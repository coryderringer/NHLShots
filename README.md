# NHL Shot Location Project

This is a project for visualizing and answering questions about NHL shot location data. The main folder contains a python script to retreive in-depth game data from the nhl.com API. The script pulls information from every shot on goal in the 2018-2019 season: shooter, team, home/away, period, time remaining, goal/save, and primary/secondary assists (if the shot is a goal). 

This data is saved in raw form as 'locationData.csv', cleaned in 'dataCleaning.R', and subsequently stored in ShotLocationsApp/Datasets in individual csv files for each team and shot outcome (i.e., goal or save).

ShotLocationsApp is a Shiny app that visualizes the locations of each goal and presents a hex-bin distribution of each shot on goal. The app can be found [here.](https://coryderringer.shinyapps.io/ShotLocationsApp/)

(Python, R, Shiny, ggplot2)
