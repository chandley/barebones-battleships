# SHIPS = {'battleship' => 5, 'cruiser' => 3}
SHIPS = {'torpedo_boat' => 2}

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
    @cells.select{|cell| cell.ship  && !cell.hit}.size == 0 ? true : false
  end
end

class Player
  attr_reader :board
  def initialize(name)
    @name = name
    @board = Board.new
    place_all_ships
  end

  def place_all_ships
    SHIPS.each do |ship, length| 
      puts "Player #{@name}, please place your #{ship}, size #{length}"
      puts "enter start coordinates (x,y)"
      coordinates = gets.chomp.split(',').to_enum
      x , y = coordinates.next.to_i, coordinates.next.to_i
      puts "across? (y,n)?"
      direction = gets.chomp.downcase == 'y' ? @board.rows : @board.cols
      @board.place_ship(x,y,length,direction)
    end
  end

  def take_a_shot
    puts "enter shot coordinates (x,y)"
    coordinates = gets.chomp.split(',').to_enum
    x , y = coordinates.next.to_i, coordinates.next.to_i
    @board.shoot(x,y)
  end
end

chris = Player.new("Chris")
until chris.board.lost? do
  chris.take_a_shot
  chris.board.show
end
puts "you lost!"

