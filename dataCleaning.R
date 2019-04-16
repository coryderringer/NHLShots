library(tidyverse)

# import data:
d <- read.csv("/Users/coryd/Desktop/Coding (GitHub repositories)/HockeyProject/ShotLocations/locationData.csv")

# convert coord to numeric
d$y_coord <- as.numeric(as.character(d$y_coord))
d$x_coord <- as.numeric(as.character(d$x_coord))
d <- filter(d, !is.na(y_coord))

d <- d %>%
    filter(!is.na(game), period %in% c(1:5)) %>%
    mutate(y_coord_flip = y_coord)

d$period <- as.numeric(as.character(d$period))

# flip y axis
flip <- which((d$period %% 2 == 0) & (d$home_away == 'Home'))
flip <- c(flip, which((d$period %% 2 == 1) & (d$home_away == 'Away')))
d$y_coord_flip[flip] <- d$y_coord[flip]*-1
d$x_coord <- abs(d$x_coord)

app_d <- d %>% 
    select(x_coord, y_coord_flip, result, team)

app_d$result <- as.numeric(d$result)
# write.csv(app_d, file = "ShotLocations/appData.csv")
# write.csv(d, file = "ShotLocations/ShotLocationsApp/cleanData.csv")



for(t in unique(app_d$team)){
    
    td <- app_d %>%
        filter(team == t)
    td_save <- td %>%
        filter(result == 0) %>%
        select(-result)
    td_goal <- td %>%
        filter(result == 1) %>%
        select(-result)
    
    title_save = paste("ShotLocations/ShotLocationsApp/Datasets/", t, "save.csv", sep='')
    title_goal = paste("ShotLocations/ShotLocationsApp/Datasets/", t, "goal.csv", sep='')
    
    
    write.csv(td_save, file = title_save)
    write.csv(td_goal, file = title_goal)
    print(t)
    
}



