# microGA
microgenetic algorythm for parameter optimisation (for NEMO-LOBTER/PISCES-type biogeochemical modesl)

## Aim

Optimization of the parameters of the PISCES biogeochemical model using a micro-genetic algorithm.

For now, it has only been applied to optimize the parameter of the PISTER model in 1D at the BATS JGOFS station. See [Ayata et al (2013)](https://doi.org/10.1016/j.jmarsys.2012.12.010).

Reference: Ayata, S.D., Lévy, M., Aumont, O., Sciandra, A., Sainte-Marie, J., Tagliabue, A. and Bernard, O., 2013. Phytoplankton growth formulation in marine ecosystem models: should we take into account photo-acclimation and variable stoichiometry in oligotrophic areas?. Journal of Marine Systems, 125, pp.29-40.

## Principle of the parameter calibration using a micro-genetic algorithm (uGA)

### Description of the uGA

Genetic algorithms are stochastic methods in which a population of parameters evolves with mutation/selection processes.

In the particular case of micro-genetic algorithms, the size of the population is small and no mutation is considered (Carroll, 1996). A micro-genetic algorithm with binary coding, elitism, tournament selection of the parents, and uniform cross-over was used (Carroll, 1996; Schartau & Oschlies, 2003).

At the beginning, a set (or population) of parameter vectors (individuals) is randomly generated within a predefined range. Each parameter vector is coded as a binary string (chromosome). Then, at each generation, the misfit of each parameter vector (fitness of each individual) is estimated as the misfit (cost function) between the data and the model outputs for this parameter vector. The parameter vector with the lowest misfit (best individual of its generation or elite) is conserved to the next generation. Then, four vectors are randomly chosen and associated in two pairs. The vectors with the lowest misfit (best fitness) within each pair are selected (parents), and a new parameter vector (child) is produced by randomly crossing each bit of the two selected vectors. This process (reproduction) is repeated until the replenishment of the population. New generations are produced (evolution), until the population of parameter vectors has converged (all the vectors are identical to the elite). Then, a new generation is randomly generated, with the elite conserved.

This process is repeated N times for a population whose size was chosen equal to the number of parameters to optimize (Schartau & Oschlies, 2003). For a given model, the parameter space has to be reduced to the parameters for which the cost function is the most sensible. Such information can be learnt from preliminary sensibility analyses (Ayata et al, submitted, have optimized four to seven parameters depending on the model).

### Characteristic of the uGA implemented here

- binary coding of parameters
- tournament selection of the parents
- uniform cross-over
- elitism 

### Here are some references for micro-genetic algorithm

Decription of the uGA technique (to calibrate a laser model): Caroll (1996) Chemical laser modeling with genetic algorithms. AIAA Journal 34, 338-346.

Example of application to a simple biogeochemical model in the North Atlantic: Schartau & Oschlies (2003) Simultaneous data-based optimization of a 1D-ecosystem model at three locations in the North Atlantic: Part I - Method and parameter estimate. Journ Mar Res 61, 765-793.

Description of the uGA technique (to calibrate a hardening-softening constitutive model): Rokonuzzama & Sakai (2010) Calibration of the parameters for a hardening-softening constitutive model using genetic algorithms. Comp & Geotch 37, 573-579.

Comparison of two optimization techniques to calibrate a marine biogeochemical model (uGA vs. variational adjoint): Wards et al. (2010) Parameter optimisation techniques and the problem of underdetermination in marine biogeochemical model. Journ Mar Sci 81, 34-43. 
