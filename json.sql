DELIMITER $$  
CREATE FUNCTION fn_parseJson(p_jsonstr VARCHAR(255) CHARACTER SET utf8 ,p_key VARCHAR(255)
) RETURNS VARCHAR(300)
BEGIN
 
DECLARE rtnVal VARCHAR(255) DEFAULT '' ;
DECLARE v_key VARCHAR(255) ;
SET v_key = CONCAT('"' , p_key , '":') ;
SET @v_flag = p_jsonstr REGEXP v_key ;
IF(@v_flag = 0) THEN
 
SET rtnVal = '' ;
ELSE
SELECT
val INTO rtnVal
FROM
(
SELECT
@start_pos := locate(v_key , p_jsonstr) ,
@end_pos := @start_pos + length(v_key) ,
@tail_pos :=
IF(
locate("," , p_jsonstr , @end_pos) = 0 ,
locate("}" , p_jsonstr , @end_pos) ,
locate("," , p_jsonstr , @end_pos)
) ,
substring(
p_jsonstr ,
@end_pos + 1 ,
@tail_pos - @end_pos - 2
) AS val
) AS t ;
END
IF ; RETURN rtnVal ;
END$$  
select fn_parseJson('{"name":"json","age":"18"}','age') ;



drop function if exists fn_jsontosql;
delimiter $$
CREATE FUNCTION fn_jsontosql(jsonstr VARCHAR(255) CHARACTER SET utf8 ,table_name VARCHAR(255)
) RETURNS VARCHAR(3000)
aa:begin
-- set @tempstr='';
set @sqlleft='';
set @sqlright='';
while(locate(':',jsonstr)>0||length(jsonstr)>0)do
-- 找到第一个,
		set jsonstr=REPLACE(jsonstr,'{','');
		set jsonstr=REPLACE(jsonstr,'}','');
		-- select locate(',',@tempstr),@tempstr;
		-- 截取键值对
		if(locate(',',jsonstr)>0) then
							-- select substring(@tempstr,1,locate(',',@tempstr));
					set @keyvalue=substring(jsonstr,1,locate(',',jsonstr));
					-- 去掉引号和逗号 保留：
					set @keyvalue=REPLACE(@keyvalue,'"','');
					set @keyvalue=REPLACE(@keyvalue,',','');
					-- 截取key value
					set @mykey=substring(@keyvalue,1,locate(':',@keyvalue)-1);
					set @myvalue=substring(@keyvalue,locate(':',@keyvalue)+1,length(@keyvalue));
		
				-- 更新字符串
			    set jsonstr=substring(jsonstr,locate(',',jsonstr)+1,length(jsonstr));	
		else
		 
		 	set @keyvalue=jsonstr;
	
			-- 去掉引号和逗号 保留：
				 set @keyvalue=REPLACE(@keyvalue,'"','');
					-- 截取key value
					 set @mykey=substring(@keyvalue,1,locate(':',@keyvalue)-1);
					 set @myvalue=substring(@keyvalue,locate(':',@keyvalue)+1,length(@keyvalue));
		
			-- 更新字符串
			    set jsonstr='';	
		end if;
					-- 拼装sql语句
						if(@sqlleft='')then
						set @sqlleft=concat(@sqlleft,@mykey);
						else
						 set @sqlleft=concat(@sqlleft,",",@mykey);
						end if;
						
				   
					  if(@sqlright='') then
						set @sqlright=concat(@sqlright,'"',@myvalue,'"');
						else
						set @sqlright=concat(@sqlright,',"',@myvalue,'"');
						end if;
					
-- select @mykey;

end while;
return concat('insert into ',table_name,'(',@sqlleft,')values(',@sqlright,')');
-- leave aa;
end$$

select fn_jsontosql('{"name":"json","age":"18","sex":"19090977","height":"180"}','t_store');

set @tempstr='{"name":"json","age":"18","sex":"1"}';
