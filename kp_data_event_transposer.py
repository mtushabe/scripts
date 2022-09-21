import pandas as pd
import json
import requests


data = pd.read_csv("transpose.csv")
data1 = data[['Enrollment date', 'Eligible for PREP', 'Outcome of baseline visit','PREP_01 Reason for declining PREP','Unique Identification Code','Population Category','Age (Years)','Sex at birth','Marital Status','Education level','Religion','Address LC1 / Village / Zone / Cell','Address Parish / Ward','Sub-County','Address District','Prevention Service Assessed for PrEP eligibility at followup','Initiated on PREP','Number of days / pills PrEP dispensed at initiation']]
data_keep_first = data1.groupby('Unique Identification Code',as_index=False).first()
data_full = data1.dropna(thresh=12)
df_merged = data_full.append(data_keep_first)
df_merged1=df_merged.groupby('Unique Identification Code',as_index=False).first()


ids=data[["Unique Identification Code"]].copy()
ids.drop_duplicates(keep="first",inplace=True)
template = []
#for i in ids.index:
for idx, identifier in ids.iterrows():
    filtered = data[data["Unique Identification Code"]==identifier["Unique Identification Code"]]
    temp={}
    temp["Unique Identification Code"]=identifier["Unique Identification Code"]
    event=1
    for index, row in filtered.iterrows():
        temp["event_"+str(event)]=row["Event date"]
        event+=1    
    template.append(temp)
df_events=pd.DataFrame(template)

left_merged = pd.merge(df_merged1, df_events, how="left", on=["Unique Identification Code"])
left_merged.to_csv("cleaned_data.csv",index=False)
