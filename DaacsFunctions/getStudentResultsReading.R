library(mongolite)
library(dplyr)

getStudentResultsReading <- function(conn, studentid, tDate) {
    
    readingFrame <- m.user_assessments$aggregate( pipeline = '[{ 
            "$match" : { 
                "assessmentCategory" : "READING",
                "status": "GRADED"
            }
        }, 
        { 
            "$project" : { 
                "_id" : 0.0, 
                "username" : 1.0, 
                "firstName" : 1.0, 
                "lastName" : 1.0, 
                "assessmentCategory" : 1.0, 
                "assessmentType" : 1.0, 
                "status" : 1.0, 
                "takenDate" : 1.0, 
                "overallScore" : 1.0, 
                "domainScores" : 1.0
            }
        }, 
        { 
            "$unwind" : { 
                "path" : "$domainScores"
            }
        }]')
    
    
    readingframe2 <- readingFrame$domainScores
    testFrame2 <- readingFrame[,c(1:7, 9)]
    readingFrame3 <- cbind(testFrame2,readingframe2)
    readingFrame4 <- readingFrame3%>% pivot_wider(names_from = domainId, values_from=rawScore)
    
    if (missing(studentid) && missing(tDate)) {
        return(readingFrame4)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(readingFrame4, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(readingFrame4, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
}