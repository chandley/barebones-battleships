class Cell < Struct.new(:ship,:hit)

def display(tracking = false)
  case true
  when ship && hit
    'X'
  when ship && !hit
    tracking ? '~' : 'S'
  when !ship && hit
    '.'
  when !ship && !hit
    '~'
  else
    '?'
  end
end
end

class Board
  def initialize
    @cells = []
    100.times {@cells << Cell.new}
  end

  def rows
    @cells.each_slice(10).to_a
  end

  def cols
    rows.transpose
  end

   def place_ship(start_x,start_y,length,direction = rows)
     direction[start_x][start_y,length].each {|cell| cell.ship = true}
   end

  def show(tracking = false)
    rows.each do |row|
      row.each {|cell| print cell.display(tracking)}
      puts
    end
  end

  def shoot(x,y)
    rows[x][y].hit = true
  end

  def lost?
    cells.map{|cell| cell.display}.select{|cell| cell == 'S'}.size == 0 ? true : false
  end
end

my_board = Board.new
my_board.place_ship(2,2,2,my_board.cols)
my_board.show
my_board.shoot(2,2)
my_board.shoot(3,2)
my_board.show
puts "lost" if my_board.lost?

my_board.shoot(3,3)
my_board.show
puts "lost" if my_board.lost?


