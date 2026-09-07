- [RTOS](#rtos)
  - [Introduction](#introduction)
    - [Scheduling](#scheduling)
      - [Non-Priority Scheduling](#non-priority-scheduling)
      - [Priority Scheduling](#priority-scheduling)
  - [RTOS basic](#rtos-basic)
  - [FreeRTOS](#freertos)
    - [Task](#task)
      - [Task Stack Memory](#task-stack-memory)
        - [Dynamic memory](#dynamic-memory)
      - [Task Context Switch](#task-context-switch)
      - [Task Time Management](#task-time-management)
      - [Atomic Task](#atomic-task)
      - [Idle Task](#idle-task)
      - [Deferred Interrupt Processing](#deferred-interrupt-processing)
      - [total solution](#total-solution)
      - [Task Priority](#task-priority)
    - [IPC (Inter Process Communication) and Atomic operation object](#ipc-inter-process-communication-and-atomic-operation-object)
      - [Semaphore](#semaphore)
      - [Coroutine](#coroutine)
      - [Mutex (Mutual eXclusion)](#mutex-mutual-exclusion)
      - [Event Group](#event-group)
      - [Message Queue](#message-queue)
      - [Task Notify](#task-notify)
    - [Deadlock](#deadlock)
    - [Porting](#porting)
  - [memo](#memo)

# RTOS
## Introduction
`TASK`: 태스크, 작업, 한가지 동작을 하는 쓰레드.
- 각 태스크는 가상의 CPU를 각자 가지고 있는 것처럼 동작한다.
- `TASK` == Virtual CPU process.
`Multi-Tasking`: 여러 작업들을 번갈아가며 하는 것.
`Kernel`: 운영체제의 핵심 프로세스, RTOS에서는 스케쥴링, 메모리 관리, IPC가 주 목적.
`OS`: 하드웨어 시스템 자원을 제어하고 (scheduling, memory management, device driver, file system), 일반적 서비스를 제공 (device driver, file system)
*FreeRTOS는 Firmware 내에 포팅되어 Kernel API를 통해 사용한다.*

`IPC (Inter-Process Communication)`: 프로세스 간 통신을 위해 커널에서 제공하는 서비스

**Task State Diagram**
- Running: CPU가 processing 중인 상태.
- Ready: CPU 처리를 기다리는 대기열에 있는 상태.
- Blocked: 휴면 상태. (Waiting, Pend, Sleep)

**Task Control Block**
Task마다 가진 멀티태스킹 (메타) 데이터 자료 구조
실행 중의 Context 포함.
Context Switch == Save Context + Restore Context


**Kernel**
`Preemptive Kernel`
- 선점형 커널
- 우선순위에 따라 Context Switch 발생, relinqush하여 넘겨줌.
`Non-Preemptive Kernel`
- 비선점형 커널

### Scheduling
Process의 처리 순서를 관리하는 것.
`starvation`: 작업이 계속 자원을 할당받지 못해 실행을 못하는 것.

#### Non-Priority Scheduling
*FIFO*
가장 간단하고 기초적인 스케쥴링, 말 그대로 온 순서대로 처리, 프로세스에 따라 매우 긴 대기 시간이 발생하여 비효율.

*Shortest Job First (SJF)*
CPU burst 시간이 짧은 순서대로 처리하는 방식. 평균적인 `starvation`은 짧아졌지만, 짧은 프로세스가 많을 경우 긴 프로세스들은 무한히 `starvation`을 겪을 수 있다.

*Highest Response Ratio Next (HRN)*
SFJ의 단점을 보완한 방식으로, 대기시간을 우선순위에 반영한다. 우선순위 = (대기시간 + 서비스시간) / 서비스시간 으로, aging을 통해 대기시간이 길어질수록 우선순위가 점점 높아진다.

#### Priority Scheduling
무조건 우선순위에 의거해 선점하는 스케쥴링 기법.
우선순위가 높은 작업이 휴면(Sleep), Kill 되지 않으면 낮은 작업이 `starvation`을 겪을 수 있음.

*Shortest Reamining Time (SRT)*
SJF의 선점형 방식, 우선순위가 높으면 바로 선점.

*Round Robin (RR)*
모든 태스크가 동일한 시간 (Time Quantum)동안만 사용하는 스케쥴링.
`Time Quantum`: 약 1ms ~ 20 ms 로 설정, 짧으면 switching 오버헤드가 크고, 길면 대기 시간이 길어 부패.

*Multi-level Queue (MQ)*
여러 단계의 Queue를 사용하는 방식, 상위 큐가 하위 큐보다 우선이고, 각 큐에는 별개의 scheduling을 적용할 수 있다.
- 프로세스의 종류에 따라 (연산, 백그라운드, IO 등), 시간에 따라 각 큐에 분배할 수도 있다.
- 상위 큐부터 남김없이 처리할 수도 (큐 단위 SRT?), 상위 큐 많이 하위 큐 조금씩 처리할 수도 (큐 단위 RR?)있다.


`Blocing I/O`
- 태스크가 시스템 콜을 호출 했으나 즉시 가용하지 않을 경우 될때까지 suspending(Blocked) 상태로 유지되는 작업 동작.
- 중단되어 있는 동안 Task의 다른 동작도 전부 대기.
`Non-Blocing I/O`
- 태스크가 시스템 콜을 호출 했으나 즉시 가용하지 않을 경우 즉시 종료 후 넘김.
- 가용한지만 확인 후 맞다면 동작, 아니라면 그 동안 다른 동작.
- 계속 가용한지 polling.

**Tick**
- Systick timer의 periodic interrupt로 값 결정.
- Task의 delayed, timeout을 위한 시간 기준 제공.
- Task delay의 분해능 (clock resolution)이 Tick 하나.

## RTOS basic
- Hard Realtime: 엄격한 실시간성
- Scalability: 가용성, 개조/변형 가능성 <!--Extensibility: 확장성 확장에 대해서만-->
- Preemptive
- Multitasking
- Deterministic: 예측가능 시스템.
- Portability: 포팅, 이식성. 다양한 아키텍쳐에서 사용.
- Robustness: 안정성.


## FreeRTOS
- FreeRTOSconfig.h에 Kernel 설정 매크로 값.
- Hungarian case와 비슷한 prefix 명명 규칙 사용. (모든 변수, 함수, 매크로 등)
  - prv: private function, user가 쓰면 안되는 커널의 함수들.
  - pd: projdef.h, 정해진 상수 매크로들.
  - port: 아키텍쳐마다 이식된 구현부 함수.

### Task
- 유형
   1. 무한루프 함수
   2. 일회성 함수 (종료 전 Task를 스스로 삭제)
- 함수 param은 무조건 한개
- return하지 않으므로 void
- Idle Task는 running할 Task가 없을 때 작동하는 작업. 스케쥴러 실행 시 자동 생성되고, 우선순위가 가장 낮은 0, 제거된 태스크를 정리하는 작업도 함. vApplicationIdleHook()을 통해 원하는 동작을 넣을 수 있음.

*API*
BaseType_t xTaskCreate(함수포인터, char[] 태스크이름, 스택 깊이, 인자, 우선순위, 핸들러) // 우선순위는 값이 높을수록 높음.
TaskHadnle_t xTaskCreateStatic( TaskFunction_t,  pcName,  ulStackDepth,  pvParameters,  uxPriority,  puxStackBuffer, pxTaskBuffer);

#### Task Stack Memory
- Task의 스택 메모리는 정적 및 동적 할당이 가능.
- #define configSUPPORT_DYNAMIC_ALLOCATION
- Task 스택은 Stack, Heap을 쓰는것이 아닌 BSS 영역을 할당해서 사용한다. 동적 할당 또한 이 영역을 런타임에 할당, 사용, 반환.
- 동적 메모리는 Memory Fragmentation을 유발시키므로 프로그램 끝까지 유지되는 경우에만 사용할 것.
- 스택의 크기 결정: 호출 횟수 (Context Saved), 지역 변수 크기에 의해 사용량 예측, 결정

##### Dynamic memory
기존의 표준 라이브러리 동적 메모리 사용의 문제점: 알고리즘의 복잡성으로 예측 어렵고, 메모리 단편화 발생
=> 전용의 동적 메모리 방법 제공함. heap_2, heap_4 추천.
configTOTAL_HEAP_SIZE에 의해 heap 블록 크기 결정.
1. heap_1.c: 메모리 할당만 가능, 메모리 단편화 가능성 원천배제.
2. heap_2.c: 할당 및 해제 가능, 해제된 빈 블럭은 다시 사용될 수 있다. heap_4와 달리 인접 자유 블록을 하나로 결합하지 않음.
3. heap_3.c: 일시적으로 FreeRTOS를 멈추고 stdandard 라이브러리의 malloc()과 free()를 thread-safe로 만든다. 실제 Heap 메모리 사용.
4. heap_4.c: 인접 자유 블록을 하나로 결합하여 메모리 파편화를 예방.

**stack overflow check**
- if stack overflow: extern void vApplicationStackOverflowHook( TaskHandle_t *pxTask, signed char *pcTaskName ); 호출
- #define configCHECK_FOR_STACK_OVERFLOW 1
  - SP가 영역을 넘었는지 확인, context change가 없을 때는 탐지 불가.
- #define configCHECK_FOR_STACK_OVERFLOW 2
  - RTOS Task 시작 전 메모리 영역에 0xA5A5A5A5를 채워넣음, 영역 끝의 20byte에서 A5가 훼손돼 있다면 오버플로우로 판정
  - 속도는 느리지만 정확.
- stack overflow는 해당 Task가 아닌 예측 불가능한 영역을 침범하여 디버깅이 곤란하기 때문에 예방이 중요.

#### Task Context Switch
PendSV_Handler에 context switch의 instruction이 들어 있음.
portYIELD() 안에서, NVIC의 인터럽트 컨트롤 레지스터에서 PendSV 비트를 올려서 문맥전환 exception을 호출,
인터럽트 상에서 문맥전환이 이루어짐.
Systick_Handler 이후에만 전환하는 것과, 하드웨어 인터럽트에도 전환하는 경우 더 Hard Real-time에 가깝다.

#### Task Time Management
- vTaskDelay (TickType_t 기다릴시간);
- vTaskDelayUntill (TickType_t* p이전시간, TickType_t 기다릴시간);
  - 실행할 때마다 지연이 발생하는 Delay와 다르게, 절대 시간(Tick)을 기준으로 설정하고 이를 반복하기에 지연이 발생하더라도 정확도를 유지함.  

#### Atomic Task
- `Concurrent Entrancy (동시성 문제)`: 전환이 잦은 OS등에서 여러 쓰레드에서 하나의 공용 메모리에 접근을 시도할 시 발생하는 문제. 
- `Reentrancy`: 실행 도중 중단되었다가 다른 흐름에서 다시 호출해도 문제(데이터 오염, fault)가 없는 상태.
  - 오직 지역 변수나 해당 쓰레드에서의 변수(지역 변수)만을 사용해야 한다.
  - else: unsafe function.

*soulutions*
- 전역, 정적 변수 제거
- schedule 중단: 우선순위 태스크가 starvation.
- 커널에서 제공하는 원자적 연산 기능 (IPC: MUTEX, SEMAPHORE): 정확도 유지, 인터럽트 중단 및 context swtch 둘다 하므로 심한 성능 손실.
- 인터럽트 비활성화: 모든 인터럽트가 비활성화 되어 context switching도 멈추지만, tick도 멈추고, 즉각적으로 처리하지 못함 == 정확도/성능 손실
  - *Critical section*
    - taskENTER_CRITICAL(); taskEXIT_CRITICAL();
    - 인터럽트 비활성화 상태에서 특정 어플리케이션 함수 (vTaskDelay 등)을 쓰면 멈출 수 있다. (PSR의 인터럽트 Enable 비트를 context switch 하냐 안하냐에 따라 결정)

#### Idle Task
Idle Task는 running할 Task가 없을 때 작동하는 작업. 스케쥴러 실행 시 자동 생성되고, 우선순위가 가장 낮은 0, 제거된 태스크를 정리하는 작업도 함. vApplicationIdleHook()을 통해 원하는 동작을 넣을 수 있음.
#define configUSE_IDLE_HOOK 1

#### Deferred Interrupt Processing
- `Deferred Interrupt`: 실행 시간이 소요되는 ISR의 실행을 지연하여 실행 방법.
- Task는 무조건 ISR보다는 우선순위가 낮기 때문에 필요.
> -> 최대한 ISR의 실행 시간을 짧게 유지하는 게 중요.

**ISR에 구현하는 대신, 이를 담당하는 쓰레드에 위탁함**  <!--RTOS이기에 가능한 간단하고 탁월한 방식-->
- HIGHEST PRI Task

#### total solution
- 전역 변수 선언 및 사용을 줄인다
- 시간 소요가 많은 ISR은 IPC를 통해 태스크에게 위탁한다.
- 간단한 임계영역 보호는 무거운 세마포어 보다는 taskENTER_CRITICAL을 활용한다.
- 필요에 따라 함수 인라이닝 (호출 오버헤드 감소.)
- 구현 이후 프로세서 클럭 스피드를 조절하여 최적화한다. => {IDLE Task의 점유율을 확인한다.}
- Tick 타이밍이 정확한지 파악.

#### Task Priority
UI 기능의 반응성이 UX 품질에 직결되는 요소이기 때문
태스크의 단위 기능으로 경중을 논할 수 없다. -> I2C Bit Banding의 경우 정확한 타이밍이 필요하지만 클락 자체는 낮아도 됨.
우선순위 배정은 응답시간 (마감기한)의 준수성을 기준으로 결정됨. (실제 성능에 따라 결정)

**Priority Inversion**
높은 우선순위의 Task가 낮은 우선순위 작업이 끝날 때까지 기다리는 상황, 문제는 중간 우선순위 작업이 끼어들면 높은 우선순위 작업이 기다리는 시간이 더 길어져버린다.

**Priority Inheritance**
높은 우선순위가 Blocked된 동안, 진행하는 원래 낮은 우선순위의 작업의 우선순위를 기다리는 작업보다 더 높게 한다.
이로써 중간 우선순위가 방해하지 않게 된다.


### IPC (Inter Process Communication) and Atomic operation object
1. semaphore
2. mutex
3. event group
4. Queue

#### Semaphore
커널에서 직접 보호하고 있는 공용 변수.
0부터 양의 정수가 들어감.
이진 세마포어는 뮤텍스와 비슷하게 사용 가능. (뮤텍스는 소유자만이 해제 가능, 세마포어는 어떤 Task든 발행이 가능.)

*세마포어는 대여방식의 입장권이라고 생각하면 쉬움.*
> 즉 일정 숫자만큼은 각자 하나씩 할당받고 입장하고, 초과인원은 입장 대기.
> 하나씩 용무를 마치고 입장권을 반납하면 초과 대기열에서 맨 앞만 하나가 입장.

**Before a semaphore can be used, it must be created.**
세마포어를 사용하는 다른 태스크가 있다면 해당 태스크가 진행(Create 후 scheduler에 진입)되기 전에 미리 생성해놔야함.

접근 방법 3가지
- 초기화
- P연산(Take, Acquire)
- V연산(Give, Release)

생산자 소비자 패턴: 상호 배제적 기능보단 IPC의 기능으로 사용.
- 생산자: Giver
- 소비자: Taker

*FreeRTOS의 Semaphore는 실제로는 QueueSemaphore다. Semaphore관련 서비스 함수들은 전부 Queue에 대한 매크로로 이루어져 있다.*

#### Coroutine
OS 수준의 서비스가 아니라, 어플리캐이션 수준에서 함수를 나눠가며 실행하는 것.
Stack 대신 Heap 영역에 context들을 백업 해놓고 (진행 상태 포함), 같은 함수를 상태에 따라 이어서 진행하는 방법. 

#### Mutex (Mutual eXclusion)
*FreeRTOS의 뮤텍스는 실제로는 우선순위 상속을 구현한 이진 세마포어를 구현한 Queue이다.*
우선순위 상속이 구현되어 있어 단순 동기화에 좋은 세마포어보다 상호 배타적 (Mutual Exclusion) 구현에 좋다.
lock과 unlock도 세마포어 Take, Give로 한다.

Mutex on SMP (Symmetric Multiprocessor System): 
멀티 프로세서에서는 mutex 변수조차 보호할 수 없으므로 (코어가 여러개라서) 더 복잡하게 구현해야 한다.
```asm
  STR r0, =mutex
lock_mutex:
  LDREX r1, [r0]  @ LDREX (Load EXclusive), 배타적으로 읽어오는 명령어. 버스에 잠금을 걸어 독점한 상태로 LDR.
  CMP r1, 1       @ compare mutex value (r1) is 1?
  WFEEQ           @ WFEEQ (Wait for Event) if equal, CPU 자체를 Sleep모드로 전환한다.
  BEQ lock_mutex  @ BEQ (Branch) if equal, 다른 뮤텍스 사용이 끝나고 이벤트로 CPU Sleep이 해제되었을때 뮤텍스 다시 확인
                  @ Critical Section 동작 이어서 시행
```

#### Event Group
세마포어(대여/반납식 입장권)가 갯수를 통해 동작을 제어했다면, Event Flag는 보고 받은 상황 코드(bit mask)를 통해 제어.
기다리는 쪽의 xWaitForAllBits가 참이라면 각 플래그 if(value==flag), 거짓이면 플래그 if(flag)로 이벤트 발생을 감지.

> 32 bit 변수의 Task간 공유 및 블로킹 구현을 담당하는 IPC object.

#### Message Queue
Kernel level에서 관리하는 Circular Buffer로 구현되어 있는 Queue를 사용한다.
FIFO Queue로 사용할 수 있고, LIFO Stack 방식으로도 사용할 수 있는 API가 제공된다.
Push도 또한 Queue의 맨 앞에 넣을 수도 있다.
Queue에 담을 수 있는 Item은 사용자가 정의한 데이터 구조체로 설정한다.

#### Task Notify
특정 Task가 가지고 있는 Event flag를 조작하는 방법.
TCB에 포함되어 있는 4 byte 변수를 직접 조작하며 Semaphore, Event Group 처럼 중간 오브젝트를 거치는 것에 비해 메모리 차지가 없고 속도는 약 45% 이상 빠르다고 한다.

**4 byte 변수 하나이므로, 구현에 따라 아래 IPC들을 대체할 수 있다.**
1. Binary Semaphore
2. Counting Semaphore
3. Event Group
4. 1 size Queue

### Deadlock
`Deadlock (교착상태)`: 여러 Task가 서로가 가진 자원 (Mutex)을 기다리며 멈춰 무한정 기다리는 상황.
아래 네 가지 조건이 동시에 만족 시 발생
1. Mutex (상호 배제)
2. Hold and Wait (보유 및 대기): 자원을 가진 채로 다른 자원을 기다림.
3. No Preemptive (비선점형): 남의 자원 선점, 강탈 불가한 경우
4. Circular Wait (순환 대기): 서로가 서로의 자원을 기다림.

*해결책*
1. Prevention (예방): 위 조건이 동시만족 안하게 하기
   - (하나의 뮤텍스로) 모든 자원을 선점 후 진행.
   - 진행 순서대로 필요한 자원을 획득. (Hold and Wait 방지)
2. Avoidance (회피): Kernel이 시스템이 안전할 때만 줌.
3. Detection & Recovery (탐지 및 복구): Kernel이 찾아서 제거.

### Porting
이미 실행 가능한 프로그램이 기존 설계와 다른 하드웨어, 소프트웨어 프레임워크 플랫폼으로 이식하는 과정
`Cross Platform`: 하나의 소스 코드로 여러 플랫폼에서 사용할 수 있는 설계.

---

## memo
Queue: 정해진 크기의 IPC
StreamBuffer: 1대1 IPC, UART 등 연속된 byte stream에 사용.
MessageBuffer: StreamBuffer의 Wrapper, 보내는 데이터의 길이를 담은 HEADER를 붙여서 보냄. 가변 길이 패킷 데이터를 전달하는데 사용.

TaskHandle_t xHandle1;
typedef void TaskFunction_t(void*);

xTaskCreate( (TaskFunction_t)Task1, "Task1", 256, (void*)Param, TASK_1_PRIO, &xHandle1);

vTaskSuspend(xHandle1);
vTaskPrioritySet(TaskHandle_t, TASK_3_PRIO);
vTaskResume(xHandle1);

vTaskDelay (pdMS_TO_TICKS (1000));
vTaskDelayUntill (TickType_t* 이전시간, TickType_t 기다릴시간);
vTaskDelete (xHandleMain);	// vTaskDelete (NULL); 일회성 작업 종료 시 필요 else 없으면 undefined behaivor.

xEventGroupCreate(void)
xEventGroupSetBits(EventGroupHandle_t, bits)
xEventGroupWaitBits(EventGroupHandle_t, bitsForWait, bool ClearOnExit, bool xWaitForAllBits, timeout )

xQueueCreate(QueueLength, sizeofItem)
xQueueMessagesWaiting(QueueHandle_t)
xQueueReset(QueueHandle_t)