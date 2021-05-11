library(datimvalidation)
require(datimvalidation)
secrets<-"secrets.json"
loadSecrets(secrets)
datafile<-"AGYW_PREV-Final.csv"
d<-d2Parser(filename = datafile ,type = "csv")# this throws an error for AGYW_PREV since the attribute option combo used is default(HllvX50cXC0)
#This covers all datasets including the one that has AGYW_PREV that normally throws the invalid data elements error
checkDataElementOrgunitValidity(data = d,datasets = c("jKdHXpBfWop","em1U5x9hhXh","qzVASYuaIey","BPEyzcDb8fT","mbdbMiLZ4AA","zL8TlPVzEBZ"))
checkDataElementDisaggValidity(data=d,datasets = c("jKdHXpBfWop","em1U5x9hhXh","qzVASYuaIey","BPEyzcDb8fT","mbdbMiLZ4AA","zL8TlPVzEBZ"))
checkValueTypeCompliance(d)
checkNegativeValues(d)
Violations_AGYW_PREV <-validateData(data = d, datasets = c("jKdHXpBfWop","em1U5x9hhXh","qzVASYuaIey","mbdbMiLZ4AA","BPEyzcDb8fT"),return_violations_only = TRUE)
savehistory("2020Q1_HISTORY")


DSD.lookup<- read.csv("dsd_lookup",header=TRUE,sep=",",check.names = FALSE,stringsAsFactors=FALSE)
