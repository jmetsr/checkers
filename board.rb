require_relative 'piece'
class board
  def initialize
    @grid = Array.new(8){Array.new(8)}
    set_up_board
  end

  def set_up_board
    (0..7).each do |row_index|#loop through board positions
      0..7.each do |col_index|
        if starts_with_red([row_index, col_index]) #checks if spot gets a red piece
          Piece.new('red',[row_index, col_index],self) #sets up red piece
        elsif starts_with_black([row_index, col_index]) #check if spot gets black piece
          Piece.new('black',[row_index, col_index],self) #sets up black piece
        else
        end
      end
    end
  end

  def starts_with_red(pos)
    (pos[0]+ pos[1] % 2 == 0) && (pos[0] < 3)
  end

  def starts_with_black(pos)
    (pos[0]+ pos[1] % 2 == 0) && (pos[0] > 4)
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos,object)
    @board[pos[0]][pos[1]] = object
  end


end

