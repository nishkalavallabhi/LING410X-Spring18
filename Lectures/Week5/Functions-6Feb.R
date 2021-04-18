my_square_function <- function(number)
{
  return(number * number)
}
#my_square_function(4) gives you 16

my_number_function <- function(number)
{
  result = c(number*number, number*number*number, number*number*number*number)
  return(result)
}
#my_number_function(4) Gives a vector with values 16, 64, 256