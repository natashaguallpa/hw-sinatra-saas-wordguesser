class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses


  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

# You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word


 def guess(letter)
    # 1. Validation: Ensure input is provided and is a valid single letter
    # If the user passed nil, an empty string, or non-alphabet characters, raise an ArgumentError
    raise ArgumentError, 'Guess cannot be nil' if letter.nil?
    raise ArgumentError, 'Guess cannot be empty' if letter.empty?
    raise ArgumentError, 'Guess must be a single letter' unless letter =~ /^[a-zA-Z]$/

    # 2. Case insensitivity: Treat uppercase and lowercase letters the same
    letter = letter.downcase

    # 3. Repeated guess check: If already guessed (correctly or incorrectly), return false
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    # 4. Check against secret word: Add to @guesses if found, otherwise to @wrong_guesses
    if @word.downcase.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end

    # Return true indicating a new, valid guess was processed
    true
  end

  def word_with_guesses
    # Build the display string representing the word progress (e.g., "-a-a-a")
    result = ''
    @word.each_char do |char|
      # If this character has been guessed, show it; otherwise hide it with '-'
      if @guesses.include?(char.downcase)
        result << char
      else
        result << '-'
      end
    end
    result
  end

  def check_win_or_lose
    # 7 or more incorrect guesses ends the game in a loss
    return :lose if @wrong_guesses.length >= 7

    # If every character in the secret word has been guessed, the player wins
    return :win if @word.chars.all? { |char| @guesses.include?(char.downcase) }

    # If not won and not lost, the game continues
    :play
  end
  
  # Fetches a random word from the remote web service
  def self.get_random_word
    require 'uri'
    require 'net/http'

    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      return http.post(uri, '').body
    end
  end
end