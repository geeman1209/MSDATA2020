#Creates the Connection Class 
#Users will need to enter user, password, host, port, and database as paramaters 
Connection <- setRefClass("Connector",
                          fields = list(
                              host = "character",
                              port = "numeric",
                              db = "character",
                              user = "character",
                              password = "character"
                          ),
                          methods = list(
                              CreateUrl = function(user,password,host,port,db) {
                                  url2return <- paste0('mongodb://', user, ':', password, '@', host, ':', port, '/', db)
                                  return(url2return)
                              }
                          ))