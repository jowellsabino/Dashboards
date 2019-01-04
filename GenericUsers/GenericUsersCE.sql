/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (CASE
            WHEN p.NAME_LAST_KEY like 'SYSTEM%'
                 OR
                 p.NAME_LAST_KEY like 'TEST%'
                 OR
                 p.NAME_LAST_KEY like 'SYTEM%'
               THEN 'TEST'
               ELSE '**REAL**'
               END) AS TEST_OR_REAL_PT
        , 'ACTOR' AS USER_ROLE
        , count(cep.CE_EVENT_PRSNL_ID) AS CE_ACTIVITY
        , max(cep.ACTION_DT_TM) AS LATEST_CE_ACTIVITY
FROM ads_v500_stage.admin.prsnl pr
JOIN ads_v500_stage.admin.ce_event_prsnl cep
  ON cep.ACTION_PRSNL_ID = pr.PERSON_ID
 AND cep.PROXY_PRSNL_ID = 0.0
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
GROUP BY pr.PERSON_ID, TEST_OR_REAL_PT, USER_ROLE
 
UNION

/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (CASE
            WHEN p.NAME_LAST_KEY like 'SYSTEM%'
                 OR 
                 p.NAME_LAST_KEY like 'TEST%'
                 OR
                 p.NAME_LAST_KEY like 'SYTEM%'
                THEN 'TEST'
                ELSE '**REAL**'
                END) AS TEST_OR_REAL_PT
     , 'PROXY' AS USER_ROLE
     , count(cep.CE_EVENT_PRSNL_ID) AS CE_ACTIVITY
     , max(cep.ACTION_DT_TM) AS LATEST_CE_ACTIVITY
FROM ads_v500_stage.admin.prsnl pr
JOIN ads_v500_stage.admin.ce_event_prsnl cep
  ON cep.PROXY_PRSNL_ID = pr.PERSON_ID
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
GROUP BY pr.PERSON_ID, TEST_OR_REAL_PT, USER_ROLE
;