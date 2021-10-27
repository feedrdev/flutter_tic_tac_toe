# tic_tac_toe

Tic Tac Toe Game

The machine always plays the "perfect" strategy to win:

1. If next move can win it will take that move
2. If other player can win it defends by blocking that move
3. If next move can "fork" (create two winning planes) it will take that move
4. If other player can "fork", block their move
5. If can move into the center, take it
6. If center is taken, move into a vacant corner
7. Otherwise grab whatever tile is left

## Getting Started

Flutter SDK is required to build this project.
Tested to build for iOS, Android. macOS and Web.

Try out the hosted Web App here:
https://tic-tac-toe-52f8d.firebaseapp.com/