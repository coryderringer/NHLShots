# json data for all pens games in the 2018-2019 regular season
library(tidyverse)

# per /u/Lang14, the game ids are organized into year, then game type, then game number
# so this will actually pull data from all teams, but that's okay
numberGames <- 31*82/2 

gameid <- character()

for(i in 1:numberGames){
    gn <- as.character(i) # game number
    if(nchar(gn) == 1){
        gn <- str_c('000', gn)
    }else if(nchar(gn) == 2){
        gn <- str_c('00', gn)
    }else if(nchar(gn) == 3){
        gn <- str_c('0', gn)
    }
    
    if(i %% 100 == 0){
        print(i)
    }
    
    newid <- paste('201802', gn, sep = '')
    gameid <- c(gameid, newid)
}


# all the game IDs
write.csv(gameid, file = "/Users/coryd/Desktop/Coding (GitHub repositories)/HockeyProject/ShotLocations/gameIDs.csv", row.names = FALSE)
