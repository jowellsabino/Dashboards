/* ORDER activity */
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
     , 'ORDER' AS ORDERING_ACTIVITY
     , count(*) AS ORDERING_ACTIVITY_COUNT
     , max(oa.UPDT_DT_TM) AS LATEST_ORDERING_ACTIVITY
FROM ads_v500_stage.admin.order_action oa
JOIN ads_v500_stage.admin.orders o
  ON o.ORDER_ID = oa.ORDER_ID
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = o.PERSON_ID
JOIN ads_v500_stage.admin.prsnl pruser
  ON pruser.PERSON_ID = oa.ACTION_PERSONNEL_ID 
 and (pruser.name_last_key like 'CHB%'
   or
   pruser.name_last_key like 'BCH%')
GROUP BY pruser.PERSON_ID
     , ORDERING_ACTIVITY  
     , TEST_OR_REAL_PT 
UNION

/*powerplan activity */
SELECT pruser.PERSON_ID
     ,(CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'
         end) AS TEST_OR_REAL_PT      
      , 'PLAN' AS ORDERING_ACTIVITY 
      , count(*) AS ORDERING_ACTIVITY_COUNT
      , max(pa.UPDT_DT_TM) AS LATEST_ORDERING_ACTIVITY
FROM ads_v500_stage.admin.pathway_action pa
JOIN ads_v500_stage.admin.pathway pp
  ON pp.pathway_ID = pa.pathway_ID
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = pp.PERSON_ID
JOIN ads_v500_stage.admin.prsnl pruser
  ON pruser.PERSON_ID = pa.ACTION_PRSNL_ID 
 and (pruser.name_last_key like 'CHB%'
   or
   pruser.name_last_key like 'BCH%')
GROUP BY pruser.PERSON_ID
     , ORDERING_ACTIVITY 
     , TEST_OR_REAL_PT