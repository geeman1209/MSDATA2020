library(mongolite)
library(dplyr)

getReadingItemResults <- function(conn, studentid, tDate) {
    itemFrame <-  conn$aggregate( pipeline='[
        { 
            "$match" : { 
                "assessmentCategory" : "READING", 
                "status" : "GRADED"
            }
        }, 
        { 
            "$project" : { 
                "_id" : 0.0, 
                "username" : 1.0, 
                "assessmentCategory" : 1.0, 
                "itemGroups" : 1.0, 
                "takenDate" : 1.0
            }
        },
        { 
            "$unwind" : { 
                "path" : "$itemGroups"
            }
        }, 
        { 
            "$unwind" : { 
                "path" : "$itemGroups.items"
            }
        }
        ]')
    
    
    iFrame <- itemFrame$itemGroups
    iFrame_slim <- itemFrame %>% select("username", "assessmentCategory")
    iFrame2 <- iFrame$items
    iFrame3 <- iFrame2$possibleItemAnswers
    iFrame2_slim <- iFrame2%>%select("_id", "question", "chosenItemAnswerId", "completeDate")
    iFSlim <- cbind(iFrame_slim, iFrame2_slim)
    
    iFrame4 <- bind_rows(iFrame3)
    
    iFSlim <- rename(iFSlim, Answer_id = chosenItemAnswerId)
    iFrame4 <- rename(iFrame4, 'Answer_id' = '_id')
    
    ansFrame <- dplyr::inner_join(iFSlim, iFrame4, by='Answer_id') %>% distinct(.keep_all = TRUE)
    
    if (missing(studentid) && missing(tDate)) {
        return(ansFrame)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(ansFrame, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(ansFrame, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
}