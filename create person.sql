CREATE TABLE [dbo].[person](
	[person_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[state_id] [int] NOT NULL,
	[gender] [char](1) NOT NULL,
	[dob] [datetime] NOT NULL,
 CONSTRAINT [PK_person] PRIMARY KEY CLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[person]  WITH CHECK ADD  CONSTRAINT [FK_person_person] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO

ALTER TABLE [dbo].[person] CHECK CONSTRAINT [FK_person_person]
GO

ALTER TABLE [dbo].[person]  WITH CHECK ADD  CONSTRAINT [FK_Person_States] FOREIGN KEY([state_id])
REFERENCES [dbo].[states] ([state_id])
GO

ALTER TABLE [dbo].[person] CHECK CONSTRAINT [FK_Person_States]
GO


