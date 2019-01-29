-- 获取轮播图
DROP PROCEDURE IF EXISTS getbanner;
DELIMITER $$
CREATE PROCEDURE getbanner ( ) BEGIN
SELECT
		concat_ws( '', 'http://192.168.123.2/huiyoufu_api/', fvalue ) AS fvalue 
	FROM
		t_user_panel_info 
	WHERE
		ftype_code = '0001' 
		LIMIT 4;
	
	END $$ 
	-- call getbanner();

-- 获取会员关注的店铺
DROP PROCEDURE IF EXISTS getfavstore;
DELIMITER $$
CREATE PROCEDURE getfavstore ( member_id VARCHAR ( 50 ), startnum INT ( 11 ), limitnum INT ( 11 ) ) BEGIN
	SET @v_sql = concat( 'select * from view_getfavstore where fmember_id="', member_id, '" limit ', startnum, ',', limitnum );
-- select @v_sql;
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END;$$ 
-- call getfavstore('201912111022010001',0,5);

-- 获取会员的订单 没有用view_getorder
DROP PROCEDURE IF EXISTS getorder;
DELIMITER $$
create procedure getorder( fmember_id VARCHAR ( 50 ), state VARCHAR (10 ))
begin
    if(state="all") then
		set @mywhere=' and 1=1 ';
		elseif(state="wait") then
		set @mywhere=' and `t_order`.`fstore_verify_state`=0 and `t_order`.`fmember_cancel_state`=0 and `t_order`.`fstore_cancel_state`=0 ';
		elseif(state="already") then
		set @mywhere=' and `t_order`.`fstore_verify_state` =1 and `t_order`.`fmember_cancel_state`=0 and `t_order`.`fstore_cancel_state`=0 ';
		elseif(state="cancel")then
		set @mywhere=' and `t_order`.`fstore_cancel_state`="1" or `t_order`.`fmember_cancel_state`="1" ';
		end if;
	SET @v_sql = concat('	SELECT
	`t_order`.`forder_time`,
	`t_order`.`forder_code`,
	`t_order`.`fstore_code`,
	`t_store`.`fstore_name`,
	`t_store`.`fstore_logo`,
	`t_order`.`fmember_id`,
	`t_order`.`fverify_state`,
	`t_order_info`.`ftype`,
`t_order`.`fmember_cancel_state`,
`t_order`.`fmember_cancel_time`,
`t_order`.`fstore_verify_state`,
`t_order`.`fstore_verify_time`,
	MAX( CASE WHEN `t_order_info`.ftype = "1003" THEN `t_order_info`.fvalue END ) AS ycrs,
	MAX( CASE WHEN `t_order_info`.ftype = "1004" THEN `t_order_info`.fvalue END ) AS etrs,
	MAX( CASE WHEN `t_order_info`.ftype = "1005" THEN DATE_FORMAT(`t_order_info`.fvalue,"%Y-%m-%d %H:%i:%s") END ) AS ddsj 
FROM
	`t_order`
	INNER JOIN `t_order_info` ON `t_order`.`forder_code` = `t_order_info`.`forder_code` 
	left join `t_store` on `t_order`.`fstore_code`=`t_store`.`fstore_code`
 where `t_order`.`fmember_id`="',fmember_id,'"',@mywhere,' GROUP BY `t_order_info`.`forder_code` order by `t_order`.`forder_time` desc ');
	PREPARE stmt 
	FROM
		@v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end;$$

--  call getorder('201912111022010001', 'already')  
-- call getorder('201912111022010001', 'cancel')
-- call getorder('201912111022010001', 'all')
-- 生成订单
	DROP PROCEDURE IF EXISTS setorder;
DELIMITER $$
create procedure setorder(store_code varchar(14), member_id varchar(50), ycrs int(11),etrs int(11),time varchar(20) )
BEGIN
    set @myorder_code=concat( DATE_FORMAT(now(),'%Y%m%d%H%i%s'),CEILING(RAND()*500000+500000));
		SET @v_sql =concat( 'insert into t_order(forder_code,fstore_code,fmember_id,forder_time)VALUES("',@myorder_code,'","',store_code,'","',member_id,'",now());') ;
		PREPARE stmt FROM @v_sql;
		EXECUTE stmt;
		
	SET @v_sql=concat('insert into t_order_info(forder_code,ftype,fvalue)values("',@myorder_code,'","1003","',ycrs,'");');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	SET @v_sql=concat('insert into t_order_info(forder_code,ftype,fvalue)values("',@myorder_code,'","1004","',etrs,'");');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	SET @v_sql=concat('insert into t_order_info(forder_code,ftype,fvalue)values("',@myorder_code,'","1005","',time,'");');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	-- set @v_sql=concat(@v_sql,@v_sql_1,@v_sql_2,@v_sql_3);
	
	-- EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	select 'OK';
END;$$
	
	
	
-- call setorder('37020201000001','201912111022010001','3','0',now())
-- call setorder('37020201000001','123123','1','0','20190127235500')
	
-- 扫码关注
drop procedure if exists setfavstore;
delimiter $$
create procedure setfavstore(fmember_id varchar(50),fstore_code varchar(14))
aa:begin
-- 判断有没有首次关注
set @v_sql_favcount=concat('select count(*) as favcount from t_member_info where fmember_id="',fmember_id,'" and ftype="1002" into @favcount;');
PREPARE stmt FROM @v_sql_favcount;
 EXECUTE stmt;

-- select count(*) as favcount from t_member_info where fmember_id="2019121110220100011" and ftype="1002" into @favcount;
 -- 判断是否关注过这个门店
set @v_sql_havelink=concat('select count(*) as havelink from t_store_member where fmember_id="',fmember_id,'" and fstore_code="',fstore_code,'" into @havelink;');
PREPARE stmt FROM @v_sql_havelink;
EXECUTE stmt;
-- DEALLOCATE PREPARE stmt;

set @v_sql_add_guanzhu=concat('insert into t_member_info(fmember_id,ftype,fvalue)values("',fmember_id,'","1002","',fstore_code,'");');
set @v_sql_add_link_first=concat('insert into t_store_member(fstore_code,fmember_id,fis_first_reg)values("',fstore_code,'","',fmember_id,'",1);');
set @v_sql_add_link=concat('insert into t_store_member(fstore_code,fmember_id)values("',fstore_code,'","',fmember_id,'");');
-- PREPARE stmt FROM @v_sql;

-- select @favcount,@havelink;
-- leave aa;
-- select count(*) as havelink from t_store_member where fmember_id="" and fstore_code="" into @havelink;
-- 如果没有首次关注
   if(@favcount=0) then
	 -- t_member_info增加关注
	 PREPARE stmt FROM @v_sql_add_guanzhu;
	 EXECUTE stmt;
   -- t_store_member 增加关联+first
	 PREPARE stmt FROM @v_sql_add_link_first;
	 EXECUTE stmt;
	-- select @favcount,@havelink;
-- 如果有过首次关注
   
    else
	-- select @favcount,@havelink;
		   
   -- 判断是否关注过这个门店
	    
			-- 如果没有关注过该门店
			if(@havelink=0) then
			-- select @favcount,@havelink;
			   -- 弹出活动，没有活动就弹出动态，没有动态就提示关注成功
		
			-- else
			-- select @favcount,@havelink;
			   -- t_member_info增加关注
						PREPARE stmt FROM @v_sql_add_guanzhu;
						EXECUTE stmt;
				 -- t_store_member 增加关联
				    PREPARE stmt FROM @v_sql_add_link;
						EXECUTE stmt;
			 end if;
		 end if;
-- insert into t_store_member(fstore_code,fmember_id)values("","");
-- 判断是否关注过

-- EXECUTE stmt;
	-- DEALLOCATE PREPARE stmt;
-- select @v_sql;
DEALLOCATE PREPARE stmt;
end;$$
-- call setfavstore('201912111022010001','37020201000007')

-- 获取店铺活动信息
drop procedure if exists getactivities;
delimiter $$
create procedure getactivities(fstore_code varchar(14))
begin
set @v_sql=concat('select * from view_getactivities where fstore_code="',fstore_code,'"');
 -- select @v_sql;
-- leave aa;
 PREPARE stmt FROM @v_sql;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
end;$$

-- call getactivities('37020201000001');

-- 会员圈列表
drop procedure if exists getcommunity;
delimiter $$
create procedure  getcommunity(fstore_code varchar(14))
begin
set @v_sql=concat('
SELECT
`t_member_community_info`.`fdatatype`,
`t_member_community_info`.`fdata`,
`t_member_community`.`fpublish_time`,
`t_member_community`.`fstop_time`,
`t_member_community`.`fthumbs_count`,
`t_member_community`.`ftitle`,
`t_member_community`.`fstore_code`,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1006" THEN `t_member_community_info`.`fdata` END ) AS fvalue1,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1007" THEN `t_member_community_info`.`fdata` END ) AS fvalue2,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1008" THEN `t_member_community_info`.`fdata` END ) AS fvalue3,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1009" THEN `t_member_community_info`.`fdata` END ) AS fvalue4,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1010" THEN `t_member_community_info`.`fdata` END ) AS fvalue5,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1011" THEN `t_member_community_info`.`fdata` END ) AS fvalue6,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1012" THEN `t_member_community_info`.`fdata` END ) AS fvalue7,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1013" THEN `t_member_community_info`.`fdata` END ) AS fvalue8,
MAX( CASE WHEN `t_member_community_info`.`fdatatype` = "1014" THEN `t_member_community_info`.`fdata` END ) AS fvalue9
FROM
`t_member_community`
left JOIN `t_member_community_info` ON `t_member_community`.`fid` = `t_member_community_info`.`fcommunity_fid` AND `t_member_community`.`fstore_code` = `t_member_community_info`.`fcommunity_fstore_code` where `t_member_community_info`.`fcommunity_fstore_code`="',fstore_code,'" GROUP BY `t_member_community_info`.`fcommunity_fid` order by `t_member_community`.`fpublish_time` desc;');
 PREPARE stmt FROM @v_sql;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
