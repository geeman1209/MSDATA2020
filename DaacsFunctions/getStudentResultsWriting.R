library(mongolite)
library(dplyr)

getStudentResultsWriting <- function (conn, studentid, tDate) {
    wrFrame <- conn$aggregate( pipeline = '[{ 
            "$match" : { 
                "assessmentCategory" : "WRITING",
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
        },
        { 
            "$unwind" : { 
                "path" : "$domainScores.subDomainScores"
            }
        }
        ]')
    
    wrframe2 <- wrFrame$domainScores
    tFrame2 <- wrFrame[,c(1:7, 9)]
    wrFrame3 <- cbind(tFrame2,wrframe2)
    wrFrame4 <- wrFrame3%>% pivot_wider(names_from = domainId, values_from=rubricScore)
    
    if (missing(studentid) && missing(tDate)) {
        return(wrFrame4)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(wrFrame4, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(wrFrame4, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
}