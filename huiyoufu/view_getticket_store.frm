TYPE=VIEW
query=select `huiyoufu`.`t_member_info`.`ftype` AS `ftype`,`huiyoufu`.`t_member_info`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_store_activities_info`.`fticiket_code` AS `fticiket_code`,`huiyoufu`.`t_store_activities_info`.`fticiket_name` AS `fticiket_name`,`huiyoufu`.`t_store_activities_info`.`fticiket_validity_start` AS `fticiket_validity_start`,`huiyoufu`.`t_store_activities_info`.`fticiket_validity_stop` AS `fticiket_validity_stop`,`huiyoufu`.`t_store_activities_info`.`fticiket_picture` AS `fticiket_picture`,`huiyoufu`.`t_store_activities_info`.`ft_store_activities_factivies_id` AS `ft_store_activities_factivies_id`,`huiyoufu`.`t_store_activities`.`fstore_code` AS `fstore_code` from ((`huiyoufu`.`t_member_info` left join `huiyoufu`.`t_store_activities_info` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store_activities_info`.`fticiket_code`))) left join `huiyoufu`.`t_store_activities` on((`huiyoufu`.`t_store_activities_info`.`ft_store_activities_factivies_id` = `huiyoufu`.`t_store_activities`.`factivites_id`))) where (`huiyoufu`.`t_member_info`.`ftype` = 1001)
md5=9060d3fc7847de932473df84f4f928b6
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=2019-01-25 11:25:13
create-version=1
source=SELECT
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_general_ci
view_body_utf8=select `huiyoufu`.`t_member_info`.`ftype` AS `ftype`,`huiyoufu`.`t_member_info`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_store_activities_info`.`fticiket_code` AS `fticiket_code`,`huiyoufu`.`t_store_activities_info`.`fticiket_name` AS `fticiket_name`,`huiyoufu`.`t_store_activities_info`.`fticiket_validity_start` AS `fticiket_validity_start`,`huiyoufu`.`t_store_activities_info`.`fticiket_validity_stop` AS `fticiket_validity_stop`,`huiyoufu`.`t_store_activities_info`.`fticiket_picture` AS `fticiket_picture`,`huiyoufu`.`t_store_activities_info`.`ft_store_activities_factivies_id` AS `ft_store_activities_factivies_id`,`huiyoufu`.`t_store_activities`.`fstore_code` AS `fstore_code` from ((`huiyoufu`.`t_member_info` left join `huiyoufu`.`t_store_activities_info` on((`huiyoufu`.`t_member_info`.`fvalue` = `huiyoufu`.`t_store_activities_info`.`fticiket_code`))) left join `huiyoufu`.`t_store_activities` on((`huiyoufu`.`t_store_activities_info`.`ft_store_activities_factivies_id` = `huiyoufu`.`t_store_activities`.`factivites_id`))) where (`huiyoufu`.`t_member_info`.`ftype` = 1001)