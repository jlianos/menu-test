USE [FS_TIMER_FUTURESOFT]
GO

/****** Object:  Table [dbo].[employee_asafeies_scenarios]    Script Date: 08-Jul-25 3:50:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[employee_asafeies_scenarios](
	[scenario_id] [int] IDENTITY(1,1) NOT NULL,
	[scenario_name] [nvarchar](50) NULL,
	[scenario_type] [nvarchar](50) NULL,
	[boolean_formula] [nvarchar](max) NULL,
	[comment_if_true] [nvarchar](max) NULL,
	[comment_if_false] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[scenario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[employee_asafeies_scenarios] ADD  DEFAULT ('') FOR [scenario_name]
GO

ALTER TABLE [dbo].[employee_asafeies_scenarios] ADD  DEFAULT ('formula') FOR [scenario_type]
GO

ALTER TABLE [dbo].[employee_asafeies_scenarios] ADD  DEFAULT ('') FOR [boolean_formula]
GO

ALTER TABLE [dbo].[employee_asafeies_scenarios] ADD  DEFAULT ('') FOR [comment_if_true]
GO

ALTER TABLE [dbo].[employee_asafeies_scenarios] ADD  DEFAULT ('') FOR [comment_if_false]
GO
