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
  def pickNcheck    
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
  def rubyParsing
    # page에 해당 웹 페이지를 열어 저장. 
    # 18년 4월 21일 기준 803회차
    page = open('http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803')
     
    # lotto_info 에 page 내용 (JSON 형식의 data) 을 읽어서 저장.
    lotto_info = page.read

    # lotto_hash에 JSON 형식인 lotto_info 를 Hash로 파싱(변환)하여 저장
    lotto_hash = JSON.parse(lotto_info)
    
    # Hash로 변환된 데이터가 출력
    puts lotto_hash
  end
  def dataToArray
    data = JSON.parse(open("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=803").read)
    # 여기까진 위에서 정리한 코드들입니다. 

    # 로또 번호 넣을 배열 @jackpot입니다. 
    # 맞추면 인생 편해집니다. 미리 알 수 있을까요?
    @jackpot = []

    # 파싱한 데이터에서 로또 번호만 가져옵니다.
    # API에서 "drwtNo어쩌구 : 로또 번호"를 긁어 @jackpot에 넣습니다 
    data.each do |key, value|
        # 데이터 중 당첨번호를 골라내 @jackpot 배열에 넣습니다
        @jackpot << value if key.include? 'drwtNo'
    end
    # 정렬되지 않은 데이터가 배열에 들어갑니다
    # [26, 30, 43, 5, 9, 14]


    # 번호를 정렬해 저장합니다
    @jackpot.sort!
    # [5, 9, 14, 26, 30, 43] 
  end

end
