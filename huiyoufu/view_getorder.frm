TYPE=VIEW
query=select `huiyoufu`.`t_order`.`forder_time` AS `forder_time`,`huiyoufu`.`t_order`.`forder_code` AS `forder_code`,`huiyoufu`.`t_order`.`fstore_code` AS `fstore_code`,`huiyoufu`.`t_order`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_order`.`fverify_state` AS `fverify_state`,`huiyoufu`.`t_order_info`.`ftype` AS `ftype`,`huiyoufu`.`t_order_info`.`fvalue` AS `fvalue`,`huiyoufu`.`t_order`.`fmember_cancel_state` AS `fmember_cancel_state`,`huiyoufu`.`t_order`.`fmember_cancel_time` AS `fmember_cancel_time`,`huiyoufu`.`t_order`.`fstore_verify_state` AS `fstore_verify_state`,`huiyoufu`.`t_order`.`fstore_verify_time` AS `fstore_verify_time` from (`huiyoufu`.`t_order` join `huiyoufu`.`t_order_info` on((`huiyoufu`.`t_order`.`forder_code` = `huiyoufu`.`t_order_info`.`forder_code`)))
md5=1c6fea826da75cdd6b9d1bb4a5056531
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=2019-01-21 11:34:47
create-version=1
source=SELECT\n`t_order`.`forder_time`,\n`t_order`.`forder_code`,\n`t_order`.`fstore_code`,\n`t_order`.`fmember_id`,\n`t_order`.`fverify_state`,\n`t_order_info`.`ftype`,\n`t_order_info`.`fvalue`,\n`t_order`.`fmember_cancel_state`,\n`t_order`.`fmember_cancel_time`,\n`t_order`.`fstore_verify_state`,\n`t_order`.`fstore_verify_time`\nFROM\n`t_order`\nINNER JOIN `t_order_info` ON `t_order`.`forder_code` = `t_order_info`.`forder_code`
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_general_ci
view_body_utf8=select `huiyoufu`.`t_order`.`forder_time` AS `forder_time`,`huiyoufu`.`t_order`.`forder_code` AS `forder_code`,`huiyoufu`.`t_order`.`fstore_code` AS `fstore_code`,`huiyoufu`.`t_order`.`fmember_id` AS `fmember_id`,`huiyoufu`.`t_order`.`fverify_state` AS `fverify_state`,`huiyoufu`.`t_order_info`.`ftype` AS `ftype`,`huiyoufu`.`t_order_info`.`fvalue` AS `fvalue`,`huiyoufu`.`t_order`.`fmember_cancel_state` AS `fmember_cancel_state`,`huiyoufu`.`t_order`.`fmember_cancel_time` AS `fmember_cancel_time`,`huiyoufu`.`t_order`.`fstore_verify_state` AS `fstore_verify_state`,`huiyoufu`.`t_order`.`fstore_verify_time` AS `fstore_verify_time` from (`huiyoufu`.`t_order` join `huiyoufu`.`t_order_info` on((`huiyoufu`.`t_order`.`forder_code` = `huiyoufu`.`t_order_info`.`forder_code`)))
