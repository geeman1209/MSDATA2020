library(mongolite)
library(dplyr)

getMathItemResults <- function (conn, studentid, tDate) {
    
    itemFrame2 <-  conn$aggregate( pipeline='[
        { 
            "$match" : { 
                "assessmentCategory" : "MATHEMATICS", 
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
    
    
    iFrameM <- itemFrame2$itemGroups
    iFrameM_slim <- itemFrame2 %>% select("username", "assessmentCategory")
    
    iFrameM2 <- iFrameM$items
    iFrameM3 <- iFrameM2$possibleItemAnswers
    iFrameM2_slim <- iFrameM2%>%select("_id", "question", "chosenItemAnswerId", "completeDate")
    
    iFSlimM <- cbind(iFrameM_slim, iFrameM2_slim)
    
    iFrameM4 <- bind_rows(iFrameM3)
    
    iFSlimM <- rename(iFSlimM, Answer_id = chosenItemAnswerId)
    iFrameM4 <- rename(iFrameM4, 'Answer_id' = '_id')
    
    ansFrameM <- dplyr::inner_join(iFSlimM, iFrameM4, by='Answer_id') %>% distinct(.keep_all = TRUE)
    
    if (missing(studentid) && missing(tDate)) {
        return(ansFrameM)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(ansFrameM, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(ansFrameM, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
}
