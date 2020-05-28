shaping <-function(file, supporttype, outputfile, ...) {
    
    setwd("~/Documents/METS/2020 Q2 REPORTING")
    #setwd("/cloud/project/files/coding")
    #data<-read.csv(file, header=TRUE,sep=",",check.names = FALSE,stringsAsFactors=FALSE)
    data<-data.table::fread(file, header=TRUE,sep=",",check.names = FALSE,stringsAsFactors=FALSE,quote="\"")
    data.m <- reshape2::melt(data, id=c(1:4)) # the rest of the columns are measure.vars
    data.m$value <- as.numeric(gsub(',', '', data.m$value))
    #data.m.split <-tidyr::separate(data = data.m, col = variable, into = c("Indicator_code", "Disagg"), sep = "\\;")
    #data.m.split <-tidyr::separate(data = data.m, col = variable, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
    #data.m.split$Disagg <- NULL
    #sum(as.numeric(as.character(data.m.split$value)),na.rm=T)
    #data.split.supportType<-split(data.m.split, data.m.split$`Type of Support`)
    data.split.supportType<-split(data.m, data.m$`Type of Support`)
    
    if (supporttype=='1') {  # both DSD & TA
        DSD <- data.split.supportType[[1]]
        TA <- data.split.supportType[[2]]
        base1.DSD <- (merge(DSD.lookup, DSD, by.x = 'Indicator_code', by.y = 'variable', all.y=TRUE))
        base2.TA <- (merge(TA.lookup, TA, by = 'Indicator_code', by.y = 'variable', all.y=TRUE))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        #names(base2.TA)[names(base2.TA) == 'RETURN_FIELD_TA'] <- 'RETURN_FIELD'
        
        #colnames(DATIM4U.Dataelements)<-mgsub(c("DeCoC","DataelementDisagg"),c("DeCoC2","DataelementDisagg2"),colnames(DATIM4U.Dataelements))
        
        colnames(base1.DSD)<-mgsub(c("RETURN_FIELD_DSD"),c("RETURN_FIELD"),colnames(base1.DSD))
        colnames(base2.TA)<-mgsub(c("RETURN_FIELD_TA"),c("RETURN_FIELD"),colnames(base2.TA))
        
        merge <- rbind(base1.DSD, base2.TA)
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","Outlet_ID","categoryOptionCombo","Mechanism ID","value")]
        #names(merge.split)[c("DATIM HFID","COP 2016  Mechanism ID")] <- c("orgUnit","IM_code")
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        
        colnames(merge.split)<-mgsub(c("Outlet_ID","Mechanism ID"),c("orgUnit","attributeOptionCombo"),colnames(merge.split))
        
        #setNames(merge.split,c("DATIM HFID","COP 2016  Mechanism ID"),c("orgUnit","IM_code"))
        #names(merge.split)[c(5,7)] <- c("orgUnit","IM_code")
        #merge.split<- merge.split[, -c(1,6,8)]COP 2016  Mechanism ID
        #ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        #ImportReady$IM_code <- NULL
        #ImportReady <- ImportReady[c(1,3,4,2,6,5)]
        #ImportReady <- ImportReady[c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")]
        ImportReady <- merge.split
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #   "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #sum(as.numeric(as.character(ImportReady.aggregate$value)))
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else if (supporttype=='2'){   # DSD only
        
        DSD <- data.split.supportType[[1]]
        base1.DSD <- (merge(DSD.lookup, DSD, by.x = 'Indicator_code', by.y = 'variable', all.y=TRUE))
        
        colnames(base1.DSD)<-mgsub(c("RETURN_FIELD_DSD"),c("RETURN_FIELD"),colnames(base1.DSD))
        
        merge <- rbind(base1.DSD)
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","Outlet_ID","categoryOptionCombo","Mechanism ID","value")]
        
        colnames(merge.split)<-mgsub(c("Outlet_ID","Mechanism ID"),c("orgUnit","attributeOptionCombo"),colnames(merge.split))
        
        ImportReady <- merge.split
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
    }
    else if(supporttype=='3'){  # other support type
        other <- data.split.supportType[[1]]
        base1.other <- (merge(other.lookup, other, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.other)<-mgsub(c("RETURN_FIELD_Other"),c("RETURN_FIELD"),colnames(base1.other))
        #merge <- rbind(base1.other)
        merge <- base1.other
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else if(supporttype=='4'){  # CD4 support type
        cd4 <- data.split.supportType[[1]]
        base1.cd4 <- (merge(cd4.lookup, cd4, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.cd4)<-mgsub(c("RETURN_FIELD_CD4"),c("RETURN_FIELD"),colnames(base1.cd4))
        #merge <- rbind(base1.other)
        merge <- base1.cd4
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else if(supporttype=='5'){  # TB AFB support type
        tb_afb <- data.split.supportType[[1]]
        base1.tb_afb<- (merge(tb_afb.lookup, tb_afb, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.tb_afb)<-mgsub(c("RETURN_FIELD_TB_AFB"),c("RETURN_FIELD"),colnames(base1.tb_afb))
        #merge <- rbind(base1.other)
        merge <- base1.tb_afb
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else if(supporttype=='6'){  # HIV support type
        hiv <- data.split.supportType[[1]]
        base1.hiv<- (merge(hiv.lookup, hiv, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.hiv)<-mgsub(c("RETURN_FIELD_HIV"),c("RETURN_FIELD"),colnames(base1.hiv))
        #merge <- rbind(base1.other)
        merge <- base1.hiv
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else if(supporttype=='7'){  # TB Xpert support type
        tb_xpert <- data.split.supportType[[1]]
        base1.tb_xpert<- (merge(tb_xpert.lookup, tb_xpert, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.tb_xpert)<-mgsub(c("RETURN_FIELD_TB_Xpert"),c("RETURN_FIELD"),colnames(base1.tb_xpert))
        #merge <- rbind(base1.other)
        merge <- base1.tb_xpert
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    else{           # TB Culture support type
        
        tb_culture <- data.split.supportType[[1]]
        base1.tb_culture<- (merge(tb_culture.lookup, tb_culture, by = 'Indicator_code'))
        #names(base1.DSD)[names(base1.DSD) == 'RETURN_FIELD_DSD'] <- 'RETURN_FIELD'
        colnames(base1.tb_culture)<-mgsub(c("RETURN_FIELD_TB_Culture"),c("RETURN_FIELD"),colnames(base1.tb_culture))
        #merge <- rbind(base1.other)
        merge <- base1.tb_culture
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","DATIM orgUnitID","categoryOptionCombo","Mechanism ID","value")]
        #colnames(merge.split)[colnames(merge.split)=="DATIM orgUnitID"] <- "orgUnit"
        #colnames(merge.split)[colnames(merge.split)=="Mechanism ID"] <- "IM_code"
        colnames(merge.split)<-mgsub(c("DATIM orgUnitID","Mechanism ID"),c("orgUnit","IM_code"),colnames(merge.split))
        ImportReady<- (merge(merge.split, Mechanism.lookup, by = 'IM_code'))
        ImportReady$IM_code <- NULL
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        #ImportReady.aggregate <- dplyr::select(ImportReady.aggregate,
        #    "dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo","value")
        #write.csv(ImportReady.aggregate,file=paste0('/cloud/project/files',outputfile,".csv"),row.names = FALSE)
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
    }
    #colnames(merge.split)
    #print (sum(as.numeric(as.character(data.m.split$value)),na.rm=T))
    print (sum(as.numeric(as.character(data.m$value)),na.rm=T))
    print (sum(as.numeric(as.character(ImportReady.aggregate$value))))
    #setwd("/cloud/project/")
    #assertthat::assert_that(sum(as.numeric(as.character(data.m.split$value)),na.rm=T)==sum(as.numeric(as.character(ImportReady.aggregate$value))))
    #sum(as.numeric(as.character(ImportReady$value)))
    
}
