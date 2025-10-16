SET IDENTITY_INSERT [dbo].[employee_asafeies_scenarios] ON 
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (1, N'test', N'formula', N'is_previous_mustin = 1 and is_last_punch_in = 0', N'Employee should be in but not punched in yet.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (2, N'test', N'formula', N'is_previous_mustout = 1 and is_last_punch_out = 0', N'Employee should be out but not punched out yet.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (3, N'test', N'formula', N'is_previous_mustin = 0 and is_previous_mustout = 0 and is_next_mustout = 1 and is_last_punch_yesterday_out = 1', N'Employee should be in but last punch is out.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (4, N'test', N'formula', N'is_next_mustout = 0 and is_last_punch_yesterday_in = 1 and previous_must_in_count = 0 and previous_must_out_count = 0', N'Employee has a missed punch from yesterday.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (5, N'test', N'formula', N'is_last_punch_yesterday_in = 1 and is_first_punch_in = 1', N'Employee has a missed punch from yesterday.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (6, N'test', N'formula', N'previous_must_in_count > punch_in_count', N'Employee IN punches are less than expexted.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (7, N'test', N'formula', N'previous_must_out_count > punch_out_count', N'Employee OUT punches are less than expexted.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (8, N'test', N'formula', N'previous_must_in_count < punch_in_count', N'Employee IN punches are more than expexted.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (9, N'test', N'formula', N'previous_must_out_count < punch_out_count', N'Employee OUT punches are more than expexted.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (10, N'test', N'formula', N'((punch_in_count > 0 and punch_out_count = 0) or (punch_out_count > 0 and punch_in_count = 0)) and (previous_must_in_count > 0 and previous_must_out_count > 0) and is_last_must_out = 1', N'Missed Punch Today.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (11, N'test', N'formula', N'mustin is null and mustout is null and mustin_cont is null and mustout_cont is null and mustin_cont_yesterday is null and mustout_cont_yesterday is null and mustout_yesterday is null and last_punch_yesterday = '''' and today_punches = ''''', N'Seems ok.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (12, N'test', N'formula', N'(mustin is null and mustout is null and mustin_cont is null and mustout_cont is null and mustin_cont_yesterday is null and mustout_cont_yesterday is null and mustout_yesterday is null) and (last_punch_yesterday like ''%(IN)%'' or today_punches <> '''')', N'Mismatched punches found.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (13, N'test', N'formula', N'(previous_must_in_count = previous_must_out_count) and (punch_in_count = punch_out_count and punch_in_count > previous_must_in_count)', N'Employee exited and entered multiple times.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (15, N'p1', N'formula', N'is_previous_mustin = 1 and is_last_punch_in = 0', N'Employee should be in but not punched in yet.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (17, N'p3', N'formula', N'punch_in_count = 0 and punch_out_count = 0', N'Employee has no punches recorded today.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (21, N'p2', N'formula', N'punch_in_count = 0', N'Employee has no IN punches recorded today.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (26, N'p4', N'formula', N'is_previous_mustout = 1 and is_last_punch_out = 0', N'Employee should have punched out but did not.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (27, N'p3', N'formula', N'is_last_punch_yesterday_in = 1 and is_first_punch_out = 1', N'Employee''s last punch was IN yesterday and first punch today is OUT.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (28, N'p1', N'formula', N'total_must_in_count > 2', N'Employee has more than 2 scheduled must IN times today.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (29, N'p5', N'formula', N'is_previous_mustin = 1 and is_last_punch_in = 0', N'Employee should be in but hasn''t punched in.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (30, N'p6', N'formula', N'is_previous_mustin = 1 and is_last_punch_in = 0', N'Employee should be in but not punched in.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (31, N'p7', N'formula', N'punch_in_count + punch_out_count > 1', N'Employee has more than one punch today.', N'')
GO
INSERT [dbo].[employee_asafeies_scenarios] ([scenario_id], [scenario_name], [scenario_type], [boolean_formula], [comment_if_true], [comment_if_false]) VALUES (32, N'p8', N'formula', N'punch_in_count + punch_out_count > 1', N'Employee has more than one punch today.', N'')
GO
SET IDENTITY_INSERT [dbo].[employee_asafeies_scenarios] OFF
GO
