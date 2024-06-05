# Vanguard-Digital-Experiment

Performance Analysis by Danielle Steede, Daniela Rivera and Vanessa Jimenez

## Introduction

We have been assigned to analyze an experiment cunducted by the Customer Experience team at Vanguard. Our mission, should we choose to accept it, is to decide whether the experiment was successful or not.

We were given the following information:

> An A/B test that was set into motion from 3/15/2017 to 6/20/2017 by the team.

Our clients were divided in the following groups:

> Control Group: Clients interacted with Vanguard’s traditional online process.

> Test Group: Clients experienced the new, spruced-up digital interface.

Both groups navigated through an identical process sequence: an initial page, three subsequent steps, and finally, a confirmation page signaling process completion.

Our goal: to see if the new design leads to a better user experience and higher process completion rates.

## Data Collected

The following datasets were essential for our analysis:

> [Client Profiles](https://github.com/data-bootcamp-v4/lessons/blob/main/5_6_eda_inf_stats_tableau/project/files_for_project/df_final_demo.txt): Includes general demographics like age, gender, and account details of our clients.

> [Digital Footprints Part 1](https://github.com/data-bootcamp-v4/lessons/blob/main/5_6_eda_inf_stats_tableau/project/files_for_project/df_final_web_data_pt_1.txt) and [Digital Footprints Part 2](https://github.com/data-bootcamp-v4/lessons/blob/main/5_6_eda_inf_stats_tableau/project/files_for_project/df_final_web_data_pt_2.txt): Both include a detailed trace of client interactions online.

> [Experiment Roster](https://github.com/data-bootcamp-v4/lessons/blob/main/5_6_eda_inf_stats_tableau/project/files_for_project/df_final_experiment_clients.txt): Includes whether the client was a part of the control or test group (if any).

## Problem & Hypotheses

Did the new design created by the Customer Experiment team successful in increasing overall client engagement and potential revenue for Vanguard?

> Completion Rate
  > Did more clients reach the confirm step in the test group than the control group?
  > We believe more clients reached the confirm step in the new design.

> Time Spent on each Step
  > Did the new design reduce the time it takes to complete all the steps?
  > We believe the new design is more efficient in directing clients to reach the final step.

> Abandonment Rate
  > Are less people "giving up" on the process with this new design?
  > We believe clients will continue the process without "giving up" at a higher rate in the new design

> Error Rate
  > Is the new design more "user friendly" so that clients don't have to go back to previous steps due to any confusion?
  > We believe in the new design clients won't have to go back to previous steps as much as in the control

## Methodology

  > Data Cleaning & Transformation

  > Performance Metrics (KPIs)

  > Hypothesis Testing

  > Experiment Evaluation

  > Tableau

## Conclusions

### Conclusions on Demographic Info

After analyzing the clients' general demographic:

  > The average age and client tenure are evenly distributed in both the control and test groups. On average, the clients were middle age (51-52 yo) and have been with the company for 15 years.

  > Although male and female clients seem to be evenly distributed for both groups, there are too many clients with unknown gender for us to make any conclusions or corellations related to gender.

  > Despite the number of unknown genders, we believe the clients were divided equally between the two designs in order to get the best results.

### Conclusions for KPIs

  > Completion Rate
    - Although there was an increase in completion rate (3.7%) for the test group, it is not enough for it to be statistically significant and it did not exceed the 5% threshhold set by Vanguard.

  > Abandonment Rate
    - The amount of people lost at start and step 3 vs the other steps indicate these two pages/steps in the process need to be evaluated for improvements because they are contributing the most to abandonment.

  > Time Spent on each Step
    - In both variations, the average time spent on each step was longer as the client moved through the steps. This could be a defining factor if we want to reduce abandonment rate.
    - In the test group, the average time a client spent to reach confirmation was 9.7 minutes. However, the average time for the control group was 8.3 minutes. The main difference between the two groups is in the final (confirmation) step, which took much longer (on average) for the test group than it did for the control group.
    - It is important to note that, in both groups, for confirmation step had many null values, which affect the average time. Why is that? Was there something added to the test group once the client completed the steps? More information needs to be gathered to get a better understanding of the process.
    - From the data, we don't know if time spent on each step includes loading times. A good design should prioritize keeping loading times as small as possible. It would be interesting to collect data on loading times of the pages as part of the experiment.

  > Error Rates
    - We define interaction as: activity or engagement between the client and the step in the process being analyzed. So attempting step 3 4 times is one interaction.
    - We define error as an interaction with a step attempt higher than 1, indicating possible confusion or errors. So attempting step 3 4 times is considered an error.
    - We define non-error as an interaction with a step attempt equal to 1. So attempting step 3 one time is considered non-error, even if they abandon the process at that step.
      - The error rate for the test group is: 22.46%

      - The error rate for the control group is: 19.61%

    - The control group had a lower error rate than the test group, meaning the control group was less likely to visit a step more than once. This could be due to previous familiarity with the process, where in the test group the process has changes to what they're used to.
    - There is a statistically significant difference in the proportions of errors between the control and test groups.
    - Any observed difference in error rates between the control and test groups is NOT attributed to random chance or sampling variability.

  > Tenure Year
    - The average client tenure between the control and test groups shows that there is no significant difference in the average tenure years between the two groups.
    - Both the control and test groups have similar average tenure years, indicating that the updated interface did not notably affect client tenure compared to the traditional process (represented by the control group).
    - Therefore, based on this observation, there isn't enough evidence to support rejecting the null hypothesis that the duration of clients does not significantly alter between the control and test groups.

## Further Questions

## URLs (PPT, Trello, Tableau Page)


