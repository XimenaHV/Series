library(tidyverse)
library(fpp3)

gamestop <- tidyquant::tq_get("GME", from = "2018-01-01")
gamestop

gamestop_tsbl <- gamestop |> 
  as_tsibble(index=date)

gamestop_tsbl |> 
  autoplot(adjusted)

gamestop_tsbl |> 
  mutate(n=seq_along(gamestop_tsbl$date)) |> 
  as_tsibble(index = n) |> 
  model(STL(close)) |> 
  components() |> 
  autoplot()

gamestop_tsbl |> 
  fill_gaps() |> # fill_gaps muestra los datos qeu faltan y les pone NA
  fill(close) |> # llena esos huecos con datos
  model(log(close)~season(window = 'periodic'))