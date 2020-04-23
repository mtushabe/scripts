import pandas as pd
import json
from dhis2 import Api
#Don't forget to change the credentials to much the ones that you use t access the system.
api = Api("http://prep.mets.or.ug","admin","district")
data = pd.read_csv('deletion.csv')
clientIds= data['unique'].astype(str).tolist()

for item in clientIds:
    teiResult=api.get('trackedEntityInstances',params={'ou':'akV6429SUqu','ouMode':'DESCENDANTS','filter':'wk44sbe36Wm:eq:'+item,'fields':'*'})
    trackedEntityInstances = teiResult.json()['trackedEntityInstances']
    if not trackedEntityInstances:
        print(item +" "+"is currently available!")
    else:
        enrollments = teiResult.json()['trackedEntityInstances'][0]['enrollments']
        teiId = teiResult.json()['trackedEntityInstances'][0]['trackedEntityInstance']
        if trackedEntityInstances and not enrollments:
            response = api.delete('trackedEntityInstances/'+ teiId)
            print(item +" "+"hanging record with this id has been removed!")
        else:
            print(item +" "+"has enrollments attached to it!")

print("Cleaning process done!")
