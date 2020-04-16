#' Scrape Investagram Stock Info
#'
#' This function extracts raw HTML from Investagram UI and 
#' returns list of details
#'
#' @param code Vector of Stock Code(s) from PSE (e.g. JFC, FMETF, BPI)
#' @param details Vector containing details to scrape. `hist` - dataframe of historical data
#' @return A list with investagram information
#' 
#' @import dplyr rvest
#' @importFrom glue glue
#' @importFrom assertthat assert_that
#' 
#' @examples 
#' scrape_investagram(c("JFC", "GLO"))
scrape_investagram <- function(code, details = c("hist")) {
  
  stock_information.list <- list()
  
  for (i in code) {
      
      message(glue("Pulling data for {i}"))
      
      url <- glue("https://www.investagrams.com/Stock/{i}")
      
      # Historical Table -------------------
      if ("hist" %in% details) {
        html_content <- url %>%
          read_html() %>%
          html_nodes(xpath = '//*[@id="HistoricalDataTable"]') %>%
          html_table()
        
        assert_that(
          length(html_content) != 0,
          msg = "No Data Extracted. Please Check if Stock Code is Valid"
        )
        
        stock_information.list[[i]]$historical_data <- html_content[[1]]
      }
  
  }
  
  return(stock_information.list)
}
