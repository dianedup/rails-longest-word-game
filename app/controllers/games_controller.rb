class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample.upcase
    end
  end

  def score
    # raise => to check if the form is being correctly set
  end
end
