/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
FROM ads_v500_stage.admin.prsnl pr
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
  and not exists (SELECT 1 
                    FROM ads_v500_stage.admin.ce_event_prsnl cep
                      WHERE cep.ACTION_PRSNL_ID = pr.PERSON_ID
                      AND cep.PROXY_PRSNL_ID = 0.0)
   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.ce_event_prsnl cepprox
                     WHERE cepprox.PROXY_PRSNL_ID = pr.PERSON_ID)

   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.order_action oa
                     WHERE oa.ACTION_PERSONNEL_ID = pr.PERSON_ID)

   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.pathway_action pa
                     WHERE pa.ACTION_PRSNL_ID  = pr.PERSON_ID)

   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.task_activity ta
                     WHERE ta.MSG_SENDER_ID  = pr.PERSON_ID)
   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.task_activity_assignment taa
                     WHERE taa.ASSIGN_PRSNL_ID  = pr.PERSON_ID)
   and not exists (SELECT 1
                        FROM ads_v500_stage.admin.task_activity_assignment taa
                     WHERE taa.proxy_prsnl_id  = pr.PERSON_ID)