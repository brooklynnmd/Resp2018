#this script will combine multiple sessions of data

#Read in all the source data ("StemRespBySession" & "readdata")
#--------------------------------------------------------------------------------------#
path<-"~/Documents/GitHub/Resp2018"
setwd(path); source('StemRespBySession.R')

#--------------------------------------------------------------------------------------#
setwd("~/Documents/HF REU/My Project/48HR/data")
mysessions <- list.files()

mysessions <- mysessions[ !grepl("20180625_0700", mysessions) ] 
mysessions <- mysessions[ !grepl("20180625_1100", mysessions) ]
mysessions <- mysessions[ !grepl("20180625_1300", mysessions) ]
mysessions <- mysessions[ !grepl("20180625_1900", mysessions) ]
mysessions <- mysessions[ !grepl("20180626_0100", mysessions) ]
mysessions <- mysessions[ !grepl("20180626_0700", mysessions) ]
mysessions <- mysessions[ !grepl("20180626_1900", mysessions) ]
mysessions <- mysessions[ !grepl("20180626_2200", mysessions) ]
mysessions <- mysessions[ !grepl("20180627_0100", mysessions) ]
mysessions <- mysessions[ !grepl("20180627_0400", mysessions) ]
mysessions <- mysessions[ !grepl("20180627_0700", mysessions) ]

mysessions <- mysessions[ !grepl("20180629_1300", mysessions) ] #only soil
mysessions <- mysessions[ !grepl("20180712_1300", mysessions) ] #only soil
mysessions <- mysessions[ !grepl("20180719_1300", mysessions) ] #only soil
mysessions <- mysessions[ !grepl("20180730_1300", mysessions) ] #only soil

#Call upon the calcSession function sourced above to loop through every session
#--------------------------------------------------------------------------------------#
if (file.exists("stemexpdata.rds")) {
  stemexpdata<-readRDS("stemexpdata.rds") #this saves the data set, won't remake it every time
} else {
  for (i in  1:length(mysessions)){
    
    date_time<-mysessions[i]
    sessiondata<-calcSession(date_time)
      if(i==1){
        stemexpdata <- sessiondata
      }else{
        stemexpdata <- rbind(stemexpdata,sessiondata)
        }
      }
  saveRDS(stemexpdata, file = "stemexpdata.rds")
} 


#Plot using dataframe "stemexpdata"
#--------------------------------------------------------------------------------------#  

#pdf("stemRespRates.pdf")

session_treatment <- paste(stemexpdata$session,stemexpdata$treatment)

