#' Pull Historical PSE Data
#'
#' This function extracts historical PSE data on close, high, low, and open
#' values from a source. Currently only pulls from Investagrams and limited
#' to past one year data.
#'
#' @param code Vector of Stock Code(s) from PSE (e.g. JFC, FMETF, BPI)
#' @return A dataframe with available historical stock data
#' 
#' @import dplyr rvest
#' @importFrom stringr str_replace_all
#' @importFrom glue glue
#' @importFrom assertthat assert_that
#' @importFrom purrr map_df
#' 
#' @include scrape_investagram.R
#' 
#' @export
#' 
#' @examples 
#' pse_get("JFC")
pse_get <- function(code) {

  stock_info.list <- scrape_investagram(code)
    
  # Combining into one dataframe
  all_historical.dt <- map_df(
    stock_info.list,
    function(stock_info) {
      
      historical.dt.raw <- stock_info$historical_data
      
      # Use First Row as Column Names
      colnames(historical.dt.raw) <- historical.dt.raw[1,]
      
      # Apply Transformations
      historical.dt <- historical.dt.raw[-c(1, nrow(historical.dt.raw)),] %>% 
        transmute(
          code = code,
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
      
      return(historical.dt)
    }
  )
  
  return(all_historical.dt)
}
