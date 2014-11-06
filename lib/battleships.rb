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
  attr_reader :board, :name
  attr_accessor :opponent
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
    puts "Player #{name}, please enter shot coordinates (x,y)"
    coordinates = gets.chomp.split(',').to_enum
    x , y = coordinates.next.to_i, coordinates.next.to_i
    opponent.board.shoot(x,y)
  end

  def show_boards
    puts "#{name}'s board"
    board.show
    puts "#{name}'s enemy tracking board"
    opponent.board.show(true)
  end
end

class Game
  def initialize
    player1 = Player.new("Adam")
    player2 = Player.new("Brenda")
    player1.opponent = player2
    player2.opponent = player1
    @current_player = player1
  end

  def play
    loop do
      @current_player.take_a_shot
      @current_player.show_boards
      break if @current_player.opponent.board.lost?
      @current_player = @current_player.opponent
    end
    puts "#{@current_player.name} won. Yay!"
  end

end

my_game = Game.new
my_game.play

