/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , pr.name_full_formatted
     , pr.username 
     , cvpos.display AS position_user 
--     , eau.directory_ind AS LDAP
--     , pr.active_ind
     , pr.end_effective_dt_tm
     , cvcontr.display AS Contributor_System
     , prup.name_full_formatted AS Updated_By
     ,  (CAST((FROM_TZ(CAST(pr.updt_dt_tm AS TIMESTAMP), '+00:00') AT TIME ZONE 'US/Eastern') AS DATE)) AS updt_dt_tm 
     , prcr.name_full_formatted AS Created_By
     , (CAST((FROM_TZ(CAST(pr.create_dt_tm  AS TIMESTAMP), '+00:00') AT TIME ZONE 'US/Eastern') AS DATE)) AS create_dt_tm   
     , (CAST((FROM_TZ(CAST(max(omf.start_day) AS TIMESTAMP), '+00:00') AT TIME ZONE 'US/Eastern') AS DATE)) AS LAST_LOGIN 
     , pr.active_ind 
 --    , eau.password_hash
 --    , eau.password_change_dt_tm
 --    , eau.password_lifetime
FROM prsnl pr
LEFT   
JOIN code_value cvpos
  ON cvpos.code_value = pr.position_cd  
 AND cvpos.code_set = 88  
LEFT   
JOIN code_value cvcontr
  ON cvcontr.code_value = pr.contributor_system_cd 
 AND cvcontr.code_set = 89  
LEFT   
JOIN prsnl prup
  ON prup.person_id = pr.updt_id
 
LEFT  
JOIN prsnl prcr
  ON prcr.person_id = pr.create_prsnl_id
LEFT  
JOIN  OMF_APP_CTX_DAY_ST omf
   ON omf.person_id = pr.person_id
  AND omf.application_number > 0
  AND omf.start_day > sysdate - 3650 
  
--JOIN ea_user eau
--  ON eau.username = pr.username
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
 
WHERE not regexp_like(pr.username,'^CH[0-9]+')  
  AND pr.name_last_key not like 'CHB%'   
  AND pr.name_last_key not like 'BCH%'  
 --- AND pr.contributor_system_cd IN (0,3805574.00) /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */ 
 --- AND pr.username != ''    
 --- AND pr.position_cd > 0  
 GROUP BY pr.person_id
     , pr.name_full_formatted
     , pr.username 
     , cvpos.display 
     , pr.end_effective_dt_tm
     , cvcontr.display
     , prup.name_full_formatted 
     , pr.updt_dt_tm 
     , prcr.name_full_formatted 
     , pr.create_dt_tm   
     , pr.active_ind 