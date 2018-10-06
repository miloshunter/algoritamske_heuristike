# Algorithm Heuristics

## A* maze search
The problem of maze search is solved using 3 different algorithm:
	-	Breadth first search
	-	Greedy Best first search
	-	A* (A star) search
The simulation is drawn and one can see the algorithm working realtime
	
## Genetic algorithms
### Implementation of Genetic Altorithm for function minimization
Custom length-bit string representation of a float number
For mutation flipping of random bit is used
For crossover two bitstrings are split and mixed at random point
### 3-SAT functions that can be solved with Matlab's optimtool
Equation:
![equation](https://latex.codecogs.com/gif.latex?f%5E%7B1%7D%28x_%7B1%7D%2C...%2Cx_%7B6%7D%29%20%3D%20%28x_%7B1%7D%20&plus;%20x_%7B2%7D%20&plus;%20x_%7B3%7D%29%5Ccdot%28%5Coverline%7Bx_%7B2%7D%7D%20&plus;%20x_%7Bx4%7D&plus;%5Coverline%7Bx_%7B5%7D%7D%29%5Ccdot%28%5Coverline%7Bx_%7B4%7D%7D&plus;%5Coverline%7Bx_%7B5%7D%7D&plus;%5Coverline%7Bx_%7B6%7D%7D%29)

Can be interpreted as:
![equation](https://latex.codecogs.com/gif.latex?%5Csmall%20f%5E%7B1%7D_%7Bbnlp%7D%28x_%7B1%7D%2C...%2Cx_%7B6%7D%29%20%3D%20%28x_%7B1%7D&plus;x_%7B2%7D&plus;x_%7B3%7D%29%5Ccdot%282-x_%7B2%7D&plus;x_%7B4%7D-x_%7B5%7D%29%5Ccdot%283-x_%7B3%7D-x_%7B5%7D-x_%7B6%7D%29%5Cgeq%201%5Ccdot1%5Ccdot1%5Cgeq1)

And by using matlabs GA solver from optimtool, we can find solution to the problem.

## Artificial neural network
### NeuralNetwork toolbox
Using the Matlab's NeuralNetwork toolbox, 4 parity function is implemented
Also custom function is implemented, including the Simulink model of a trained network:
![equation](https://latex.codecogs.com/gif.latex?(x1\cdot&space;x2&space;&plus;&space;\overline{x3\cdot&space;x4})\cdot&space;x1)

## Cellular automata (WireWorld)
In WireWorld cellular automata, custom digital circuit is implemented:
![equation](https://latex.codecogs.com/gif.latex?(x1\cdot&space;x2&space;&plus;&space;x3\cdot&space;x4)\cdot&space;x1)
The file opens in Golly application for cellular automata simulation

## Partitioning of a digital circuit
Partition is done both with Kernighan Lin algorithm and Simulated Annealing
