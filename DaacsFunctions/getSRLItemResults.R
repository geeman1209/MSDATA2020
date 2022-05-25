#Function needs to be reworked or broken down into further pieces
#Creates large dataframes (GB in size)

library(mongolite)
library(dplyr)

getSRLItemResults <- function (conn, studentid, tDate) {
    itemFrame3 <-  conn$aggregate( pipeline='[
        { 
            "$match" : { 
                "assessmentCategory" : "COLLEGE_SKILLS", 
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
    
    
    iFrameCSR <- itemFrame3$itemGroups
    iFrameCSR_slim <- itemFrame3 %>% select("username", "assessmentCategory")
    
    iFrameCSR2 <- iFrameCSR$items
    iFrameCSR3 <- iFrameCSR2$possibleItemAnswers
    iFrameCSR2_slim <- iFrameCSR2%>%select("_id", "question", "chosenItemAnswerId", "completeDate")
    
    iFSlimCSR <- cbind(iFrameCSR_slim, iFrameCSR2_slim)
    
    iFrameCSR4 <- bind_rows(iFrameCSR3)
    
    iFSlimCSR <- rename(iFSlimCSR, Answer_id = chosenItemAnswerId)
    iFrameCSR4 <- rename(iFrameCSR4, 'Answer_id' = '_id')
    
    ansFrameCSR <- dplyr::inner_join(iFSlimCSR, iFrameCSR4, by='Answer_id') %>% distinct(.keep_all = TRUE)
    
    if (missing(studentid) && missing(tDate)) {
        return(ansFrameCSR)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(ansFrameCSR, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(ansFrameCSR, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
    
    
}
