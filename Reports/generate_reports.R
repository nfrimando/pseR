## Generate Reports

library(janitor)

#################################################
## Support vs Resistance ########################
#################################################

for (type in c("Blue Chip", "Alternative", "Concept Play")) {
  rmarkdown::render(
    input = "Reports/bands.Rmd", 
    params = list(
      stock_type = type 
    ),
    output_file = paste0("bands_",make_clean_names(type),".html")
  )  
}
