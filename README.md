flowchart TD
    A[timer_init()] -->|configures PIT &\nregisters handler| B[timer_interrupt()]
    B -->|on each tick| C[ticks++]
    C -->|calls| D[thread_tick()]

    F[timer_calibrate()] --> G[too_many_loops()]
    G -->|if too few loops| H[loops <<= 1]
    G -->|else|\nrefine bits using| H
    G -->|calls| I[busy_wait()]

    J[timer_ticks()] -->|disable intr|\nread ticks| C
    J -->|return| K[t]

    L[timer_elapsed(then)] -->|calls| J
    L -->|compute| M[t - then]

    N[timer_sleep(ticks)] -->|start = timer_ticks()| J
    N -->|while elapsed < ticks| L
    N -->|inside loop| O[thread_yield()]

    %% style separators
    style A fill:#f9f,stroke:#333,stroke-width:1px
    style F fill:#f9f,stroke:#333,stroke-width:1px
    style J fill:#f9f,stroke:#333,stroke-width:1px
    style L fill:#f9f,stroke:#333,stroke-width:1px
    style N fill:#f9f,stroke:#333,stroke-width:1px
    style B fill:#ff9,stroke:#333,stroke-width:1px
