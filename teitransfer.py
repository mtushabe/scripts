import pandas as pd
import json
from dhis2 import Api
api = Api("http://prep.mets.or.ug","admin","district")
data = pd.read_csv('lugore.csv')
uids= data['id'].astype(str).tolist()
for i in uids:
    result=api.put('tracker/ownership/transfer',params={'trackedEntityInstance':i,'program':'F5ZdOBuqlJh','ou':'oSbVEcIxwTX'})
    print (i +" "+ result.json()["message"])
print("Step 1 Done!")

for item in uids:
    teiResult = api.get('trackedEntityInstances',params={'trackedEntityInstance':item,'fields':'*'})
    trackedEntities = teiResult.json()['trackedEntityInstances']
    dict_entity=dict()
    for entity in trackedEntities:
        tei_json =json.dumps(entity)
        tei_json = tei_json.replace("Am5BLrPGyfR","oSbVEcIxwTX")
        tei_json = tei_json.replace("Facility A","Lugore Prisons HC II (Patiko)")
        dict_entity = json.loads(tei_json)
    transfer=api.put('trackedEntityInstances/'+item,data = dict_entity)
    print (item +" "+ transfer.json()["message"])
print("Step 2 Done!")
