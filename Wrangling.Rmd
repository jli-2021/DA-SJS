---
title: "Wrangling"
author: "NAME"
date: "DATE"
output: html_document
---

SCORE _____ / 90 POINTS

The film "Moneyball" is based on Michael Lewis's 2003 nonfiction book of the same name, an account of the Oakland Athletics baseball team's 2002 season and their general manager's attempts to assemble a competitive team.

We want to understand historically how efficient teams are at spending money and getting wins in return. In the case of Moneyball, one would expect that Oakland was not much more efficient than other teams in their spending before 2000, were much more efficient between 2000 and 2005, and by then other teams may have caught up. Your job in this project is to see if this is true.

Load the **tidyverse** and **Lahman** libraries. (2 pts.)

```{r}
library(tidyverse)

library(Lahman)
```

Look inside the **Lahman** documentation. (2 pt.)

```{r}
LahmanData

?LahmanData
```

Notice how many datasets come with this package. We will use the "Teams" and "Salaries" datasets in this project. Peek inside them to get an idea of what information they provide. Try using the colnames() function. Look at its documentation to see what it does. (2 pts.)

```{r}
colnames(Teams)
Teams

colnames(Salaries)
Salaries
```

How many rows do we have in our "Salaries" dataset? Try using the nrow() function. (2 pts.)

```{r}
nrow(Salaries)
Salaries
```

What date range does our "Teams" dataset cover? (4 pts.)

```{r}
arrange(Teams, desc(yearID))
```

1985-2019

What date range does our "Salaries" dataset cover? (4 pts.)

```{r}
arrange(Salaries, desc(yearID))
```

2015-2016

Let's begin by filtering our datasets to contain only data between the years 1990 and 2015, inclusive. We should also store this filtered data in a new dataset to avoid mutating our original datasets. Name the new datasets "teams", and "salaries" (no capitals). (10 pts.)

```{r}
teams <- Teams %>%
  filter(yearID > 1989 & yearID < 2016)

salaries <- Salaries %>%
  filter(yearID > 1989 & yearID < 2016)

salaries
```

### Problem 1

Use the group_by() and summarize() functions, along with the %>% operator, to calculate the yearly payroll for all teams in the "salaries" dataset. Save this to a new dataset called "by_teams_year". (8 pts.)

```{r}
by_teams_year <- salaries %>%
  group_by(teamID, yearID) %>%
  summarize(
    yearly_payroll = sum(salary, na.rm = TRUE)
  )

by_teams_year
```

### Problem 2

Write code that adds the payroll column from Problem 1, to the "teams" dataset. Save this to a new dataset called "joined".
HINT: Use the left_join() function. (5 pts.)

```{r}
joined <- teams %>%
  left_join(by_teams_year, y_names = yearly_payroll)

joined
```

Notice that your new "joined" dataset has a LOT of columns, go ahead and create a new dataset called "simple_joined", and use the select() function to include in it only the "yearID", "teamID", "W", and "payroll" columns. (7 pts.)

```{r}
simple_joined <- joined %>%
  select(yearID, teamID, W, yearly_payroll)

simple_joined
```

### Problem 3

Let's create a new measurement unit that summarizes how efficiently each team spends its money, every year. 

**We’ll use the number of wins a team can get (W) per dollar spent (payroll)**

wpd = W / payroll

wpd stands for "wins per dollar"

Use the group_by() and summarize() functions to calculate the number of wins per dollar spent on payroll by each team, each year. Save this to a new dataset called "wpd_dataset" (10 pts.)

```{r}
wpd_dataset <- simple_joined %>%
  group_by(yearID, teamID) %>%
  summarize(
    wpd = W / yearly_payroll
  )

wpd_dataset
```

### Problem 4 

Using the result of Problem 3, calculate the average number of wins per dollar spent *by all teams* for each year. Again, use the group_by() and summarize() functions. Save this to a new dataset called "avg_wpd_dataset". (8 pts.)

```{r}
avg_wpd_dataset <- wpd_dataset %>%
  group_by(yearID) %>%
  summarize(
    avg_wpd = mean(wpd)
  )

avg_wpd_dataset
```

With the result of Problem 4, now we can approximate the number of wins we would expect each team to get given their payroll, and then see how many more (or less) wins they had compared to this expectation. Take a moment to try to understand this concept, it is VERY important. 

Note: this is a naive version of linear regression that we’ll see in better detail later in the semester.

### Problem 5
Compute the difference between wins and expected wins for each team in each year.

##### Step 1
Remember your "simple_joined" dataset? Take a look at it to familiarize yourself with it once again. (1 pts.)

```{r}
simple_joined
```

##### Step 2
Let's join it with our "avg_wpd_dataset". Use the left_join() function once again. Call this new dataset "calculations". (5 pts.)

```{r}
calculations <- avg_wpd_dataset %>%
  left_join(simple_joined, y_names = yearID & teamID & W & yearly_payroll)

calculations
```

If you multiply the "payroll" column, by the "avg_wpd" column, what should you get? (5 pts.)

> ANS: The predicted number of wins for each team for each year.

##### Step 3
Use the mutate() function to add a new column to your dataset with the name "expected_wins" that equals "payroll" times "avg_wpd" (5 pts.)

```{r}
calculations <- calculations %>%
  mutate(expected_wins = yearly_payroll * avg_wpd)

calculations
```

We're almost done! All that's left for us to do is compare our calculations for expected number of wins with the actual number of wins. 

##### Step 4
Use the mutate() function to add a new column to your dataset with the name "residual_wins" that equals "W" - "expected_wins". (5 pts.)

```{r}
calculations <- calculations %>%
  mutate(residual_wins = W - expected_wins)

calculations
```

Great job! Go ahead and run the code chunk below. If you have done everything correctly, you should see a plot comparing how efficiently the Oakland Athletics, New York Yankees, New York Mets, and Boston Red Sox used their money from 1990 - 2015.

```{r}
calculations %>%
  filter(teamID %in% c("OAK", "NYA", "NYN", "BOS")) %>%
  ggplot(mapping = aes(x = yearID, y = residual_wins, color = teamID)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  labs(x = "Year", y = "Residual Wins", title = "Cost efficiency from 1990 to 2015", subtitle = "Lines of best fit indicate general performance")
```

Were the Oakland A's do more, same, or less efficient? (5 pts.)

> ANS:  The Oakland A's were the most efficient overall, especially after 1995, and were the only team to consistently beat their number of predicted wins after that year.



















