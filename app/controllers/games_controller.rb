require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample.upcase
    end
  end

  def score
    # raise # => to check if the form is being correctly set
    @attempt = params[:player_suggestion]
    @letters = params[:letters].split(' ')

    # Session is a big hash which already exists like params
    # 1. Get the content of score
    @score = session[:score]
    # 2.a if the key 'score' doesn't exist in session, the score is initialized
    # 2.b if the score is already present, it is increased
    if @score.blank?
      @score = @attempt.length**2
    else
      @score += @attempt.length**2
    end
    # 3. assign the new score value to the session
    session[:score] = @score

    if !test_word_in_grid(@attempt, @letters)
       @game_output = "not_in_grid"
     elsif test_english_word(@attempt) == false
       @game_output = "not_english"
     else
      @game_output = "congratulations"

     end
  end


# hidden_field_tag 'tags_list'
# # => <input id="tags_list" name="tags_list" type="hidden" />

# hidden_field_tag 'token', 'VUBJKB23UIVI1UU1VOBVI@'
# # => <input id="token" name="token" type="hidden" value="VUBJKB23UIVI1UU1VOBVI@" />

# hidden_field_tag 'collected_input', '', onchange: "alert('Input collected!')"
# # => <input id="collected_input" name="collected_input" onchange="alert('Input collected!')"
# #    type="hidden" value="" />

  private

  def test_word_in_grid(attempt, grid)
    attempt_letters = attempt.upcase.chars
    word_in_grid = true
    attempt_letters.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        word_in_grid = false
      end
    end
    return word_in_grid
  end

  def test_english_word(attempt)
    attempt.downcase!
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_test_serialized = open(url).read
    word_test = JSON.parse(word_test_serialized)
    return word_test["found"] # => true or false
  end
end
