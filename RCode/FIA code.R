#4/3/2017 



#FIA modern forest density
#density given by plot and by taxa within the plot
#soo the necessary steps are:
  #sum up taxa data within each plot to get overall plot density
  #calculate the average plot densities for the east and west
  #as well as the island

#setwd("~/Dropbox/YR_Manuscript/YellowRiver_Indiana")
setwd("~/Documents/YR/YellowRiver_Indiana")

fia=read.csv("./Data/FIA_density_4-3-17.csv")
head(fia)
View(fia)
dim(fia)

plot = aggregate(density ~ ID, fia, sum)
#plot$diam=aggregate(dbh ~ ID, fia, mean)
View(plot)
plot$line="NA"
plot$line[1:14]="West"
plot$line[15:20]="East"
plotW<-subset(plot, line=='West')
plotE<-subset(plot, line=='East')
dim(plotW)
dim(plotE)

dW=mean(plotW$density,na.rm=TRUE)
dW #[1] 111.5318

seW=sd(plotW$density,na.rm=TRUE)/sqrt(length(which(!is.na(plotW$density))))
seW #[1] 22.08739

dE=mean(plotE$density,na.rm=TRUE)
dE #[1] 161.1014

seE=sd(plotE$density,na.rm=TRUE)/sqrt(length(which(!is.na(plotE$density))))
seE #[1] 31.75943


modt=t.test(density~line,var.equal=T, data=plot,na.rm=TRUE)
modt

results=list(dW,seW,dE,seE,modt)
names(results)=c("Mod densW","se densw","Mod densE","se dense","t-test mod")
results

sink(file = paste("./Results/FIAdensity.txt", sep=""))
results
sink()



#also need FIA composition and average diameter
#for this we do not want just plot-level density: use the other data file

fiadbh=read.csv("./Data/FIA_dbh_composition.csv")


#first: dbh
#calculate averages, SE, and run a t-test to compare

View(fiadbh)  #170 total trees
#subset the tree2 data by Other and Oak buffers
other.oak<-subset(fiadbh, Buffer=="Other"|Buffer=="Oak")
View(other.oak)
#run the t-test for the diameter (in meters)
dbh <-t.test(dbh~Buffer,var.equal=T, data=other.oak)
dbh


#standard error function with code to remove NAs
se <- function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))

#subset the other.oak data to just select the Buffer = Oak trees and to just select the Buffer = Other trees
oak<-subset(other.oak, Buffer=="Oak")
other <-subset(other.oak, Buffer=="Other")

#calculate the standard error (and just for fun to compare to the means reported by the t-tests, I have calculated the mean)
#variables are: Available_Water_Storage_5_20, 

se <- function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))

se_diam_oak <- se(oak$dbh)
se_diam_other <- se(other$dbh)

se_diam_oak
se_diam_other

# Print output 
### BE CAREFUL YOU DON'T OVERWRITE PREVIOUS RESULTS IF YOU ARE RUNNING THIS AGAIN! ####
output <- list(FIAdiameter = dbh, sediam_oak = se_diam_oak, sediam_other = se_diam_other)
sink(file = paste("./Results/FIA_DBH_",Sys.Date(), sep=""))
output
sink()







#composition
#tbe two buffers are already subsetted by "oak and "other"
#species composition of vegetation in WEST
library(plyr)
A<-count(oak,"L3_tree1") #freq table west, oak
View(A)
str(A)

Percentage<-(A$freq/nrow(oak))*100 #add percentages based on # in oak/west
WestC<-cbind(A,Percentage)
WestC


write.table(WestC,file='./Data/WestFIAComp.csv', sep=",", col.names=NA)

#species composition of vegetation in EAST

B<-count(other,"L3_tree1")
View(B)
str(B)

Percentage1<-B$freq/nrow(other)*100
EastC<-cbind(B,Percentage1)
EastC

write.table(EastC,file='./Data/EastFIAComp.csv', sep=",", col.names=NA)




