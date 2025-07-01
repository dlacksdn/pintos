```mermaid
flowchart TD
  A["timer_init()"] -->|"PIT 설정 및 핸들러 등록"| B["timer_interrupt()"]
  B -->|"매 틱마다"| C["ticks++"]
  C -->|"thread_tick() 호출"| D["thread_tick()"]

  F["timer_calibrate()"] --> G["too_many_loops()"]
  G -->|"루프가 너무 짧으면"| H["loops <<= 1"]
  G -->|"아니면 비트 정밀도 보정"| H
  G -->|"busy_wait() 호출"| I["busy_wait()"]

  J["timer_ticks()"] -->|"값 반환"| K["t 반환"] 

  L["timer_elapsed(then)"] -->|"timer_ticks() 호출"| J
  L -->|"경과 계산"| M["t – then"]

  N["timer_sleep(ticks)"] -->|"start = timer_ticks()"| J
  N -->|"elapsed < ticks 동안"| L
  N -->|"루프 안에서"| O["thread_yield()"]

  style A fill:#9f9,stroke:#333,stroke-width:1px
  style F fill:#9f9,stroke:#333,stroke-width:1px
  style J fill:#9f9,stroke:#333,stroke-width:1px
  style L fill:#9f9,stroke:#333,stroke-width:1px
  style N fill:#9f9,stroke:#333,stroke-width:1px
  style B fill:#5f9,stroke:#333,stroke-width:1px
