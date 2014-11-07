Battleships Spike Exercise

I wanted to see if I could express a simple view of the essential components of a battleships game. This does give a playable game, although it is not a complete game

Problems

* no error checking of user input. Game will crash with bad input
* placing a ship down does not work properly (cell coordinates get switched)
* ships can overlap, and cells can be shot at more than once

Key simplifications are

* The opponents tracking view of your board is your view with some information removed
* You don't need to keep track of the ships after they are placed, you just need to count the number of unhit ship cells. When this reaches zero on your board, you lose. This makes the ships look like data, rather than a class.
* Having the data organised by rows and columns simplifies the placing of the ship, and the display.
* Easiest to place ships when initializing board

