# SHIPS = {'battleship' => 5, 'cruiser' => 4, 'destroyer => 3'}
SHIPS = { 'torpedo_boat' => 2 }
SIZE = 10


class Cell < Struct.new( :ship , :hit )

  def display( tracking = false )
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
    (SIZE**2).times {@cells << Cell.new}
  end

  def rows
    @cells.each_slice(SIZE).to_a
  end

  def cols
    rows.transpose
  end

   def place_ship(start_x,start_y,length,direction = rows)

     direction[start_x][start_y, length].each do |cell|
      # rescue raise "Invalid coordinates"
       # raise "Invalid coordinates" if cell.is_nil?
       raise "Already placed ship there" if cell.ship
       cell.ship = true
     end
   end

  def show(tracking = false)
    rows.each do |row|
      row.each {|cell| print cell.display(tracking)}
      puts
    end
  end

  def show_data(tracking = false)
    display_array = rows.map do |row|
      row.map {|cell| cell.display(tracking)}
    end
    return display_array
  end

  def shoot(x,y)
    # raise "Invalid coordinates" if rows[x][y].is_nil?
    raise "Already shot there" if rows[x][y].hit
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

      # show ship name, length, get x,y direction from user

      puts "Player #{@name}, please place your #{ship}, size #{length}"
      puts "enter start coordinates (x,y)"
      coordinates = gets.chomp.split(',').to_enum # this is probably a bad way to do this
      x , y = coordinates.next.to_i, coordinates.next.to_i
      puts "across? (y,n)?"
      direction = gets.chomp.downcase == 'y' ? @board.rows : @board.cols
      @board.place_ship(x,y,length,direction) # need to swap coordinates if using cols
    end
  end

  def take_a_shot
    # get shot x,y from user


    puts "Player #{name}, please enter shot coordinates (x,y)"
    coordinates = gets.chomp.split(',').to_enum
    x , y = coordinates.next.to_i, coordinates.next.to_i
    opponent.board.shoot(x,y)
  end

  def show_boards
    # do this in HTML
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

