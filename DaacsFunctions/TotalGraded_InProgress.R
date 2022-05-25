library(mongolite)

total_graded <- function(collectionConnection) {
    collectionConnection$count('{"status":"GRADED"}')
}


in_progress <- function(conn) {
    conn$count('{"status":"IN_PROGRESS"}')
}
