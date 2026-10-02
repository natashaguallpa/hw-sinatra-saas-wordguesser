require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  # Default landing page redirects to new game
  get '/' do
    redirect '/new'
  end

# Renders the new game form
  get '/new' do
    erb :new
  end

  # Starts a new game session with a word
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  # Processes an incoming letter guess
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###
    # Try to make a guess using our model
    begin
      # If guess returns false, it was already guessed
      unless @game.guess(letter)
        flash[:message] = "You have already used that letter."
      end
    rescue ArgumentError
      # If guess throws an ArgumentError, it was nil, empty, or non-alphabet
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  # Main game board view
  get '/show' do
    ### YOUR CODE HERE ###
    status = @game.check_win_or_lose
    if status == :win
      redirect '/win'
    elsif status == :lose
      redirect '/lose'
    else
    erb :show # You may change/remove this line
  end
end

  get '/win' do
    ### YOUR CODE HERE ###
    redirect '/show' unless @game.check_win_or_lose == :win
    erb :win # You may change/remove this line
  end

  get '/lose' do
    ### YOUR CODE HERE ###
    redirect '/show' unless @game.check_win_or_lose == :lose
    erb :lose # You may change/remove this line
  end
end