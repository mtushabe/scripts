#! /bin/bash

cd /home/mtushabe/dreamsbackup/

sudo rm -r dreams.mets*

mkdir -p /home/mtushabe/dreamsbackup/dreamsdump

mkdir -p /home/mtushabe/dreamsbackup/usaiddreamsdump

mkdir -p /home/mtushabe/dreamsbackup/muwrpdreamsdump

chmod 777 /home/mtushabe/dreamsbackup/dreamsdump

chmod 777 /home/mtushabe/dreamsbackup/usaiddreamsdump

chmod 777 /home/mtushabe/dreamsbackup/muwrpdreamsdump

PGPASSWORD=_Postgres12_ psql -U postgres -p 5432 -h localhost -d dreams182 -f /home/mtushabe/dreamsbackup/staging/staging13052023_test.sql

PGPASSWORD=_Postgres12_  psql -U postgres << END_OF_SCRIPT
\c dreams182

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_cash_transfer_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/cashtransfer.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_contraceptive_mix_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/contraceptives.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_ic s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/dreamsic.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflateen_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/aflateen.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sti_screening_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/sti_screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflatoun_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/aflatoun.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_condom_provision_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/condoms.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_exit s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/dreamsexit.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_educ_subsidy_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/educsubsidy.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_prep s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/prep.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_partner_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/partnerservices.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_pvc_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/pvc.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sasa_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/sasa.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sbhvp_w2 s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/sbhvp.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_economic_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL ) TO '/home/mtushabe/dreamsbackup/dreamsdump/ses.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_hts_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/hts.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sinovuyo_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/sinovuyo.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sstones_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/sstones.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screeningdate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening_old s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screeningdate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/screening_old.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_no_means_no_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/nomeansno.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_eses_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/eses.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_alcohol_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/mental_health_and_alcohol.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_psychosocial_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/mental_health_and_psychosocial.csv' (format CSV, HEADER);

\copy (SELECT * FROM staging.stage_screening_for_eligibility_w WHERE executiondate IS NOT NULL) TO '/home/mtushabe/dreamsbackup/dreamsdump/screening_for_eligibility.csv' (format CSV, HEADER);

\copy (SELECT n.programinstanceid, n.htc, n.sstones, n.sinovuyo, n.sbhvp, n.sasa, n.pvc, n.partner_services, n.educ_subsidy, n.econ_services, n.contraceptive_mix, n.condom_provision, n.cash_transfer, n.prep, n.dreams_ic, n.dreams_exit,l.* FROM staging.agyw_srv_no n JOIN staging.agyws_list l ON n.trackedentityinstanceid = l.trackedentityinstanceid ) TO '/home/mtushabe/dreamsbackup/dreamsdump/girlandnumberservicesreceived.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_cash_transfer_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/cashtransfer.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_contraceptive_mix_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/contraceptives.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_ic s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/dreamsic.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_condom_provision_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/condoms.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_exit s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/dreamsexit.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflateen_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/aflateen.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sti_screening_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/sti_screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_alcohol_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/mental_health_and_alcohol.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_psychosocial_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/mental_health_and_psychosocial.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflatoun_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/aflatoun.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_eses_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/eses.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_educ_subsidy_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/educsubsidy.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_prep s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/prep.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_partner_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/partnerservices.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_pvc_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/pvc.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sasa_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/sasa.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sbhvp_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/sbhvp.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_economic_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426) ) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/ses.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_hts_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/hts.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sinovuyo_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/sinovuyo.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sstones_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/sstones.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_no_means_no_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/no_means_no.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screeningdate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening_old s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screeningdate IS NOT NULL AND s.organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/screening_old.csv' (format CSV, HEADER);

\copy (SELECT * FROM staging.stage_screening_for_eligibility_w WHERE executiondate IS NOT NULL  AND organisationunitid IN (313,320,369,763,996,1048,1050,1058,1084,1412,1353,1436,1452,1455,1456,1567,329,353,354,1626,672,375,1608,494,193598006,1052,1055,193598011,193598020,193598031,193598047,1433,1446,1454,1573,193598146,1612,1603,1579,332,620,681,1269,312,319,321,333,339,367,1609,1057,1059,1304,1397,1398,1464,394,415,473,145181396,145181443,733,741,746,782,843,145181476,1349,1363,1474,1475,145181478,1504,413,991,1046,1047,1387,86751699,1415,1585,1602,1605,342,674,770,1076,1161,1219,1298,1425,1426)) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/screening_for_eligibility.csv' (format CSV, HEADER);

