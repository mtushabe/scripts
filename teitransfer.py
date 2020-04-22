import pandas as pd
import json
from dhis2 import Api
#Don't forget to put the right credentials to the system and also look at the TRACKER program you working with.
api = Api("http://localhost:8181","admin","district")
#Change the path to the file with the tei ids you want to delete.
data = pd.read_csv('mul.csv')
uids= data['id'].astype(str).tolist()
transferFrom = "Facility A"
transferTo = "Facility B"
fromOrg = api.get('organisationUnits',params={'field':'id','filter':'name:eq:'+ transferFrom})
toOrg = api.get('organisationUnits',params={'field':'id','filter':'name:eq:'+ transferTo})
if not fromOrg.json()['organisationUnits']:
    print("Transfer from organisation unit not found!")
elif not toOrg.json()['organisationUnits']:
    print("Transfer from organisation unit not found!")
else:
    transferFromId = fromOrg.json()['organisationUnits'][0]['id']
    transferToId = toOrg.json()['organisationUnits'][0]['id']
    for item in uids:
        result = api.put('tracker/ownership/transfer',params={'trackedEntityInstance':item,'program':'F5ZdOBuqlJh','ou':transferToId})
        teiResult = api.get('trackedEntityInstances',params={'trackedEntityInstance':item,'fields':'*'})
        entity = teiResult.json()['trackedEntityInstances'][0]
        tei_json =json.dumps(entity)
        tei_json = tei_json.replace(transferFromId,transferToId)
        tei_json = tei_json.replace(transferFrom,transferTo)
        dict_entity = json.loads(tei_json)
        transfer = api.put('trackedEntityInstances/'+item,data = dict_entity)
        print (item +" "+ result.json()["message"])
    print("Transfer process done!")
