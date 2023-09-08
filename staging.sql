--
-- PostgreSQL database dump
--

-- Dumped from database version 11.14 (Ubuntu 11.14-1.pgdg18.04+1)
-- Dumped by pg_dump version 13.5 (Ubuntu 13.5-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: staging; Type: SCHEMA; Schema: -; Owner: postgres
--
DROP SCHEMA staging CASCADE;;


CREATE SCHEMA staging;


ALTER SCHEMA staging OWNER TO postgres;

--
-- Name: program_stage_data_l; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.program_stage_data_l AS
 SELECT psi.programinstanceid,
    psi.programstageinstanceid,
    psi.programstageid,
    psi.executiondate,
    psi.duedate,
    psi.organisationunitid,
    psi.status,
    psd.dataelementid,
    de.name,
    ( SELECT ted.value
           FROM public.trackedentitydatavalue ted
          WHERE ((ted.programstageinstanceid = psi.programstageinstanceid) AND (ted.dataelementid = psd.dataelementid))) AS val,
    ( SELECT pi.status
           FROM public.programinstance pi
          WHERE (pi.programinstanceid = psi.programinstanceid)) AS program_status
   FROM (((public.programstageinstance psi
     JOIN public.programstage ps ON ((psi.programstageid = ps.programstageid)))
     JOIN public.programstagedataelement psd ON ((ps.programstageid = psd.programstageid)))
     JOIN public.dataelement de ON ((de.dataelementid = psd.dataelementid)))
  ORDER BY psi.programinstanceid, psi.programstageinstanceid, psd.sort_order;


ALTER TABLE staging.program_stage_data_l OWNER TO postgres;


--
-- Name: stage_sti_screning_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sti_screening_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 279457617) THEN l.val
            ELSE NULL::character varying
        END)::text) AS agyw_screened_for_sti,
    max((
        CASE
            WHEN (l.dataelementid = 1835) THEN l.val
            ELSE NULL::character varying
        END)::text) AS abnormal_virginal_discharge,
                    max((
        CASE
            WHEN (l.dataelementid = 279055826) THEN l.val
            ELSE NULL::character varying
        END)::text) AS genital_itching,
                    max((
        CASE
            WHEN (l.dataelementid = 279056183) THEN l.val
            ELSE NULL::character varying
        END)::text) AS genital_ulcers,
                    max((
        CASE
            WHEN (l.dataelementid = 1834) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lower_abdominal_pain,
                    max((
        CASE
            WHEN (l.dataelementid = 1837) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sti_pain_during_intercourse,
                    max((
        CASE
            WHEN (l.dataelementid = 279057394) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_treated_for_sti_in_last_8_weeks,
                max((
        CASE
            WHEN (l.dataelementid = 279058651) THEN l.val
            ELSE NULL::character varying
        END)::text) AS action_taken,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 279064628) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sti_screening_w OWNER TO postgres;

--
-- Name: stage_cash_transfer_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_cash_transfer_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1752) THEN l.val
            ELSE NULL::character varying
        END)::text) AS cash_transfer,
    max((
        CASE
            WHEN (l.dataelementid = 2569) THEN l.val
            ELSE NULL::character varying
        END)::text) AS transfer_date,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1910) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_cash_transfer_w OWNER TO postgres;

--
-- Name: stage_condom_provision_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_condom_provision_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1741) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received,
    max(
        CASE
            WHEN (l.dataelementid = 1686) THEN (l.val)::integer
            ELSE NULL::integer
        END) AS no_condoms,
    max((
        CASE
            WHEN (l.dataelementid = 1736) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dpoint,
    max((
        CASE
            WHEN (l.dataelementid = 1734) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dname,
    max((
        CASE
            WHEN (l.dataelementid = 1761) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dcontact,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1915) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_condom_provision_w OWNER TO postgres;

--
-- Name: stage_contraceptive_mix_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_contraceptive_mix_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1774) THEN l.val
            ELSE NULL::character varying
        END)::text) AS anc,
    max((
        CASE
            WHEN (l.dataelementid = 1781) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pnc,
    max((
        CASE
            WHEN (l.dataelementid = 1745) THEN l.val
            ELSE NULL::character varying
        END)::text) AS contraceptive_services,
    max((
        CASE
            WHEN (l.dataelementid = 1772) THEN l.val
            ELSE NULL::character varying
        END)::text) AS injectables,
    max((
        CASE
            WHEN (l.dataelementid = 1746) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dinjectables,
    max((
        CASE
            WHEN (l.dataelementid = 1773) THEN l.val
            ELSE NULL::character varying
        END)::text) AS implants,
    max((
        CASE
            WHEN (l.dataelementid = 2556) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dimplants,
    max((
        CASE
            WHEN (l.dataelementid = 1775) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iuds,
    max((
        CASE
            WHEN (l.dataelementid = 2557) THEN l.val
            ELSE NULL::character varying
        END)::text) AS diuds,
    max((
        CASE
            WHEN (l.dataelementid = 1776) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pills,
    max((
        CASE
            WHEN (l.dataelementid = 2558) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dpills,
    max((
        CASE
            WHEN (l.dataelementid = 1780) THEN l.val
            ELSE NULL::character varying
        END)::text) AS monthly_beads,
    max((
        CASE
            WHEN (l.dataelementid = 2559) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dmonthlybeads,
    max((
        CASE
            WHEN (l.dataelementid = 1816) THEN l.val
            ELSE NULL::character varying
        END)::text) AS tubligations,
    max((
        CASE
            WHEN (l.dataelementid = 2560) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dtubligations,
    max((
        CASE
            WHEN (l.dataelementid = 1769) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other,
    max((
        CASE
            WHEN (l.dataelementid = 1770) THEN l.val
            ELSE NULL::character varying
        END)::text) AS specify,
    max((
        CASE
            WHEN (l.dataelementid = 2561) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dother,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1914) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_contraceptive_mix_w OWNER TO postgres;

--
-- Name: stage_dreams_exit; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_dreams_exit AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 22396166) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_for_exiting_dreams,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445464) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_dreams_exit OWNER TO postgres;

--
-- Name: stage_dreams_ic; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_dreams_ic AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 19443779) THEN l.val
            ELSE NULL::character varying
        END)::text) AS life_skills_training_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443797) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_life_skills_training_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS menstrual_hygiene_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443813) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_menstrual_hygiene_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443832) THEN l.val
            ELSE NULL::character varying
        END)::text) AS mentorship_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443873) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_mentorship_received,
    max((
        CASE
            WHEN (l.dataelementid = 19444111) THEN l.val
            ELSE NULL::character varying
        END)::text) AS returned_to_school,
    max((
        CASE
            WHEN (l.dataelementid = 19444135) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_returned_to_school,
    max((
        CASE
            WHEN (l.dataelementid = 19444253) THEN l.val
            ELSE NULL::character varying
        END)::text) AS interschool_competition,
    max((
        CASE
            WHEN (l.dataelementid = 19444348) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_interschool_competition,
    max((
        CASE
            WHEN (l.dataelementid = 19444557) THEN l.val
            ELSE NULL::character varying
        END)::text) AS train_on_gbv_prevention,
    max((
        CASE
            WHEN (l.dataelementid = 19444575) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_train_on_gbv_prevention,
    max((
        CASE
            WHEN (l.dataelementid = 19444627) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_prevention_information,
    max((
        CASE
            WHEN (l.dataelementid = 19444802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_prevention_information_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444821) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring,
    max((
        CASE
            WHEN (l.dataelementid = 19444840) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444885) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring_date2,
    max((
        CASE
            WHEN (l.dataelementid = 19444886) THEN l.val
            ELSE NULL::character varying
        END)::text) AS radio_production_skills,
    max((
        CASE
            WHEN (l.dataelementid = 19444914) THEN l.val
            ELSE NULL::character varying
        END)::text) AS radio_production_skills_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444922) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economic_skills_training,
    max((
        CASE
            WHEN (l.dataelementid = 19444923) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economic_skills_training_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444924) THEN l.val
            ELSE NULL::character varying
        END)::text) AS market_training,
    max((
        CASE
            WHEN (l.dataelementid = 19444936) THEN l.val
            ELSE NULL::character varying
        END)::text) AS market_training_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444944) THEN l.val
            ELSE NULL::character varying
        END)::text) AS che_mentorship,
    max((
        CASE
            WHEN (l.dataelementid = 19444964) THEN l.val
            ELSE NULL::character varying
        END)::text) AS che_mentorship_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444996) THEN l.val
            ELSE NULL::character varying
        END)::text) AS followup_meetings_attended,
    max((
        CASE
            WHEN (l.dataelementid = 19445000) THEN l.val
            ELSE NULL::character varying
        END)::text) AS followup_meetings_attended_date,
    max((
        CASE
            WHEN (l.dataelementid = 19445023) THEN l.val
            ELSE NULL::character varying
        END)::text) AS started_business,
    max((
        CASE
            WHEN (l.dataelementid = 19445024) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_started_business,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445397) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_dreams_ic OWNER TO postgres;

--
-- Name: stage_economic_services_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_economic_services_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1748) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sdate,
    max((
        CASE
            WHEN (l.dataelementid = 1786) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_training,
    max((
        CASE
            WHEN (l.dataelementid = 5525) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_date,
    max((
        CASE
            WHEN (l.dataelementid = 1794) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_training,
    max((
        CASE
            WHEN (l.dataelementid = 5526) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_date,
    max((
        CASE
            WHEN (l.dataelementid = 1795) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_support,
    max((
        CASE
            WHEN (l.dataelementid = 5527) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_date,
    max((
        CASE
            WHEN (l.dataelementid = 1796) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_silc,
    max((
        CASE
            WHEN (l.dataelementid = 5528) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_silc_date,
    max((
        CASE
            WHEN (l.dataelementid = 28357003) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ses_services,
    l.program_status,
    max((
        CASE
            WHEN (l.dataelementid = 22395429) THEN l.val
            ELSE NULL::character varying
        END)::text) AS entrepreneurship,
    max((
        CASE
            WHEN (l.dataelementid = 22395443) THEN l.val
            ELSE NULL::character varying
        END)::text) AS entrepreneurship_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752791) THEN l.val
            ELSE NULL::character varying
        END)::text) AS microfinance,
    max((
        CASE
            WHEN (l.dataelementid = 22752830) THEN l.val
            ELSE NULL::character varying
        END)::text) AS microfinance_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752562) THEN l.val
            ELSE NULL::character varying
        END)::text) AS business_skills,
    max((
        CASE
            WHEN (l.dataelementid = 22752605) THEN l.val
            ELSE NULL::character varying
        END)::text) AS business_skills_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752686) THEN l.val
            ELSE NULL::character varying
        END)::text) AS startup_kits,
    max((
        CASE
            WHEN (l.dataelementid = 22752755) THEN l.val
            ELSE NULL::character varying
        END)::text) AS start_upkitsdate,
    max((
        CASE
            WHEN (l.dataelementid = 5525) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 15048929) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 5526) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 15048892) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 148436913) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_package,
    max((
        CASE
            WHEN (l.dataelementid = 5527) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 15048975) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 5528) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 15048805) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 22395443) THEN l.val
            ELSE NULL::character varying
        END)::text) AS entrepreneurship_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 22395451) THEN l.val
            ELSE NULL::character varying
        END)::text) AS entrepreneurship_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752830) THEN l.val
            ELSE NULL::character varying
        END)::text) AS microfinance_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752902) THEN l.val
            ELSE NULL::character varying
        END)::text) AS microfinance_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752605) THEN l.val
            ELSE NULL::character varying
        END)::text) AS business_skills_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 22752649) THEN l.val
            ELSE NULL::character varying
        END)::text) AS business_skills_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 150082946) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_financial_literacy_done,
    max((
        CASE
            WHEN (l.dataelementid = 150083456) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_vsla_done,
    max((
        CASE
            WHEN (l.dataelementid = 148437110) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_vocational_skills_done,
    max((
        CASE
            WHEN (l.dataelementid = 150084404) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_iga_done,
    max((
        CASE
            WHEN (l.dataelementid = 148443286) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_business_skills_done,
    max((
        CASE
            WHEN (l.dataelementid = 148443442) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_microfinance_done,
    max((
        CASE
            WHEN (l.dataelementid = 150085696) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_days_entrepreneurship_done
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1917) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_economic_services_w OWNER TO postgres;

--
-- Name: stage_educ_subsidy_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_educ_subsidy_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1755) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received,
    max((
        CASE
            WHEN (l.dataelementid = 2570) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_recieved,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1913) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_educ_subsidy_w OWNER TO postgres;

--
-- Name: stage_hts_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_hts_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 1721) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hts_result,
    max((
        CASE
            WHEN (l.dataelementid = 2286) THEN l.val
            ELSE NULL::character varying
        END)::text) AS linked_to_care,
    max((
        CASE
            WHEN (l.dataelementid = 35249726) THEN l.val
            ELSE NULL::character varying
        END)::text) AS screened_for_hts,
    max((
        CASE
            WHEN (l.dataelementid = 35253499) THEN l.val
            ELSE NULL::character varying
        END)::text) AS tested_for_hiv,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1911) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_hts_w OWNER TO postgres;

--
-- Name: stage_partner_services_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_partner_services_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1722) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fname,
    max((
        CASE
            WHEN (l.dataelementid = 1723) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lname,
    max((
        CASE
            WHEN (l.dataelementid = 1724) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_type,
    max((
        CASE
            WHEN (l.dataelementid = 1725) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_status,
    max((
        CASE
            WHEN (l.dataelementid = 1756) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vmmc_status,
    max((
        CASE
            WHEN (l.dataelementid = 1726) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_contact,
        max((
        CASE
            WHEN (l.dataelementid = 276546187) THEN l.val
            ELSE NULL::character varying
        END)::text) AS Partner_Ownership_type,
    max((
        CASE
            WHEN (l.dataelementid = 1727) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_address,
    max((
        CASE
            WHEN (l.dataelementid = 1728) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_traced,
    max((
        CASE
            WHEN (l.dataelementid = 1759) THEN l.val
            ELSE NULL::character varying
        END)::text) AS htc,
         max((
        CASE
            WHEN (l.dataelementid = 1778) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sti,
    max((
        CASE
            WHEN (l.dataelementid = 1758) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vmmc,
    max((
        CASE
            WHEN (l.dataelementid = 1760) THEN l.val
            ELSE NULL::character varying
        END)::text) AS art,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1906) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
      GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_partner_services_w OWNER TO postgres;

--
-- Name: stage_prep; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_prep AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
            max((
        CASE
            WHEN (l.dataelementid = 276752755) THEN l.val
            ELSE NULL::character varying
        END)::text) AS visit_type,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
                    max((
        CASE
            WHEN (l.dataelementid = 250314692) THEN l.val
            ELSE NULL::character varying
        END)::text) AS agyw_screened_for_prep,
                    max((
        CASE
            WHEN (l.dataelementid = 19443584) THEN l.val
            ELSE NULL::character varying
        END)::text) AS initiated_on_prep,
                    max((
        CASE
            WHEN (l.dataelementid = 19443653) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_initiated_on_prep,
                    max((
        CASE
            WHEN (l.dataelementid = 276746971) THEN l.val
            ELSE NULL::character varying
        END)::text) AS initiating_health_facility,
                    max((
        CASE
            WHEN (l.dataelementid = 276750251) THEN l.val
            ELSE NULL::character varying
        END)::text) AS prep_id_no,
                        max((
        CASE
            WHEN (l.dataelementid = 276751268) THEN l.val
            ELSE NULL::character varying
        END)::text) AS declined_prep,
    max((
        CASE
            WHEN (l.dataelementid = 19443584) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received_prep,
    max((
        CASE
            WHEN (l.dataelementid = 19443653) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_received_prep,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445321) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_prep OWNER TO postgres;

--
-- Name: stage_pvc_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_pvc_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
      max((
        CASE
            WHEN (l.dataelementid = 279244476) THEN l.val
            ELSE NULL::character varying
        END)::text) AS screened_for_gbv,
    max((
        CASE
            WHEN (l.dataelementid = 1787) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economical,
    max((
        CASE
            WHEN (l.dataelementid = 1782) THEN l.val
            ELSE NULL::character varying
        END)::text) AS physical,
    max((
        CASE
            WHEN (l.dataelementid = 1788) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sexual,
    max((
        CASE
            WHEN (l.dataelementid = 1783) THEN l.val
            ELSE NULL::character varying
        END)::text) AS psychosocial,
                    max((
        CASE
            WHEN (l.dataelementid = 1817) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pep,
                    max((
        CASE
            WHEN (l.dataelementid = 1818) THEN l.val
            ELSE NULL::character varying
        END)::text) AS linked_police,
    max((
        CASE
            WHEN (l.dataelementid = 1819) THEN l.val
            ELSE NULL::character varying
        END)::text) AS psychosocial_support,
    max((
        CASE
            WHEN (l.dataelementid = 1820) THEN l.val
            ELSE NULL::character varying
        END)::text) AS emergency_contraception,
    max((
        CASE
            WHEN (l.dataelementid = 1759) THEN l.val
            ELSE NULL::character varying
        END)::text) AS htc,
    max((
        CASE
            WHEN (l.dataelementid = 1778) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sti,
                    max((
        CASE
            WHEN (l.dataelementid = 1789) THEN l.val
            ELSE NULL::character varying
        END)::text) AS contraceptive_mix,
    max((
        CASE
            WHEN (l.dataelementid = 1791) THEN l.val
            ELSE NULL::character varying
        END)::text) AS stepping_stones,
    max((
        CASE
            WHEN (l.dataelementid = 1793) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sasa,
    max((
        CASE
            WHEN (l.dataelementid = 1784) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sinovuyo,

    max((
        CASE
            WHEN (l.dataelementid = 1777) THEN l.val
            ELSE NULL::character varying
        END)::text) AS cash_transfer,
    max((
        CASE
            WHEN (l.dataelementid = 1790) THEN l.val
            ELSE NULL::character varying
        END)::text) AS condom_provision,
    max((
        CASE
            WHEN (l.dataelementid = 1785) THEN l.val
            ELSE NULL::character varying
        END)::text) AS education_subsidy,
    max((
        CASE
            WHEN (l.dataelementid = 1792) THEN l.val
            ELSE NULL::character varying
        END)::text) AS combined_social_economic,
    max((
        CASE
            WHEN (l.dataelementid = 1740) THEN l.val
            ELSE NULL::character varying
        END)::text) AS refered_from,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1916) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_pvc_w OWNER TO postgres;

--
-- Name: stage_sasa_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sasa_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1763) THEN l.val
            ELSE NULL::character varying
        END)::text) AS attended_sasa,
    max((
        CASE
            WHEN (l.dataelementid = 1771) THEN l.val
            ELSE NULL::character varying
        END)::text) AS relative_partner_attended,
    max((
        CASE
            WHEN (l.dataelementid = 1768) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dialogue,
    max((
        CASE
            WHEN (l.dataelementid = 1764) THEN l.val
            ELSE NULL::character varying
        END)::text) AS drama,
    max((
        CASE
            WHEN (l.dataelementid = 1765) THEN l.val
            ELSE NULL::character varying
        END)::text) AS days_activism,
    max((
        CASE
            WHEN (l.dataelementid = 1766) THEN l.val
            ELSE NULL::character varying
        END)::text) AS press_conference,
    max((
        CASE
            WHEN (l.dataelementid = 1767) THEN l.val
            ELSE NULL::character varying
        END)::text) AS films_screening,
    max((
        CASE
            WHEN (l.dataelementid = 1769) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other,
    max((
        CASE
            WHEN (l.dataelementid = 1770) THEN l.val
            ELSE NULL::character varying
        END)::text) AS specify,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1912) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sasa_w OWNER TO postgres;

--
-- Name: stage_sbhvp_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sbhvp_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1762) THEN l.val
            ELSE NULL::character varying
        END)::text) AS enrolled,
    max((
        CASE
            WHEN (l.dataelementid = 162620576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_group_name,
    max((
        CASE
            WHEN (l.dataelementid = 162620757) THEN l.val
            ELSE NULL::character varying
        END)::text) AS facilitator_name,
    max((
        CASE
            WHEN (l.dataelementid = 32806025) THEN l.val
            ELSE NULL::character varying
        END)::text) AS name_of_school,
    max((
        CASE
            WHEN (l.dataelementid = 147836872) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class,
    max((
        CASE
            WHEN (l.dataelementid = 33394464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sbhvp_service,
    max((
        CASE
            WHEN (l.dataelementid = 162934825) THEN l.val
            ELSE NULL::character varying
        END)::text) AS curriculum,
    max((
        CASE
            WHEN (l.dataelementid = 147835449) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835473) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835479) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835480) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835484) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835558) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835586) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835657) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835627) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835688) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835675) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835718) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835762) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835751) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835829) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835800) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835888) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_10_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835875) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_10_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835960) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835954) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836007) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836005) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836084) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836034) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836097) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836096) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836114) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836111) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162924153) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162926839) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_1_date,
    max((
        CASE
            WHEN (l.dataelementid = 162930643) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162930764) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_2_date,
    max((
        CASE
            WHEN (l.dataelementid = 162931416) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162933945) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_3_date,
    max((
        CASE
            WHEN (l.dataelementid = 162934415) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162934737) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_4_date,
    max((
        CASE
            WHEN (l.dataelementid = 162936096) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162936390) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_5_date,
    max((
        CASE
            WHEN (l.dataelementid = 162938109) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162938445) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_6_date,
    max((
        CASE
            WHEN (l.dataelementid = 162939186) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162939376) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_7_date,
    max((
        CASE
            WHEN (l.dataelementid = 162940063) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162940273) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_8_date,
    max((
        CASE
            WHEN (l.dataelementid = 162941536) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162941879) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_9_date,
    max((
        CASE
            WHEN (l.dataelementid = 162942189) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10a_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162942417) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10a_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943088) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10b_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162949195) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10b_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943376) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162949922) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_11_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943739) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162951194) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_12_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943913) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162944088) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_13_date,
    max((
        CASE
            WHEN (l.dataelementid = 162944389) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162944702) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_14_date,
    max((
        CASE
            WHEN (l.dataelementid = 162617746) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162617694) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_15_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618048) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_16_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162617928) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_16_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618209) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_17_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618139) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_17_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618320) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_18_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618293) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_18_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618426) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_19_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618401) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_19_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618551) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_20_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618533) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_20_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618677) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_21_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618612) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_21_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618978) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_22_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162619030) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_22_date,
    max((
        CASE
            WHEN (l.dataelementid = 33395351) THEN l.val
            ELSE NULL::character varying
        END)::text) AS journeys_plus_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 33395399) THEN l.val
            ELSE NULL::character varying
        END)::text) AS journeys_plus_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 135017978) THEN l.val
            ELSE NULL::character varying
        END)::text) AS journeys_or_sbhvp_completed
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1908) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sbhvp_w OWNER TO postgres;

--
-- Name: stage_sinovuyo_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sinovuyo_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1815) THEN l.val
            ELSE NULL::character varying
        END)::text) AS gname,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1806) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j1,
    max((
        CASE
            WHEN (l.dataelementid = 2571026) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj1,
    max((
        CASE
            WHEN (l.dataelementid = 1807) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j2,
    max((
        CASE
            WHEN (l.dataelementid = 2571045) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj2,
    max((
        CASE
            WHEN (l.dataelementid = 1808) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j3,
    max((
        CASE
            WHEN (l.dataelementid = 2571059) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj3,
    max((
        CASE
            WHEN (l.dataelementid = 1809) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s4,
    max((
        CASE
            WHEN (l.dataelementid = 2571089) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds4,
    max((
        CASE
            WHEN (l.dataelementid = 1810) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s5,
    max((
        CASE
            WHEN (l.dataelementid = 2571127) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds5,
    max((
        CASE
            WHEN (l.dataelementid = 1811) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j6,
    max((
        CASE
            WHEN (l.dataelementid = 2571159) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj6,
    max((
        CASE
            WHEN (l.dataelementid = 1812) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j7,
    max((
        CASE
            WHEN (l.dataelementid = 2571188) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj7,
    max((
        CASE
            WHEN (l.dataelementid = 1813) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s8,
    max((
        CASE
            WHEN (l.dataelementid = 2571216) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds8,
    max((
        CASE
            WHEN (l.dataelementid = 1814) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s9,
    max((
        CASE
            WHEN (l.dataelementid = 2571232) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds9,
    max((
        CASE
            WHEN (l.dataelementid = 2573) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j10,
    max((
        CASE
            WHEN (l.dataelementid = 2571257) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj10,
    max((
        CASE
            WHEN (l.dataelementid = 2574) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j11,
    max((
        CASE
            WHEN (l.dataelementid = 2571258) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj11,
    max((
        CASE
            WHEN (l.dataelementid = 2575) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j12,
    max((
        CASE
            WHEN (l.dataelementid = 2571259) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj12,
    max((
        CASE
            WHEN (l.dataelementid = 2576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j13,
    max((
        CASE
            WHEN (l.dataelementid = 2571260) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj13,
    max((
        CASE
            WHEN (l.dataelementid = 2577) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j14,
    max((
        CASE
            WHEN (l.dataelementid = 2571298) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj14,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 2515) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sinovuyo_w OWNER TO postgres;

--
-- Name: stage_sstones_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sstones_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1815) THEN l.val
            ELSE NULL::character varying
        END)::text) AS gname,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1797) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sa,
    max((
        CASE
            WHEN (l.dataelementid = 2570821) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsa,
    max((
        CASE
            WHEN (l.dataelementid = 1798) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sb,
    max((
        CASE
            WHEN (l.dataelementid = 2570822) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsb,
    max((
        CASE
            WHEN (l.dataelementid = 1799) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sc,
    max((
        CASE
            WHEN (l.dataelementid = 2570837) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsc,
    max((
        CASE
            WHEN (l.dataelementid = 1800) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m1,
    max((
        CASE
            WHEN (l.dataelementid = 2570947) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm1,
    max((
        CASE
            WHEN (l.dataelementid = 1801) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sd,
    max((
        CASE
            WHEN (l.dataelementid = 2570838) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsd,
    max((
        CASE
            WHEN (l.dataelementid = 1802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS se,
    max((
        CASE
            WHEN (l.dataelementid = 2570839) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dse,
    max((
        CASE
            WHEN (l.dataelementid = 1803) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sf,
    max((
        CASE
            WHEN (l.dataelementid = 2570853) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsf,
    max((
        CASE
            WHEN (l.dataelementid = 1804) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sg,
    max((
        CASE
            WHEN (l.dataelementid = 2570880) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsg,
    max((
        CASE
            WHEN (l.dataelementid = 1805) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m2,
    max((
        CASE
            WHEN (l.dataelementid = 2570962) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm2,
    max((
        CASE
            WHEN (l.dataelementid = 5517) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sh,
    max((
        CASE
            WHEN (l.dataelementid = 2570895) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsh,
    max((
        CASE
            WHEN (l.dataelementid = 5518) THEN l.val
            ELSE NULL::character varying
        END)::text) AS si,
    max((
        CASE
            WHEN (l.dataelementid = 2570912) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsi,
    max((
        CASE
            WHEN (l.dataelementid = 5519) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sj,
    max((
        CASE
            WHEN (l.dataelementid = 2570931) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsj,
    max((
        CASE
            WHEN (l.dataelementid = 5520) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m3,
    max((
        CASE
            WHEN (l.dataelementid = 2570979) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm3,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1909) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sstones_w OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: agyw_srv_no; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_srv_no AS
 SELECT p.programinstanceid,
    p.trackedentityinstanceid,
    COALESCE(h.htc, (0)::bigint) AS htc,
    COALESCE(ss.sstones, (0)::bigint) AS sstones,
    COALESCE(s.sinovuyo, (0)::bigint) AS sinovuyo,
    COALESCE(sb.sbhvp, (0)::bigint) AS sbhvp,
    COALESCE(sa.sasa, (0)::bigint) AS sasa,
    COALESCE(pv.pvc, (0)::bigint) AS pvc,
    COALESCE(ps.partner_services, (0)::bigint) AS partner_services,
    COALESCE(ed.educ_subsidy, (0)::bigint) AS educ_subsidy,
    COALESCE(es.econ_services, (0)::bigint) AS econ_services,
    COALESCE(cs.contraceptive_mix, (0)::bigint) AS contraceptive_mix,
    COALESCE(cp.condom_provision, (0)::bigint) AS condom_provision,
    COALESCE(ct.cash_transfer, (0)::bigint) AS cash_transfer,
    COALESCE(prep.prep, (0)::bigint) AS prep,
    COALESCE(ic.dreams_ic, (0)::bigint) AS dreams_ic,
    COALESCE(exit.dreams_exit, (0)::bigint) AS dreams_exit
   FROM (((((((((((((((public.programinstance p
     LEFT JOIN ( SELECT stage_hts_w.programinstanceid,
            count(*) AS htc
           FROM staging.stage_hts_w
          WHERE (stage_hts_w.hts_result <> ''::text)
          GROUP BY stage_hts_w.programinstanceid) h ON ((p.programinstanceid = h.programinstanceid)))
     LEFT JOIN ( SELECT stage_sstones_w.programinstanceid,
            count(*) AS sstones
           FROM staging.stage_sstones_w
          WHERE (stage_sstones_w.sa = 'true'::text)
          GROUP BY stage_sstones_w.programinstanceid) ss ON ((ss.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sinovuyo_w.programinstanceid,
            count(*) AS sinovuyo
           FROM staging.stage_sinovuyo_w
          WHERE (stage_sinovuyo_w.j1 <> ''::text)
          GROUP BY stage_sinovuyo_w.programinstanceid) s ON ((s.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sbhvp_w.programinstanceid,
            count(*) AS sbhvp
           FROM staging.stage_sbhvp_w
          WHERE (stage_sbhvp_w.enrolled = 'true'::text)
          GROUP BY stage_sbhvp_w.programinstanceid) sb ON ((sb.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sasa_w.programinstanceid,
            count(*) AS sasa
           FROM staging.stage_sasa_w
          WHERE (stage_sasa_w.attended_sasa = 'true'::text)
          GROUP BY stage_sasa_w.programinstanceid) sa ON ((sa.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_pvc_w.programinstanceid,
            count(*) AS pvc
           FROM staging.stage_pvc_w
          WHERE ((stage_pvc_w.economical = 'true'::text) OR (stage_pvc_w.physical = 'true'::text) OR (stage_pvc_w.sexual = 'true'::text) OR (stage_pvc_w.psychosocial = 'true'::text) OR (stage_pvc_w.sti = 'true'::text) OR (stage_pvc_w.stepping_stones = 'true'::text) OR (stage_pvc_w.sasa = 'true'::text) OR (stage_pvc_w.sinovuyo = 'true'::text) OR (stage_pvc_w.contraceptive_mix = 'true'::text) OR (stage_pvc_w.cash_transfer = 'true'::text) OR (stage_pvc_w.condom_provision = 'true'::text) OR (stage_pvc_w.education_subsidy = 'true'::text) OR (stage_pvc_w.combined_social_economic = 'true'::text) OR (stage_pvc_w.pep = 'true'::text) OR (stage_pvc_w.linked_police = 'true'::text) OR (stage_pvc_w.psychosocial_support = 'true'::text) OR (stage_pvc_w.emergency_contraception = 'true'::text) OR (stage_pvc_w.htc = 'true'::text))
          GROUP BY stage_pvc_w.programinstanceid) pv ON ((pv.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_partner_services_w.programinstanceid,
            count(*) AS partner_services
           FROM staging.stage_partner_services_w
          WHERE ((stage_partner_services_w.fname <> ''::text) OR (stage_partner_services_w.lname <> ''::text))
          GROUP BY stage_partner_services_w.programinstanceid) ps ON ((ps.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_educ_subsidy_w.programinstanceid,
            count(*) AS educ_subsidy
           FROM staging.stage_educ_subsidy_w
          WHERE (stage_educ_subsidy_w.received = 'true'::text)
          GROUP BY stage_educ_subsidy_w.programinstanceid) ed ON ((ed.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_economic_services_w.programinstanceid,
            count(*) AS econ_services
           FROM staging.stage_economic_services_w
          WHERE ((stage_economic_services_w.fl_training = 'true'::text) OR (stage_economic_services_w.vs_training = 'true'::text) OR (stage_economic_services_w.iga_support = 'true'::text) OR (stage_economic_services_w.vsla_silc = 'true'::text) OR (stage_economic_services_w.ses_services <> ''::text))
          GROUP BY stage_economic_services_w.programinstanceid) es ON ((es.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_contraceptive_mix_w.programinstanceid,
            count(*) AS contraceptive_mix
           FROM staging.stage_contraceptive_mix_w
          WHERE (stage_contraceptive_mix_w.contraceptive_services = 'true'::text)
          GROUP BY stage_contraceptive_mix_w.programinstanceid) cs ON ((cs.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_condom_provision_w.programinstanceid,
            count(*) AS condom_provision
           FROM staging.stage_condom_provision_w
          WHERE (stage_condom_provision_w.received = 'true'::text)
          GROUP BY stage_condom_provision_w.programinstanceid) cp ON ((cp.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_cash_transfer_w.programinstanceid,
            count(*) AS cash_transfer
           FROM staging.stage_cash_transfer_w
          WHERE (stage_cash_transfer_w.cash_transfer = 'true'::text)
          GROUP BY stage_cash_transfer_w.programinstanceid) ct ON ((ct.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_prep.programinstanceid,
            count(*) AS prep
           FROM staging.stage_prep
          WHERE (stage_prep.received_prep = 'true'::text)
          GROUP BY stage_prep.programinstanceid) prep ON ((prep.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_ic.programinstanceid,
            count(*) AS dreams_ic
           FROM staging.stage_dreams_ic
          WHERE ((stage_dreams_ic.life_skills_training_received = 'true'::text) OR (stage_dreams_ic.menstrual_hygiene_received = 'true'::text) OR (stage_dreams_ic.mentorship_received = 'true'::text) OR (stage_dreams_ic.returned_to_school = 'true'::text) OR (stage_dreams_ic.economic_skills_training = 'true'::text) OR (stage_dreams_ic.market_training = 'true'::text) OR (stage_dreams_ic.che_mentorship = 'true'::text) OR (stage_dreams_ic.followup_meetings_attended = 'true'::text) OR (stage_dreams_ic.started_business = 'true'::text) OR (stage_dreams_ic.interschool_competition = 'true'::text) OR (stage_dreams_ic.train_on_gbv_prevention = 'true'::text) OR (stage_dreams_ic.hiv_prevention_information = 'true'::text) OR (stage_dreams_ic.peer_monitoring = 'true'::text) OR (stage_dreams_ic.radio_production_skills = 'true'::text))
          GROUP BY stage_dreams_ic.programinstanceid) ic ON ((ic.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_exit.programinstanceid,
            count(*) AS dreams_exit
           FROM staging.stage_dreams_exit
          WHERE (stage_dreams_exit.reason_for_exiting_dreams <> ''::text)
          GROUP BY stage_dreams_exit.programinstanceid) exit ON ((exit.programinstanceid = p.programinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679))
  WITH NO DATA;


ALTER TABLE staging.agyw_srv_no OWNER TO postgres;

--
-- Name: agyws_l; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.agyws_l AS
 SELECT pa.programtrackedentityattributeid,
    pa.trackedentityattributeid AS id,
    pa.programid,
    tea.code,
    teav.value,
    teav.trackedentityinstanceid
   FROM ((public.program_attributes pa
     JOIN public.trackedentityattribute tea ON ((pa.trackedentityattributeid = tea.trackedentityattributeid)))
     JOIN public.trackedentityattributevalue teav ON ((pa.trackedentityattributeid = teav.trackedentityattributeid)))
  ORDER BY pa.sort_order;


ALTER TABLE staging.agyws_l OWNER TO postgres;

--
-- Name: d_agyws_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.d_agyws_w AS
 SELECT agyws_l.trackedentityinstanceid,
    max((
        CASE
            WHEN (agyws_l.id = 1517164) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (agyws_l.id = 1900) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS dreams_id,
    max((
        CASE
            WHEN (agyws_l.id = 1905) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS sim_card_no,
    max((
        CASE
            WHEN (agyws_l.id = 1884) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS fname,
    max((
        CASE
            WHEN (agyws_l.id = 1885) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS lname,
    max((
        CASE
            WHEN (agyws_l.id = 1886) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS dob,
    max(
        CASE
            WHEN (agyws_l.id = 1887) THEN (agyws_l.value)::double precision
            ELSE NULL::double precision
        END) AS age,
    max((
        CASE
            WHEN (agyws_l.id = 2262) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS maiden_name,
    max((
        CASE
            WHEN (agyws_l.id = 1889) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS parish,
    max((
        CASE
            WHEN (agyws_l.id = 1890) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS village,
    max((
        CASE
            WHEN (agyws_l.id = 1883) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS phone,
    max((
        CASE
            WHEN (agyws_l.id = 2309) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS location_coordinates,
    max((
        CASE
            WHEN (agyws_l.id = 1891) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS education_status,
    max((
        CASE
            WHEN (agyws_l.id = 1897) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS disability,
    max((
        CASE
            WHEN (agyws_l.id = 1896) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS parental_status,
    max((
        CASE
            WHEN (agyws_l.id = 1901) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS entry,
    max((
        CASE
            WHEN (agyws_l.id = 1892) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS married,
    max((
        CASE
            WHEN (agyws_l.id = 1893) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS pregnant,
    max((
        CASE
            WHEN (agyws_l.id = 1894) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS given_birth_at_15,
    max((
        CASE
            WHEN (agyws_l.id = 2263) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS first_child_birth,
    max((
        CASE
            WHEN (agyws_l.id = 1902) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS segment
   FROM staging.agyws_l
  WHERE (agyws_l.programid = 2059)
  GROUP BY agyws_l.trackedentityinstanceid;


ALTER TABLE staging.d_agyws_w OWNER TO postgres;

--
-- Name: agyws_list; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyws_list AS
 SELECT p.enrollmentdate,
    ( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))) AS district,
    ( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = p.organisationunitid)) AS subcounty,
    p.status,
    d.trackedentityinstanceid,
    d.ip,
    d.dreams_id,
    d.sim_card_no,
    d.fname,
    d.lname,
    d.dob,
    d.age,
    d.maiden_name,
    d.parish,
    d.village,
    d.phone,
    d.location_coordinates,
    d.education_status,
    d.disability,
    d.parental_status,
    d.entry,
    d.married,
    d.pregnant,
    d.given_birth_at_15,
    d.first_child_birth,
    d.segment
   FROM (staging.d_agyws_w d
     JOIN public.programinstance p ON ((d.trackedentityinstanceid = p.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.programid = 2059))
  WITH NO DATA;


ALTER TABLE staging.agyws_list OWNER TO postgres;

--
-- Name: agegroup_analysis2; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agegroup_analysis2 AS
 SELECT
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END AS agegroup,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 0) THEN 1
            ELSE 0
        END) AS zero,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 1) THEN 1
            ELSE 0
        END) AS one_service,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 2) THEN 1
            ELSE 0
        END) AS two_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 3) THEN 1
            ELSE 0
        END) AS three_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 4) THEN 1
            ELSE 0
        END) AS four_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 5) THEN 1
            ELSE 0
        END) AS five_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 6) THEN 1
            ELSE 0
        END) AS six_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 7) THEN 1
            ELSE 0
        END) AS seven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 8) THEN 1
            ELSE 0
        END) AS eight_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 9) THEN 1
            ELSE 0
        END) AS nine_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 10) THEN 1
            ELSE 0
        END) AS ten_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 11) THEN 1
            ELSE 0
        END) AS eleven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 12) THEN 1
            ELSE 0
        END) AS twelve_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) >= 5) THEN 1
            ELSE 0
        END) AS five_plus_services,
    tbl.ip AS implementing_partner,
    tbl.segment
   FROM ( SELECT l.enrollmentdate,
            l.district,
            l.subcounty,
            l.status,
            l.trackedentityinstanceid,
            l.ip,
            l.dreams_id,
            l.sim_card_no,
            l.fname,
            l.lname,
            l.dob,
            l.age,
            l.maiden_name,
            l.parish,
            l.village,
            l.phone,
            l.location_coordinates,
            l.education_status,
            l.disability,
            l.parental_status,
            l.entry,
            l.married,
            l.pregnant,
            l.given_birth_at_15,
            l.first_child_birth,
            l.segment,
            s.programinstanceid,
            s.trackedentityinstanceid,
            s.htc,
            s.sstones,
            s.sinovuyo,
            s.sbhvp,
            s.sasa,
            s.pvc,
            s.partner_services,
            s.educ_subsidy,
            s.econ_services,
            s.contraceptive_mix,
            s.condom_provision,
            s.cash_transfer
           FROM (staging.agyws_list l
             JOIN staging.agyw_srv_no s ON ((l.trackedentityinstanceid = s.trackedentityinstanceid)))) tbl(enrollmentdate, district, subcounty, status, trackedentityinstanceid, ip, dreams_id, sim_card_no, fname, lname, dob, age, maiden_name, parish, village, phone, location_coordinates, education_status, disability, parental_status, entry, married, pregnant, given_birth_at_15, first_child_birth, segment, programinstanceid, trackedentityinstanceid_1, htc, sstones, sinovuyo, sbhvp, sasa, pvc, partner_services, educ_subsidy, econ_services, contraceptive_mix, condom_provision, cash_transfer)
  GROUP BY tbl.ip, tbl.segment,
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END
  ORDER BY
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END
  WITH NO DATA;


ALTER TABLE staging.agegroup_analysis2 OWNER TO postgres;

--
-- Name: agyw_srv_no_minus_cancelled; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_srv_no_minus_cancelled AS
 SELECT p.programinstanceid,
    p.trackedentityinstanceid,
    COALESCE(h.htc, (0)::bigint) AS htc,
    COALESCE(ss.sstones, (0)::bigint) AS sstones,
    COALESCE(s.sinovuyo, (0)::bigint) AS sinovuyo,
    COALESCE(sb.sbhvp, (0)::bigint) AS sbhvp,
    COALESCE(sa.sasa, (0)::bigint) AS sasa,
    COALESCE(pv.pvc, (0)::bigint) AS pvc,
    COALESCE(ps.partner_services, (0)::bigint) AS partner_services,
    COALESCE(ed.educ_subsidy, (0)::bigint) AS educ_subsidy,
    COALESCE(es.econ_services, (0)::bigint) AS econ_services,
    COALESCE(cs.contraceptive_mix, (0)::bigint) AS contraceptive_mix,
    COALESCE(cp.condom_provision, (0)::bigint) AS condom_provision,
    COALESCE(ct.cash_transfer, (0)::bigint) AS cash_transfer,
    COALESCE(prep.prep, (0)::bigint) AS prep,
    COALESCE(ic.dreams_ic, (0)::bigint) AS dreams_ic,
    COALESCE(exit.dreams_exit, (0)::bigint) AS dreams_exit
   FROM (((((((((((((((public.programinstance p
     LEFT JOIN ( SELECT stage_hts_w.programinstanceid,
            count(*) AS htc
           FROM staging.stage_hts_w
          WHERE (stage_hts_w.hts_result <> ''::text)
          GROUP BY stage_hts_w.programinstanceid) h ON ((p.programinstanceid = h.programinstanceid)))
     LEFT JOIN ( SELECT stage_sstones_w.programinstanceid,
            count(*) AS sstones
           FROM staging.stage_sstones_w
          WHERE (stage_sstones_w.sa = 'true'::text)
          GROUP BY stage_sstones_w.programinstanceid) ss ON ((ss.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sinovuyo_w.programinstanceid,
            count(*) AS sinovuyo
           FROM staging.stage_sinovuyo_w
          WHERE (stage_sinovuyo_w.j1 <> ''::text)
          GROUP BY stage_sinovuyo_w.programinstanceid) s ON ((s.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sbhvp_w.programinstanceid,
            count(*) AS sbhvp
           FROM staging.stage_sbhvp_w
          WHERE (stage_sbhvp_w.enrolled = 'true'::text)
          GROUP BY stage_sbhvp_w.programinstanceid) sb ON ((sb.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sasa_w.programinstanceid,
            count(*) AS sasa
           FROM staging.stage_sasa_w
          WHERE (stage_sasa_w.attended_sasa = 'true'::text)
          GROUP BY stage_sasa_w.programinstanceid) sa ON ((sa.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_pvc_w.programinstanceid,
            count(*) AS pvc
           FROM staging.stage_pvc_w
          WHERE ((stage_pvc_w.economical = 'true'::text) OR (stage_pvc_w.physical = 'true'::text) OR (stage_pvc_w.sexual = 'true'::text) OR (stage_pvc_w.psychosocial = 'true'::text) OR (stage_pvc_w.sti = 'true'::text) OR (stage_pvc_w.stepping_stones = 'true'::text) OR (stage_pvc_w.sasa = 'true'::text) OR (stage_pvc_w.sinovuyo = 'true'::text) OR (stage_pvc_w.contraceptive_mix = 'true'::text) OR (stage_pvc_w.cash_transfer = 'true'::text) OR (stage_pvc_w.condom_provision = 'true'::text) OR (stage_pvc_w.education_subsidy = 'true'::text) OR (stage_pvc_w.combined_social_economic = 'true'::text) OR (stage_pvc_w.pep = 'true'::text) OR (stage_pvc_w.linked_police = 'true'::text) OR (stage_pvc_w.psychosocial_support = 'true'::text) OR (stage_pvc_w.emergency_contraception = 'true'::text) OR (stage_pvc_w.htc = 'true'::text))
          GROUP BY stage_pvc_w.programinstanceid) pv ON ((pv.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_partner_services_w.programinstanceid,
            count(*) AS partner_services
           FROM staging.stage_partner_services_w
          WHERE ((stage_partner_services_w.fname <> ''::text) OR (stage_partner_services_w.lname <> ''::text))
          GROUP BY stage_partner_services_w.programinstanceid) ps ON ((ps.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_educ_subsidy_w.programinstanceid,
            count(*) AS educ_subsidy
           FROM staging.stage_educ_subsidy_w
          WHERE (stage_educ_subsidy_w.received = 'true'::text)
          GROUP BY stage_educ_subsidy_w.programinstanceid) ed ON ((ed.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_economic_services_w.programinstanceid,
            count(*) AS econ_services
           FROM staging.stage_economic_services_w
          WHERE ((stage_economic_services_w.fl_training = 'true'::text) OR (stage_economic_services_w.vs_training = 'true'::text) OR (stage_economic_services_w.iga_support = 'true'::text) OR (stage_economic_services_w.vsla_silc = 'true'::text) OR (stage_economic_services_w.ses_services <> ''::text))
          GROUP BY stage_economic_services_w.programinstanceid) es ON ((es.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_contraceptive_mix_w.programinstanceid,
            count(*) AS contraceptive_mix
           FROM staging.stage_contraceptive_mix_w
          WHERE (stage_contraceptive_mix_w.contraceptive_services = 'true'::text)
          GROUP BY stage_contraceptive_mix_w.programinstanceid) cs ON ((cs.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_condom_provision_w.programinstanceid,
            count(*) AS condom_provision
           FROM staging.stage_condom_provision_w
          WHERE (stage_condom_provision_w.received = 'true'::text)
          GROUP BY stage_condom_provision_w.programinstanceid) cp ON ((cp.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_cash_transfer_w.programinstanceid,
            count(*) AS cash_transfer
           FROM staging.stage_cash_transfer_w
          WHERE (stage_cash_transfer_w.cash_transfer = 'true'::text)
          GROUP BY stage_cash_transfer_w.programinstanceid) ct ON ((ct.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_prep.programinstanceid,
            count(*) AS prep
           FROM staging.stage_prep
          WHERE (stage_prep.received_prep = 'true'::text)
          GROUP BY stage_prep.programinstanceid) prep ON ((prep.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_ic.programinstanceid,
            count(*) AS dreams_ic
           FROM staging.stage_dreams_ic
          WHERE ((stage_dreams_ic.life_skills_training_received = 'true'::text) OR (stage_dreams_ic.menstrual_hygiene_received = 'true'::text) OR (stage_dreams_ic.mentorship_received = 'true'::text) OR (stage_dreams_ic.returned_to_school = 'true'::text) OR (stage_dreams_ic.economic_skills_training = 'true'::text) OR (stage_dreams_ic.market_training = 'true'::text) OR (stage_dreams_ic.che_mentorship = 'true'::text) OR (stage_dreams_ic.followup_meetings_attended = 'true'::text) OR (stage_dreams_ic.started_business = 'true'::text) OR (stage_dreams_ic.interschool_competition = 'true'::text) OR (stage_dreams_ic.train_on_gbv_prevention = 'true'::text) OR (stage_dreams_ic.hiv_prevention_information = 'true'::text) OR (stage_dreams_ic.peer_monitoring = 'true'::text) OR (stage_dreams_ic.radio_production_skills = 'true'::text))
          GROUP BY stage_dreams_ic.programinstanceid) ic ON ((ic.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_exit.programinstanceid,
            count(*) AS dreams_exit
           FROM staging.stage_dreams_exit
          WHERE (stage_dreams_exit.reason_for_exiting_dreams <> ''::text)
          GROUP BY stage_dreams_exit.programinstanceid) exit ON ((exit.programinstanceid = p.programinstanceid)))
  WHERE ((p.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND ((p.status)::text <> 'CANCELLED'::text))
  WITH NO DATA;


ALTER TABLE staging.agyw_srv_no_minus_cancelled OWNER TO postgres;

--
-- Name: agyws_list_minus_cancelled; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyws_list_minus_cancelled AS
 SELECT p.enrollmentdate,
    ( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))) AS district,
    ( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = p.organisationunitid)) AS subcounty,
    p.status,
    d.trackedentityinstanceid,
    d.ip,
    d.dreams_id,
    d.sim_card_no,
    d.fname,
    d.lname,
    d.dob,
    d.age,
    d.maiden_name,
    d.parish,
    d.village,
    d.phone,
    d.location_coordinates,
    d.education_status,
    d.disability,
    d.parental_status,
    d.entry,
    d.married,
    d.pregnant,
    d.given_birth_at_15,
    d.first_child_birth,
    d.segment
   FROM (staging.d_agyws_w d
     JOIN public.programinstance p ON ((d.trackedentityinstanceid = p.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (p.programid = 2059) AND ((p.status)::text <> 'CANCELLED'::text))
  WITH NO DATA;


ALTER TABLE staging.agyws_list_minus_cancelled OWNER TO postgres;

--
-- Name: agyw_rcv_fpri_anysec; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_rcv_fpri_anysec AS
 SELECT COALESCE(tbl.ip, 'NoIP'::text) AS implimentingpartner,
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END AS cohort,
        CASE
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE 'No age'::text
        END AS agegroup,
    COALESCE(tbl.segment, 'NoSeg'::text) AS segment,
    tbl.enrollmentdate,
    tbl.district,
    tbl.subcounty,
    count(DISTINCT tbl.dreams_id) AS totalenrollment,
    sum(
        CASE
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN
            CASE
                WHEN (((
                CASE
                    WHEN (tbl.htc >= 1) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.sinovuyo >= 1) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ((tbl.sstones >= 1) OR (tbl.sbhvp >= 1)) THEN 1
                    ELSE 0
                END) = 3) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS primary_1,
    sum(
        CASE
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN
            CASE
                WHEN (((
                CASE
                    WHEN (tbl.htc >= 1) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.econ_services >= 1) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ((tbl.sstones >= 1) OR (tbl.sbhvp >= 1)) THEN 1
                    ELSE 0
                END) = 3) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS primary_2,
    sum(
        CASE
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN
            CASE
                WHEN (((
                CASE
                    WHEN (tbl.htc >= 1) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.econ_services >= 1) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.sstones >= 1) THEN 1
                    ELSE 0
                END) = 3) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS primary_3,
    sum(
        CASE
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN
            CASE
                WHEN (((((((
                CASE
                    WHEN (tbl.htc > 0) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.pvc > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.partner_services > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.educ_subsidy > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.econ_services > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.contraceptive_mix > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.condom_provision > 0) THEN 1
                    ELSE 0
                END) >= 1) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS secondary_1,
    sum(
        CASE
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN
            CASE
                WHEN ((((((((
                CASE
                    WHEN (tbl.htc > 0) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.sinovuyo > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.pvc > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.partner_services > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.educ_subsidy > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.contraceptive_mix > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.condom_provision > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.cash_transfer > 0) THEN 1
                    ELSE 0
                END) >= 1) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS secondary_2,
    sum(
        CASE
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN
            CASE
                WHEN ((((((
                CASE
                    WHEN (tbl.htc > 0) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (tbl.pvc > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.educ_subsidy > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.contraceptive_mix > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.condom_provision > 0) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (tbl.prep > 0) THEN 1
                    ELSE 0
                END) >= 1) THEN 1
                ELSE 0
            END
            ELSE 0
        END) AS secondary_3,
    sum(
        CASE
            WHEN (((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.prep > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) >= 1) THEN 1
            ELSE 0
        END) AS all_agegroups,
    sum(
        CASE
            WHEN (((((
            CASE
                WHEN (tbl.htc >= 1) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sinovuyo >= 1) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services >= 1) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN ((tbl.sstones >= 1) OR (tbl.sbhvp >= 1)) THEN 1
                ELSE 0
            END) = 3) AND (((((
            CASE
                WHEN (tbl.partner_services >= 1) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.educ_subsidy >= 1) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision >= 1) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix >= 1) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc >= 1) THEN 1
                ELSE 0
            END) >= 1)) THEN 1
            ELSE 0
        END) AS additional_secondary
   FROM ( SELECT l.enrollmentdate,
            l.district,
            l.subcounty,
            l.status,
            l.trackedentityinstanceid,
            l.ip,
            l.dreams_id,
            l.sim_card_no,
            l.fname,
            l.lname,
            l.dob,
            l.age,
            l.maiden_name,
            l.parish,
            l.village,
            l.phone,
            l.location_coordinates,
            l.education_status,
            l.disability,
            l.parental_status,
            l.entry,
            l.married,
            l.pregnant,
            l.given_birth_at_15,
            l.first_child_birth,
            l.segment,
            s.programinstanceid,
            s.trackedentityinstanceid,
            s.htc,
            s.sstones,
            s.sinovuyo,
            s.sbhvp,
            s.sasa,
            s.pvc,
            s.partner_services,
            s.educ_subsidy,
            s.econ_services,
            s.contraceptive_mix,
            s.condom_provision,
            s.cash_transfer,
            s.prep,
            s.dreams_ic,
            s.dreams_exit
           FROM (staging.agyws_list_minus_cancelled l
             JOIN staging.agyw_srv_no_minus_cancelled s ON ((s.trackedentityinstanceid = l.trackedentityinstanceid)))) tbl(enrollmentdate, district, subcounty, status, trackedentityinstanceid, ip, dreams_id, sim_card_no, fname, lname, dob, age, maiden_name, parish, village, phone, location_coordinates, education_status, disability, parental_status, entry, married, pregnant, given_birth_at_15, first_child_birth, segment, programinstanceid, trackedentityinstanceid_1, htc, sstones, sinovuyo, sbhvp, sasa, pvc, partner_services, educ_subsidy, econ_services, contraceptive_mix, condom_provision, cash_transfer, prep, dreams_ic, dreams_exit)
  GROUP BY tbl.ip, tbl.segment,
        CASE
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE 'No age'::text
        END,
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END, tbl.enrollmentdate, tbl.district, tbl.subcounty
  WITH NO DATA;


ALTER TABLE staging.agyw_rcv_fpri_anysec OWNER TO postgres;

--
-- Name: agyw_service_layering; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_service_layering AS
 SELECT
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END AS cohort,
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END AS agegroup,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 0) THEN 1
            ELSE 0
        END) AS zero,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 1) THEN 1
            ELSE 0
        END) AS one_service,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 2) THEN 1
            ELSE 0
        END) AS two_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 3) THEN 1
            ELSE 0
        END) AS three_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 4) THEN 1
            ELSE 0
        END) AS four_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 5) THEN 1
            ELSE 0
        END) AS five_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 6) THEN 1
            ELSE 0
        END) AS six_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 7) THEN 1
            ELSE 0
        END) AS seven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 8) THEN 1
            ELSE 0
        END) AS eight_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 9) THEN 1
            ELSE 0
        END) AS nine_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 10) THEN 1
            ELSE 0
        END) AS ten_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 11) THEN 1
            ELSE 0
        END) AS eleven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 12) THEN 1
            ELSE 0
        END) AS twelve_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) >= 5) THEN 1
            ELSE 0
        END) AS five_plus_services,
    tbl.enrollmentdate,
    tbl.district,
    tbl.subcounty,
    tbl.ip AS implementing_partner,
    tbl.segment
   FROM ( SELECT l.enrollmentdate,
            l.district,
            l.subcounty,
            l.status,
            l.trackedentityinstanceid,
            l.ip,
            l.dreams_id,
            l.sim_card_no,
            l.fname,
            l.lname,
            l.dob,
            l.age,
            l.maiden_name,
            l.parish,
            l.village,
            l.phone,
            l.location_coordinates,
            l.education_status,
            l.disability,
            l.parental_status,
            l.entry,
            l.married,
            l.pregnant,
            l.given_birth_at_15,
            l.first_child_birth,
            l.segment,
            s.programinstanceid,
            s.trackedentityinstanceid,
            s.htc,
            s.sstones,
            s.sinovuyo,
            s.sbhvp,
            s.sasa,
            s.pvc,
            s.partner_services,
            s.educ_subsidy,
            s.econ_services,
            s.contraceptive_mix,
            s.condom_provision,
            s.cash_transfer
           FROM (staging.agyws_list_minus_cancelled l
             JOIN staging.agyw_srv_no_minus_cancelled s ON ((l.trackedentityinstanceid = s.trackedentityinstanceid)))) tbl(enrollmentdate, district, subcounty, status, trackedentityinstanceid, ip, dreams_id, sim_card_no, fname, lname, dob, age, maiden_name, parish, village, phone, location_coordinates, education_status, disability, parental_status, entry, married, pregnant, given_birth_at_15, first_child_birth, segment, programinstanceid, trackedentityinstanceid_1, htc, sstones, sinovuyo, sbhvp, sasa, pvc, partner_services, educ_subsidy, econ_services, contraceptive_mix, condom_provision, cash_transfer)
  GROUP BY tbl.enrollmentdate, tbl.district, tbl.subcounty, tbl.ip, tbl.segment,
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END,
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END
  ORDER BY
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END,
        CASE
            WHEN (tbl.age <= (10)::double precision) THEN '0-9 Years'::text
            WHEN ((tbl.age >= (10)::double precision) AND (tbl.age <= (14)::double precision)) THEN '10-14 Years'::text
            WHEN ((tbl.age >= (15)::double precision) AND (tbl.age <= (19)::double precision)) THEN '15-19 Years'::text
            WHEN ((tbl.age >= (20)::double precision) AND (tbl.age <= (24)::double precision)) THEN '20-24 Years'::text
            WHEN (tbl.age >= (25)::double precision) THEN '25+ Years'::text
            ELSE NULL::text
        END
  WITH NO DATA;


ALTER TABLE staging.agyw_service_layering OWNER TO postgres;

--
-- Name: stage_screening; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_screening AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate AS screeningdate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    l.program_status,
    max((
        CASE
            WHEN (l.dataelementid = 94517522) THEN l.val
            ELSE NULL::character varying
        END)::text) AS site_location,
    max((
        CASE
            WHEN (l.dataelementid = 94518014) THEN l.val
            ELSE NULL::character varying
        END)::text) AS next_of_kin,
    max((
        CASE
            WHEN (l.dataelementid = 94518100) THEN l.val
            ELSE NULL::character varying
        END)::text) AS next_of_kin_phone_contact,
    max((
        CASE
            WHEN (l.dataelementid = 94518289) THEN l.val
            ELSE NULL::character varying
        END)::text) AS are_you_currently_in_school,
    max((
        CASE
            WHEN (l.dataelementid = 94579384) THEN l.val
            ELSE NULL::character varying
        END)::text) AS days_of_school_missed,
    max((
        CASE
            WHEN (l.dataelementid = 272338473) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_caring_for_sick_family_member,
    max((
        CASE
            WHEN (l.dataelementid = 272338477) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_child_was_not_in_interested_in_school,
    max((
        CASE
            WHEN (l.dataelementid = 272338480) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_given_birth,
    max((
        CASE
            WHEN (l.dataelementid = 272338475) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_long_public_holidays,
    max((
        CASE
            WHEN (l.dataelementid = 272338478) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_no_school_fees,
    max((
        CASE
            WHEN (l.dataelementid = 272338481) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_no_school_near_by,
    max((
        CASE
            WHEN (l.dataelementid = 272338482) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_other_reason_please_specify,
    max((
        CASE
            WHEN (l.dataelementid = 272338476) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_preference_given_to_boy_child,
    max((
        CASE
            WHEN (l.dataelementid = 272338479) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_pregnant,
    max((
        CASE
            WHEN (l.dataelementid = 272338474) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_school_closure_eg_lockdown,
    max((
        CASE
            WHEN (l.dataelementid = 272338472) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_sick,
    max((
        CASE
            WHEN (l.dataelementid = 94579661) THEN l.val
            ELSE NULL::character varying
        END)::text) AS both_parents_living,
    max((
        CASE
            WHEN (l.dataelementid = 94579642) THEN l.val
            ELSE NULL::character varying
        END)::text) AS current_caregiver,
    max((
        CASE
            WHEN (l.dataelementid = 94579889) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ever_drunk_alcohol_or_used_illicit_drugs,
    max((
        CASE
            WHEN (l.dataelementid = 94580060) THEN l.val
            ELSE NULL::character varying
        END)::text) AS have_you_ever_had_sex,
    max((
        CASE
            WHEN (l.dataelementid = 272339784) THEN l.val
            ELSE NULL::character varying
        END)::text) AS head_of_your_household,
    max((
        CASE
            WHEN (l.dataelementid = 94580674) THEN l.val
            ELSE NULL::character varying
        END)::text) AS violence_emotional_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94581008) THEN l.val
            ELSE NULL::character varying
        END)::text) AS violence_physical_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94581310) THEN l.val
            ELSE NULL::character varying
        END)::text) AS violence_sexual_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94581456) THEN l.val
            ELSE NULL::character varying
        END)::text) AS anything_to_share_or_ask,
    max((
        CASE
            WHEN (l.dataelementid = 94579405) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_for_missing_school,
    max((
        CASE
            WHEN (l.dataelementid = 272342433) THEN l.val
            ELSE NULL::character varying
        END)::text) AS who_buys_you_these_drinks,
    max((
        CASE
            WHEN (l.dataelementid = 272342434) THEN l.val
            ELSE NULL::character varying
        END)::text) AS where_do_you_get_money_to_buy_alcohol,
    max((
        CASE
            WHEN (l.dataelementid = 272342435) THEN l.val
            ELSE NULL::character varying
        END)::text) AS used_any_of_the_following_substances,
    max((
        CASE
            WHEN (l.dataelementid = 272342436) THEN l.val
            ELSE NULL::character varying
        END)::text) AS  past_3months_use_of_alcohol_led_to_any_problems,
    max((
        CASE
            WHEN (l.dataelementid = 94580189) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_currently_sexually_active,
    max((
        CASE
            WHEN (l.dataelementid = 94582399) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_partners_had_in_the_last_12months,
    max((
        CASE
            WHEN (l.dataelementid = 94582464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_use_condoms_regularly_with_latest_partner,
    max((
        CASE
            WHEN (l.dataelementid = 272342442) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_main_reason_for_not_using_condoms_regularly_with_latest_partner,
    max((
        CASE
            WHEN (l.dataelementid = 94582649) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_last_12months_had_any_of_the_following_symptoms,
    max((
        CASE
            WHEN (l.dataelementid = 94582709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_tested_and_screened_for_any_stis,
    max((
        CASE
            WHEN (l.dataelementid = 272342444) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_treated_for_any_stis,
    max((
        CASE
            WHEN (l.dataelementid = 94580202) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_have_you_ever_been_pregnant,
    max((
        CASE
            WHEN (l.dataelementid = 94582504) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_symptoms_abnormal_vaginal_discharge,
    max((
        CASE
            WHEN (l.dataelementid = 94582520) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_symptoms_genital_sores_or_wound,
    max((
        CASE
            WHEN (l.dataelementid = 94582572) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_symptoms_pain_during_intercourse,
    max((
        CASE
            WHEN (l.dataelementid = 272342443) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_symptoms_sti_diagnosis,
    max((
        CASE
            WHEN (l.dataelementid = 94583370) THEN l.val
            ELSE NULL::character varying
        END)::text) AS work_educ_are_you_currently_working,
    max((
        CASE
            WHEN (l.dataelementid = 94583460) THEN l.val
            ELSE NULL::character varying
        END)::text) AS work_educ_are_you_currently_at_home_with_children,
    max((
        CASE
            WHEN (l.dataelementid = 272374704) THEN l.val
            ELSE NULL::character varying
        END)::text) AS work_educ_are_you_married,
    max((
        CASE
            WHEN (l.dataelementid = 94582952) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_ever_had_sex_in_exchange_for_gifts,
    max((
        CASE
            WHEN (l.dataelementid = 94583081) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_stayed_in_relationship_for_gifts,
    max((
        CASE
            WHEN (l.dataelementid = 94517709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS phone_number

   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 246126062) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_screening OWNER TO postgres;



--
-- Name: stage_screening_old; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_screening_old AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate AS screeningdate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    l.program_status,
    max((
        CASE
            WHEN (l.dataelementid = 1834) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lower_abdominal_pain,
    max((
        CASE
            WHEN (l.dataelementid = 1835) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vaginal_discharge,
    max((
        CASE
            WHEN (l.dataelementid = 1836) THEN l.val
            ELSE NULL::character varying
        END)::text) AS genital_sores,
    max((
        CASE
            WHEN (l.dataelementid = 1837) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pain_during_intercourse,
    max((
        CASE
            WHEN (l.dataelementid = 1821) THEN l.val
            ELSE NULL::character varying
        END)::text) AS would_you_like_condoms,
    max((
        CASE
            WHEN (l.dataelementid = 1838) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_pregnant,
    max((
        CASE
            WHEN (l.dataelementid = 1839) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lmp,
    max((
        CASE
            WHEN (l.dataelementid = 1840) THEN l.val
            ELSE NULL::character varying
        END)::text) AS are_you_on_any_type_of_contraception,
    max((
        CASE
            WHEN (l.dataelementid = 1841) THEN l.val
            ELSE NULL::character varying
        END)::text) AS interested_in_contraception,
    max((
        CASE
            WHEN (l.dataelementid = 1823) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_in_school_or_training,
    max((
        CASE
            WHEN (l.dataelementid = 1824) THEN l.val
            ELSE NULL::character varying
        END)::text) AS school_days_missed,
    max((
        CASE
            WHEN (l.dataelementid = 1825) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reasons_for_missing_school,
    max((
        CASE
            WHEN (l.dataelementid = 1826) THEN l.val
            ELSE NULL::character varying
        END)::text) AS interested_in_going_back_to_school,
    max((
        CASE
            WHEN (l.dataelementid = 1822) THEN l.val
            ELSE NULL::character varying
        END)::text) AS does_agyw_need_post_violence_care,
    max((
        CASE
            WHEN (l.dataelementid = 1844) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_have_sexual_partner
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1907) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_screening_old OWNER TO postgres;

--
-- Name: agyw_srv_no_with_screening_date; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_srv_no_with_screening_date AS
 SELECT p.programinstanceid,
    p.trackedentityinstanceid,
    sc.screeningdate,
    COALESCE(h.htc, (0)::bigint) AS htc,
    COALESCE(ss.sstones, (0)::bigint) AS sstones,
    COALESCE(s.sinovuyo, (0)::bigint) AS sinovuyo,
    COALESCE(sb.sbhvp, (0)::bigint) AS sbhvp,
    COALESCE(sa.sasa, (0)::bigint) AS sasa,
    COALESCE(pv.pvc, (0)::bigint) AS pvc,
    COALESCE(ps.partner_services, (0)::bigint) AS partner_services,
    COALESCE(ed.educ_subsidy, (0)::bigint) AS educ_subsidy,
    COALESCE(es.econ_services, (0)::bigint) AS econ_services,
    COALESCE(cs.contraceptive_mix, (0)::bigint) AS contraceptive_mix,
    COALESCE(cp.condom_provision, (0)::bigint) AS condom_provision,
    COALESCE(ct.cash_transfer, (0)::bigint) AS cash_transfer,
    COALESCE(prep.prep, (0)::bigint) AS prep,
    COALESCE(ic.dreams_ic, (0)::bigint) AS dreams_ic,
    COALESCE(exit.dreams_exit, (0)::bigint) AS dreams_exit
   FROM ((((((((((((((((public.programinstance p
     LEFT JOIN staging.stage_screening sc ON ((sc.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_hts_w.programinstanceid,
            count(*) AS htc
           FROM staging.stage_hts_w
          WHERE (stage_hts_w.hts_result <> ''::text)
          GROUP BY stage_hts_w.programinstanceid) h ON ((p.programinstanceid = h.programinstanceid)))
     LEFT JOIN ( SELECT stage_sstones_w.programinstanceid,
            count(*) AS sstones
           FROM staging.stage_sstones_w
          WHERE (stage_sstones_w.sa = 'true'::text)
          GROUP BY stage_sstones_w.programinstanceid) ss ON ((ss.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sinovuyo_w.programinstanceid,
            count(*) AS sinovuyo
           FROM staging.stage_sinovuyo_w
          WHERE (stage_sinovuyo_w.j1 <> ''::text)
          GROUP BY stage_sinovuyo_w.programinstanceid) s ON ((s.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sbhvp_w.programinstanceid,
            count(*) AS sbhvp
           FROM staging.stage_sbhvp_w
          WHERE (stage_sbhvp_w.enrolled = 'true'::text)
          GROUP BY stage_sbhvp_w.programinstanceid) sb ON ((sb.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sasa_w.programinstanceid,
            count(*) AS sasa
           FROM staging.stage_sasa_w
          WHERE (stage_sasa_w.attended_sasa = 'true'::text)
          GROUP BY stage_sasa_w.programinstanceid) sa ON ((sa.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_pvc_w.programinstanceid,
            count(*) AS pvc
           FROM staging.stage_pvc_w
          WHERE ((stage_pvc_w.economical = 'true'::text) OR (stage_pvc_w.physical = 'true'::text) OR (stage_pvc_w.sexual = 'true'::text) OR (stage_pvc_w.psychosocial = 'true'::text) OR (stage_pvc_w.sti = 'true'::text) OR (stage_pvc_w.stepping_stones = 'true'::text) OR (stage_pvc_w.sasa = 'true'::text) OR (stage_pvc_w.sinovuyo = 'true'::text) OR (stage_pvc_w.contraceptive_mix = 'true'::text) OR (stage_pvc_w.cash_transfer = 'true'::text) OR (stage_pvc_w.condom_provision = 'true'::text) OR (stage_pvc_w.education_subsidy = 'true'::text) OR (stage_pvc_w.combined_social_economic = 'true'::text) OR (stage_pvc_w.pep = 'true'::text) OR (stage_pvc_w.linked_police = 'true'::text) OR (stage_pvc_w.psychosocial_support = 'true'::text) OR (stage_pvc_w.emergency_contraception = 'true'::text) OR (stage_pvc_w.htc = 'true'::text))
          GROUP BY stage_pvc_w.programinstanceid) pv ON ((pv.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_partner_services_w.programinstanceid,
            count(*) AS partner_services
           FROM staging.stage_partner_services_w
          WHERE ((stage_partner_services_w.fname <> ''::text) OR (stage_partner_services_w.lname <> ''::text))
          GROUP BY stage_partner_services_w.programinstanceid) ps ON ((ps.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_educ_subsidy_w.programinstanceid,
            count(*) AS educ_subsidy
           FROM staging.stage_educ_subsidy_w
          WHERE (stage_educ_subsidy_w.received = 'true'::text)
          GROUP BY stage_educ_subsidy_w.programinstanceid) ed ON ((ed.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_economic_services_w.programinstanceid,
            count(*) AS econ_services
           FROM staging.stage_economic_services_w
          WHERE ((stage_economic_services_w.fl_training = 'true'::text) OR (stage_economic_services_w.vs_training = 'true'::text) OR (stage_economic_services_w.iga_support = 'true'::text) OR (stage_economic_services_w.vsla_silc = 'true'::text) OR (stage_economic_services_w.ses_services <> ''::text))
          GROUP BY stage_economic_services_w.programinstanceid) es ON ((es.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_contraceptive_mix_w.programinstanceid,
            count(*) AS contraceptive_mix
           FROM staging.stage_contraceptive_mix_w
          WHERE (stage_contraceptive_mix_w.contraceptive_services = 'true'::text)
          GROUP BY stage_contraceptive_mix_w.programinstanceid) cs ON ((cs.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_condom_provision_w.programinstanceid,
            count(*) AS condom_provision
           FROM staging.stage_condom_provision_w
          WHERE (stage_condom_provision_w.received = 'true'::text)
          GROUP BY stage_condom_provision_w.programinstanceid) cp ON ((cp.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_cash_transfer_w.programinstanceid,
            count(*) AS cash_transfer
           FROM staging.stage_cash_transfer_w
          WHERE (stage_cash_transfer_w.cash_transfer = 'true'::text)
          GROUP BY stage_cash_transfer_w.programinstanceid) ct ON ((ct.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_prep.programinstanceid,
            count(*) AS prep
           FROM staging.stage_prep
          WHERE (stage_prep.received_prep = 'true'::text)
          GROUP BY stage_prep.programinstanceid) prep ON ((prep.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_ic.programinstanceid,
            count(*) AS dreams_ic
           FROM staging.stage_dreams_ic
          WHERE ((stage_dreams_ic.life_skills_training_received = 'true'::text) OR (stage_dreams_ic.menstrual_hygiene_received = 'true'::text) OR (stage_dreams_ic.mentorship_received = 'true'::text) OR (stage_dreams_ic.returned_to_school = 'true'::text) OR (stage_dreams_ic.economic_skills_training = 'true'::text) OR (stage_dreams_ic.market_training = 'true'::text) OR (stage_dreams_ic.che_mentorship = 'true'::text) OR (stage_dreams_ic.followup_meetings_attended = 'true'::text) OR (stage_dreams_ic.started_business = 'true'::text) OR (stage_dreams_ic.interschool_competition = 'true'::text) OR (stage_dreams_ic.train_on_gbv_prevention = 'true'::text) OR (stage_dreams_ic.hiv_prevention_information = 'true'::text) OR (stage_dreams_ic.peer_monitoring = 'true'::text) OR (stage_dreams_ic.radio_production_skills = 'true'::text))
          GROUP BY stage_dreams_ic.programinstanceid) ic ON ((ic.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_exit.programinstanceid,
            count(*) AS dreams_exit
           FROM staging.stage_dreams_exit
          WHERE (stage_dreams_exit.reason_for_exiting_dreams <> ''::text)
          GROUP BY stage_dreams_exit.programinstanceid) exit ON ((exit.programinstanceid = p.programinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679))
  WITH NO DATA;


ALTER TABLE staging.agyw_srv_no_with_screening_date OWNER TO postgres;

--
-- Name: agyw_srv_smry; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_srv_smry AS
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_hts_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.hts_result <> ''::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_sstones_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.sa = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_sinovuyo_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.j1 <> ''::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_sbhvp_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.enrolled = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_sasa_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.attended_sasa = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_pvc_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND ((s.economical = 'true'::text) OR (s.physical = 'true'::text) OR (s.sexual = 'true'::text) OR (s.psychosocial = 'true'::text) OR (s.sti = 'true'::text) OR (s.stepping_stones = 'true'::text) OR (s.sasa = 'true'::text) OR (s.sinovuyo = 'true'::text) OR (s.contraceptive_mix = 'true'::text) OR (s.cash_transfer = 'true'::text) OR (s.condom_provision = 'true'::text) OR (s.education_subsidy = 'true'::text) OR (s.combined_social_economic = 'true'::text) OR (s.pep = 'true'::text) OR (s.linked_police = 'true'::text) OR (s.psychosocial_support = 'true'::text) OR (s.emergency_contraception = 'true'::text) OR (s.htc = 'true'::text)))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_partner_services_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND ((s.fname <> ''::text) OR (s.lname <> ''::text)))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_educ_subsidy_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.received = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_economic_services_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND ((s.fl_training = 'true'::text) OR (s.vs_training = 'true'::text) OR (s.iga_support = 'true'::text) OR (s.vsla_silc = 'true'::text) OR (s.ses_services <> ''::text)))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_contraceptive_mix_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.contraceptive_services = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_condom_provision_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.received = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_cash_transfer_w s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.cash_transfer = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_prep s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND (s.received_prep = 'true'::text))
  GROUP BY d.trackedentityinstanceid
UNION ALL
 SELECT max(d.trackedentityinstanceid) AS tei,
    max((( SELECT programstage.name
           FROM public.programstage
          WHERE (programstage.programstageid = s.programstageid)))::text) AS stage,
    max(p.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = p.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM ((staging.stage_dreams_ic s
     JOIN public.programinstance p ON ((s.programinstanceid = p.programinstanceid)))
     JOIN staging.d_agyws_w d ON ((p.trackedentityinstanceid = d.trackedentityinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679) AND ((s.life_skills_training_received = 'true'::text) OR (s.menstrual_hygiene_received = 'true'::text) OR (s.mentorship_received = 'true'::text) OR (s.returned_to_school = 'true'::text) OR (s.economic_skills_training = 'true'::text) OR (s.market_training = 'true'::text) OR (s.che_mentorship = 'true'::text) OR (s.followup_meetings_attended = 'true'::text) OR (s.started_business = 'true'::text) OR (s.interschool_competition = 'true'::text) OR (s.train_on_gbv_prevention = 'true'::text) OR (s.hiv_prevention_information = 'true'::text) OR (s.peer_monitoring = 'true'::text) OR (s.radio_production_skills = 'true'::text)))
  GROUP BY d.trackedentityinstanceid
  WITH NO DATA;


ALTER TABLE staging.agyw_srv_smry OWNER TO postgres;

--
-- Name: agyw_zero_srv; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.agyw_zero_srv AS
 SELECT max(d.trackedentityinstanceid) AS tei,
    max('None'::text) AS stage,
    max(pi.enrollmentdate) AS enrolldate,
    max((( SELECT organisationunit.name
           FROM public.organisationunit
          WHERE (organisationunit.organisationunitid = ( SELECT organisationunit_1.parentid
                   FROM public.organisationunit organisationunit_1
                  WHERE (organisationunit_1.organisationunitid = pi.organisationunitid)))))::text) AS dis,
    max(d.age) AS age,
    max(d.segment) AS seg
   FROM (staging.d_agyws_w d
     JOIN public.programinstance pi ON ((d.trackedentityinstanceid = pi.trackedentityinstanceid)))
  WHERE ((NOT (d.trackedentityinstanceid IN ( SELECT DISTINCT agyw_srv_smry.tei
           FROM staging.agyw_srv_smry))) AND (pi.organisationunitid <> 899707) AND (pi.organisationunitid <> 24787679))
  GROUP BY d.trackedentityinstanceid
  WITH NO DATA;


ALTER TABLE staging.agyw_zero_srv OWNER TO postgres;

--
-- Name: cohort_analysis2; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.cohort_analysis2 AS
 SELECT
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END AS cohort,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 0) THEN 1
            ELSE 0
        END) AS zero,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 1) THEN 1
            ELSE 0
        END) AS one_service,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 2) THEN 1
            ELSE 0
        END) AS two_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 3) THEN 1
            ELSE 0
        END) AS three_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 4) THEN 1
            ELSE 0
        END) AS four_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 5) THEN 1
            ELSE 0
        END) AS five_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 6) THEN 1
            ELSE 0
        END) AS six_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 7) THEN 1
            ELSE 0
        END) AS seven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 8) THEN 1
            ELSE 0
        END) AS eight_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 9) THEN 1
            ELSE 0
        END) AS nine_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 10) THEN 1
            ELSE 0
        END) AS ten_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 11) THEN 1
            ELSE 0
        END) AS eleven_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) = 12) THEN 1
            ELSE 0
        END) AS twelve_services,
    sum(
        CASE
            WHEN ((((((((((((
            CASE
                WHEN (tbl.htc > 0) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (tbl.sstones > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sinovuyo > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sbhvp > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.sasa > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.pvc > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.partner_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.educ_subsidy > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.econ_services > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.contraceptive_mix > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.condom_provision > 0) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (tbl.cash_transfer > 0) THEN 1
                ELSE 0
            END) >= 5) THEN 1
            ELSE 0
        END) AS five_plus_services,
    tbl.ip AS implementing_partner
   FROM ( SELECT l.enrollmentdate,
            l.district,
            l.subcounty,
            l.status,
            l.trackedentityinstanceid,
            l.ip,
            l.dreams_id,
            l.sim_card_no,
            l.fname,
            l.lname,
            l.dob,
            l.age,
            l.maiden_name,
            l.parish,
            l.village,
            l.phone,
            l.location_coordinates,
            l.education_status,
            l.disability,
            l.parental_status,
            l.entry,
            l.married,
            l.pregnant,
            l.given_birth_at_15,
            l.first_child_birth,
            l.segment,
            s.programinstanceid,
            s.trackedentityinstanceid,
            s.htc,
            s.sstones,
            s.sinovuyo,
            s.sbhvp,
            s.sasa,
            s.pvc,
            s.partner_services,
            s.educ_subsidy,
            s.econ_services,
            s.contraceptive_mix,
            s.condom_provision,
            s.cash_transfer
           FROM (staging.agyws_list l
             JOIN staging.agyw_srv_no s ON ((l.trackedentityinstanceid = s.trackedentityinstanceid)))) tbl(enrollmentdate, district, subcounty, status, trackedentityinstanceid, ip, dreams_id, sim_card_no, fname, lname, dob, age, maiden_name, parish, village, phone, location_coordinates, education_status, disability, parental_status, entry, married, pregnant, given_birth_at_15, first_child_birth, segment, programinstanceid, trackedentityinstanceid_1, htc, sstones, sinovuyo, sbhvp, sasa, pvc, partner_services, educ_subsidy, econ_services, contraceptive_mix, condom_provision, cash_transfer)
  GROUP BY tbl.ip,
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END
  ORDER BY
        CASE
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (6)::numeric) THEN '0-6 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (7)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (12)::numeric)) THEN '07-12 Months'::text
            WHEN ((round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (13)::numeric) AND (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) <= (24)::numeric)) THEN '13-24 Months'::text
            WHEN (round((((date(now()) - date(tbl.enrollmentdate)))::numeric / 30.5), 0) >= (25)::numeric) THEN '25+ Months'::text
            ELSE NULL::text
        END
  WITH NO DATA;


ALTER TABLE staging.cohort_analysis2 OWNER TO postgres;

--
-- Name: d_ovchh_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.d_ovchh_w AS
 SELECT agyws_l.trackedentityinstanceid,
    max((
        CASE
            WHEN (agyws_l.id = 1517164) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (agyws_l.id = 1900) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS dreams_id,
    max((
        CASE
            WHEN (agyws_l.id = 1905) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS sim_card_no,
    max((
        CASE
            WHEN (agyws_l.id = 1884) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS fname,
    max((
        CASE
            WHEN (agyws_l.id = 1885) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS lname,
    max((
        CASE
            WHEN (agyws_l.id = 1886) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS dob,
    max(
        CASE
            WHEN (agyws_l.id = 1887) THEN (agyws_l.value)::double precision
            ELSE NULL::double precision
        END) AS age,
    max((
        CASE
            WHEN (agyws_l.id = 2262) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS maiden_name,
    max((
        CASE
            WHEN (agyws_l.id = 1889) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS parish,
    max((
        CASE
            WHEN (agyws_l.id = 1890) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS village,
    max((
        CASE
            WHEN (agyws_l.id = 1883) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS phone,
    max((
        CASE
            WHEN (agyws_l.id = 2309) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS location_coordinates,
    max((
        CASE
            WHEN (agyws_l.id = 1891) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS education_status,
    max((
        CASE
            WHEN (agyws_l.id = 1897) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS disability,
    max((
        CASE
            WHEN (agyws_l.id = 1896) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS parental_status,
    max((
        CASE
            WHEN (agyws_l.id = 1901) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS entry,
    max((
        CASE
            WHEN (agyws_l.id = 1892) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS married,
    max((
        CASE
            WHEN (agyws_l.id = 1893) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS pregnant,
    max((
        CASE
            WHEN (agyws_l.id = 1894) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS given_birth_at_15,
    max((
        CASE
            WHEN (agyws_l.id = 2263) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS first_child_birth,
    max((
        CASE
            WHEN (agyws_l.id = 1902) THEN agyws_l.value
            ELSE NULL::character varying
        END)::text) AS segment
   FROM staging.agyws_l
  WHERE (agyws_l.programid = 23576601)
  GROUP BY agyws_l.trackedentityinstanceid;


ALTER TABLE staging.d_ovchh_w OWNER TO postgres;

--
-- Name: ogstructure; Type: TABLE; Schema: staging; Owner: postgres
--

CREATE TABLE staging.ogstructure (
    organisationunitid integer,
    organisationunituid character(11),
    level integer,
    idlevel1 integer,
    uidlevel1 character(11),
    idlevel2 integer,
    uidlevel2 character(11),
    idlevel3 integer,
    uidlevel3 character(11),
    idlevel4 integer,
    uidlevel4 character(11)
);


ALTER TABLE staging.ogstructure OWNER TO postgres;

--
-- Name: pg_status; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.pg_status AS
 SELECT stage_sinovuyo_w.programinstanceid,
    max(
        CASE
            WHEN (((stage_sinovuyo_w.j1 = 'Only child'::text) OR (stage_sinovuyo_w.j1 = 'Both'::text) OR (stage_sinovuyo_w.j1 = 'Only parent'::text)) AND ((stage_sinovuyo_w.j14 = 'Only child'::text) OR (stage_sinovuyo_w.j14 = 'Both'::text) OR (stage_sinovuyo_w.j14 = 'Only parent'::text))) THEN 1
            ELSE 0
        END) AS complete
   FROM staging.stage_sinovuyo_w
  WHERE (stage_sinovuyo_w.organisationunitid <> 899707)
  GROUP BY stage_sinovuyo_w.programinstanceid
  WITH NO DATA;


ALTER TABLE staging.pg_status OWNER TO postgres;

--
-- Name: sbhvp_ip; Type: MATERIALIZED VIEW; Schema: staging; Owner: postgres
--

CREATE MATERIALIZED VIEW staging.sbhvp_ip AS
 SELECT p.programinstanceid,
    p.trackedentityinstanceid,
    COALESCE(h.htc, (0)::bigint) AS htc,
    COALESCE(ss.sstones, (0)::bigint) AS sstones,
    COALESCE(s.sinovuyo, (0)::bigint) AS sinovuyo,
    COALESCE(sb.sbhvp, (0)::bigint) AS sbhvp,
    sb.ip,
    COALESCE(sa.sasa, (0)::bigint) AS sasa,
    COALESCE(pv.pvc, (0)::bigint) AS pvc,
    COALESCE(ps.partner_services, (0)::bigint) AS partner_services,
    COALESCE(ed.educ_subsidy, (0)::bigint) AS educ_subsidy,
    COALESCE(es.econ_services, (0)::bigint) AS econ_services,
    COALESCE(cs.contraceptive_mix, (0)::bigint) AS contraceptive_mix,
    COALESCE(cp.condom_provision, (0)::bigint) AS condom_provision,
    COALESCE(ct.cash_transfer, (0)::bigint) AS cash_transfer,
    COALESCE(prep.prep, (0)::bigint) AS prep,
    COALESCE(ic.dreams_ic, (0)::bigint) AS dreams_ic,
    COALESCE(exit.dreams_exit, (0)::bigint) AS dreams_exit
   FROM (((((((((((((((public.programinstance p
     LEFT JOIN ( SELECT stage_hts_w.programinstanceid,
            count(*) AS htc
           FROM staging.stage_hts_w
          WHERE (stage_hts_w.hts_result <> ''::text)
          GROUP BY stage_hts_w.programinstanceid) h ON ((p.programinstanceid = h.programinstanceid)))
     LEFT JOIN ( SELECT stage_sstones_w.programinstanceid,
            count(*) AS sstones
           FROM staging.stage_sstones_w
          WHERE (stage_sstones_w.sa = 'true'::text)
          GROUP BY stage_sstones_w.programinstanceid) ss ON ((ss.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sinovuyo_w.programinstanceid,
            count(*) AS sinovuyo
           FROM staging.stage_sinovuyo_w
          WHERE (stage_sinovuyo_w.j1 <> ''::text)
          GROUP BY stage_sinovuyo_w.programinstanceid) s ON ((s.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sbhvp_w.programinstanceid,
            stage_sbhvp_w.ip,
            count(*) AS sbhvp
           FROM staging.stage_sbhvp_w
          WHERE (stage_sbhvp_w.enrolled = 'true'::text)
          GROUP BY stage_sbhvp_w.programinstanceid, stage_sbhvp_w.ip) sb ON ((sb.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_sasa_w.programinstanceid,
            count(*) AS sasa
           FROM staging.stage_sasa_w
          WHERE (stage_sasa_w.attended_sasa = 'true'::text)
          GROUP BY stage_sasa_w.programinstanceid) sa ON ((sa.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_pvc_w.programinstanceid,
            count(*) AS pvc
           FROM staging.stage_pvc_w
          WHERE ((stage_pvc_w.economical = 'true'::text) OR (stage_pvc_w.physical = 'true'::text) OR (stage_pvc_w.sexual = 'true'::text) OR (stage_pvc_w.psychosocial = 'true'::text) OR (stage_pvc_w.sti = 'true'::text) OR (stage_pvc_w.stepping_stones = 'true'::text) OR (stage_pvc_w.sasa = 'true'::text) OR (stage_pvc_w.sinovuyo = 'true'::text) OR (stage_pvc_w.contraceptive_mix = 'true'::text) OR (stage_pvc_w.cash_transfer = 'true'::text) OR (stage_pvc_w.condom_provision = 'true'::text) OR (stage_pvc_w.education_subsidy = 'true'::text) OR (stage_pvc_w.combined_social_economic = 'true'::text) OR (stage_pvc_w.pep = 'true'::text) OR (stage_pvc_w.linked_police = 'true'::text) OR (stage_pvc_w.psychosocial_support = 'true'::text) OR (stage_pvc_w.emergency_contraception = 'true'::text) OR (stage_pvc_w.htc = 'true'::text))
          GROUP BY stage_pvc_w.programinstanceid) pv ON ((pv.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_partner_services_w.programinstanceid,
            count(*) AS partner_services
           FROM staging.stage_partner_services_w
          WHERE ((stage_partner_services_w.fname <> ''::text) OR (stage_partner_services_w.lname <> ''::text))
          GROUP BY stage_partner_services_w.programinstanceid) ps ON ((ps.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_educ_subsidy_w.programinstanceid,
            count(*) AS educ_subsidy
           FROM staging.stage_educ_subsidy_w
          WHERE (stage_educ_subsidy_w.received = 'true'::text)
          GROUP BY stage_educ_subsidy_w.programinstanceid) ed ON ((ed.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_economic_services_w.programinstanceid,
            count(*) AS econ_services
           FROM staging.stage_economic_services_w
          WHERE ((stage_economic_services_w.fl_training = 'true'::text) OR (stage_economic_services_w.vs_training = 'true'::text) OR (stage_economic_services_w.iga_support = 'true'::text) OR (stage_economic_services_w.vsla_silc = 'true'::text) OR (stage_economic_services_w.ses_services <> ''::text))
          GROUP BY stage_economic_services_w.programinstanceid) es ON ((es.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_contraceptive_mix_w.programinstanceid,
            count(*) AS contraceptive_mix
           FROM staging.stage_contraceptive_mix_w
          WHERE (stage_contraceptive_mix_w.contraceptive_services = 'true'::text)
          GROUP BY stage_contraceptive_mix_w.programinstanceid) cs ON ((cs.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_condom_provision_w.programinstanceid,
            count(*) AS condom_provision
           FROM staging.stage_condom_provision_w
          WHERE (stage_condom_provision_w.received = 'true'::text)
          GROUP BY stage_condom_provision_w.programinstanceid) cp ON ((cp.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_cash_transfer_w.programinstanceid,
            count(*) AS cash_transfer
           FROM staging.stage_cash_transfer_w
          WHERE (stage_cash_transfer_w.cash_transfer = 'true'::text)
          GROUP BY stage_cash_transfer_w.programinstanceid) ct ON ((ct.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_prep.programinstanceid,
            count(*) AS prep
           FROM staging.stage_prep
          WHERE (stage_prep.received_prep = 'true'::text)
          GROUP BY stage_prep.programinstanceid) prep ON ((prep.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_ic.programinstanceid,
            count(*) AS dreams_ic
           FROM staging.stage_dreams_ic
          WHERE ((stage_dreams_ic.life_skills_training_received = 'true'::text) OR (stage_dreams_ic.menstrual_hygiene_received = 'true'::text) OR (stage_dreams_ic.mentorship_received = 'true'::text) OR (stage_dreams_ic.returned_to_school = 'true'::text) OR (stage_dreams_ic.economic_skills_training = 'true'::text) OR (stage_dreams_ic.market_training = 'true'::text) OR (stage_dreams_ic.che_mentorship = 'true'::text) OR (stage_dreams_ic.followup_meetings_attended = 'true'::text) OR (stage_dreams_ic.started_business = 'true'::text) OR (stage_dreams_ic.interschool_competition = 'true'::text) OR (stage_dreams_ic.train_on_gbv_prevention = 'true'::text) OR (stage_dreams_ic.hiv_prevention_information = 'true'::text) OR (stage_dreams_ic.peer_monitoring = 'true'::text) OR (stage_dreams_ic.radio_production_skills = 'true'::text))
          GROUP BY stage_dreams_ic.programinstanceid) ic ON ((ic.programinstanceid = p.programinstanceid)))
     LEFT JOIN ( SELECT stage_dreams_exit.programinstanceid,
            count(*) AS dreams_exit
           FROM staging.stage_dreams_exit
          WHERE (stage_dreams_exit.reason_for_exiting_dreams <> ''::text)
          GROUP BY stage_dreams_exit.programinstanceid) exit ON ((exit.programinstanceid = p.programinstanceid)))
  WHERE ((p.organisationunitid <> 899707) AND (p.organisationunitid <> 24787679))
  WITH NO DATA;


ALTER TABLE staging.sbhvp_ip OWNER TO postgres;

--
-- Name: ses_services_received; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.ses_services_received AS
 SELECT ses.programinstanceid,
    ses.programstageinstanceid,
    ses.programstageid,
    ses.executiondate,
    ses.duedate,
    ses.organisationunitid,
    ses.sub_county,
    ses.status,
    ses.ip,
    max(
        CASE
            WHEN ((ses.fl_training = 'true'::text) OR (ses.ses_services = 'Financial Literacy Training'::text)) THEN 1
            ELSE 0
        END) AS fl_training_received,
    ses.fl_date,
    max(
        CASE
            WHEN ((ses.vs_training = 'true'::text) OR (ses.ses_services = 'Vocational skills training'::text)) THEN 1
            ELSE 0
        END) AS vs_training_received,
    ses.vs_date,
    max(
        CASE
            WHEN ((ses.iga_support = 'true'::text) OR (ses.ses_services = 'Linkage to IGA support'::text)) THEN 1
            ELSE 0
        END) AS linked_to_iga_support,
    ses.iga_date,
    max(
        CASE
            WHEN ((ses.vsla_silc = 'true'::text) OR (ses.ses_services = 'VSLA / SILC'::text)) THEN 1
            ELSE 0
        END) AS vsla_silc_received,
    ses.vsla_silc_date,
    max(
        CASE
            WHEN ((ses.entrepreneurship = 'true'::text) OR (ses.ses_services = 'Entrepreneurship'::text)) THEN 1
            ELSE 0
        END) AS entrepreneurship_received,
    ses.entrepreneurship_date,
    max(
        CASE
            WHEN ((ses.microfinance = 'true'::text) OR (ses.ses_services = 'Microfinance and credit'::text)) THEN 1
            ELSE 0
        END) AS microfinance_received,
    ses.microfinance_date,
    max(
        CASE
            WHEN ((ses.business_skills = 'true'::text) OR (ses.ses_services = 'Business Skills'::text)) THEN 1
            ELSE 0
        END) AS business_skills_received,
    ses.business_skills_date,
    max(
        CASE
            WHEN ((ses.startup_kits = 'true'::text) OR (ses.ses_services = 'Startup kits/Capital'::text)) THEN 1
            ELSE 0
        END) AS start_up_kits_received,
    ses.start_upkitsdate,
    ses.program_status
   FROM staging.stage_economic_services_w ses
  WHERE ((ses.programstageid = 1917) AND (ses.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY ses.programstageinstanceid, ses.program_status, ses.programinstanceid, ses.programstageid, ses.executiondate, ses.duedate, ses.organisationunitid, ses.status, ses.sub_county, ses.ip, ses.fl_date, ses.iga_date, ses.vs_date, ses.vsla_silc_date, ses.entrepreneurship_date, ses.microfinance_date, ses.business_skills_date, ses.start_upkitsdate;


ALTER TABLE staging.ses_services_received OWNER TO postgres;

--
-- Name: sinovuyo_sessions_attended; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.sinovuyo_sessions_attended AS
 SELECT sino.programinstanceid,
    sino.programstageinstanceid,
    sino.programstageid,
    sino.executiondate,
    sino.duedate,
    sino.organisationunitid,
    sino.sub_county,
    sino.status,
    sino.gname,
    sino.ip,
    max(
        CASE
            WHEN ((sino.j1 = 'Both'::text) OR (sino.j1 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j1_received,
    sino.dj1,
    max(
        CASE
            WHEN ((sino.j2 = 'Both'::text) OR (sino.j2 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j2_received,
    sino.dj2,
    max(
        CASE
            WHEN ((sino.j3 = 'Both'::text) OR (sino.j3 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j3_received,
    sino.dj3,
    max(
        CASE
            WHEN ((sino.s4 = 'Both'::text) OR (sino.s4 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s4_received,
    sino.ds4,
    max(
        CASE
            WHEN ((sino.s5 = 'Both'::text) OR (sino.s5 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s5_received,
    sino.ds5,
    max(
        CASE
            WHEN ((sino.j6 = 'Both'::text) OR (sino.j6 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j6_received,
    sino.dj6,
    max(
        CASE
            WHEN ((sino.j7 = 'Both'::text) OR (sino.j7 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j7_received,
    sino.dj7,
    max(
        CASE
            WHEN ((sino.s8 = 'Both'::text) OR (sino.s8 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s8_received,
    sino.ds8,
    max(
        CASE
            WHEN ((sino.s9 = 'Both'::text) OR (sino.s9 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s9_received,
    sino.ds9,
    max(
        CASE
            WHEN ((sino.j10 = 'Both'::text) OR (sino.j10 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j10_received,
    sino.dj10,
    max(
        CASE
            WHEN ((sino.j11 = 'Both'::text) OR (sino.j11 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j11_received,
    sino.dj11,
    max(
        CASE
            WHEN ((sino.j12 = 'Both'::text) OR (sino.j12 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j12_received,
    sino.dj12,
    max(
        CASE
            WHEN ((sino.j13 = 'Both'::text) OR (sino.j13 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j13_received,
    sino.dj13,
    max(
        CASE
            WHEN ((sino.j14 = 'Both'::text) OR (sino.j14 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j14_received,
    sino.dj14,
    sino.program_status
   FROM staging.stage_sinovuyo_w sino
  WHERE (sino.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679]))
  GROUP BY sino.programstageinstanceid, sino.program_status, sino.programinstanceid, sino.programstageid, sino.executiondate, sino.duedate, sino.organisationunitid, sino.status, sino.sub_county, sino.gname, sino.dj1, sino.dj2, sino.dj10, sino.dj11, sino.dj12, sino.dj13, sino.dj14, sino.dj3, sino.dj6, sino.dj7, sino.ds4, sino.ds5, sino.ds8, sino.ds9, sino.ip;


ALTER TABLE staging.sinovuyo_sessions_attended OWNER TO postgres;

--
-- Name: sinovuyo_sessions_attended_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.sinovuyo_sessions_attended_current_year AS
 SELECT sino.programinstanceid,
    sino.programstageinstanceid,
    sino.programstageid,
    sino.executiondate,
    sino.duedate,
    sino.organisationunitid,
    sino.sub_county,
    sino.status,
    sino.gname,
    sino.ip,
    max(
        CASE
            WHEN ((sino.j1 = 'Both'::text) OR (sino.j1 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j1_received,
    sino.dj1,
    max(
        CASE
            WHEN ((sino.j2 = 'Both'::text) OR (sino.j2 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j2_received,
    sino.dj2,
    max(
        CASE
            WHEN ((sino.j3 = 'Both'::text) OR (sino.j3 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j3_received,
    sino.dj3,
    max(
        CASE
            WHEN ((sino.s4 = 'Both'::text) OR (sino.s4 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s4_received,
    sino.ds4,
    max(
        CASE
            WHEN ((sino.s5 = 'Both'::text) OR (sino.s5 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s5_received,
    sino.ds5,
    max(
        CASE
            WHEN ((sino.j6 = 'Both'::text) OR (sino.j6 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j6_received,
    sino.dj6,
    max(
        CASE
            WHEN ((sino.j7 = 'Both'::text) OR (sino.j7 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j7_received,
    sino.dj7,
    max(
        CASE
            WHEN ((sino.s8 = 'Both'::text) OR (sino.s8 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s8_received,
    sino.ds8,
    max(
        CASE
            WHEN ((sino.s9 = 'Both'::text) OR (sino.s9 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS s9_received,
    sino.ds9,
    max(
        CASE
            WHEN ((sino.j10 = 'Both'::text) OR (sino.j10 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j10_received,
    sino.dj10,
    max(
        CASE
            WHEN ((sino.j11 = 'Both'::text) OR (sino.j11 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j11_received,
    sino.dj11,
    max(
        CASE
            WHEN ((sino.j12 = 'Both'::text) OR (sino.j12 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j12_received,
    sino.dj12,
    max(
        CASE
            WHEN ((sino.j13 = 'Both'::text) OR (sino.j13 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j13_received,
    sino.dj13,
    max(
        CASE
            WHEN ((sino.j14 = 'Both'::text) OR (sino.j14 = 'Only child'::text)) THEN 1
            ELSE 0
        END) AS j14_received,
    sino.dj14,
    sino.program_status
   FROM staging.stage_sinovuyo_w sino
  WHERE ((sino.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (sino.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (sino.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY sino.programstageinstanceid, sino.program_status, sino.programinstanceid, sino.programstageid, sino.executiondate, sino.duedate, sino.organisationunitid, sino.status, sino.sub_county, sino.gname, sino.dj1, sino.dj2, sino.dj10, sino.dj11, sino.dj12, sino.dj13, sino.dj14, sino.dj3, sino.dj6, sino.dj7, sino.ds4, sino.ds5, sino.ds8, sino.ds9, sino.ip;


ALTER TABLE staging.sinovuyo_sessions_attended_current_year OWNER TO postgres;

--
-- Name: sstones_sessions_attended; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.sstones_sessions_attended AS
 SELECT ss.programinstanceid,
    ss.programstageinstanceid,
    ss.programstageid,
    ss.executiondate,
    ss.duedate,
    ss.organisationunitid,
    ss.sub_county,
    ss.status,
    ss.gname,
    ss.ip,
    max(
        CASE
            WHEN (ss.sa = 'true'::text) THEN 1
            ELSE 0
        END) AS sa_attended,
    ss.dsa,
    max(
        CASE
            WHEN (ss.sb = 'true'::text) THEN 1
            ELSE 0
        END) AS sb_attended,
    ss.dsb,
    max(
        CASE
            WHEN (ss.sc = 'true'::text) THEN 1
            ELSE 0
        END) AS sc_attended,
    ss.dsc,
    max(
        CASE
            WHEN (ss.m1 = 'true'::text) THEN 1
            ELSE 0
        END) AS m1_attended,
    ss.dm1,
    max(
        CASE
            WHEN (ss.sd = 'true'::text) THEN 1
            ELSE 0
        END) AS sd_attended,
    ss.dsd,
    max(
        CASE
            WHEN (ss.se = 'true'::text) THEN 1
            ELSE 0
        END) AS se_attended,
    ss.dse,
    max(
        CASE
            WHEN (ss.sf = 'true'::text) THEN 1
            ELSE 0
        END) AS sf_attended,
    ss.dsf,
    max(
        CASE
            WHEN (ss.sg = 'true'::text) THEN 1
            ELSE 0
        END) AS sg_attended,
    ss.dsg,
    max(
        CASE
            WHEN (ss.m2 = 'true'::text) THEN 1
            ELSE 0
        END) AS m2_attended,
    ss.dm2,
    max(
        CASE
            WHEN (ss.sh = 'true'::text) THEN 1
            ELSE 0
        END) AS sh_attended,
    ss.dsh,
    max(
        CASE
            WHEN (ss.si = 'true'::text) THEN 1
            ELSE 0
        END) AS si_attended,
    ss.dsi,
    max(
        CASE
            WHEN (ss.sj = 'true'::text) THEN 1
            ELSE 0
        END) AS sj_attended,
    ss.dsj,
    max(
        CASE
            WHEN (ss.m3 = 'true'::text) THEN 1
            ELSE 0
        END) AS m3_attended,
    ss.dm3,
    ss.program_status
   FROM staging.stage_sstones_w ss
  WHERE (ss.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679]))
  GROUP BY ss.programstageinstanceid, ss.program_status, ss.programinstanceid, ss.programstageid, ss.executiondate, ss.duedate, ss.organisationunitid, ss.status, ss.dm1, ss.dm2, ss.dm3, ss.dsa, ss.dsb, ss.dsc, ss.dsd, ss.dse, ss.dsf, ss.dsg, ss.dsh, ss.dsi, ss.dsj, ss.gname, ss.ip, ss.sub_county;


ALTER TABLE staging.sstones_sessions_attended OWNER TO postgres;

--
-- Name: sstones_sessions_attended_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.sstones_sessions_attended_current_year AS
 SELECT ss.programinstanceid,
    ss.programstageinstanceid,
    ss.programstageid,
    ss.executiondate,
    ss.duedate,
    ss.organisationunitid,
    ss.sub_county,
    ss.status,
    ss.gname,
    ss.ip,
    max(
        CASE
            WHEN (ss.sa = 'true'::text) THEN 1
            ELSE 0
        END) AS sa_attended,
    ss.dsa,
    max(
        CASE
            WHEN (ss.sb = 'true'::text) THEN 1
            ELSE 0
        END) AS sb_attended,
    ss.dsb,
    max(
        CASE
            WHEN (ss.sc = 'true'::text) THEN 1
            ELSE 0
        END) AS sc_attended,
    ss.dsc,
    max(
        CASE
            WHEN (ss.m1 = 'true'::text) THEN 1
            ELSE 0
        END) AS m1_attended,
    ss.dm1,
    max(
        CASE
            WHEN (ss.sd = 'true'::text) THEN 1
            ELSE 0
        END) AS sd_attended,
    ss.dsd,
    max(
        CASE
            WHEN (ss.se = 'true'::text) THEN 1
            ELSE 0
        END) AS se_attended,
    ss.dse,
    max(
        CASE
            WHEN (ss.sf = 'true'::text) THEN 1
            ELSE 0
        END) AS sf_attended,
    ss.dsf,
    max(
        CASE
            WHEN (ss.sg = 'true'::text) THEN 1
            ELSE 0
        END) AS sg_attended,
    ss.dsg,
    max(
        CASE
            WHEN (ss.m2 = 'true'::text) THEN 1
            ELSE 0
        END) AS m2_attended,
    ss.dm2,
    max(
        CASE
            WHEN (ss.sh = 'true'::text) THEN 1
            ELSE 0
        END) AS sh_attended,
    ss.dsh,
    max(
        CASE
            WHEN (ss.si = 'true'::text) THEN 1
            ELSE 0
        END) AS si_attended,
    ss.dsi,
    max(
        CASE
            WHEN (ss.sj = 'true'::text) THEN 1
            ELSE 0
        END) AS sj_attended,
    ss.dsj,
    max(
        CASE
            WHEN (ss.m3 = 'true'::text) THEN 1
            ELSE 0
        END) AS m3_attended,
    ss.dm3,
    ss.program_status
   FROM staging.stage_sstones_w ss
  WHERE ((ss.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (ss.executiondate >= '2019-10-01 00:00:00'::timestamp without time zone) AND (ss.executiondate < '2020-10-01 00:00:00'::timestamp without time zone))
  GROUP BY ss.programstageinstanceid, ss.program_status, ss.programinstanceid, ss.programstageid, ss.executiondate, ss.duedate, ss.organisationunitid, ss.status, ss.dm1, ss.dm2, ss.dm3, ss.dsa, ss.dsb, ss.dsc, ss.dsd, ss.dse, ss.dsf, ss.dsg, ss.dsh, ss.dsi, ss.dsj, ss.gname, ss.ip, ss.sub_county;


ALTER TABLE staging.sstones_sessions_attended_current_year OWNER TO postgres;

--
-- Name: stage_aflateen_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_aflateen_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 210765019) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflateen_peer_group,
    max((
        CASE
            WHEN (l.dataelementid = 210764550) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflateen_name_of_facilitator,
    max((
        CASE
            WHEN (l.dataelementid = 288611084) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflateen_facilitator_contact,
    max((
        CASE
            WHEN (l.dataelementid = 288616639) THEN l.val
            ELSE NULL::character varying
        END)::text) AS welcome_to_aflateen,
   max((
        CASE
            WHEN (l.dataelementid = 288617496) THEN l.val
            ELSE NULL::character varying
        END)::text) AS my_family,
   max((
        CASE
            WHEN (l.dataelementid = 288618213) THEN l.val
            ELSE NULL::character varying
        END)::text) AS my_goal_my_dreams,
   max((
        CASE
            WHEN (l.dataelementid = 288618711) THEN l.val
            ELSE NULL::character varying
        END)::text) AS my_career,
    max((
        CASE
            WHEN (l.dataelementid = 210742803) THEN l.val
            ELSE NULL::character varying
        END)::text) AS money_and_well_being,
    max((
        CASE
            WHEN (l.dataelementid = 210744414) THEN l.val
            ELSE NULL::character varying
        END)::text) AS learning_about_saving,
    max((
        CASE
            WHEN (l.dataelementid = 210745146) THEN l.val
            ELSE NULL::character varying
        END)::text) AS learning_about_spending,
    max((
        CASE
            WHEN (l.dataelementid = 210745410) THEN l.val
            ELSE NULL::character varying
        END)::text) AS creating_a_budget,
    max((
        CASE
            WHEN (l.dataelementid = 210745599) THEN l.val
            ELSE NULL::character varying
        END)::text) AS saving_options,
    max((
        CASE
            WHEN (l.dataelementid = 210745892) THEN l.val
            ELSE NULL::character varying
        END)::text) AS smart_savers,
    max((
        CASE
            WHEN (l.dataelementid = 210746148) THEN l.val
            ELSE NULL::character varying
        END)::text) AS borrowing_money,
    max((
        CASE
            WHEN (l.dataelementid = 210747902) THEN l.val
            ELSE NULL::character varying
        END)::text) AS money_power_and_rights,
    max((
        CASE
            WHEN (l.dataelementid = 210749550) THEN l.val
            ELSE NULL::character varying
        END)::text) AS being_a_cool_consumer,
    max((
        CASE
            WHEN (l.dataelementid = 210756566) THEN l.val
            ELSE NULL::character varying
        END)::text) AS budgeting_for_an_enterprise,
    max((
        CASE
            WHEN (l.dataelementid = 210757325) THEN l.val
            ELSE NULL::character varying
        END)::text) AS social_enterprise,
    max((
        CASE
            WHEN (l.dataelementid = 210757772) THEN l.val
            ELSE NULL::character varying
        END)::text) AS financial_enterprise,
    max((
        CASE
            WHEN (l.dataelementid = 288629805) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_welcome_to_aflateen,   
   max((
        CASE
            WHEN (l.dataelementid = 288631648) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_my_family,
   max((
        CASE
            WHEN (l.dataelementid = 288634862) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_my_goal_my_dreams,
  max((
        CASE
            WHEN (l.dataelementid = 288635923) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_my_career,
    max((
        CASE
            WHEN (l.dataelementid = 210743894) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_money_and_well_being,
    max((
        CASE
            WHEN (l.dataelementid = 210744923) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_learning_about_saving,
    max((
        CASE
            WHEN (l.dataelementid = 210746945) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_learning_about_spending,
    max((
        CASE
            WHEN (l.dataelementid = 210747108) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_creating_a_budget,
    max((
        CASE
            WHEN (l.dataelementid = 210747223) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_saving_options,
    max((
        CASE
            WHEN (l.dataelementid = 210747367) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_smart_savers,
    max((
        CASE
            WHEN (l.dataelementid = 210746547) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_borrowing_money,
    max((
        CASE
            WHEN (l.dataelementid = 210748758) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_money_power_and_rights,
    max((
        CASE
            WHEN (l.dataelementid = 210752263) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_being_a_cool_consumer,
 
    max((
        CASE
            WHEN (l.dataelementid = 210756781) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_budgeting_for_an_enterprise,
    max((
        CASE
            WHEN (l.dataelementid = 210757541) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_social_enterprise,
    max((
        CASE
            WHEN (l.dataelementid = 210757962) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_financial_enterprise,
    
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 210739069) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_aflateen_w OWNER TO postgres;

--
-- Name: stage_aflatoun_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_aflatoun_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 286782475) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_peer_group,
    max((
        CASE
            WHEN (l.dataelementid = 286781698) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_name_of_facilitator,
    max((
        CASE
            WHEN (l.dataelementid = 286781965) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_facilitator_contact,

    max((
        CASE
            WHEN (l.dataelementid = 286836505) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_flag,
    max((
        CASE
            WHEN (l.dataelementid = 286836763) THEN l.val
            ELSE NULL::character varying
        END)::text) AS afla_passport,
    max((
        CASE
            WHEN (l.dataelementid = 286836861) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_mosaic,
    max((
        CASE
            WHEN (l.dataelementid = 286836995) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_club_badges,
    max((
        CASE
            WHEN (l.dataelementid = 286837049) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_identity_cards,
    max((
        CASE
            WHEN (l.dataelementid = 286837076) THEN l.val
            ELSE NULL::character varying
        END)::text) AS aflatoun_pledge,
    max((
        CASE
            WHEN (l.dataelementid = 286837600) THEN l.val
            ELSE NULL::character varying
        END)::text) AS musa_aflatoun_box,
    max((
        CASE
            WHEN (l.dataelementid = 286837828) THEN l.val
            ELSE NULL::character varying
        END)::text) AS daniel_makes_a_mistake,
    max((
        CASE
            WHEN (l.dataelementid = 286837914) THEN l.val
            ELSE NULL::character varying
        END)::text) AS origins_of_money,


    max((
        CASE
            WHEN (l.dataelementid = 286837965) THEN l.val
            ELSE NULL::character varying
        END)::text) AS effective_thinker,
    max((
        CASE
            WHEN (l.dataelementid = 286838087) THEN l.val
            ELSE NULL::character varying
        END)::text) AS thats_my_goal,
   max((
        CASE
            WHEN (l.dataelementid = 286838158) THEN l.val
            ELSE NULL::character varying
        END)::text) AS creating_our_dream_board,
   max((
        CASE
            WHEN (l.dataelementid = 286838204) THEN l.val
            ELSE NULL::character varying
        END)::text) AS a_letter_to_myself,
   max((
        CASE
            WHEN (l.dataelementid = 286838371) THEN l.val
            ELSE NULL::character varying
        END)::text) AS opening_your_letter,
   max((
        CASE
            WHEN (l.dataelementid = 286838446) THEN l.val
            ELSE NULL::character varying
        END)::text) AS smiley_face_reflections,
   max((
        CASE
            WHEN (l.dataelementid = 286838481) THEN l.val
            ELSE NULL::character varying
        END)::text) AS target_reflections,
   max((
        CASE
            WHEN (l.dataelementid = 286838608) THEN l.val
            ELSE NULL::character varying
        END)::text) AS six_word_reflections,

   max((
        CASE
            WHEN (l.dataelementid = 286838668) THEN l.val
            ELSE NULL::character varying
        END)::text) AS school_year_poster,
   max((
        CASE
            WHEN (l.dataelementid = 286838776) THEN l.val
            ELSE NULL::character varying
        END)::text) AS balancing_branches,
    max((
        CASE
            WHEN (l.dataelementid = 286839049) THEN l.val
            ELSE NULL::character varying
        END)::text) AS how_long_is_piece_of_string,
    max((
        CASE
            WHEN (l.dataelementid = 286839396) THEN l.val
            ELSE NULL::character varying
        END)::text) AS who_can_help_me,
   max((
        CASE
            WHEN (l.dataelementid = 286839630) THEN l.val
            ELSE NULL::character varying
        END)::text) AS mind_mapping,
   max((
        CASE
            WHEN (l.dataelementid = 286839775) THEN l.val
            ELSE NULL::character varying
        END)::text) AS how_to_brainstorm,
   max((
        CASE
            WHEN (l.dataelementid = 286850876) THEN l.val
            ELSE NULL::character varying
        END)::text) AS diamond_ranking,
   max((
        CASE
            WHEN (l.dataelementid = 286850991) THEN l.val
            ELSE NULL::character varying
        END)::text) AS decision_making_grid,
   max((
        CASE
            WHEN (l.dataelementid = 286851223) THEN l.val
            ELSE NULL::character varying
        END)::text) AS what_if,
   max((
        CASE
            WHEN (l.dataelementid = 286851292) THEN l.val
            ELSE NULL::character varying
        END)::text) AS create_an_action_plan,

   max((
        CASE
            WHEN (l.dataelementid = 286851426) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sample_business_plan_for_a_financial_enterprise,
   max((
        CASE
            WHEN (l.dataelementid = 286851580) THEN l.val
            ELSE NULL::character varying
        END)::text) AS organise_a_shareity_exercise,
   max((
        CASE
            WHEN (l.dataelementid = 286851626) THEN l.val
            ELSE NULL::character varying
        END)::text) AS create_a_savings_book,
   max((
        CASE
            WHEN (l.dataelementid = 286851740) THEN l.val
            ELSE NULL::character varying
        END)::text) AS organise_a_fundraising_campaign,
   max((
        CASE
            WHEN (l.dataelementid = 286851774) THEN l.val
            ELSE NULL::character varying
        END)::text) AS organise_a_poster_campaign,
   max((
        CASE
            WHEN (l.dataelementid = 286851797) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ideas_for_environment_campaigns,
   max((
        CASE
            WHEN (l.dataelementid = 286851847) THEN l.val
            ELSE NULL::character varying
        END)::text) AS invite_a_guest_speaker,


    max((
        CASE
            WHEN (l.dataelementid = 286854245) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_aflatoun_flag,
    max((
        CASE
            WHEN (l.dataelementid = 286860728) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_afla_passport,
    max((
        CASE
            WHEN (l.dataelementid = 286860928) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_aflatoun_mosaic,
    max((
        CASE
            WHEN (l.dataelementid = 286861133) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_aflatoun_club_badges,
    max((
        CASE
            WHEN (l.dataelementid = 286861196) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_aflatoun_identity_cards,
    max((
        CASE
            WHEN (l.dataelementid = 286861342) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_aflatoun_pledge,
    max((
        CASE
            WHEN (l.dataelementid = 286861391) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_musa_aflatoun_box,
    max((
        CASE
            WHEN (l.dataelementid = 286861681) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_daniel_makes_a_mistake,
    max((
        CASE
            WHEN (l.dataelementid = 286861856) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_origins_of_money,

    max((
        CASE
            WHEN (l.dataelementid = 286861986) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_effective_thinker,
    max((
        CASE
            WHEN (l.dataelementid = 286862126) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_thats_my_goal,
   max((
        CASE
            WHEN (l.dataelementid = 286862260) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_creating_our_dream_board,
   max((
        CASE
            WHEN (l.dataelementid = 286862552) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_a_letter_to_myself,
   max((
        CASE
            WHEN (l.dataelementid = 286862611) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_opening_your_letter,
   max((
        CASE
            WHEN (l.dataelementid = 286862809) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_smiley_face_reflections,
   max((
        CASE
            WHEN (l.dataelementid = 286862917) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_target_reflections,
   max((
        CASE
            WHEN (l.dataelementid = 286863122) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_six_word_reflections,

   max((
        CASE
            WHEN (l.dataelementid = 286863343) THEN l.val 
            ELSE NULL::character varying
        END)::text) AS date_of_school_year_poster,
   max((
        CASE
            WHEN (l.dataelementid = 286863664) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_balancing_branches,
    max((
        CASE
            WHEN (l.dataelementid = 286863952) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_how_long_is_piece_of_string,
    max((
        CASE
            WHEN (l.dataelementid = 286864192) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_who_can_help_me,
   max((
        CASE
            WHEN (l.dataelementid = 286864226) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_mind_mapping,
   max((
        CASE
            WHEN (l.dataelementid = 286864338) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_how_to_brainstorm,
   max((
        CASE
            WHEN (l.dataelementid = 286864443) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_diamond_ranking,
   max((
        CASE
            WHEN (l.dataelementid = 286864624) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_decision_making_grid,
   max((
        CASE
            WHEN (l.dataelementid = 286864655) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_what_if,
   max((
        CASE
            WHEN (l.dataelementid = 286864838) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_create_an_action_plan,
 
   max((
        CASE
            WHEN (l.dataelementid = 286864866) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_sample_business_plan_for_a_financial_enterprise,
   max((
        CASE
            WHEN (l.dataelementid = 286864930) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_organise_a_shareity_exercise,
   max((
        CASE
            WHEN (l.dataelementid = 286865041) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_create_a_savings_book,
   max((
        CASE
            WHEN (l.dataelementid = 286865188) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_organise_a_fundraising_campaign,
   max((
        CASE
            WHEN (l.dataelementid = 286865472) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_organise_a_poster_campaign,

   max((
        CASE
            WHEN (l.dataelementid = 286865534) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_ideas_for_environment_campaigns,
   max((
        CASE
            WHEN (l.dataelementid = 286865617) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_of_invite_a_guest_speaker,

    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 28731586) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_aflatounn_w OWNER TO postgres;

--
-- Name: stage_cash_transfer_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_cash_transfer_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1752) THEN l.val
            ELSE NULL::character varying
        END)::text) AS cash_transfer,
    max((
        CASE
            WHEN (l.dataelementid = 2569) THEN l.val
            ELSE NULL::character varying
        END)::text) AS transfer_date,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1910) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_cash_transfer_w_current_year OWNER TO postgres;

--
-- Name: stage_condom_provision_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_condom_provision_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1741) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received,
    max(
        CASE
            WHEN (l.dataelementid = 1686) THEN (l.val)::integer
            ELSE NULL::integer
        END) AS no_condoms,
    max((
        CASE
            WHEN (l.dataelementid = 1736) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dpoint,
    max((
        CASE
            WHEN (l.dataelementid = 1734) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dname,
    max((
        CASE
            WHEN (l.dataelementid = 1761) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dcontact,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1915) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_condom_provision_w_current_year OWNER TO postgres;

--
-- Name: stage_contraceptive_mix_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_contraceptive_mix_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1774) THEN l.val
            ELSE NULL::character varying
        END)::text) AS anc,
    max((
        CASE
            WHEN (l.dataelementid = 1781) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pnc,
    max((
        CASE
            WHEN (l.dataelementid = 1745) THEN l.val
            ELSE NULL::character varying
        END)::text) AS contraceptive_services,
    max((
        CASE
            WHEN (l.dataelementid = 1772) THEN l.val
            ELSE NULL::character varying
        END)::text) AS injectables,
    max((
        CASE
            WHEN (l.dataelementid = 1746) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dinjectables,
    max((
        CASE
            WHEN (l.dataelementid = 1773) THEN l.val
            ELSE NULL::character varying
        END)::text) AS implants,
    max((
        CASE
            WHEN (l.dataelementid = 2556) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dimplants,
    max((
        CASE
            WHEN (l.dataelementid = 1775) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iuds,
    max((
        CASE
            WHEN (l.dataelementid = 2557) THEN l.val
            ELSE NULL::character varying
        END)::text) AS diuds,
    max((
        CASE
            WHEN (l.dataelementid = 1776) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pills,
    max((
        CASE
            WHEN (l.dataelementid = 2558) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dpills,
    max((
        CASE
            WHEN (l.dataelementid = 1780) THEN l.val
            ELSE NULL::character varying
        END)::text) AS monthly_beads,
    max((
        CASE
            WHEN (l.dataelementid = 2559) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dmonthlybeads,
    max((
        CASE
            WHEN (l.dataelementid = 1816) THEN l.val
            ELSE NULL::character varying
        END)::text) AS tubligations,
    max((
        CASE
            WHEN (l.dataelementid = 2560) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dtubligations,
    max((
        CASE
            WHEN (l.dataelementid = 1769) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other,
    max((
        CASE
            WHEN (l.dataelementid = 1770) THEN l.val
            ELSE NULL::character varying
        END)::text) AS specify,
    max((
        CASE
            WHEN (l.dataelementid = 2561) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dother,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1914) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_contraceptive_mix_w_current_year OWNER TO postgres;

--
-- Name: stage_dreams_exit_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_dreams_exit_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 22396166) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_for_exiting_dreams,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445464) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_dreams_exit_current_year OWNER TO postgres;

--
-- Name: stage_dreams_ic_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_dreams_ic_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 19443779) THEN l.val
            ELSE NULL::character varying
        END)::text) AS life_skills_training_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443797) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_life_skills_training_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS menstrual_hygiene_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443813) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_menstrual_hygiene_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443832) THEN l.val
            ELSE NULL::character varying
        END)::text) AS mentorship_received,
    max((
        CASE
            WHEN (l.dataelementid = 19443873) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_mentorship_received,
    max((
        CASE
            WHEN (l.dataelementid = 19444111) THEN l.val
            ELSE NULL::character varying
        END)::text) AS returned_to_school,
    max((
        CASE
            WHEN (l.dataelementid = 19444135) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_returned_to_school,
    max((
        CASE
            WHEN (l.dataelementid = 19444253) THEN l.val
            ELSE NULL::character varying
        END)::text) AS interschool_competition,
    max((
        CASE
            WHEN (l.dataelementid = 19444348) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_interschool_competition,
    max((
        CASE
            WHEN (l.dataelementid = 19444557) THEN l.val
            ELSE NULL::character varying
        END)::text) AS train_on_gbv_prevention,
    max((
        CASE
            WHEN (l.dataelementid = 19444575) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_train_on_gbv_prevention,
    max((
        CASE
            WHEN (l.dataelementid = 19444627) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_prevention_information,
    max((
        CASE
            WHEN (l.dataelementid = 19444802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_prevention_information_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444821) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring,
    max((
        CASE
            WHEN (l.dataelementid = 19444840) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444885) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_monitoring_date2,
    max((
        CASE
            WHEN (l.dataelementid = 19444886) THEN l.val
            ELSE NULL::character varying
        END)::text) AS radio_production_skills,
    max((
        CASE
            WHEN (l.dataelementid = 19444914) THEN l.val
            ELSE NULL::character varying
        END)::text) AS radio_production_skills_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444922) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economic_skills_training,
    max((
        CASE
            WHEN (l.dataelementid = 19444923) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economic_skills_training_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444924) THEN l.val
            ELSE NULL::character varying
        END)::text) AS market_training,
    max((
        CASE
            WHEN (l.dataelementid = 19444936) THEN l.val
            ELSE NULL::character varying
        END)::text) AS market_training_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444944) THEN l.val
            ELSE NULL::character varying
        END)::text) AS che_mentorship,
    max((
        CASE
            WHEN (l.dataelementid = 19444964) THEN l.val
            ELSE NULL::character varying
        END)::text) AS che_mentorship_date,
    max((
        CASE
            WHEN (l.dataelementid = 19444996) THEN l.val
            ELSE NULL::character varying
        END)::text) AS followup_meetings_attended,
    max((
        CASE
            WHEN (l.dataelementid = 19445000) THEN l.val
            ELSE NULL::character varying
        END)::text) AS followup_meetings_attended_date,
    max((
        CASE
            WHEN (l.dataelementid = 19445023) THEN l.val
            ELSE NULL::character varying
        END)::text) AS started_business,
    max((
        CASE
            WHEN (l.dataelementid = 19445024) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_started_business,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445397) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_dreams_ic_current_year OWNER TO postgres;

--
-- Name: stage_economic_services_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_economic_services_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1748) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sdate,
    max((
        CASE
            WHEN (l.dataelementid = 1786) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_training,
    max((
        CASE
            WHEN (l.dataelementid = 5525) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fl_date,
    max((
        CASE
            WHEN (l.dataelementid = 1794) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_training,
    max((
        CASE
            WHEN (l.dataelementid = 5526) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vs_date,
    max((
        CASE
            WHEN (l.dataelementid = 1795) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_support,
    max((
        CASE
            WHEN (l.dataelementid = 5527) THEN l.val
            ELSE NULL::character varying
        END)::text) AS iga_date,
    max((
        CASE
            WHEN (l.dataelementid = 1796) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_silc,
    max((
        CASE
            WHEN (l.dataelementid = 5528) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vsla_silc_date,
    max((
        CASE
            WHEN (l.dataelementid = 28357003) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ses_services,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1917) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_economic_services_w_current_year OWNER TO postgres;

--
-- Name: stage_educ_subsidy_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_educ_subsidy_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1755) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received,
    max((
        CASE
            WHEN (l.dataelementid = 2570) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_recieved,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1913) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_educ_subsidy_w_current_year OWNER TO postgres;

--
-- Name: stage_hts_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_hts_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 1721) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hts_result,
    max((
        CASE
            WHEN (l.dataelementid = 2286) THEN l.val
            ELSE NULL::character varying
        END)::text) AS linked_to_care,
    max((
        CASE
            WHEN (l.dataelementid = 35249726) THEN l.val
            ELSE NULL::character varying
        END)::text) AS screened_for_hts,
    max((
        CASE
            WHEN (l.dataelementid = 35253499) THEN l.val
            ELSE NULL::character varying
        END)::text) AS tested_for_hiv,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1911) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_hts_w_current_year OWNER TO postgres;

--
-- Name: stage_no_means_no_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_no_means_no_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 136960885) THEN l.val
            ELSE NULL::character varying
        END)::text) AS intervention_type,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 136962058) THEN l.val
            ELSE NULL::character varying
        END)::text) AS nmn_start_date,
    max((
        CASE
            WHEN (l.dataelementid = 136962108) THEN l.val
            ELSE NULL::character varying
        END)::text) AS nmn_end_date,
    max((
        CASE
            WHEN (l.dataelementid = 136966502) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_disclosure,
    max((
        CASE
            WHEN (l.dataelementid = 136960925) THEN l.val
            ELSE NULL::character varying
        END)::text) AS delivery_method,
    max((
        CASE
            WHEN (l.dataelementid = 136962255) THEN l.val
            ELSE NULL::character varying
        END)::text) AS supervisor,
    max((
        CASE
            WHEN (l.dataelementid = 136961389) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class1,
    max((
        CASE
            WHEN (l.dataelementid = 136961431) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class2,
    max((
        CASE
            WHEN (l.dataelementid = 136961452) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class3,
    max((
        CASE
            WHEN (l.dataelementid = 136961494) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class4,
    max((
        CASE
            WHEN (l.dataelementid = 136961526) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class5,
    max((
        CASE
            WHEN (l.dataelementid = 136961549) THEN l.val
            ELSE NULL::character varying
        END)::text) AS class6,
    max((
        CASE
            WHEN (l.dataelementid = 136961616) THEN l.val
            ELSE NULL::character varying
        END)::text) AS additional_classes,
    max((
        CASE
            WHEN (l.dataelementid = 136976125) THEN l.val
            ELSE NULL::character varying
        END)::text) AS nmn_comments,
    max((
        CASE
            WHEN (l.dataelementid = 136961761) THEN l.val
            ELSE NULL::character varying
        END)::text) AS nmn_graduated,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 136988585) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_no_means_no_w OWNER TO postgres;

--
-- Name: eses_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_eses_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 303278136) THEN l.val
            ELSE NULL::character varying
        END)::text) AS experience_violence,
    max((
        CASE
            WHEN (l.dataelementid = 303278243) THEN l.val
            ELSE NULL::character varying
        END)::text) AS alcohol_abuse,
    max((
        CASE
            WHEN (l.dataelementid = 303279589) THEN l.val
            ELSE NULL::character varying
        END)::text) AS multiple_sexual_partners,
    max((
        CASE
            WHEN (l.dataelementid = 303279927) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sti_symptoms,
    max((
        CASE
            WHEN (l.dataelementid = 303279567) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sexually_active_less_than_18years,
    max((
        CASE
            WHEN (l.dataelementid = 303280010) THEN l.val
            ELSE NULL::character varying
        END)::text) AS transactional_sex,
    max((
        CASE
            WHEN (l.dataelementid = 303279674) THEN l.val
            ELSE NULL::character varying
        END)::text) AS irregular_condom_use,
    max((
        CASE
            WHEN (l.dataelementid = 303276242) THEN l.val
            ELSE NULL::character varying
        END)::text) AS started_receiving_the_service_for_risk_assessed_for,
    max((
        CASE
            WHEN (l.dataelementid = 270702191) THEN l.val
            ELSE NULL::character varying
        END)::text) AS did_the_beneficiary_complete_the_financial_literacy_activity,
    max((
        CASE
            WHEN (l.dataelementid = 270703164) THEN l.val
            ELSE NULL::character varying
        END)::text) AS rural_business_more_than_50000_profit_and_100000_for_urban_area,     
    max((
        CASE
            WHEN (l.dataelementid = 270703807) THEN l.val
            ELSE NULL::character varying
        END)::text) AS rural_employment_with_profit_50000_and_100000_for_urban,
    max((
        CASE
            WHEN (l.dataelementid = 270703250) THEN l.val
            ELSE NULL::character varying
        END)::text) AS enrollment_in_a_government_iga_program,
    max((
        CASE
            WHEN (l.dataelementid = 270703384) THEN l.val
            ELSE NULL::character varying
        END)::text) AS membership_in_a_savings_group,   
    max((
        CASE
            WHEN (l.dataelementid = 270703933) THEN l.val
            ELSE NULL::character varying
        END)::text) AS agyw_as_source_of_income_or_support_from_a_trusted_adult,    
    max((
        CASE
            WHEN (l.dataelementid = 270704326) THEN l.val
            ELSE NULL::character varying
        END)::text) AS whole_day_and_night_without_a_meal_due_to_lack_of_food,    
    max((
        CASE
            WHEN (l.dataelementid = 276564072) THEN l.val
            ELSE NULL::character varying
        END)::text) AS whole_day_not_able_to_feed_your_children,   
    max((
        CASE
            WHEN (l.dataelementid = 270704432) THEN l.val
            ELSE NULL::character varying
        END)::text) AS agyw_household_is_enrolled_on_the_ovc_platform,  
    max((
        CASE
            WHEN (l.dataelementid = 276569135) THEN l.val
            ELSE NULL::character varying
        END)::text) AS household_head_and_between_16_19_years_of_age, 
    max((
        CASE
            WHEN (l.dataelementid = 270705366) THEN l.val
            ELSE NULL::character varying
        END)::text) AS total_score,     
    max((
        CASE
            WHEN (l.dataelementid = 270705569) THEN l.val
            ELSE NULL::character varying
        END)::text) AS enrolled_for_eses,       
    max((
        CASE
            WHEN (l.dataelementid = 276569469) THEN l.val
            ELSE NULL::character varying
        END)::text) AS name_of_interviewer
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 270112016) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_eses_w OWNER TO postgres;

--
-- Name: stage_partner_services_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_partner_services_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1722) THEN l.val
            ELSE NULL::character varying
        END)::text) AS fname,
    max((
        CASE
            WHEN (l.dataelementid = 1723) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lname,
    max((
        CASE
            WHEN (l.dataelementid = 1724) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_type,
    max((
        CASE
            WHEN (l.dataelementid = 1725) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hiv_status,
    max((
        CASE
            WHEN (l.dataelementid = 1756) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vmmc_status,
    max((
        CASE
            WHEN (l.dataelementid = 1726) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_contact,
    max((
        CASE
            WHEN (l.dataelementid = 1727) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_address,
    max((
        CASE
            WHEN (l.dataelementid = 1728) THEN l.val
            ELSE NULL::character varying
        END)::text) AS partner_traced,
    max((
        CASE
            WHEN (l.dataelementid = 1779) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sero_status,
    max((
        CASE
            WHEN (l.dataelementid = 1759) THEN l.val
            ELSE NULL::character varying
        END)::text) AS htc,
    max((
        CASE
            WHEN (l.dataelementid = 1758) THEN l.val
            ELSE NULL::character varying
        END)::text) AS vmmc,
    max((
        CASE
            WHEN (l.dataelementid = 1757) THEN l.val
            ELSE NULL::character varying
        END)::text) AS condoms,
    max((
        CASE
            WHEN (l.dataelementid = 1760) THEN l.val
            ELSE NULL::character varying
        END)::text) AS art,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1906) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_partner_services_w_current_year OWNER TO postgres;

--
-- Name: stage_prep_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_prep_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    max((
        CASE
            WHEN (l.dataelementid = 19443584) THEN l.val
            ELSE NULL::character varying
        END)::text) AS received_prep,
    max((
        CASE
            WHEN (l.dataelementid = 19443653) THEN l.val
            ELSE NULL::character varying
        END)::text) AS date_received_prep,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 19445321) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_prep_current_year OWNER TO postgres;

--
-- Name: stage_stage_mental_health_and_psychosocial_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_mental_health_and_psychosocial_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 279076654) THEN l.val
            ELSE NULL::character varying
        END)::text) AS little_interest_or_pleasure_in_doing_things,
    max((
        CASE
            WHEN (l.dataelementid = 279074219) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feeling_down_epressed_or_hopeless,
    max((
        CASE
            WHEN (l.dataelementid = 279074322) THEN l.val
            ELSE NULL::character varying
        END)::text) AS trouble_falling_asleep_or_sleeping_too_much,
    max((
        CASE
            WHEN (l.dataelementid = 279074057) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pleasurable_activities,

            max((
        CASE
            WHEN (l.dataelementid = 279077068) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feeling_down_depressed_or_hopeless,
                    max((
        CASE
            WHEN (l.dataelementid = 279077254) THEN l.val
            ELSE NULL::character varying
        END)::text) AS copy_trouble_falling_asleep_or_sleeping_too_much,
                    max((
        CASE
            WHEN (l.dataelementid = 279077891) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feeling_tired_or_having_little_energy,
                max((
        CASE
            WHEN (l.dataelementid = 279078165) THEN l.val
            ELSE NULL::character varying
        END)::text) AS poor_appetite_or_over_eating,
                    max((
        CASE
            WHEN (l.dataelementid = 279079253) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feeling_bad_about_yourself,
                    max((
        CASE
            WHEN (l.dataelementid = 279080246) THEN l.val
            ELSE NULL::character varying
        END)::text) AS trouble_concentrating_on_things,
                    max((
        CASE
            WHEN (l.dataelementid = 279082031) THEN l.val
            ELSE NULL::character varying
        END)::text) AS moving_or_speaking_so_slowly,
                    max((
        CASE
            WHEN (l.dataelementid = 279082588) THEN l.val
            ELSE NULL::character varying
        END)::text) AS thoughts_that_you_would_be_better_off_dead,
                    max((
        CASE
            WHEN (l.dataelementid = 279089622) THEN l.val
            ELSE NULL::character varying
        END)::text) AS provisional_diagnosis_and_proposed_treatment_actions,
                        max((
        CASE
            WHEN (l.dataelementid = 279074480) THEN l.val
            ELSE NULL::character varying
        END)::text) AS action_taken,
                                        max((
        CASE
            WHEN (l.dataelementid = 279151695) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other_action_specify,
                
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 279099735) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_mental_health_and_psychosocial_w OWNER TO postgres;


--
-- Name: stage_mental_health_and_alcohol_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_mental_health_and_alcohol_w AS
SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 286882956) THEN l.val
            ELSE NULL::character varying
        END)::text) AS often_have_headaches,
    max((
        CASE
            WHEN (l.dataelementid = 286883121) THEN l.val
            ELSE NULL::character varying
        END)::text) AS appetite_poor,
    max((
        CASE
            WHEN (l.dataelementid = 286883437) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sleep_badly,
    max((
        CASE
            WHEN (l.dataelementid = 286883563) THEN l.val
            ELSE NULL::character varying
        END)::text) AS easily_frightened,
    max((
        CASE
            WHEN (l.dataelementid = 286883698) THEN l.val
            ELSE NULL::character varying
        END)::text) AS hands_shake,
            max((
        CASE
            WHEN (l.dataelementid = 286884557) THEN l.val
            ELSE NULL::character varying
        END)::text) AS nervous_tense_or_worried,
                    max((
        CASE
            WHEN (l.dataelementid = 286886804) THEN l.val
            ELSE NULL::character varying
        END)::text) AS often_experience_constipation,
                    max((
        CASE
            WHEN (l.dataelementid = 286889472) THEN l.val
            ELSE NULL::character varying
        END)::text) AS difficulties_with_your_thinking,
                max((
        CASE
            WHEN (l.dataelementid = 286889773) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feel_unhappy,
                    max((
        CASE
            WHEN (l.dataelementid = 286889971) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feeling_of_wanting_to_cry_but_you_cannot,
                    max((
        CASE
            WHEN (l.dataelementid = 286890246) THEN l.val
            ELSE NULL::character varying
        END)::text) AS difficult_to_enjoy_your_daily_activities,
                    max((
        CASE
            WHEN (l.dataelementid = 286890646) THEN l.val
            ELSE NULL::character varying
        END)::text) AS difficulty_in_deciding_on_what_activities_you_will_perform,
                    max((
        CASE
            WHEN (l.dataelementid = 286890832) THEN l.val
            ELSE NULL::character varying
        END)::text) AS have_trouble_completing_your_daily_tasks,
                    max((
        CASE
            WHEN (l.dataelementid = 286891207) THEN l.val
            ELSE NULL::character varying
        END)::text) AS unable_to_play_a_useful_role_in_life,
                    max((
        CASE
            WHEN (l.dataelementid = 286891563) THEN l.val
            ELSE NULL::character varying
        END)::text) AS lost_interest_in_things,
                max((
                CASE
            WHEN (l.dataelementid = 286891882) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feel_that_you_are_a_worthless_person,
                max((
                CASE
            WHEN (l.dataelementid = 286892227) THEN l.val
            ELSE NULL::character varying
        END)::text) AS thought_of_ending_your_life_been_on_your_mind,
                max((
                CASE
            WHEN (l.dataelementid = 286893058) THEN l.val
            ELSE NULL::character varying
        END)::text) AS feel_tired_all_the_time,
                max((
                CASE
            WHEN (l.dataelementid = 286893381) THEN l.val
            ELSE NULL::character varying
        END)::text) AS have_uncomfortable_feelings_in_your_stomach,
                max((
                CASE
            WHEN (l.dataelementid = 286893556) THEN l.val
            ELSE NULL::character varying
        END)::text) AS are_you_easily_tired,
                max((
                CASE
            WHEN (l.dataelementid = 286897493) THEN l.val
            ELSE NULL::character varying
        END)::text) AS Total_Score_Anxiety_and_Depression_assessment,
                max((
                CASE
            WHEN (l.dataelementid = 286901307) THEN l.val
            ELSE NULL::character varying
        END)::text) AS often_have_taken_a_drink_containing_alcohol_or_any_substance,
                max((
                                CASE
            WHEN (l.dataelementid = 286901631) THEN l.val
            ELSE NULL::character varying
        END)::text) AS how_many_drinks_containing_alcohol_do_you_have_on_a_typical_day,
                max((
                                CASE
            WHEN (l.dataelementid = 286902004) THEN l.val
            ELSE NULL::character varying
        END)::text) AS how_often_do_you_have_six_or_more_drinks_on_one_occasion,
                max((
                                CASE
            WHEN (l.dataelementid = 286902297) THEN l.val
            ELSE NULL::character varying
        END)::text) AS total_Score_Alcohol_use_assessment,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 286912048) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_mental_health_and_alcohol_w OWNER TO postgres;

--
-- Name: stage_pvc_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_pvc_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1787) THEN l.val
            ELSE NULL::character varying
        END)::text) AS economical,
    max((
        CASE
            WHEN (l.dataelementid = 1782) THEN l.val
            ELSE NULL::character varying
        END)::text) AS physical,
    max((
        CASE
            WHEN (l.dataelementid = 1788) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sexual,
    max((
        CASE
            WHEN (l.dataelementid = 1783) THEN l.val
            ELSE NULL::character varying
        END)::text) AS psychosocial,
    max((
        CASE
            WHEN (l.dataelementid = 1778) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sti,
    max((
        CASE
            WHEN (l.dataelementid = 1791) THEN l.val
            ELSE NULL::character varying
        END)::text) AS stepping_stones,
    max((
        CASE
            WHEN (l.dataelementid = 1793) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sasa,
    max((
        CASE
            WHEN (l.dataelementid = 1784) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sinovuyo,
    max((
        CASE
            WHEN (l.dataelementid = 1789) THEN l.val
            ELSE NULL::character varying
        END)::text) AS contraceptive_mix,
    max((
        CASE
            WHEN (l.dataelementid = 1777) THEN l.val
            ELSE NULL::character varying
        END)::text) AS cash_transfer,
    max((
        CASE
            WHEN (l.dataelementid = 1790) THEN l.val
            ELSE NULL::character varying
        END)::text) AS condom_provision,
    max((
        CASE
            WHEN (l.dataelementid = 1785) THEN l.val
            ELSE NULL::character varying
        END)::text) AS education_subsidy,
    max((
        CASE
            WHEN (l.dataelementid = 1792) THEN l.val
            ELSE NULL::character varying
        END)::text) AS combined_social_economic,
    max((
        CASE
            WHEN (l.dataelementid = 1817) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pep,
    max((
        CASE
            WHEN (l.dataelementid = 1818) THEN l.val
            ELSE NULL::character varying
        END)::text) AS linked_police,
    max((
        CASE
            WHEN (l.dataelementid = 1819) THEN l.val
            ELSE NULL::character varying
        END)::text) AS psychosocial_support,
    max((
        CASE
            WHEN (l.dataelementid = 1820) THEN l.val
            ELSE NULL::character varying
        END)::text) AS emergency_contraception,
    max((
        CASE
            WHEN (l.dataelementid = 1759) THEN l.val
            ELSE NULL::character varying
        END)::text) AS htc,
    max((
        CASE
            WHEN (l.dataelementid = 1740) THEN l.val
            ELSE NULL::character varying
        END)::text) AS refered_from,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1916) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_pvc_w_current_year OWNER TO postgres;

--
-- Name: stage_sasa_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sasa_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1763) THEN l.val
            ELSE NULL::character varying
        END)::text) AS attended_sasa,
    max((
        CASE
            WHEN (l.dataelementid = 1771) THEN l.val
            ELSE NULL::character varying
        END)::text) AS relative_partner_attended,
    max((
        CASE
            WHEN (l.dataelementid = 1768) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dialogue,
    max((
        CASE
            WHEN (l.dataelementid = 1764) THEN l.val
            ELSE NULL::character varying
        END)::text) AS drama,
    max((
        CASE
            WHEN (l.dataelementid = 1765) THEN l.val
            ELSE NULL::character varying
        END)::text) AS days_activism,
    max((
        CASE
            WHEN (l.dataelementid = 1766) THEN l.val
            ELSE NULL::character varying
        END)::text) AS press_conference,
    max((
        CASE
            WHEN (l.dataelementid = 1767) THEN l.val
            ELSE NULL::character varying
        END)::text) AS films_screening,
    max((
        CASE
            WHEN (l.dataelementid = 1769) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other,
    max((
        CASE
            WHEN (l.dataelementid = 1770) THEN l.val
            ELSE NULL::character varying
        END)::text) AS specify,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1912) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sasa_w_current_year OWNER TO postgres;

--
-- Name: stage_sbhvp_w2; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sbhvp_w2 AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1762) THEN l.val
            ELSE NULL::character varying
        END)::text) AS enrolled,
    max((
        CASE
            WHEN (l.dataelementid = 32806025) THEN l.val
            ELSE NULL::character varying
        END)::text) AS name_of_school,
    l.program_status,
    max((
        CASE
            WHEN (l.dataelementid = 33394464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sbhvp_service,
    max((
        CASE
            WHEN (l.dataelementid = 23918482) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_sessions,
    max((
        CASE
            WHEN (l.dataelementid = 147835449) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835473) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835479) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835480) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835484) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835558) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835586) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835657) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835627) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835688) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835675) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835718) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835762) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835751) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835829) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835800) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835888) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_10_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835875) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_10_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835960) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147835954) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836007) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836005) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836084) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836034) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836097) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836096) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836114) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147836111) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_date_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 147838002) THEN l.val
            ELSE NULL::character varying
        END)::text) AS old_curriculum_activity_16_and_above_attended,
    max((
        CASE
            WHEN (l.dataelementid = 135017978) THEN l.val
            ELSE NULL::character varying
        END)::text) AS journeys_or_sbhvp_completed,
    max((
        CASE
            WHEN (l.dataelementid = 162620576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS peer_group_name,
    max((
        CASE
            WHEN (l.dataelementid = 162620757) THEN l.val
            ELSE NULL::character varying
        END)::text) AS facilitator_name,
    max((
        CASE
            WHEN (l.dataelementid = 162934825) THEN l.val
            ELSE NULL::character varying
        END)::text) AS curriculum,
    max((
        CASE
            WHEN (l.dataelementid = 162924153) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_1_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162926839) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_1_date,
    max((
        CASE
            WHEN (l.dataelementid = 162930643) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_2_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162930764) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_2_date,
    max((
        CASE
            WHEN (l.dataelementid = 162931416) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_3_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162933945) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_3_date,
    max((
        CASE
            WHEN (l.dataelementid = 162934415) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_4_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162934737) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_4_date,
    max((
        CASE
            WHEN (l.dataelementid = 162936096) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_5_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162936390) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_5_date,
    max((
        CASE
            WHEN (l.dataelementid = 162938109) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_6_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162938445) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_6_date,
    max((
        CASE
            WHEN (l.dataelementid = 162939186) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_7_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162939376) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_7_date,
    max((
        CASE
            WHEN (l.dataelementid = 162940063) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_8_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162940273) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_8_date,
    max((
        CASE
            WHEN (l.dataelementid = 162941536) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_9_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162941879) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_9_date,
    max((
        CASE
            WHEN (l.dataelementid = 162942189) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10a_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162942417) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10a_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943088) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10b_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162949195) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_10b_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943376) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_11_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162949922) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_11_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943739) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_12_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162951194) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_12_date,
    max((
        CASE
            WHEN (l.dataelementid = 162943913) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_13_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162944088) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_13_date,
    max((
        CASE
            WHEN (l.dataelementid = 162944389) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_14_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162944702) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_14_date,
    max((
        CASE
            WHEN (l.dataelementid = 162617746) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_15_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162617694) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_15_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618048) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_16_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162617928) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_16_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618209) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_17_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618139) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_17_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618320) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_18_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618293) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_18_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618426) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_19_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618401) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_19_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618551) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_20_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618533) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_20_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618677) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_21_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162618612) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_21_date,
    max((
        CASE
            WHEN (l.dataelementid = 162618978) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_22_attended,
    max((
        CASE
            WHEN (l.dataelementid = 162619030) THEN l.val
            ELSE NULL::character varying
        END)::text) AS new_curriculum_activity_22_date
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1908) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sbhvp_w2 OWNER TO postgres;

--
-- Name: stage_sbhvp_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sbhvp_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1762) THEN l.val
            ELSE NULL::character varying
        END)::text) AS enrolled,
    max((
        CASE
            WHEN (l.dataelementid = 32806025) THEN l.val
            ELSE NULL::character varying
        END)::text) AS name_of_school,
    l.program_status,
    max((
        CASE
            WHEN (l.dataelementid = 33394464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sbhvp_service
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1908) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sbhvp_w_current_year OWNER TO postgres;

--
-- Name: stage_screening_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_screening_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate AS screeningdate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS service_provider,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1907) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_screening_current_year OWNER TO postgres;

--
-- Name: stage_screening_for_eligibility_w; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_screening_for_eligibility_w AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 94586731) THEN l.val
            ELSE NULL::character varying
        END)::text) AS screening_ip,
    max((
        CASE
            WHEN (l.dataelementid = 94517522) THEN l.val
            ELSE NULL::character varying
        END)::text) AS screening_site,
    max((
        CASE
            WHEN (l.dataelementid = 94517576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS name_of_agyw,
    max((
        CASE
            WHEN (l.dataelementid = 94517678) THEN l.val
            ELSE NULL::character varying
        END)::text) AS preferred_name,
    max((
        CASE
            WHEN (l.dataelementid = 94517709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS phone_number,
    max((
        CASE
            WHEN (l.dataelementid = 94517758) THEN l.val
            ELSE NULL::character varying
        END)::text) AS agyw_age,
    max((
        CASE
            WHEN (l.dataelementid = 94517853) THEN l.val
            ELSE NULL::character varying
        END)::text) AS parish,
    max((
        CASE
            WHEN (l.dataelementid = 94517944) THEN l.val
            ELSE NULL::character varying
        END)::text) AS village,
    max((
        CASE
            WHEN (l.dataelementid = 94517961) THEN l.val
            ELSE NULL::character varying
        END)::text) AS zone,
    max((
        CASE
            WHEN (l.dataelementid = 94518014) THEN l.val
            ELSE NULL::character varying
        END)::text) AS next_of_kin,
    max((
        CASE
            WHEN (l.dataelementid = 94518100) THEN l.val
            ELSE NULL::character varying
        END)::text) AS next_of_kin_phone_contact,
    max((
        CASE
            WHEN (l.dataelementid = 94518289) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_in_school,
    max((
        CASE
            WHEN (l.dataelementid = 94518441) THEN l.val
            ELSE NULL::character varying
        END)::text) AS reason_for_not_being_in_school,
    max((
        CASE
            WHEN (l.dataelementid = 94579384) THEN l.val
            ELSE NULL::character varying
        END)::text) AS days_of_school_missed,
    max((
        CASE
            WHEN (l.dataelementid = 94583370) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_working,
    max((
        CASE
            WHEN (l.dataelementid = 94583460) THEN l.val
            ELSE NULL::character varying
        END)::text) AS currently_at_home_with_children,
    max((
        CASE
            WHEN (l.dataelementid = 94579642) THEN l.val
            ELSE NULL::character varying
        END)::text) AS who_is_your_caregiver,
    max((
        CASE
            WHEN (l.dataelementid = 94579661) THEN l.val
            ELSE NULL::character varying
        END)::text) AS both_parents_living,
    max((
        CASE
            WHEN (l.dataelementid = 94579732) THEN l.val
            ELSE NULL::character varying
        END)::text) AS head_of_household_under_18,
    max((
        CASE
            WHEN (l.dataelementid = 94579889) THEN l.val
            ELSE NULL::character varying
        END)::text) AS drank_alcohol_or_used_drugs,
    max((
        CASE
            WHEN (l.dataelementid = 94582029) THEN l.val
            ELSE NULL::character varying
        END)::text) AS more_than_3_drinks_at_one_time_used_drugs,
    max((
        CASE
            WHEN (l.dataelementid = 94582131) THEN l.val
            ELSE NULL::character varying
        END)::text) AS use_of_alcohol_led_to_problems,
    max((
        CASE
            WHEN (l.dataelementid = 94580060) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ever_had_sex_including_forced_sex,
    max((
        CASE
            WHEN (l.dataelementid = 94580189) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sexually_active,
    max((
        CASE
            WHEN (l.dataelementid = 94582399) THEN l.val
            ELSE NULL::character varying
        END)::text) AS number_of_partners_last_12_months,
    max((
        CASE
            WHEN (l.dataelementid = 94582464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS used_condoms_regularly_latest_partner,
    max((
        CASE
            WHEN (l.dataelementid = 94582504) THEN l.val
            ELSE NULL::character varying
        END)::text) AS abnormal_vaginal_discharge,
    max((
        CASE
            WHEN (l.dataelementid = 94582520) THEN l.val
            ELSE NULL::character varying
        END)::text) AS genital_sores_or_wounds,
    max((
        CASE
            WHEN (l.dataelementid = 94582572) THEN l.val
            ELSE NULL::character varying
        END)::text) AS pain_during_intercourse,
    max((
        CASE
            WHEN (l.dataelementid = 94582649) THEN l.val
            ELSE NULL::character varying
        END)::text) AS any_sti_symptoms,
    max((
        CASE
            WHEN (l.dataelementid = 94582709) THEN l.val
            ELSE NULL::character varying
        END)::text) AS tested_and_screened_for_sti,
    max((
        CASE
            WHEN (l.dataelementid = 94580202) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ever_been_pregnant,
    max((
        CASE
            WHEN (l.dataelementid = 94582809) THEN l.val
            ELSE NULL::character varying
        END)::text) AS age_at_first_pregnancy,
    max((
        CASE
            WHEN (l.dataelementid = 94582952) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sex_in_exchange_for_items,
    max((
        CASE
            WHEN (l.dataelementid = 94583081) THEN l.val
            ELSE NULL::character varying
        END)::text) AS stayed_in_a_relationship_because_of_provision,
    max((
        CASE
            WHEN (l.dataelementid = 94580464) THEN l.val
            ELSE NULL::character varying
        END)::text) AS continuously_ridiculed_by_adult,
    max((
        CASE
            WHEN (l.dataelementid = 94580518) THEN l.val
            ELSE NULL::character varying
        END)::text) AS told_that_not_loved_and_didnt_deserve_love,
    max((
        CASE
            WHEN (l.dataelementid = 94580576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS adult_said_they_wish_you_were_never_born,
    max((
        CASE
            WHEN (l.dataelementid = 94580674) THEN l.val
            ELSE NULL::character varying
        END)::text) AS emotional_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94580819) THEN l.val
            ELSE NULL::character varying
        END)::text) AS punched_kicked_beat_with_object,
    max((
        CASE
            WHEN (l.dataelementid = 94580913) THEN l.val
            ELSE NULL::character varying
        END)::text) AS choked_smothered_drowned_burned_intentionally,
    max((
        CASE
            WHEN (l.dataelementid = 94580956) THEN l.val
            ELSE NULL::character varying
        END)::text) AS threatened_with_knife_gun,
    max((
        CASE
            WHEN (l.dataelementid = 94581008) THEN l.val
            ELSE NULL::character varying
        END)::text) AS physical_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94581192) THEN l.val
            ELSE NULL::character varying
        END)::text) AS touched_in_sexual_way,
    max((
        CASE
            WHEN (l.dataelementid = 94581232) THEN l.val
            ELSE NULL::character varying
        END)::text) AS made_you_have_sex_through_force,
    max((
        CASE
            WHEN (l.dataelementid = 94581310) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sexual_violence,
    max((
        CASE
            WHEN (l.dataelementid = 94581456) THEN l.val
            ELSE NULL::character varying
        END)::text) AS other_information_shared,
    max((
        CASE
            WHEN (l.dataelementid = 94581509) THEN l.val
            ELSE NULL::character varying
        END)::text) AS eligible_for_dreams,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 94584926) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])))
  GROUP BY l.programstageinstanceid, l.programinstanceid, l.program_status, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_screening_for_eligibility_w OWNER TO postgres;

--
-- Name: stage_sinovuyo_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sinovuyo_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1815) THEN l.val
            ELSE NULL::character varying
        END)::text) AS gname,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1806) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j1,
    max((
        CASE
            WHEN (l.dataelementid = 2571026) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj1,
    max((
        CASE
            WHEN (l.dataelementid = 1807) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j2,
    max((
        CASE
            WHEN (l.dataelementid = 2571045) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj2,
    max((
        CASE
            WHEN (l.dataelementid = 1808) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j3,
    max((
        CASE
            WHEN (l.dataelementid = 2571059) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj3,
    max((
        CASE
            WHEN (l.dataelementid = 1809) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s4,
    max((
        CASE
            WHEN (l.dataelementid = 2571089) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds4,
    max((
        CASE
            WHEN (l.dataelementid = 1810) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s5,
    max((
        CASE
            WHEN (l.dataelementid = 2571127) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds5,
    max((
        CASE
            WHEN (l.dataelementid = 1811) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j6,
    max((
        CASE
            WHEN (l.dataelementid = 2571159) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj6,
    max((
        CASE
            WHEN (l.dataelementid = 1812) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j7,
    max((
        CASE
            WHEN (l.dataelementid = 2571188) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj7,
    max((
        CASE
            WHEN (l.dataelementid = 1813) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s8,
    max((
        CASE
            WHEN (l.dataelementid = 2571216) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds8,
    max((
        CASE
            WHEN (l.dataelementid = 1814) THEN l.val
            ELSE NULL::character varying
        END)::text) AS s9,
    max((
        CASE
            WHEN (l.dataelementid = 2571232) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ds9,
    max((
        CASE
            WHEN (l.dataelementid = 2573) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j10,
    max((
        CASE
            WHEN (l.dataelementid = 2571257) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj10,
    max((
        CASE
            WHEN (l.dataelementid = 2574) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j11,
    max((
        CASE
            WHEN (l.dataelementid = 2571258) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj11,
    max((
        CASE
            WHEN (l.dataelementid = 2575) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j12,
    max((
        CASE
            WHEN (l.dataelementid = 2571259) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj12,
    max((
        CASE
            WHEN (l.dataelementid = 2576) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j13,
    max((
        CASE
            WHEN (l.dataelementid = 2571260) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj13,
    max((
        CASE
            WHEN (l.dataelementid = 2577) THEN l.val
            ELSE NULL::character varying
        END)::text) AS j14,
    max((
        CASE
            WHEN (l.dataelementid = 2571298) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dj14,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 2515) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sinovuyo_w_current_year OWNER TO postgres;

--
-- Name: stage_sstones_w_current_year; Type: VIEW; Schema: staging; Owner: postgres
--

CREATE VIEW staging.stage_sstones_w_current_year AS
 SELECT l.programinstanceid,
    l.programstageinstanceid,
    l.programstageid,
    l.executiondate,
    l.duedate,
    l.organisationunitid,
    ( SELECT ou.name
           FROM public.organisationunit ou
          WHERE (ou.organisationunitid = l.organisationunitid)) AS sub_county,
    l.status,
    max((
        CASE
            WHEN (l.dataelementid = 1815) THEN l.val
            ELSE NULL::character varying
        END)::text) AS gname,
    max((
        CASE
            WHEN (l.dataelementid = 1517231) THEN l.val
            ELSE NULL::character varying
        END)::text) AS ip,
    max((
        CASE
            WHEN (l.dataelementid = 1797) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sa,
    max((
        CASE
            WHEN (l.dataelementid = 2570821) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsa,
    max((
        CASE
            WHEN (l.dataelementid = 1798) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sb,
    max((
        CASE
            WHEN (l.dataelementid = 2570822) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsb,
    max((
        CASE
            WHEN (l.dataelementid = 1799) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sc,
    max((
        CASE
            WHEN (l.dataelementid = 2570837) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsc,
    max((
        CASE
            WHEN (l.dataelementid = 1800) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m1,
    max((
        CASE
            WHEN (l.dataelementid = 2570947) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm1,
    max((
        CASE
            WHEN (l.dataelementid = 1801) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sd,
    max((
        CASE
            WHEN (l.dataelementid = 2570838) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsd,
    max((
        CASE
            WHEN (l.dataelementid = 1802) THEN l.val
            ELSE NULL::character varying
        END)::text) AS se,
    max((
        CASE
            WHEN (l.dataelementid = 2570839) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dse,
    max((
        CASE
            WHEN (l.dataelementid = 1803) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sf,
    max((
        CASE
            WHEN (l.dataelementid = 2570853) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsf,
    max((
        CASE
            WHEN (l.dataelementid = 1804) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sg,
    max((
        CASE
            WHEN (l.dataelementid = 2570880) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsg,
    max((
        CASE
            WHEN (l.dataelementid = 1805) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m2,
    max((
        CASE
            WHEN (l.dataelementid = 2570962) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm2,
    max((
        CASE
            WHEN (l.dataelementid = 5517) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sh,
    max((
        CASE
            WHEN (l.dataelementid = 2570895) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsh,
    max((
        CASE
            WHEN (l.dataelementid = 5518) THEN l.val
            ELSE NULL::character varying
        END)::text) AS si,
    max((
        CASE
            WHEN (l.dataelementid = 2570912) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsi,
    max((
        CASE
            WHEN (l.dataelementid = 5519) THEN l.val
            ELSE NULL::character varying
        END)::text) AS sj,
    max((
        CASE
            WHEN (l.dataelementid = 2570931) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dsj,
    max((
        CASE
            WHEN (l.dataelementid = 5520) THEN l.val
            ELSE NULL::character varying
        END)::text) AS m3,
    max((
        CASE
            WHEN (l.dataelementid = 2570979) THEN l.val
            ELSE NULL::character varying
        END)::text) AS dm3,
    l.program_status
   FROM staging.program_stage_data_l l
  WHERE ((l.programstageid = 1909) AND (l.organisationunitid <> ALL (ARRAY[899707, 32711908, 24787679])) AND (l.executiondate >= '2019-10-10 00:00:00'::timestamp without time zone) AND (l.executiondate <= '2020-09-30 00:00:00'::timestamp without time zone))
  GROUP BY l.programstageinstanceid, l.program_status, l.programinstanceid, l.programstageid, l.executiondate, l.duedate, l.organisationunitid, l.status;


ALTER TABLE staging.stage_sstones_w_current_year OWNER TO postgres;

--
-- Data for Name: ogstructure; Type: TABLE DATA; Schema: staging; Owner: postgres
--

COPY staging.ogstructure (organisationunitid, organisationunituid, level, idlevel1, uidlevel1, idlevel2, uidlevel2, idlevel3, uidlevel3, idlevel4, uidlevel4) FROM stdin;
194	akV6429SUqu	1	194	akV6429SUqu	\N	\N	\N	\N	\N	\N
197	VA90IqaI4Ji	2	194	akV6429SUqu	197	VA90IqaI4Ji	\N	\N	\N	\N
198	adZ6T35ve4h	2	194	akV6429SUqu	198	adZ6T35ve4h	\N	\N	\N	\N
899561	ecZgt4pokn4	2	194	akV6429SUqu	899561	ecZgt4pokn4	\N	\N	\N	\N
195	pz9Uu65Irbg	2	194	akV6429SUqu	195	pz9Uu65Irbg	\N	\N	\N	\N
196	auJdpeHbeet	2	194	akV6429SUqu	196	auJdpeHbeet	\N	\N	\N	\N
227	NREoMszwQZW	3	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	\N	\N
228	QYiQ2KqgCxj	3	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	\N	\N
229	ztIyIYAzFKp	3	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	\N	\N
230	p7EEgDEX3jT	3	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	\N	\N
231	ZuQHWOaFQVM	3	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	\N	\N
232	a8RHFdF4DXL	3	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	\N	\N
233	TM6ccNxawqy	3	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	\N	\N
213	C0RSe3EWBqU	3	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	\N	\N
234	JyZJhGXKeEq	3	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	\N	\N
235	WcB3kLlgRTb	3	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	\N	\N
236	kb7iUQISRlx	3	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	\N	\N
309	AhwgeZQYj16	3	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	\N	\N
237	gUaoj8Geuao	3	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	\N	\N
209	sWoNWQZ9qrD	3	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	\N	\N
199	x75Yh65MaUa	3	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	\N	\N
276	tdZbtg9sZkO	3	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	\N	\N
280	Ame30QOwuX6	3	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	\N	\N
272	e8m9ZYMRoeR	3	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	\N	\N
283	auLatLbcOxf	3	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	\N	\N
288	CQTmrrriwOq	3	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	\N	\N
211	g8M1cWRJZV6	3	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	\N	\N
223	It5UGwdHAPF	3	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	\N	\N
226	lkuO79O6mRx	3	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	\N	\N
239	MtpE3CH6vq3	3	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	\N	\N
240	a3LMKP8z8Xj	3	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	\N	\N
241	aZLZPPjqft0	3	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	\N	\N
242	F3ccON3OCsL	3	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	\N	\N
243	wMQ25dybdgH	3	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	\N	\N
244	lQj3yMM1lI7	3	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	\N	\N
245	Gwk4wkLz7EW	3	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	\N	\N
246	PJFtfCyp6Rb	3	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	\N	\N
269	r8WLxW9JwsS	3	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	\N	\N
247	oNxpMjveyZt	3	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	\N	\N
248	UaR7OHycj8c	3	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	\N	\N
249	aJR2ZxSH7g4	3	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	\N	\N
251	eOJUW6OGpc7	3	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	\N	\N
257	zBIpPzKYFLp	3	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	\N	\N
250	m77oR1YJESj	3	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	\N	\N
252	QoRZB7xc3j9	3	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	\N	\N
253	JrHILmtK0OU	3	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	\N	\N
254	kJCEJnXLgnh	3	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	\N	\N
255	ahyi8Uq4vaj	3	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	\N	\N
262	aXmBzv61LbM	3	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	\N	\N
263	oyygQ2STBST	3	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	\N	\N
203	uCVQXAdKqL9	3	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	\N	\N
307	aphcy5JTnd6	3	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	\N	\N
204	aginheWSLef	3	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	\N	\N
205	aa8xVDzSpte	3	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	\N	\N
206	cSrCFjPKqcG	3	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	\N	\N
207	ykxQEnZGXkj	3	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	\N	\N
208	tM3DsJxMaMX	3	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	\N	\N
302	GLHh0BXys9w	3	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	\N	\N
303	Oyxwe3iDqpR	3	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	\N	\N
305	qf9xWZu7Dq8	3	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	\N	\N
304	B0G9cqixld8	3	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	\N	\N
308	aPhSZRinfbg	3	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	\N	\N
264	pnTVIF5v27r	3	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	\N	\N
266	iqsaGItA68C	3	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	\N	\N
289	Y4LV8xqkv6J	3	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	\N	\N
287	aPZzL4CyBTg	3	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	\N	\N
221	saT18HClZoz	3	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	\N	\N
267	h1O9AvNR4jS	3	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	\N	\N
268	IVuiLJYABw6	3	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	\N	\N
270	a9tQqo1rSj7	3	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	\N	\N
278	O9MoQcpZ4uA	3	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	\N	\N
281	xy0M4HhjXtD	3	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	\N	\N
271	Lj8t70RYnEt	3	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	\N	\N
214	hn1AlYtF1Pu	3	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	\N	\N
284	tr9XWtYsL5P	3	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	\N	\N
286	aqpd0Y9eXZ2	3	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	\N	\N
200	aPRNSGUR3vk	3	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	\N	\N
210	JIZDvNlIhXS	3	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	\N	\N
216	WyR8Eetj7Uw	3	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	\N	\N
219	bIONCoCnt3Q	3	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	\N	\N
224	xr8EMirOASp	3	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	\N	\N
256	mv4gKtY0qW8	3	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	\N	\N
258	yuo5ielNL7W	3	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	\N	\N
259	auswb7JO9wY	3	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	\N	\N
899614	CKgGrgTdDiW	3	194	akV6429SUqu	899561	ecZgt4pokn4	899614	CKgGrgTdDiW	\N	\N
260	FLygHiUd2UW	3	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	\N	\N
261	Q7PaNIbyZII	3	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	\N	\N
277	A9kRCvmn6Co	3	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	\N	\N
274	W0kQBddyGyh	3	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	\N	\N
275	YMMexeHFUay	3	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	\N	\N
291	lzWuB6bCQeV	3	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	\N	\N
218	a0DfYpC2Rwl	3	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	\N	\N
292	VuHCApXcMTm	3	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	\N	\N
293	aSbgVKaeCP0	3	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	\N	\N
294	aUcYGQCK9ub	3	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	\N	\N
295	Ut0ysYGEipO	3	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	\N	\N
296	esIUe2tQAtL	3	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	\N	\N
297	EDhGji3EteB	3	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	\N	\N
298	Xjc0LDFa5gW	3	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	\N	\N
299	aj4hsYK3dVm	3	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	\N	\N
300	z8D9ER36EKN	3	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	\N	\N
301	hAoe9dhZh9V	3	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	\N	\N
310	zNgVoDVPYgD	3	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	\N	\N
913191	DAfT22pPqzk	3	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	\N	\N
201	aXjub1BYn1y	3	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	\N	\N
265	xpIFdCMhVHG	3	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	\N	\N
306	aBrjuZk0W31	3	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	\N	\N
202	WiVj4bEhX4P	3	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	\N	\N
279	P8iz90eiIrW	3	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	\N	\N
238	fS71jg1WYPk	3	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	\N	\N
285	tugqr4dY6wq	3	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	\N	\N
290	j7AQsnEYmvi	3	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	\N	\N
212	zJfpujxC1kD	3	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	\N	\N
215	xAJgEKKAeRA	3	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	\N	\N
282	wJ2a6YKDFZW	3	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	\N	\N
217	srmGjHrpVE5	3	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	\N	\N
220	KhT80mlwJ3Y	3	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	\N	\N
222	aIahLLmtvgT	3	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	\N	\N
225	W1JM2Qdhcv3	3	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	\N	\N
273	A4aGXEfdb8P	3	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	\N	\N
1596	i8gkuINdorl	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1596	i8gkuINdorl
1597	xT38Pbk8s4j	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1597	xT38Pbk8s4j
1625	YjjiR3pf7GD	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1625	YjjiR3pf7GD
1585	xuuOj2eAPqb	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1585	xuuOj2eAPqb
1598	jM15KbiS4KY	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1598	jM15KbiS4KY
1599	A8Xv1XbkdrA	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1599	A8Xv1XbkdrA
1600	SVXuVZuvsit	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1600	SVXuVZuvsit
1601	XTljgoHlV32	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	1601	XTljgoHlV32
1602	vy4wRPZvp83	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1602	vy4wRPZvp83
1603	mhMXhrnEHGU	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1603	mhMXhrnEHGU
1604	NKIjT6Gi8Z3	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1604	NKIjT6Gi8Z3
1605	amLhY9BnViS	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1605	amLhY9BnViS
1606	IcEOvr6u0b6	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1606	IcEOvr6u0b6
1607	tfAnfdXJwCW	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1607	tfAnfdXJwCW
311	d9BOrS0TD0v	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	311	d9BOrS0TD0v
312	LWUX581FhMd	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	312	LWUX581FhMd
313	FihNC5KfGJV	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	313	FihNC5KfGJV
314	AABKGoyjpm2	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	314	AABKGoyjpm2
315	Lo367kZNoT7	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	315	Lo367kZNoT7
316	fSyCcycKdSl	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	316	fSyCcycKdSl
1579	fZFfFLzQrxM	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1579	fZFfFLzQrxM
332	a5Rsb7b0H2V	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	332	a5Rsb7b0H2V
317	iTWrGnwCEOJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	317	iTWrGnwCEOJ
318	oslXMLLbQdv	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	318	oslXMLLbQdv
319	OvJyCqX93Di	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	319	OvJyCqX93Di
320	lhKxF8mfub4	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	320	lhKxF8mfub4
321	msdmNNK8OGv	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	321	msdmNNK8OGv
338	NC1BI24zrtd	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	338	NC1BI24zrtd
322	pTX9sgiNkqB	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	322	pTX9sgiNkqB
323	cdnlhhlkqJ1	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	323	cdnlhhlkqJ1
324	ak3LSCYUzzc	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	324	ak3LSCYUzzc
333	FNqGR9apfAN	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	333	FNqGR9apfAN
325	eaiTceKCzoa	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	325	eaiTceKCzoa
326	vwDbo5apOm9	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	326	vwDbo5apOm9
334	MfQUi3dPpvc	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	334	MfQUi3dPpvc
327	DTtuY2aAGcc	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	327	DTtuY2aAGcc
335	zLlDlWXIaK6	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	335	zLlDlWXIaK6
328	RXmpTec0meY	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	328	RXmpTec0meY
329	ae3r7yqNpat	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	329	ae3r7yqNpat
330	asCoXu0PHpL	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	330	asCoXu0PHpL
331	ZSY4OdZ4iAx	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	331	ZSY4OdZ4iAx
336	yeA4jdSqetI	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	336	yeA4jdSqetI
2597	rD922anbNzS	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	2597	rD922anbNzS
341	P1IYVDrz7rL	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	341	P1IYVDrz7rL
342	BXgAR3Kq8kv	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	342	BXgAR3Kq8kv
343	un9dv9VS0Cd	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	343	un9dv9VS0Cd
344	fT98rg0rZFy	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	344	fT98rg0rZFy
337	Qr8y4NcchsS	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	337	Qr8y4NcchsS
345	NluQOzhboUd	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	345	NluQOzhboUd
346	khzscd51sFY	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	346	khzscd51sFY
347	wDNV7tv3hzP	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	347	wDNV7tv3hzP
348	z0vS3kFxDjc	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	348	z0vS3kFxDjc
339	QmOEotRpx4w	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	339	QmOEotRpx4w
349	FdQo42NAOxF	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	349	FdQo42NAOxF
351	B9NWy5hoq0C	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	351	B9NWy5hoq0C
352	UC5oDg6aLRl	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	352	UC5oDg6aLRl
1580	ObP05tDjGoW	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1580	ObP05tDjGoW
1581	D06Hv2GofVa	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1581	D06Hv2GofVa
1582	JvF5JZK4OIl	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1582	JvF5JZK4OIl
1583	acwO6ZCWJj7	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1583	acwO6ZCWJj7
1584	YG7bSJaIniu	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1584	YG7bSJaIniu
350	g6FnEMkJC9Q	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	350	g6FnEMkJC9Q
1590	DjqXZ26I2cN	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	1590	DjqXZ26I2cN
2596	Z5sUKqQ2Dj9	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	2596	Z5sUKqQ2Dj9
340	DqOwtu7833e	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	340	DqOwtu7833e
1613	t89pNBmJnKW	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1613	t89pNBmJnKW
1614	zmqrtMA7R5I	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1614	zmqrtMA7R5I
353	fXF5EXLOSdC	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	353	fXF5EXLOSdC
354	jtCFBhcCIrW	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	354	jtCFBhcCIrW
355	aizpwKYoKtN	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	355	aizpwKYoKtN
356	M0i3WV2BrFk	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	356	M0i3WV2BrFk
361	fu6SGxjqBEm	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	361	fu6SGxjqBEm
357	R7ff2hyU6vl	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	357	R7ff2hyU6vl
358	WS9RVsVKaPl	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	358	WS9RVsVKaPl
359	NvldsxeQgJf	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	359	NvldsxeQgJf
360	O29YQnbcXRf	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	360	O29YQnbcXRf
362	e1uAyULbNqU	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	362	e1uAyULbNqU
363	ZCER8MJ2DeP	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	363	ZCER8MJ2DeP
364	Qw1HTN8srXZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	364	Qw1HTN8srXZ
365	GUNcDwlsQYQ	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	365	GUNcDwlsQYQ
366	rXllRge31pf	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	366	rXllRge31pf
367	tJbdFuiO6tY	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	367	tJbdFuiO6tY
368	BJc6aAKfEdk	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	368	BJc6aAKfEdk
369	y2tqwpJlSZd	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	369	y2tqwpJlSZd
370	ZfKPEEqgxDY	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	370	ZfKPEEqgxDY
371	OuGhhbtALJT	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	371	OuGhhbtALJT
372	wDG9YN30TtI	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	372	wDG9YN30TtI
373	hQNlx67qNxz	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	373	hQNlx67qNxz
374	EpK05gvAmQd	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	374	EpK05gvAmQd
1619	XDyiOGArIT7	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1619	XDyiOGArIT7
1620	ftLtvhHg24p	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1620	ftLtvhHg24p
1621	hCqsW3kUlSL	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1621	hCqsW3kUlSL
1622	tAM0excypCp	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1622	tAM0excypCp
375	nd7BxeKY0BC	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	375	nd7BxeKY0BC
376	RHEU4J1wJiy	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	376	RHEU4J1wJiy
377	EQzZv91U9wT	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	377	EQzZv91U9wT
378	OkLwuZ0WpVb	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	378	OkLwuZ0WpVb
379	APscKx450Qa	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	379	APscKx450Qa
380	NEw9nvySGeM	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	380	NEw9nvySGeM
381	aaCfJhBmGNy	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	381	aaCfJhBmGNy
382	mXkgYpPVevL	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	382	mXkgYpPVevL
384	eVqTzYtYuI7	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	384	eVqTzYtYuI7
383	aMxU0CjFNiG	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	383	aMxU0CjFNiG
385	a6U3yalrRlI	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	385	a6U3yalrRlI
386	yOGnbMFrKQh	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	386	yOGnbMFrKQh
387	kGk6ZytfQ1R	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	387	kGk6ZytfQ1R
1608	kTswDBmRkXI	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1608	kTswDBmRkXI
1609	TibfOVehAIg	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1609	TibfOVehAIg
388	VFQwTt1dbwy	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	388	VFQwTt1dbwy
389	eFewDBgvkUo	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	389	eFewDBgvkUo
390	da7lLykmZrk	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	390	da7lLykmZrk
391	lN73pdksWUB	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	391	lN73pdksWUB
392	hVS9ex07Opz	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	392	hVS9ex07Opz
393	IEjbPvDOXTU	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	393	IEjbPvDOXTU
394	aRxbH61glg4	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	394	aRxbH61glg4
395	aNr9ajfdR2q	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	395	aNr9ajfdR2q
396	ugKCZ7kJQPh	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	396	ugKCZ7kJQPh
397	wJ1jKBQsVHw	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	397	wJ1jKBQsVHw
409	XD1KW6zzsZW	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	409	XD1KW6zzsZW
410	OZTaLjgTD2w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	410	OZTaLjgTD2w
398	SXrFhwJB3wi	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	398	SXrFhwJB3wi
399	WzfWcG6I4e6	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	399	WzfWcG6I4e6
400	rKLL7VlbL3b	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	400	rKLL7VlbL3b
411	AgYgZ65N9vd	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	411	AgYgZ65N9vd
412	O2dHlvX1nZV	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	412	O2dHlvX1nZV
413	FjaBJw5pfW8	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	413	FjaBJw5pfW8
414	xb87C9pAYuF	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	414	xb87C9pAYuF
415	zzuqkx8GWNy	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	415	zzuqkx8GWNy
416	TQCB9RroT0I	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	416	TQCB9RroT0I
417	gzratsgHCh4	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	417	gzratsgHCh4
418	nLtTLd8oVQi	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	418	nLtTLd8oVQi
419	afDtaFFJy5U	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	419	afDtaFFJy5U
420	MzbvVMv6qqR	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	420	MzbvVMv6qqR
421	mwrx20w7TwC	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	421	mwrx20w7TwC
422	KA3m8Skxyrd	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	422	KA3m8Skxyrd
423	hO6qi1vSbQa	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	423	hO6qi1vSbQa
424	HLymn5haKX6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	424	HLymn5haKX6
401	kcStNQ2LDcH	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	401	kcStNQ2LDcH
429	KMVmXiFpKHe	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	429	KMVmXiFpKHe
402	BA5mnJAevwO	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	402	BA5mnJAevwO
430	aI77OsoVVCX	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	430	aI77OsoVVCX
403	bRDYyY5ifEh	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	403	bRDYyY5ifEh
404	ajfHMWjRuW4	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	404	ajfHMWjRuW4
405	QOZgGnGOiBF	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	405	QOZgGnGOiBF
406	LAhpdWaQw44	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	406	LAhpdWaQw44
407	n3uOjROSJWU	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	407	n3uOjROSJWU
408	pRs8qxqjCaa	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	408	pRs8qxqjCaa
431	immOGNT21Gt	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	431	immOGNT21Gt
432	UncsFPaUPY4	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	432	UncsFPaUPY4
433	KHKxw334CWz	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	433	KHKxw334CWz
434	fcACbA55GDC	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	434	fcACbA55GDC
435	aZwX9DfOUK2	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	435	aZwX9DfOUK2
436	s2dkjCPY2qR	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	436	s2dkjCPY2qR
437	UDksMxL5cfZ	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	437	UDksMxL5cfZ
2611	q0d7cUeMDjo	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	2611	q0d7cUeMDjo
438	JlGpcng9BFf	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	438	JlGpcng9BFf
440	gN1WNlUMCAO	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	440	gN1WNlUMCAO
425	ktVICQZY6Va	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	425	ktVICQZY6Va
426	D6Mz2uFmKrb	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	426	D6Mz2uFmKrb
441	eVDEotZAl6S	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	441	eVDEotZAl6S
442	HNcjoI8Hikq	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	442	HNcjoI8Hikq
443	yjo1AMiB3pU	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	443	yjo1AMiB3pU
444	XZ5EZKyfHD2	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	444	XZ5EZKyfHD2
445	avyPYZAMQV9	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	445	avyPYZAMQV9
1586	PhCq4x6L2o1	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1586	PhCq4x6L2o1
439	O95WxDWc3nj	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	439	O95WxDWc3nj
447	aMIG8T1OZD7	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	447	aMIG8T1OZD7
448	kisFgxvHQ0b	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	448	kisFgxvHQ0b
449	NpxPtxsVliE	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	449	NpxPtxsVliE
450	areRYmW2Moa	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	450	areRYmW2Moa
451	lkTLhQNgq5O	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	451	lkTLhQNgq5O
452	CiSoGcQQ88r	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	452	CiSoGcQQ88r
453	umzGjVN9LWy	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	453	umzGjVN9LWy
446	STVXdJbnn3H	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	446	STVXdJbnn3H
427	oSkHt5d4nr6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	427	oSkHt5d4nr6
454	iusvea4wlaa	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	454	iusvea4wlaa
455	adH5G8EstWj	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	455	adH5G8EstWj
456	MYSHyvamVzh	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	456	MYSHyvamVzh
457	HYW1XVqXk62	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	457	HYW1XVqXk62
459	LdyV4e0vzeu	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	459	LdyV4e0vzeu
460	K6dmqTjBz5B	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	460	K6dmqTjBz5B
428	itMXAtIHVu2	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	428	itMXAtIHVu2
461	fA4gHLINj8q	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	461	fA4gHLINj8q
462	Nwdvs8JuEbv	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	462	Nwdvs8JuEbv
463	I2XU2SFfwnB	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	463	I2XU2SFfwnB
464	CjVML3u4v4O	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	464	CjVML3u4v4O
465	QIuZPS9HZlu	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	465	QIuZPS9HZlu
466	WxQQCkhFNzQ	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	466	WxQQCkhFNzQ
467	cb19xb8BO6Q	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	467	cb19xb8BO6Q
1634	apXGr1f8l9D	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	1634	apXGr1f8l9D
468	QxHGHhger7q	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	468	QxHGHhger7q
469	WQLYmAhQup5	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	469	WQLYmAhQup5
458	HWHRutHDzXu	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	458	HWHRutHDzXu
470	qiewZJ2PhvP	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	470	qiewZJ2PhvP
1632	PhRuQO8U4RI	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1632	PhRuQO8U4RI
1633	HorpECfqag7	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1633	HorpECfqag7
471	F1OvU15f7z0	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	471	F1OvU15f7z0
472	vOnAOaB1pFA	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	472	vOnAOaB1pFA
473	MCcHPIPGtCo	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	473	MCcHPIPGtCo
474	PGjfT8GmgvT	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	474	PGjfT8GmgvT
475	Uo7haVIuBGR	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	475	Uo7haVIuBGR
476	ZIIpqinbXJS	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	476	ZIIpqinbXJS
477	cutapjXYyeI	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	477	cutapjXYyeI
478	vQtUjVkhR7L	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	478	vQtUjVkhR7L
479	esylq1Zwig3	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	479	esylq1Zwig3
480	AvjirMUjg0j	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	480	AvjirMUjg0j
1591	M85YNgaQCoM	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1591	M85YNgaQCoM
481	BXbTY29PWlG	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	481	BXbTY29PWlG
482	sAIggLrZ5Ru	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	482	sAIggLrZ5Ru
483	yWYw37S44Ku	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	483	yWYw37S44Ku
484	aeovDDRuWXz	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	484	aeovDDRuWXz
485	Pud49eGxz7F	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	485	Pud49eGxz7F
486	yyiNJYq4R1G	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	486	yyiNJYq4R1G
487	HE9Llpjlago	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	487	HE9Llpjlago
488	Bh0U2ITJVc7	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	488	Bh0U2ITJVc7
489	s65J7cpFWS4	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	489	s65J7cpFWS4
490	KG8j3CvkRd9	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	490	KG8j3CvkRd9
491	MzHx79UsWAd	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	491	MzHx79UsWAd
492	OMrkzFQQ1qN	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	492	OMrkzFQQ1qN
493	NgEEuq6uZfV	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	493	NgEEuq6uZfV
496	ZMvUDFx9XnN	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	496	ZMvUDFx9XnN
497	qQPApRF5J28	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	497	qQPApRF5J28
498	tkgsqoGYcYi	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	498	tkgsqoGYcYi
1587	v34OKRUDNcU	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1587	v34OKRUDNcU
1588	uNP90Zfk2Lg	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1588	uNP90Zfk2Lg
499	lqOmHQtlRmV	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	499	lqOmHQtlRmV
500	enlpMHcmSeb	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	500	enlpMHcmSeb
501	bw1fnw2gvKX	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	501	bw1fnw2gvKX
502	B5hUY8cW6hE	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	502	B5hUY8cW6hE
503	GNk286NN5pG	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	503	GNk286NN5pG
504	Wr3gyeZ6KUr	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	504	Wr3gyeZ6KUr
505	XmUndBGqpt6	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	505	XmUndBGqpt6
506	yha3MhpqPH1	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	506	yha3MhpqPH1
507	QmhTQqN5gZv	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	507	QmhTQqN5gZv
508	DGBFUfYWCBl	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	508	DGBFUfYWCBl
509	nBZk2ugBiwx	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	509	nBZk2ugBiwx
510	wY6EznPosth	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	510	wY6EznPosth
511	EzcaOWLXAqW	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	511	EzcaOWLXAqW
512	DyPcdfPhNdS	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	512	DyPcdfPhNdS
513	aKZcxeiqnDC	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	513	aKZcxeiqnDC
514	XY8Siwchc7A	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	514	XY8Siwchc7A
515	BJXJyNCFAl2	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	515	BJXJyNCFAl2
516	BbzYFgQMV67	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	516	BbzYFgQMV67
517	aEOan17QsoW	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	517	aEOan17QsoW
518	hUz7cK7sja3	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	518	hUz7cK7sja3
519	nBKJ3cpl4T0	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	519	nBKJ3cpl4T0
520	tXDsfp50KIl	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	520	tXDsfp50KIl
521	a5pj74dBGEp	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	521	a5pj74dBGEp
494	LNkFivzpeA1	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	494	LNkFivzpeA1
522	rLXKKzktTVy	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	522	rLXKKzktTVy
523	D6VouTb2XCU	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	523	D6VouTb2XCU
524	hjo5ZPxN6lF	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	524	hjo5ZPxN6lF
525	gAQjtVVeV0w	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	525	gAQjtVVeV0w
526	Avn1mi6BJ58	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	526	Avn1mi6BJ58
527	rIGScyQWQfv	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	527	rIGScyQWQfv
1589	L4fYeaxZz9w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1589	L4fYeaxZz9w
528	V8YasjaiKtV	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	528	V8YasjaiKtV
530	aJedGfomkcr	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	530	aJedGfomkcr
531	saGv90kz1c0	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	531	saGv90kz1c0
532	u2n8s5Ol9SE	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	532	u2n8s5Ol9SE
533	ZbMUQHETUwO	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	533	ZbMUQHETUwO
534	D3NU99wFJ8q	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	534	D3NU99wFJ8q
535	a0zpHapVjFR	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	535	a0zpHapVjFR
536	fYaQexh3P77	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	536	fYaQexh3P77
537	tQcM2PMDVjA	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	537	tQcM2PMDVjA
538	a1BUAxYwQ1t	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	538	a1BUAxYwQ1t
539	HSfJD8SpfGG	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	539	HSfJD8SpfGG
495	sBXTbPz7S4Z	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	495	sBXTbPz7S4Z
540	WhdBSl0J7TV	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	540	WhdBSl0J7TV
541	cWGy4pU4VNL	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	541	cWGy4pU4VNL
542	M2Evh1Y9m1w	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	542	M2Evh1Y9m1w
543	HxUixzlcItQ	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	543	HxUixzlcItQ
544	zDJSedQmteO	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	544	zDJSedQmteO
545	MlsORrMK1p8	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	545	MlsORrMK1p8
546	K3fBM7akxIM	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	546	K3fBM7akxIM
547	gR9ugQ5XA2p	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	547	gR9ugQ5XA2p
548	vRIkWQ53yWk	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	548	vRIkWQ53yWk
549	nbfgB0iEtZi	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	549	nbfgB0iEtZi
550	PRm0WRtzN3B	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	550	PRm0WRtzN3B
551	ataZYLjOJXV	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	551	ataZYLjOJXV
552	RGGBHxJiRuh	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	552	RGGBHxJiRuh
529	pnxCSdB9Msk	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	529	pnxCSdB9Msk
553	ZCNZLPHbl3A	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	553	ZCNZLPHbl3A
554	Qk9HZ65zQnB	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	554	Qk9HZ65zQnB
555	sZkAxsA924V	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	555	sZkAxsA924V
556	fxbYbS59MHd	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	556	fxbYbS59MHd
557	tbrqQuOozOK	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	557	tbrqQuOozOK
558	kkYXfP8JNL2	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	558	kkYXfP8JNL2
559	d29fMUVvhDk	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	559	d29fMUVvhDk
560	a3qYnKHnulG	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	560	a3qYnKHnulG
561	HrVQp6KrVX9	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	561	HrVQp6KrVX9
562	eC4loXN1tRm	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	562	eC4loXN1tRm
563	XW7unjyUCe8	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	563	XW7unjyUCe8
564	a92Lyf8Vnrg	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	564	a92Lyf8Vnrg
566	aDPJkOqtFvR	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	566	aDPJkOqtFvR
567	IT6uTDE2Mmb	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	567	IT6uTDE2Mmb
568	ACGwiDCOGnv	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	568	ACGwiDCOGnv
569	IoHAYBBHJv6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	569	IoHAYBBHJv6
570	v9FD5Gpl9mz	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	570	v9FD5Gpl9mz
571	O2pu4FaMeOX	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	571	O2pu4FaMeOX
572	asazeL5Os4W	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	572	asazeL5Os4W
573	X7IxKzXFuG2	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	573	X7IxKzXFuG2
574	jZuodh1Bux6	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	574	jZuodh1Bux6
575	beCHk64vc24	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	575	beCHk64vc24
576	ijcJS6aeDzn	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	576	ijcJS6aeDzn
577	UePQHLsuRjz	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	577	UePQHLsuRjz
578	r7Yx3IGPRyv	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	578	r7Yx3IGPRyv
579	uig2M5cny1H	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	579	uig2M5cny1H
580	aG0jMQyfUTx	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	580	aG0jMQyfUTx
581	hduvp3xa2Ay	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	581	hduvp3xa2Ay
582	aT9SzVJj0bl	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	582	aT9SzVJj0bl
583	VzNo51e77c5	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	583	VzNo51e77c5
584	ukbA7OKBWnA	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	584	ukbA7OKBWnA
585	zpLy53v57se	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	585	zpLy53v57se
586	N5HS3jdULUy	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	586	N5HS3jdULUy
587	Xsx22uXtlpC	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	587	Xsx22uXtlpC
588	tSaD45BABGh	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	588	tSaD45BABGh
589	acI7OX1zZEL	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	589	acI7OX1zZEL
565	lkkGqyqZ6qF	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	565	lkkGqyqZ6qF
590	hQ8aPoqFZbB	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	590	hQ8aPoqFZbB
591	Faj16MOBMgV	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	591	Faj16MOBMgV
592	dQPA0d35Rve	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	592	dQPA0d35Rve
593	fyRAZd94Iko	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	593	fyRAZd94Iko
594	vhabQS0hUcP	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	594	vhabQS0hUcP
595	t3epAUsT575	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	595	t3epAUsT575
596	qr9NGNGWnKe	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	596	qr9NGNGWnKe
597	OKDIaS83FAi	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	597	OKDIaS83FAi
598	TSjl80sWfHh	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	598	TSjl80sWfHh
599	SlNtFLDkwFu	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	599	SlNtFLDkwFu
600	RFO7xONPACc	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	600	RFO7xONPACc
601	rMpx9X7T5lY	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	601	rMpx9X7T5lY
602	BNyMSSfYf4F	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	602	BNyMSSfYf4F
603	RNvCuVyrrIM	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	603	RNvCuVyrrIM
604	AL6JpHbgaDx	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	604	AL6JpHbgaDx
605	jLbNqQrDbKZ	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	605	jLbNqQrDbKZ
606	UOMccy1X4qP	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	606	UOMccy1X4qP
607	YCLl9sb7PPj	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	607	YCLl9sb7PPj
608	DqlVBrTm4ge	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	608	DqlVBrTm4ge
609	a8kUiWFtuPS	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	609	a8kUiWFtuPS
610	JStHLwEQslP	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	610	JStHLwEQslP
611	sSqr43OzNQJ	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	611	sSqr43OzNQJ
612	SV1Bw284a44	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	612	SV1Bw284a44
614	aH0jq5ENnZS	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	614	aH0jq5ENnZS
615	fBjBTSTJHf6	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	615	fBjBTSTJHf6
616	Ve7T1nizG7q	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	616	Ve7T1nizG7q
617	q7s1d5LzgWc	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	617	q7s1d5LzgWc
618	kdIm0faI4Qw	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	618	kdIm0faI4Qw
619	B9VTI1nHb8T	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	619	B9VTI1nHb8T
620	s8bn45A31mu	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	620	s8bn45A31mu
1626	aFoe95rrnkM	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1626	aFoe95rrnkM
621	xIKybEz7PTY	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	621	xIKybEz7PTY
622	adTaaCdwRM7	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	622	adTaaCdwRM7
623	aaes1np8v4h	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	623	aaes1np8v4h
624	OWRojvEDKoQ	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	624	OWRojvEDKoQ
625	Z0G5mSsk4VZ	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	625	Z0G5mSsk4VZ
626	xiFyzChOvlR	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	626	xiFyzChOvlR
627	gLyHeUBTz8t	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	627	gLyHeUBTz8t
628	IfprxlrKiKL	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	628	IfprxlrKiKL
629	DRAypYcgokr	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	629	DRAypYcgokr
630	F9n4CIZXoSa	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	630	F9n4CIZXoSa
631	uI5RcvNU7bG	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	631	uI5RcvNU7bG
632	kygzvZq01dr	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	632	kygzvZq01dr
633	hL8S70PKfJ7	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	633	hL8S70PKfJ7
634	K53DNeXvZyY	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	634	K53DNeXvZyY
635	xWj7K97vdF9	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	635	xWj7K97vdF9
636	AbV5pHHSFTU	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	636	AbV5pHHSFTU
613	ovQV6rcV90p	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	613	ovQV6rcV90p
637	a8kHG8t6bY6	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	637	a8kHG8t6bY6
649	a0vg4d6HxAt	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	649	a0vg4d6HxAt
650	ZLnbMrovQ9f	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	650	ZLnbMrovQ9f
651	RTxq0C3ff1y	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	651	RTxq0C3ff1y
652	aQbUr8vlhmm	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	652	aQbUr8vlhmm
653	EAvf9A8eXu3	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	653	EAvf9A8eXu3
654	o1TE46Mk0lW	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	654	o1TE46Mk0lW
655	afAjPIjW0D3	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	655	afAjPIjW0D3
656	gj1Omw1FJCo	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	656	gj1Omw1FJCo
657	acHyc4nCqAg	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	657	acHyc4nCqAg
658	ajyWVVmNSuc	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	658	ajyWVVmNSuc
659	aYieDAsKoLt	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	659	aYieDAsKoLt
660	aBvWL2yX3ZA	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	660	aBvWL2yX3ZA
661	aIcEOOsCdQz	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	661	aIcEOOsCdQz
662	e4XWNDjKUXH	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	662	e4XWNDjKUXH
1568	VWM1FTIMfuj	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1568	VWM1FTIMfuj
663	awd0xy7yb1C	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	663	awd0xy7yb1C
664	McggXNT9Zyg	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	664	McggXNT9Zyg
665	bGpRkGyvpw2	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	665	bGpRkGyvpw2
638	alKCrUnF0Ww	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	638	alKCrUnF0Ww
667	IU8fCTgthtM	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	667	IU8fCTgthtM
668	ai2RrlY9Fcd	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	668	ai2RrlY9Fcd
639	giI51CVkmc5	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	639	giI51CVkmc5
669	fDUCgOeUSZ3	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	669	fDUCgOeUSZ3
640	cTEozrMez9F	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	640	cTEozrMez9F
899707	FTlhugCaMo2	4	194	akV6429SUqu	899561	ecZgt4pokn4	899614	CKgGrgTdDiW	899707	FTlhugCaMo2
670	aYWNoEFeoUw	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	670	aYWNoEFeoUw
671	eTbQFH93KnL	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	671	eTbQFH93KnL
672	FEIP4B06TTS	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	672	FEIP4B06TTS
673	atuGUiyfDCY	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	673	atuGUiyfDCY
674	hNRHAcDywTL	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	674	hNRHAcDywTL
675	TW0y96F73kX	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	675	TW0y96F73kX
676	HzudJ19fruU	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	676	HzudJ19fruU
677	sAOvU6xz6rg	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	677	sAOvU6xz6rg
641	txhaIBaEbrA	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	641	txhaIBaEbrA
678	weIcTd1431E	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	678	weIcTd1431E
643	rs5gMlaHAKN	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	643	rs5gMlaHAKN
644	qi6GOznKLly	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	644	qi6GOznKLly
645	vTfdVf6ncdV	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	645	vTfdVf6ncdV
679	VrN4YeR370f	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	679	VrN4YeR370f
680	q0BqaYeLsKz	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	680	q0BqaYeLsKz
681	ZXUkpP7874H	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	681	ZXUkpP7874H
666	gt1m7SU1IYP	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	666	gt1m7SU1IYP
682	u2qKXP2Yt49	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	682	u2qKXP2Yt49
646	NUIvwbo2SFh	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	646	NUIvwbo2SFh
1615	Pzuty2p5guf	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1615	Pzuty2p5guf
683	I2CScuUNy5Y	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	683	I2CScuUNy5Y
684	ZHfJLqSYMkD	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	684	ZHfJLqSYMkD
647	wyW0esOM7ZB	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	647	wyW0esOM7ZB
685	uWXVoMSOy5v	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	685	uWXVoMSOy5v
686	oUbjAL1F0oh	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	686	oUbjAL1F0oh
687	bzz1pfLJqsG	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	687	bzz1pfLJqsG
688	FNKf692yj8f	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	688	FNKf692yj8f
648	gmakqYElPUi	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	648	gmakqYElPUi
689	GEO7nsOVAeb	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	689	GEO7nsOVAeb
690	Mdhjgfhqq3E	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	690	Mdhjgfhqq3E
691	OjpRztl3PXm	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	691	OjpRztl3PXm
692	dIryCQvB5SO	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	692	dIryCQvB5SO
693	aQdwdYyr6GL	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	693	aQdwdYyr6GL
694	a8JmSlpZNZp	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	694	a8JmSlpZNZp
695	lXd493OI3PF	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	695	lXd493OI3PF
696	Qz23CEgrnri	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	696	Qz23CEgrnri
697	ZXVPHNGdsSz	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	697	ZXVPHNGdsSz
698	FJMPE6W5Eh5	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	698	FJMPE6W5Eh5
699	anjXngIyBSK	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	699	anjXngIyBSK
700	yCliwz5ZvHM	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	700	yCliwz5ZvHM
701	FIum5r1vz31	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	701	FIum5r1vz31
702	bccV4EYcggS	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	702	bccV4EYcggS
704	DiPNrbcTMu7	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	704	DiPNrbcTMu7
705	OKG9JhAXAh8	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	705	OKG9JhAXAh8
706	XbSvPK3Vt68	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	706	XbSvPK3Vt68
707	XH5QSihkOp9	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	707	XH5QSihkOp9
708	M8nMckziF7v	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	708	M8nMckziF7v
709	z7zg0AlCyHn	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	709	z7zg0AlCyHn
710	sDD3UFAT7eA	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	710	sDD3UFAT7eA
711	a8UqcJq7pdF	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	711	a8UqcJq7pdF
712	VdgakBSJmWY	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	712	VdgakBSJmWY
713	kimHkD6SIvJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	713	kimHkD6SIvJ
714	P0O4loDtPtQ	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	714	P0O4loDtPtQ
715	wqcNzckuzrb	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	715	wqcNzckuzrb
716	LQLSqsdH1d5	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	716	LQLSqsdH1d5
1610	wLL0PdmBLep	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1610	wLL0PdmBLep
717	Vko6vxEEGTL	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	717	Vko6vxEEGTL
1572	htalJQhw2VH	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	1572	htalJQhw2VH
718	UeBN5O6ty6x	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	718	UeBN5O6ty6x
719	eNfm0rdOENJ	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	719	eNfm0rdOENJ
720	UbxVhXZ5cxg	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	720	UbxVhXZ5cxg
721	Ff8IGt4L1bx	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	721	Ff8IGt4L1bx
722	BH9KY4rNgOd	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	722	BH9KY4rNgOd
723	T0h7sp936Oj	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	723	T0h7sp936Oj
724	XHmgImvm1YA	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	724	XHmgImvm1YA
725	Vn1BrRW11CK	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	725	Vn1BrRW11CK
726	irk9vMITnjG	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	726	irk9vMITnjG
727	v9bokcX3eyh	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	727	v9bokcX3eyh
728	unil8uWmdaQ	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	728	unil8uWmdaQ
729	s7AX07hTO3k	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	729	s7AX07hTO3k
730	FP69DGoEtwM	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	730	FP69DGoEtwM
731	QKcOOobdPtO	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	731	QKcOOobdPtO
732	Rwjn2kDDgwf	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	732	Rwjn2kDDgwf
733	IzhBEvsBLuC	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	733	IzhBEvsBLuC
734	ankNTtBte7C	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	734	ankNTtBte7C
735	a1ZQxyqQh2P	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	735	a1ZQxyqQh2P
736	tpjk403ii11	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	736	tpjk403ii11
737	KGfsBIXqGWC	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	737	KGfsBIXqGWC
738	f82sIZY6sXk	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	738	f82sIZY6sXk
739	ibNVWLqSB0M	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	739	ibNVWLqSB0M
740	QsVqR2LTTyA	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	740	QsVqR2LTTyA
741	DZ756Z6f6or	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	741	DZ756Z6f6or
742	k3TPzr4AjuK	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	742	k3TPzr4AjuK
743	aPq34NY4UoQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	743	aPq34NY4UoQ
744	bzwQwNeos4x	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	744	bzwQwNeos4x
745	UOGlWhl35aX	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	745	UOGlWhl35aX
2606	A4sujFcM3Rd	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2606	A4sujFcM3Rd
746	k7Wgi7O0JdY	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	746	k7Wgi7O0JdY
747	nxmcI5yFfZT	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	747	nxmcI5yFfZT
748	aGcAkfwodXH	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	748	aGcAkfwodXH
1574	NcuAdU0UfGD	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1574	NcuAdU0UfGD
749	jlUSUrhXkWa	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	749	jlUSUrhXkWa
750	j4mYXmd6dAo	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	750	j4mYXmd6dAo
751	FBqsNdo7BhV	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	751	FBqsNdo7BhV
752	AyfxIwQbwaa	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	752	AyfxIwQbwaa
753	aqPlmnEhKp4	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	753	aqPlmnEhKp4
754	TDySLXGWz3J	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	754	TDySLXGWz3J
755	lBaXWVG0uKY	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	755	lBaXWVG0uKY
756	P5yisXF3Zpg	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	756	P5yisXF3Zpg
757	qwvt0BiEsTd	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	757	qwvt0BiEsTd
758	PYy5HTyCdNG	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	758	PYy5HTyCdNG
703	WSYIQSpwPop	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	703	WSYIQSpwPop
759	LUHdM7WTGOa	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	759	LUHdM7WTGOa
760	BgokGwMnuMg	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	760	BgokGwMnuMg
2600	EuenzV2j2gh	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	2600	EuenzV2j2gh
762	ajkzjPlcCwo	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	762	ajkzjPlcCwo
763	RXwynIETRuW	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	763	RXwynIETRuW
764	Z5bpgfoV7zZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	764	Z5bpgfoV7zZ
765	jXtChmPP7Nj	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	765	jXtChmPP7Nj
766	FmcUCen26pk	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	766	FmcUCen26pk
767	azuXegJHaV5	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	767	azuXegJHaV5
768	XbFljDSYnip	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	768	XbFljDSYnip
769	Pr3pvr9gLU8	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	769	Pr3pvr9gLU8
770	HtZQp7J8zCH	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	770	HtZQp7J8zCH
771	uVmqHTweoDr	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	771	uVmqHTweoDr
772	PYG2auieAq6	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	772	PYG2auieAq6
773	aztJaVUNQQd	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	773	aztJaVUNQQd
774	mCATibfPDkS	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	774	mCATibfPDkS
775	JYWZpPyfYmQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	775	JYWZpPyfYmQ
776	a8kpQiPpYy0	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	776	a8kpQiPpYy0
777	WYXK0xBPYfx	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	777	WYXK0xBPYfx
778	zNdkt1W9dcu	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	778	zNdkt1W9dcu
779	fwJDrgKD2HB	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	779	fwJDrgKD2HB
780	xNFWmVZ4Q5L	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	780	xNFWmVZ4Q5L
781	cLas0iVZsnw	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	781	cLas0iVZsnw
782	BUWL20wfAHB	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	782	BUWL20wfAHB
783	C4Gn1IRKEmg	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	783	C4Gn1IRKEmg
784	Tk6cI0YZc9n	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	784	Tk6cI0YZc9n
785	ZeGDEUnjafd	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	785	ZeGDEUnjafd
1616	I9sa8wYtbhI	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1616	I9sa8wYtbhI
786	GKYsDNWyURe	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	786	GKYsDNWyURe
787	a9bdfn2hOs0	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	787	a9bdfn2hOs0
788	oAC3iaYXnzM	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	788	oAC3iaYXnzM
789	O8iZOZeRWv1	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	789	O8iZOZeRWv1
790	LD3UI99qch9	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	790	LD3UI99qch9
791	lKc1HJwGQpo	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	791	lKc1HJwGQpo
792	jFNWWovsSyW	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	792	jFNWWovsSyW
793	Yl575haJAFI	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	793	Yl575haJAFI
794	eN59rRkxQhi	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	794	eN59rRkxQhi
795	rX3aSZRsV6q	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	795	rX3aSZRsV6q
796	O55NSHMG3SN	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	796	O55NSHMG3SN
797	WzWkYEphZW9	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	797	WzWkYEphZW9
798	VV0exqWnJYw	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	798	VV0exqWnJYw
799	DJRzqJrw6hs	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	799	DJRzqJrw6hs
800	wrvQ9sKuSsJ	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	800	wrvQ9sKuSsJ
801	noZnZEDjkuI	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	801	noZnZEDjkuI
802	aJjvRZT2AqT	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	802	aJjvRZT2AqT
803	fmX1IQNrk2Q	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	803	fmX1IQNrk2Q
804	aalsK83lGNw	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	804	aalsK83lGNw
805	yPgbuSci4pX	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	805	yPgbuSci4pX
806	TTTUd8x0XZ7	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	806	TTTUd8x0XZ7
807	GNfNmxhRBMX	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	807	GNfNmxhRBMX
808	bAAsA9G7rGX	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	808	bAAsA9G7rGX
809	GLh6NlOfYQP	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	809	GLh6NlOfYQP
810	djMgaXn0i9x	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	810	djMgaXn0i9x
811	h8bx9l02abI	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	811	h8bx9l02abI
812	amkxMXakeXu	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	812	amkxMXakeXu
813	Nes6fdESisv	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	813	Nes6fdESisv
814	nIHa6wXLbHt	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	814	nIHa6wXLbHt
815	OtcX4cHu6sF	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	815	OtcX4cHu6sF
816	HTZhrdw748h	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	816	HTZhrdw748h
817	ciYirJoS2bT	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	817	ciYirJoS2bT
818	cdUu7uCoOhY	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	818	cdUu7uCoOhY
819	aOlMtRebTz8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	819	aOlMtRebTz8
820	HU27Dm5PRHo	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	820	HU27Dm5PRHo
821	YrGNy5AQy2U	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	821	YrGNy5AQy2U
1611	QYb31ehcR5R	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1611	QYb31ehcR5R
822	WCE4lL4rT73	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	822	WCE4lL4rT73
823	QyjU22BhtrY	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	823	QyjU22BhtrY
824	tsLXZfmENJW	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	824	tsLXZfmENJW
825	n4gYlmLUOrU	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	825	n4gYlmLUOrU
826	oMZSkQE6CzW	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	826	oMZSkQE6CzW
827	wVRNuBQptIz	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	827	wVRNuBQptIz
828	Pw1S7C7oSlb	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	828	Pw1S7C7oSlb
829	Ol8iEPOeRAB	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	829	Ol8iEPOeRAB
830	UScOSjCwMK5	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	830	UScOSjCwMK5
832	aVEnwpUDlzd	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	832	aVEnwpUDlzd
833	kF1SFRGTg9d	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	833	kF1SFRGTg9d
834	L4bNeaH542W	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	834	L4bNeaH542W
835	a3Kzeo29ZKb	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	835	a3Kzeo29ZKb
836	rIngfXPkVV0	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	836	rIngfXPkVV0
838	J8NEcJToM09	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	838	J8NEcJToM09
839	FCUvR11qCK1	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	839	FCUvR11qCK1
840	XIUw6GYfz2o	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	840	XIUw6GYfz2o
841	Lrz2RTu4m7z	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	841	Lrz2RTu4m7z
831	A2UOcJadqvg	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	831	A2UOcJadqvg
842	arqyzyS4nL2	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	842	arqyzyS4nL2
843	alAMOnr7I1C	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	843	alAMOnr7I1C
844	ZA35ZIXly1S	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	844	ZA35ZIXly1S
845	YXmA2I9pEgy	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	845	YXmA2I9pEgy
846	aVSDdSh3pZc	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	846	aVSDdSh3pZc
847	atjtfI5ERhj	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	847	atjtfI5ERhj
2601	oUu2ZSHv6MY	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2601	oUu2ZSHv6MY
848	aem5mcxM1gO	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	848	aem5mcxM1gO
849	lYqNWu82K6e	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	849	lYqNWu82K6e
850	a6kSPA6WRKJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	850	a6kSPA6WRKJ
851	GriJuFUbYvj	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	851	GriJuFUbYvj
852	TMJdZnNOFfa	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	852	TMJdZnNOFfa
853	Y4NFDi1A36x	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	853	Y4NFDi1A36x
854	SCdTXGoDrqJ	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	854	SCdTXGoDrqJ
855	K6tAujIHmVM	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	855	K6tAujIHmVM
856	DCD67vVjc2E	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	856	DCD67vVjc2E
857	qJ0sxVsO2pk	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	857	qJ0sxVsO2pk
858	fzvBAzpTuei	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	858	fzvBAzpTuei
859	OArnksuH9WD	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	859	OArnksuH9WD
860	yh1Sulu1NeO	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	860	yh1Sulu1NeO
861	H2g74E6daJi	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	861	H2g74E6daJi
862	WfCOLLxAlQl	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	862	WfCOLLxAlQl
863	UXjEx2E2ZA4	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	863	UXjEx2E2ZA4
864	lTJKdr8yZcj	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	864	lTJKdr8yZcj
865	zwrCEmPW7Nn	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	865	zwrCEmPW7Nn
866	BynI1aokvo2	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	866	BynI1aokvo2
867	EIwIQOkPTaD	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	867	EIwIQOkPTaD
868	hDJoLiGGfRY	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	868	hDJoLiGGfRY
869	Tm9sPGt31dl	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	869	Tm9sPGt31dl
870	EaYP1A2wyvE	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	870	EaYP1A2wyvE
871	dORhiEXRNbk	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	871	dORhiEXRNbk
872	d4oc9mO8c7a	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	872	d4oc9mO8c7a
873	NkDX1oU6cfn	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	873	NkDX1oU6cfn
874	LYuMx5oPsR5	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	874	LYuMx5oPsR5
875	QcwYauvw0xm	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	875	QcwYauvw0xm
876	moNkR6R4Giv	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	876	moNkR6R4Giv
877	joyz7BH8DXG	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	877	joyz7BH8DXG
878	wXKdvmz0nrv	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	878	wXKdvmz0nrv
879	CDtQkwtnyAH	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	879	CDtQkwtnyAH
880	Pp5WSDc9OCY	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	880	Pp5WSDc9OCY
881	zCQyW5ODHjj	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	881	zCQyW5ODHjj
882	g2cqoGXKKIR	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	882	g2cqoGXKKIR
883	yuGhB6fDmnU	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	883	yuGhB6fDmnU
884	a7t73IQZdXp	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	884	a7t73IQZdXp
885	jvcz0hVcAxJ	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	885	jvcz0hVcAxJ
886	yCb8ApS6M0g	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	886	yCb8ApS6M0g
887	AAXO2IZq70L	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	887	AAXO2IZq70L
888	nY0VztZvBTO	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	888	nY0VztZvBTO
889	e98gCd9BlNl	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	889	e98gCd9BlNl
890	atQIWPlJi3f	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	890	atQIWPlJi3f
891	prpCrjA0faa	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	891	prpCrjA0faa
892	e9lITPTVy5H	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	892	e9lITPTVy5H
893	Y9BKBtIjli6	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	893	Y9BKBtIjli6
894	J2sL2LLRwdg	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	894	J2sL2LLRwdg
895	abeBKMqGN0S	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	895	abeBKMqGN0S
896	dbfXxjnS2Pt	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	896	dbfXxjnS2Pt
837	NgU6GKFkUU4	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	837	NgU6GKFkUU4
897	hvOhryiEkBg	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	897	hvOhryiEkBg
898	amqLFDsy2mP	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	898	amqLFDsy2mP
899	eLn35raYbxK	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	899	eLn35raYbxK
900	WlD8pvSBDdI	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	900	WlD8pvSBDdI
901	ylIpZ1kqrzl	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	901	ylIpZ1kqrzl
902	tiCEiYlOHa9	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	902	tiCEiYlOHa9
904	EmP1TgdHCnS	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	904	EmP1TgdHCnS
905	jTDRA7XUQLH	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	905	jTDRA7XUQLH
903	ggvYKc3bfrH	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	903	ggvYKc3bfrH
906	sCXOgVGqtpp	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	906	sCXOgVGqtpp
907	v3u1aOgDsgx	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	907	v3u1aOgDsgx
908	zNyf0buOkOl	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	908	zNyf0buOkOl
909	OEWhwSnx6tP	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	909	OEWhwSnx6tP
910	wwh3Av3jOqm	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	910	wwh3Av3jOqm
911	qSt7JthiH9h	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	911	qSt7JthiH9h
912	aX8e1LzHpbE	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	912	aX8e1LzHpbE
913	lgwkTLjh0z8	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	913	lgwkTLjh0z8
914	XXvbdTUuGgg	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	914	XXvbdTUuGgg
915	ZjFXjIHR5u2	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	915	ZjFXjIHR5u2
916	lqh3U0Yv4CH	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	916	lqh3U0Yv4CH
917	l9dRuCYLpXH	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	917	l9dRuCYLpXH
918	VpJ2HH58EjI	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	918	VpJ2HH58EjI
919	i6UwRGRlTe6	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	919	i6UwRGRlTe6
920	RgaVJyjupYA	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	920	RgaVJyjupYA
925	k6Qib6wlmSW	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	925	k6Qib6wlmSW
926	aTalSr9jUmm	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	926	aTalSr9jUmm
927	iNsYdEeHG7q	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	927	iNsYdEeHG7q
928	KQCblChIrTo	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	928	KQCblChIrTo
929	aQfttHh6crC	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	929	aQfttHh6crC
930	oPGBU8lsM7Z	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	930	oPGBU8lsM7Z
931	jm4G6gQJISm	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	931	jm4G6gQJISm
932	i7RHER6mToP	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	932	i7RHER6mToP
933	YI1W2cHvMEF	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	933	YI1W2cHvMEF
934	hnrm4ibfoTk	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	934	hnrm4ibfoTk
935	uMZROveCZt0	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	935	uMZROveCZt0
936	HnJdqBFEw34	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	936	HnJdqBFEw34
937	asxJZ73r4QU	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	937	asxJZ73r4QU
938	M1GFPaWfMs9	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	938	M1GFPaWfMs9
939	SreeBEW8Aqm	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	939	SreeBEW8Aqm
940	VclKT9ER4XM	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	940	VclKT9ER4XM
941	O3kEMiNyC7J	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	941	O3kEMiNyC7J
942	avbBgK9zyA2	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	942	avbBgK9zyA2
943	SyDmHzRhAjp	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	943	SyDmHzRhAjp
944	l0LizWT16CQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	944	l0LizWT16CQ
945	aWMP3wvnNZW	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	945	aWMP3wvnNZW
946	dY1Tvx0RPRi	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	946	dY1Tvx0RPRi
947	zeYJmjH1keH	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	947	zeYJmjH1keH
948	p1fk9MgsBJp	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	948	p1fk9MgsBJp
949	JN43iMJuuu0	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	949	JN43iMJuuu0
950	GLbWzyzBfzw	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	950	GLbWzyzBfzw
921	asGXvs8RGcx	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	921	asGXvs8RGcx
951	pUzjkVgv6Fi	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	951	pUzjkVgv6Fi
952	INpjo0DSjXk	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	952	INpjo0DSjXk
953	mS0Js3oecic	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	953	mS0Js3oecic
954	OvshHVjn0lS	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	954	OvshHVjn0lS
955	PyNAIp8LzqW	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	955	PyNAIp8LzqW
956	Qv4Ev8LymW3	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	956	Qv4Ev8LymW3
957	PAjHH9FKnf7	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	957	PAjHH9FKnf7
958	ifsoB4c1lK3	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	958	ifsoB4c1lK3
922	ZwgfKE1W71u	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	922	ZwgfKE1W71u
959	aGywgyDsaIJ	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	959	aGywgyDsaIJ
923	g8E2xKiKNDo	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	923	g8E2xKiKNDo
960	swymPYYE156	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	960	swymPYYE156
961	BnEEwTPuAdl	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	961	BnEEwTPuAdl
962	mmzJuWJudcF	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	962	mmzJuWJudcF
963	LITVvlOIhKH	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	963	LITVvlOIhKH
964	BMyjKocJfay	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	964	BMyjKocJfay
965	RrMypNnd0bB	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	965	RrMypNnd0bB
966	wnc7108bfUe	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	966	wnc7108bfUe
967	ipwsQpJqSTw	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	967	ipwsQpJqSTw
968	amnWLIZ44DS	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	968	amnWLIZ44DS
969	K1ZKgCaz0Hd	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	969	K1ZKgCaz0Hd
970	qmcJkZ4ywL9	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	970	qmcJkZ4ywL9
971	aYH223NvQM9	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	971	aYH223NvQM9
972	aiZ5zkqnKTk	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	972	aiZ5zkqnKTk
924	DHWHrDD2bPf	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	924	DHWHrDD2bPf
973	VTkMLMzzqao	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	973	VTkMLMzzqao
974	JzZkIkp7PnX	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	974	JzZkIkp7PnX
975	svThtOW2ZOx	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	975	svThtOW2ZOx
976	s2a0yLa3g2f	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	976	s2a0yLa3g2f
642	a4eJM1A5pmq	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	642	a4eJM1A5pmq
977	aKZZ42qXlZq	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	977	aKZZ42qXlZq
978	pBCTMJRY7HR	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	978	pBCTMJRY7HR
979	JXMBQgVmU19	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	979	JXMBQgVmU19
980	afxMkooK3iZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	980	afxMkooK3iZ
981	K9Kbf0kDcAO	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	981	K9Kbf0kDcAO
982	aANELFaFbpF	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	982	aANELFaFbpF
983	Kgm0dUViEfO	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	983	Kgm0dUViEfO
984	WSDI45idzp5	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	984	WSDI45idzp5
985	uodLpKe7cyL	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	985	uodLpKe7cyL
986	hfW1BGRy1XT	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	986	hfW1BGRy1XT
987	Ed2uyXvmovM	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	987	Ed2uyXvmovM
988	fOv2DdPf7fG	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	988	fOv2DdPf7fG
989	uNDDSxipolZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	989	uNDDSxipolZ
990	KPGI2KIVJYC	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	990	KPGI2KIVJYC
991	q03uh0SJ0N9	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	991	q03uh0SJ0N9
992	dzxOS342VoL	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	992	dzxOS342VoL
993	RGpPADZEyuz	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	993	RGpPADZEyuz
995	V0rnbupwOSg	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	995	V0rnbupwOSg
996	nmK9yk0kjmP	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	996	nmK9yk0kjmP
997	HsanwfHFpmb	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	997	HsanwfHFpmb
998	lUpDen75Xj1	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	998	lUpDen75Xj1
999	rQcFYXak0LH	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	999	rQcFYXak0LH
1000	vzwpI60WeOu	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1000	vzwpI60WeOu
1001	aYNxEpv8ugI	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1001	aYNxEpv8ugI
1002	fbPAuvlJO2x	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1002	fbPAuvlJO2x
1003	FpHwm5xxH41	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1003	FpHwm5xxH41
1004	AH9Soa1y2qd	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1004	AH9Soa1y2qd
1005	Hy2n4D2yJOM	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1005	Hy2n4D2yJOM
1006	xYpXN24CZWB	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1006	xYpXN24CZWB
1007	hY5HcMQt93G	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1007	hY5HcMQt93G
1008	BKmwdsqAY8X	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1008	BKmwdsqAY8X
1009	pYK9GIYGHha	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1009	pYK9GIYGHha
1010	YExRLcjp4gN	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1010	YExRLcjp4gN
1011	FTHpI3wbK44	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1011	FTHpI3wbK44
1012	QHDvSlNK4AR	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1012	QHDvSlNK4AR
1013	einBeJvXJ9C	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1013	einBeJvXJ9C
1014	YqM3WN8CBFs	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1014	YqM3WN8CBFs
1015	WBLZTH5N3PI	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1015	WBLZTH5N3PI
1016	smtpWtgMApq	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1016	smtpWtgMApq
1017	VytuF37uBdH	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1017	VytuF37uBdH
1018	jpSKkolHZLC	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1018	jpSKkolHZLC
1019	INAlXb1eDqD	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1019	INAlXb1eDqD
1020	powsUW9bIIP	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1020	powsUW9bIIP
1021	CPZioDtBpZV	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1021	CPZioDtBpZV
1022	WeFUHhkOL7X	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1022	WeFUHhkOL7X
1023	eeX08t63esL	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1023	eeX08t63esL
1024	aXfUiVQAoT5	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1024	aXfUiVQAoT5
1025	jvma3lxo8f8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1025	jvma3lxo8f8
1026	ZlnVZxGQXOx	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1026	ZlnVZxGQXOx
1027	WjtyvvauxbS	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1027	WjtyvvauxbS
1028	mayeGj9ddSB	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1028	mayeGj9ddSB
1029	NRDNqq6C6e0	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1029	NRDNqq6C6e0
1030	KYNuILiw5nZ	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1030	KYNuILiw5nZ
1031	a0WerFS0RsJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1031	a0WerFS0RsJ
1032	BMGbzxq74QD	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1032	BMGbzxq74QD
1033	vjJEam7cAan	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1033	vjJEam7cAan
1034	WKSICXIHQfF	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1034	WKSICXIHQfF
1035	v4SsBMVYOWo	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1035	v4SsBMVYOWo
1036	as3Z6ngugbk	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1036	as3Z6ngugbk
1037	KqoeThv6f1S	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1037	KqoeThv6f1S
2610	I59FGFaG12c	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	2610	I59FGFaG12c
1038	aQM5mVi0TJ6	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1038	aQM5mVi0TJ6
1039	l01FDO0PtI0	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1039	l01FDO0PtI0
1040	I0Dnu8MNpI6	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1040	I0Dnu8MNpI6
1041	awkC6nEZfiH	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1041	awkC6nEZfiH
1042	GYTYaoNGHZ3	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1042	GYTYaoNGHZ3
2602	aXxvYqah8Pp	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2602	aXxvYqah8Pp
1043	aUTx89Nc5z1	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1043	aUTx89Nc5z1
1044	anccgvVRV6E	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1044	anccgvVRV6E
1045	r1CT8PzuM0D	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1045	r1CT8PzuM0D
1046	BNUP3lD4kG4	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1046	BNUP3lD4kG4
1047	Jwnd2Jayc4g	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1047	Jwnd2Jayc4g
1048	QpcgX2e3WIK	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1048	QpcgX2e3WIK
1049	COaxzbRhsBA	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1049	COaxzbRhsBA
1050	qUDCFxUq4uw	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1050	qUDCFxUq4uw
1051	ayMSTn5sz80	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1051	ayMSTn5sz80
1052	x7pZ9LvlBky	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1052	x7pZ9LvlBky
1053	B6t4I0VO1re	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1053	B6t4I0VO1re
1054	OWgilSeUm8D	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1054	OWgilSeUm8D
1055	p5nJqYlFrnv	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1055	p5nJqYlFrnv
1056	FBzF6PAZ005	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1056	FBzF6PAZ005
1057	siFCXpF47oz	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1057	siFCXpF47oz
1058	pH004BIak3K	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1058	pH004BIak3K
1059	arVCB9uKDid	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1059	arVCB9uKDid
1060	MnJWFwnuzn3	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1060	MnJWFwnuzn3
1061	rpArRJJW06x	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1061	rpArRJJW06x
1062	awMQEoN8pM3	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1062	awMQEoN8pM3
1065	YAjpUZ4zMfG	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1065	YAjpUZ4zMfG
1066	HEXRFkHHTnV	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1066	HEXRFkHHTnV
1067	jvOw5Sxvxvj	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1067	jvOw5Sxvxvj
1068	q5gtDb5elfP	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1068	q5gtDb5elfP
1069	e8OZNj5acCv	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1069	e8OZNj5acCv
1070	ou4ERpDzITv	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1070	ou4ERpDzITv
1071	lJWSXSCBtli	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	1071	lJWSXSCBtli
1072	tw10nJiKtIc	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1072	tw10nJiKtIc
1073	gGlUQNvHlRy	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1073	gGlUQNvHlRy
1074	FvufV5jpEM5	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1074	FvufV5jpEM5
1075	acHG8DfK2la	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1075	acHG8DfK2la
1076	Lg96gQU7KFN	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1076	Lg96gQU7KFN
1077	lohzTg3j7jU	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1077	lohzTg3j7jU
1078	BBRR0ZCNp9p	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1078	BBRR0ZCNp9p
1079	aYLAe6kESiT	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1079	aYLAe6kESiT
1080	Pb5LohJFHA0	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1080	Pb5LohJFHA0
1081	ak8dhyMummI	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1081	ak8dhyMummI
1082	JXAOPG4pehv	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1082	JXAOPG4pehv
1083	SGXPXHBPCyu	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1083	SGXPXHBPCyu
1084	d7O2HPDA9UV	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1084	d7O2HPDA9UV
1085	D6FXIrPgDTu	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1085	D6FXIrPgDTu
994	C2MPhjR29Db	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	994	C2MPhjR29Db
1086	XUogk7gtKr6	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1086	XUogk7gtKr6
1087	lcOZwwI0DzD	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1087	lcOZwwI0DzD
1088	QBs5UwEfnge	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1088	QBs5UwEfnge
1089	HT5sk9MS3Br	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1089	HT5sk9MS3Br
1090	wboIhZcZzoD	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1090	wboIhZcZzoD
1091	YhVHvo0UUnR	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1091	YhVHvo0UUnR
1092	iPiO62aF9FB	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1092	iPiO62aF9FB
1093	SOeWmeGdMfu	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1093	SOeWmeGdMfu
1094	DZQIcj2NrHv	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1094	DZQIcj2NrHv
1095	aIXbRzimOry	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	1095	aIXbRzimOry
1096	W93hZALLbDc	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1096	W93hZALLbDc
1097	c4Vsie8YEMT	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1097	c4Vsie8YEMT
1099	xcbWr7R7FDK	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1099	xcbWr7R7FDK
1100	vP5RNMjCpa5	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1100	vP5RNMjCpa5
1101	VeulA9IP9jC	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1101	VeulA9IP9jC
1102	vpIWLBHTWgV	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1102	vpIWLBHTWgV
1103	cYeWg82r4fI	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1103	cYeWg82r4fI
15386357	dWhV6fQI1c4	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	15386357	dWhV6fQI1c4
1104	aG6R67xf8oR	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1104	aG6R67xf8oR
1105	T5GMofQmNr0	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1105	T5GMofQmNr0
1106	BSIgbcTVHu7	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1106	BSIgbcTVHu7
1107	grLyhuvPVbL	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1107	grLyhuvPVbL
1108	NJBN4GJd1Q5	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1108	NJBN4GJd1Q5
1109	voFp0uhCRYz	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1109	voFp0uhCRYz
1110	dXbVDDOMeOX	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1110	dXbVDDOMeOX
1111	a8I8dB8Oztl	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1111	a8I8dB8Oztl
1113	amHAOOSM5kw	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	1113	amHAOOSM5kw
1114	Jc70rDN6l2B	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1114	Jc70rDN6l2B
1063	tTpyWAITi30	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1063	tTpyWAITi30
1115	IalHV5BSxEb	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1115	IalHV5BSxEb
1116	a8cUZGMlpFN	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1116	a8cUZGMlpFN
1117	VnaniHNwR1S	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1117	VnaniHNwR1S
1118	qp4HY08HICB	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1118	qp4HY08HICB
1119	xMnKacdHGIz	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1119	xMnKacdHGIz
1120	QDT6nKYPObn	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1120	QDT6nKYPObn
1536	byvlp3p7dsR	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1536	byvlp3p7dsR
1121	FbuhMjEaMXt	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1121	FbuhMjEaMXt
1122	zEkQ9IMTejV	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1122	zEkQ9IMTejV
1123	R8mMDsfgcsd	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1123	R8mMDsfgcsd
1124	Y2uKnrkZ9eV	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1124	Y2uKnrkZ9eV
1125	ajaV3Ug1PuP	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1125	ajaV3Ug1PuP
1126	sW1lqVgbz6k	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1126	sW1lqVgbz6k
1127	agmiAjuf7ro	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	1127	agmiAjuf7ro
1128	VBrVhVxTU7W	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1128	VBrVhVxTU7W
1129	ccykDrWXKhD	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1129	ccykDrWXKhD
1130	dBVKGKNutFP	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1130	dBVKGKNutFP
1131	DKdF7P7ky4F	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1131	DKdF7P7ky4F
2604	w3Vtnikkr4r	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	2604	w3Vtnikkr4r
1064	V9aklQkm2yr	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1064	V9aklQkm2yr
1132	dBfetAZt4c1	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1132	dBfetAZt4c1
1133	kQqMT67WT2W	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1133	kQqMT67WT2W
1134	ulnzx5SZRLA	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1134	ulnzx5SZRLA
1112	a1bvHu4FRCq	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1112	a1bvHu4FRCq
1136	NYb019QWhPQ	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1136	NYb019QWhPQ
1137	uBD4inblovY	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	1137	uBD4inblovY
1138	PMR2Cc13YGh	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1138	PMR2Cc13YGh
1139	KDXoiPpllM7	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1139	KDXoiPpllM7
2607	NJF59S6GI3h	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2607	NJF59S6GI3h
1140	dP3Esu3zfvR	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1140	dP3Esu3zfvR
1141	Rl44sEcQF4J	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1141	Rl44sEcQF4J
1142	a8wKUexqqyw	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1142	a8wKUexqqyw
1143	resyoKSgFWP	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1143	resyoKSgFWP
1144	RtQUimJT9Ek	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1144	RtQUimJT9Ek
1145	tSwz19SGiY4	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1145	tSwz19SGiY4
1146	PfhLA9YVg8z	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1146	PfhLA9YVg8z
1147	uJLhpdO3O7K	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1147	uJLhpdO3O7K
1148	Iw6keYNnGOk	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1148	Iw6keYNnGOk
1149	mzTzzMsXjM9	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1149	mzTzzMsXjM9
1150	js9oxW08GfX	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1150	js9oxW08GfX
1151	OltIU5j6TaY	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1151	OltIU5j6TaY
1152	aKVAF30coFQ	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1152	aKVAF30coFQ
1153	gcJKnH2Ypa2	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1153	gcJKnH2Ypa2
1154	gAYBU4aipnZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1154	gAYBU4aipnZ
1155	o6ovDOHBgez	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1155	o6ovDOHBgez
1156	aCaPqIkvV2s	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1156	aCaPqIkvV2s
1157	vPNvgAKiwMi	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1157	vPNvgAKiwMi
1158	ARBWmz1XLMI	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1158	ARBWmz1XLMI
1159	OOoyWm1xvfG	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1159	OOoyWm1xvfG
1160	P78aC0ujKWk	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1160	P78aC0ujKWk
1161	WXGWfHkIJS9	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1161	WXGWfHkIJS9
1162	MZPstrhbA2g	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1162	MZPstrhbA2g
1163	aXyuXVfPhwz	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1163	aXyuXVfPhwz
1164	aPkiP7PQgCU	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1164	aPkiP7PQgCU
1165	HjoAahqy6Yw	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1165	HjoAahqy6Yw
1166	PBqMI3x2WeG	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1166	PBqMI3x2WeG
1167	FHJczgAz2ML	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1167	FHJczgAz2ML
1168	aSxiOcCkU0C	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1168	aSxiOcCkU0C
1098	a6WHMHqHS7a	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1098	a6WHMHqHS7a
1169	YeM7sYuP1xa	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1169	YeM7sYuP1xa
1170	gDG5yDZ6hiy	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1170	gDG5yDZ6hiy
1171	CoRoHHdK9FC	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1171	CoRoHHdK9FC
1172	FH7eT8hveKf	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1172	FH7eT8hveKf
1173	FWvHZdDKXd1	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1173	FWvHZdDKXd1
1174	mPhXfTnsI3S	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1174	mPhXfTnsI3S
1175	LF0fSY2ILTy	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1175	LF0fSY2ILTy
1176	Ip1gZFlVBg7	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1176	Ip1gZFlVBg7
2428	eQX0AdRrOfu	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	2428	eQX0AdRrOfu
1177	ZA7d44nDMn9	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1177	ZA7d44nDMn9
1178	SkMZHCUnzSK	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1178	SkMZHCUnzSK
1179	abHXswMdUC4	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1179	abHXswMdUC4
1180	atNffeiZvJ7	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1180	atNffeiZvJ7
1181	aRg8TDbBLG5	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1181	aRg8TDbBLG5
2429	VOzSTeqb6FF	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	2429	VOzSTeqb6FF
1182	It68vhwjK9d	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1182	It68vhwjK9d
1183	M3Pmx8tT6Z0	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1183	M3Pmx8tT6Z0
1184	oj3kh1K3c92	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1184	oj3kh1K3c92
1185	gozR97R4Khm	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1185	gozR97R4Khm
1186	C7fvZef106g	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1186	C7fvZef106g
1187	OsIhf9n3bXq	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1187	OsIhf9n3bXq
1188	tTZFQkyysiA	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1188	tTZFQkyysiA
1189	x50dfSoQUiV	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1189	x50dfSoQUiV
1190	GXpcZGzzZld	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1190	GXpcZGzzZld
1191	a7rSAVPxSgz	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1191	a7rSAVPxSgz
1192	gzw1SzvRwhp	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1192	gzw1SzvRwhp
1193	jUjZnYO6hUP	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1193	jUjZnYO6hUP
1194	WQ0tKwuAKiu	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1194	WQ0tKwuAKiu
1195	l2rFeHo9dfd	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1195	l2rFeHo9dfd
1196	tecfO3gvavj	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1196	tecfO3gvavj
1197	afMspJFqzy0	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1197	afMspJFqzy0
1198	hriseTUfks9	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1198	hriseTUfks9
1199	a2lazVXF8h0	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1199	a2lazVXF8h0
1200	unv8Mf3d1rl	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1200	unv8Mf3d1rl
1201	YL7WGm3qhJM	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	1201	YL7WGm3qhJM
1202	akmhIvDeUc3	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1202	akmhIvDeUc3
1204	lCAzLvgKtQd	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1204	lCAzLvgKtQd
1205	L9Tu7DLXDWf	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1205	L9Tu7DLXDWf
1206	hhepptsETDL	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1206	hhepptsETDL
1207	jxS8tyaOxom	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1207	jxS8tyaOxom
1208	fATqj07PHYr	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1208	fATqj07PHYr
1209	PTydXF4vkcb	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1209	PTydXF4vkcb
1210	aNYVpLHVWVQ	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1210	aNYVpLHVWVQ
1211	L2U4GtsXEpx	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1211	L2U4GtsXEpx
1212	WwbY46nZ6GJ	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1212	WwbY46nZ6GJ
1213	LLAbaUTIKKz	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1213	LLAbaUTIKKz
1214	mx3iKoXSg9l	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	1214	mx3iKoXSg9l
1215	aIUWnrP1UkC	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	1215	aIUWnrP1UkC
1216	pYQZOdSlZAz	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1216	pYQZOdSlZAz
1217	AA8TRyfTwtn	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1217	AA8TRyfTwtn
1218	x2N6BwYSFr8	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1218	x2N6BwYSFr8
1219	LBdhCYNiWCn	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1219	LBdhCYNiWCn
1220	mqxYq0fQIXf	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1220	mqxYq0fQIXf
1221	xmBzxlSRY4r	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1221	xmBzxlSRY4r
1222	ay4fqIXfwka	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1222	ay4fqIXfwka
1223	aNQKIokHNo6	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1223	aNQKIokHNo6
1224	i7M0C7n2uB0	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1224	i7M0C7n2uB0
1225	M7EUkvZed0e	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1225	M7EUkvZed0e
1226	oEFcsYJgkHV	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1226	oEFcsYJgkHV
1227	zUlsz5QOq4e	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1227	zUlsz5QOq4e
1228	B3slkfrgMRU	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1228	B3slkfrgMRU
1229	aMbwlzLZVsf	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1229	aMbwlzLZVsf
1230	rkgET3qTHmL	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1230	rkgET3qTHmL
1231	xYDLn9Sqaac	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1231	xYDLn9Sqaac
1232	PjhyW3z1eVs	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1232	PjhyW3z1eVs
1233	JEKNYSV6wvH	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1233	JEKNYSV6wvH
1234	KAUpmFGlBgW	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1234	KAUpmFGlBgW
1235	DQc5kV0NulE	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1235	DQc5kV0NulE
1236	LkCq9TdFwPe	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1236	LkCq9TdFwPe
1237	Tk7ofkvg3K9	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	1237	Tk7ofkvg3K9
1238	oQJH7ffJs1R	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1238	oQJH7ffJs1R
1239	GzQBIYVSUhV	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1239	GzQBIYVSUhV
1240	acI8lyq9jgr	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1240	acI8lyq9jgr
1241	SazalLP46YD	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1241	SazalLP46YD
1242	yG3R0J1qk4S	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1242	yG3R0J1qk4S
1243	agP7sOujwQ7	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1243	agP7sOujwQ7
1244	dL9ehAbVZUU	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1244	dL9ehAbVZUU
1246	FWimTcTZqM5	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1246	FWimTcTZqM5
1247	tjUxvkdGJ6y	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1247	tjUxvkdGJ6y
1248	lOsKnJcNQzX	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1248	lOsKnJcNQzX
1249	BdksaWC7crj	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1249	BdksaWC7crj
1250	hzZatGLk0q7	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1250	hzZatGLk0q7
1251	kKEBeO1LL7S	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1251	kKEBeO1LL7S
1252	KD0DEkooFhS	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1252	KD0DEkooFhS
1253	aMjwtFPZA3H	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1253	aMjwtFPZA3H
1254	zGdzg5hNpYO	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1254	zGdzg5hNpYO
1255	zGvow9Y6Awr	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1255	zGvow9Y6Awr
1256	omOX1GefJV8	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1256	omOX1GefJV8
1257	O75JEwLpIwW	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1257	O75JEwLpIwW
1258	wYoqkK8QUwM	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1258	wYoqkK8QUwM
1259	H4tQzkRKUNV	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1259	H4tQzkRKUNV
1260	az05GsgiKFF	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1260	az05GsgiKFF
1261	ptvKeuNVX6s	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1261	ptvKeuNVX6s
1262	n5qiWcR51id	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1262	n5qiWcR51id
1263	ZTuSeOtiQni	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1263	ZTuSeOtiQni
1264	aMOfdLbimPZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1264	aMOfdLbimPZ
1265	GL0v8GPeUvF	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1265	GL0v8GPeUvF
1135	arG3rmRFr7R	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1135	arG3rmRFr7R
1266	BB2J33NR7Dx	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1266	BB2J33NR7Dx
1267	lQYgbIyb32L	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1267	lQYgbIyb32L
2609	d9WtGKgg65W	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2609	d9WtGKgg65W
1268	h406m6Bzo7K	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1268	h406m6Bzo7K
1269	aUF5lfBvkBv	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1269	aUF5lfBvkBv
1270	aTC9aDSibvV	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1270	aTC9aDSibvV
1271	qFIN6OqYHyT	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1271	qFIN6OqYHyT
1272	aOw1OatOZPe	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1272	aOw1OatOZPe
1273	qMYnyy4UbXl	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1273	qMYnyy4UbXl
1274	DLZHSyxD2Eu	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1274	DLZHSyxD2Eu
1275	DJpSMaBi8QN	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1275	DJpSMaBi8QN
1276	aqumUYpc1O3	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1276	aqumUYpc1O3
1277	rR0HG5n2orn	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1277	rR0HG5n2orn
1278	zbSnVGJrhQK	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1278	zbSnVGJrhQK
1279	blpraSaOXw0	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1279	blpraSaOXw0
1280	aWV1RUl4uWC	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1280	aWV1RUl4uWC
1283	h7rS7d8M2jI	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1283	h7rS7d8M2jI
1284	r19kbQBjko2	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1284	r19kbQBjko2
1285	YoysVtAL2hS	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1285	YoysVtAL2hS
1286	aTqees1o4V6	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1286	aTqees1o4V6
1287	i93w6kNOmuT	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1287	i93w6kNOmuT
1288	I7p8gyqE4lE	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1288	I7p8gyqE4lE
1289	Jty2W5j6aWP	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1289	Jty2W5j6aWP
1290	eMbM3ntRRMe	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1290	eMbM3ntRRMe
1291	FTbWW3RQjIc	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1291	FTbWW3RQjIc
1292	oWRTyNICPdf	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	1292	oWRTyNICPdf
1293	atEE4GDUI2h	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1293	atEE4GDUI2h
1294	hwebBowmZ7w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1294	hwebBowmZ7w
1245	y7RFe3e9KKO	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1245	y7RFe3e9KKO
1295	ppkMVgeDCK0	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1295	ppkMVgeDCK0
1296	McVQHO6D8M7	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1296	McVQHO6D8M7
1592	VHak0ZFer7F	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1592	VHak0ZFer7F
1297	qLxrGCn9hAN	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1297	qLxrGCn9hAN
1298	lEUPQBvOtge	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1298	lEUPQBvOtge
1299	Uzi6oqsmWod	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1299	Uzi6oqsmWod
1300	raWSnyIytKm	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	1300	raWSnyIytKm
1301	eeBbHGQ0Z2K	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1301	eeBbHGQ0Z2K
1302	LmtC4nnHnZr	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1302	LmtC4nnHnZr
1303	VSxYEJhhOT4	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1303	VSxYEJhhOT4
1304	coddMVYZDBC	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1304	coddMVYZDBC
1305	x6skp5j1Sww	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1305	x6skp5j1Sww
1306	RkdZOxEbO4w	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1306	RkdZOxEbO4w
1307	TUXZLkFga0q	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1307	TUXZLkFga0q
1308	ezgM4Z4aWIc	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1308	ezgM4Z4aWIc
1309	pv2sbE1glyI	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	1309	pv2sbE1glyI
1310	VeSVU5gWpPv	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	1310	VeSVU5gWpPv
1311	u15TM0AiEC3	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1311	u15TM0AiEC3
1312	q6pj00ArvMt	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1312	q6pj00ArvMt
1313	aXKgezTIy3F	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1313	aXKgezTIy3F
1314	tzIWNdJGfLJ	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1314	tzIWNdJGfLJ
1315	w8tQUCOIBLf	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	1315	w8tQUCOIBLf
1316	gtYMnQp5i5d	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1316	gtYMnQp5i5d
1317	o2AmXGnxfGy	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1317	o2AmXGnxfGy
1318	RPWh7oVz9kg	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1318	RPWh7oVz9kg
1319	wZVOGC8j9Wu	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1319	wZVOGC8j9Wu
1320	Mg6A6eQOMWJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1320	Mg6A6eQOMWJ
1321	te7XHeZeaId	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1321	te7XHeZeaId
1322	Bsrkpxh3yzN	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1322	Bsrkpxh3yzN
1323	Y60BygAP9NH	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1323	Y60BygAP9NH
1378	weGoxVGJism	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1378	weGoxVGJism
1325	p8sjPfR588j	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1325	p8sjPfR588j
1326	QRDEYBjoQkE	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1326	QRDEYBjoQkE
1327	cLqDIzGpHIA	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1327	cLqDIzGpHIA
1328	MZQeEUso8Um	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1328	MZQeEUso8Um
1329	vNdP5dtds30	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1329	vNdP5dtds30
1330	fjuPviYKfGN	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1330	fjuPviYKfGN
1331	xR3tMZhXRSG	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1331	xR3tMZhXRSG
1332	eJ6V2fUvJa3	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1332	eJ6V2fUvJa3
1333	ZXKYB8MLZ0N	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1333	ZXKYB8MLZ0N
1281	K8EbLIWv4gn	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1281	K8EbLIWv4gn
1334	XziArrrpUNq	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1334	XziArrrpUNq
1335	cK0HH9ZqvdJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1335	cK0HH9ZqvdJ
1336	XI6wsL7BBbu	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1336	XI6wsL7BBbu
1337	aPcTrAQZUXQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1337	aPcTrAQZUXQ
1338	lmgYdspcL6p	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1338	lmgYdspcL6p
1339	IlCTmTQDK1j	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1339	IlCTmTQDK1j
1340	mzN07vjeNN8	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1340	mzN07vjeNN8
1341	aeWGRzEMtRa	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1341	aeWGRzEMtRa
1342	PFmDufIDfGB	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1342	PFmDufIDfGB
1343	Nc5nlJywn4F	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1343	Nc5nlJywn4F
1344	NFhTAn0f77V	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1344	NFhTAn0f77V
1282	YRxg8b8P3CN	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1282	YRxg8b8P3CN
1345	MobV3oxRvud	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1345	MobV3oxRvud
1203	Qf74g7IuA7j	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1203	Qf74g7IuA7j
1346	m1aZdsy6aOH	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1346	m1aZdsy6aOH
1347	Ler1BWHg56d	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1347	Ler1BWHg56d
1348	IkJ8rVHyW5X	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1348	IkJ8rVHyW5X
1349	AzKsBz4epB3	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1349	AzKsBz4epB3
1350	LBmenMWrESK	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1350	LBmenMWrESK
1351	mbruZc0Y2Wv	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1351	mbruZc0Y2Wv
1352	aXiw1i9etPS	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1352	aXiw1i9etPS
1354	gSrojZccMJ7	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1354	gSrojZccMJ7
1355	C8KGSaxhXaQ	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1355	C8KGSaxhXaQ
1356	cXuZrvRWFcg	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1356	cXuZrvRWFcg
1357	QT2X5ExHi0h	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1357	QT2X5ExHi0h
1358	aT8hmwXQ07D	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1358	aT8hmwXQ07D
1359	rR2AOks4tG6	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1359	rR2AOks4tG6
1360	t9AXNBpffmR	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1360	t9AXNBpffmR
1361	sIxtI5tcPqo	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1361	sIxtI5tcPqo
1362	c2axH7WAdTn	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1362	c2axH7WAdTn
1363	QnyFjJrR0jW	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1363	QnyFjJrR0jW
1364	nFhF5jPXNM8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1364	nFhF5jPXNM8
1365	EkLjk71mOyH	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1365	EkLjk71mOyH
1366	H5dzLI03le7	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1366	H5dzLI03le7
1367	N38gC3CNUib	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1367	N38gC3CNUib
1368	spa5nU4NVar	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1368	spa5nU4NVar
1369	gtOP1Uo7oOx	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1369	gtOP1Uo7oOx
1370	vLujVIJd0j7	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1370	vLujVIJd0j7
1371	cCy6kanD5Hw	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1371	cCy6kanD5Hw
1372	qZxQw5vhQmN	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1372	qZxQw5vhQmN
1373	eSxa9KsHr5h	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1373	eSxa9KsHr5h
1375	rVlOahJhyvJ	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1375	rVlOahJhyvJ
1376	Uuo4aSz4x5g	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1376	Uuo4aSz4x5g
1377	oSEii1BuIbC	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1377	oSEii1BuIbC
1379	S6TrG4cNUIZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1379	S6TrG4cNUIZ
1380	Q9dlhYRxdUL	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1380	Q9dlhYRxdUL
1382	OpD74f0SyGI	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1382	OpD74f0SyGI
1383	VTWueywhLKE	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1383	VTWueywhLKE
1384	sXpYXsXppVM	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1384	sXpYXsXppVM
1385	jpCB71nqbJu	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1385	jpCB71nqbJu
1386	Q94ayRFilbA	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1386	Q94ayRFilbA
1387	acQJJL9aUo0	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1387	acQJJL9aUo0
1388	apKpog39DlX	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1388	apKpog39DlX
1389	Fi0oIAe06s4	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1389	Fi0oIAe06s4
1391	muPPh3RbpBj	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1391	muPPh3RbpBj
1392	azZk0TJOe3j	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1392	azZk0TJOe3j
1393	aBmWpMfBVjr	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1393	aBmWpMfBVjr
1394	p1iOb5SBsBd	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1394	p1iOb5SBsBd
1395	qbyIofSU5tA	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1395	qbyIofSU5tA
1396	YM9WoJWgiZk	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1396	YM9WoJWgiZk
1397	MaMG7y4TKz4	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1397	MaMG7y4TKz4
2598	cPS96oUSKL7	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	2598	cPS96oUSKL7
1398	UNiDU0Y3r2i	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1398	UNiDU0Y3r2i
1399	NmKQP1XcgKJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1399	NmKQP1XcgKJ
1400	yTUn4OdHAs4	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1400	yTUn4OdHAs4
1401	lbIyDdBijdD	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1401	lbIyDdBijdD
1374	PrIDcobIQsW	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1374	PrIDcobIQsW
1402	XWHw6fTKtoE	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1402	XWHw6fTKtoE
1403	CPvpbCc51Aw	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1403	CPvpbCc51Aw
1404	ag7SEvoulDA	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1404	ag7SEvoulDA
1405	ERioiaRYt58	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1405	ERioiaRYt58
1406	g4jN39Mu4K8	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1406	g4jN39Mu4K8
1407	BBqkdNv0rk1	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1407	BBqkdNv0rk1
1408	xFPP0xRg2AV	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1408	xFPP0xRg2AV
1409	y5VwP02ADlq	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1409	y5VwP02ADlq
1410	aZAE15J3Zb1	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1410	aZAE15J3Zb1
1411	ZZmXu10Dnci	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1411	ZZmXu10Dnci
1412	Lv7IX3Xxutv	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1412	Lv7IX3Xxutv
1413	Y5n22tapmhs	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1413	Y5n22tapmhs
1575	VvSRAEcdc5o	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1575	VvSRAEcdc5o
1353	XAYIceYQGIl	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1353	XAYIceYQGIl
1414	J9Q5GilXIvy	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1414	J9Q5GilXIvy
1415	hMmTuvB73LZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1415	hMmTuvB73LZ
1416	vhBrLJBbs8t	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1416	vhBrLJBbs8t
1417	bZBIK5nSjJS	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1417	bZBIK5nSjJS
1418	igvemwDsp2j	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1418	igvemwDsp2j
1419	iDEPY2bO8nQ	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1419	iDEPY2bO8nQ
1420	a4OYFNcMXZO	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1420	a4OYFNcMXZO
1421	PNnzRWEmz8V	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1421	PNnzRWEmz8V
1422	QjFwopEl3i9	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1422	QjFwopEl3i9
1423	rWKu3uQbesz	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1423	rWKu3uQbesz
1424	Zb0o00tdmnx	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1424	Zb0o00tdmnx
1425	j9JRmkoveVc	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1425	j9JRmkoveVc
1426	hZA6Q0HfT0V	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1426	hZA6Q0HfT0V
1427	gijuR34Jj5H	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1427	gijuR34Jj5H
1428	EgcvIoAN7Ti	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1428	EgcvIoAN7Ti
1390	xEGUTFJd2LB	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1390	xEGUTFJd2LB
1429	OoSjd5RuEQb	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1429	OoSjd5RuEQb
2599	C8B19BSd474	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	2599	C8B19BSd474
1430	b24YFQUhFfF	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1430	b24YFQUhFfF
1431	lHy3V8wTvjA	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1431	lHy3V8wTvjA
1432	HMzXFZXwkDG	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1432	HMzXFZXwkDG
1433	OKIyTJatyIr	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1433	OKIyTJatyIr
1434	WIp1921a57B	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1434	WIp1921a57B
1435	wMj4Uco2mMl	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1435	wMj4Uco2mMl
1436	zzl9JUHMQY1	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1436	zzl9JUHMQY1
1437	elu8zUTsqIW	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1437	elu8zUTsqIW
1438	IC4N267eDYG	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1438	IC4N267eDYG
1439	HGPMh3r18FZ	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1439	HGPMh3r18FZ
1440	kRF4X846xVW	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1440	kRF4X846xVW
1569	Whc0SWU4T5n	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1569	Whc0SWU4T5n
1441	nLCKvxD90Ek	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1441	nLCKvxD90Ek
2357719	GIXkEmjvUPh	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	2357719	GIXkEmjvUPh
1442	a1HgVn8Q288	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1442	a1HgVn8Q288
1443	KhXTdz48N9o	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1443	KhXTdz48N9o
1444	YxleBIY0wms	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1444	YxleBIY0wms
1445	B4c4U2wA0w0	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1445	B4c4U2wA0w0
1446	N00GWUvXv52	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1446	N00GWUvXv52
1447	axeaTpoaevL	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1447	axeaTpoaevL
1448	kVC2XemQfB6	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1448	kVC2XemQfB6
1449	aQuFXdkixjd	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1449	aQuFXdkixjd
1576	jAd3Yz8eWoM	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1576	jAd3Yz8eWoM
1450	JxlOhSzW8GJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1450	JxlOhSzW8GJ
1451	Uf7qbLumqbn	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1451	Uf7qbLumqbn
1452	gqlcWIrj9J3	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1452	gqlcWIrj9J3
1453	X3w6hzHSdUe	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1453	X3w6hzHSdUe
1454	mJidDmRCdn8	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1454	mJidDmRCdn8
1455	tlIMKbS5bmI	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1455	tlIMKbS5bmI
1456	SE5V8TUKQnZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1456	SE5V8TUKQnZ
1457	hrxNQMA6PNu	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1457	hrxNQMA6PNu
1458	DyMUZat98Gm	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1458	DyMUZat98Gm
1573	spJaE9AvZmf	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1573	spJaE9AvZmf
1459	HoW0caoiLjf	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1459	HoW0caoiLjf
1460	K9pBdHdIp6Z	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1460	K9pBdHdIp6Z
1627	tt9yUB7IjHC	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1627	tt9yUB7IjHC
1461	CyUUpNIQ98L	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1461	CyUUpNIQ98L
1462	GhrSbqvL2At	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	1462	GhrSbqvL2At
1463	SjjQnm5MK1W	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1463	SjjQnm5MK1W
1464	iFx5B3JZNWU	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1464	iFx5B3JZNWU
1465	aSNralWoVvR	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1465	aSNralWoVvR
6957	WnFW4rCaYbF	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	6957	WnFW4rCaYbF
1467	FsrPvHIMo4j	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1467	FsrPvHIMo4j
1468	RIRO5KSi82T	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1468	RIRO5KSi82T
1469	qD90qvNgVtw	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1469	qD90qvNgVtw
1470	Gxs5KLq9tWr	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1470	Gxs5KLq9tWr
1471	aazt2Bo4gk8	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1471	aazt2Bo4gk8
1472	wCiHoNAAXNp	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1472	wCiHoNAAXNp
1473	oweSpFBNbmi	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1473	oweSpFBNbmi
1474	iYyORXQ8Z6h	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1474	iYyORXQ8Z6h
1475	W9JVeFCwE5n	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1475	W9JVeFCwE5n
1476	ase3dyB86hx	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1476	ase3dyB86hx
1477	L91J9E1sJbc	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1477	L91J9E1sJbc
1478	mV8AQZkSf3K	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1478	mV8AQZkSf3K
1479	PFkULd44r0L	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1479	PFkULd44r0L
1594	ipjC8RjDoJ0	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1594	ipjC8RjDoJ0
1595	hNN2wZnydEg	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1595	hNN2wZnydEg
1480	aBJcRBYVnCc	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1480	aBJcRBYVnCc
1481	h6Wx2ZuKWJ3	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1481	h6Wx2ZuKWJ3
1482	aqtHhUruLLD	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1482	aqtHhUruLLD
1483	T06zMrtvVyD	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1483	T06zMrtvVyD
1484	gW8zDLtLKRw	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1484	gW8zDLtLKRw
1485	rFcB1UxSU9H	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1485	rFcB1UxSU9H
1486	tjDQAJuamDX	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1486	tjDQAJuamDX
1487	DMJIQmR8GNr	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1487	DMJIQmR8GNr
1488	KG4Ns1Klr2C	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1488	KG4Ns1Klr2C
1489	ykAaC6ZBwGO	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1489	ykAaC6ZBwGO
1324	a7R6lzPJHUN	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1324	a7R6lzPJHUN
1490	aBKUgg9eMEK	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1490	aBKUgg9eMEK
1491	S1nFWV7Ij1f	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1491	S1nFWV7Ij1f
1492	xRBoyoffMdY	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1492	xRBoyoffMdY
1493	aQtZqGVl9u2	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1493	aQtZqGVl9u2
1494	s9FltYF4w25	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1494	s9FltYF4w25
1495	PpJwAqyUEAw	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1495	PpJwAqyUEAw
1496	FV5oHVJGVQj	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1496	FV5oHVJGVQj
1497	ubp4U8p1EGD	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1497	ubp4U8p1EGD
1498	M3o19feuYfH	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1498	M3o19feuYfH
1499	El1yfqR0BNT	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1499	El1yfqR0BNT
1500	qgAScVAF3qQ	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1500	qgAScVAF3qQ
1501	zXzgzNuexTY	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1501	zXzgzNuexTY
1502	DUP58MfrOO5	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1502	DUP58MfrOO5
1503	anYY2nbOTA5	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1503	anYY2nbOTA5
1504	aLbdtQFDIfU	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1504	aLbdtQFDIfU
1505	y1eq9C6oPWj	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1505	y1eq9C6oPWj
1506	E2ZDSHzpE6w	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1506	E2ZDSHzpE6w
1507	OelY0OuJRrh	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1507	OelY0OuJRrh
1508	AyD2uS3F3Jb	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1508	AyD2uS3F3Jb
1509	Bk8WGRJ6zC2	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1509	Bk8WGRJ6zC2
1510	d8G3QcJpzxC	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1510	d8G3QcJpzxC
1511	QeI9XXwoy2h	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1511	QeI9XXwoy2h
1512	dS6Xrka1WwD	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1512	dS6Xrka1WwD
1513	PQEJbD9Vybo	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1513	PQEJbD9Vybo
1514	aqJaciRotCj	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1514	aqJaciRotCj
1515	jkd1XWIp0ZR	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1515	jkd1XWIp0ZR
1516	y8ZoiFCNV8W	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1516	y8ZoiFCNV8W
1517	M9l386COmzm	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1517	M9l386COmzm
1617	qp2LM87D7ie	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1617	qp2LM87D7ie
1518	XB8o8p7f97z	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1518	XB8o8p7f97z
2605	HITX9bsKQwR	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2605	HITX9bsKQwR
2603	x3s74yCtzFy	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	2603	x3s74yCtzFy
1519	DPDFR2NSNL4	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1519	DPDFR2NSNL4
1520	p4JCTAyEhij	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1520	p4JCTAyEhij
1521	aifNCvFFHYu	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1521	aifNCvFFHYu
1522	HlBP6Xv1pEx	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1522	HlBP6Xv1pEx
1523	audl05CJPvD	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1523	audl05CJPvD
1524	a98vV85q7VA	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1524	a98vV85q7VA
1525	uyxasfC9cr3	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1525	uyxasfC9cr3
1526	S4m2TKOXxUp	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1526	S4m2TKOXxUp
1527	mj0OwLAoGxj	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1527	mj0OwLAoGxj
1528	U3F1jMS8CYd	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1528	U3F1jMS8CYd
1529	fISqLilkoLm	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1529	fISqLilkoLm
1530	aKJnwPPfPhk	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1530	aKJnwPPfPhk
1531	ys2eaRzu6MB	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1531	ys2eaRzu6MB
1532	xnqsEM3TxbR	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1532	xnqsEM3TxbR
1533	a0awJjtBQ2u	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1533	a0awJjtBQ2u
1534	c3RuJBL6y2x	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1534	c3RuJBL6y2x
1535	ak477N3SWYO	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1535	ak477N3SWYO
1537	kw9oIuVNzcJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1537	kw9oIuVNzcJ
1538	XdqPw4hn5nq	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1538	XdqPw4hn5nq
1539	fIAdaHNM2zm	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1539	fIAdaHNM2zm
1540	FngcsacEaM4	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1540	FngcsacEaM4
1541	q1TxlOLZPqV	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1541	q1TxlOLZPqV
1542	OR4TRYV75lr	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1542	OR4TRYV75lr
1543	vleQsSrMRcT	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1543	vleQsSrMRcT
1544	ugewbq4RtKN	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	1544	ugewbq4RtKN
1545	vJLeTItF2kD	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1545	vJLeTItF2kD
1546	NwjAOvrcNuU	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1546	NwjAOvrcNuU
1570	a9Gy7Imvd9F	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1570	a9Gy7Imvd9F
1571	aNvDakWiwMs	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1571	aNvDakWiwMs
2357613	qfSk8i2Td5s	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	2357613	qfSk8i2Td5s
1618	abrPOGp0zoG	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1618	abrPOGp0zoG
1623	WWilgFGBjBC	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1623	WWilgFGBjBC
1624	GuJonnL9KkC	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1624	GuJonnL9KkC
1547	l4qmCfoNbn6	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1547	l4qmCfoNbn6
1612	Anb2BySBeLP	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1612	Anb2BySBeLP
1548	Fz23SXgkfYc	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1548	Fz23SXgkfYc
1549	y1iun1mJXWa	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1549	y1iun1mJXWa
1550	EAw4NikTilV	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1550	EAw4NikTilV
1551	qrGzd0QTgxt	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1551	qrGzd0QTgxt
1552	IlAqwJZzL40	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	1552	IlAqwJZzL40
1553	YD8E2vpUOTX	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1553	YD8E2vpUOTX
1381	aotTeLfiAZB	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1381	aotTeLfiAZB
1554	QMYSsdVCuem	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1554	QMYSsdVCuem
1556	V8DloIhJgVB	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1556	V8DloIhJgVB
1593	UjUroihV9AC	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1593	UjUroihV9AC
1557	PaitbhdeU8f	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1557	PaitbhdeU8f
1558	GSj56KTqJRQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1558	GSj56KTqJRQ
1559	xfJuqAwolQi	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1559	xfJuqAwolQi
1560	KIukjQefWsY	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1560	KIukjQefWsY
1561	uO3WnJBCEq5	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1561	uO3WnJBCEq5
1562	W6dgKKl8WCg	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1562	W6dgKKl8WCg
1563	wysZBhhaSaS	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1563	wysZBhhaSaS
1564	LyX5VLc9Eyz	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1564	LyX5VLc9Eyz
1555	mnk10FugmGB	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1555	mnk10FugmGB
1565	OVrhhkOMbwS	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1565	OVrhhkOMbwS
1566	eYw6xfpMCpt	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1566	eYw6xfpMCpt
1567	EJCiKQCS6WT	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1567	EJCiKQCS6WT
1628	uB3nFQ5y73Z	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1628	uB3nFQ5y73Z
1629	Q1zNSRAbxjf	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1629	Q1zNSRAbxjf
1630	kOu6Jeco0Gs	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1630	kOu6Jeco0Gs
1631	WPNKWhyNTT3	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1631	WPNKWhyNTT3
1577	qPxhlMvCde5	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1577	qPxhlMvCde5
1578	BeLWlF7oliH	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1578	BeLWlF7oliH
194	akV6429SUqu	1	194	akV6429SUqu	\N	\N	\N	\N	\N	\N
197	VA90IqaI4Ji	2	194	akV6429SUqu	197	VA90IqaI4Ji	\N	\N	\N	\N
198	adZ6T35ve4h	2	194	akV6429SUqu	198	adZ6T35ve4h	\N	\N	\N	\N
899561	ecZgt4pokn4	2	194	akV6429SUqu	899561	ecZgt4pokn4	\N	\N	\N	\N
195	pz9Uu65Irbg	2	194	akV6429SUqu	195	pz9Uu65Irbg	\N	\N	\N	\N
196	auJdpeHbeet	2	194	akV6429SUqu	196	auJdpeHbeet	\N	\N	\N	\N
227	NREoMszwQZW	3	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	\N	\N
228	QYiQ2KqgCxj	3	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	\N	\N
229	ztIyIYAzFKp	3	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	\N	\N
230	p7EEgDEX3jT	3	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	\N	\N
231	ZuQHWOaFQVM	3	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	\N	\N
232	a8RHFdF4DXL	3	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	\N	\N
233	TM6ccNxawqy	3	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	\N	\N
213	C0RSe3EWBqU	3	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	\N	\N
234	JyZJhGXKeEq	3	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	\N	\N
235	WcB3kLlgRTb	3	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	\N	\N
236	kb7iUQISRlx	3	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	\N	\N
309	AhwgeZQYj16	3	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	\N	\N
237	gUaoj8Geuao	3	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	\N	\N
209	sWoNWQZ9qrD	3	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	\N	\N
199	x75Yh65MaUa	3	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	\N	\N
276	tdZbtg9sZkO	3	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	\N	\N
280	Ame30QOwuX6	3	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	\N	\N
272	e8m9ZYMRoeR	3	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	\N	\N
283	auLatLbcOxf	3	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	\N	\N
288	CQTmrrriwOq	3	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	\N	\N
211	g8M1cWRJZV6	3	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	\N	\N
223	It5UGwdHAPF	3	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	\N	\N
226	lkuO79O6mRx	3	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	\N	\N
239	MtpE3CH6vq3	3	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	\N	\N
240	a3LMKP8z8Xj	3	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	\N	\N
241	aZLZPPjqft0	3	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	\N	\N
242	F3ccON3OCsL	3	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	\N	\N
243	wMQ25dybdgH	3	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	\N	\N
244	lQj3yMM1lI7	3	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	\N	\N
245	Gwk4wkLz7EW	3	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	\N	\N
246	PJFtfCyp6Rb	3	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	\N	\N
269	r8WLxW9JwsS	3	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	\N	\N
247	oNxpMjveyZt	3	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	\N	\N
248	UaR7OHycj8c	3	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	\N	\N
249	aJR2ZxSH7g4	3	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	\N	\N
251	eOJUW6OGpc7	3	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	\N	\N
257	zBIpPzKYFLp	3	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	\N	\N
250	m77oR1YJESj	3	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	\N	\N
252	QoRZB7xc3j9	3	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	\N	\N
253	JrHILmtK0OU	3	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	\N	\N
254	kJCEJnXLgnh	3	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	\N	\N
255	ahyi8Uq4vaj	3	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	\N	\N
262	aXmBzv61LbM	3	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	\N	\N
263	oyygQ2STBST	3	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	\N	\N
203	uCVQXAdKqL9	3	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	\N	\N
307	aphcy5JTnd6	3	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	\N	\N
204	aginheWSLef	3	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	\N	\N
205	aa8xVDzSpte	3	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	\N	\N
206	cSrCFjPKqcG	3	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	\N	\N
207	ykxQEnZGXkj	3	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	\N	\N
208	tM3DsJxMaMX	3	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	\N	\N
302	GLHh0BXys9w	3	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	\N	\N
303	Oyxwe3iDqpR	3	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	\N	\N
305	qf9xWZu7Dq8	3	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	\N	\N
304	B0G9cqixld8	3	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	\N	\N
308	aPhSZRinfbg	3	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	\N	\N
264	pnTVIF5v27r	3	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	\N	\N
266	iqsaGItA68C	3	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	\N	\N
289	Y4LV8xqkv6J	3	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	\N	\N
287	aPZzL4CyBTg	3	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	\N	\N
221	saT18HClZoz	3	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	\N	\N
267	h1O9AvNR4jS	3	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	\N	\N
268	IVuiLJYABw6	3	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	\N	\N
270	a9tQqo1rSj7	3	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	\N	\N
278	O9MoQcpZ4uA	3	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	\N	\N
281	xy0M4HhjXtD	3	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	\N	\N
271	Lj8t70RYnEt	3	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	\N	\N
214	hn1AlYtF1Pu	3	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	\N	\N
284	tr9XWtYsL5P	3	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	\N	\N
286	aqpd0Y9eXZ2	3	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	\N	\N
200	aPRNSGUR3vk	3	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	\N	\N
210	JIZDvNlIhXS	3	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	\N	\N
216	WyR8Eetj7Uw	3	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	\N	\N
219	bIONCoCnt3Q	3	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	\N	\N
224	xr8EMirOASp	3	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	\N	\N
256	mv4gKtY0qW8	3	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	\N	\N
258	yuo5ielNL7W	3	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	\N	\N
259	auswb7JO9wY	3	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	\N	\N
899614	CKgGrgTdDiW	3	194	akV6429SUqu	899561	ecZgt4pokn4	899614	CKgGrgTdDiW	\N	\N
260	FLygHiUd2UW	3	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	\N	\N
261	Q7PaNIbyZII	3	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	\N	\N
277	A9kRCvmn6Co	3	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	\N	\N
274	W0kQBddyGyh	3	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	\N	\N
275	YMMexeHFUay	3	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	\N	\N
291	lzWuB6bCQeV	3	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	\N	\N
218	a0DfYpC2Rwl	3	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	\N	\N
292	VuHCApXcMTm	3	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	\N	\N
293	aSbgVKaeCP0	3	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	\N	\N
294	aUcYGQCK9ub	3	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	\N	\N
295	Ut0ysYGEipO	3	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	\N	\N
296	esIUe2tQAtL	3	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	\N	\N
297	EDhGji3EteB	3	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	\N	\N
298	Xjc0LDFa5gW	3	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	\N	\N
299	aj4hsYK3dVm	3	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	\N	\N
300	z8D9ER36EKN	3	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	\N	\N
301	hAoe9dhZh9V	3	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	\N	\N
310	zNgVoDVPYgD	3	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	\N	\N
913191	DAfT22pPqzk	3	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	\N	\N
201	aXjub1BYn1y	3	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	\N	\N
265	xpIFdCMhVHG	3	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	\N	\N
306	aBrjuZk0W31	3	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	\N	\N
202	WiVj4bEhX4P	3	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	\N	\N
279	P8iz90eiIrW	3	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	\N	\N
238	fS71jg1WYPk	3	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	\N	\N
285	tugqr4dY6wq	3	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	\N	\N
290	j7AQsnEYmvi	3	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	\N	\N
212	zJfpujxC1kD	3	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	\N	\N
215	xAJgEKKAeRA	3	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	\N	\N
282	wJ2a6YKDFZW	3	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	\N	\N
217	srmGjHrpVE5	3	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	\N	\N
220	KhT80mlwJ3Y	3	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	\N	\N
222	aIahLLmtvgT	3	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	\N	\N
225	W1JM2Qdhcv3	3	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	\N	\N
273	A4aGXEfdb8P	3	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	\N	\N
1596	i8gkuINdorl	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1596	i8gkuINdorl
1597	xT38Pbk8s4j	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1597	xT38Pbk8s4j
1625	YjjiR3pf7GD	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1625	YjjiR3pf7GD
1585	xuuOj2eAPqb	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1585	xuuOj2eAPqb
1598	jM15KbiS4KY	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1598	jM15KbiS4KY
1599	A8Xv1XbkdrA	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1599	A8Xv1XbkdrA
1600	SVXuVZuvsit	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1600	SVXuVZuvsit
1601	XTljgoHlV32	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	1601	XTljgoHlV32
1602	vy4wRPZvp83	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1602	vy4wRPZvp83
1603	mhMXhrnEHGU	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1603	mhMXhrnEHGU
1604	NKIjT6Gi8Z3	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1604	NKIjT6Gi8Z3
1605	amLhY9BnViS	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1605	amLhY9BnViS
1606	IcEOvr6u0b6	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1606	IcEOvr6u0b6
1607	tfAnfdXJwCW	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1607	tfAnfdXJwCW
311	d9BOrS0TD0v	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	311	d9BOrS0TD0v
312	LWUX581FhMd	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	312	LWUX581FhMd
313	FihNC5KfGJV	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	313	FihNC5KfGJV
314	AABKGoyjpm2	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	314	AABKGoyjpm2
315	Lo367kZNoT7	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	315	Lo367kZNoT7
316	fSyCcycKdSl	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	316	fSyCcycKdSl
1579	fZFfFLzQrxM	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1579	fZFfFLzQrxM
332	a5Rsb7b0H2V	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	332	a5Rsb7b0H2V
317	iTWrGnwCEOJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	317	iTWrGnwCEOJ
318	oslXMLLbQdv	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	318	oslXMLLbQdv
319	OvJyCqX93Di	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	319	OvJyCqX93Di
320	lhKxF8mfub4	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	320	lhKxF8mfub4
321	msdmNNK8OGv	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	321	msdmNNK8OGv
338	NC1BI24zrtd	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	338	NC1BI24zrtd
322	pTX9sgiNkqB	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	322	pTX9sgiNkqB
323	cdnlhhlkqJ1	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	323	cdnlhhlkqJ1
324	ak3LSCYUzzc	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	324	ak3LSCYUzzc
333	FNqGR9apfAN	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	333	FNqGR9apfAN
325	eaiTceKCzoa	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	325	eaiTceKCzoa
326	vwDbo5apOm9	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	326	vwDbo5apOm9
334	MfQUi3dPpvc	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	334	MfQUi3dPpvc
327	DTtuY2aAGcc	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	327	DTtuY2aAGcc
335	zLlDlWXIaK6	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	335	zLlDlWXIaK6
328	RXmpTec0meY	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	328	RXmpTec0meY
329	ae3r7yqNpat	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	329	ae3r7yqNpat
330	asCoXu0PHpL	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	330	asCoXu0PHpL
331	ZSY4OdZ4iAx	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	331	ZSY4OdZ4iAx
336	yeA4jdSqetI	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	336	yeA4jdSqetI
2597	rD922anbNzS	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	2597	rD922anbNzS
341	P1IYVDrz7rL	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	341	P1IYVDrz7rL
342	BXgAR3Kq8kv	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	342	BXgAR3Kq8kv
343	un9dv9VS0Cd	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	343	un9dv9VS0Cd
344	fT98rg0rZFy	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	344	fT98rg0rZFy
337	Qr8y4NcchsS	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	337	Qr8y4NcchsS
345	NluQOzhboUd	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	345	NluQOzhboUd
346	khzscd51sFY	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	346	khzscd51sFY
347	wDNV7tv3hzP	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	347	wDNV7tv3hzP
348	z0vS3kFxDjc	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	348	z0vS3kFxDjc
339	QmOEotRpx4w	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	339	QmOEotRpx4w
349	FdQo42NAOxF	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	349	FdQo42NAOxF
351	B9NWy5hoq0C	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	351	B9NWy5hoq0C
352	UC5oDg6aLRl	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	352	UC5oDg6aLRl
1580	ObP05tDjGoW	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1580	ObP05tDjGoW
1581	D06Hv2GofVa	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1581	D06Hv2GofVa
1582	JvF5JZK4OIl	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1582	JvF5JZK4OIl
1583	acwO6ZCWJj7	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1583	acwO6ZCWJj7
1584	YG7bSJaIniu	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1584	YG7bSJaIniu
350	g6FnEMkJC9Q	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	350	g6FnEMkJC9Q
1590	DjqXZ26I2cN	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	1590	DjqXZ26I2cN
2596	Z5sUKqQ2Dj9	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	2596	Z5sUKqQ2Dj9
340	DqOwtu7833e	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	340	DqOwtu7833e
1613	t89pNBmJnKW	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1613	t89pNBmJnKW
1614	zmqrtMA7R5I	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1614	zmqrtMA7R5I
353	fXF5EXLOSdC	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	353	fXF5EXLOSdC
354	jtCFBhcCIrW	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	354	jtCFBhcCIrW
355	aizpwKYoKtN	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	355	aizpwKYoKtN
356	M0i3WV2BrFk	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	356	M0i3WV2BrFk
361	fu6SGxjqBEm	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	361	fu6SGxjqBEm
357	R7ff2hyU6vl	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	357	R7ff2hyU6vl
358	WS9RVsVKaPl	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	358	WS9RVsVKaPl
359	NvldsxeQgJf	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	359	NvldsxeQgJf
360	O29YQnbcXRf	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	360	O29YQnbcXRf
362	e1uAyULbNqU	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	362	e1uAyULbNqU
363	ZCER8MJ2DeP	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	363	ZCER8MJ2DeP
364	Qw1HTN8srXZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	364	Qw1HTN8srXZ
365	GUNcDwlsQYQ	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	365	GUNcDwlsQYQ
366	rXllRge31pf	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	366	rXllRge31pf
367	tJbdFuiO6tY	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	367	tJbdFuiO6tY
368	BJc6aAKfEdk	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	368	BJc6aAKfEdk
369	y2tqwpJlSZd	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	369	y2tqwpJlSZd
370	ZfKPEEqgxDY	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	370	ZfKPEEqgxDY
371	OuGhhbtALJT	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	371	OuGhhbtALJT
372	wDG9YN30TtI	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	372	wDG9YN30TtI
373	hQNlx67qNxz	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	373	hQNlx67qNxz
374	EpK05gvAmQd	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	374	EpK05gvAmQd
1619	XDyiOGArIT7	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1619	XDyiOGArIT7
1620	ftLtvhHg24p	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1620	ftLtvhHg24p
1621	hCqsW3kUlSL	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1621	hCqsW3kUlSL
1622	tAM0excypCp	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1622	tAM0excypCp
375	nd7BxeKY0BC	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	375	nd7BxeKY0BC
376	RHEU4J1wJiy	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	376	RHEU4J1wJiy
377	EQzZv91U9wT	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	377	EQzZv91U9wT
378	OkLwuZ0WpVb	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	378	OkLwuZ0WpVb
379	APscKx450Qa	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	379	APscKx450Qa
380	NEw9nvySGeM	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	380	NEw9nvySGeM
381	aaCfJhBmGNy	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	381	aaCfJhBmGNy
382	mXkgYpPVevL	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	382	mXkgYpPVevL
384	eVqTzYtYuI7	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	384	eVqTzYtYuI7
383	aMxU0CjFNiG	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	383	aMxU0CjFNiG
385	a6U3yalrRlI	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	385	a6U3yalrRlI
386	yOGnbMFrKQh	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	386	yOGnbMFrKQh
387	kGk6ZytfQ1R	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	387	kGk6ZytfQ1R
1608	kTswDBmRkXI	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1608	kTswDBmRkXI
1609	TibfOVehAIg	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1609	TibfOVehAIg
388	VFQwTt1dbwy	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	388	VFQwTt1dbwy
389	eFewDBgvkUo	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	389	eFewDBgvkUo
390	da7lLykmZrk	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	390	da7lLykmZrk
391	lN73pdksWUB	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	391	lN73pdksWUB
392	hVS9ex07Opz	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	392	hVS9ex07Opz
393	IEjbPvDOXTU	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	393	IEjbPvDOXTU
394	aRxbH61glg4	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	394	aRxbH61glg4
395	aNr9ajfdR2q	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	395	aNr9ajfdR2q
396	ugKCZ7kJQPh	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	396	ugKCZ7kJQPh
397	wJ1jKBQsVHw	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	397	wJ1jKBQsVHw
409	XD1KW6zzsZW	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	409	XD1KW6zzsZW
410	OZTaLjgTD2w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	410	OZTaLjgTD2w
398	SXrFhwJB3wi	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	398	SXrFhwJB3wi
399	WzfWcG6I4e6	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	399	WzfWcG6I4e6
400	rKLL7VlbL3b	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	400	rKLL7VlbL3b
411	AgYgZ65N9vd	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	411	AgYgZ65N9vd
412	O2dHlvX1nZV	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	412	O2dHlvX1nZV
413	FjaBJw5pfW8	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	413	FjaBJw5pfW8
414	xb87C9pAYuF	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	414	xb87C9pAYuF
415	zzuqkx8GWNy	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	415	zzuqkx8GWNy
416	TQCB9RroT0I	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	416	TQCB9RroT0I
417	gzratsgHCh4	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	417	gzratsgHCh4
418	nLtTLd8oVQi	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	418	nLtTLd8oVQi
419	afDtaFFJy5U	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	419	afDtaFFJy5U
420	MzbvVMv6qqR	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	420	MzbvVMv6qqR
421	mwrx20w7TwC	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	421	mwrx20w7TwC
422	KA3m8Skxyrd	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	422	KA3m8Skxyrd
423	hO6qi1vSbQa	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	423	hO6qi1vSbQa
424	HLymn5haKX6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	424	HLymn5haKX6
401	kcStNQ2LDcH	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	401	kcStNQ2LDcH
429	KMVmXiFpKHe	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	429	KMVmXiFpKHe
402	BA5mnJAevwO	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	402	BA5mnJAevwO
430	aI77OsoVVCX	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	430	aI77OsoVVCX
403	bRDYyY5ifEh	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	403	bRDYyY5ifEh
404	ajfHMWjRuW4	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	404	ajfHMWjRuW4
405	QOZgGnGOiBF	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	405	QOZgGnGOiBF
406	LAhpdWaQw44	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	406	LAhpdWaQw44
407	n3uOjROSJWU	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	407	n3uOjROSJWU
408	pRs8qxqjCaa	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	408	pRs8qxqjCaa
431	immOGNT21Gt	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	431	immOGNT21Gt
432	UncsFPaUPY4	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	432	UncsFPaUPY4
433	KHKxw334CWz	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	433	KHKxw334CWz
434	fcACbA55GDC	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	434	fcACbA55GDC
435	aZwX9DfOUK2	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	435	aZwX9DfOUK2
436	s2dkjCPY2qR	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	436	s2dkjCPY2qR
437	UDksMxL5cfZ	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	437	UDksMxL5cfZ
2611	q0d7cUeMDjo	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	2611	q0d7cUeMDjo
438	JlGpcng9BFf	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	438	JlGpcng9BFf
440	gN1WNlUMCAO	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	440	gN1WNlUMCAO
425	ktVICQZY6Va	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	425	ktVICQZY6Va
426	D6Mz2uFmKrb	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	426	D6Mz2uFmKrb
441	eVDEotZAl6S	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	441	eVDEotZAl6S
442	HNcjoI8Hikq	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	442	HNcjoI8Hikq
443	yjo1AMiB3pU	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	443	yjo1AMiB3pU
444	XZ5EZKyfHD2	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	444	XZ5EZKyfHD2
445	avyPYZAMQV9	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	445	avyPYZAMQV9
1586	PhCq4x6L2o1	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1586	PhCq4x6L2o1
439	O95WxDWc3nj	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	439	O95WxDWc3nj
447	aMIG8T1OZD7	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	447	aMIG8T1OZD7
448	kisFgxvHQ0b	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	448	kisFgxvHQ0b
449	NpxPtxsVliE	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	449	NpxPtxsVliE
450	areRYmW2Moa	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	450	areRYmW2Moa
451	lkTLhQNgq5O	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	451	lkTLhQNgq5O
452	CiSoGcQQ88r	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	452	CiSoGcQQ88r
453	umzGjVN9LWy	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	453	umzGjVN9LWy
446	STVXdJbnn3H	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	446	STVXdJbnn3H
427	oSkHt5d4nr6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	427	oSkHt5d4nr6
454	iusvea4wlaa	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	454	iusvea4wlaa
455	adH5G8EstWj	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	455	adH5G8EstWj
456	MYSHyvamVzh	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	456	MYSHyvamVzh
457	HYW1XVqXk62	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	457	HYW1XVqXk62
459	LdyV4e0vzeu	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	459	LdyV4e0vzeu
460	K6dmqTjBz5B	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	460	K6dmqTjBz5B
428	itMXAtIHVu2	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	428	itMXAtIHVu2
461	fA4gHLINj8q	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	461	fA4gHLINj8q
462	Nwdvs8JuEbv	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	462	Nwdvs8JuEbv
463	I2XU2SFfwnB	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	463	I2XU2SFfwnB
464	CjVML3u4v4O	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	464	CjVML3u4v4O
465	QIuZPS9HZlu	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	465	QIuZPS9HZlu
466	WxQQCkhFNzQ	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	466	WxQQCkhFNzQ
467	cb19xb8BO6Q	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	467	cb19xb8BO6Q
1634	apXGr1f8l9D	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	1634	apXGr1f8l9D
468	QxHGHhger7q	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	468	QxHGHhger7q
469	WQLYmAhQup5	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	469	WQLYmAhQup5
458	HWHRutHDzXu	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	458	HWHRutHDzXu
470	qiewZJ2PhvP	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	470	qiewZJ2PhvP
1632	PhRuQO8U4RI	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1632	PhRuQO8U4RI
1633	HorpECfqag7	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1633	HorpECfqag7
471	F1OvU15f7z0	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	471	F1OvU15f7z0
472	vOnAOaB1pFA	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	472	vOnAOaB1pFA
473	MCcHPIPGtCo	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	473	MCcHPIPGtCo
474	PGjfT8GmgvT	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	474	PGjfT8GmgvT
475	Uo7haVIuBGR	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	475	Uo7haVIuBGR
476	ZIIpqinbXJS	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	476	ZIIpqinbXJS
477	cutapjXYyeI	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	477	cutapjXYyeI
478	vQtUjVkhR7L	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	478	vQtUjVkhR7L
479	esylq1Zwig3	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	479	esylq1Zwig3
480	AvjirMUjg0j	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	480	AvjirMUjg0j
1591	M85YNgaQCoM	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1591	M85YNgaQCoM
481	BXbTY29PWlG	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	481	BXbTY29PWlG
482	sAIggLrZ5Ru	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	482	sAIggLrZ5Ru
483	yWYw37S44Ku	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	483	yWYw37S44Ku
484	aeovDDRuWXz	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	484	aeovDDRuWXz
485	Pud49eGxz7F	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	485	Pud49eGxz7F
486	yyiNJYq4R1G	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	486	yyiNJYq4R1G
487	HE9Llpjlago	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	487	HE9Llpjlago
488	Bh0U2ITJVc7	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	488	Bh0U2ITJVc7
489	s65J7cpFWS4	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	489	s65J7cpFWS4
490	KG8j3CvkRd9	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	490	KG8j3CvkRd9
491	MzHx79UsWAd	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	491	MzHx79UsWAd
492	OMrkzFQQ1qN	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	492	OMrkzFQQ1qN
493	NgEEuq6uZfV	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	493	NgEEuq6uZfV
496	ZMvUDFx9XnN	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	496	ZMvUDFx9XnN
497	qQPApRF5J28	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	497	qQPApRF5J28
498	tkgsqoGYcYi	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	498	tkgsqoGYcYi
1587	v34OKRUDNcU	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1587	v34OKRUDNcU
1588	uNP90Zfk2Lg	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1588	uNP90Zfk2Lg
499	lqOmHQtlRmV	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	499	lqOmHQtlRmV
500	enlpMHcmSeb	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	500	enlpMHcmSeb
501	bw1fnw2gvKX	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	501	bw1fnw2gvKX
502	B5hUY8cW6hE	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	502	B5hUY8cW6hE
503	GNk286NN5pG	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	503	GNk286NN5pG
504	Wr3gyeZ6KUr	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	504	Wr3gyeZ6KUr
505	XmUndBGqpt6	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	505	XmUndBGqpt6
506	yha3MhpqPH1	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	506	yha3MhpqPH1
507	QmhTQqN5gZv	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	507	QmhTQqN5gZv
508	DGBFUfYWCBl	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	508	DGBFUfYWCBl
509	nBZk2ugBiwx	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	509	nBZk2ugBiwx
510	wY6EznPosth	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	510	wY6EznPosth
511	EzcaOWLXAqW	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	511	EzcaOWLXAqW
512	DyPcdfPhNdS	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	512	DyPcdfPhNdS
513	aKZcxeiqnDC	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	513	aKZcxeiqnDC
514	XY8Siwchc7A	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	514	XY8Siwchc7A
515	BJXJyNCFAl2	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	515	BJXJyNCFAl2
516	BbzYFgQMV67	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	516	BbzYFgQMV67
517	aEOan17QsoW	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	517	aEOan17QsoW
518	hUz7cK7sja3	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	518	hUz7cK7sja3
519	nBKJ3cpl4T0	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	519	nBKJ3cpl4T0
520	tXDsfp50KIl	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	520	tXDsfp50KIl
521	a5pj74dBGEp	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	521	a5pj74dBGEp
494	LNkFivzpeA1	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	494	LNkFivzpeA1
522	rLXKKzktTVy	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	522	rLXKKzktTVy
523	D6VouTb2XCU	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	523	D6VouTb2XCU
524	hjo5ZPxN6lF	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	524	hjo5ZPxN6lF
525	gAQjtVVeV0w	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	525	gAQjtVVeV0w
526	Avn1mi6BJ58	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	526	Avn1mi6BJ58
527	rIGScyQWQfv	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	527	rIGScyQWQfv
1589	L4fYeaxZz9w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1589	L4fYeaxZz9w
528	V8YasjaiKtV	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	528	V8YasjaiKtV
530	aJedGfomkcr	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	530	aJedGfomkcr
531	saGv90kz1c0	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	531	saGv90kz1c0
532	u2n8s5Ol9SE	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	532	u2n8s5Ol9SE
533	ZbMUQHETUwO	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	533	ZbMUQHETUwO
534	D3NU99wFJ8q	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	534	D3NU99wFJ8q
535	a0zpHapVjFR	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	535	a0zpHapVjFR
536	fYaQexh3P77	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	536	fYaQexh3P77
537	tQcM2PMDVjA	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	537	tQcM2PMDVjA
538	a1BUAxYwQ1t	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	538	a1BUAxYwQ1t
539	HSfJD8SpfGG	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	539	HSfJD8SpfGG
495	sBXTbPz7S4Z	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	495	sBXTbPz7S4Z
540	WhdBSl0J7TV	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	540	WhdBSl0J7TV
541	cWGy4pU4VNL	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	541	cWGy4pU4VNL
542	M2Evh1Y9m1w	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	542	M2Evh1Y9m1w
543	HxUixzlcItQ	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	543	HxUixzlcItQ
544	zDJSedQmteO	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	544	zDJSedQmteO
545	MlsORrMK1p8	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	545	MlsORrMK1p8
546	K3fBM7akxIM	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	546	K3fBM7akxIM
547	gR9ugQ5XA2p	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	547	gR9ugQ5XA2p
548	vRIkWQ53yWk	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	548	vRIkWQ53yWk
549	nbfgB0iEtZi	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	549	nbfgB0iEtZi
550	PRm0WRtzN3B	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	550	PRm0WRtzN3B
551	ataZYLjOJXV	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	551	ataZYLjOJXV
552	RGGBHxJiRuh	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	552	RGGBHxJiRuh
529	pnxCSdB9Msk	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	529	pnxCSdB9Msk
553	ZCNZLPHbl3A	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	553	ZCNZLPHbl3A
554	Qk9HZ65zQnB	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	554	Qk9HZ65zQnB
555	sZkAxsA924V	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	555	sZkAxsA924V
556	fxbYbS59MHd	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	556	fxbYbS59MHd
557	tbrqQuOozOK	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	557	tbrqQuOozOK
558	kkYXfP8JNL2	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	558	kkYXfP8JNL2
559	d29fMUVvhDk	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	559	d29fMUVvhDk
560	a3qYnKHnulG	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	560	a3qYnKHnulG
561	HrVQp6KrVX9	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	561	HrVQp6KrVX9
562	eC4loXN1tRm	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	562	eC4loXN1tRm
563	XW7unjyUCe8	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	563	XW7unjyUCe8
564	a92Lyf8Vnrg	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	564	a92Lyf8Vnrg
566	aDPJkOqtFvR	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	566	aDPJkOqtFvR
567	IT6uTDE2Mmb	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	567	IT6uTDE2Mmb
568	ACGwiDCOGnv	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	568	ACGwiDCOGnv
569	IoHAYBBHJv6	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	569	IoHAYBBHJv6
570	v9FD5Gpl9mz	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	570	v9FD5Gpl9mz
571	O2pu4FaMeOX	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	571	O2pu4FaMeOX
572	asazeL5Os4W	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	572	asazeL5Os4W
573	X7IxKzXFuG2	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	573	X7IxKzXFuG2
574	jZuodh1Bux6	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	574	jZuodh1Bux6
575	beCHk64vc24	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	575	beCHk64vc24
576	ijcJS6aeDzn	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	576	ijcJS6aeDzn
577	UePQHLsuRjz	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	577	UePQHLsuRjz
578	r7Yx3IGPRyv	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	578	r7Yx3IGPRyv
579	uig2M5cny1H	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	579	uig2M5cny1H
580	aG0jMQyfUTx	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	580	aG0jMQyfUTx
581	hduvp3xa2Ay	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	581	hduvp3xa2Ay
582	aT9SzVJj0bl	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	582	aT9SzVJj0bl
583	VzNo51e77c5	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	583	VzNo51e77c5
584	ukbA7OKBWnA	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	584	ukbA7OKBWnA
585	zpLy53v57se	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	585	zpLy53v57se
586	N5HS3jdULUy	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	586	N5HS3jdULUy
587	Xsx22uXtlpC	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	587	Xsx22uXtlpC
588	tSaD45BABGh	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	588	tSaD45BABGh
589	acI7OX1zZEL	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	589	acI7OX1zZEL
565	lkkGqyqZ6qF	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	565	lkkGqyqZ6qF
590	hQ8aPoqFZbB	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	590	hQ8aPoqFZbB
591	Faj16MOBMgV	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	591	Faj16MOBMgV
592	dQPA0d35Rve	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	592	dQPA0d35Rve
593	fyRAZd94Iko	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	593	fyRAZd94Iko
594	vhabQS0hUcP	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	594	vhabQS0hUcP
595	t3epAUsT575	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	595	t3epAUsT575
596	qr9NGNGWnKe	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	596	qr9NGNGWnKe
597	OKDIaS83FAi	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	597	OKDIaS83FAi
598	TSjl80sWfHh	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	598	TSjl80sWfHh
599	SlNtFLDkwFu	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	599	SlNtFLDkwFu
600	RFO7xONPACc	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	600	RFO7xONPACc
601	rMpx9X7T5lY	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	601	rMpx9X7T5lY
602	BNyMSSfYf4F	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	602	BNyMSSfYf4F
603	RNvCuVyrrIM	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	603	RNvCuVyrrIM
604	AL6JpHbgaDx	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	604	AL6JpHbgaDx
605	jLbNqQrDbKZ	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	605	jLbNqQrDbKZ
606	UOMccy1X4qP	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	606	UOMccy1X4qP
607	YCLl9sb7PPj	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	607	YCLl9sb7PPj
608	DqlVBrTm4ge	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	608	DqlVBrTm4ge
609	a8kUiWFtuPS	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	609	a8kUiWFtuPS
610	JStHLwEQslP	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	610	JStHLwEQslP
611	sSqr43OzNQJ	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	611	sSqr43OzNQJ
612	SV1Bw284a44	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	612	SV1Bw284a44
614	aH0jq5ENnZS	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	614	aH0jq5ENnZS
615	fBjBTSTJHf6	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	615	fBjBTSTJHf6
616	Ve7T1nizG7q	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	616	Ve7T1nizG7q
617	q7s1d5LzgWc	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	617	q7s1d5LzgWc
618	kdIm0faI4Qw	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	618	kdIm0faI4Qw
619	B9VTI1nHb8T	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	619	B9VTI1nHb8T
620	s8bn45A31mu	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	620	s8bn45A31mu
1626	aFoe95rrnkM	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1626	aFoe95rrnkM
621	xIKybEz7PTY	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	621	xIKybEz7PTY
622	adTaaCdwRM7	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	622	adTaaCdwRM7
623	aaes1np8v4h	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	623	aaes1np8v4h
624	OWRojvEDKoQ	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	624	OWRojvEDKoQ
625	Z0G5mSsk4VZ	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	625	Z0G5mSsk4VZ
626	xiFyzChOvlR	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	626	xiFyzChOvlR
627	gLyHeUBTz8t	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	627	gLyHeUBTz8t
628	IfprxlrKiKL	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	628	IfprxlrKiKL
629	DRAypYcgokr	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	629	DRAypYcgokr
630	F9n4CIZXoSa	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	630	F9n4CIZXoSa
631	uI5RcvNU7bG	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	631	uI5RcvNU7bG
632	kygzvZq01dr	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	632	kygzvZq01dr
633	hL8S70PKfJ7	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	633	hL8S70PKfJ7
634	K53DNeXvZyY	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	634	K53DNeXvZyY
635	xWj7K97vdF9	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	635	xWj7K97vdF9
636	AbV5pHHSFTU	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	636	AbV5pHHSFTU
613	ovQV6rcV90p	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	613	ovQV6rcV90p
637	a8kHG8t6bY6	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	637	a8kHG8t6bY6
649	a0vg4d6HxAt	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	649	a0vg4d6HxAt
650	ZLnbMrovQ9f	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	650	ZLnbMrovQ9f
651	RTxq0C3ff1y	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	651	RTxq0C3ff1y
652	aQbUr8vlhmm	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	652	aQbUr8vlhmm
653	EAvf9A8eXu3	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	653	EAvf9A8eXu3
654	o1TE46Mk0lW	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	654	o1TE46Mk0lW
655	afAjPIjW0D3	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	655	afAjPIjW0D3
656	gj1Omw1FJCo	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	656	gj1Omw1FJCo
657	acHyc4nCqAg	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	657	acHyc4nCqAg
658	ajyWVVmNSuc	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	658	ajyWVVmNSuc
659	aYieDAsKoLt	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	659	aYieDAsKoLt
660	aBvWL2yX3ZA	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	660	aBvWL2yX3ZA
661	aIcEOOsCdQz	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	661	aIcEOOsCdQz
662	e4XWNDjKUXH	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	662	e4XWNDjKUXH
1568	VWM1FTIMfuj	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1568	VWM1FTIMfuj
663	awd0xy7yb1C	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	663	awd0xy7yb1C
664	McggXNT9Zyg	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	664	McggXNT9Zyg
665	bGpRkGyvpw2	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	665	bGpRkGyvpw2
638	alKCrUnF0Ww	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	638	alKCrUnF0Ww
667	IU8fCTgthtM	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	667	IU8fCTgthtM
668	ai2RrlY9Fcd	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	668	ai2RrlY9Fcd
639	giI51CVkmc5	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	639	giI51CVkmc5
669	fDUCgOeUSZ3	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	669	fDUCgOeUSZ3
640	cTEozrMez9F	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	640	cTEozrMez9F
899707	FTlhugCaMo2	4	194	akV6429SUqu	899561	ecZgt4pokn4	899614	CKgGrgTdDiW	899707	FTlhugCaMo2
670	aYWNoEFeoUw	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	670	aYWNoEFeoUw
671	eTbQFH93KnL	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	671	eTbQFH93KnL
672	FEIP4B06TTS	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	672	FEIP4B06TTS
673	atuGUiyfDCY	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	673	atuGUiyfDCY
674	hNRHAcDywTL	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	674	hNRHAcDywTL
675	TW0y96F73kX	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	675	TW0y96F73kX
676	HzudJ19fruU	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	676	HzudJ19fruU
677	sAOvU6xz6rg	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	677	sAOvU6xz6rg
641	txhaIBaEbrA	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	641	txhaIBaEbrA
678	weIcTd1431E	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	678	weIcTd1431E
643	rs5gMlaHAKN	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	643	rs5gMlaHAKN
644	qi6GOznKLly	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	644	qi6GOznKLly
645	vTfdVf6ncdV	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	645	vTfdVf6ncdV
679	VrN4YeR370f	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	679	VrN4YeR370f
680	q0BqaYeLsKz	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	680	q0BqaYeLsKz
681	ZXUkpP7874H	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	681	ZXUkpP7874H
666	gt1m7SU1IYP	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	666	gt1m7SU1IYP
682	u2qKXP2Yt49	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	682	u2qKXP2Yt49
646	NUIvwbo2SFh	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	646	NUIvwbo2SFh
1615	Pzuty2p5guf	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1615	Pzuty2p5guf
683	I2CScuUNy5Y	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	683	I2CScuUNy5Y
684	ZHfJLqSYMkD	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	684	ZHfJLqSYMkD
647	wyW0esOM7ZB	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	647	wyW0esOM7ZB
685	uWXVoMSOy5v	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	685	uWXVoMSOy5v
686	oUbjAL1F0oh	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	686	oUbjAL1F0oh
687	bzz1pfLJqsG	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	687	bzz1pfLJqsG
688	FNKf692yj8f	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	688	FNKf692yj8f
648	gmakqYElPUi	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	648	gmakqYElPUi
689	GEO7nsOVAeb	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	689	GEO7nsOVAeb
690	Mdhjgfhqq3E	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	690	Mdhjgfhqq3E
691	OjpRztl3PXm	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	691	OjpRztl3PXm
692	dIryCQvB5SO	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	692	dIryCQvB5SO
693	aQdwdYyr6GL	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	693	aQdwdYyr6GL
694	a8JmSlpZNZp	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	694	a8JmSlpZNZp
695	lXd493OI3PF	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	695	lXd493OI3PF
696	Qz23CEgrnri	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	696	Qz23CEgrnri
697	ZXVPHNGdsSz	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	697	ZXVPHNGdsSz
698	FJMPE6W5Eh5	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	698	FJMPE6W5Eh5
699	anjXngIyBSK	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	699	anjXngIyBSK
700	yCliwz5ZvHM	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	700	yCliwz5ZvHM
701	FIum5r1vz31	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	701	FIum5r1vz31
702	bccV4EYcggS	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	702	bccV4EYcggS
704	DiPNrbcTMu7	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	704	DiPNrbcTMu7
705	OKG9JhAXAh8	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	705	OKG9JhAXAh8
706	XbSvPK3Vt68	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	706	XbSvPK3Vt68
707	XH5QSihkOp9	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	707	XH5QSihkOp9
708	M8nMckziF7v	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	708	M8nMckziF7v
709	z7zg0AlCyHn	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	709	z7zg0AlCyHn
710	sDD3UFAT7eA	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	710	sDD3UFAT7eA
711	a8UqcJq7pdF	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	711	a8UqcJq7pdF
712	VdgakBSJmWY	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	712	VdgakBSJmWY
713	kimHkD6SIvJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	713	kimHkD6SIvJ
714	P0O4loDtPtQ	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	714	P0O4loDtPtQ
715	wqcNzckuzrb	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	715	wqcNzckuzrb
716	LQLSqsdH1d5	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	716	LQLSqsdH1d5
1610	wLL0PdmBLep	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1610	wLL0PdmBLep
717	Vko6vxEEGTL	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	717	Vko6vxEEGTL
1572	htalJQhw2VH	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	1572	htalJQhw2VH
718	UeBN5O6ty6x	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	718	UeBN5O6ty6x
719	eNfm0rdOENJ	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	719	eNfm0rdOENJ
720	UbxVhXZ5cxg	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	720	UbxVhXZ5cxg
721	Ff8IGt4L1bx	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	721	Ff8IGt4L1bx
722	BH9KY4rNgOd	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	722	BH9KY4rNgOd
723	T0h7sp936Oj	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	723	T0h7sp936Oj
724	XHmgImvm1YA	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	724	XHmgImvm1YA
725	Vn1BrRW11CK	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	725	Vn1BrRW11CK
726	irk9vMITnjG	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	726	irk9vMITnjG
727	v9bokcX3eyh	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	727	v9bokcX3eyh
728	unil8uWmdaQ	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	728	unil8uWmdaQ
729	s7AX07hTO3k	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	729	s7AX07hTO3k
730	FP69DGoEtwM	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	730	FP69DGoEtwM
731	QKcOOobdPtO	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	731	QKcOOobdPtO
732	Rwjn2kDDgwf	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	732	Rwjn2kDDgwf
733	IzhBEvsBLuC	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	733	IzhBEvsBLuC
734	ankNTtBte7C	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	734	ankNTtBte7C
735	a1ZQxyqQh2P	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	735	a1ZQxyqQh2P
736	tpjk403ii11	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	736	tpjk403ii11
737	KGfsBIXqGWC	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	737	KGfsBIXqGWC
738	f82sIZY6sXk	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	738	f82sIZY6sXk
739	ibNVWLqSB0M	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	739	ibNVWLqSB0M
740	QsVqR2LTTyA	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	740	QsVqR2LTTyA
741	DZ756Z6f6or	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	741	DZ756Z6f6or
742	k3TPzr4AjuK	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	742	k3TPzr4AjuK
743	aPq34NY4UoQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	743	aPq34NY4UoQ
744	bzwQwNeos4x	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	744	bzwQwNeos4x
745	UOGlWhl35aX	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	745	UOGlWhl35aX
2606	A4sujFcM3Rd	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2606	A4sujFcM3Rd
746	k7Wgi7O0JdY	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	746	k7Wgi7O0JdY
747	nxmcI5yFfZT	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	747	nxmcI5yFfZT
748	aGcAkfwodXH	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	748	aGcAkfwodXH
1574	NcuAdU0UfGD	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1574	NcuAdU0UfGD
749	jlUSUrhXkWa	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	749	jlUSUrhXkWa
750	j4mYXmd6dAo	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	750	j4mYXmd6dAo
751	FBqsNdo7BhV	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	751	FBqsNdo7BhV
752	AyfxIwQbwaa	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	752	AyfxIwQbwaa
753	aqPlmnEhKp4	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	753	aqPlmnEhKp4
754	TDySLXGWz3J	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	754	TDySLXGWz3J
755	lBaXWVG0uKY	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	755	lBaXWVG0uKY
756	P5yisXF3Zpg	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	756	P5yisXF3Zpg
757	qwvt0BiEsTd	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	757	qwvt0BiEsTd
758	PYy5HTyCdNG	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	758	PYy5HTyCdNG
703	WSYIQSpwPop	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	703	WSYIQSpwPop
759	LUHdM7WTGOa	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	759	LUHdM7WTGOa
760	BgokGwMnuMg	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	760	BgokGwMnuMg
2600	EuenzV2j2gh	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	2600	EuenzV2j2gh
762	ajkzjPlcCwo	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	762	ajkzjPlcCwo
763	RXwynIETRuW	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	763	RXwynIETRuW
764	Z5bpgfoV7zZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	764	Z5bpgfoV7zZ
765	jXtChmPP7Nj	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	765	jXtChmPP7Nj
766	FmcUCen26pk	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	766	FmcUCen26pk
767	azuXegJHaV5	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	767	azuXegJHaV5
768	XbFljDSYnip	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	768	XbFljDSYnip
769	Pr3pvr9gLU8	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	769	Pr3pvr9gLU8
770	HtZQp7J8zCH	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	770	HtZQp7J8zCH
771	uVmqHTweoDr	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	771	uVmqHTweoDr
772	PYG2auieAq6	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	772	PYG2auieAq6
773	aztJaVUNQQd	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	773	aztJaVUNQQd
774	mCATibfPDkS	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	774	mCATibfPDkS
775	JYWZpPyfYmQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	775	JYWZpPyfYmQ
776	a8kpQiPpYy0	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	776	a8kpQiPpYy0
777	WYXK0xBPYfx	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	777	WYXK0xBPYfx
778	zNdkt1W9dcu	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	778	zNdkt1W9dcu
779	fwJDrgKD2HB	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	779	fwJDrgKD2HB
780	xNFWmVZ4Q5L	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	780	xNFWmVZ4Q5L
781	cLas0iVZsnw	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	781	cLas0iVZsnw
782	BUWL20wfAHB	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	782	BUWL20wfAHB
783	C4Gn1IRKEmg	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	783	C4Gn1IRKEmg
784	Tk6cI0YZc9n	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	784	Tk6cI0YZc9n
785	ZeGDEUnjafd	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	785	ZeGDEUnjafd
1616	I9sa8wYtbhI	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1616	I9sa8wYtbhI
786	GKYsDNWyURe	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	786	GKYsDNWyURe
787	a9bdfn2hOs0	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	787	a9bdfn2hOs0
788	oAC3iaYXnzM	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	788	oAC3iaYXnzM
789	O8iZOZeRWv1	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	789	O8iZOZeRWv1
790	LD3UI99qch9	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	790	LD3UI99qch9
791	lKc1HJwGQpo	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	791	lKc1HJwGQpo
792	jFNWWovsSyW	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	792	jFNWWovsSyW
793	Yl575haJAFI	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	793	Yl575haJAFI
794	eN59rRkxQhi	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	794	eN59rRkxQhi
795	rX3aSZRsV6q	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	795	rX3aSZRsV6q
796	O55NSHMG3SN	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	796	O55NSHMG3SN
797	WzWkYEphZW9	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	797	WzWkYEphZW9
798	VV0exqWnJYw	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	798	VV0exqWnJYw
799	DJRzqJrw6hs	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	799	DJRzqJrw6hs
800	wrvQ9sKuSsJ	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	800	wrvQ9sKuSsJ
801	noZnZEDjkuI	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	801	noZnZEDjkuI
802	aJjvRZT2AqT	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	802	aJjvRZT2AqT
803	fmX1IQNrk2Q	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	803	fmX1IQNrk2Q
804	aalsK83lGNw	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	804	aalsK83lGNw
805	yPgbuSci4pX	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	805	yPgbuSci4pX
806	TTTUd8x0XZ7	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	806	TTTUd8x0XZ7
807	GNfNmxhRBMX	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	807	GNfNmxhRBMX
808	bAAsA9G7rGX	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	808	bAAsA9G7rGX
809	GLh6NlOfYQP	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	809	GLh6NlOfYQP
810	djMgaXn0i9x	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	810	djMgaXn0i9x
811	h8bx9l02abI	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	811	h8bx9l02abI
812	amkxMXakeXu	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	812	amkxMXakeXu
813	Nes6fdESisv	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	813	Nes6fdESisv
814	nIHa6wXLbHt	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	814	nIHa6wXLbHt
815	OtcX4cHu6sF	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	815	OtcX4cHu6sF
816	HTZhrdw748h	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	816	HTZhrdw748h
817	ciYirJoS2bT	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	817	ciYirJoS2bT
818	cdUu7uCoOhY	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	818	cdUu7uCoOhY
819	aOlMtRebTz8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	819	aOlMtRebTz8
820	HU27Dm5PRHo	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	820	HU27Dm5PRHo
821	YrGNy5AQy2U	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	821	YrGNy5AQy2U
1611	QYb31ehcR5R	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1611	QYb31ehcR5R
822	WCE4lL4rT73	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	822	WCE4lL4rT73
823	QyjU22BhtrY	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	823	QyjU22BhtrY
824	tsLXZfmENJW	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	824	tsLXZfmENJW
825	n4gYlmLUOrU	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	825	n4gYlmLUOrU
826	oMZSkQE6CzW	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	826	oMZSkQE6CzW
827	wVRNuBQptIz	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	827	wVRNuBQptIz
828	Pw1S7C7oSlb	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	828	Pw1S7C7oSlb
829	Ol8iEPOeRAB	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	829	Ol8iEPOeRAB
830	UScOSjCwMK5	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	830	UScOSjCwMK5
832	aVEnwpUDlzd	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	832	aVEnwpUDlzd
833	kF1SFRGTg9d	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	833	kF1SFRGTg9d
834	L4bNeaH542W	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	834	L4bNeaH542W
835	a3Kzeo29ZKb	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	835	a3Kzeo29ZKb
836	rIngfXPkVV0	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	836	rIngfXPkVV0
838	J8NEcJToM09	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	838	J8NEcJToM09
839	FCUvR11qCK1	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	839	FCUvR11qCK1
840	XIUw6GYfz2o	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	840	XIUw6GYfz2o
841	Lrz2RTu4m7z	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	841	Lrz2RTu4m7z
831	A2UOcJadqvg	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	831	A2UOcJadqvg
842	arqyzyS4nL2	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	842	arqyzyS4nL2
843	alAMOnr7I1C	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	843	alAMOnr7I1C
844	ZA35ZIXly1S	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	844	ZA35ZIXly1S
845	YXmA2I9pEgy	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	845	YXmA2I9pEgy
846	aVSDdSh3pZc	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	846	aVSDdSh3pZc
847	atjtfI5ERhj	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	847	atjtfI5ERhj
2601	oUu2ZSHv6MY	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2601	oUu2ZSHv6MY
848	aem5mcxM1gO	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	848	aem5mcxM1gO
849	lYqNWu82K6e	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	849	lYqNWu82K6e
850	a6kSPA6WRKJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	850	a6kSPA6WRKJ
851	GriJuFUbYvj	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	851	GriJuFUbYvj
852	TMJdZnNOFfa	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	852	TMJdZnNOFfa
853	Y4NFDi1A36x	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	853	Y4NFDi1A36x
854	SCdTXGoDrqJ	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	854	SCdTXGoDrqJ
855	K6tAujIHmVM	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	855	K6tAujIHmVM
856	DCD67vVjc2E	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	856	DCD67vVjc2E
857	qJ0sxVsO2pk	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	857	qJ0sxVsO2pk
858	fzvBAzpTuei	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	858	fzvBAzpTuei
859	OArnksuH9WD	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	859	OArnksuH9WD
860	yh1Sulu1NeO	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	860	yh1Sulu1NeO
861	H2g74E6daJi	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	861	H2g74E6daJi
862	WfCOLLxAlQl	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	862	WfCOLLxAlQl
863	UXjEx2E2ZA4	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	863	UXjEx2E2ZA4
864	lTJKdr8yZcj	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	864	lTJKdr8yZcj
865	zwrCEmPW7Nn	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	865	zwrCEmPW7Nn
866	BynI1aokvo2	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	866	BynI1aokvo2
867	EIwIQOkPTaD	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	867	EIwIQOkPTaD
868	hDJoLiGGfRY	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	868	hDJoLiGGfRY
869	Tm9sPGt31dl	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	869	Tm9sPGt31dl
870	EaYP1A2wyvE	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	870	EaYP1A2wyvE
871	dORhiEXRNbk	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	871	dORhiEXRNbk
872	d4oc9mO8c7a	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	872	d4oc9mO8c7a
873	NkDX1oU6cfn	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	873	NkDX1oU6cfn
874	LYuMx5oPsR5	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	874	LYuMx5oPsR5
875	QcwYauvw0xm	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	875	QcwYauvw0xm
876	moNkR6R4Giv	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	876	moNkR6R4Giv
877	joyz7BH8DXG	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	877	joyz7BH8DXG
878	wXKdvmz0nrv	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	878	wXKdvmz0nrv
879	CDtQkwtnyAH	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	879	CDtQkwtnyAH
880	Pp5WSDc9OCY	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	880	Pp5WSDc9OCY
881	zCQyW5ODHjj	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	881	zCQyW5ODHjj
882	g2cqoGXKKIR	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	882	g2cqoGXKKIR
883	yuGhB6fDmnU	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	883	yuGhB6fDmnU
884	a7t73IQZdXp	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	884	a7t73IQZdXp
885	jvcz0hVcAxJ	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	885	jvcz0hVcAxJ
886	yCb8ApS6M0g	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	886	yCb8ApS6M0g
887	AAXO2IZq70L	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	887	AAXO2IZq70L
888	nY0VztZvBTO	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	888	nY0VztZvBTO
889	e98gCd9BlNl	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	889	e98gCd9BlNl
890	atQIWPlJi3f	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	890	atQIWPlJi3f
891	prpCrjA0faa	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	891	prpCrjA0faa
892	e9lITPTVy5H	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	892	e9lITPTVy5H
893	Y9BKBtIjli6	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	893	Y9BKBtIjli6
894	J2sL2LLRwdg	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	894	J2sL2LLRwdg
895	abeBKMqGN0S	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	895	abeBKMqGN0S
896	dbfXxjnS2Pt	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	896	dbfXxjnS2Pt
837	NgU6GKFkUU4	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	837	NgU6GKFkUU4
897	hvOhryiEkBg	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	897	hvOhryiEkBg
898	amqLFDsy2mP	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	898	amqLFDsy2mP
899	eLn35raYbxK	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	899	eLn35raYbxK
900	WlD8pvSBDdI	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	900	WlD8pvSBDdI
901	ylIpZ1kqrzl	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	901	ylIpZ1kqrzl
902	tiCEiYlOHa9	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	902	tiCEiYlOHa9
904	EmP1TgdHCnS	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	904	EmP1TgdHCnS
905	jTDRA7XUQLH	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	905	jTDRA7XUQLH
903	ggvYKc3bfrH	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	903	ggvYKc3bfrH
906	sCXOgVGqtpp	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	906	sCXOgVGqtpp
907	v3u1aOgDsgx	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	907	v3u1aOgDsgx
908	zNyf0buOkOl	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	908	zNyf0buOkOl
909	OEWhwSnx6tP	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	909	OEWhwSnx6tP
910	wwh3Av3jOqm	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	910	wwh3Av3jOqm
911	qSt7JthiH9h	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	911	qSt7JthiH9h
912	aX8e1LzHpbE	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	912	aX8e1LzHpbE
913	lgwkTLjh0z8	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	913	lgwkTLjh0z8
914	XXvbdTUuGgg	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	914	XXvbdTUuGgg
915	ZjFXjIHR5u2	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	915	ZjFXjIHR5u2
916	lqh3U0Yv4CH	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	916	lqh3U0Yv4CH
917	l9dRuCYLpXH	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	917	l9dRuCYLpXH
918	VpJ2HH58EjI	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	918	VpJ2HH58EjI
919	i6UwRGRlTe6	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	919	i6UwRGRlTe6
920	RgaVJyjupYA	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	920	RgaVJyjupYA
925	k6Qib6wlmSW	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	925	k6Qib6wlmSW
926	aTalSr9jUmm	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	926	aTalSr9jUmm
927	iNsYdEeHG7q	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	927	iNsYdEeHG7q
928	KQCblChIrTo	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	928	KQCblChIrTo
929	aQfttHh6crC	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	929	aQfttHh6crC
930	oPGBU8lsM7Z	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	930	oPGBU8lsM7Z
931	jm4G6gQJISm	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	931	jm4G6gQJISm
932	i7RHER6mToP	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	932	i7RHER6mToP
933	YI1W2cHvMEF	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	933	YI1W2cHvMEF
934	hnrm4ibfoTk	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	934	hnrm4ibfoTk
935	uMZROveCZt0	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	935	uMZROveCZt0
936	HnJdqBFEw34	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	936	HnJdqBFEw34
937	asxJZ73r4QU	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	937	asxJZ73r4QU
938	M1GFPaWfMs9	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	938	M1GFPaWfMs9
939	SreeBEW8Aqm	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	939	SreeBEW8Aqm
940	VclKT9ER4XM	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	940	VclKT9ER4XM
941	O3kEMiNyC7J	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	941	O3kEMiNyC7J
942	avbBgK9zyA2	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	942	avbBgK9zyA2
943	SyDmHzRhAjp	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	943	SyDmHzRhAjp
944	l0LizWT16CQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	944	l0LizWT16CQ
945	aWMP3wvnNZW	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	945	aWMP3wvnNZW
946	dY1Tvx0RPRi	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	946	dY1Tvx0RPRi
947	zeYJmjH1keH	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	947	zeYJmjH1keH
948	p1fk9MgsBJp	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	948	p1fk9MgsBJp
949	JN43iMJuuu0	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	949	JN43iMJuuu0
950	GLbWzyzBfzw	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	950	GLbWzyzBfzw
921	asGXvs8RGcx	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	921	asGXvs8RGcx
951	pUzjkVgv6Fi	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	951	pUzjkVgv6Fi
952	INpjo0DSjXk	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	952	INpjo0DSjXk
953	mS0Js3oecic	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	953	mS0Js3oecic
954	OvshHVjn0lS	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	954	OvshHVjn0lS
955	PyNAIp8LzqW	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	955	PyNAIp8LzqW
956	Qv4Ev8LymW3	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	956	Qv4Ev8LymW3
957	PAjHH9FKnf7	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	957	PAjHH9FKnf7
958	ifsoB4c1lK3	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	958	ifsoB4c1lK3
922	ZwgfKE1W71u	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	922	ZwgfKE1W71u
959	aGywgyDsaIJ	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	959	aGywgyDsaIJ
923	g8E2xKiKNDo	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	923	g8E2xKiKNDo
960	swymPYYE156	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	960	swymPYYE156
961	BnEEwTPuAdl	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	961	BnEEwTPuAdl
962	mmzJuWJudcF	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	962	mmzJuWJudcF
963	LITVvlOIhKH	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	963	LITVvlOIhKH
964	BMyjKocJfay	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	964	BMyjKocJfay
965	RrMypNnd0bB	4	194	akV6429SUqu	197	VA90IqaI4Ji	280	Ame30QOwuX6	965	RrMypNnd0bB
966	wnc7108bfUe	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	966	wnc7108bfUe
967	ipwsQpJqSTw	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	967	ipwsQpJqSTw
968	amnWLIZ44DS	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	968	amnWLIZ44DS
969	K1ZKgCaz0Hd	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	969	K1ZKgCaz0Hd
970	qmcJkZ4ywL9	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	970	qmcJkZ4ywL9
971	aYH223NvQM9	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	971	aYH223NvQM9
972	aiZ5zkqnKTk	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	972	aiZ5zkqnKTk
924	DHWHrDD2bPf	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	924	DHWHrDD2bPf
973	VTkMLMzzqao	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	973	VTkMLMzzqao
974	JzZkIkp7PnX	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	974	JzZkIkp7PnX
975	svThtOW2ZOx	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	975	svThtOW2ZOx
976	s2a0yLa3g2f	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	976	s2a0yLa3g2f
642	a4eJM1A5pmq	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	642	a4eJM1A5pmq
977	aKZZ42qXlZq	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	977	aKZZ42qXlZq
978	pBCTMJRY7HR	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	978	pBCTMJRY7HR
979	JXMBQgVmU19	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	979	JXMBQgVmU19
980	afxMkooK3iZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	980	afxMkooK3iZ
981	K9Kbf0kDcAO	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	981	K9Kbf0kDcAO
982	aANELFaFbpF	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	982	aANELFaFbpF
983	Kgm0dUViEfO	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	983	Kgm0dUViEfO
984	WSDI45idzp5	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	984	WSDI45idzp5
985	uodLpKe7cyL	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	985	uodLpKe7cyL
986	hfW1BGRy1XT	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	986	hfW1BGRy1XT
987	Ed2uyXvmovM	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	987	Ed2uyXvmovM
988	fOv2DdPf7fG	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	988	fOv2DdPf7fG
989	uNDDSxipolZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	289	Y4LV8xqkv6J	989	uNDDSxipolZ
990	KPGI2KIVJYC	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	990	KPGI2KIVJYC
991	q03uh0SJ0N9	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	991	q03uh0SJ0N9
992	dzxOS342VoL	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	992	dzxOS342VoL
993	RGpPADZEyuz	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	993	RGpPADZEyuz
995	V0rnbupwOSg	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	995	V0rnbupwOSg
996	nmK9yk0kjmP	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	996	nmK9yk0kjmP
997	HsanwfHFpmb	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	997	HsanwfHFpmb
998	lUpDen75Xj1	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	998	lUpDen75Xj1
999	rQcFYXak0LH	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	999	rQcFYXak0LH
1000	vzwpI60WeOu	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1000	vzwpI60WeOu
1001	aYNxEpv8ugI	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1001	aYNxEpv8ugI
1002	fbPAuvlJO2x	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1002	fbPAuvlJO2x
1003	FpHwm5xxH41	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1003	FpHwm5xxH41
1004	AH9Soa1y2qd	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1004	AH9Soa1y2qd
1005	Hy2n4D2yJOM	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1005	Hy2n4D2yJOM
1006	xYpXN24CZWB	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1006	xYpXN24CZWB
1007	hY5HcMQt93G	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1007	hY5HcMQt93G
1008	BKmwdsqAY8X	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1008	BKmwdsqAY8X
1009	pYK9GIYGHha	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1009	pYK9GIYGHha
1010	YExRLcjp4gN	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1010	YExRLcjp4gN
1011	FTHpI3wbK44	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1011	FTHpI3wbK44
1012	QHDvSlNK4AR	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1012	QHDvSlNK4AR
1013	einBeJvXJ9C	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1013	einBeJvXJ9C
1014	YqM3WN8CBFs	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1014	YqM3WN8CBFs
1015	WBLZTH5N3PI	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1015	WBLZTH5N3PI
1016	smtpWtgMApq	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1016	smtpWtgMApq
1017	VytuF37uBdH	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1017	VytuF37uBdH
1018	jpSKkolHZLC	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1018	jpSKkolHZLC
1019	INAlXb1eDqD	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1019	INAlXb1eDqD
1020	powsUW9bIIP	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1020	powsUW9bIIP
1021	CPZioDtBpZV	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1021	CPZioDtBpZV
1022	WeFUHhkOL7X	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1022	WeFUHhkOL7X
1023	eeX08t63esL	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1023	eeX08t63esL
1024	aXfUiVQAoT5	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1024	aXfUiVQAoT5
1025	jvma3lxo8f8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1025	jvma3lxo8f8
1026	ZlnVZxGQXOx	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1026	ZlnVZxGQXOx
1027	WjtyvvauxbS	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1027	WjtyvvauxbS
1028	mayeGj9ddSB	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1028	mayeGj9ddSB
1029	NRDNqq6C6e0	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1029	NRDNqq6C6e0
1030	KYNuILiw5nZ	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1030	KYNuILiw5nZ
1031	a0WerFS0RsJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1031	a0WerFS0RsJ
1032	BMGbzxq74QD	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1032	BMGbzxq74QD
1033	vjJEam7cAan	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1033	vjJEam7cAan
1034	WKSICXIHQfF	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1034	WKSICXIHQfF
1035	v4SsBMVYOWo	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1035	v4SsBMVYOWo
1036	as3Z6ngugbk	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1036	as3Z6ngugbk
1037	KqoeThv6f1S	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1037	KqoeThv6f1S
2610	I59FGFaG12c	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	2610	I59FGFaG12c
1038	aQM5mVi0TJ6	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1038	aQM5mVi0TJ6
1039	l01FDO0PtI0	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1039	l01FDO0PtI0
1040	I0Dnu8MNpI6	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1040	I0Dnu8MNpI6
1041	awkC6nEZfiH	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1041	awkC6nEZfiH
1042	GYTYaoNGHZ3	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1042	GYTYaoNGHZ3
2602	aXxvYqah8Pp	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2602	aXxvYqah8Pp
1043	aUTx89Nc5z1	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1043	aUTx89Nc5z1
1044	anccgvVRV6E	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1044	anccgvVRV6E
1045	r1CT8PzuM0D	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1045	r1CT8PzuM0D
1046	BNUP3lD4kG4	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1046	BNUP3lD4kG4
1047	Jwnd2Jayc4g	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1047	Jwnd2Jayc4g
1048	QpcgX2e3WIK	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1048	QpcgX2e3WIK
1049	COaxzbRhsBA	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1049	COaxzbRhsBA
1050	qUDCFxUq4uw	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1050	qUDCFxUq4uw
1051	ayMSTn5sz80	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1051	ayMSTn5sz80
1052	x7pZ9LvlBky	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1052	x7pZ9LvlBky
1053	B6t4I0VO1re	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1053	B6t4I0VO1re
1054	OWgilSeUm8D	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1054	OWgilSeUm8D
1055	p5nJqYlFrnv	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1055	p5nJqYlFrnv
1056	FBzF6PAZ005	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1056	FBzF6PAZ005
1057	siFCXpF47oz	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1057	siFCXpF47oz
1058	pH004BIak3K	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1058	pH004BIak3K
1059	arVCB9uKDid	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1059	arVCB9uKDid
1060	MnJWFwnuzn3	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1060	MnJWFwnuzn3
1061	rpArRJJW06x	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1061	rpArRJJW06x
1062	awMQEoN8pM3	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1062	awMQEoN8pM3
1065	YAjpUZ4zMfG	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1065	YAjpUZ4zMfG
1066	HEXRFkHHTnV	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1066	HEXRFkHHTnV
1067	jvOw5Sxvxvj	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1067	jvOw5Sxvxvj
1068	q5gtDb5elfP	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1068	q5gtDb5elfP
1069	e8OZNj5acCv	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1069	e8OZNj5acCv
1070	ou4ERpDzITv	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1070	ou4ERpDzITv
1071	lJWSXSCBtli	4	194	akV6429SUqu	195	pz9Uu65Irbg	232	a8RHFdF4DXL	1071	lJWSXSCBtli
1072	tw10nJiKtIc	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1072	tw10nJiKtIc
1073	gGlUQNvHlRy	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1073	gGlUQNvHlRy
1074	FvufV5jpEM5	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1074	FvufV5jpEM5
1075	acHG8DfK2la	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1075	acHG8DfK2la
1076	Lg96gQU7KFN	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1076	Lg96gQU7KFN
1077	lohzTg3j7jU	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1077	lohzTg3j7jU
1078	BBRR0ZCNp9p	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1078	BBRR0ZCNp9p
1079	aYLAe6kESiT	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1079	aYLAe6kESiT
1080	Pb5LohJFHA0	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1080	Pb5LohJFHA0
1081	ak8dhyMummI	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1081	ak8dhyMummI
1082	JXAOPG4pehv	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1082	JXAOPG4pehv
1083	SGXPXHBPCyu	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1083	SGXPXHBPCyu
1084	d7O2HPDA9UV	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1084	d7O2HPDA9UV
1085	D6FXIrPgDTu	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1085	D6FXIrPgDTu
994	C2MPhjR29Db	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	994	C2MPhjR29Db
1086	XUogk7gtKr6	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1086	XUogk7gtKr6
1087	lcOZwwI0DzD	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1087	lcOZwwI0DzD
1088	QBs5UwEfnge	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1088	QBs5UwEfnge
1089	HT5sk9MS3Br	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1089	HT5sk9MS3Br
1090	wboIhZcZzoD	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1090	wboIhZcZzoD
1091	YhVHvo0UUnR	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1091	YhVHvo0UUnR
1092	iPiO62aF9FB	4	194	akV6429SUqu	197	VA90IqaI4Ji	255	ahyi8Uq4vaj	1092	iPiO62aF9FB
1093	SOeWmeGdMfu	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1093	SOeWmeGdMfu
1094	DZQIcj2NrHv	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1094	DZQIcj2NrHv
1095	aIXbRzimOry	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	1095	aIXbRzimOry
1096	W93hZALLbDc	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1096	W93hZALLbDc
1097	c4Vsie8YEMT	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1097	c4Vsie8YEMT
1099	xcbWr7R7FDK	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1099	xcbWr7R7FDK
1100	vP5RNMjCpa5	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1100	vP5RNMjCpa5
1101	VeulA9IP9jC	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1101	VeulA9IP9jC
1102	vpIWLBHTWgV	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1102	vpIWLBHTWgV
1103	cYeWg82r4fI	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1103	cYeWg82r4fI
15386357	dWhV6fQI1c4	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	15386357	dWhV6fQI1c4
1104	aG6R67xf8oR	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1104	aG6R67xf8oR
1105	T5GMofQmNr0	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1105	T5GMofQmNr0
1106	BSIgbcTVHu7	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1106	BSIgbcTVHu7
1107	grLyhuvPVbL	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1107	grLyhuvPVbL
1108	NJBN4GJd1Q5	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1108	NJBN4GJd1Q5
1109	voFp0uhCRYz	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1109	voFp0uhCRYz
1110	dXbVDDOMeOX	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1110	dXbVDDOMeOX
1111	a8I8dB8Oztl	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1111	a8I8dB8Oztl
1113	amHAOOSM5kw	4	194	akV6429SUqu	198	adZ6T35ve4h	249	aJR2ZxSH7g4	1113	amHAOOSM5kw
1114	Jc70rDN6l2B	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1114	Jc70rDN6l2B
1063	tTpyWAITi30	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1063	tTpyWAITi30
1115	IalHV5BSxEb	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1115	IalHV5BSxEb
1116	a8cUZGMlpFN	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1116	a8cUZGMlpFN
1117	VnaniHNwR1S	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1117	VnaniHNwR1S
1118	qp4HY08HICB	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1118	qp4HY08HICB
1119	xMnKacdHGIz	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1119	xMnKacdHGIz
1120	QDT6nKYPObn	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1120	QDT6nKYPObn
1536	byvlp3p7dsR	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1536	byvlp3p7dsR
1121	FbuhMjEaMXt	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1121	FbuhMjEaMXt
1122	zEkQ9IMTejV	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1122	zEkQ9IMTejV
1123	R8mMDsfgcsd	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1123	R8mMDsfgcsd
1124	Y2uKnrkZ9eV	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1124	Y2uKnrkZ9eV
1125	ajaV3Ug1PuP	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1125	ajaV3Ug1PuP
1126	sW1lqVgbz6k	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1126	sW1lqVgbz6k
1127	agmiAjuf7ro	4	194	akV6429SUqu	198	adZ6T35ve4h	276	tdZbtg9sZkO	1127	agmiAjuf7ro
1128	VBrVhVxTU7W	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1128	VBrVhVxTU7W
1129	ccykDrWXKhD	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1129	ccykDrWXKhD
1130	dBVKGKNutFP	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1130	dBVKGKNutFP
1131	DKdF7P7ky4F	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1131	DKdF7P7ky4F
2604	w3Vtnikkr4r	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	2604	w3Vtnikkr4r
1064	V9aklQkm2yr	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1064	V9aklQkm2yr
1132	dBfetAZt4c1	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1132	dBfetAZt4c1
1133	kQqMT67WT2W	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1133	kQqMT67WT2W
1134	ulnzx5SZRLA	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1134	ulnzx5SZRLA
1112	a1bvHu4FRCq	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1112	a1bvHu4FRCq
1136	NYb019QWhPQ	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1136	NYb019QWhPQ
1137	uBD4inblovY	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	1137	uBD4inblovY
1138	PMR2Cc13YGh	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1138	PMR2Cc13YGh
1139	KDXoiPpllM7	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1139	KDXoiPpllM7
2607	NJF59S6GI3h	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2607	NJF59S6GI3h
1140	dP3Esu3zfvR	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1140	dP3Esu3zfvR
1141	Rl44sEcQF4J	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1141	Rl44sEcQF4J
1142	a8wKUexqqyw	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1142	a8wKUexqqyw
1143	resyoKSgFWP	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1143	resyoKSgFWP
1144	RtQUimJT9Ek	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1144	RtQUimJT9Ek
1145	tSwz19SGiY4	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1145	tSwz19SGiY4
1146	PfhLA9YVg8z	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1146	PfhLA9YVg8z
1147	uJLhpdO3O7K	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1147	uJLhpdO3O7K
1148	Iw6keYNnGOk	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1148	Iw6keYNnGOk
1149	mzTzzMsXjM9	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1149	mzTzzMsXjM9
1150	js9oxW08GfX	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1150	js9oxW08GfX
1151	OltIU5j6TaY	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1151	OltIU5j6TaY
1152	aKVAF30coFQ	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1152	aKVAF30coFQ
1153	gcJKnH2Ypa2	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1153	gcJKnH2Ypa2
1154	gAYBU4aipnZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1154	gAYBU4aipnZ
1155	o6ovDOHBgez	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1155	o6ovDOHBgez
1156	aCaPqIkvV2s	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1156	aCaPqIkvV2s
1157	vPNvgAKiwMi	4	194	akV6429SUqu	195	pz9Uu65Irbg	266	iqsaGItA68C	1157	vPNvgAKiwMi
1158	ARBWmz1XLMI	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1158	ARBWmz1XLMI
1159	OOoyWm1xvfG	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1159	OOoyWm1xvfG
1160	P78aC0ujKWk	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1160	P78aC0ujKWk
1161	WXGWfHkIJS9	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1161	WXGWfHkIJS9
1162	MZPstrhbA2g	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1162	MZPstrhbA2g
1163	aXyuXVfPhwz	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1163	aXyuXVfPhwz
1164	aPkiP7PQgCU	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1164	aPkiP7PQgCU
1165	HjoAahqy6Yw	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1165	HjoAahqy6Yw
1166	PBqMI3x2WeG	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1166	PBqMI3x2WeG
1167	FHJczgAz2ML	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1167	FHJczgAz2ML
1168	aSxiOcCkU0C	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1168	aSxiOcCkU0C
1098	a6WHMHqHS7a	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1098	a6WHMHqHS7a
1169	YeM7sYuP1xa	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1169	YeM7sYuP1xa
1170	gDG5yDZ6hiy	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1170	gDG5yDZ6hiy
1171	CoRoHHdK9FC	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1171	CoRoHHdK9FC
1172	FH7eT8hveKf	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1172	FH7eT8hveKf
1173	FWvHZdDKXd1	4	194	akV6429SUqu	195	pz9Uu65Irbg	274	W0kQBddyGyh	1173	FWvHZdDKXd1
1174	mPhXfTnsI3S	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1174	mPhXfTnsI3S
1175	LF0fSY2ILTy	4	194	akV6429SUqu	196	auJdpeHbeet	246	PJFtfCyp6Rb	1175	LF0fSY2ILTy
1176	Ip1gZFlVBg7	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1176	Ip1gZFlVBg7
2428	eQX0AdRrOfu	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	2428	eQX0AdRrOfu
1177	ZA7d44nDMn9	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1177	ZA7d44nDMn9
1178	SkMZHCUnzSK	4	194	akV6429SUqu	197	VA90IqaI4Ji	244	lQj3yMM1lI7	1178	SkMZHCUnzSK
1179	abHXswMdUC4	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1179	abHXswMdUC4
1180	atNffeiZvJ7	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1180	atNffeiZvJ7
1181	aRg8TDbBLG5	4	194	akV6429SUqu	197	VA90IqaI4Ji	200	aPRNSGUR3vk	1181	aRg8TDbBLG5
2429	VOzSTeqb6FF	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	2429	VOzSTeqb6FF
1182	It68vhwjK9d	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1182	It68vhwjK9d
1183	M3Pmx8tT6Z0	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1183	M3Pmx8tT6Z0
1184	oj3kh1K3c92	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1184	oj3kh1K3c92
1185	gozR97R4Khm	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1185	gozR97R4Khm
1186	C7fvZef106g	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1186	C7fvZef106g
1187	OsIhf9n3bXq	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1187	OsIhf9n3bXq
1188	tTZFQkyysiA	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1188	tTZFQkyysiA
1189	x50dfSoQUiV	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1189	x50dfSoQUiV
1190	GXpcZGzzZld	4	194	akV6429SUqu	197	VA90IqaI4Ji	253	JrHILmtK0OU	1190	GXpcZGzzZld
1191	a7rSAVPxSgz	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1191	a7rSAVPxSgz
1192	gzw1SzvRwhp	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1192	gzw1SzvRwhp
1193	jUjZnYO6hUP	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1193	jUjZnYO6hUP
1194	WQ0tKwuAKiu	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1194	WQ0tKwuAKiu
1195	l2rFeHo9dfd	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1195	l2rFeHo9dfd
1196	tecfO3gvavj	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1196	tecfO3gvavj
1197	afMspJFqzy0	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1197	afMspJFqzy0
1198	hriseTUfks9	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1198	hriseTUfks9
1199	a2lazVXF8h0	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1199	a2lazVXF8h0
1200	unv8Mf3d1rl	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1200	unv8Mf3d1rl
1201	YL7WGm3qhJM	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	1201	YL7WGm3qhJM
1202	akmhIvDeUc3	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1202	akmhIvDeUc3
1204	lCAzLvgKtQd	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1204	lCAzLvgKtQd
1205	L9Tu7DLXDWf	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1205	L9Tu7DLXDWf
1206	hhepptsETDL	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1206	hhepptsETDL
1207	jxS8tyaOxom	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1207	jxS8tyaOxom
1208	fATqj07PHYr	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1208	fATqj07PHYr
1209	PTydXF4vkcb	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1209	PTydXF4vkcb
1210	aNYVpLHVWVQ	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1210	aNYVpLHVWVQ
1211	L2U4GtsXEpx	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1211	L2U4GtsXEpx
1212	WwbY46nZ6GJ	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1212	WwbY46nZ6GJ
1213	LLAbaUTIKKz	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1213	LLAbaUTIKKz
1214	mx3iKoXSg9l	4	194	akV6429SUqu	196	auJdpeHbeet	304	B0G9cqixld8	1214	mx3iKoXSg9l
1215	aIUWnrP1UkC	4	194	akV6429SUqu	197	VA90IqaI4Ji	302	GLHh0BXys9w	1215	aIUWnrP1UkC
1216	pYQZOdSlZAz	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1216	pYQZOdSlZAz
1217	AA8TRyfTwtn	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1217	AA8TRyfTwtn
1218	x2N6BwYSFr8	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1218	x2N6BwYSFr8
1219	LBdhCYNiWCn	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1219	LBdhCYNiWCn
1220	mqxYq0fQIXf	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1220	mqxYq0fQIXf
1221	xmBzxlSRY4r	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1221	xmBzxlSRY4r
1222	ay4fqIXfwka	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1222	ay4fqIXfwka
1223	aNQKIokHNo6	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1223	aNQKIokHNo6
1224	i7M0C7n2uB0	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1224	i7M0C7n2uB0
1225	M7EUkvZed0e	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1225	M7EUkvZed0e
1226	oEFcsYJgkHV	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1226	oEFcsYJgkHV
1227	zUlsz5QOq4e	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1227	zUlsz5QOq4e
1228	B3slkfrgMRU	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1228	B3slkfrgMRU
1229	aMbwlzLZVsf	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1229	aMbwlzLZVsf
1230	rkgET3qTHmL	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1230	rkgET3qTHmL
1231	xYDLn9Sqaac	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1231	xYDLn9Sqaac
1232	PjhyW3z1eVs	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1232	PjhyW3z1eVs
1233	JEKNYSV6wvH	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1233	JEKNYSV6wvH
1234	KAUpmFGlBgW	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1234	KAUpmFGlBgW
1235	DQc5kV0NulE	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1235	DQc5kV0NulE
1236	LkCq9TdFwPe	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1236	LkCq9TdFwPe
1237	Tk7ofkvg3K9	4	194	akV6429SUqu	197	VA90IqaI4Ji	241	aZLZPPjqft0	1237	Tk7ofkvg3K9
1238	oQJH7ffJs1R	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1238	oQJH7ffJs1R
1239	GzQBIYVSUhV	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1239	GzQBIYVSUhV
1240	acI8lyq9jgr	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1240	acI8lyq9jgr
1241	SazalLP46YD	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1241	SazalLP46YD
1242	yG3R0J1qk4S	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1242	yG3R0J1qk4S
1243	agP7sOujwQ7	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1243	agP7sOujwQ7
1244	dL9ehAbVZUU	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1244	dL9ehAbVZUU
1246	FWimTcTZqM5	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1246	FWimTcTZqM5
1247	tjUxvkdGJ6y	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1247	tjUxvkdGJ6y
1248	lOsKnJcNQzX	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1248	lOsKnJcNQzX
1249	BdksaWC7crj	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1249	BdksaWC7crj
1250	hzZatGLk0q7	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1250	hzZatGLk0q7
1251	kKEBeO1LL7S	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1251	kKEBeO1LL7S
1252	KD0DEkooFhS	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1252	KD0DEkooFhS
1253	aMjwtFPZA3H	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1253	aMjwtFPZA3H
1254	zGdzg5hNpYO	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1254	zGdzg5hNpYO
1255	zGvow9Y6Awr	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1255	zGvow9Y6Awr
1256	omOX1GefJV8	4	194	akV6429SUqu	197	VA90IqaI4Ji	291	lzWuB6bCQeV	1256	omOX1GefJV8
1257	O75JEwLpIwW	4	194	akV6429SUqu	198	adZ6T35ve4h	309	AhwgeZQYj16	1257	O75JEwLpIwW
1258	wYoqkK8QUwM	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1258	wYoqkK8QUwM
1259	H4tQzkRKUNV	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1259	H4tQzkRKUNV
1260	az05GsgiKFF	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1260	az05GsgiKFF
1261	ptvKeuNVX6s	4	194	akV6429SUqu	195	pz9Uu65Irbg	292	VuHCApXcMTm	1261	ptvKeuNVX6s
1262	n5qiWcR51id	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1262	n5qiWcR51id
1263	ZTuSeOtiQni	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1263	ZTuSeOtiQni
1264	aMOfdLbimPZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1264	aMOfdLbimPZ
1265	GL0v8GPeUvF	4	194	akV6429SUqu	195	pz9Uu65Irbg	231	ZuQHWOaFQVM	1265	GL0v8GPeUvF
1135	arG3rmRFr7R	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1135	arG3rmRFr7R
1266	BB2J33NR7Dx	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1266	BB2J33NR7Dx
1267	lQYgbIyb32L	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1267	lQYgbIyb32L
2609	d9WtGKgg65W	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	2609	d9WtGKgg65W
1268	h406m6Bzo7K	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1268	h406m6Bzo7K
1269	aUF5lfBvkBv	4	194	akV6429SUqu	195	pz9Uu65Irbg	234	JyZJhGXKeEq	1269	aUF5lfBvkBv
1270	aTC9aDSibvV	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1270	aTC9aDSibvV
1271	qFIN6OqYHyT	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1271	qFIN6OqYHyT
1272	aOw1OatOZPe	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1272	aOw1OatOZPe
1273	qMYnyy4UbXl	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1273	qMYnyy4UbXl
1274	DLZHSyxD2Eu	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1274	DLZHSyxD2Eu
1275	DJpSMaBi8QN	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1275	DJpSMaBi8QN
1276	aqumUYpc1O3	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1276	aqumUYpc1O3
1277	rR0HG5n2orn	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1277	rR0HG5n2orn
1278	zbSnVGJrhQK	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1278	zbSnVGJrhQK
1279	blpraSaOXw0	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1279	blpraSaOXw0
1280	aWV1RUl4uWC	4	194	akV6429SUqu	198	adZ6T35ve4h	237	gUaoj8Geuao	1280	aWV1RUl4uWC
1283	h7rS7d8M2jI	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1283	h7rS7d8M2jI
1284	r19kbQBjko2	4	194	akV6429SUqu	198	adZ6T35ve4h	236	kb7iUQISRlx	1284	r19kbQBjko2
1285	YoysVtAL2hS	4	194	akV6429SUqu	198	adZ6T35ve4h	254	kJCEJnXLgnh	1285	YoysVtAL2hS
1286	aTqees1o4V6	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1286	aTqees1o4V6
1287	i93w6kNOmuT	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1287	i93w6kNOmuT
1288	I7p8gyqE4lE	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1288	I7p8gyqE4lE
1289	Jty2W5j6aWP	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1289	Jty2W5j6aWP
1290	eMbM3ntRRMe	4	194	akV6429SUqu	198	adZ6T35ve4h	247	oNxpMjveyZt	1290	eMbM3ntRRMe
1291	FTbWW3RQjIc	4	194	akV6429SUqu	198	adZ6T35ve4h	239	MtpE3CH6vq3	1291	FTbWW3RQjIc
1292	oWRTyNICPdf	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	1292	oWRTyNICPdf
1293	atEE4GDUI2h	4	194	akV6429SUqu	197	VA90IqaI4Ji	286	aqpd0Y9eXZ2	1293	atEE4GDUI2h
1294	hwebBowmZ7w	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1294	hwebBowmZ7w
1245	y7RFe3e9KKO	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1245	y7RFe3e9KKO
1295	ppkMVgeDCK0	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1295	ppkMVgeDCK0
1296	McVQHO6D8M7	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1296	McVQHO6D8M7
1592	VHak0ZFer7F	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1592	VHak0ZFer7F
1297	qLxrGCn9hAN	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1297	qLxrGCn9hAN
1298	lEUPQBvOtge	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1298	lEUPQBvOtge
1299	Uzi6oqsmWod	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1299	Uzi6oqsmWod
1300	raWSnyIytKm	4	194	akV6429SUqu	197	VA90IqaI4Ji	240	a3LMKP8z8Xj	1300	raWSnyIytKm
1301	eeBbHGQ0Z2K	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1301	eeBbHGQ0Z2K
1302	LmtC4nnHnZr	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1302	LmtC4nnHnZr
1303	VSxYEJhhOT4	4	194	akV6429SUqu	198	adZ6T35ve4h	267	h1O9AvNR4jS	1303	VSxYEJhhOT4
1304	coddMVYZDBC	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1304	coddMVYZDBC
1305	x6skp5j1Sww	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1305	x6skp5j1Sww
1306	RkdZOxEbO4w	4	194	akV6429SUqu	195	pz9Uu65Irbg	297	EDhGji3EteB	1306	RkdZOxEbO4w
1307	TUXZLkFga0q	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1307	TUXZLkFga0q
1308	ezgM4Z4aWIc	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1308	ezgM4Z4aWIc
1309	pv2sbE1glyI	4	194	akV6429SUqu	198	adZ6T35ve4h	299	aj4hsYK3dVm	1309	pv2sbE1glyI
1310	VeSVU5gWpPv	4	194	akV6429SUqu	196	auJdpeHbeet	288	CQTmrrriwOq	1310	VeSVU5gWpPv
1311	u15TM0AiEC3	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1311	u15TM0AiEC3
1312	q6pj00ArvMt	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1312	q6pj00ArvMt
1313	aXKgezTIy3F	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1313	aXKgezTIy3F
1314	tzIWNdJGfLJ	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1314	tzIWNdJGfLJ
1315	w8tQUCOIBLf	4	194	akV6429SUqu	198	adZ6T35ve4h	242	F3ccON3OCsL	1315	w8tQUCOIBLf
1316	gtYMnQp5i5d	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1316	gtYMnQp5i5d
1317	o2AmXGnxfGy	4	194	akV6429SUqu	197	VA90IqaI4Ji	275	YMMexeHFUay	1317	o2AmXGnxfGy
1318	RPWh7oVz9kg	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1318	RPWh7oVz9kg
1319	wZVOGC8j9Wu	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1319	wZVOGC8j9Wu
1320	Mg6A6eQOMWJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1320	Mg6A6eQOMWJ
1321	te7XHeZeaId	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1321	te7XHeZeaId
1322	Bsrkpxh3yzN	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1322	Bsrkpxh3yzN
1323	Y60BygAP9NH	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1323	Y60BygAP9NH
1378	weGoxVGJism	4	194	akV6429SUqu	198	adZ6T35ve4h	296	esIUe2tQAtL	1378	weGoxVGJism
1325	p8sjPfR588j	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1325	p8sjPfR588j
1326	QRDEYBjoQkE	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1326	QRDEYBjoQkE
1327	cLqDIzGpHIA	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1327	cLqDIzGpHIA
1328	MZQeEUso8Um	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1328	MZQeEUso8Um
1329	vNdP5dtds30	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1329	vNdP5dtds30
1330	fjuPviYKfGN	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1330	fjuPviYKfGN
1331	xR3tMZhXRSG	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1331	xR3tMZhXRSG
1332	eJ6V2fUvJa3	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1332	eJ6V2fUvJa3
1333	ZXKYB8MLZ0N	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1333	ZXKYB8MLZ0N
1281	K8EbLIWv4gn	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1281	K8EbLIWv4gn
1334	XziArrrpUNq	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1334	XziArrrpUNq
1335	cK0HH9ZqvdJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1335	cK0HH9ZqvdJ
1336	XI6wsL7BBbu	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1336	XI6wsL7BBbu
1337	aPcTrAQZUXQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1337	aPcTrAQZUXQ
1338	lmgYdspcL6p	4	194	akV6429SUqu	196	auJdpeHbeet	203	uCVQXAdKqL9	1338	lmgYdspcL6p
1339	IlCTmTQDK1j	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1339	IlCTmTQDK1j
1340	mzN07vjeNN8	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1340	mzN07vjeNN8
1341	aeWGRzEMtRa	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1341	aeWGRzEMtRa
1342	PFmDufIDfGB	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1342	PFmDufIDfGB
1343	Nc5nlJywn4F	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1343	Nc5nlJywn4F
1344	NFhTAn0f77V	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1344	NFhTAn0f77V
1282	YRxg8b8P3CN	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1282	YRxg8b8P3CN
1345	MobV3oxRvud	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1345	MobV3oxRvud
1203	Qf74g7IuA7j	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1203	Qf74g7IuA7j
1346	m1aZdsy6aOH	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1346	m1aZdsy6aOH
1347	Ler1BWHg56d	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1347	Ler1BWHg56d
1348	IkJ8rVHyW5X	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1348	IkJ8rVHyW5X
1349	AzKsBz4epB3	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1349	AzKsBz4epB3
1350	LBmenMWrESK	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1350	LBmenMWrESK
1351	mbruZc0Y2Wv	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1351	mbruZc0Y2Wv
1352	aXiw1i9etPS	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1352	aXiw1i9etPS
1354	gSrojZccMJ7	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1354	gSrojZccMJ7
1355	C8KGSaxhXaQ	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1355	C8KGSaxhXaQ
1356	cXuZrvRWFcg	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1356	cXuZrvRWFcg
1357	QT2X5ExHi0h	4	194	akV6429SUqu	195	pz9Uu65Irbg	227	NREoMszwQZW	1357	QT2X5ExHi0h
1358	aT8hmwXQ07D	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1358	aT8hmwXQ07D
1359	rR2AOks4tG6	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1359	rR2AOks4tG6
1360	t9AXNBpffmR	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1360	t9AXNBpffmR
1361	sIxtI5tcPqo	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1361	sIxtI5tcPqo
1362	c2axH7WAdTn	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1362	c2axH7WAdTn
1363	QnyFjJrR0jW	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1363	QnyFjJrR0jW
1364	nFhF5jPXNM8	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1364	nFhF5jPXNM8
1365	EkLjk71mOyH	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1365	EkLjk71mOyH
1366	H5dzLI03le7	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1366	H5dzLI03le7
1367	N38gC3CNUib	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1367	N38gC3CNUib
1368	spa5nU4NVar	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1368	spa5nU4NVar
1369	gtOP1Uo7oOx	4	194	akV6429SUqu	196	auJdpeHbeet	278	O9MoQcpZ4uA	1369	gtOP1Uo7oOx
1370	vLujVIJd0j7	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1370	vLujVIJd0j7
1371	cCy6kanD5Hw	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1371	cCy6kanD5Hw
1372	qZxQw5vhQmN	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1372	qZxQw5vhQmN
1373	eSxa9KsHr5h	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1373	eSxa9KsHr5h
1375	rVlOahJhyvJ	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1375	rVlOahJhyvJ
1376	Uuo4aSz4x5g	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1376	Uuo4aSz4x5g
1377	oSEii1BuIbC	4	194	akV6429SUqu	197	VA90IqaI4Ji	219	bIONCoCnt3Q	1377	oSEii1BuIbC
1379	S6TrG4cNUIZ	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1379	S6TrG4cNUIZ
1380	Q9dlhYRxdUL	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1380	Q9dlhYRxdUL
1382	OpD74f0SyGI	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1382	OpD74f0SyGI
1383	VTWueywhLKE	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1383	VTWueywhLKE
1384	sXpYXsXppVM	4	194	akV6429SUqu	196	auJdpeHbeet	308	aPhSZRinfbg	1384	sXpYXsXppVM
1385	jpCB71nqbJu	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1385	jpCB71nqbJu
1386	Q94ayRFilbA	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1386	Q94ayRFilbA
1387	acQJJL9aUo0	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1387	acQJJL9aUo0
1388	apKpog39DlX	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1388	apKpog39DlX
1389	Fi0oIAe06s4	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1389	Fi0oIAe06s4
1391	muPPh3RbpBj	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1391	muPPh3RbpBj
1392	azZk0TJOe3j	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1392	azZk0TJOe3j
1393	aBmWpMfBVjr	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1393	aBmWpMfBVjr
1394	p1iOb5SBsBd	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1394	p1iOb5SBsBd
1395	qbyIofSU5tA	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1395	qbyIofSU5tA
1396	YM9WoJWgiZk	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1396	YM9WoJWgiZk
1397	MaMG7y4TKz4	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1397	MaMG7y4TKz4
2598	cPS96oUSKL7	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	2598	cPS96oUSKL7
1398	UNiDU0Y3r2i	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1398	UNiDU0Y3r2i
1399	NmKQP1XcgKJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1399	NmKQP1XcgKJ
1400	yTUn4OdHAs4	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1400	yTUn4OdHAs4
1401	lbIyDdBijdD	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1401	lbIyDdBijdD
1374	PrIDcobIQsW	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1374	PrIDcobIQsW
1402	XWHw6fTKtoE	4	194	akV6429SUqu	195	pz9Uu65Irbg	243	wMQ25dybdgH	1402	XWHw6fTKtoE
1403	CPvpbCc51Aw	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1403	CPvpbCc51Aw
1404	ag7SEvoulDA	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1404	ag7SEvoulDA
1405	ERioiaRYt58	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1405	ERioiaRYt58
1406	g4jN39Mu4K8	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1406	g4jN39Mu4K8
1407	BBqkdNv0rk1	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1407	BBqkdNv0rk1
1408	xFPP0xRg2AV	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1408	xFPP0xRg2AV
1409	y5VwP02ADlq	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1409	y5VwP02ADlq
1410	aZAE15J3Zb1	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1410	aZAE15J3Zb1
1411	ZZmXu10Dnci	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1411	ZZmXu10Dnci
1412	Lv7IX3Xxutv	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1412	Lv7IX3Xxutv
1413	Y5n22tapmhs	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1413	Y5n22tapmhs
1575	VvSRAEcdc5o	4	194	akV6429SUqu	195	pz9Uu65Irbg	230	p7EEgDEX3jT	1575	VvSRAEcdc5o
1353	XAYIceYQGIl	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1353	XAYIceYQGIl
1414	J9Q5GilXIvy	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1414	J9Q5GilXIvy
1415	hMmTuvB73LZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	913191	DAfT22pPqzk	1415	hMmTuvB73LZ
1416	vhBrLJBbs8t	4	194	akV6429SUqu	198	adZ6T35ve4h	221	saT18HClZoz	1416	vhBrLJBbs8t
1417	bZBIK5nSjJS	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1417	bZBIK5nSjJS
1418	igvemwDsp2j	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1418	igvemwDsp2j
1419	iDEPY2bO8nQ	4	194	akV6429SUqu	195	pz9Uu65Irbg	264	pnTVIF5v27r	1419	iDEPY2bO8nQ
1420	a4OYFNcMXZO	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1420	a4OYFNcMXZO
1421	PNnzRWEmz8V	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1421	PNnzRWEmz8V
1422	QjFwopEl3i9	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1422	QjFwopEl3i9
1423	rWKu3uQbesz	4	194	akV6429SUqu	198	adZ6T35ve4h	252	QoRZB7xc3j9	1423	rWKu3uQbesz
1424	Zb0o00tdmnx	4	194	akV6429SUqu	195	pz9Uu65Irbg	201	aXjub1BYn1y	1424	Zb0o00tdmnx
1425	j9JRmkoveVc	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1425	j9JRmkoveVc
1426	hZA6Q0HfT0V	4	194	akV6429SUqu	195	pz9Uu65Irbg	265	xpIFdCMhVHG	1426	hZA6Q0HfT0V
1427	gijuR34Jj5H	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1427	gijuR34Jj5H
1428	EgcvIoAN7Ti	4	194	akV6429SUqu	195	pz9Uu65Irbg	213	C0RSe3EWBqU	1428	EgcvIoAN7Ti
1390	xEGUTFJd2LB	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1390	xEGUTFJd2LB
1429	OoSjd5RuEQb	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1429	OoSjd5RuEQb
2599	C8B19BSd474	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	2599	C8B19BSd474
1430	b24YFQUhFfF	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1430	b24YFQUhFfF
1431	lHy3V8wTvjA	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1431	lHy3V8wTvjA
1432	HMzXFZXwkDG	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1432	HMzXFZXwkDG
1433	OKIyTJatyIr	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1433	OKIyTJatyIr
1434	WIp1921a57B	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1434	WIp1921a57B
1435	wMj4Uco2mMl	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1435	wMj4Uco2mMl
1436	zzl9JUHMQY1	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1436	zzl9JUHMQY1
1437	elu8zUTsqIW	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1437	elu8zUTsqIW
1438	IC4N267eDYG	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1438	IC4N267eDYG
1439	HGPMh3r18FZ	4	194	akV6429SUqu	196	auJdpeHbeet	224	xr8EMirOASp	1439	HGPMh3r18FZ
1440	kRF4X846xVW	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1440	kRF4X846xVW
1569	Whc0SWU4T5n	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1569	Whc0SWU4T5n
1441	nLCKvxD90Ek	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1441	nLCKvxD90Ek
2357719	GIXkEmjvUPh	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	2357719	GIXkEmjvUPh
1442	a1HgVn8Q288	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1442	a1HgVn8Q288
1443	KhXTdz48N9o	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1443	KhXTdz48N9o
1444	YxleBIY0wms	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1444	YxleBIY0wms
1445	B4c4U2wA0w0	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1445	B4c4U2wA0w0
1446	N00GWUvXv52	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1446	N00GWUvXv52
1447	axeaTpoaevL	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1447	axeaTpoaevL
1448	kVC2XemQfB6	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1448	kVC2XemQfB6
1449	aQuFXdkixjd	4	194	akV6429SUqu	195	pz9Uu65Irbg	281	xy0M4HhjXtD	1449	aQuFXdkixjd
1576	jAd3Yz8eWoM	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1576	jAd3Yz8eWoM
1450	JxlOhSzW8GJ	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1450	JxlOhSzW8GJ
1451	Uf7qbLumqbn	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1451	Uf7qbLumqbn
1452	gqlcWIrj9J3	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1452	gqlcWIrj9J3
1453	X3w6hzHSdUe	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1453	X3w6hzHSdUe
1454	mJidDmRCdn8	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1454	mJidDmRCdn8
1455	tlIMKbS5bmI	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1455	tlIMKbS5bmI
1456	SE5V8TUKQnZ	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1456	SE5V8TUKQnZ
1457	hrxNQMA6PNu	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1457	hrxNQMA6PNu
1458	DyMUZat98Gm	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1458	DyMUZat98Gm
1573	spJaE9AvZmf	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1573	spJaE9AvZmf
1459	HoW0caoiLjf	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1459	HoW0caoiLjf
1460	K9pBdHdIp6Z	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1460	K9pBdHdIp6Z
1627	tt9yUB7IjHC	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	1627	tt9yUB7IjHC
1461	CyUUpNIQ98L	4	194	akV6429SUqu	195	pz9Uu65Irbg	306	aBrjuZk0W31	1461	CyUUpNIQ98L
1462	GhrSbqvL2At	4	194	akV6429SUqu	195	pz9Uu65Irbg	310	zNgVoDVPYgD	1462	GhrSbqvL2At
1463	SjjQnm5MK1W	4	194	akV6429SUqu	198	adZ6T35ve4h	202	WiVj4bEhX4P	1463	SjjQnm5MK1W
1464	iFx5B3JZNWU	4	194	akV6429SUqu	195	pz9Uu65Irbg	271	Lj8t70RYnEt	1464	iFx5B3JZNWU
1465	aSNralWoVvR	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	1465	aSNralWoVvR
6957	WnFW4rCaYbF	4	194	akV6429SUqu	197	VA90IqaI4Ji	279	P8iz90eiIrW	6957	WnFW4rCaYbF
1467	FsrPvHIMo4j	4	194	akV6429SUqu	195	pz9Uu65Irbg	287	aPZzL4CyBTg	1467	FsrPvHIMo4j
1468	RIRO5KSi82T	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1468	RIRO5KSi82T
1469	qD90qvNgVtw	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1469	qD90qvNgVtw
1470	Gxs5KLq9tWr	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1470	Gxs5KLq9tWr
1471	aazt2Bo4gk8	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1471	aazt2Bo4gk8
1472	wCiHoNAAXNp	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1472	wCiHoNAAXNp
1473	oweSpFBNbmi	4	194	akV6429SUqu	197	VA90IqaI4Ji	262	aXmBzv61LbM	1473	oweSpFBNbmi
1474	iYyORXQ8Z6h	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1474	iYyORXQ8Z6h
1475	W9JVeFCwE5n	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1475	W9JVeFCwE5n
1476	ase3dyB86hx	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1476	ase3dyB86hx
1477	L91J9E1sJbc	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1477	L91J9E1sJbc
1478	mV8AQZkSf3K	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1478	mV8AQZkSf3K
1479	PFkULd44r0L	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1479	PFkULd44r0L
1594	ipjC8RjDoJ0	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1594	ipjC8RjDoJ0
1595	hNN2wZnydEg	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1595	hNN2wZnydEg
1480	aBJcRBYVnCc	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1480	aBJcRBYVnCc
1481	h6Wx2ZuKWJ3	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1481	h6Wx2ZuKWJ3
1482	aqtHhUruLLD	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1482	aqtHhUruLLD
1483	T06zMrtvVyD	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1483	T06zMrtvVyD
1484	gW8zDLtLKRw	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1484	gW8zDLtLKRw
1485	rFcB1UxSU9H	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1485	rFcB1UxSU9H
1486	tjDQAJuamDX	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1486	tjDQAJuamDX
1487	DMJIQmR8GNr	4	194	akV6429SUqu	196	auJdpeHbeet	223	It5UGwdHAPF	1487	DMJIQmR8GNr
1488	KG4Ns1Klr2C	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1488	KG4Ns1Klr2C
1489	ykAaC6ZBwGO	4	194	akV6429SUqu	196	auJdpeHbeet	205	aa8xVDzSpte	1489	ykAaC6ZBwGO
1324	a7R6lzPJHUN	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1324	a7R6lzPJHUN
1490	aBKUgg9eMEK	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1490	aBKUgg9eMEK
1491	S1nFWV7Ij1f	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1491	S1nFWV7Ij1f
1492	xRBoyoffMdY	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1492	xRBoyoffMdY
1493	aQtZqGVl9u2	4	194	akV6429SUqu	196	auJdpeHbeet	285	tugqr4dY6wq	1493	aQtZqGVl9u2
1494	s9FltYF4w25	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1494	s9FltYF4w25
1495	PpJwAqyUEAw	4	194	akV6429SUqu	196	auJdpeHbeet	260	FLygHiUd2UW	1495	PpJwAqyUEAw
1496	FV5oHVJGVQj	4	194	akV6429SUqu	196	auJdpeHbeet	269	r8WLxW9JwsS	1496	FV5oHVJGVQj
1497	ubp4U8p1EGD	4	194	akV6429SUqu	196	auJdpeHbeet	248	UaR7OHycj8c	1497	ubp4U8p1EGD
1498	M3o19feuYfH	4	194	akV6429SUqu	196	auJdpeHbeet	208	tM3DsJxMaMX	1498	M3o19feuYfH
1499	El1yfqR0BNT	4	194	akV6429SUqu	196	auJdpeHbeet	307	aphcy5JTnd6	1499	El1yfqR0BNT
1500	qgAScVAF3qQ	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1500	qgAScVAF3qQ
1501	zXzgzNuexTY	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1501	zXzgzNuexTY
1502	DUP58MfrOO5	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1502	DUP58MfrOO5
1503	anYY2nbOTA5	4	194	akV6429SUqu	196	auJdpeHbeet	257	zBIpPzKYFLp	1503	anYY2nbOTA5
1504	aLbdtQFDIfU	4	194	akV6429SUqu	196	auJdpeHbeet	259	auswb7JO9wY	1504	aLbdtQFDIfU
1505	y1eq9C6oPWj	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1505	y1eq9C6oPWj
1506	E2ZDSHzpE6w	4	194	akV6429SUqu	196	auJdpeHbeet	300	z8D9ER36EKN	1506	E2ZDSHzpE6w
1507	OelY0OuJRrh	4	194	akV6429SUqu	196	auJdpeHbeet	301	hAoe9dhZh9V	1507	OelY0OuJRrh
1508	AyD2uS3F3Jb	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1508	AyD2uS3F3Jb
1509	Bk8WGRJ6zC2	4	194	akV6429SUqu	196	auJdpeHbeet	209	sWoNWQZ9qrD	1509	Bk8WGRJ6zC2
1510	d8G3QcJpzxC	4	194	akV6429SUqu	196	auJdpeHbeet	270	a9tQqo1rSj7	1510	d8G3QcJpzxC
1511	QeI9XXwoy2h	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1511	QeI9XXwoy2h
1512	dS6Xrka1WwD	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1512	dS6Xrka1WwD
1513	PQEJbD9Vybo	4	194	akV6429SUqu	196	auJdpeHbeet	238	fS71jg1WYPk	1513	PQEJbD9Vybo
1514	aqJaciRotCj	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1514	aqJaciRotCj
1515	jkd1XWIp0ZR	4	194	akV6429SUqu	196	auJdpeHbeet	305	qf9xWZu7Dq8	1515	jkd1XWIp0ZR
1516	y8ZoiFCNV8W	4	194	akV6429SUqu	197	VA90IqaI4Ji	218	a0DfYpC2Rwl	1516	y8ZoiFCNV8W
1517	M9l386COmzm	4	194	akV6429SUqu	197	VA90IqaI4Ji	290	j7AQsnEYmvi	1517	M9l386COmzm
1617	qp2LM87D7ie	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1617	qp2LM87D7ie
1518	XB8o8p7f97z	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1518	XB8o8p7f97z
2605	HITX9bsKQwR	4	194	akV6429SUqu	198	adZ6T35ve4h	212	zJfpujxC1kD	2605	HITX9bsKQwR
2603	x3s74yCtzFy	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	2603	x3s74yCtzFy
1519	DPDFR2NSNL4	4	194	akV6429SUqu	196	auJdpeHbeet	215	xAJgEKKAeRA	1519	DPDFR2NSNL4
1520	p4JCTAyEhij	4	194	akV6429SUqu	195	pz9Uu65Irbg	251	eOJUW6OGpc7	1520	p4JCTAyEhij
1521	aifNCvFFHYu	4	194	akV6429SUqu	198	adZ6T35ve4h	295	Ut0ysYGEipO	1521	aifNCvFFHYu
1522	HlBP6Xv1pEx	4	194	akV6429SUqu	198	adZ6T35ve4h	226	lkuO79O6mRx	1522	HlBP6Xv1pEx
1523	audl05CJPvD	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1523	audl05CJPvD
1524	a98vV85q7VA	4	194	akV6429SUqu	196	auJdpeHbeet	211	g8M1cWRJZV6	1524	a98vV85q7VA
1525	uyxasfC9cr3	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1525	uyxasfC9cr3
1526	S4m2TKOXxUp	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1526	S4m2TKOXxUp
1527	mj0OwLAoGxj	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1527	mj0OwLAoGxj
1528	U3F1jMS8CYd	4	194	akV6429SUqu	198	adZ6T35ve4h	283	auLatLbcOxf	1528	U3F1jMS8CYd
1529	fISqLilkoLm	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1529	fISqLilkoLm
1530	aKJnwPPfPhk	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1530	aKJnwPPfPhk
1531	ys2eaRzu6MB	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1531	ys2eaRzu6MB
1532	xnqsEM3TxbR	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1532	xnqsEM3TxbR
1533	a0awJjtBQ2u	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1533	a0awJjtBQ2u
1534	c3RuJBL6y2x	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1534	c3RuJBL6y2x
1535	ak477N3SWYO	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1535	ak477N3SWYO
1537	kw9oIuVNzcJ	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	1537	kw9oIuVNzcJ
1538	XdqPw4hn5nq	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1538	XdqPw4hn5nq
1539	fIAdaHNM2zm	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1539	fIAdaHNM2zm
1540	FngcsacEaM4	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1540	FngcsacEaM4
1541	q1TxlOLZPqV	4	194	akV6429SUqu	195	pz9Uu65Irbg	277	A9kRCvmn6Co	1541	q1TxlOLZPqV
1542	OR4TRYV75lr	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1542	OR4TRYV75lr
1543	vleQsSrMRcT	4	194	akV6429SUqu	198	adZ6T35ve4h	204	aginheWSLef	1543	vleQsSrMRcT
1544	ugewbq4RtKN	4	194	akV6429SUqu	198	adZ6T35ve4h	303	Oyxwe3iDqpR	1544	ugewbq4RtKN
1545	vJLeTItF2kD	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1545	vJLeTItF2kD
1546	NwjAOvrcNuU	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1546	NwjAOvrcNuU
1570	a9Gy7Imvd9F	4	194	akV6429SUqu	198	adZ6T35ve4h	220	KhT80mlwJ3Y	1570	a9Gy7Imvd9F
1571	aNvDakWiwMs	4	194	akV6429SUqu	198	adZ6T35ve4h	210	JIZDvNlIhXS	1571	aNvDakWiwMs
2357613	qfSk8i2Td5s	4	194	akV6429SUqu	197	VA90IqaI4Ji	261	Q7PaNIbyZII	2357613	qfSk8i2Td5s
1618	abrPOGp0zoG	4	194	akV6429SUqu	198	adZ6T35ve4h	217	srmGjHrpVE5	1618	abrPOGp0zoG
1623	WWilgFGBjBC	4	194	akV6429SUqu	198	adZ6T35ve4h	272	e8m9ZYMRoeR	1623	WWilgFGBjBC
1624	GuJonnL9KkC	4	194	akV6429SUqu	195	pz9Uu65Irbg	228	QYiQ2KqgCxj	1624	GuJonnL9KkC
1547	l4qmCfoNbn6	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1547	l4qmCfoNbn6
1612	Anb2BySBeLP	4	194	akV6429SUqu	195	pz9Uu65Irbg	245	Gwk4wkLz7EW	1612	Anb2BySBeLP
1548	Fz23SXgkfYc	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1548	Fz23SXgkfYc
1549	y1iun1mJXWa	4	194	akV6429SUqu	198	adZ6T35ve4h	206	cSrCFjPKqcG	1549	y1iun1mJXWa
1550	EAw4NikTilV	4	194	akV6429SUqu	195	pz9Uu65Irbg	235	WcB3kLlgRTb	1550	EAw4NikTilV
1551	qrGzd0QTgxt	4	194	akV6429SUqu	197	VA90IqaI4Ji	294	aUcYGQCK9ub	1551	qrGzd0QTgxt
1552	IlAqwJZzL40	4	194	akV6429SUqu	197	VA90IqaI4Ji	207	ykxQEnZGXkj	1552	IlAqwJZzL40
1553	YD8E2vpUOTX	4	194	akV6429SUqu	195	pz9Uu65Irbg	298	Xjc0LDFa5gW	1553	YD8E2vpUOTX
1381	aotTeLfiAZB	4	194	akV6429SUqu	198	adZ6T35ve4h	214	hn1AlYtF1Pu	1381	aotTeLfiAZB
1554	QMYSsdVCuem	4	194	akV6429SUqu	198	adZ6T35ve4h	256	mv4gKtY0qW8	1554	QMYSsdVCuem
1556	V8DloIhJgVB	4	194	akV6429SUqu	197	VA90IqaI4Ji	199	x75Yh65MaUa	1556	V8DloIhJgVB
1593	UjUroihV9AC	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1593	UjUroihV9AC
1557	PaitbhdeU8f	4	194	akV6429SUqu	197	VA90IqaI4Ji	222	aIahLLmtvgT	1557	PaitbhdeU8f
1558	GSj56KTqJRQ	4	194	akV6429SUqu	197	VA90IqaI4Ji	293	aSbgVKaeCP0	1558	GSj56KTqJRQ
1559	xfJuqAwolQi	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1559	xfJuqAwolQi
1560	KIukjQefWsY	4	194	akV6429SUqu	198	adZ6T35ve4h	258	yuo5ielNL7W	1560	KIukjQefWsY
1561	uO3WnJBCEq5	4	194	akV6429SUqu	198	adZ6T35ve4h	263	oyygQ2STBST	1561	uO3WnJBCEq5
1562	W6dgKKl8WCg	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1562	W6dgKKl8WCg
1563	wysZBhhaSaS	4	194	akV6429SUqu	197	VA90IqaI4Ji	268	IVuiLJYABw6	1563	wysZBhhaSaS
1564	LyX5VLc9Eyz	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1564	LyX5VLc9Eyz
1555	mnk10FugmGB	4	194	akV6429SUqu	196	auJdpeHbeet	250	m77oR1YJESj	1555	mnk10FugmGB
1565	OVrhhkOMbwS	4	194	akV6429SUqu	198	adZ6T35ve4h	233	TM6ccNxawqy	1565	OVrhhkOMbwS
1566	eYw6xfpMCpt	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1566	eYw6xfpMCpt
1567	EJCiKQCS6WT	4	194	akV6429SUqu	195	pz9Uu65Irbg	229	ztIyIYAzFKp	1567	EJCiKQCS6WT
1628	uB3nFQ5y73Z	4	194	akV6429SUqu	195	pz9Uu65Irbg	216	WyR8Eetj7Uw	1628	uB3nFQ5y73Z
1629	Q1zNSRAbxjf	4	194	akV6429SUqu	195	pz9Uu65Irbg	225	W1JM2Qdhcv3	1629	Q1zNSRAbxjf
1630	kOu6Jeco0Gs	4	194	akV6429SUqu	198	adZ6T35ve4h	282	wJ2a6YKDFZW	1630	kOu6Jeco0Gs
1631	WPNKWhyNTT3	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1631	WPNKWhyNTT3
1577	qPxhlMvCde5	4	194	akV6429SUqu	197	VA90IqaI4Ji	284	tr9XWtYsL5P	1577	qPxhlMvCde5
1578	BeLWlF7oliH	4	194	akV6429SUqu	195	pz9Uu65Irbg	273	A4aGXEfdb8P	1578	BeLWlF7oliH
\.


--
-- Name: SCHEMA staging; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA staging TO analysis;


--
-- Name: TABLE program_stage_data_l; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.program_stage_data_l TO datastudio;


--
-- Name: TABLE stage_cash_transfer_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_cash_transfer_w TO datastudio;


--
-- Name: TABLE stage_condom_provision_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_condom_provision_w TO datastudio;


--
-- Name: TABLE stage_contraceptive_mix_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_contraceptive_mix_w TO datastudio;


--
-- Name: TABLE stage_dreams_exit; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_dreams_exit TO datastudio;


--
-- Name: TABLE stage_dreams_ic; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_dreams_ic TO datastudio;


--
-- Name: TABLE stage_economic_services_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_economic_services_w TO datastudio;


--
-- Name: TABLE stage_educ_subsidy_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_educ_subsidy_w TO datastudio;


--
-- Name: TABLE stage_hts_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_hts_w TO datastudio;


--
-- Name: TABLE stage_partner_services_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_partner_services_w TO datastudio;


--
-- Name: TABLE stage_prep; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_prep TO datastudio;


--
-- Name: TABLE stage_pvc_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_pvc_w TO datastudio;


--
-- Name: TABLE stage_sasa_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_sasa_w TO datastudio;


--
-- Name: TABLE stage_sbhvp_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_sbhvp_w TO datastudio;


--
-- Name: TABLE stage_sinovuyo_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_sinovuyo_w TO datastudio;


--
-- Name: TABLE stage_sstones_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.stage_sstones_w TO datastudio;


--
-- Name: TABLE agyw_srv_no; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_srv_no TO analysis;


--
-- Name: TABLE agyws_l; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyws_l TO datastudio;


--
-- Name: TABLE d_agyws_w; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.d_agyws_w TO datastudio;


--
-- Name: TABLE agyws_list; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyws_list TO analysis;


--
-- Name: TABLE agegroup_analysis2; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agegroup_analysis2 TO analysis;


--
-- Name: TABLE agyw_srv_no_minus_cancelled; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_srv_no_minus_cancelled TO analysis;


--
-- Name: TABLE agyws_list_minus_cancelled; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyws_list_minus_cancelled TO analysis;


--
-- Name: TABLE agyw_rcv_fpri_anysec; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_rcv_fpri_anysec TO analysis;


--
-- Name: TABLE agyw_service_layering; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_service_layering TO analysis;


--
-- Name: TABLE agyw_srv_no_with_screening_date; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_srv_no_with_screening_date TO analysis;


--
-- Name: TABLE agyw_srv_smry; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_srv_smry TO analysis;


--
-- Name: TABLE agyw_zero_srv; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.agyw_zero_srv TO analysis;


--
-- Name: TABLE cohort_analysis2; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.cohort_analysis2 TO analysis;


--
-- Name: TABLE ogstructure; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.ogstructure TO datastudio;


--
-- Name: TABLE pg_status; Type: ACL; Schema: staging; Owner: postgres
--

GRANT SELECT ON TABLE staging.pg_status TO datastudio;


--
-- Name: agyw_srv_no; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyw_srv_no;


--
-- Name: agyws_list; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyws_list;


--
-- Name: agegroup_analysis2; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agegroup_analysis2;


--
-- Name: agyw_srv_no_minus_cancelled; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyw_srv_no_minus_cancelled;


--
-- Name: agyws_list_minus_cancelled; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyws_list_minus_cancelled;


--
-- Name: agyw_rcv_fpri_anysec; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyw_rcv_fpri_anysec;


--
-- Name: agyw_service_layering; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyw_service_layering;


--
-- Name: agyw_srv_no_with_screening_date; Type: MATERIALIZED VIEW DATA; Schema: staging; Owner: postgres
--

REFRESH MATERIALIZED VIEW staging.agyw_srv_no_with_screening_date;


--
-- PostgreSQL database dump complete
--