#isolate chamber #1
    fluxch    <- stemexpdata$flux [stemexpdata$chamber == 1]
    group     <- session_treatment [stemexpdata$chamber == 1]
    flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length)) #Standard error
    flux_mean <- tapply(fluxch, group, mean) 
    tmp       <- unlist(strsplit(names(flux_mean)," "))
    session   <- tmp[seq(1,length(tmp),2)]
    treatment <- tmp[seq(2,length(tmp),2)]
     
    #For just the initial 48 HR experiment, write in these parameters:
      #xlim<-c(as.POSIXct("20180625",format="%Y%m%d"),as.POSIXct("20180720",format="%Y%m%d"))
      ylim<-c(0,0.050)
    
    plot(session,flux_mean,main="Average Stem Respiration",ylim=ylim) #xlim=xlim, )  
      lines(session[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6")  
      lines(session[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76")
      lines(session[treatment=="compress"],flux_mean[treatment=="compress"],col="red")  
      segments(session[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],session[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      segments(session[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],session[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(session[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],session[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76")  
        
      
  #isolate chamber #2
    fluxch    <- stemexpdata$flux [stemexpdata$chamber == 2]
    group     <- session_treatment [stemexpdata$chamber == 2]
    flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length))
    flux_mean <- tapply(fluxch, group, mean) 
    
    #plot(session,flux_mean,main="Average Stem Respiration",ylim=ylim) #xlim=xlim, )  
      lines(session[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",lty=2)  
      lines(session[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",lty=2)
      lines(session[treatment=="compress"],flux_mean[treatment=="compress"],col="red",lty=2)  
      segments(session[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],session[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      segments(session[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],session[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(session[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],session[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76")  
    
  #isolate chamber #3
    fluxch    <- stemexpdata$flux [stemexpdata$chamber == 3]
    group     <- session_treatment [stemexpdata$chamber == 3]
    flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length))
    flux_mean <- tapply(fluxch, group, mean) 
  
    
    #plot(session,flux_mean,main="Average Stem Respiration",ylim=ylim) #xlim=xlim, )  
      lines(session[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",lty=3)  
      lines(session[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",lty=3)
      lines(session[treatment=="compress"],flux_mean[treatment=="compress"],col="red")  
      segments(session[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],session[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      segments(session[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],session[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(session[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],session[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76") 
    
      legend("top", c("Control", "Compress", "Chilling", "Chamber 1", "Chamber 2", "Chamber 3"), horiz=TRUE)
      
#--------------------------------------------------------------------------------------#  
    

      #Temperature over time
      plot(stemexpdata$timestamp,stemexpdata$airt.C,pch=19,main="Temperature over time")
#--------------------------------------------------------------------------------------#  
      
      #Respiration rate per temperature
      colors<-  ifelse (stemexpdata$treatment=="chilling", "#6BAED6","#41ae76")
      colors[stemexpdata$treatment=="compress"]<-"red"
      plot(stemexpdata$airt.C,stemexpdata$flux,pch=19,main="Resp rates per temperature",
           col=colors)
    
      
      for (tree in sort(unique(stemexpdata$tree))){
        ord<-order(stemexpdata$airt.C[stemexpdata$tree==tree])
        lines(stemexpdata$airt.C[stemexpdata$tree==tree][ord],log(stemexpdata$flux[stemexpdata$tree==tree][ord]))
        model<-lm(log(stemexpdata$flux[stemexpdata$tree==tree])~stemexpdata$airt.C[stemexpdata$tree==tree])
        abline(model)
        #Sys.sleep(1)
      }
      model<-lm(log(stemexpdata$flux)~stemexpdata$airt.C)
      #abline(model,lwd=5,col="pink")
      # We take only the controls for temperature correction
      #model<-lm(log(stemexpdata$flux[stemexpdata$treatment=="control"])~stemexpdata$airt.C[stemexpdata$treatment=="control"])
      abline(model,lwd=5)
      summary(model)
      stemexpdata$flux_tc<- exp(log(stemexpdata$flux) -(stemexpdata$airt.C-20)*coefficients(model)[2]) #20C is our chosen base T

      #plot
      plot(stemexpdata$airt.C[stemexpdata$treatment=="control"],stemexpdata$flux[stemexpdata$treatment=="control"],pch=19,main="Resp rates per temperature",las=1,col=colors[expdata$treatment=="control"]) 
      lines(seq(0,40,0.1),exp(coefficients(model)[2]*seq(0,40,0.1)+coefficients(model)[1]),lwd=2,col="red")
      #plot
      plot(stemexpdata$airt.C,stemexpdata$flux_tc,pch=19,main="Resp rates per temperature",col=colors)
    
#Now, account for temperature when plotting by chamber BY DAY
#--------------------------------------------------------------------------------------#  
op<-par()
par(mar=c(par("mar")[1],par("mar")[2]+1,par("mar")[3],par("mar")[4]))
      session_treatment <- paste(stemexpdata$session,stemexpdata$treatment)
  
#chamber 1
        fluxch    <- stemexpdata$flux_tc [stemexpdata$chamber == 1]
        group     <- paste(strftime(stemexpdata$timestamp,"%j")[stemexpdata$chamber == 1],stemexpdata$treatment[stemexpdata$chamber == 1]) 
        flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length)) #Standard error
        flux_mean <- tapply(fluxch, group, mean) 
        tmp       <- unlist(strsplit(names(flux_mean)," "))
        day       <- as.numeric(tmp[seq(1,length(tmp),2)])
        treatment <- tmp[seq(2,length(tmp),2)]
      
      ylim <- c(0,0.03)
      
      plot(day,flux_mean,main="Stem Respiration Since Chilling",ylim=ylim,las=1,xlab = "Day of the Year",ylab = NA,type="n")  
  mtext(side=2,"Respiration Rate (μmol/sec)",line=4)

        lines(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6") 
        lines(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76")
        points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#FFFFFF",pch=19)  
        points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",pch=1)  
        points(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",pch=19)
        
                # lines(day[treatment=="compress"],flux_mean[treatment=="compress"],col="red")  
        segments(day[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],day[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
        # segments(day[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],day[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
        segments(day[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],day[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76")  
      
      
      #isolate chamber #2
      fluxch    <- stemexpdata$flux_tc [stemexpdata$chamber == 2]
      group     <- paste(strftime(stemexpdata$timestamp,"%j")[stemexpdata$chamber == 2],stemexpdata$treatment[stemexpdata$chamber == 2]) 
      flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length)) #Standard error
      flux_mean <- tapply(fluxch, group, mean) 
      tmp       <- unlist(strsplit(names(flux_mean)," "))
      day       <- as.numeric(tmp[seq(1,length(tmp),2)])
      treatment <- tmp[seq(2,length(tmp),2)]
      
      #plot(session,flux_mean,main="Average Stem Respiration",ylim=ylim) #xlim=xlim, )  
      
      lines(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",lty=2)  
      lines(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",lty=2)
      # lines(day[treatment=="compress"],flux_mean[treatment=="compress"],col="red",lty=2)  
      points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#FFFFFF",pch=19)  
      points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",pch=1)  
      points(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",pch=19)
      
          segments(day[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],day[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      # segments(day[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],day[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(day[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],day[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76")  
      
      #isolate chamber #3
      fluxch    <- stemexpdata$flux_tc [stemexpdata$chamber == 3]
      group     <- paste(strftime(stemexpdata$timestamp,"%j")[stemexpdata$chamber == 3],stemexpdata$treatment[stemexpdata$chamber == 3]) 
      flux_se   <- tapply(fluxch,group,sd)/sqrt(tapply(fluxch,group,length)) #Standard error
      flux_mean <- tapply(fluxch, group, mean) 
      tmp       <- unlist(strsplit(names(flux_mean)," "))
      day       <- as.numeric(tmp[seq(1,length(tmp),2)])
      treatment <- tmp[seq(2,length(tmp),2)]
      
      #plot(session,flux_mean,main="Average Stem Respiration",ylim=ylim) #xlim=xlim, )
      
      lines(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",lty=3)  
      lines(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",lty=3)
      points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#FFFFFF",pch=19)  
      points(day[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",pch=1)  
      points(day[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",pch=19)
      
            # lines(day[treatment=="compress"],flux_mean[treatment=="compress"],col="red")  
      segments(day[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],day[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      # segments(day[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],day[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(day[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],day[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76") 
      
      legend(178,0.0305,c("Control","Chilling"),col=c("#41ae76","#6BAED6"),pch=c(19,1),box.lty = 0)
      legend("topright",c("Top Chamber","Middle Chamber","Bottom Chamber"),col=c("#41ae76","#6BAED6"),inset=.02,lty=c(1,2,3),box.lty=0)
      abline(v=176.546,
             col='black',
             lwd = 4,
             lty = 3)
#--------------------------------------------------------------------------------------#   
      #plot(session,flux_mean1,main="CH 1 Avg stem resp rates over time near start",xlim=xlim, ylim=ylim)  
      lines(session[treatment=="chilling"],flux_mean[treatment=="chilling"],col="#6BAED6",lty=3)  
      lines(session[treatment=="control"],flux_mean[treatment=="control"],col="#41ae76",lty=3)
      lines(session[treatment=="compress"],flux_mean[treatment=="compress"],col="red",lty=3)  
      segments(session[treatment=="chilling"],flux_mean[treatment=="chilling"]-flux_se[treatment=="chilling"],day[treatment=="chilling"],flux_mean[treatment=="chilling"]+flux_se[treatment=="chilling"],col="#6BAED6")  
      segments(session[treatment=="compress"],flux_mean[treatment=="compress"]-flux_se[treatment=="compress"],day[treatment=="compress"],flux_mean[treatment=="compress"]+flux_se[treatment=="compress"],col="red")  
      segments(session[treatment=="control"],flux_mean[treatment=="control"]-flux_se[treatment=="control"],day[treatment=="control"],flux_mean[treatment=="control"]+flux_se[treatment=="control"],col="#41ae76")  
      
      
      
dev.off()
