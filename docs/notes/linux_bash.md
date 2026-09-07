# Bash Shell

- [Bash Shell](#bash-shell)
  - [주요 커맨드 (Major Commands) 나열](#주요-커맨드-major-commands-나열)
    - [기본 파일 및 디렉토리 작업](#기본-파일-및-디렉토리-작업)
    - [권한 및 소유권 관리](#권한-및-소유권-관리)
    - [텍스트 처리 (Processing)](#텍스트-처리-processing)
    - [시스템 모니터링 및 작업 제어](#시스템-모니터링-및-작업-제어)
    - [네트워킹 (Networking)](#네트워킹-networking)
  - [Bash Syntax and Meta Characters](#bash-syntax-and-meta-characters)
    - [Builtin Commands](#builtin-commands)
    - [Reserved Keywords](#reserved-keywords)
- [Bash Programming](#bash-programming)
  - [Scripting](#scripting)
  - [Control Operators  \& Redirection and Pipeline](#control-operators---redirection-and-pipeline)
    - [따옴표 (Quoting) 처리 방식](#따옴표-quoting-처리-방식)
  - [Parameter](#parameter)
    - [Variable](#variable)
    - [array](#array)
    - [Special Parameters](#special-parameters)
  - [Expansion](#expansion)
    - [Parameter Expansion](#parameter-expansion)
    - [Patterns](#patterns)
      - [glob](#glob)
      - [Regex (ReGular Expression patterns)](#regex-regular-expression-patterns)
        - [grep command](#grep-command)
        - [sed](#sed)
    - [Brace Expansion (중괄호 확장)](#brace-expansion-중괄호-확장)
    - [command substitution (명령 대치)](#command-substitution-명령-대치)
    - [Arithmetic Expansion](#arithmetic-expansion)
    - [Exit Status](#exit-status)
    - [Conditional Blocks](#conditional-blocks)
  - [Redirection](#redirection)
    - [Pipes](#pipes)
    - [Process Substitution (프로세스 대치)](#process-substitution-프로세스-대치)
    - [Subshell (서브쉘)](#subshell-서브쉘)
    - [Command Grouping (명령어 그룹화)](#command-grouping-명령어-그룹화)
    - [Arithmetic Evaluation (산술 평가)](#arithmetic-evaluation-산술-평가)
  - [Functions and Aliases](#functions-and-aliases)
    - [Function](#function)
  - [Job Control](#job-control)
    - [Debug Script](#debug-script)
    - [cron](#cron)
- [memo](#memo)
  - [괄호 구문 (Brackets \& Parentheses) 정립](#괄호-구문-brackets--parentheses-정립)
    - [1. 소괄호 `()`](#1-소괄호-)
    - [2. 중괄호 `{}`](#2-중괄호-)
    - [3. 대괄호 `[]`](#3-대괄호-)

---

## 주요 커맨드 (Major Commands) 나열
### 기본 파일 및 디렉토리 작업
- **`ls`** (List): 파일 및 디렉토리 목록 표시
  - `-a`: 숨김 파일(`.`으로 시작) 포함 전체 표시
  - `-l`: 상세 정보(권한, 링크 수, 소유자, 그룹, 크기, 수정일시, 파일명) 표시
  - `-h`: 사람이 읽기 쉬운 단위(K, M, G)로 크기 표시
  - `-i`: 파일의 inode 번호 표시
  - `-t`: 수정 시간순 정렬
  - `-r`: 역순 정렬
  - `-S`: 파일 크기순 정렬


- **`cd`** (Change Directory): 디렉토리 이동
  - `cd ~` 또는 `cd`: 홈 디렉토리로 이동
  - `cd ..`: 상위 디렉토리로 이동
  - `cd -`: 직전 작업 디렉토리로 이동 (내장 변수 `$OLDPWD` 참조)

- **`pwd`** (Print Working Directory): 현재 작업 디렉토리 경로 출력
  - `-P`: 심볼릭 링크를 추적하여 실제 물리 경로 표시

- **`mkdir`** (Make Directory): 디렉토리 생성
  - `-p`: 필요한 경우 상위 디렉토리까지 자동 생성

- **`cp`** (Copy): 파일/디렉토리 복사
  - `-r`: 디렉토리 및 하위 내용 재귀적 복사
  - `-p`: 파일 속성(권한, 시간 등) 유지
  - `-i`: 덮어쓸 때 확인 응답 요청
  - `-v`: 복사 과정 상세 출력

- **`mv`** (Move): 파일/디렉토리 이동 또는 이름 변경
  - `-i`: 덮어쓸 때 확인 응답 요청
  - `-f`: 강제 실행 (확인 없이 덮어씀)
  - `-v`: 이동 과정 상세 출력

- **`rm`** (Remove): 파일/디렉토리 삭제
  - `-r`: 디렉토리 및 하위 내용 재귀적 삭제
  - `-f`: 강제 삭제 (경고 메시지 무시)
  - `-i`: 삭제 전 매번 확인

- **`touch`**: 빈 파일 생성 또는 파일의 접근/수정 시간 업데이트
  - `-t [YYYYMMDDhhmm]`: 지정한 시간으로 수정 시간 변경
  - `-c`: 파일이 존재하지 않아도 새로 생성하지 않음

- **`cat`** (Concatenate): 파일 내용 출력 및 연결
  - `-n`: 전체 행 번호 표시
  - `-b`: 공백이 아닌 행에만 번호 표시

- **`man`** (Manual): 명령어 매뉴얼 페이지 확인
  - 구문: `man [섹션번호] [명령어]`
  - 섹션 구분: `1`(일반 명령어), `2`(시스템 콜), `3`(C 라이브러리 함수)

- **`history`**: 실행한 명령어 기록 조회 및 재실행
  - `history [N]`: 최근 N개 기록 출력
  - `!N`: N번째 명령어 재실행
  - `!!`: 바로 직전 명령어 재실행


### 권한 및 소유권 관리
- **`umask`**: 파일/디렉토리 생성 시 적용할 기본 권한 마스크 설정 (예: `umask 022`)
- **`chmod`**: 파일/디렉토리 접근 권한(Mode) 변경
  - 숫자 표현: `chmod 755 [파일]` (`rwxr-xr-x`)
  - 심볼릭 표현: `chmod +x [파일]` (실행 권한 추가)
  - `-R`: 하위 디렉토리 및 파일까지 재귀적 적용

- **`chown`**: 소유자 및 그룹 변경
  - 구문: `chown [소유자]:[그룹] [파일]`
  - `-R`: 재귀적 적용

- **`chgrp`**: 그룹 소유권만 변경
  - 구문: `chgrp [그룹] [파일]`

### 텍스트 처리 (Processing)
- **`grep`**: 패턴 매칭을 이용한 텍스트 검색
  - `-i`: 대소문자 구분 안 함, --ignore-case         ignore case distinctions in patterns and data
  - `-v`: 일치하지 않는 행 선택 (반대 매칭)
  - `-n`: 행 번호 함께 출력, --line-number         print line number with output lines
  - `-r`: 디렉토리 내부 파일까지 재귀적 검색, --recursive           like --directories=recurse
  - `-E`: 확장 정규 표현식 사용
  - `-c`: 패턴 매칭이 된 라인 수 출력.
  - `-B`: 패턴 매칭이 된 라인의 n번째 윗라인까지 출력.
  - `-A`: 패턴 매칭이 된 라인의 n번째 아랫라인까지 출력.
  - `-P`: PCRE 표현식 사용
  - `-I`: equivalent to --binary-files=without-match
  - `egrep`: grep -E.
  - `fgrep`: 정규 표현식을 쓰지 않는, 평문 검색.

- **`sed`** (Stream Editor): 텍스트 검색 및 치환 스트림 편집기
  - `'s/old/new/g'`: 문자열 일괄 치환
  - `-i`: 원본 파일을 직접 수정
  - `-n '/pattern/p'`: 매칭되는 행만 출력
  - `-E`: 확장 정규 표현식 사용.
  - `-e`:

- **`awk`**: 패턴 탐색 및 텍스트 데이터 리포팅/작성
  - `' { print $1 } '`: 첫 번째 열 출력
  - `-F [구분자]`: 필드 구분 기호 지정 (기본값: 공백)

- **`cut`**: 행의 특정 필드나 문자 구간 추출
  - `-d [구분자]`: 구분자 지정
  - `-f [필드번호]`: 추출할 열 지정 (예: `-f 1,3`)

- **`sort`**: 텍스트 행 정렬
  - `-n`: 숫자 크기 기준으로 정렬
  - `-r`: 역순 정렬
  - `-k [열번호]`: 특정 열을 기준 필드로 정렬
  - `-u`: 중복 행 제거

- **`wc`** (Word Count): 라인 수, 단어 수, 바이트 수 출력 (`-l`, `-w`, `-c`)
- **`head`**: 파일의 상위 행 출력 (`-n [숫자]`)
- **`tail`**: 파일의 하위 행 출력
  - `-n [숫자]`: 마지막 N줄 출력
  - `-n +[숫자]`: N번째 줄부터 파일 끝까지 출력
  - `-f`: 실시간 파일 변화 감지 (로그 모니터링)
- **`seq`**: 연속된 숫자열 생성 및 출력 (예: `seq 1 10`)

### 시스템 모니터링 및 작업 제어
- **`ps`**: 프로세스 상태 확인 (`ps aux`, `ps -ef`)
  - `a`: '모든 사용자'의 프로세스
  - `u`: CPU, 메모리 사용량 포함 사용자 중심(User-oriented)의 상세한 포맷으로 출력 
  - `x`: daemon 포함
  - `-e`: 모든 프로세스
  - `-f`: full foramt
  - `m`: 프로세스의 thread까지
  - `l`: ppid, priority, nice 등 포함한 BSD long format
- **`top`**: 실시간 시스템 모니터링 (단축키: `P` CPU순, `M` 메모리순, `k` 프로세스 종료, `q` 종료)
- **`df`**: 디스크 파일 시스템 공간 확인 (`-h` 단위 변환, `-T` 파일시스템 종류)
- **`du`**: 디렉토리/파일 용량 확인 (`-sh` 요약, `-ah` 전체)
- **`free`**: 메모리 사용량 확인 (`-h` 단위 변환, `-s` 주기적 출력)
- **`kill`**: 프로세스 종료 신호 송신 (`-9` 강제종료, `-15` 정상종료 요청, `-l` 목록)
- **`bg` / `fg` / `jobs`**: 작업 제어 (`jobs` 목록 확인, `bg %[번호]`, `fg %[번호]`)
- **`crontab`** (작업 예약)
  - **구조**: `* * * * * [실행할 명령어]` (`분` `시` `일` `월` `요일`)
  - **예시**: `0 3 * * * /backup.sh` (매일 새벽 3시 0분에 `/backup.sh` 스크립트 실행)

### 네트워킹 (Networking)
- **`ping`**: 네트워크 연결 상태 확인 (`-c` 횟수, `-i` 간격)
- **`curl`**: URL 데이터 전송 (`-O` 다운로드, `-I` 헤더만, `-X` HTTP 메소드)
- **`wget`**: 파일 다운로드 (`-b` 백그라운드, `-r` 재귀적 다운로드)
- **`ssh`**: 원격 접속 (`-p` 포트, `-i` 비밀키)
- **`scp`**: 원격 파일 복사 (`-P` 포트 - 대문자 주의, `-r` 디렉토리)
- **`rsync`**: 효율적인 파일 동기화 (`-a` 아카이브, `-v` 상세, `-z` 압축, `--delete` 동일화)

---

<!--TODO: here.-->
## Bash Syntax and Meta Characters
### Builtin Commands
셸 자체에 내장되어 외부 프로세스 생성 없이 즉시 실행되는 명령들입니다.
- **`echo`**: 텍스트 출력
  - `-e`: 이스케이프 문자(`\n`, `\t`, `\r` 등) 해석 활성화
  - `-n`: 끝에 줄바꿈 문자(`\n`)를 출력하지 않음

- **`read`**: 입력받은 값을 변수에 저장
  - `-p "prompt"`: 입력 전 프롬프트 출력
  - `-s`: 입력 문자 비표시 (비밀번호용)
  - `-n [N]`: N개 문자 입력 시 종료
  - `-t [초]`: 타임아웃 설정
  - `-r`: 
  - `REPLY`: default 변수

- **`alias` / `unalias`**: 별칭 설정 및 해제
  - `alias 별칭='명령어'`: 자주 사용하는 길거나 복잡한 명령어를 묶어 대화형 셸에서 사용
  - `unalias 별칭`: 등록된 별칭 해제
  - **alias와 변수(var)의 차이**: `alias`는 명령어를 단축하여 대화형 셸에서 사용자가 직접 입력할 때 적용되며, `var`(변수)는 스크립트 내에서 데이터를 담아 제어하기 위한 수단입니다.

- **`compgen`**: 자동 완성 후보 출력 (`-b`: Builtin 목록, `-k`: Keyword 목록 등)
- **`test` / `[`**: 조건식 평가 (참/거짓 반환)
  - `-e FILE`: 파일이 있는 경우 true.
  - `-f FILE`: 파일이 일반 파일인 경우 true.
  - `-d FILE`: 파일이 디렉터리인 경우 true.
  - `-z STRING`: 빈 문자열이면 true.
  - `-n STRING`: 길이가 0이 아니면 true.
- **`declare` / `typeset`**: 변수 선언 및 속성 부여
- **`export`**: 변수를 환경 변수로 설정하여 자식 프로세스로 전달
- **`unset`**: 변수 또는 함수 정의 해제
- **`source` / `.`**: 스크립트 파일을 읽어 현재 셸 환경에서 실행
- **`exec`**: 새 프로세스를 생성하지 않고 현재 셸을 지정한 명령으로 대체
- **`trap`**: 시그널 수신 시 실행할 핸들러 등록
- **`set` / `shopt`**: 셸의 동작 옵션 및 환경 설정 변경
- **`shift`**: 위치 매개변수(`$1`, `$2` 등)를 좌측으로 이동
- **`eval`**:  Execute value, argument로 오는 것을 명령어로 실행.

- **`env`**: 현재 설정된 전체 환경 변수 목록 출력, [참조](#internal-variables)
  - **`OLDPWD`**: 직전 작업 디렉토리 경로 저장 (`cd -` 실행 시 참조됨)
  - **`IFS`** (Internal Field Separator): 셸이 문자열을 단어 단위로 분할할 때 사용하는 내부 구분자 (기본값: 공백, 탭, 줄바꿈)

---

### Reserved Keywords
Bash 셸의 문법 구조를 형성하는 예약어(Built-in Reserved Words)입니다.
- **조건문 표현식**: `if`, `then`, `else`, `elif`, `fi`, `case`, `esac`
- **반복 및 선택 구문**: `for`, `in`, `select`, `while`, `until`, `do`, `done`
- **함수 및 실행 관련**: `function`, `time`, `coproc`
- **조건문 및 그룹화 키워드**:
- `[[ ]]`: 확장된 조건 평가 구문,  buitin command인 test, [를 대체하는 키워드. 내부에서 제어 연산자도 사용 가능하다.
- `{ }`: 현재 셸 환경에서의 명령 그룹화, 내부에서 앞 뒤 공백 및 명령어 간 `;` (command separator) 필수.
- `!`: 논리 부정 (NOT)

---

# Bash Programming
## Scripting
*Hashbang (`#!`)*
스크립트 파일 첫 번째 줄에 명시하는 실행 인터프리터 경로입니다.
- `#!/bin/bash`: 시스템의 `/bin/bash` 인터프리터로 실행합니다.
- `#!/usr/bin/env bash`: 환경 변수 `PATH` 내에서 bash를 검색하여 실행하므로 환경 독립적이고 안전합니다.

*Script 구조 예시*
```bash
#!/usr/bin/env bash

# 변수 할당 (등호 앞뒤 공백 금지)
VAR=10

# 조건문 구문
if [ "$VAR" -eq 10 ]; then
    echo "Equal"
fi

# 반복문 구문
for f in *.txt; do
    echo "File: $f"
done
```

---

## Control Operators  & Redirection and Pipeline
| 기호   | 기능                                                    | 예시                                  |
| ------ | ------------------------------------------------------- | ------------------------------------- |
| `\|`   | 표준 출력을 다음 명령의 표준 입력으로 전달 (파이프)     | `ls \| grep ".txt"`                   |
| `&&`   | 앞 명령이 성공(exit code 0)했을 때만 뒤 명령 실행 (AND) | `mkdir logs && cd logs`               |
| `\|\|` | 앞 명령이 실패했을 때만 뒤 명령 실행 (OR)               | `mkdir logs \|\| echo "Failed"`       |
| `>`    | 표준 출력을 파일로 저장 (덮어쓰기)                      | `echo "Hi" > log.txt`                 |
| `>>`   | 표준 출력을 파일에 추가 (이어쓰기)                      | `echo "Hi" >> log.txt`                |
| `2>`   | 표준 에러(stderr)를 파일로 리다이렉션                   | `ls non_file 2> error.log`            |
| `&>`   | 표준 출력과 표준 에러를 한 번에 파일로 리다이렉션       | `command &> combined.log`             |
| `&`    | 백그라운드에서 명령 실행                                | `command &`                           |
| `$`    | 변수 확장                                               | $foo ${foo} "${foo}"                  |
| `<<`   | 임시 파일 내용물을 스크립트에서 직접 전달.              | grep 'toFind' << END toFindString END |

### 따옴표 (Quoting) 처리 방식
- **약한 인용 (`" "` - Double Quotes)**: bash의 interpreting이 적용됩니다. 변수 확장(`$VAR`), 명령어 대치(`$(cmd)`), 이스케이프 문자(`\n` 등)가 해석됩니다.
- **강한 인용 (`' '` - Single Quotes)**: bash의 interpreting이 적용되지 않으며, 내부 문자가 순수 문자열 그대로 처리됩니다.

---

## Parameter
*Parameter*: 메모리의 일종인 식별자 공간.
**인자 대치**
`${variable}`: 변수 값을 명확히 읽어오는 파라미터 확장 기호입니다. Parameter Substitution.

### Variable
- 글자 숫자 _로만 명명.
- 숫자로 시작 불가.
- =로 대입, 공백이 존재시 parsing 되어 사용 불가.
- $ 변수 확장 메타 문자로 참조.
- `unset -v`: 변수를 제거.

### array
배열 확장.
VAR=(,,)
VAR[@]: 배열 전체의 expression
${#VAR[*]}: 배열의 크기
<!-- $ -->

### Special Parameters
bash에 의해 사전 선언된 읽기 전용의 Bash 내부 변수, 상태를 전달하는데 사용.
| name    | usage  | description                                                                                                                                                       |
| ------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0       | $0     | 스크립트의 이름 또는 경로를 포함합니다                                                                                                                            |
| 1 2 etc | $1 etc | 위치 매개 변수에는 현재 스크립트 또는 함수에 전달된 인수가 포함됩니다                                                                                             |
| *       | "$*"   | 모든 위치 매개 변수의 모든 단어로 확장됩니다. 큰 따옴표를 붙이면, IFS 변수의 첫 번째 문자로 분리 된 모든 문자열을 포함하는 단일 문자열로 확장됩니다 (나중에 설명) |
| @       | $@     | 모든 위치 매개 변수의 모든 단어로 확장됩니다. 큰 따옴표로 묶어서 개별 단어로 모두 목록으로 확장합니다                                                             |
| #       | $#     | 위치 매개 변수의 수로 확장됩니다                                                                                                                                  |
| ?       | $?     | 가장 최근에 완료한 포 그라운드 명령의 종료 코드로 확장합니다                                                                                                      |
| $       | $$     | 현재 쉘의 PID(프로세스 ID)으로 확장됩니다                                                                                                                         |
| !       | $!     | 백그라운드에서 가장 최근에 실행 된 명령의 PID로 확장합니다                                                                                                        |
| _       | $_     | 실행된 마지막 명령의 마지막 인수로 확장합니다                                                                                                                     |

---

## Expansion
### Parameter Expansion
parameter expansion
```
Bash 쉘에서 #, ##, %, %%는 변수 값의 앞 또는 뒤에서 일치하는 패턴을 찾아 잘라내는 매개변수 확장(Parameter Expansion) 기호입니다.
 방향에 따라 앞에서부터 자르거나 뒤에서부터 자르며, 개수에 따라 가장 짧은 일치 또는 가장 긴 일치를 선택합니다.
문법별 동작 방식${변수#패턴}: 앞에서부터 가장 짧게 일치하는 패턴을 제거합니다.
${변수##패턴}: 앞에서부터 가장 길게 일치하는 패턴을 제거합니다.
${변수%패턴}: 뒤에서부터 가장 짧게 일치하는 패턴을 제거합니다.
${변수%%패턴}: 뒤에서부터 가장 길게 일치하는 패턴을 제거합니다
```

---

### Patterns
#### glob
1. Wildcards and Pattern Matching
  - `*` Match zero or more characters in file names.
  - `?` Match exactly one single character.
  - `[...]` Match any one of the characters enclosed inside the brackets.
  - `[!...]` To negate a range of characters to match.

extended glob, `shopt -s extglob`

####  Regex (ReGular Expression patterns)
정규 표현식 (Regex)
![regex](https://regexr.com/)
- Character
  - [ ]: 글자 모음 (character set), [0-9] 숫자만
  - [^ ]: (negated set), [^0-9] 숫자 제외 전부
  - .: 아무 글자 하나 == [^\n\r]
  - \w: word == [0-9A-Za-z]
  - \W: not word == [^0-9A-Za-z]
- Anchor
  - ^: 줄의 시작
  - $: 줄의 끝
  - \b: word Boundary, 단어의 경계 (단어=연속된 알파벳 문자)
  - \B: 단어의 경계가 아닌 것
- Quantifiers
  - *: 앞의 글자가 0번 이상 반복
  - +: 앞의 글자가 1번 이상 반복 (확장 정규식)
  - ?: 앞의 글자가 없거나 1개일때
  - {숫자1, 숫자2}: 앞의 글자가 숫자1개부터 숫자2개 사이일 때
- Groups and Reference
  - ( ): 그룹 capture, (ha)+  hahaha haha ha 전부 해당
- Alternation
  - (||): 대체, b(a|e|i)d    bad    bed   bid
- Substitution: sed 등 치환 문법에서 사용.
  - 위에서 capture한 그룹을 다시 사용.
  - \0 $0\{0}, 일치한 문자열 전체 재사용
  - \숫자: 숫자에 해당하는 번째의 capture 그룹 재사용, \1 $1 \{1}

##### grep command
[텍스트 처리 (Processing)](#텍스트-처리-processing)
`egrep` == `grep -E`
`grep -e ABC -e DEF`: ABC, DEF 전부 찾기
`grep -v`: 매치되지 않는 것만 (NOT).

##### sed
sed 'ADDRESSs/REGEXP/REPLACEMENT/FLAGS' filename
sed 'PATTERNs/REGEXP/REPLACEMENT/FLAGS' filename

### Brace Expansion (중괄호 확장)
내부의 문자들을 순회하며 반복하여 전개하여 문자열 목록으로 대체된다.
{0, 1}: 0 1
{0, 1}{0..9}: 00 01 02 ........ 19 

### command substitution (명령 대치)
$(variable)
서브셸 내부에서 명령어를 수행한 후 실행 결과를 입력으로 대치한다.
$

---

### Arithmetic Expansion
[참조](#arithmetic-evaluation-산술-평가)
산술 확장식 `(())`을 사용하여 산술식을 평가 할 수 있다.
산술 확장식에서는 C언어 스타일의 연산을 구현하며 true가 1이다.
`$`을 통해 산술 확장식에서도 결과를 대치하여 얻는다.
(()) 내에서는 변수를 참조 `$`하지 않고도 사용할 수 있다.

```bash
a=$((3+5))
echo $a  # 8
```
### Exit Status
`?` 특수 매개 변수는 마지막 fg 프로세스의 종료 코드(`Exit Status`)를 보관한다.
0이 아닌 종료 코드는 정상 처리가 아닌 것으로, exit #을 통해 사용자가 직접 종료 코드를 반환할 수 있다.
- 0이면 true, 0 이외의 1byte value (1~255)는 false 상태.
- `&&`: 성공하면 뒤에 이어진 명령 실행
- `||`: 실패하면 뒤에 이어진 명령 실행

### Conditional Blocks
- `[]`: 빌트인 커맨드 test, 참과 거짓 판별
- `[[]]`: 다양한 기능(glob 패턴 매칭, `&&`/`||` 연산 등)을 지원하고 안전한 Bash 전용 조건문입니다.
인용부호 quotes가 중요, 인용 부호 사용 시에는 문자열로 취급, 없으면 (glob) 패턴 매칭에 사용.
`=~`: 정규 표현식을 만족하는지 판별.

아래 builtin keyword들을 사용하여 조건 평가에 따른 동작을 구현한다.
`if`, `then`, `fi`, `while`, `do`, `for`, `in`, `case`, `esac` 등.
`until`: not while, run when condition is false
`select`: 나열된 리스트 중에서 쓰는 반복문., `break;`가 나타나지 않는 동안 다시 실행.(continue) while switch(case)와 비슷하다고 생각하면 됨. select문 자체가 리스트를 번호로 표시하여 나열하고 번호를 입력받음.


```bash
if [[ $var = ]]; then
;;
fi

for file in $files; do
;;
done

for ((i=0;i<5;i++)); do
;;
done

while [[]]; do
;;
done;


while sleep 300;
do ;;
done



case $val in
abc) echo 'abc';; # break 역할의 ;하나 더 기입.
def) echo 'def';;
*) echo 'default';;
esac

#!/bin/bash 
while getopts ":a:" opt; do 
  case $opt in 
    a) 
      echo "-a was triggered, Parameter: $OPTARG" >&2 
      ;; 
    \?) 
      echo "Invalid option: -$OPTARG" >&2 
      exit 1 
      ;; 
    :) 
      echo "Option -$OPTARG requires an argument." >&2 
      exit 1 
      ;; 
  esac 
done

select sel in "abc" "def";
if [[ $sel =  "abc" ]]; then break; fi
echo 'not answer";
done;

PS3 변수, 
```

---

## Redirection
*File descriptor*
FD는 파일 또는 파일의 형태로 매핑된 리소스 (파이프, 디바이스, 소켓, 터미널 등)를 참조하는 방법, 데이터 소스, 기록 장소의 포인터와 비슷한 것.

0: standard input
1: standard output
2: standard error

- `2>`: 표준 error 출력을 리다이렉션.
- `1>`: 표준 출력만 리다이렉션.
- `&>`: 표준 출력 및 error 둘다 리다이렉션

**Heredocs**
`<<NAME`: 임시 파일의 내용을 터미널 창에 적어서 직접 전달. 인용문 ''를 사용하여 'NAME' 이런식으로 전달하면 Bash의 변수, 메타 문자 대치가 일어나지 않는다. 

**Herestrings**
`<<<NAME`: 임시 문자열을 파일으로써 전달한다.
부피가 큰 heredocs에 비해 짧고 편리. pipe를 통해 변수를 보내는 것보다 편리.

### Pipes
파이프 연산자는 각 명령에 대한 `Subshell` 환경을 작성합니다. 두 번째 명령 내에서 수정하거나 초기화하는 변수는 수정되지 않은 상태로 나타납니다

`tee`: Copy standard input to each FILE, and also to standard output.

### Process Substitution (프로세스 대치)
명령어 대치 (`Command Substitution`)과 같이 `Subshell`에서 명령어를 실행시켜 출력 결과를 얻는 것은 같으나, 명령어 대치가 그 자리를 대체하는 것이고 프로세스 대치는 리다이렉션으로 사용하는 임시 파일로 여긴다.
`<()`:
`>()`:

### Subshell (서브쉘)
현재 shell에서 새로운 shell을 fork하여 실행 후 종료한다. fork이므로 현재 쉘의 정보(변수)가 상속된다.
`( command )`: 명령어를 서브셸(Subshell) 안에서 실행합니다. 변수 변경 사항이 메인 셸에 유지되지 않습니다.


### Command Grouping (명령어 그룹화)
`{ cmd1; cmd2; }`: command group, 현재 셸 환경에서 명령어를 그룹화하여 실행합니다. (끝에 세미콜론 `;` 필수, 내부에서 괄호 주변 공백 필수)
명령어 그룹의 리다이렉션은 그룹 내의 모든 명령어의 출력을 받는다, 즉 파일이 각 명령마다 닫히거나 열리지 않는다.


### Arithmetic Evaluation (산술 평가)
`(( expression ))`: 산술 연산 및 조건식을 평가합니다.
산술 확장식에서는 C언어 스타일의 연산을 구현하며 true가 1이다.
`$`을 통해 산술 확장식에서도 결과를 대치하여 얻는다.
(()) 내에서는 변수를 참조 `$`하지 않고도 사용할 수 있다.

---

## Functions and Aliases
### Function
별도의 파일에 존재하지 않고 명령어를 실행할 수 있으며(like alias, command block), 또한 인자를 받는 게 가능하다 (like script).
`local` 키워드를 이용하여 함수에서만 쓰는 지역 변수를 선언한다.

*함수 정의 형태*
```bash
function func {
  # 동작
}

function func() {
  # 동작
}

func() {
  # 동작
}
```

`declare`: 현재 쉘에 정의된 함수들의 목록을 보여줌.
- `-f`: 함수의 정의까지 본다.
- `-F`: 함수의 이름만 본다.
`unset -f`: 정의된 함수를 제거.

---

## Job Control
CTRL-Z: SIGSTP
CTRL-C: SIGINT
CTRL-\: SIGQUIT
fg:
bg:
suspend:

### Debug Script
### cron
`crontab`: cron이라는 daemon 프로세스에 주기적으로 실행할 동작을 맡김.
- `-e`: editor를 통해 crontab 파일을 열어서 수정.
- `-l`: list.
- `-r`: 목록 제거.

```bash
minute hour day month 요일 명령
* * * * * command
```

---


# memo
`--`로 -P를 P 옵션 전달이 아닌 이름으로 사용 가능하게 한다.
glob *를 사용하여 파일들을 열거하여 expression으로 사용하는 것이 ls (\t과 \n이 혼용)를 사용하는 것보다 좋다.


`xargs`: redirection 과정 중에 보통의 경우 출력 내용을 파일로 전달하지만 xargs로 받으면 그 출력을 찾아야 할 파일의 이름으로 받는다.
- `-0`: separated with Null.

`fifo`: `mkfifo`를 통해 만드는 특수 파일, FIFO에 대한 모든 읽기 작업은 데이터가 사용 가능할 때까지 차단. FIFO는 실제로 명명된 파이프(named pipe) 라고도 합니다. 파이프 연산자와 동일한 결과를 얻지만 파일 이름을 통해 수행합니다.

- `who`: 
- `cut`: 
- `tr`: 
- `uniq`: 
- `sort`: 
- `tar`: 압축 및 해제 명령어.
  - `c`: --create, 
  - `f`: --file, 사용할 아카이브 파일 이름.
  - `x`: --extract, 아카이브에서 추출.
  - `z`: gzip을 이용한 압축 및 해제.
- `find [path...] [expression]`: 파일을 지정 경로 이하에서 찾는다. 전달하는 인자들(-name, -not, -mindepth, -maxdepth)은 모두 AND.
  - `-name FILENAME`: 찾을 파일 이름, `-iname`: ignore case.
  - `-type`: 찾을 파일 종류.
    - f: 파일
    - d: 디렉터리
    - l: 심볼릭 링크
  - actions
    - `-print`
    - `-printf FORMAT`
    - `-print0`
    - `-exec COMMAND {} \;`: 자리표시자 {}가 찾은 파일들을 하나씩 전달하는 부분.  \;는 -exec에게 전달한 명령어 완료됨을 명시하는 부분.(bash가 ;를 낚아채지 않게 \; escape로 전달)

## 괄호 구문 (Brackets & Parentheses) 정립
### 1. 소괄호 `()`
- `( command )`: 명령어를 서브셸(Subshell) 안에서 실행합니다. 변수 변경 사항이 메인 셸에 유지되지 않습니다.
- `$( command )`: 명령어 대치(Command Substitution). 실행 결과를 문자열로 변환합니다. (예: `result=$(date)`)
- `(( expression ))`: 산술 연산 및 조건식을 평가합니다.
- `name() { ... }`: 함수를 선언할 때 사용합니다.

### 2. 중괄호 `{}`
- `{ cmd1; cmd2; }`: command group, 현재 셸 환경에서 명령어를 그룹화하여 실행합니다. (끝에 세미콜론 `;` 필수)
- `${variable}`: 변수 값을 명확히 읽어오는 파라미터 확장 기호입니다. Parameter Substitution
- `{a,b,c}`: 문자열 조합을 생성하는 중괄호 확장(Brace Expansion)입니다. (예: `file_{1,2}.txt`)

### 3. 대괄호 `[]`
- `[ condition ]`: 조건식을 평가하는 `test` 내장 명령의 별칭입니다. (괄호 양옆 공백 필수, command이기 때문)
- `[[ condition ]]`: `[` 보다 다양한 기능(glob 패턴 매칭, `&&`/`||` 연산 등)을 지원하고 안전한 Bash 전용 조건문입니다.
  - `=~` 연산자로 정규 표현식을 사용할 수 있다.
- `[a-z]`: 정규식 또는 와일드카드에서 문자 클래스 범위를 지정합니다.

