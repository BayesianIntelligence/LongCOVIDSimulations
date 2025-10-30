library(brms)

df <- read.csv('world 1 - spike protein as cause.csv')
df2 <- read.csv('world 2 - fibrosis as only cause.csv')

# Contingency table (Mild_disease omitted as it is constant and doesn't affect analysis)
tbl <- xtabs(~ Treatment + Severe_disease + Symptoms_t1 + Lowest_SpO2 + Fatigue_t3, data = df)
df_tbl <- as.data.frame(tbl)

# Bayesian analysis

# Weakly informative prior that approx. translates to each term multiplying
# the expected cell count by between e^-1 to e^1 (~0.37 to 2.7).
priors <- prior(normal(0, 1), class = "b")

# Full (saturated) model
full_model <- brm(Freq ~ Treatment * Severe_disease * Symptoms_t1 * Lowest_SpO2 * Fatigue_t3,
                  family = poisson(), data = df_tbl, prior = priors)

# Reduced model (with no Treatment Fatigue_t2 interaction)
reduced_model <- brm(Freq ~ (Treatment * Severe_disease * Lowest_SpO2 * Symptoms_t1) +
                            (            Severe_disease * Symptoms_t1 * Lowest_SpO2 * Fatigue_t3),
  family = poisson(), data = df_tbl, prior = priors)

# Bayes factor
print(bayes_factor(full_model, reduced_model))

# LOO cross-validation (Are differences in the two model predictions robust?)
loo_result <- loo_compare(loo(full_model, moment_match = T, reloo=T), loo(reduced_model, moment_match = T, reloo=T))
print(loo_result)
cat("\n")

# Frequentist analysis

# Compare this reduced model (no direct Treatment:Fatigue_t3 interaction)
# to saturated model (default comparison in the chi square)
m_reduced <- loglin(tbl, list(
  c("Treatment","Severe_disease","Symptoms_t1","Lowest_SpO2"),
  c(            "Severe_disease","Symptoms_t1","Lowest_SpO2","Fatigue_t3")
), fit = TRUE)

# Compute p-value
p_value <- pchisq(m_reduced$lrt, df = m_reduced$df, lower.tail = FALSE)

# Report result
cat("Chi square test results\n")
cat("LRT statistic: ", m_reduced$lrt, "\n")
cat("Degrees of freedom: ", m_reduced$df, "\n")
cat("p-value: ", p_value, "\n")
