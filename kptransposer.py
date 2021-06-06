import pandas as pd

datae = pd.read_csv("refill.csv")
ids=datae[["Unique Client Number"]].copy()
ids.drop_duplicates(keep="first",inplace=True)
template = []
#for i in ids.index:
for idx, identifier in ids.iterrows():
    filtered = datae[datae["Unique Client Number"]==identifier["Unique Client Number"]]
    temp={}
    temp["id"]=identifier["Unique Client Number"]
    event=0
    for index, row in filtered.iterrows():
        temp["event."+str(event)]=row["Event date"]
        event+=1    
    template.append(temp)
final=pd.DataFrame(template)
final.to_csv("df_refill.csv",index=False)   
