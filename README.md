# Algorithm Heuristics

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
