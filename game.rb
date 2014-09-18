require_relative 'piece'
require_relative 'board'
class Game

  def initialize
    @board = Board.new
    @turn = :red
  end

  def play
    until cant_move(@turn)
      @board.display
      take_turn
    end
  end

  def take_turn
    puts "It's #{@turn.to_s}'s turn. Type in a move or move sequence to make"
    moves = convert_move(gets.chomp)
    if moves.flatten.include?(nil)
      puts "can only move on the board"
      take_turn
    else
      spot = moves.shift
      if @board[spot] == nil
        puts "no piece over there to move. Enter a valid starting position"
        take_turn
      elsif @board[spot].color != @turn
        puts "You can only move your own piece. Enter a valid move"
        take_turn
      elsif !@board[spot].valid_move_seq?(moves)
        puts "That's not a valid move sequence"
        take_turn
      else
        (@board[spot]).perform_moves!(moves)
        switch_turn
      end
    end
  end

  def cant_move(color)
    it_cant = true
    pawns = @board.pieces.select{|piece| piece.color == color}
    pawns.each{ |pawn| it_cant = it_cant && !pawn.can_move?}
    it_cant
  end

  def switch_turn
    puts "switching the turn"
    if @turn == :black
      @turn = :red
    else
      @turn = :black
    end
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

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end