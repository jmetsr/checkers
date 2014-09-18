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
    return true
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

  def promote
    king = true
  end

  def maybe_promote?
    if position[0] == 7 && color == "red"
      return true
    elsif position[0] == 0 && color == "black"
      return true
    else
      return false
    end
  end

  def slide_dirs
    return [[1,-1], [1, 1]] if color == "red" && king == false
    return [[-1,1],[-1,-1]] if color == "black" && king == false
    return [[1,-1], [1, 1], [-1,1],[-1,-1]] if king
  end

  def jump_dirs
    return [[2, 2],[-2, 2]] if color == 'red' && king == false
    return [[2,-2],[-2,-2]] if color == 'black' && king == false
    return [[2,-2],[-2,-2],[2, 2],[-2, 2]] if king
  end

  def render
    return "r" if self.color == "red" && !self.king
    return "b" if self.color == "black" && !self.king
    return "R" if self.color == "red" && self.king
    return "B" if self.color == "black" && self.king
  end

  def on_board?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def piece_to_jump_over(jump_move) #returns pos of piece to jump
    return vector_addition([1,  1],position) if jump_move == [ 2, 2]
    return vector_addition([-1,-1],position) if jump_move == [-2,-2]
    return vector_addition([-1, 1],position) if jump_move == [-2, 2]
    return vector_addition([ 1,-1],position) if jump_move == [ 2,-2]
  end

  def vector_addition(pos1,pos2)
    [pos1[0]+pos2[0],pos1[1]+pos2[1]]
  end
  def vector_subtraction(pos1,pos2)
    [pos1[0]-pos2[0],pos1[1]-pos2[1]]
  end
  def set_position(pos)
    @position = pos
    @board[pos] = self
  end

end