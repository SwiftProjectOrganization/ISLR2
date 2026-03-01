installISLR2Libraries = function() {
    install.packages("MASS")
    install.packages("tidyverse")
    install.packages("ISLR2")
    install.packages("ggpmisc")
    install.packages("e1071")
    install.packages("class")
    install.packages("LaplacesDemon")
    install.packages("gridExtra")
}

loadISLR2Libraries = function() {
    library(MASS)
    library(tidyverse)
    library(ISLR2)
    library(ggpmisc)
    library(gridExtra)
    library(e1071)
    library(class)
    library(LaplacesDemon)
    library(gridExtra)
}

installSRLibraries = function() {
    install.packages(c("coda", "mvtnorm", "devtools", "loo", "dagitty", "shape"))
    library(devtools)
    devtools::install_github("rmcelreath/rethinking")
}

loadSRLibraries = function() {
    library(coda)
    library(mvtnorm)
    library(loo)
    library(dagitty)
    library(shape)
    library(rethinking)
}

installRCausalLibraries = function() {
    install.packages("pak")
}

loadRCausalLibraries = function() {
    options(
  # set default colors in ggplot2 to colorblind-friendly
  # Okabe-Ito and Viridis palettes
  ggplot2.discrete.colour = ggokabeito::palette_okabe_ito(),
  ggplot2.discrete.fill = ggokabeito::palette_okabe_ito(),
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  # set theme font and size
  book.base_family = "sans",
  book.base_size = 14
)

}