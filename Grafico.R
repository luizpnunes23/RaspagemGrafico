# Raspagem de dados e gráfico com ggplot

library(rvest)
library(dplyr)
library(ggplot2)

site <- "https://www.dicionariofinanceiro.com/maiores-economias-do-mundo/"

PIB <- read_html(site) %>%
  html_table()

PIB <- PIB[[1]]
PIB$Posição <- NULL
PIB$`PIB PPC em US$ trilhões (posição)` <- NULL
cols <- sapply(PIB, function(`PIB em US$ trilhões`) any(grepl(",", `PIB em US$ trilhões`)))
PIB[cols] <- lapply(PIB[cols], function(`PIB em US$ trilhões`) as.numeric(sub(",", ".", `PIB em US$ trilhões`)))
PIB$País <- factor(as.character(PIB$País), levels = PIB$País[order(PIB$`PIB em US$ trilhões`)])

ggplot(PIB) +
  ggtitle("20 Maiores Economias") +
  aes(x = País, y = `PIB em US$ trilhões`, fill = País) +
  geom_col() +
  guides(fill="none") +
  coord_flip()
