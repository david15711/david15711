
- [C#](#c)
  - [기본](#기본)
  - [기본 형태](#기본-형태)
  - [Syntax](#syntax)
      - [변수](#변수)
      - [기본 타입](#기본-타입)
      - [참조 타입 (Reference Type)](#참조-타입-reference-type)
      - [foreach 문법](#foreach-문법)
      - [형변환](#형변환)
  - [Class](#class)
    - [멤버 함수 (method)](#멤버-함수-method)
      - [parameters](#parameters)
      - [method overloading](#method-overloading)
      - [생성자와 소멸자](#생성자와-소멸자)
      - [접근 제한자](#접근-제한자)
      - [member data (Field, Property)](#member-data-field-property)
      - [this](#this)
      - [static (정적 멤버)](#static-정적-멤버)
      - [Indexer](#indexer)
      - [메소드 재정의와 가상 메소드](#메소드-재정의와-가상-메소드)
      - [Upcasting과 Downcasting](#upcasting과-downcasting)
    - [추상 클래스 (abstract class)](#추상-클래스-abstract-class)
    - [인터페이스 (Interface)](#인터페이스-interface)
  - [일반화 프로그래밍 (Generic programming)](#일반화-프로그래밍-generic-programming)
      - [Object boxing - classic way](#object-boxing---classic-way)
      - [Generic 방식](#generic-방식)
  - [컬렉션 (Collection)](#컬렉션-collection)
      - [List](#list)
      - [Dictionary\<TKey, TValue\>](#dictionarytkey-tvalue)
      - [Stack:](#stack)
      - [Queue:](#queue)
      - [Linq (Language INtergrated Query)](#linq-language-intergrated-query)
  - [예외처리 (Exception)](#예외처리-exception)
  - [파일 입출력](#파일-입출력)
  - [delegate](#delegate)
      - [Action](#action)
      - [Func](#func)
      - [event 키워드](#event-키워드)
  - [쓰레드 (Thread)](#쓰레드-thread)
      - [mutex lock](#mutex-lock)
      - [Monitor](#monitor)
  - [Network](#network)
      - [TCP](#tcp)
- [WPF (Window Presentation Foundation)](#wpf-window-presentation-foundation)
  - [XAML (extensible Application Markup Language)](#xaml-extensible-application-markup-language)
      - [속성 요소 (Property Element)](#속성-요소-property-element)
      - [이벤트 핸들러 연결](#이벤트-핸들러-연결)
      - [데이터 바인딩 (Binding)](#데이터-바인딩-binding)
    - [네임스페이스 (Namespace)](#네임스페이스-namespace)
    - [레이아웃 Layout](#레이아웃-layout)
      - [Grid](#grid)
      - [StackPanel](#stackpanel)
      - [Layout Nesting](#layout-nesting)
    - [Control](#control)
- [MVVM (Model View ViewModel)](#mvvm-model-view-viewmodel)
  - [생성자 인자로 받는 외부 함수를 Inject 받아 실행하는 객체.](#생성자-인자로-받는-외부-함수를-inject-받아-실행하는-객체)

# C#
## 기본
> C++과 JAVA의 혼종 언어.

1. `CLR (Common Language Runtime)`
   - JIT 컴파일러: IL로 컴파일된 DLL 파일을 실행 아키텍쳐에 맞게 기계어로 컴파일 한다.
   - GC
2. `BCL (Base Class Library)`

## 기본 형태
```CSharp
using System;
namespace CSharpConsole1
{
  internal class Program
  {
    static void Main(string[] args)
    {
    }
  }
}
```


`using`: 해당 namespace를 import함. 즉, 사용함을 명시함. 또한 using namespace와 동일함, 즉 스코프 참조 생략가능하게 함.
`namespace`: namespace 정의.
`internal`: 클래스 접근 제한자, 해당 프로젝트에서만 사용.
`public`: 클래스 접근 제한자, 다른 어플리케이션에서도 접근 가능. (Java 등은 해당 어플리케이션 다른 클래스만.)


main을 static으로 선언하여 전역에서 볼 수 있도록 한다.
C#은 모든것이 객체이기 때문에 진입점이 따로 존재하지 않고, main 또한 클래스의 멤버 함수이다.

---

표준 입출력
Console.Write();     // System::Console
Console.WriteLine();
Console.ReadLine();

---

## Syntax
#### 변수
`var`: 암시적 형식 지역 변수(Implicity typed local variable), C++의 `auto`와 같음. 선언과 동시에 초기화 필요.

#### 기본 타입
`struct`: C++의 struct는 public인 class였다면, 여기서는 값 타입인 class.

#### 참조 타입 (Reference Type)
- 타입 자체가 참조 방식으로 동작, 실제 공간을 가지는 것이 아니라 그 자체로 가상 주소값을 가리킴.
- 저장 위치: 실제 데이터는 힙(Heap) 메모리에 저장되고, 변수 자체는 주소를 스택(Stack) 에 보관합니다.
- 동작 방식: 한 변수의 데이터를 수정하면 동일한 객체를 참조하는 다른 변수의 데이터도 함께 변경됩니다.
- 메모리 해제: 사용하지 않는 객체는 가비지 컬렉터(GC, Garbage Collector) 가 자동으로 힙에서 수거합니다.
`class`: C# 객체는 참조 타입으로 스택 영역의 지개 객체로 쓸 수 없다. 즉 단독으론 포인터 선언과 같다. new Class;를 대입해줘야 사용.
`object`: 모든 객체(class, type) 등의 조상 클래스, 모든 객체는 object를 상속받음.
`string`
`interface`
`typename[]`: 배열형을 가져온다고 명시하며 실제로는 런타임 머신이 매긴 가상 주소값을 주고 받음. 자체 Length 멤버를 가짐.
`delegate`


**Target-typed new**: 타입 정보가 명확한 경우 new 뒤를 생략하고 new()로 표현할 수 있다.

#### foreach 문법
foreach(var asdf in args)

#### 형변환
- (): 연산자 방식.
- Convert 메소드
  - ToString
  - ToInt32
  - ToChar

## Class
- 접근 제한자 (public, private)으로 묶어서 선언하지 않고, 각 멤버마다 지시.
- 메소드를 선언 및 정의로 분리하지 않고, 선언부에서 정의.


### 멤버 함수 (method)

#### parameters
| 키워드 | 역할      | 특징                                                   |
| ------ | --------- | ------------------------------------------------------ |
| (기본) | 값 복사   | 원본에 영향 없음                                       |
| ref    | 참조 전달 | 원본 변수의 값을 변경 가능 (초기화 필수)               |
| out    | 결과 반환 | 메서드 내에서 반드시 값을 할당해야 함 (주로 다중 반환) |
| in     | 읽기 전용 | 메서드 내에서 값 수정 불가 (성능 최적화용)             |
| params | 가변 인자 | 개수가 정해지지 않은 인자를 배열로 받음                |

**out**:
파라미터로 받은 변수에 직접 접근하여 값을 바꿀 수 있음. (참조로 받은 변수를 바꾸는 방식.)
무조건 초기화 해야함. 다중 반환 등.
**in**:
인자를 받을 때, 값에 의한 호출(Call-by-Value)을 하지 않고 주소값만 참조(읽기 전용)로 받아와 전달받아 성능 하락을 없앰.
멤버 변수도 바꿀 수 없음. 즉 const로 받아옴.
**(기본)**:
기본 형식은 값에 의한 호출, 참조 형식은 참조값 복사(포인터 복사).
**ref**:
변수 및 객체 자체가 가리키는 주소 그 자체를 전달. 즉 참조.
원본 참조 타입의 대상을 바꿀 수 있음.
**params**:
가변인자, (params int[] numbers) 형태로 선언하면 인자를 (1,2,3,4,5) 형태의 길이 상관없이 나열된 값으로 호출 가능.

*const*: 컴파일 타임에 확정되는 무조건적는 상수, 코드 곳곳에서 치환해버림, 매크로와 같은 것.


#### method overloading
- 매개변수의 자료형
- 매개변수의 갯수
가 다르면 구별되는 오버로딩 다형성 구현됨, 반환값만 다르면 구분되지 않음.


#### 생성자와 소멸자
C++과 같음, C#에서 메모리는 GC가 처리하므로 소멸자는 잘 쓰지 않는다.
상속 시 Class() : base() 형태로 부모 생성자 호출 가능.

#### 접근 제한자
| 제한자    | 설명                                                |
| --------- | --------------------------------------------------- |
| public    | 어디서든 접근 가능                                  |
| private   | 해당 클래스 내부에서만 접근 가능 (기본값)           |
| protected | 해당 클래스 및 상속받은 자식 클래스에서만 접근 가능 |
| internal  | 동일한 프로젝트(어셈블리) 내에서만 접근 가능        |


#### member data (Field, Property)
`Field`: 그냥 멤버 데이터.
`Property`: 데이터 접근 제어기. (필터링, 계산, 보호 가능)

---

**Property**
필드 선언 형식에 블록{}을 추가로 선언하고 내부에 get, set, init 등을 선언 또는 정의.
속성으로 접근(rvalue, lvalue 사용)하면 내부에 선언 또는 정의한 동작을 함.
```csharp
public class Person
{
    private int age; // 실제 데이터는 숨김 (private)

    public int Age // 외부에서 접근하는 창구 (public)
    {
        get { return age; } // 값을 읽을 때
        set
        {
            // 값을 쓸 때 검사 로직 추가 가능!
            if (value >= 0) age = value;
        }
    }
}
```
Age를 rvalue, lvalue로 사용 시 private 필드의 age를 사용하는 속성.
value는 buitin 지시어로, setter에 대입하는 값. Age의 자료형과 같음.

*접근자*
get: 읽기 전용 속성
set: 쓰기 전용 속성
init: 초기화 전용 속성
value: 자동 구현 속성에서 해당 이름의 필드.

**자동 구현 속성 (Auto-Implemented Property)**
매번 필드를 따로 만들고 속성을 선언하는 대신, 속성만 만들면 같은 이름의 private 필드를 만들어줌.

---
#### this
객체 자기 자신을 가리키는 참조 변수, C++처럼 포인터 형태가 아니므로 멤버 참조 연산자 .을 사용.
1. 이름 충돌 해결: 같은 이름의 필드가 존재 시
2. 객체 전달
3. 생성자 호출: 자기 자신의 생성자 호출

**base**: 부모 클래스를 가리키는 참조 식별자.

#### static (정적 멤버)
클래스에 단 하나만 존재하는 정적 멤버. class 이름으로 접근.
- Field의 경우:
- method의 경우: 객체에 존재하는 일반 멤버 변수 사용 불가.


#### Indexer
this키워드를 사용하여 정의.
객체의 필드를 배열처럼 접근.
C++의 operator[]와 비슷한 기능.

```csharp
public class ShoppingCart
{
    private string[] _items = new string[10];

    // 인덱서 정의
    public string this[int index]
    {
        get => _items[index];
        set => _items[index] = value;
    }
}
// 사용 예시
var cart = new ShoppingCart();
cart[0] = "사과"; // 마치 배열처럼 사용
Console.WriteLine(cart[0]);
```
Indexer는 int 말고도 다른 자료형도 가능, this[string name]륾 받으면,

*Lamda Expression*
람다 표현식 =>, => 뒤에 동작 구현.

---
#### 메소드 재정의와 가상 메소드
1. new: 부모 메소드 무시하고 재정의. 생략가능. 객체 종류 상관없이 자료형의 해당 메소드를 호출.
2. override: virtual로 정의된 부모 메소드 재정의. Upcasting된 객체의 메소드가 재정의된 메소드 호출.

#### Upcasting과 Downcasting
Upcasting: 암시적으로 변환. 항상 안전.
Downcasting: 명시적으로 시행, 불안정하며 런타임 에러 (InvalidCastException) 발생 위험.

**C#의 안전한 다운캐스팅**
1. is 연산자: 특정 타입인자 확인하여 bool 반환.
2. as 연산자: 오른쪽의 타입으로 변환하고 실패하면 null. 매우 안전함.

### 추상 클래스 (abstract class)
- 미완성 클래스, 객체 생성 불가,
- `abstract` 키워드를 class 앞에 붙임.
- 구현부가 없는 추상 메소드를 가질 수 있음. == 자식에게 구현을 강제, LSP(리스코프 치환 원칙) 준수, Loose Coupling
- is-a 관계, 상속 받은 클래스들은 상위 클래스의 일종이다.

### 인터페이스 (Interface)
- 완전 추상 클래스, C++의 추상 클래스(C++에서 순수 가상 함수만 가진 클래스)
- C#에서 다중 상속 가능한 클래스
- `abstract` 키워드 생략.
- 접근 제한자 생략. 모든 멤버가 public.
- can-do 관계, 상속 받은 클래스들은 받아온 메소드를 할 수 있다.

## 일반화 프로그래밍 (Generic programming)
#### Object boxing - classic way
`object`: 모든 자료형, 클래스 등 객체들의 조상 클래스.
- int, string, bool, class, struct 등 그 무엇이라도 object 타입 변수에 담을 수 있습니다.
- **박싱(Boxing)과 언박싱(Unboxing):**
  - **박싱:** 값 형식(예: `int`)을 `object` 타입에 담는 것. (힙 메모리에 복사됨)
  - **언박싱:** `object`에 담긴 값을 다시 원래의 값 형식으로 꺼내는 것.
  - **주의:** 이 과정은 성능 비용이 발생하므로 자주 사용하면 성능 저하의 원인이 됩니다.

`ArrayList`: `object` 기반 컬렉션.
안 쓰는 이유
1. **타입 안정성 결여:** `object` 컬렉션에는 정수와 문자열을 섞어서 넣을 수 있습니다. 꺼낼 때 어떤 타입인지 알 수 없어 런타임 에러가 발생하기 쉽습니다.
2. **성능 문제:** 위에서 언급한 박싱/언박싱 과정 때문에 CPU와 메모리를 많이 소모합니다.

써야하는 경우
- **API 연동:** 아주 오래된 외부 라이브러리(Legacy API)가 `object`를 매개변수로 요구할 때.
- **유연한 데이터 처리:** `JSON` 등을 파싱할 때 데이터 구조를 미리 알 수 없어서 `object`를 임시로 사용해야 하는 경우.
- **공통 함수:** 모든 객체에 대해 공통 기능을 수행하는 메서드를 만들 때 (예: `ToString()`, `GetHashCode()` 등은 모든 `object`에 기본 정의되어 있음).

주요 메소드
1. ToString()
2. Equals(object obj): 주소값이 같은 참조인지 반환
3. GetHashCode(): 객체 식별용 고유 정수(Hash Code) 반환, 같은 객체 같은 값
  - 기본 동작: 참조형 타입은 두 변수가 '같은 메모리 주소를 가리키고 있는지'를 비교합니다.
4. GetType(): 런타임 정보 확인
  - 주의: Equals를 재정의했다면, 반드시 GetHashCode도 함께 재정의해야 합니다. (두 객체가 Equals로 같으면, GetHashCode 값도 같아야 함)


#### Generic 방식
C++과 거의 같으나 template<typename T> 선언 부분만 없음.

**where 키워드**
제네릭 타입에 제약 조건(Constraints)을 설정.
만족하는 타입만 들어올 수 있게 설정함.
| 제약 조건              | 설명                                                 |
| ---------------------- | ---------------------------------------------------- |
| where T : struct       | T는 반드시 **값 형식(Value Type)**이어야 함.         |
| where T : class        | T는 반드시 **참조 형식(Reference Type)**이어야 함.   |
| where T : new()        | T는 반드시 매개변수 없는 생성자가 있어야 함.         |
| where T : 인터페이스명 | T는 반드시 해당 인터페이스를 구현해야 함.            |
| where T : 클래스명     | T는 반드시 해당 클래스를 상속받아야 함.              |
| where T : U            | T는 반드시 U라는 다른 제네릭 타입에서 파생되어야 함. |


## 컬렉션 (Collection)
- Generic Collection: STL
- non-Generic Collection: object 기반, ArrayList, Hashtable

#### List<T>
1) 데이터 추가 및 삭제 (Manipulation)
    - **`Add(T item)`**: 리스트 끝에 요소를 추가합니다.
    - **`AddRange(IEnumerable<T> collection)`**: 다른 리스트나 배열의 요소를 한꺼번에 추가합니다.
    - **`Insert(int index, T item)`**: 특정 위치에 요소를 삽입합니다.
    - **`Remove(T item)`**: 리스트에서 특정 요소의 **첫 번째 항목**을 찾아 삭제합니다.
    - **`RemoveAt(int index)`**: 특정 위치의 요소를 삭제합니다.
    - **`Clear()`**: 리스트의 모든 요소를 삭제합니다.

2) 검색 및 조회 (Search & Query)
    - **`Contains(T item)`**: 리스트에 특정 요소가 있는지 `bool`로 반환합니다.
    - **`IndexOf(T item)`**: 특정 요소가 처음 나타나는 인덱스를 반환합니다 (없으면 -1).
    - **`Find(Predicate<T> match)`**: 조건을 만족하는 **첫 번째** 요소를 반환합니다.
    - **`FindAll(Predicate<T> match)`**: 조건을 만족하는 **모든** 요소를 새로운 리스트로 반환합니다.
    - **`Exists(Predicate<T> match)`**: 조건을 만족하는 요소가 하나라도 있는지 확인합니다.

3) 정렬 및 데이터 변환 (Transformation)
    - **`Sort()`**: 리스트를 오름차순으로 정렬합니다.
    - **`Reverse()`**: 리스트의 요소 순서를 뒤집습니다.
    - **`ConvertAll<TOutput>(Converter<T, TOutput> converter)`**: 모든 요소를 다른 타입으로 변환하여 새 리스트를 만듭니다.

#### Dictionary<TKey, TValue>
#### Stack<T>:
| 메서드           | 설명                                                                           |
| ---------------- | ------------------------------------------------------------------------------ |
| Push(T item)     | 스택의 가장 위에 데이터를 추가합니다.                                          |
| Pop()            | 스택의 가장 위에 있는 데이터를 꺼내고(제거) 반환합니다. (비어있으면 예외 발생) |
| Peek()           | 스택의 가장 위에 있는 데이터를 꺼내지 않고 확인만 합니다.                      |
| Clear()          | 스택의 모든 데이터를 삭제합니다.                                               |
| Contains(T item) | 특정 데이터가 스택에 있는지 확인합니다.                                        |
| Count            | 스택에 들어있는 데이터의 개수를 반환합니다.                                    |

#### Queue<T>:
| 메서드                            | 설명                                                                         |
| --------------------------------- | ---------------------------------------------------------------------------- |
| Enqueue(T item)                   | 큐의 가장 뒤에 데이터를 추가합니다.                                          |
| Dequeue(Dictionary<TKey, TValue>) | 큐의 가장 앞에 있는 데이터를 꺼내고(제거) 반환합니다. (비어있으면 예외 발생) |
| Peek(Dictionary<TKey, TValue>)    | 큐의 가장 앞에 있는 데이터를 꺼내지 않고 확인만 합니다.                      |
| Clear()                           | 큐의 모든 데이터를 삭제합니다.                                               |
| Contains(T item)                  | 특정 데이터가 큐에 있는지 확인합니다.                                        |
| Count                             | 큐에 들어있는 데이터의 개수를 반환합니다.                                    |


#### Linq (Language INtergrated Query)
`Query`: DataBase에서 데이터 요청. 검색 수행.
*지연 실행 (Deferred Execution)*:
LINQ 쿼리는 문장을 만드는 시점에 바로 실행되지 않고, 실제로 데이터가 필요한 순간(예: foreach를 돌거나 .ToList()를 호출할 때)까지 실행을 미룹니다.
**Clause**
| 구문 (Clause) | 설명                               |
| ------------- | ---------------------------------- |
| from          | 어떤 데이터에서 찾을 것인가        |
| where         | 어떤 조건으로 찾을 것인가          |
| select        | 어떤 항목을 추출할 것인가          |
| order by      | 어떤 항목을 기준으로 정렬할 것인가 |

**Method Syntax**
| 메소드  | 설명                               |
| ------- | ---------------------------------- |
| From    | 어떤 데이터에서 찾을 것인가        |
| Where   | 어떤 조건으로 찾을 것인가          |
| Select  | 어떤 항목을 추출할 것인가          |
| OrderBy | 어떤 항목을 기준으로 정렬할 것인가 |

## 예외처리 (Exception)
try, catch, finally
.NET Framework가 exception을 던지기 때문에 try 내부에 반드시 throw를 쓸 필요가 없음.
`finally`: 예외가 발생하든 안하든 실행하는 블록


## 파일 입출력
System.IO namespace.
1. File class 사용
   1. AppendText()
   2. Copy()
   3. Create()
   4. Delete()
   5. Exists()
   6. ReadAllText()
   7. Replace()
   8. WriteAllText()
2. StreamWriter / StreamReader class 사용.


- using을 사용하여 파일을 열기 (GC 적용됨)
- `StringBuilder` 클래스를 사용하여 string 객체를 사용하는 것보다 성능 비용을 줄이고 문자열 사용.
  - 내부에 자체적인 버퍼를 가져서 동적 가변 객체인 string의 오버헤드가 없음.
- FileInfo
- DirectorInfo



## delegate
`delegate` mean 대리자.
*함수 포인터같은 함수 자료형 정의*
외부에서 정의한 커스텀 함수를 Inject 가능.
멀티캐스트(MultiCast) 가능, 즉 여러 함수 대입하여 함수 매크로로 사용 가능.
`?` 연산자: 삼항 연산자로도 쓰이는 연산자, 변수?.Invoke() 패턴에서 변수가 NULL이 아닐때만 시행하도록 한다.

```csharp
public delegate void MyFunc(string argname);

static void SayHello(string msg){ Console.WriteLine($"Hello {msg}")}
static void SayBye(string msg){ Console.WriteLine($"Bye {msg}")}

MyFunc handler =  SayHello + SayBye;
handler("User");
/*
Hello User
Bye User
*/
```

#### Action
반환값이 없는 delegate
Action<매개변수타입1, ... > 형태로 선언, param 없으면 그냥 Action.

#### Func
Func<매개변수타입1, ... , 반환타입> 형태로 선언, 마지막 자료형이 반환 자료형.

---

#### event 키워드
> delegate 문제점: 외부에서의 변경 -> 대참사
> public delegate는 외부에서 마음대로 조작 가능. 버그의 원인.

delegate 앞에 event 키워드 추가.
메소드 구독 (+=)과 해지 (-=)는 가능하지만 null 대입, .Invoke() (외부에서 직접 호출) 등은 컴파일 에러로 방지.
protected delegate를 선언 시 보호. (자식 클래스로부터 보호)

## 쓰레드 (Thread)
MultiTasking: 단일 프로세스가 여러 태스크를 동시 실행, context switching 오버헤드가 프로세스간 스위칭보다 적음.

#### mutex lock
```C#
lock(참조 타입 객체)
{
  // 선점 후 동작 구현
}
```

#### Monitor
| 메소드                           | 설명                                    |
| -------------------------------- | --------------------------------------- |
| Monitor.PulseAll(참조 타입 객체) | Wait(객체)로 대기한 쓰레드를 전부 꺠움. |
| Monitor.Wait(참조 타입 객체)     | 깨울때까지 sleep                        |

## Network
#### TCP
TcpListener
.accept()로 클라이언트 접속 대기

TcpClient
.Connect()로 서버에 연결.


# WPF (Window Presentation Foundation)
UI는 XAML, 로직 (code-behind)는 C#으로 구성.

## XAML (extensible Application Markup Language)
기본적으로 XML이며, 다음과 같은 매핑 관계를 가진다.
- **태그 이름:** .NET 클래스 이름 (예: `<Button/>` -> `System.Windows.Controls.Button`)
- **속성:** 클래스의 속성 (Property) (예: `<Button Content="확인"/>` -> `Button.Content = "확인"`)
- **중첩 태그:** 객체 간의 부모-자식 관계 (예: `Grid` 안에 `Button`)

####  속성 요소 (Property Element)
속성값이 단순 문자열이 아닐 때, 별도의 태그로 속성을 설정합니다.
```XML
<Button>
    <Button.Content>
        <StackPanel>
            <TextBlock Text="확인" />
        </StackPanel>
    </Button.Content>
</Button>
```
`Button.Content`라는 태그를 사용하여 복잡한 객체(StackPanel)를 콘텐츠로 삽입합니다.

---
#### 이벤트 핸들러 연결
XAML에서 발생한 이벤트를 C# 코드로 연결합니다.
```xml
<Button Click="Button_Click" Content="클릭하세요" />
```
*코드 비하인드(.xaml.cs)에서 `private void Button_Click(object sender, RoutedEventArgs e)` 메서드가 정의되어 있어야 합니다.*

---

#### 데이터 바인딩 (Binding)
UI와 데이터(ViewModel)를 연결하는 핵심 문법입니다.
```xml
<TextBlock Text="{Binding UserName, Mode=TwoWay}" />
```
- `{ }`: 마크업 확장(Markup Extension)이라 부르며, 런타임에 값을 동적으로 계산할 때 사용합니다.
- `Mode=TwoWay`: UI 수정 시 데이터가 같이 변경되도록 설정합니다.

| 모드           | 방향        | 설명                                                          |
| -------------- | ----------- | ------------------------------------------------------------- |
| OneWay         | 소스 → 타겟 | 데이터가 변경되면 UI가 자동으로 업데이트됩니다.               |
| TwoWay         | 소스 ↔ 타겟 | UI가 변경되면 데이터도 바뀌고, 데이터가 바뀌면 UI도 바뀝니다. |
| OneTime        | 소스 → 타겟 | 처음 초기화될 때 한 번만 UI를 업데이트합니다.                 |
| OneWayToSource | 타겟 → 소스 | UI가 변경되면 데이터만 업데이트합니다.                        |


### 네임스페이스 (Namespace)

XAML 파일 상단에 있는 `xmlns`는 클래스가 포함된 DLL을 가리킵니다.

- `xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"`: WPF 기본 컨트롤 (Button, Grid 등)
- `xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"`: XAML 언어 자체의 기능 (`x:Name`, `x:Key` 등)



### 레이아웃 Layout
| 특징      | Grid                          | StackPanel                |
| --------- | ----------------------------- | ------------------------- |
| 배치 방식 | 행과 열을 이용한 좌표 방식    | 일렬로 차곡차곡 쌓음      |
| 복잡도    | 높음 (자유도 높음)            | 낮음 (단순함)             |
| 주 용도   | 메인 레이아웃, 복잡한 폼 구성 | 버튼 나열, 간단한 입력 폼 |
| 유연성    | 반응형 디자인에 최적          | 내용물 크기에 따라 유동적 |
#### Grid
- GridColumn
- GridTextColumn

#### StackPanel
#### Layout Nesting


### Control
- ContentControl 계열 (콘텐츠 표시): `Button`, `Label`, `CheckBox`, `RadioButton`
    - 내부에 텍스트뿐만 아니라 이미지, 패널 등 다양한 요소를 담을 수 있습니다.
- TextBoxBase 계열 (텍스트 입력): `TextBox`, `PasswordBox`
    - 사용자로부터 텍스트 입력을 받습니다.
- ItemsControl 계열 (데이터 목록): `ListBox`, `ComboBox`, `DataGrid`
    - 여러 데이터를 리스트 형태로 보여줍니다.



| 속성                | 설명                                          | 활용 예시                              |
| ------------------- | --------------------------------------------- | -------------------------------------- |
| Margin              | 컨트롤 주변의 외부 여백                       | Margin="10, 5, 10, 5" (좌, 상, 우, 하) |
| Padding             | 컨트롤 내부 콘텐츠와 테두리 사이의 여백       | 버튼 내부의 텍스트 위치 조절           |
| HorizontalAlignment | 가로 정렬 방식 (Left, Center, Right, Stretch) | HorizontalAlignment="Center"           |
| VerticalAlignment   | 세로 정렬 방식 (Top, Center, Bottom, Stretch) | VerticalAlignment="Top"                |
| Visibility          | 컨트롤 노출 여부 (Visible, Collapsed, Hidden) | Collapsed는 공간도 차지하지 않음       |




# MVVM (Model View ViewModel)
**MVC (Model VIew Controller)**
M(model): 데이터 캡슐화 및 데이터 처리하는 클래스
V(view) : ui
C(controller): 데이터의 흐름 구현

**MVVM (Model View Viewmodel)**
M(model): 데이터 캡슐화 및 데이터 처리하는 클래스
V(view) : ui
VM(view model): 모델과 뷰 중간단계. 데이터변화를 이벤트로 처리해서 감지되면 뷰나 데이터가 자동으로 변동되도록 구현
Model과 View가 유착되지 않고 Viewmodel이 중재함. Command Pattern, 변동 이벤트 핸들러를 ViewModel이 모아서 전달.

---


> class MainViewModel : INotifyPropertyChanged

INotifyPropertyChanged: Interface, 속성 변경 시 알림==이벤트 발생=핸들러 호출=View및Model 변경

> set 
> { 
>   num = value; 
>   OnPropertyChanged(nameof(Num));
> }

- nameof(Num) == "Num", 즉 propertyName을 문자열로 받는다.

> public event PropertyChangedEventHandler PropertyChanged;
> private void OnPropertyChanged(string propertyName)
> {
>   PropertyChanged?.Invoke( this, new PropertyChangedEventArgs(propertyName));
> }

- 구현해야하는 메소드 OnPropertyChanged.
- PropertyChangedEventHandler: delegate, 속성이 변경될시 시행할 메소드 더미.
- this == object sender
- PropertyChangedEventArgs(...) == 
- **속성이 변하는 것을 알리면** 모델과 뷰 양쪽을 모두 바꾸는 핸들러를 호출한다.


> class YourCmd : ICommand

> <Button Command="{Binding 커맨드객체}"/>

커맨드 구현체, 멤버로 delegate를 가짐. delegate는 명령어 처리할 핸들러 함수따라 선언.
생성자 인자로 받는 외부 함수를 Inject 받아 실행하는 객체.
---