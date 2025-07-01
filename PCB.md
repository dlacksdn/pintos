```mermaid
flowchart TD
  %% Initialization
  A[thread_init()] -->|calls| B[init_thread()]
  B -->|gets tid| C[allocate_tid()]
  C --> A

  %% Start scheduling
  A -->|from main| D[thread_start()]
  D -->|create idle| E[thread_create("idle", PRI_MIN, idle, aux)]
  E -->|calls| F[init_thread()]
  F --> G[allocate_tid()]
  G --> H[alloc_frame()]
  H --> I[alloc_frame()]
  I --> J[alloc_frame()]
  J --> K[thread_unblock()]
  K --> L[ready_list ← t]
  D --> M[intr_enable()]
  D --> N[sema_down(&idle_started)]

  %% Timer tick / preemption
  O[timer_interrupt()] -->|each tick| P[thread_tick()]
  P --> Q{ticks ≥ TIME_SLICE?}
  Q -->|yes| R[intr_yield_on_return()]
  R --> S[thread_yield()]
  Q -->|no| T[return]

  %% Blocking & Unblocking
  U[thread_block()] --> V[status ← BLOCKED]
  V --> W[schedule()]
  X[thread_unblock(t)] --> Y[status ← READY]
  Y --> L

  %% Yield
  S --> AA[intr_disable()]
  AA --> AB{not idle?}
  AB -->|yes| AC[ready_list ← cur]
  AC --> AD[status ← READY]
  AD --> W
  AB -->|no| W

  %% Scheduler core
  W --> AE[next_thread_to_run()]
  AE --> AF[switch_threads(cur,next)]
  AF --> AG[thread_schedule_tail()]
  AG --> AH[cleanup & reset ticks]

  %% Helpers
  AI[thread_current()] --> AJ[running_thread()]
  AJ --> AK[is_thread()]
  AF --> AJ

  %% Exit
  AL[thread_exit()] --> AM[intr_disable()]
  AM --> AN[list_remove(&allelem)]
  AN --> AO[status ← DYING]
  AO --> W

  %% Kernel thread
  AP[kernel_thread(func,aux)] --> AQ[intr_enable()]
  AQ --> AR[func(aux)]
  AR --> AL

  %% Idle loop
  AT[idle(aux)] --> AU[idle_thread = cur]
  AU --> AV[sema_up(&idle_started)]
  AV --> AW[intr_disable()]
  AW --> AX[thread_block()]
  AX --> AY[sti; hlt]
  AY --> AW

  %% Styles
  style A fill:#9f9,stroke:#333,stroke-width:1px
  style D fill:#9f9,stroke:#333,stroke-width:1px
  style P fill:#9f9,stroke:#333,stroke-width:1px
  style W fill:#9f9,stroke:#333,stroke-width:1px
  style AF fill:#9f9,stroke:#333,stroke-width:1px
