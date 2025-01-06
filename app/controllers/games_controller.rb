require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")
    @valid_in_grid = valid_in_grid?(@word, @letters)
    @valid_english = valid_english_word?(@word)

    if !@valid_in_grid
      @result = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}."
    elsif !@valid_english
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def valid_in_grid?(word, letters)
    letters_copy = letters.dup
    word.upcase.chars.all? do |char|
      if letters_copy.include?(char)
        letters_copy.delete_at(letters_copy.index(char))
        true
      else
        false
      end
    end
  end

  def valid_english_word?(word)
    url = URI("https://dictionary.lewagon.com/#{word}")
    response = Net::HTTP.get(url)
    json = JSON.parse(response)
    json["found"]
  end
end
