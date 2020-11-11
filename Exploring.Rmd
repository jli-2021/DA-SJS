---
title: "exploring"
author: "NAME"
date: "DATE"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

Load the necessary libraries
```{r}
library(tidyverse)
```

Take a look inside your dataset
```{r}
listings
```

### Variation

Perform an analysis of the variation in the "neighbourhood" column. 

```{r}
ggplot(data = listings, aes(x = neighbourhood)) +
  geom_bar()

listings %>%
  count(neighbourhood)
```

```{r}
ggplot(listings, aes(x = neighbourhood, y = price)) +
  geom_boxplot()
```


* Which values are the most common? Why?

> Dorchester and Downtown are the most common neighbourhoods.

* Which values are rare? Why? Does that match your expectations?

> Leather District and Longwood Medical Area are the least common, not even exceeding 10 counts.

* Can you see any unusual patterns? What might explain them?

> Leather District is a rather high-end location, explaining the low number of listings and overall high prices.

Perform an analysis of the variation in the "room_type" column. 

```{r}
ggplot(listings, aes(x = room_type)) +
  geom_bar()
```

```{r}
ggplot(listings, aes(x = room_type, y = price)) +
  geom_boxplot()
```

* Which values are the most common? Why?

> Entire homes/apartments and private rooms are the most common.

* Which values are rare? Why? Does that match your expectations?

> Hotel rooms and shared rooms are oustandingly rare.

* Can you see any unusual patterns? What might explain them?

> Again, hotel rooms and shared rooms are very rare; the reason(s) being is not immediately evident.


Perform an analysis of the variation in the "price" column. Make sure to explore different "binwidth" values in your analysis.

```{r}
ggplot(listings, aes(x = price)) +
  geom_histogram(binwidth = 500)

ggplot(listings, aes(x = price)) +
  geom_histogram(binwidth = 100)

ggplot(listings, aes(x = price)) +
  geom_histogram(binwidth = 50)
```

* Which values are the most common? Why?

> The vast majority of prices place below 1250, the most of those being under 250.

* Which values are rare? Why? Does that match your expectations?

> There are lone values scattered at unusually high prices, like two at above 2500 and one at 10000. These are reasonably rare.

* Can you see any unusual patterns? What might explain them?

> There is a very small peak present at around 1000 which likely comprise of higher-end/luxury stays.


Perform an analysis of the variation in the "minimum_nights" column. Make sure to explore different "binwidth" values in your analysis.

```{r}
ggplot(listings, aes(x = minimum_nights)) +
  geom_histogram(binwidth = 50)

ggplot(listings, aes(x = minimum_nights)) +
  geom_histogram(binwidth = 10)

ggplot(listings, aes(x = minimum_nights)) +
  geom_histogram(binwidth = 5)
```

```{r}
listings %>%
  filter(minimum_nights > 250)
```

```{r}
listings %>%
  count(minimum_nights) %>%
  arrange(desc(n))
```

* Which values are the most common? Why?

> Around 1, 30 (one month), and 91 (quarter of a year) are the most common values.

* Which values are rare? Why? Does that match your expectations?

> There are seven listings that have minimum nights about equal to or greater than an entire year. Understandably, these are long term commitment locations and are very rare.

* Can you see any unusual patterns? What might explain them?

> Again, there are few listings that require extensive minimum stays. The hosts may be away from the property for extended periods of time and are leasing the locations for the time they are gone. Locations with 1/4 month minimum stay may correspond with availability, where they are available for that period of time and renters must stay for that entire time.


Perform an analysis of the variation in the "number_of_reviews" column. Make sure to explore different "binwidth" values in your analysis.

```{r}
ggplot(listings, aes(x = number_of_reviews)) +
  geom_histogram(binwidth = 50)

ggplot(listings, aes(x = number_of_reviews)) +
  geom_histogram(binwidth = 10)

ggplot(listings, aes(x = number_of_reviews)) +
  geom_histogram(binwidth = 5)
```

* Which values are the most common? Why?

> Many listings have 10 to no reviews.

* Which values are rare? Why? Does that match your expectations?

> The greater the value, the rarer it tends to be.

* Can you see any unusual patterns? What might explain them?

