# FPGA (Field Programmable Gate Array)

- [FPGA (Field Programmable Gate Array)](#fpga-field-programmable-gate-array)
  - [Verilog and FPGA SDE](#verilog-and-fpga-sde)
    - [Verilog HDL](#verilog-hdl)
      - [Syntax](#syntax)
      - [build](#build)
      - [Simulation과 Synthesis](#simulation과-synthesis)
    - [주요 논리회로](#주요-논리회로)
      - [조합회로](#조합회로)
      - [순차회로](#순차회로)

## Verilog and FPGA SDE

### Verilog HDL

 디지털 회로의 구조와 동작을 기술하기 위한 HDL (Hardware Description Language).
논리 회로에 대한 기술 언어이므로 명령어를 실행하는 것이 아닌 정적인 설계 언어.

*Xilinx Vivado*
Xilinx 사에서 제공하는 PL 영역 설계 프로그램.

#### Syntax

- `module`: The module is the basic unit of logic description
  - wire or reg declarations
  - behavioral, data flow, gate-level constructs
  - lower-level module instantiations
- `input` :
- `output`:
- `assign`: data flow 방식의 구축
- `xor()`, `and()` 등의 논리 연산: gate-level 구축
- `wire`: 모듈간의 입출력 연결
- `reg`: 변수 역할을 하는 공간, 실제 하드웨어 구현은 전부 다를 수 있음.
- `always #1 `: timescale 단위마다 동작, behavioral 문법, 소프트웨어적 시뮬레이션으로 동작, 
- `timescale ns / ps`: 이 경우 ns마다 동작, ps 단위로 시뮬레이션
- [3:0]: bus 선언, 같은 이름의 input, output을 배열형태로 구분
- `{양 {원본}}`: 복사, 양만큼 똑같이 만들어 나열한다.
- `{하나,둘}`: 두개를 묶는다.

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


#### Simulation과 Synthesis

같은 Verilog 파일 내부에 작성하지만 실제 하드웨어에서 동작하는 내용과 시뮬레이션에서 동작하는 내용이 혼재함. 상태를 정의하는 것이 아닌 실행이 있다면 시뮬레이션.


### 주요 논리회로
#### 조합회로

1. 덧셈기
   1. 반가산기
   2. 전가산기
2. 뺄셈기
3. 비교기
   1. ALU
4. 디코더
5. 선택기, multiplexer, mux

#### 순차회로

Double-Inversion: 원래의 신호를 유지하며 지연이 적용되어 buffer와 동일한 역할을 한다.

1. latch
2. Flip-Flop