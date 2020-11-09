class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_reader :word
  attr_accessor :word_with_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses=''
    @word_with_guesses='-'*@word.length
    @count = 0
  end

  def guesses
    @guesses
  end
  
  def wrong_guesses
    @wrong_guesses  
  end
  
  def guess(letter)
    @count+=1
    
    if letter.nil?
      raise ArgumentError
    elsif letter.match(/[^a-zA-Z]/)
      raise ArgumentError
    elsif letter.empty?
      raise ArgumentError
    end
    
    if letter.upcase == letter
      return false
    end
    
    if @word.include?letter # 정답에 포함될때
    
      if @word_with_guesses.include?letter # 이미 한번 추측한 문자는 제외
        return false
      end
      
      @guesses=letter
      for i in 0...@word.length
        if @word[i]==@guesses
          @word_with_guesses[i]=@guesses # 적절한 자리에 '-'를 문자로 대체
        end
      end
      return true
    else
      return false if @wrong_guesses==letter
      @wrong_guesses=letter
      return true # spec 45~46
    end
  end
  
  def check_win_or_lose
    return :win if @word == @word_with_guesses
    return :lose if @count>=7
    return :play if @count<7
  end
  

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
