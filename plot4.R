## Creating a temp file
temp <- tempfile()
## downloading zipped file and storing in temp file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

## unzip file reading data from text file
d = read.table(unz(temp, "household_power_consumption.txt"), 
               header = FALSE, sep=";", skip=1,
               col.names=c("Date", "Time", "Global_active_power", "Global_reactive_power",
                           "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               
)

## replacing ? values with NA
m<-as.matrix(d)
m[m=="?"] <- NA
d <- as.data.frame(m)

## converting Time Column to Time format
d$Time <- strptime(paste(d$Date,d$Time,sep = " "), format = "%d/%m/%Y %T")
## converting Date Column to Date format
d$Date <- as.Date(d$Date, "%d/%m/%Y")


## Subset dataframe to include the data for required dates
d <- subset(d, d$Date >= "2007-02-01" & d$Date <= "2007-02-02")

## Conerting remaining columns from Factor to Numeric
tempNum <- d$Global_active_power
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Global_active_power <- tempNum 
tempNum <- d$Global_reactive_power
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Global_reactive_power <- tempNum
tempNum <- d$Sub_metering_1
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Sub_metering_1 <- tempNum
tempNum <- d$Sub_metering_2
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Sub_metering_2 <- tempNum
tempNum <- d$Sub_metering_3
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Sub_metering_3 <- tempNum
tempNum <- d$Voltage
tempNum <-as.numeric(levels(tempNum ))[tempNum ]
d$Voltage <- tempNum

## Initiating PNG graphics device
png('plot4.png', width = 480, height = 480, units = "px")

## plot Graph
par(mfrow = c(2,2))
##Graph1
plot(d$Time, d$Global_active_power, type='l', ylab="Global Active Power", xlab="")
##Graph2
plot(d$Time, d$Voltage, type='l', ylab="Volgate", xlab="datetime",col="Black")
##Graph3
plot(d$Time, d$Sub_metering_1, type='n', ylab = "Energy sub metering", xlab = "")
lines(d$Time, d$Sub_metering_1, col="Black")
lines(d$Time, d$Sub_metering_2, col="Red")
lines(d$Time, d$Sub_metering_3, col="Blue")
legend("topright", c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"),lty=1,col=c("Black","Red","Blue"), cex=0.75,bty='n')
##Graph4
plot(d$Time, d$Global_reactive_power, type='l', ylab="Global_reactive_power", xlab="datetime",col="Black")

## closing graphics device
dev.off()