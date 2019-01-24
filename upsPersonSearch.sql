CREATE PROCEDURE [dbo].[upsPersonSearch] 
(
	@personid int = 0,
	@first_name varchar(50) = '',
	@last_name varchar(50) = ''
)
AS
BEGIN
	if (@personid <> 0)
	begin
		Select p.person_id, p.first_name, p.last_name, p.state_id, convert(varchar, p.dob, 101) as dob, s.state_code, case p.gender when 'M' Then 'Male' when 'F' Then 'Female' else '' end as gender from person p Inner Join states s on s.state_id = p.state_id
		Where first_name = @first_name AND last_name = @last_name AND p.person_id = @personid 
	end
	else
	begin
		if ((@first_name <> '') AND (@last_name <> ''))
		begin
			Select p.person_id, p.first_name, p.last_name, p.state_id, convert(varchar, p.dob, 101) as dob, s.state_code, case p.gender when 'M' Then 'Male' when 'F' Then 'Female' else '' end as gender from person p Inner Join states s on s.state_id = p.state_id Where first_name like '%'+@first_name+'%' AND last_name like '%'+@last_name+'%'
		end
		else if (@first_name <> '')
		begin
			Select p.person_id, p.first_name, p.last_name, p.state_id, convert(varchar, p.dob, 101) as dob, s.state_code, case p.gender when 'M' Then 'Male' when 'F' Then 'Female' else '' end as gender from person p Inner Join states s on s.state_id = p.state_id Where first_name like '%'+@first_name+'%'
		end
		else if (@last_name <> '')
		begin
			Select p.person_id, p.first_name, p.last_name, p.state_id, convert(varchar, p.dob, 101) as dob, s.state_code, case p.gender when 'M' Then 'Male' when 'F' Then 'Female' else '' end as gender from person p Inner Join states s on s.state_id = p.state_id Where last_name like '%'+@last_name+'%'
		end
		else
		begin
			Select p.person_id, p.first_name, p.last_name, p.state_id, convert(varchar, p.dob, 101) as dob, s.state_code, case p.gender when 'M' Then 'Male' when 'F' Then 'Female' else '' end as gender from person p Inner Join states s on s.state_id = p.state_id
		end
	end
END




GO


