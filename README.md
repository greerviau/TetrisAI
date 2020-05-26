# TetrisAI

## Download and Run
To run the program you will need [Processing](https://processing.org/)

### [YouTube Video](https://www.youtube.com/watch?v=1yXBNKubb2o&t)

![tetris4](https://user-images.githubusercontent.com/36581610/78828900-6d6a2080-79b3-11ea-81a3-bd284849c3f2.gif)

## Scoring
* 1 Line cleared = 100 points
* 2 Line cleared = 200 points
* 3 Line cleared = 300 points
* 4 Lines cleared (1 Tetris) = 800 points
* Back-to-back Tetris = 1200 points

## Calculating Moves
When a piece comes into play, the system first calculates every possible position the piece can be placed. For each position, features about the resulting game state are calculated.
### Features
* Total difference in height of adjacent columns
* Holes (empty spaces that cannot be filled with a piece)
* Maximum height of the structure
* Minimum height of the structure
* Lines Cleared

These features are input to the neural network which outputs a score for that placement. This is repeated for every placement, and the placement with the highest score is selected. A moveset is returned which the system then executes to place the piece into the selected position.

There are 10 columns and 4 rotations so for every piece there are 40 positions to calculate.

## Training
A genetic algorithm is used to optimize the neural network. A population of 200 players are created and every generation players play the game until they loose. Once all the players in the population loose, the genetic algorithm selects the players with the highest scores and "breeds" them. Breeding consists of taking two players and combining random pieces of their neural networks. The resulting network is then mutated sligtly according to the mutation rate. This is done to create a new population of 200 players and the entire process is repeated.

## Next Piece Knowledge
As expected, when the AI is given the ability to predict the best move for the next piece, it will perform much better. With next piece knowledge, for each possible position of the current piece, every position for the next piece is calculated. The positions for the next piece are then scored using the neural network and the highest score is added to the score of the current piece position that is being tested. Doing this means that the best position of the current piece will result in the best position for the next piece.

Since for every piece there are atleast 40 positions to place a piece, with next piece knowledge there are roughly 40<sup>2</sup> moves to calculate or approximately 1600 moves.

![tetris2](https://user-images.githubusercontent.com/36581610/78828927-79ee7900-79b3-11ea-9b25-936f19c4bf4a.gif)
