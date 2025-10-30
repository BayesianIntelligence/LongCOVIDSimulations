# LongCOVIDSimulations
Simulations and example analysis using the DAG/BN research framework for long COVID, from the paper Pérez Chacón et al. (2025) *"Developing a general research framework for long COVID using causal modelling"*.

The main analysis file is `combined_analysis2.R`.

In the supplement, an illustration is provided that walks through a mediation analysis using the long COVID framework. To show how the framework can help guide the analysis through bias and measurement issues, the analysis is run against the backdrop of 2 counterfactual worlds, leading to different conclusions from the analysis.

To switch between these counterfactual worlds, change the `data = df` in line 7 to `data = df2`. This will switch the dataset from `world 1 - spike protein as cause.csv` to `world 1 - spike protein as cause.csv`. These two datasets were generated from their corresponding GeNIe `.xdsl` files (GeNIe is available from [BayesFusion](https://bayesfusion.com)).

The supplement also describes the results of running an analysis that doesn't not handle bias and measurement issues. combined_analysis2.R can be modified by removing the `Severe_disease, Symptoms_t1, Lowest_SpO2` variables (or any subset) from the analysis.