#' Pull Historical PSE Data
#'
#' This function extracts historical PSE data on close, high, low, and open
#' values from a source. Currently only pulls from Investagrams and limited
#' to past one year data.
#'
#' @param codes Vector of Stock Code(s) from PSE (e.g. JFC, FMETF, BPI)
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
pse_get <- function(codes) {

  stock_info.list <- scrape_investagram(codes)
    
  # Combining into one dataframe
  all_historical.dt <- map_df(
    stock_info.list,
    function(stock_info) {
      stock_info$data
    },
    .id = "code"
  )
  
  return(all_historical.dt)
}
