require_relative 'piece'
require_relative 'board'
class Game

  def initialize
    board = Board.new
    @turn = :red
  end

  def play
  end

  def take_turn
  end

  def convert_move(string)
    move = []
    string.split.each{ |spot| move += [convert_spot(spot)]}
    move
  end

  def convert_spot(string)
    letter_hash = ("a".."h").to_a.zip(0..7).to_a.to_h
    [string[1].to_i-1] + [letter_hash[string[0]]]
  end



end