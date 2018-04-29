# ruby로 lotto 뽑아보자
> lotto API와 JSON 파싱(parsing)을 사용해 로또 뽑아봅시다

## 레일즈 프로젝트 생성하기
레일즈 프로젝트를 만듭니다.
```bash
$ rail new hellolotto
```
생성된 Rails 프로젝트 폴더로 이동합니다.
```bash
$ cd hellolotto
```

## controller 만들기
$ 표시가 있으면 cmd 혹은 bash에 입력하는 명령어입니다. 

```bash
$ rails g controller lottos index
```  
> 레일즈야 만들자 컨트롤러 이름은 lottos이고 index 액션도 만들어   

#### API란?
위키피디아의 정의를 찾아보자
> API(Application Programming Interface, 응용 프로그램 프로그래밍 인터페이스)는 응용 프로그램에서 사용할 수 있도록,  
> 운영 체제나 프로그래밍 언어가 제공하는 기능을 제어할 수 있게 만든 인터페이스를 뜻한다.   
> 주로 파일 제어, 창 제어, 화상 처리, 문자 제어 등을 위한 인터페이스를 제공한다.

..?! 비개발자 입장에선 아무리 읽어봐도 무슨 소리인지 이해가 안간다.  

프로그래밍의 구조를 무시하고 결론부터 이야기하면  
**누군가 고생하며 만들어둔 기능**을 **내가 편하게 사용할 수 있게 모듈화**한 것이다. 

