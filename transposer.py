import pandas as pd

datae = pd.read_csv("OVCServiceOctDec2019.csv")
ids=datae[["OVC ID No"]].copy()
ids.drop_duplicates(keep="first",inplace=True)
template = []
#for i in ids.index:
for idx, identifier in ids.iterrows():
    filtered = datae[datae["OVC ID No"]==identifier["OVC ID No"]]
    temp = {}
    for index, row in filtered.iterrows():
        df = pd.DataFrame(row).transpose()
        dataframe = df[df.columns[~df.isnull().all()]]
        for index, line in dataframe.iterrows():
            temp.update(line.to_dict())
            
    template.append(temp)
final=pd.DataFrame(template)
final.to_csv("OVC-Finale.csv",index=False)    
