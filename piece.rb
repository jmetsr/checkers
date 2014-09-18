class Piece
  attr_accessor :king, :position, :board
  attr_reader :color

  def initialize(color,position,board,king=false)
    @color = color
    @board = board
    @king = king

    set_position(position)
  end

  def perform_slide(end_pos)
    move = vector_subtraction(end_pos,position)
    return false if board[end_pos] != nil
    return false if !slide_dirs.include?(move)
    return false if !on_board?(end_pos)

    set_position(end_pos)
    promote if maybe_promote?
    true
  end

  def perform_jump(end_pos)
    move = vector_subtraction(end_pos,position)

    return false if board[end_pos] != nil
    return false if !jump_dirs.include?(move)
    return false if !on_board?(end_pos)
    return false if board[piece_to_jump_over(move)] == nil
    return false if board[piece_to_jump_over(move)].color == color

    board[piece_to_jump_over(move)] = nil
    set_position(end_pos)
    promote if maybe_promote?

    true
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      unless perform_slide(move_sequence[0])
        unless perform_jump(move_sequence[0])
          raise InvalidMoveError.new "not a valid move sequence"
        end
      end
    else
      move_sequence.each do |move|
         unless perform_jump(move)
           raise InvalidMoveError.new "not a valid move sequence"
         end
      end
    end

    nil
  end

  def valid_move_seq?(move_sequence)
    new_board = @board.dup
    begin
      new_board[@position].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      return false
    else
      return true
    end

  end

  def dup(new_board)
    Piece.new(@color,@position.dup,new_board,@king)
  end

  def promote
    @king = true
  end

  def maybe_promote?
    (position[0] == 7 && color == :red) || (position[0] == 0 && color == :black)
  end

  def slide_dirs
    return [[1,-1], [1, 1]] if color == :red && king == false
    return [[-1,1],[-1,-1]] if color == :black && king == false
    return [[1,-1], [1, 1], [-1,1],[-1,-1]] if king
  end

  def jump_dirs
    return [[2, 2],[2, -2]] if color == :red && king == false
    return [[-2,2],[-2,-2]] if color == :black && king == false
    return [[2,-2],[-2,-2],[2, 2],[-2, 2]] if king
  end

  def render
    return "r" if self.color == :red && !self.king
    return "b" if self.color == :black && !self.king
    return "R" if self.color == :red && self.king
    return "B" if self.color == :black && self.king
  end

  def on_board?(pos)
    pos.all? { |x| x.between?(0,7) }
  end

  def piece_to_jump_over(jump_move) #returns pos of piece to jump
    case jump_move
    when [2,  2]
      return vector_addition([1,  1],position)
    when [-2,-2]
      return vector_addition([-1,-1],position)
    when [-2, 2]
      return vector_addition([-1, 1],position)
    when [ 2,-2]
      return vector_addition([ 1,-1],position)
    end
  end

  def can_move?
    possible_moves = []
    slide_dirs+jump_dirs.each do |move|
      possible_moves += vector_addition(@position,move)
    end
    return false if possible_moves == []
    can_i = true
    possible_moves.each { |move| can_i = can_i || valid_move_seq?([move])}

    can_i
  end

  def vector_addition(pos1,pos2)
    [pos1[0]+pos2[0],pos1[1]+pos2[1]]
  end
  def vector_subtraction(pos1,pos2)
    [pos1[0]-pos2[0],pos1[1]-pos2[1]]
  end
  def set_position(pos)
    @board[@position] = nil unless @position == nil
    @position = pos
    @board[pos] = self
  end

end

class InvalidMoveError < StandardError
end