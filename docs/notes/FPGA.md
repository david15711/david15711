# FPGA (Field Programmable Gate Array)

- [FPGA (Field Programmable Gate Array)](#fpga-field-programmable-gate-array)
  - [Verilog and FPGA SDE](#verilog-and-fpga-sde)
    - [Verilog HDL](#verilog-hdl)
      - [Syntax](#syntax)
      - [always if-else, case Mux](#always-if-else-case-mux)
    - [Vivado](#vivado)
      - [build](#build)
      - [Simulation과 Synthesis](#simulation과-synthesis)
    - [주요 논리회로](#주요-논리회로)
      - [조합회로](#조합회로)
      - [순차회로](#순차회로)
        - [latch](#latch)
        - [Flip-Flop:](#flip-flop)

## Verilog and FPGA SDE

### Verilog HDL

 디지털 회로의 구조와 동작을 기술하기 위한 HDL (Hardware Description Language).
논리 회로에 대한 기술 언어이므로 명령어를 실행하는 것이 아닌 정적인 설계 언어.


#### Syntax

- `module`: The module is the basic unit of logic description
  - wire or reg declarations
  - behavioral, data flow, gate-level constructs
  - lower-level module instantiations
- `input` : 모듈 내에서 입력 정의, 기본 wire 정의와 같음
- `output`: 모듈 내에서 출력 정의, 기본 wire 정의와 같음
- `assign`: data flow 방식의 구축
- `xor()`, `and()` 등의 논리 연산: gate-level 구축
- `wire`: 모듈간의 입출력 연결
- `reg`: 변수 역할을 하는 공간, 실제 하드웨어 구현은 전부 다를 수 있음.
- `#1 `: timescale 단위마다 동작, behavioral 문법, 소프트웨어적 시뮬레이션으로 동작, 
- `timescale ns / ps`: 이 경우 ns마다 동작, ps 단위로 시뮬레이션
- [3:0]: bus 선언, 같은 이름의 input, output을 배열형태로 구분
- `{양 {원본}}`: 복사, 양만큼 똑같이 만들어 나열한다.
- `{하나,둘}`: 두개를 묶는다.
- `always`: behavioral한 명령문.
  - `@(A, B, Cond)`, `@ *`: A, B, Cond가 변하면 작동, 모든 변화에 작동.
- `begin`, `end`: 코드 블록 {}의 역할.
- `if-else`: 우리가 아는 if-else 문, 
- `case`, `endcase`: 우리가 아는 switch-case 문, 그 어떤 경우도 아닌 것 (default)에 대해 정의되지 않으면 `latch inference`



#### always if-else, case Mux

그 어떤 경우도 아닌 것에 대해 정의되지 않으면 `latch inference` 발생
*latch inferece*: 특정 입력 조건에서 출력이 정의되지 않는 경우, 명시적으로 값을 유지해야 한다고 해석하여 의도하지 않은 latch가 배치된다. 이로 인해 타이밍 분석 실패, 레이스 컨디션, 예측 불가능한 회로 Glitch가 유발된다.
`default assignment`가 필요함.

**if-else**
```verilog
// default assignment: constant value
always @ *
  if (sel == 2'b00) y = a;
  else if (sel == 2'b01) y = b;
  else if (sel == 2'b10) y = c;
  else y = 1'bx;      // 값이 뭐가 나오는 상관 없는 경우 상수 x, z 등 사용.
```

```verilog
// Alternate default approach: already substituted value
always @ *
begin
y = 1'bx;
  case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    default: y = d;
  endcase
end
```

```verilog
// Alternate default approach
always @ *
begin
  en1 = 0;
  en2 = 0;
  en2 = 0;
  en2 = 0;
  if      (sel == 2'b00) en1 = a;
  else if (sel == 2'b01) en2 = b;
  else if (sel == 2'b10) en3 = c;
  else if (sel == 2'b11) en4 = c;
end
```
default assign으로 해도 위의 각 경우에서 (en1 대입하는 경우) en2, en3, en4에 대해 정의 되지 않으면 latch inference.
Alternate default assign으로 대입하는 게 간편하고 가독성이 좋고 선명함.



### Vivado

*Xilinx Vivado*
Xilinx 사에서 제공하는 PL 영역 설계 프로그램.

#### build

- `합성 (Synthesis)`
  - 개념: RTL(HDL) 코드를 FPGA 내부의 마이크로-아키텍처, 물리적 최소 단위 부품(LUT, Flip-Flop, MUX, Block RAM, DSP48E1 등)의 기술망(Netlist)으로 변환하는 단계입니다.
- `구현 (Implementation)`
  - 개념: 합성된 기술망(Netlist)을 Zynq-7010 FPGA 내부의 실제 물리적 위치에 배치하고(Placement), 금속 배선선으로 전기적으로 연결(Routing)하는 과정입니다.
    - Opt Design: 불필요한 로직을 제거하고 최적화합니다.
    - Place Design: 합성된 LUT와 FF들을 FPGA 슬라이스(Slice)의 몇 번째 CLB 좌표에 올려놓을지 물리적 위치를 정합니다.
    - Route Design: 결정된 CLB와 I/O 핀, AXI 버스 사이를 FPGA 내부 스위치 매트릭스 배선을 이용해 구체적으로 이어줍니다.
- `비트스트림 생성 (Generate Bitstream)`
  - 개념: 구현이 끝난 물리적 정보를 FPGA 내부 SRAM 및 프로그래머블 스위치에 다운로드할 수 있는 바이너리 파일(.bit)로 생성하는 최종 단계입니다.

*RTL*: Register-Transfer Level, 레지스터간 데이터 이동과 연산을 모델링하는 정도의 추상화된 정보

#### Simulation과 Synthesis

같은 Verilog 파일 내부에 작성하지만 실제 하드웨어에서 동작하는 내용과 시뮬레이션에서 동작하는 내용이 혼재함. 상태를 정의하는 것이 아닌 실행이 있다면 시뮬레이션.

### 주요 논리회로
#### 조합회로

1. 덧셈기
   1. 반가산기
   2. 전가산기
2. 뺄셈기
  1. 비교기
  2. ALU
3. 디코더
4. 선택기, multiplexer, mux

#### 순차회로

##### latch

![SR latch](image/SRLatch.png)
![D latch](image/DLatch.png)

1. SR latch
   - NOR
   - NAND
    - (0, 1), (1, 0)을 줄 경우 저장된 신호 반전
    - (1, 1)을 줄 경우 신호 유지
    - !S와 !R에 (0, 0)을 줄 경우 정의되지 않은 동작
2. D latch
   - SR latch의 정의되지 않은 입력을 제거한 latch, NAND 두개와 인버터를 추가 사용.
   - 저장할 신호 1 또는 0을 주는 D
   - D 저장을 활성화 하는 En (클럭으로 활성화)

##### Flip-Flop:

1. D Flip-Flop
2. T Flip-Flop: Deprecated

**D Flip-Flop**

D latch의 경우 En이 High level인 동안의 모든 D 입력이 지속적으로 적용.
플립플랍의 경우 트리거를 레벨이 아닌 엣지로 작동하도록 함.