프로그래밍의 구조를 알아야 이해할 수 있으니 궁금한 분들은   
생활코딩의 [UI와 API](https://www.youtube.com/watch?v=Z4kH0IZVT-8&t=95s) 동영상을 보기 바란다.  

#### JSON이란?
위키피디아의 정의를 찾아보자 
> JSON(JavaScript Object Notation)은 속성-값 쌍(attribute–value pairs and array data type)으로 이루어진 데이터 오브젝트를 전달하기 위해  
> 인간이 읽을 수 있는 텍스트를 사용하는 개방형 표준 포맷이다.   
> 비동기 브라우저/서버 통신 (AJAX)을 위해, 넓게는 XML(AJAX가 사용)을 대체하는 주요 데이터 포맷이다.  
> 특히, 인터넷에서 자료를 주고 받을 때 그 자료를 표현하는 방법으로 알려져 있다.  
> 자료의 종류에 큰 제한은 없으며, 특히 컴퓨터 프로그램의 변수값을 표현하는 데 적합하다.
> 본래는 자바스크립트 언어로부터 파생되어 자바스크립트의 구문 형식을 따르지만 언어 독립형 데이터 포맷이다.  
> 즉, 프로그래밍 언어나 플랫폼에 독립적이므로, 구문 분석 및 JSON 데이터 생성을 위한 코드는  
> C, C++, C#, 자바, 자바스크립트, 펄, 파이썬 등 수많은 프로그래밍 언어에서 쉽게 이용할 수 있다.

...&#$?! API보다 더 어렵다  
다른 블로그를 찾아봤다  
> JSON은 **경량의 DATA-교환** 형식  
> **Javascript**에서 객체를 만들 때 사용하는 표현식을 사용  
> JSON 표현식은 **사람과 기계 모두 이해하기 쉬우며** 용량이 작아서, 최근에는 JSON이 XML을 대체해서 데이터 전송 등에 많이 사용  
> **특정 언어에 종속되지 않으며**, 대부분의 프로그래밍 언어에서 JSON 포맷의 데이터를 핸들링 할 수 있는 라이브러리를 제공  

정리해서  
JSON은 **특정 언어에 상관없이 사용하기 편한 데이터**로 기억하자

수많은 데이터 중 원하는 key를 넣으면 해당하는 value를 보여준다  
```javascript
{
    key: value,
    이름: "홍길동",
    성별: "남자",
    나이: 25,
    국적: "대한민국"
}
```
예를 들면,  
`이름`을 넣으면 `"홍길동"`,  
`성별`을 넣으면 `"남자"`,  
`나이`를 넣으면 `25`,  
`국적`을 넣으면 `"대한민국`"  
이런식이다.

#### Hash
위키피디아의 정의를 찾아보자  
> 해시 테이블(hash table), 해시 맵(hash map), 해시 표는 컴퓨팅에서 키를 값에 매핑할 수 있는 구조인, 연관 배열 추가에 사용되는 자료 구조이다.  
> 해시 테이블은 해시 함수를 사용하여 색인(index)을 버킷(bucket)이나 슬롯(slot)의 배열로 계산한다.

이 자식들은 외계어로 백과사전 만드나..  
[나무위키](https://namu.wiki/w/%ED%95%B4%EC%8B%9C#s-2)는 좀더 친절히 설명 해두었다. 궁금하면 들어가보자

해쉬는 루비가 데이터를 다루는 방식 중 하나라고 생각하자
javascript과 동일하게 원하는 key를 넣으면 해당하는 value를 보여준다.
```javascript
{
    key: value
}
```


## ruby로 데이터 긁어오기
```ruby
# 웹 페이지 open 에 필요
require 'json'
# JSON을 Hash로 변환하는데 필요
require 'open-uri'

# page에 나눔로또 API 웹 페이지를 열어 저장. 
# 18년 4월 21일 기준 803회차
page = open('http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803')
    
# lotto_info 에 page 내용 (JSON 형식의 data) 을 읽어서 저장.
lotto_info = page.read

# lotto_hash에 JSON 형식인 lotto_info 를 Hash로 파싱(변환)하여 저장
lotto_hash = JSON.parse(lotto_info)

# Hash로 변환된 데이터가 출력
puts lotto_hash
```
데이터를 가져옵니다
```javascript
{"bnusNo"=>2, "firstAccumamnt"=>18319051125, "firstWinamnt"=>3663810225, "returnValue"=>"success", "totSellamnt"=>75670793000, "drwtNo3"=>14, "drwtNo2"=>9, "drwtNo1"=>5, "drwtNo6"=>43, "drwtNo5"=>30, "drwtNo4"=>26, "drwNoDate"=>"2018-04-21", "drwNo"=>803, "firstPrzwnerCo"=>5}
```
이는 컴퓨터가 보기 좋은 상태고 사람이 보기 좋게 들여쓰기 및 정리 해줍니다.
```javascript
{
    "bnusNo"=>2, 
    "firstAccumamnt"=>18319051125, 
    "firstWinamnt"=>3663810225, 
    "returnValue"=>"success", 
    "totSellamnt"=>75670793000, 
    "drwtNo3"=>14, 
    "drwtNo2"=>9, 
    "drwtNo1"=>5, 
    "drwtNo6"=>43, 
    "drwtNo5"=>30, 
    "drwtNo4"=>26, 
    "drwNoDate"=>"2018-04-21", 
    "drwNo"=>803, 
    "firstPrzwnerCo"=>5
}
```
한결 낫네요. 보너스번호(`"bnusNo"`), 당첨번호(`"drwtNo"`), 추첨일수(`"drwNoDate"`), 추첨회차(`"drwNo"`) 등 여러 정보가 들어있음을 볼 수 있습니다.

위의 ruby 코드를 줄이면
```ruby
# 웹 페이지 open 에 필요
require 'json'
# JSON을 Hash로 변환하는데 필요
require 'open-uri'

# 나눔로또 API 웹페이지 열고 JSON을 읽어와 hash로 변환해 저장하는 한줄 코드입니다. 
data = JSON.parse(open("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803").read)

```
핵심 로직을 한줄로 줄일 수 있습니다.
## 원하는 데이터를 배열에 넣기
```javascript
{
    key1: value1,
    key2: value2,
    key3: value3,
    ...
}
```
`key: value` 형태로 가져온 데이터엔 당첨번호, 추첨일수, 추첨회차 등 여러 정보가 들어있습니다.  
이 중 당첨번호(`drwtNo`)와 보너스번호(`bnusNo`)를 뽑아봅니다  
```ruby
require 'json'
require 'open-uri'

data = JSON.parse(open("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803").read)
# 여기까진 위에서 정리한 코드들입니다. 

# 로또 번호 넣을 배열 @jackpot입니다. 
# 맞추면 인생 편해집니다. 미리 알 수 있을까요?
@jackpot = []

# 파싱한 데이터에서 로또 번호만 가져옵니다.
# API에서 "drwtNo어쩌구 : 로또 번호"를 긁어 @jackpot에 넣습니다 
data.each do |key, value|
    # 데이터 중 당첨번호를 골라내 jackpot 배열에 넣습니다
    @jackpot << value if key.include? 'drwtNo'
end
# 정렬되지 않은 데이터가 배열에 들어갑니다
# [26, 30, 43, 5, 9, 14]


# 번호를 정렬해 저장합니다
@jackpot.sort!
# [5, 9, 14, 26, 30, 43] 

# 보너스 번호도 뽑습니다 
@bonusNum = data["bnusNo"]
```
## 내 번호 뽑기
#### 배열
컴퓨터가 자료를 저장하는 방법 중 하나인 배열은 필수적입니다.  
형태를 비유로 들자면 상자가 일렬로 늘어져 있는 상태입니다.  
위에서 `jackpot = [ ]`라고 썼었죠? 이는 `배열 = [ ]`로 빈 배열인 상태입니다.  
`배열 = [요소1, 요소2, 요소3, ...]` 이런식으로 문자열, 정수 등 여러 요소를 집어넣습니다.    

이제 1에서 10의 숫자 중 하나를 뽑아봅시다.
```ruby
number = [1,2,3,4,5,6,7,8,9,10]
puts number.sample
# 3 - 하나의 숫자가 뽑힙니다
```
1에서 10의 숫자 중 세개를 뽑아봅시다.
```ruby
# number = [1,2,3,4,5,6,7,8,9,10]를 아래의 식으로 쓸 수 있습니다.
# 숫자가 커진다면 아래 방식이 편하겠죠?
number = (1..10).to_a
puts number.sample(3)
# 3
# 6
# 5 - 세개의 숫자가 뽑힙니다
```
이제 나만의 로또 번호를 뽑아봅시다
```ruby
# 랜덤으로 내 번호 6개 뽑습니다
myNumber = (1..45).to_a.sample(6)
```
정렬까지 해봅시다
```ruby
# 랜덤으로 내 번호 6개 뽑아 정렬합니다
myNumber = (1..45).to_a.sample(6).sort
```

## 로또 등수 확인
* 6개 다 맞추면 1등  
* 5개 맞추고 보너스 번호 맞으면 2등
* 5개 맞추면 3등
* 4개 맞우면 4등

#### `&` 
정렬된 `@jackpot`과 `myNumber`의 요소를 순서대로 비교해  
순서마다 동일한 경우 살려두고 다른 경우엔 없애버립니다.

```ruby
number = [1,2,3,4,5,6,7,8,9,10] # 1 부터 10의 자연수
even   = [2,4,6,8,10]             # 1부터 10 중에 짝수
odd    = [1,3,5,7,9]               # 1부터 10 중에 홀수

puts number & even 
# [2, 4, 6, 8, 10] number와 even 중 겹치는 짝수만 살립니다
puts number & odd  
# [1, 3, 5, 7, 9] number 와 odd 중 겹치는 홀수만 살립니다 
```

```ruby
# 겹치는 숫자 파악합니다
@overlap = @jackpot & @myNumber
    
# 겹치는 숫자 개수를 파악합니다
@score = (@overlap).length

if @score == 6
    @answer = "축하합니다. 1등이에요!!"	
elsif @score == 5 && myNumber.include?(@bonusNum)
    @answer = "하하하. 2등이에요!"	
elsif @score == 5
    @answer = "헤헤헤. 3등이에요"	
elsif @score == 4
    @answer = "하하하. 4등이에요"	
elsif @score == 5
    @answer = "5등이군요"
else
    @answer = "로또 하지마.."
end
```

## `lotto_controller.rb`에 합치기 
```ruby
# 나눔 로또의 로또 API를 사용합니다
# open-uri로 나눔 로또 홈페이지를 열고
# json으로 데이터를 파싱해 옵니다

# 웹 페이지 open 에 필요
require 'json'
# JSON을 Hash로 변환하는데 필요
require 'open-uri'
class LottosController < ApplicationController
  def index
    # page에 나눔로또 API 웹 페이지를 열어 저장. 
    # 18년 4월 21일 기준 803회차
    # page = open('http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803')
        
    # lotto_info 에 page 내용 (JSON 형식의 data) 을 읽어서 저장.
    # lotto_info = page.read

    # lotto_hash에 JSON 형식인 lotto_info 를 Hash로 파싱(변환)하여 저장
    # lotto_hash = JSON.parse(lotto_info)

    # 위의 코드들을 1줄로 줄인 코드, data에 긁어온 hash가 저장되어 있음 
    
    # 나눔로또 API 웹페이지 열고 JSON을 읽어와 hash로 변환해 저장하는 한줄 코드입니다. 
    data = JSON.parse(open("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803").read)
    
    # 로또 번호 넣을 배열 @jackpot입니다. 
    # 맞추면 인생 편해집니다. 미리 알 수 있을까요?
    @jackpot = []

    # 파싱한 데이터에서 로또 번호만 가져옵니다.
    # API에서 "drwtNo어쩌구 : 로또 번호"를 긁어 @jackpot에 넣습니다 
    data.each do |key, value|
        # 데이터 중 당첨번호를 골라내 jackpot 배열에 넣습니다
        @jackpot << value if key.include? 'drwtNo'
    end
    # 정렬되지 않은 데이터가 배열에 들어갑니다
    # [26, 30, 43, 5, 9, 14]


    # 번호를 정렬해 저장합니다
    @jackpot.sort!
    # [5, 9, 14, 26, 30, 43] 

    # 보너스 번호도 뽑습니다 
    @bonusNum = data["bnusNo"]

    # 랜덤으로 내 번호 6개 뽑아 정렬합니다
    @myNumber = (1..45).to_a.sample(6).sort

    # 겹치는 숫자 파악합니다
    @overlap = @jackpot & @myNumber

    # 겹치는 숫자 개수를 파악합니다
    @score = @overlap.length

    if @score == 6
        @answer = "축하합니다. 1등이에요!!"	
    elsif @score == 5 && myNumber.include?(@bonusNum)
        @answer = "하하하. 2등이에요!"	
    elsif @score == 5
        @answer = "헤헤헤. 3등이에요"	
    elsif @score == 4
        @answer = "하하하. 4등이에요"	
    elsif @score == 5
        @answer = "5등이군요"
    else
        @answer = "로또 하지마.."
    end
  end
end
```  
## 사용자에게 보여줄 view(`index.html.erb`) 만들기 
HTML만으로 형태를 만듭니다
```erb
<h1>당첨 번호 :<%= @jackpot %></h1>
<h1>내 번호  :<%= @myNumber %></h1>
<h1>겹치는 번호 : <%= @overlap %></h1>
<h1><%= @answer %></h1>
```
## `routes.rb`

```ruby
Rails.application.routes.draw do
  root 'lottos#index'
end
```

## `application.html.erb`    
#### `bootstrap CDN` 붙이기   
#### 나눔로또 `favicon` 붙이기  
**favicon**은 브라우저 상단 탭에 있는 작은 이미지 입니다.
#### 내용을 `container`에 집어넣기
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>Hellolotto</title>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- favicon -->
	<link rel="icon" href="http://www.nlotto.co.kr/img/common/favicon.ico" type="image/x-icon">
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
    <!-- bootstrap CDN -->
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
  </head>

  <body>
   <!-- 내용을 container에 집어넣자 -->
  	<div class="container">
		<%= yield %>
	</div>
  </body>
</html>
```

## Bootstrap 사용한 view(`index.html.erb`)
```erb
<div class="alert alert-primary" role="alert">  
	<p>이번 주 로또 번호!!</p>
	<% @jackpot.each do |img| %>
		<img src="http://www.nlotto.co.kr/img/index/main_ball_<%= img %>.gif" >
	<% end %>
</div>
<div class="alert alert-success" role="alert">  
	<p>내가 뽑은 번호</p>
	<% @myNumber.each do |img| %>
		<img src="http://www.nlotto.co.kr/img/index/main_ball_<%= img %>.gif" >
	<% end %>
</div>
<div class="alert alert-danger">
	<p><%= @answer %></p>
</div>
<!-- root로 가는 새로고침 버튼-->
<a href="/" class="btn btn-primary">한번 더?</a>
```