\copy (SELECT n.programinstanceid, n.htc, n.sstones, n.sinovuyo, n.sbhvp, n.sasa, n.pvc, n.partner_services, n.educ_subsidy, n.econ_services, n.contraceptive_mix, n.condom_provision, n.cash_transfer, n.prep, n.dreams_ic, n.dreams_exit,l.* FROM staging.agyw_srv_no n JOIN staging.agyws_list l ON n.trackedentityinstanceid = l.trackedentityinstanceid ) TO '/home/mtushabe/dreamsbackup/usaiddreamsdump/girlandnumberservicesreceived.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_cash_transfer_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/cashtransfer.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_contraceptive_mix_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/contraceptives.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_ic s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/dreamsic.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_condom_provision_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/condoms.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_dreams_exit s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/dreamsexit.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_educ_subsidy_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/educsubsidy.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_prep s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/prep.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_partner_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/partnerservices.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_pvc_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/pvc.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflateen_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/aflateen.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sti_screening_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/sti_screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_alcohol_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/mental_health_and_alcohol.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_mental_health_and_psychosocial_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/mental_health_and_psychosocial.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_aflatoun_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/aflatoun.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_eses_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/eses.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sasa_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/sasa.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sbhvp_w2 s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/sbhvp.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_economic_services_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568) ) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/ses.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_hts_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/hts.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sinovuyo_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/sinovuyo.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_sstones_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/sstones.csv' (format CSV, HEADER);


\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_no_means_no_w s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.executiondate IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/nomeansno.csv' (format CSV, HEADER);

\copy (SELECT * FROM staging.stage_screening_for_eligibility_w WHERE executiondate IS NOT NULL AND organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/screening_for_eligibility_muwrp.csv' (format CSV, HEADER);

\copy (SELECT n.programinstanceid, n.htc, n.sstones, n.sinovuyo, n.sbhvp, n.sasa, n.pvc, n.partner_services, n.educ_subsidy, n.econ_services, n.contraceptive_mix, n.condom_provision, n.cash_transfer, n.prep, n.dreams_ic, n.dreams_exit,l.* FROM staging.agyw_srv_no n JOIN staging.agyws_list l ON n.trackedentityinstanceid = l.trackedentityinstanceid ) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/girlandnumberservicesreceived.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screening
date IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/screening.csv' (format CSV, HEADER);

\copy (SELECT d.trackedentityinstanceid, d.dreams_id, s.* FROM staging.stage_screening_old s JOIN programinstance p ON s.programinstanceid = p.programinstanceid JOIN staging.d_agyws_w d ON p.trackedentityinstanceid = d.trackedentityinstanceid WHERE s.screening
date IS NOT NULL AND s.organisationunitid IN (1326,1196,838,1220,1135,2428,1516,2429,939,983,1015,1253,1234,1330,1568)) TO '/home/mtushabe/dreamsbackup/muwrpdreamsdump/screening_old.csv' (format CSV, HEADER);

END_OF_SCRIPT

zip -r "dreamsdatadump-$(date +"%Y-%m-%d").zip" dreamsdump

zip -r "usaiddreamsdump-$(date +"%Y-%m-%d").zip" usaiddreamsdump

zip -r "muwrpdreamsdump-$(date +"%Y-%m-%d").zip" muwrpdreamsdump

rm /home/mtushabe/apps/download-app/downloads/*

rm /home/mtushabe/apps/us-dreams-app/downloads/*

#rm -r /home/mtushabe/apps/download-app/downloads

#mkdir /home/mtushabe/apps/download-app/downloads

cp "dreamsdatadump-$(date +"%Y-%m-%d").zip" /home/mtushabe/apps/download-app/downloads

cp "usaiddreamsdump-$(date +"%Y-%m-%d").zip" /home/mtushabe/apps/download-app/downloads

cp "muwrpdreamsdump-$(date +"%Y-%m-%d").zip" /home/mtushabe/apps/download-app/downloads

cp "muwrpdreamsdump-$(date +"%Y-%m-%d").zip" /home/mtushabe/apps/us-dreams-app/downloads

cp "usaiddreamsdump-$(date +"%Y-%m-%d").zip" /home/mtushabe/apps/us-dreams-app/downloads

rm -r /home/mtushabe/dreamsbackup/dreamsdump

rm -r /home/mtushabe/dreamsbackup/usaiddreamsdump

rm -r /home/mtushabe/dreamsbackup/muwrpdreamsdump

rm -rf "dreamsdatadump-$(date +"%Y-%m-%d").zip"

rm -rf "usaiddreamsdump-$(date +"%Y-%m-%d").zip"

rm -rf "muwrpdreamsdump-$(date +"%Y-%m-%d").zip"
