#' Scrape Investagram Stock Info
#'
#' This function extracts raw HTML from Investagram UI and 
#' returns list of details
#'
#' @param code Vector of Stock Code(s) from PSE (e.g. JFC, FMETF, BPI)
#' @param details Vector containing details to scrape. `hist` - dataframe of historical data. 
#' `bands` - basic analytics
#' @return A list with investagram information
#' 
#' @import dplyr rvest
#' @importFrom glue glue
#' @importFrom assertthat assert_that
#' 
#' @examples 
#' scrape_investagram(c("JFC", "GLO"))
scrape_investagram <- function(code, details = c("hist", "bands")) {
  
  stock_information.list <- list()
  
  for (i in code) {
      
      message(glue("Pulling data for {i}"))
      
      url <- glue("https://www.investagrams.com/Stock/{i}")
      
      html_content <- url %>%
        read_html()
      
      # Historical Table ----------------------------------
      if ("hist" %in% details) {
        data <- html_content %>% 
          html_nodes(xpath = '//*[@id="HistoricalDataTable"]') %>% 
          html_table()
        
        assert_that(
          length(data) != 0,
          msg = "No Historical Data Extracted. Please Check if Stock Code is Valid"
        )
        
        stock_information.list[[i]]$historical_data <- data[[1]]
      }
      
      # Support Table ----------------------------------
      if ("bands" %in% details) {
        data <- html_content %>% 
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
          length(data) != 0,
          msg = "No Bands Data Extracted. Please Check if Stock Code is Valid"
        )
        
        stock_information.list[[i]]$bands <- data
      }
  
  }
  
  return(stock_information.list)
}
