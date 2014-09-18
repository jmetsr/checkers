require_relative 'piece'
class Board
  def initialize
    @grid = Array.new(8){Array.new(8)}
    set_up_board
  end

  def slide(start_pos,end_pos)
    if self[start_pos] != nil
      self[start_pos] = nil if self[start_pos].perform_slide(end_pos)
    end
  end

  def display
    puts render
  end

  def jump(start_pos,end_pos)
    if self[start_pos] != nil
      self[start_pos] = nil if self[start_pos].perform_jump(end_pos)
    end
  end

  def set_up_board
    (0..7).each do |row_index|#loop through board positions
      (0..7).each do |col_index|
        if starts_with_red([row_index, col_index]) #checks if spot gets a red piece
          Piece.new(:red,[row_index, col_index],self) #sets up red piece
        elsif starts_with_black([row_index, col_index]) #check if spot gets black piece
          Piece.new(:black,[row_index, col_index],self) #sets up black piece
        else
        end
      end
    end
  end

  def starts_with_red(pos)
    ((pos[0]+ pos[1]) % 2 == 0) && (pos[0] < 3)
  end

  def starts_with_black(pos)
    ((pos[0]+ pos[1]) % 2 == 0) && (pos[0] > 4)
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos,object)
    @grid[pos[0]][pos[1]] = object
  end

  def render
    top_row = ""
    ('a'..'h').each{|letter| top_row += (' ' + letter)}
    bottom_rows = ""
    (0..7).each do |i|
      row = "#{i+1}"
      (0..7).each do |col|
        if self[[i,col]] == nil
          row += "\u25A1"+" "
        else
          row += self[[i,col]].render+" "
        end
      end
      bottom_rows += row + "\n"
    end
    top_row + "\n" + bottom_rows
  end

  def inspect
    ""
  end
end

