% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scrape_investagram.R
\name{scrape_investagram_indiv}
\alias{scrape_investagram_indiv}
\title{Scrape Investagram Stock Info (Individual)}
\usage{
scrape_investagram_indiv(code, details = c("hist", "bands"))
}
\arguments{
\item{code}{single stock code}

\item{details}{Vector containing details to scrape. `hist` - dataframe of historical data. 
`bands` - basic bands}
}
\value{
A list with investagram information
}
\description{
This function extracts raw HTML from Investagram UI and 
returns list of details for one stock
}
\examples{
scrape_investagram_indiv("JFC")
}
