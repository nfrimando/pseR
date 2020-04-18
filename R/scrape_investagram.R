#' Scrape Investagram Stock Info (Individual)
#'
#' This function extracts raw HTML from Investagram UI and 
#' returns list of details for one stock
#'
#' @param code single stock code
#' @param details Vector containing details to scrape. `hist` - dataframe of historical data. 
#' `bands` - basic bands
#' @return A list with investagram information
#' 
#' @import dplyr rvest
#' @importFrom glue glue
#' @importFrom assertthat assert_that
#' 
#' @examples 
#' scrape_investagram_indiv("JFC")
scrape_investagram_indiv <- function(code, details = c("hist", "bands")) {
  
  assert_that(length(code) == 1, msg = "Enter only one stock code")
  assert_that(all(details %in% c("hist", "bands")), msg = "Enter valid details")
  
  info.list <- list()
  
  message(glue("Pulling data for {code}"))
  
  url <- glue("https://www.investagrams.com/Stock/{code}")
  
  html_content <- url %>%
    read_html()
  
  # Historical Table ----------------------------------
  if ("hist" %in% details) {
    historical_raw.dt <- html_content %>% 
      html_nodes(xpath = '//*[@id="HistoricalDataTable"]') %>% 
      html_table() %>% 
      {.[[1]]}
    
    # Use First Row as Column Names
    colnames(historical_raw.dt) <- historical_raw.dt[1,]
    
    # Transmute Info
    historical.dt <- historical_raw.dt[-c(1, nrow(historical_raw.dt)),] %>% 
      transmute(
        date = format.Date(strptime(Date, "%b %d, %Y"), '%Y-%m-%d'),
        close = str_replace_all(`Last Price`, ",", ""),
        change = str_replace_all(`Change`, ",", ""),
        open = str_replace_all(`Open`, ",", ""),
        low = str_replace_all(`Low`, ",", ""),
        high = str_replace_all(`High`, ",", "")
      ) %>% 
      mutate_at(
        c("close", "change", "open", "low", "high"),
        as.numeric
      )
    
    assert_that(
      length(historical.dt) != 0,
      msg = "No Historical Data Extracted. Please Check if Stock Code is Valid"
    )
    
    info.list$data <- historical.dt
  }
  
  # Support and Resist Info ----------------------------------
  if ("bands" %in% details) {
    bands.list <- html_content %>% 
      html_nodes('.stock-information-table') %>%
      html_table(fill = TRUE) %>% 
      {.[[5]]} %>% {
        list(
          support_1 = .$X2[which(.$X1 == "Support 1:")],
          support_2 = .$X2[which(.$X1 == "Support 2:")],
          resist_1 = .$X4[which(.$X3 == "Resistance 1:")],
          resist_2 = .$X4[which(.$X3 == "Resistance 2:")]
        ) %>% 
          lapply(function(x) {str_replace_all(x,",","") %>% as.numeric()})
      }
    
    assert_that(
      length(bands.list) != 0,
      msg = "No Bands Data Extracted. Please Check if Stock Code is Valid"
    )
    
    info.list$bands <- bands.list
  }
  
  return(
    info.list
  )
}

#' Scrape Investagram Stock Info
#'
#' This function extracts raw HTML from Investagram UI and 
#' returns list of details
#'
#' @param codes Vector of Stock Code(s) from PSE (e.g. JFC, FMETF, BPI)
#' @param details Vector containing details to scrape. `hist` - dataframe of historical data. 
#' `bands` - basic analytics
#' @return A list with investagram information
#' 
#' @importFrom assertthat assert_that
#' 
#' @examples 
#' scrape_investagram(codes = c("JFC", "GLO"))
scrape_investagram <- function(codes, details = c("hist", "bands")) {
  Map(
    function(x) {scrape_investagram_indiv(x, details)},
    codes
  )
}
