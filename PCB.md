flowchart TD
  %% Initialization
  A[thread_init()] -->|calls| B[init_thread(t, \"main\", PRI_DEFAULT)]
  B -->|assign tid| C[allocate_tid()]
  C -->|return tid| A

  %% Start scheduling
  A -->|later from main| D[thread_start()]
  D -->|create idle thread| E[thread_create(\"idle\", PRI_MIN, idle, &idle_started)]
  E -->|calls| F[init_thread(t, \"idle\", PRI_MIN)]
  F --> G[allocate_tid()]
  G --> H[alloc_frame(t, sizeof kernel_thread_frame)]
  H --> I[alloc_frame(t, sizeof switch_entry_frame)]
  I --> J[alloc_frame(t, sizeof switch_threads_frame)]
  J --> K[thread_unblock(t)]
  K -->|push to ready_list| L[list_push_back(&ready_list)]
  D -->|enable interrupts| M[intr_enable()]
  D -->|wait for idle| N[sema_down(&idle_started)]

  %% Timer tick and preemption
  O[timer_interrupt()] -->|on each tick| P[thread_tick()]
  P -->|update idle/kernel/user ticks| Q[stats update]
  P -->|TIME_SLICE reached?| R{thread_ticks ≥ TIME_SLICE?}
  R -->|yes| S[intr_yield_on_return()]
  S --> T[thread_yield()]
  R -->|no| U[return]

  %% Blocking and unblocking
  V[thread_block()] -->|set status BLOCKED| W[thread_current()->status=THREAD_BLOCKED]
  W --> X[schedule()]
  Y[thread_unblock(t)] -->|set status READY| Z[t->status=THREAD_READY]
  Z --> L

  %% Yielding
  T -->|disable interrupts| AA[intr_disable()]
  AA -->|if not idle| AB[list_push_back(&ready_list)]
  AB --> AC[set status READY]
  AC --> X

  %% Scheduling core
  X -->|find next| AD[next_thread_to_run()]
  AD -->|returns| AE[thread *next]
  AE -->|if next != cur| AF[switch_threads(cur, next)]
  AF --> AG[thread_schedule_tail(prev)]
  AG -->|reset ticks & free dying| AH[cleanup]

  %% Current thread helpers
  AI[thread_current()] -->|calls| AJ[running_thread()]
  AJ -->|checks| AK[is_thread(t)]
  AK --> AJ

  %% Thread exit
  AL[thread_exit()] -->|disable interrupts| AM[intr_disable()]
  AM -->|remove from all_list| AN[list_remove(&allelem)]
  AN -->|set status DYING| AO[status=THREAD_DYING]
  AO --> X

  %% Kernel thread and idle routines
  AP[kernel_thread(function, aux)] -->|enable interrupts| AQ[intr_enable()]
  AQ -->|call user function| AR[function(aux)]
  AR --> AS[thread_exit()]

  AT[idle(aux)] -->|set idle_thread| AU[idle_thread = thread_current()]
  AU -->|sema_up| AV[sema_up(&idle_started)]
  AV --> loopIdle
  subgraph loopIdle [ ]
    direction TB
    AW[intr_disable()] --> AX[thread_block()]
    AX --> AY[sti; hlt]
    AY --> AW
  end

  style A fill:#9f9,stroke:#333,stroke-width:1px
  style D fill:#9f9,stroke:#333,stroke-width:1px
  style P fill:#9f9,stroke:#333,stroke-width:1px
  style X fill:#9f9,stroke:#333,stroke-width:1px
  style AF fill:#9f9,stroke:#333,stroke-width:1px
