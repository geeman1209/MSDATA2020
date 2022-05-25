library(mongolite)
library(dplyr)

getStudentResultsSRL <- function(conn,studentid, tDate) {
    
    srlFrame <- conn$aggregate( pipeline = '  [
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
    
    
    
    srlFrame2 <- srlFrame$domainScores
    srlDomain <- srlFrame2[,c(1:3)]
    subsrlFrame <- srlFrame2$subDomainScores
    sbFrame <- subsrlFrame
    sbFrame <- rename(sbFrame, subdomainId = domainId, subRawScore = rawScore, subRubric = rubricScore)
    tFrame <- srlFrame[ ,c(1:7,9)]
    srlFrame3 <- cbind(tFrame, srlDomain)
    srlFrame4 <- cbind(srlFrame3, sbFrame)
    
    srlFrame5 <- srlFrame4 %>% pivot_wider(names_from = subdomainId, values_from=subRawScore)
    
    if (missing(studentid) && missing(tDate)) {
        return(srlFrame5)
    } else if (missing(tDate)) {
        vec <- studentid
        dFrame <- filter(srlFrame5, username %in% vec)
        return(dFrame)
    } else {
        vec <- studentid
        dFrame <- filter(srlFrame5, username %in% vec)
        dFrame <- dFrame %>% filter(as.Date(takenDate) == tDate)
        return(dFrame)
    }
    
    
    
}