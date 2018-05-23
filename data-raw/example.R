library(e1071)
library(magrittr)
data(iris)
groups <- split(sample(1:nrow(iris)), 1:2)
train <- iris[groups[[1]],]
test <- iris[groups[[2]],]
confs := for(kernel in c("linear", "radial", "polynomial"))
  svm(Species ~ ., train, kernel = kernel) %>%
  predict(test) %>% table(test$Species)
confs
