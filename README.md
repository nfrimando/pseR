
<!-- README.md is generated from README.Rmd. Please edit that file -->
pseR
====

Pull and analyse PSE data. Currently limited only to Investagrams as source which is limited to past year data only.

Installation
------------

Install devtools to easily install `pseR`.

``` r
install.packages("devtools")
devtools::install_github("nfrimando/pseR")
```

Examples
--------

Extract historical PSE data with `pse_get()`

``` r
suppressPackageStartupMessages({library(pseR); library(dplyr)}) 
stock.dt <- pse_get(c("JFC", "MBT", "FGEN","BPI", "URC",
                            "ALI", "MER", "ABS", "GLO"))
stock.dt %>% head()
```

    ##   code       date close change  open   low  high
    ## 1  JFC 2020-04-08 120.0    9.5 111.0 108.1 120.0
    ## 2  JFC 2020-04-07 110.5    4.5 110.2 109.0 112.5
    ## 3  JFC 2020-04-06 106.0    4.0 104.6 103.5 106.4
    ## 4  JFC 2020-04-03 102.0    0.0 102.3 102.0 105.0
    ## 5  JFC 2020-04-02 102.0   -1.2 102.9 102.0 103.2
    ## 6  JFC 2020-04-01 103.2   -3.2 107.0 103.0 109.6

Analytics using `tidyquant`
---------------------------

The package [`tidyquant`](https://cran.r-project.org/web/packages/tidyquant/vignettes/TQ04-charting-with-tidyquant.html) has convenient functions that allows easy implementation for visualisation and analysis. (It also has functions to pull data for PSE from various sources. The easy-to-access sources though are usually not updated. E.g. Yahoo! Finance).

``` r
suppressPackageStartupMessages({library(tidyquant); library(ggplot2)})
stock.dt %>%
  ggplot(aes(x = as.Date(date), y = close)) +
  geom_barchart(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "PSE Stocks Daily Past 1 Year", y = "Closing Price", x = "") + 
  facet_wrap(~code, scales = "free") + 
  scale_x_date(date_breaks = "3 months", date_labels = "%b %d") + 
  theme_tq()
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)
