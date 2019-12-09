# Structure-Learning
Learning Tree-Structured Graphical Model: Chow-Liu algorithm with noisy input data.

Last revision: Dec 2019 (Matlab R2019b) Author: Konstantinos Nikolakakis

The purpose of this code is to support the published paper: "Learning Tree Structures from Noisy Data", AIStats, 2019,
and the under review (JMLR) paper: "Predictive Learning on Hidden Tree-Structured Ising Models" by Konstantinos E. Nikolakakis, Dionysios S. Kalogerias, Anand D. Sarwate.

Any part of this code used in your work should cite the above publication.
This code is provided "as is" to support the ideals of reproducible research. Any issues with this code should be reported by email to k.nikolakakis@rutgers.edu. 

The code is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License available at https://creativecommons.org/licenses/by-nc-sa/4.0/.

Description: Structure_Estimation.m generates a tree-structured Ising model (over p nodes) and samples based on that model. Structure estimation is performed on the original and noisy data of the underlying model. Noise is generated by a Binary symmetric channel. The simulation estimates the average number of mismatched edges between the original and the estimated structure for both noisy and noiseless data. Further, the probability of at least one incorrect edge is calculated and it is presented in Probability_of_incorrect_structure_recovery.pdf as a 3D plot. We provide a comparison between our theoretical bound for exact structure recovery and the experimental behavior of the sufficient number of samples in Heat_map.pdf (the red line represents the bound of our Theorem).