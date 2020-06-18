import pandas as pd
import json
from dhis2 import Api
#Don't forget to put the right credentials to the system
#api = Api("http://localhost:8181","mtushabe","Justborn@08")
api = Api("https://dreams.mets.or.ug","mtushabe","DREAMS1234!")
#Change the path to the file with the ids
##
#DREAMS- Program ID is YRwgjjgdDvM
#KP- Program ID is F5ZdOBuqlJh
##
transfers = pd.read_csv('transfers.csv')
for index in transfers.index:
    dreamsid=transfers['dreamsuid'][index]
    current =transfers['current'][index]
    rightful =transfers['rightful'][index]
    currentOrg=api.get('organisationUnits',params={'field':'id','filter':'name:eq:'+current})
    rightfulOrg=api.get('organisationUnits',params={'field':'id','filter':'name:eq:'+rightful})
    teiResponse=api.get('trackedEntityInstances',params={'ou':'akV6429SUqu','ouMode':'DESCENDANTS','filter':'NaMm3htbGdZ:eq:'+dreamsid,'fields':'*'})
    trackedEntities=teiResponse.json()['trackedEntityInstances']
    if(trackedEntities):  
        teiId = teiResponse.json()['trackedEntityInstances'][0]['trackedEntityInstance']
        if not currentOrg.json()['organisationUnits']:
            print("Current organisation unit not found!")
        elif not rightfulOrg.json()['organisationUnits']:
            print("Rightful organisation unit not found!")
        else:
            currentOrgId=currentOrg.json()['organisationUnits'][0]['id']
            rightfulOrgId=rightfulOrg.json()['organisationUnits'][0]['id']
            result=api.put('tracker/ownership/transfer',params={'trackedEntityInstance':teiId,'program':'YRwgjjgdDvM','ou':rightfulOrgId})
            teiResult = api.get('trackedEntityInstances',params={'trackedEntityInstance':teiId,'fields':'*'})
            entity = teiResult.json()['trackedEntityInstances'][0]
            tei_json =json.dumps(entity)
            tei_json = tei_json.replace(currentOrgId,rightfulOrgId)
            tei_json = tei_json.replace(current,rightful)
            dict_entity = json.loads(tei_json)
            transfer=api.put('trackedEntityInstances/'+teiId,data = dict_entity)
            print (dreamsid +" "+ result.json()["message"])
    else:
        print("No AGYW with this ID "+dreamsid)
print("Transfer process done!")
