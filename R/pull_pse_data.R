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
#' @export
#' 
#' @examples 
#' pull_pse_data("JFC")
pull_pse_data <- function(code) {
  
  all_historical.dt <- map_df(
    code,
    function(code) {
      
      message(glue("Pulling data for {code}"))
      
      url <- glue("https://www.investagrams.com/Stock/{code}")
      
      # Extract Data From Investagrams Historical Table
      html_content <- url %>%
        read_html() %>%
        html_nodes(xpath = '//*[@id="HistoricalDataTable"]') %>%
        html_table()
      
      assert_that(
        length(html_content) != 0,
        msg = "No Data Extracted. Please Check if Stock Code is Valid"
      )
      
      historical.dt.raw <- html_content[[1]]
      
      # Use First Row as Column Names
      colnames(historical.dt.raw) <- historical.dt.raw[1,]
      
      # Apply Transformations
      historical.dt <- historical.dt.raw[-c(1, nrow(historical.dt.raw)),] %>% 
        transmute(
          code = code,
          date = format.Date(strptime(Date, "%b %d, %Y"), '%Y-%m-%d'),
          close = as.numeric(`Last Price`),
          change = `Change`,
          open = `Open`,
          low = `Low`,
          high = `High`
        ) %>% 
        mutate_at(
          c("change", "open", "low", "high"),
          as.numeric
        )
      
      return(historical.dt)
    }
  )

  return(all_historical.dt)
}