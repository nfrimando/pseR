## Generate Reports

library(janitor)

#################################################
## Support vs Resistance ########################
#################################################

for (type in c("Blue Chip", "Alternative", "Concept Play", "My Portfolio")) {
  rmarkdown::render(
    input = "Reports/bands.Rmd", 
    params = list(
      stock_type = type 
    ),
    output_file = paste0(str_replace_all(Sys.Date(), "-", ""), "bands_",make_clean_names(type),".html")
  )  
}
