TYPE=VIEW
query=select distinct `huiyoufu`.`t_member_info`.`fvalue` AS `fvalue`,`huiyoufu`.`t_member_info`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_member_info`.`ftype` AS `ftype`,`huiyoufu`.`t_store`.`fstore_code` AS `fstore_code`,`huiyoufu`.`t_store`.`fstore_name` AS `fstore_name`,`huiyoufu`.`t_store`.`fstore_access_order` AS `fstore_access_order`,`huiyoufu`.`t_store`.`fstore_logo` AS `fstore_logo`,`huiyoufu`.`t_store`.`fstore_tel` AS `fstore_tel`,if((`huiyoufu`.`t_store_activities`.`fstart_time` < now()),if((`huiyoufu`.`t_store_activities`.`fstop_time` > now()),1,0),0) AS `nowact_state`,`huiyoufu`.`t_store_activities`.`factivites_id` AS `factivites_id`,`huiyoufu`.`t_store`.`fstore_address` AS `fstore_address` from ((`huiyoufu`.`t_member_info` left join `huiyoufu`.`t_store` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store`.`fstore_code`))) left join `huiyoufu`.`t_store_activities` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store_activities`.`fstore_code`))) where (`huiyoufu`.`t_member_info`.`ftype` = 1002)
md5=2a2a166e4e1153f70fe4613a1fee843a
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=1
with_check_option=0
timestamp=2019-01-29 16:10:18
create-version=1
source=SELECT
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_general_ci
view_body_utf8=select distinct `huiyoufu`.`t_member_info`.`fvalue` AS `fvalue`,`huiyoufu`.`t_member_info`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_member_info`.`ftype` AS `ftype`,`huiyoufu`.`t_store`.`fstore_code` AS `fstore_code`,`huiyoufu`.`t_store`.`fstore_name` AS `fstore_name`,`huiyoufu`.`t_store`.`fstore_access_order` AS `fstore_access_order`,`huiyoufu`.`t_store`.`fstore_logo` AS `fstore_logo`,`huiyoufu`.`t_store`.`fstore_tel` AS `fstore_tel`,if((`huiyoufu`.`t_store_activities`.`fstart_time` < now()),if((`huiyoufu`.`t_store_activities`.`fstop_time` > now()),1,0),0) AS `nowact_state`,`huiyoufu`.`t_store_activities`.`factivites_id` AS `factivites_id`,`huiyoufu`.`t_store`.`fstore_address` AS `fstore_address` from ((`huiyoufu`.`t_member_info` left join `huiyoufu`.`t_store` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store`.`fstore_code`))) left join `huiyoufu`.`t_store_activities` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store_activities`.`fstore_code`))) where (`huiyoufu`.`t_member_info`.`ftype` = 1002)