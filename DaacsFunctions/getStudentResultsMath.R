library(mongolite)
library(dplyr)

getStudentResultsMath <- function(conn, studentid, tDate) {
    
    mathFrame <- conn$aggregate( pipeline = '[{ 
            "$match" : { 
                "assessmentCategory" : "MATHEMATICS",
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
    
    mathframe2 <- mathFrame$domainScores
    testFrame <- mathFrame[,c(1:7, 9)]
    mathFrame3 <- cbind(testFrame,mathframe2)
    mathFrame4 <- mathFrame3%>% pivot_wider(names_from = domainId, values_from=rawScore)
    
    if (missing(studentid) && missing(tDate)) {
        return(mathFrame4)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(mathFrame4, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(mathFrame4, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
    
    
}