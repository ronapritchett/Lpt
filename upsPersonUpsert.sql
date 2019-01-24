CREATE PROCEDURE [dbo].[upsPersonUpsert] 
(
	@person_id int,
	@first_name varchar(50),
	@last_name varchar(50),
	@state_id int,
	@gender char(1),
	@dob [datetime]
)
AS
BEGIN
	SET NOCOUNT ON

	Declare @sql varchar(4000)

	create table #temp_Person  
	(	
		[person_id] [int] NOT NULL,
		[first_name] [varchar](50) NOT NULL,
		[last_name] [varchar](50) NOT NULL,
		[state_id] int NOT NULL,
		[gender] [char](1) NOT NULL,
		[dob] [datetime] NOT NULL
	)
	INSERT INTO #temp_Person( 
		[person_id],
		[first_name],
		[last_name],
		[state_id],
		[gender],
		[dob] 
	)
	SELECT 	@person_id, @first_name, @last_name, @state_id, @gender, @dob

	SET @sql = 'MERGE person AS D
            USING #temp_Person AS S
            ON (D.person_id = S.person_id) 
        WHEN NOT MATCHED BY TARGET
            THEN INSERT(first_name,last_name,state_id,gender,dob) 
            VALUES(S.first_name,S.last_name,S.state_id,S.gender,S.dob)
        WHEN MATCHED 
            THEN UPDATE SET 
				first_name = S.first_name
				,last_name = S.last_name
				,state_id = S.state_id
				,gender = S.gender
				,dob = S.dob 
        OUTPUT $action as action, ''person'' as actionTableName, Inserted.person_id as person_id;';
	Execute(@sql)

END


GO