> In general, there aren't any unusual patterns immediately recognizeable.


Perform an analysis of the variation in the "availability_365" column. Make sure to explore different "binwidth" values in your analysis.

```{r}
ggplot(listings, aes(x = availability_365)) +
  geom_histogram(binwidth = 50)

ggplot(listings, aes(x = availability_365)) +
  geom_histogram(binwidth = 10)

ggplot(listings, aes(x = availability_365)) +
  geom_histogram(binwidth = 5)
```

* Which values are the most common? Why?

> The most common value is 0, followed by 365. The unavailable locations are most likely already rented out.

* Which values are rare? Why? Does that match your expectations?

> Values that are not at exact fractions of a year tend to be generally rare. There aren't many common reasons to limit availability by non-fractions of a year.

* Can you see any unusual patterns? What might explain them?

> There are spikes at half and a quarter of the year, as well as a higher value at slightly less than a full year. This may be because certain listings serve as vacation locations for specific seasons. Those available for a couple days less than a full year may be closed for a few holidays.

###Part II

```{r}
clean <- listings %>%
  filter(price < 1500)
```

1. Do the number of reviews affect the price of the Airbnb price? How? Why do you think this happens?

```{r}
ggplot(clean) +
  geom_point(aes(x = number_of_reviews, y = price))

ggplot(clean) +
  geom_point(aes(x = number_of_reviews, y = price))
```

> The densest area of the plot suggests that while low-priced listings can have any reasonable number of reviews, more higher-priced listings have fewer reviews. Since reviewers will write reviews with consideration to experience based on price listed, reviews generally decide a reasonable price threshold that hosts are generally discouraged from exceeding; properties with few reviews do not have such limitations placed on their listings and thus can determine their own prices without much justification.

2. What type of room tends to have the highest Airbnb price?

```{r}
ggplot(clean, aes(x = room_type, y = price)) +
  geom_boxplot()
```

> Home/apartments have the highest third quartile and most high-priced outliers, whereas hotel rooms have the highest median price.

3. What neighbourhood(s) tend to have the highest Airbnb price?

```{r}
ggplot(clean, aes(x = neighbourhood, y = price)) +
  geom_boxplot()
```

> Leather District, with its small slection of properties, has the highest general prices. West End comes second. Allston has the highest priced listing in the dataset, but otherwise constains lower-priced listings among neighbourhoods.

4. Suppose you could purchase a property in the city you selected, and that you could rent it to others as an Airbnb. In what neighbourhood would you want to purchase your property? Why?

> Assuming we do not intend to rent any properties at prices which would be considered outliers in their respective neighbourhoods, Leather District gives us the best prospects. Furthermore, considering the small number of options there, we may hold a monopolistic competition system where we have an easier time charging an unusually high price.


###Part III

Visit a real estate website (such as realtor.com) and find a property that is for sale in the neighbourhood you selected. Take note of the price and address of the property.

> Decent-sized house for $725000.

1. Use your dataset to find what the average Airbnb price/night is in the neighbourhood you selected.

```{r}
listings %>%
  filter(neighbourhood == "Leather District") %>%
  select(price)
```

```{r}
by_nh <- group_by(listings, neighbourhood) %>%
  summarize(
    avg_price = mean(price, na.rm = TRUE)
    )

by_nh
```

> The average price/night in Leather District is $1447. This average is heavily right skewed since one property is nearly $4000 while the other two are under $200.

2. Use your dataset to find what the average number of available nights per year is for an Airbnb in the neighbourhood you selected.

```{r}
listings %>%
  filter(neighbourhood == "Leather District") %>%
  select(availability_365)
```

```{r}
by_an <- group_by(listings, neighbourhood) %>%
  summarize(
    avg_availability = mean(availability_365, na.rm = TRUE)
    )

by_an
```

> The average number of available nights for Leather District properties is 150 days. However, within the three listings in Leather District, one of them is unavailable, the another is available almost year-round, and the last is available for around a quarter of the year.

3. Suppose you bought the property you selected above. If you were to rent it as an Airbnb at the average neighbourhood price, for the average number of days, how long will it take for you to break even?

> It will take less than four years (about three a third of a year, or 1219 days).
