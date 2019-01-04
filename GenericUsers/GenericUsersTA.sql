/* task activity */
SELECT pruser.PERSON_ID
     ,  (CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'                                 
        end) AS TEST_OR_REAL_PT 
     , 'SENDER' AS ACTION_ROLE
     , count(*) AS TASK_ACTIVITY_COUNT
     , max(ta.UPDT_DT_TM) AS LATEST_TASK_ACTIVITY
FROM ads_v500_stage.admin.task_activity ta
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = ta.PERSON_ID
JOIN ads_v500_stage.admin.prsnl pruser
  ON pruser.PERSON_ID = ta.MSG_SENDER_ID
 AND (pruser.name_last_key like 'CHB%' 
      OR  
      pruser.name_last_key like  'BCH%')
 AND pruser.name_first_key is not null
 AND pruser.person_id > 0 
WHERE ta.PERFORMED_PRSNL_ID > 0
GROUP BY pruser.PERSON_ID
     , TEST_OR_REAL_PT 
     , ACTION_ROLE

UNION

SELECT pruser.PERSON_ID
     ,  (CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'                                 
        end) AS TEST_OR_REAL_PT 
     , 'ACTOR' AS ACTION_ROLE
     , count(*) AS TASK_ACTIVITY_COUNT
     , max(taa.UPDT_DT_TM) AS LATEST_TASK_ACTIVITY
FROM ads_v500_stage.admin.task_activity_assignment taa
JOIN ads_v500_stage.admin.task_activity ta
  ON ta.TASK_ID = taa.TASK_ID
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = ta.PERSON_ID
JOIN ads_v500_stage.admin.prsnl pruser
  ON pruser.PERSON_ID = taa.ASSIGN_PRSNL_ID
 AND (pruser.name_last_key like 'CHB%' 
      OR  
      pruser.name_last_key like  'BCH%')
 AND pruser.name_first_key is not null
 AND pruser.person_id > 0 
WHERE taa.proxy_prsnl_id = 0.0
GROUP BY pruser.PERSON_ID
     , TEST_OR_REAL_PT 
     , ACTION_ROLE

UNION

SELECT pruser.PERSON_ID
     ,  (CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'                                 
        end) AS TEST_OR_REAL_PT 
     , 'PROXY' AS ACTION_ROLE
     , count(*) AS TASK_ACTIVITY_COUNT
     , max(taa.UPDT_DT_TM) AS LATEST_TASK_ACTIVITY
FROM ads_v500_stage.admin.task_activity_assignment taa
JOIN ads_v500_stage.admin.task_activity ta
  ON ta.TASK_ID = taa.TASK_ID
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = ta.PERSON_ID
JOIN ads_v500_stage.admin.prsnl pruser
  ON pruser.PERSON_ID = taa.proxy_prsnl_id
 AND (pruser.name_last_key like 'CHB%' 
     OR  
     pruser.name_last_key like  'BCH%')
 and pruser.name_first_key is not null
 and pruser.person_id > 0 
GROUP BY pruser.PERSON_ID
     , TEST_OR_REAL_PT 
     , ACTION_ROLE