end;$$
-- call getcommunity('37020201000001');



drop procedure if exists getorder_store;
delimiter $$
create procedure getorder_store(fstore_code varchar(14),state varchar(10))
begin
    if(state="wait") then
		set @mywhere=' and `t_order`.`fstore_verify_state`=0 and `t_order`.`fmember_cancel_state`=0 and `t_order`.`fstore_cancel_state`=0 ';
		elseif(state="already") then
		set @mywhere=' and `t_order`.`fstore_verify_state` =1 and `t_order`.`fmember_cancel_state`=0 and `t_order`.`fstore_cancel_state`=0 ';
		elseif(state="cancel")then
		set @mywhere=' and `t_order`.`fstore_cancel_state`="1" or `t_order`.`fmember_cancel_state`="1" ';
		end if;
	SET @v_sql = concat('	SELECT
	`t_order`.`forder_time`,
	`t_order`.`forder_code`,
	`t_order`.`fstore_code`,
	`t_order`.`fmember_id`,
	`t_order`.`fverify_state`,
	`t_order_info`.`ftype`,
`t_order`.`fmember_cancel_state`,
`t_order`.`fmember_cancel_time`,
`t_order`.`fstore_verify_state`,
`t_order`.`fstore_verify_time`,
	MAX( CASE WHEN `t_order_info`.ftype = "1003" THEN `t_order_info`.fvalue END ) AS ycrs,
	MAX( CASE WHEN `t_order_info`.ftype = "1004" THEN `t_order_info`.fvalue END ) AS etrs,
	MAX( CASE WHEN `t_order_info`.ftype = "1005" THEN `t_order_info`.fvalue END ) AS ddsj 
FROM
	`t_order`
	INNER JOIN `t_order_info` ON `t_order`.`forder_code` = `t_order_info`.`forder_code` 
 where `t_order`.`fstore_code`="',fstore_code,'"',@mywhere,' GROUP BY `t_order_info`.`forder_code`');
	PREPARE stmt 
	FROM
		@v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end$$
-- call getorder_store('201912111022010001','wait');

drop procedure if exists setorder_store;
delimiter $$
create procedure setorder_store(forder_code varchar(50) ,state varchar(10))
begin
if(state="already") then
SET @v_sql = concat('update `t_order` set fstore_verify_state="1",fstore_verify_time=now() where forder_code="',forder_code,'"');
elseif(state="cancel") then
SET @v_sql = concat('update `t_order` set fstore_cancel_state="1",fstore_cancel_time=now() where forder_code="',forder_code,'"');
end if;

	PREPARE stmt 
	FROM
		@v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
end$$
-- call setorder_store('20190121174038701550','already');
-- call setorder_store('20190121174038701550','cancel');

drop procedure if exists chat_list_store;
create procedure chat_list_store()
begin
end;
drop procedure if exists chat_point_store;
create procedure chat_point_store()
begin
end;

drop procedure if exists getticket_store;
delimiter $$
create procedure getticket_store(fstore_code varchar(14),fmember_id varchar(50))
begin
SET @v_sql = concat('select * from view_getticket_store where fmember_id="',fmember_id,'" and fstore_code="',fstore_code,'"');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end$$
-- call getticket_store('37020201000001','201912111022010001');



drop procedure if exists setactivities_store;
delimiter $$
create procedure setactivities_store(fstore_code varchar(14),startdate varchar(50),stopdate varchar(50),tickets_and_fwinning varchar(1500),frequency_day int(11),public_activites_id int(11))
aa:begin

set @activitesid=concat( DATE_FORMAT(now(),'%Y%m%d%H%i%s'),CEILING(RAND()*500000+500000));
set @v_sql=concat('insert into t_store_activities(factivites_id,fstore_code,fstart_time,fstop_time,fpartake_frequency_day,ft_public_activities_fid)values("',@activitesid,'","',fstore_code,'","',startdate,'","',stopdate,'","',frequency_day,'","',public_activites_id,'");
');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	-- DEALLOCATE PREPARE stmt;

-- leave aa;
while(length(tickets_and_fwinning)>0 || LOCATE('|',tickets_and_fwinning)>0) do
-- 
-- 如果还有|
if(LOCATE('|',tickets_and_fwinning)>0) then
-- 取出优惠卷编码和中奖率
	set @ticketcode=substring(tickets_and_fwinning,1,locate(',',tickets_and_fwinning)-1);
	set @winning=substring(tickets_and_fwinning,locate(',',tickets_and_fwinning)+1,locate('|',tickets_and_fwinning)-locate(',',tickets_and_fwinning)-1);


-- 修改原始变量
	set tickets_and_fwinning=substring(tickets_and_fwinning,locate('|',tickets_and_fwinning)+1,length(tickets_and_fwinning)-locate('|',tickets_and_fwinning));
else 
-- 如果没有| 说明是最后一个优惠卷了
	set @ticketcode=substring(tickets_and_fwinning,1,locate(',',tickets_and_fwinning)-1);
	set @winning=substring(tickets_and_fwinning,locate(',',tickets_and_fwinning)+1,length(tickets_and_fwinning)-1);
	-- select @ticketcode,@winning,tickets_and_fwinning;leave aa;
-- 保险起见滞空变量
	set tickets_and_fwinning='';
end if;

-- set @tempstr=concat(@tempstr,'+',@ticketcode,':',@winning);
-- 执行sql语句
set @v_sql=concat('insert into t_store_activities_info(ft_store_activities_factivies_id,fticiket_code,fwinning_rate)values("',@activitesid,'","',@ticketcode,'","',@winning,'")');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	
-- leave aa;
end while;
 DEALLOCATE PREPARE stmt;
end$$
-- call setactivities_store('37020201000001','20190121054719','20190321222222','37020201000001000001,30|37020201000001000002,40|37020201000001000003,30','1','1');



drop procedure if exists getactivities_store;
create procedure getactivities_store()
begin
-- 返回店铺游戏基础数据，是否可以玩，是否超过次数，是不是要中奖
end;

drop procedure if exists setticket_store;
create procedure setticket_store(fstore_code varchar(14),fticiket_name varchar(255) ,fticiket_validity_start  varchar(255),fticiket_validity_stop varchar(255) ,fticiket_picture varchar(255), fticiket_type int(11) ,fconsume_money int(11), fmoney varchar(255) ,fdiscount float(0) )
begin
set @myticiketcode=concat(fstore_code,lpad(substring(forder_code,15,6)+1,6,0)) 
set @v_sql=concat('insert into t_store_ticket(`fticiket_code`, `fstore_code`,`fticiket_name`,`fticiket_validity_start`,`fticiket_validity_stop`,`fticiket_picture`,`fticiket_type`,`fconsume_money`,`fmoney`,`fdiscount`)values("',,'","',fstore_code,'","',fticiket_name,'","',fticiket_validity_start,'","',fticiket_validity_stop,'","',fticiket_picture,'","',fticiket_type,'","',fconsume_money ,'","',fmoney ,'","',fdiscount,'");');
 
-- select max(substring(fticiket_code,15,6))+1 from t_store_ticket where substring(fticiket_code,1,14)='37020201000001';

select  lpad(if(max(substring(fticiket_code,15,6))+1 is null,'1',max(substring(fticiket_code,15,6))+1),6,0) from t_store_ticket where substring(fticiket_code,1,14)='37020201000001';

-- select fticiket_code from t_store_ticket where substring(fticiket_code,1,14)='37020201000001';
end;

drop procedure if exists setcommunity_store;
delimiter $$
create procedure setcommunity_store(fstore_code varchar(14),ftitle varchar(50),datas varchar(1500),type  varchar(10))
aa:begin
if(type="normal")then
	set @type="0";
elseif(type="order")then
	set @type="1";
end if;
set @v_sql=concat('select if(max(fid)+1 is null,1,max(fid)+1) from t_member_community into @fid');
	PREPARE stmt FROM @v_sql;
	EXECUTE stmt;	
  -- DEALLOCATE PREPARE stmt;
 set @v_sql=concat('insert into t_member_community(fid,fstore_code,ftitle,fpublish_time,ftype)values("',@fid,'","',fstore_code,'","',ftitle,'",now(),"',@type,'")');
	 PREPARE stmt FROM @v_sql;
	 EXECUTE stmt;	
 -- DEALLOCATE PREPARE stmt;
	-- while 1006-1014
	set @mycount='1006';
	while(locate('|',datas)>0 ||length(datas)>0 && @mycount<1015)do
	-- 如果能找到|
	  if(locate('|',datas)>0) then
		set @mydata=substring(datas,1,locate('|',datas)-1);
		-- set @mycount=@mycount+1;
		-- select @mydata,@mycount;
	-- leave aa;
	-- 更新变量
		 set datas=substring(datas,locate('|',datas)+1,length(datas)-locate('|',datas));
		-- 如果找不到|,说明是最后一组了
		else
			set @mydata=datas;
			set datas='';
		end if;
-- select @mydata,@mycount;
	-- leave aa;
		set @v_sql=concat('insert into t_member_community_info(fcommunity_fid,fcommunity_fstore_code,fdatatype,fdata)values("',@fid,'","',fstore_code,'","',@mycount,'","',@mydata,'")');
		PREPARE stmt FROM @v_sql;
		EXECUTE stmt;	
		set @mycount=@mycount+1;
	end while;
	 DEALLOCATE PREPARE stmt;
end$$
 
 -- call setcommunity_store('37020201000001','店铺开业','/img/user/community/20190121214000000001.jpg|/img/user/community/20190121214000000002.jpg|/img/user/community/20190121214000000003.jpg','normal');
 




drop procedure if exists getstoreinfo_store;
delimiter $$
create procedure getstoreinfo_store(fstore_code varchar(14))
begin
set @v_sql=concat('select * from t_store where fstore_code="',fstore_code,'"');
PREPARE stmt from @v_sql;
EXECUTE stmt;
DEALLOCATE prepare stmt;
end$$
-- call getstoreinfo_store('37020201000001');

drop procedure if exists setstoreinfo_store;-- 可以用函数jsontosql
create procedure setstoreinfo_store()
begin

end;
drop procedure if exists smsauth_store;
create procedure smsauth_store()
begin
end;
drop procedure if exists login_store;
create procedure login_store()
begin
end;
drop procedure if exists updatecommunity_store;
create procedure updatecommunity_store()
begin
end;



`fid` int(11) NOT NULL AUTO_INCREMENT,
  `fstore_name`  
  `fstore_code` 
  `fstore_address` 
  `fstore_business_start` time  
  `fstore_business_stop` time  
  `fstore_business_state` 
  `fstore_logo` 
  `fstore_verify_time` datetime  
  `fstore_reg_time`  
  `fstore_verify_person`  
  `fstore_tel` 
  `fstore_people`  
  `fstore_people_tel` 
  `fstore_public_state`  
  `fstore_access_order` 
  PRIMARY KEY (`fid`)
	

SELECT
`t_member_info`.`ftype`,
`t_member_info`.`fmember_id`,
`t_store_activities_info`.`fticiket_code`,
`t_store_activities_info`.`fticiket_name`,
`t_store_activities_info`.`fticiket_validity_start`,
`t_store_activities_info`.`fticiket_validity_stop`,
`t_store_activities_info`.`fticiket_picture`,
`t_store_activities_info`.`ft_store_activities_factivies_id`,
`t_store_activities`.`fstore_code`
FROM
`t_member_info`
LEFT JOIN `t_store_activities_info` ON `t_member_info`.`fvalue` = `t_store_activities_info`.`fticiket_code`
LEFT JOIN `t_store_activities` ON `t_store_activities_info`.`ft_store_activities_factivies_id` = `t_store_activities`.`factivites_id`
WHERE
`t_member_info`.`ftype` = 1001










select * from view_getactivities where fstore_code="370202010000011"
select view_getfavstore where fstore_code="37020201000001"
select * from t_store_activities
	
	insert into t_order_info(forder_code,ftype,fvalue)values('','','');
	select concat( DATE_FORMAT(now(),'%Y%m%d%H%i%s'),lpad(substring(forder_code,15,6)+1,6,0)) from t_order;
	select forder_code from t_order;
	select DATE_FORMAT(now(),'%Y-%m-%d %H:%i:%s')
	
	
	SELECT concat( DATE_FORMAT(now(),'%Y%m%d%H%i%s'),CEILING(RAND()*500000+500000));
	
	
	
	set @tempstr='/img/user/community/20190121214000000001.jpg|/img/user/community/20190121214000000002.jpg|/img/user/community/20190121214000000003.jpg';

select substring(@tempstr,1,locate('|',@tempstr)-1);
select substring(@tempstr,locate('|',@tempstr)+1,length(@tempstr)-locate('|',@tempstr));
	select @tempstr;

set @tempstr='';
SELECT LOCATE('|', '37020201000001000001,30|37020201000001000002,40|37020201000001000003,30');
select  length('');


set @tempstr='37020201000001000001,30|37020201000001000002,40|37020201000001000003,30';

select substring(@tempstr,1,locate(',',@tempstr)-1);
select substring(@tempstr,locate(',',@tempstr)+1,locate('|',@tempstr)-locate(',',@tempstr)-1)
select substring(@tempstr,locate('|',@tempstr)+1,length(@tempstr)-locate('|',@tempstr)-1)

set @tempstr='37020201000001000003,30';
select substring(@tempstr,1,locate(',',@tempstr)-1);
select substring(@tempstr,locate(',',@tempstr)+1,length(@tempstr)-1);