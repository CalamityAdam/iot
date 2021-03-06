# Tic Tac Toe

## Learning Goals

+ Be able to write object-oriented JavaScript programs comfortably
+ Be comfortable using readline in Node
+ Know how to approach creating an AI

[Here][ruby-ttt]'s a link to the old instructions for Tic Tac Toe.

* Write a `Board` class in `ttt/board.js`.
  * There should be no UI in your `Board`, except maybe to
    `console.log` a representation of the grid.
* Write a `Game` class in `ttt/game.js`. You'll want to require your
`ttt/board.js` file.
* Write the `Game` constructor such that it takes a reader interface as an 
argument. As in the previous exercise, write a `run` method that takes in both
this reader and a completion callback (`Game.prototype.run(reader, 
completionCallback)`).
* Copy your `playScript.js` from [Hanoi Node][node-ttt]. It should work for Tic Tac Toe as well.

## Bonus
* Build an AI for your game. Try to make it unbeatable.

[ruby-ttt]: https://github.com/appacademy/curriculum/blob/master/javascript/projects/ttt_node/ruby_ttt.md
[node-ttt]: https://github.com/appacademy/curriculum/blob/master/javascript/projects/ttt_node/hanoi_node
