```mermaid
flowchart TD
  A["timer_init()"] -->|PIT 설정 및 핸들러 등록| B["timer_interrupt()"]
  B -->|매 틱마다| C["ticks++"]
  C -->|thread_tick() 호출| D["thread_tick()"]

  F["timer_calibrate()"] --> G["too_many_loops()"]
  G -->|루프가 너무 짧으면| H["loops <<= 1"]
  G -->|아니면 비트 정밀도 보정| H
  G -->|busy_wait() 호출| I["busy_wait()"]

  J["timer_ticks()"] -->|인터럽트 비활성화 후 읽기| C
  J -->|값 반환| K["t 반환"]

  L["timer_elapsed(then)"] -->|timer_ticks() 호출| J
  L -->|경과 계산| M["t – then"]

  N["timer_sleep(ticks)"] -->|start = timer_ticks()| J
  N -->|elapsed < ticks 동안| L
  N -->|루프 안에서| O["thread_yield()"]

  %% 색상 변경
  style A fill:#2f2f3f,stroke:#555,stroke-width:2px,color:#eef
  style B fill:#3f2f4f,stroke:#555,stroke-width:2px,color:#eef
  style C fill:#2f3f3f,stroke:#555,stroke-width:2px,color:#eef
  style D fill:#2f2f3f,stroke:#555,stroke-width:2px,color:#eef
  style F fill:#3f3f2f,stroke:#555,stroke-width:2px,color:#eef
  style G fill:#4f3f2f,stroke:#555,stroke-width:2px,color:#eef
  style H fill:#3f2f3f,stroke:#555,stroke-width:2px,color:#eef
  style I fill:#2f3f4f,stroke:#555,stroke-width:2px,color:#eef
  style J fill:#3f2f3f,stroke:#555,stroke-width:2px,color:#eef
  style K fill:#2f2f4f,stroke:#555,stroke-width:2px,color:#eef
  style L fill:#3f2f2f,stroke:#555,stroke-width:2px,color:#eef
  style M fill:#2f4f2f,stroke:#555,stroke-width:2px,color:#eef
  style N fill:#4f2f2f,stroke:#555,stroke-width:2px,color:#eef
  style O fill:#2f2f2f,stroke:#555,stroke-width:2px,color:#eef
