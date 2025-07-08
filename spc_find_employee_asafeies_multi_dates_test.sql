USE [FS_TIMER_FUTURESOFT]
GO
/****** Object:  StoredProcedure [dbo].[spc_find_employee_asafeies_multi_dates_test]    Script Date: 08-Jul-25 3:41:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   procedure [dbo].[spc_find_employee_asafeies_multi_dates_test]
	@start_date date = null,
	@end_date date = null,
	@codefs nvarchar(max) = '*',
	@only_ergani_punches int = 0,
	@level int = 1,
	@show_no_karta int = 0,
	@remove_duplicate_missed int = 0,
	@scenario_name nvarchar(50) = ''
as
begin

/*
--Example Usage
exec spc_find_employee_asafeies_multi_dates_test
	@start_date = '20250601',
	@end_date = '20250630',
	@codefs = '10017',
	@only_ergani_punches = 0,
	@level = 1,
	@show_no_karta = 0,
	@scenario_name = 'test';
*/

if @level <> 3
begin
	set @remove_duplicate_missed = 0;
end


drop table if exists #sp_res;

create table #sp_res (
	codef nvarchar(100),
	epon nvarchar(100),
	onom nvarchar(100),
	work_date date,
	mustin datetime,
	mustout datetime,
	mustin_cont datetime,
	mustout_cont datetime,
	mustout_yesterday datetime,
	mustin_cont_yesterday datetime,
	mustout_cont_yesterday datetime,
	last_punch_yesterday nvarchar(max),
	today_punches nvarchar(max),
	missed_punch nvarchar(max),
	comments nvarchar(max),
	comments2 nvarchar(max),
	missed_punch_today int,
	missed_punch_yesterday int
);

if @level = 0
begin
	alter table #sp_res drop column 
		epon,
		onom,
		work_date,
		mustin,
		mustout,
		mustin_cont,
		mustout_cont,
		mustout_yesterday,
		mustin_cont_yesterday,
		mustout_cont_yesterday,
		last_punch_yesterday,
		today_punches,
		missed_punch,
		comments, 
		comments2,
		missed_punch_today,
		missed_punch_yesterday;

	alter table #sp_res add
		epon nvarchar(100),
		onom nvarchar(100),
		work_date date,
		nokarta int,
		mustin datetime,
		mustout datetime,
		mustin_cont datetime,
		mustout_cont datetime,
		mustout_yesterday datetime,
		mustin_cont_yesterday datetime,
		mustout_cont_yesterday datetime,
		last_punch_yesterday nvarchar(max),
		today_punches nvarchar(max),
	    is_previous_mustin int,
		is_previous_mustout int,
		is_next_mustin int,
		is_next_mustout int,
		is_first_must_in int,
		is_first_must_out int,
		is_last_must_in int,
		is_last_must_out int,
		is_first_punch_in int,
		is_first_punch_out int,
		is_last_punch_in int,
		is_last_punch_out int,
		is_last_punch_yesterday_in int,
		is_last_punch_yesterday_out int,
		punch_in_count int,
		punch_out_count int,
		previous_must_in_count int,
		previous_must_out_count int,
		total_must_in_count int,
		total_must_out_count int,
		yesterday_punch_in_count int,
		yesterday_punch_out_count int;
end

declare @start_date_time datetime = datetimefromparts(year(@start_date), month(@start_date), day(@start_date), 23, 59, 0, 0);
declare @end_date_time datetime = datetimefromparts(year(@end_date), month(@end_date), day(@end_date), 23, 59, 0, 0);

if @start_date is null and @end_date is null
begin
	set @start_date_time = getdate();
	set @end_date_time = getdate();
end

declare @current_date_time datetime = @start_date_time;

while @current_date_time <= @end_date_time
begin
	insert into #sp_res
	exec spc_find_employee_asafeies_test 
		@now = @current_date_time, 
		@level = @level, 
		@codefs = @codefs, 
		@only_ergani_punches = @only_ergani_punches,
		@show_no_karta = @show_no_karta, 
		@scenario_name = @scenario_name;

	set @current_date_time = dateadd(day, 1, @current_date_time);
end

if @remove_duplicate_missed = 1 and @level = 3
begin
	with
	ranked_rows as
	(
		select *, lag(missed_punch_today, 1) over (partition by codef order by work_date) as prev_missed_punch_today
		from #sp_res
	),
	to_update as
	(
		select work_date, codef
		from ranked_rows
		where 
			missed_punch_yesterday = 1
		and missed_punch_today = 0
		and prev_missed_punch_today = 1
	)
	update r
	set comments = replace(r.comments, 'Employee has a missed punch from yesterday.', ''), missed_punch_yesterday = 0
	from #sp_res r
	join to_update u on u.codef = r.codef and u.work_date = r.work_date;

	delete from #sp_res where missed_punch_today + missed_punch_yesterday = 0;
end

if @level <> 0
begin
	alter table #sp_res drop column missed_punch_today, missed_punch_yesterday;
end

select *, scenario_name = @scenario_name from #sp_res order by codef, work_date;

end
