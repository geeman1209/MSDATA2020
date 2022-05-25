library(mongolite)
library(dplyr)

getWRItemResults <- function (conn, studentid, tDate) {
    itemFrame4 <-  conn$aggregate( pipeline='[
        { 
            "$match" : { 
                "assessmentCategory" : "WRITING", 
                "status" : "GRADED"
            }
        }, 
        { 
            "$project" : { 
                "_id" : 0.0, 
                "username" : 1.0, 
                "assessmentCategory" : 1.0, 
                "writingPrompt" : 1.0, 
                "takenDate" : 1.0
            }
        },
        { 
            "$unwind" : { 
                "path" : "$writingPrompt"
            }
        }
        ]')
    
    
    iFrameWR <- itemFrame4$itemGroups
    iFrameWR_slim <- itemFrame4 %>% select("username", "assessmentCategory")
    
    iFrameWR2 <- iFrameWR$items
    iFrameWR3 <- iFrameWR2$possibleItemAnswers
    iFrameWR2_slim <- iFrameWR2%>%select("_id", "question", "chosenItemAnswerId", "completeDate")
    
    iFSlimWR <- cbind(iFrameWR_slim, iFrameWR2_slim)
    
    iFrameWR4 <- bind_rows(iFrameWR3)
    
    iFSlimWR <- rename(iFSlimWR, Answer_id = chosenItemAnswerId)
    iFrameWR4 <- rename(iFrameWR4, 'Answer_id' = '_id')
    
    ansFrameWR <- dplyr::inner_join(iFSlimWR, iFrameWR4, by='Answer_id') %>% distinct(.keep_all = TRUE)
    
    if (missing(studentid) && missing(tDate)) {
        return(ansFrameWR)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(ansFrameWR, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(ansFrameWR, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
}
