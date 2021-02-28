Once upon a time, there were two railway trains competing for the passenger
traffic of 1000 people leaving from Chicago at the same hour and going to Los
Angeles. Assume that passengers are equally likely to choose each train. How
many seats must a train have to assure a probability of .99 or better of having
a seat for each passenger?
    


#Variables
#Number of people waiting for the train
n <- 1000

q <- 1 - p

#Probability of a person taking a train
p <- .50

#Mean
mu <- n * p

#STD
#sqrt(n * p * q)
std <- sqrt(mu * q)

#Z --> 2.33
k <- ((2.33*std)) + 500 - 0.5

