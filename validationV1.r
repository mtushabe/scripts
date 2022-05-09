shaping <-function(file, supporttype, outputfile, ...) {
    
    #setwd("/cloud/project/files/coding")
    data<-data.table::fread(file, header=TRUE,sep=",",check.names = FALSE,stringsAsFactors=FALSE,quote="\"")
    data.m <- reshape2::melt(data, id=c(1:4)) # the rest of the columns are measure.vars
    data.m$value <- as.numeric(gsub(',', '', data.m$value))
    data.split.supportType<-split(data.m, data.m$`Type of Support`)
    
    if (supporttype=='1') {  # both DSD & TA
        DSD <- data.split.supportType[[1]]
        TA <- data.split.supportType[[2]]
        base1.DSD <- (merge(DSD.lookup, DSD, by.x = 'Indicator_code', by.y = 'variable', all.y=TRUE))
        base2.TA <- (merge(TA.lookup, TA, by = 'Indicator_code', by.y = 'variable', all.y=TRUE))
        
        colnames(base1.DSD)<-mgsub(c("RETURN_FIELD_DSD"),c("RETURN_FIELD"),colnames(base1.DSD))
        colnames(base2.TA)<-mgsub(c("RETURN_FIELD_TA"),c("RETURN_FIELD"),colnames(base2.TA))
        
        merge <- rbind(base1.DSD, base2.TA)
        merge.split<-tidyr::separate(data = merge, col = RETURN_FIELD, into = c("dataElement", "categoryOptionCombo"), sep = "\\;")
        merge.split <- merge.split[, c("dataElement","period","Outlet_ID","categoryOptionCombo","Mechanism ID","value")]
        
        colnames(merge.split)<-mgsub(c("Outlet_ID","Mechanism ID"),c("orgUnit","attributeOptionCombo"),colnames(merge.split))
        
        ImportReady <- merge.split
        ImportReady[is.na(ImportReady)] <- 0
        ImportReady <- ImportReady[-row(ImportReady)[ImportReady == 0],]
        ImportReady.aggregate <- plyr::ddply(ImportReady, c("dataElement","period","orgUnit","categoryOptionCombo","attributeOptionCombo"), plyr::summarize, value = sum(as.numeric(as.character(value))))
        write.csv(ImportReady.aggregate,paste0(outputfile,".csv"),row.names = FALSE)
        
        
    }
    #else if (supporttype=='2'){DSD only
    else { 
        
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

    print (sum(as.numeric(as.character(data.m$value)),na.rm=T))
    print (sum(as.numeric(as.character(ImportReady.aggregate$value))))

    
}



## multi find and replace, start
mgsub <-function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}


##Scripts
install.packages('devtools')
devtools::install_github(repo = "https://github.com/pepfar-datim/datimutils.git", ref = "master")
library(datimvalidation)
require(datimvalidation)

datimutils::loginToDATIM(config_path = "secrets.json")
DSD.lookup<- read.csv("dsd_lookup.csv",header=TRUE,sep=",",check.names = FALSE,stringsAsFactors=FALSE)
shaping("PMTCT_ART_HEI_POS_EID.csv",2,"PMTCT_ART_HEI_POS_EID-Final")
datafile<-"PMTCT_ART_HEI_POS_EID-Final.csv"
d<-d2Parser(filename = datafile ,type = "csv")

checkDataElementOrgunitValidity(data = d,datasets = c("HfhTPdnRWES","HrozVxNYFJy","BHlhyPmRTUY","GEBcXhZw0fD","MGNVwVicMVm"))
checkDataElementDisaggValidity(data=d,datasets = c("HfhTPdnRWES","HrozVxNYFJy","BHlhyPmRTUY","GEBcXhZw0fD","MGNVwVicMVm"))
checkValueTypeCompliance(d)
checkNegativeValues(d)
Violation_PMTCT_ART_HEI_POS_EID<-validateData(data = d,return_violations_only = TRUE)
