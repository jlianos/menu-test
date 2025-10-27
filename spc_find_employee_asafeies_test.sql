USE [FS_TIMER_FUTURESOFT]
GO
/****** Object:  StoredProcedure [dbo].[spc_find_employee_asafeies_test]    Script Date: 08-Jul-25 1:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   procedure [dbo].[spc_find_employee_asafeies_test]

@now datetime = null,
@codefs nvarchar(max) = '*',
@only_ergani_punches int = 0,
@level int = 1,
@show_no_karta int = 0,
@scenario_name nvarchar(50) = ''
--@level = 0 stats
--@level = 1 final_data all
--@level = 2 final_data all warning
--@level = 3 final_data only missed punch warnings
as
begin

/*
--Example Usage
exec spc_find_employee_asafeies_multi_dates_test
	@now = '20250601 15:30',
	@codefs = '10017',
	@only_ergani_punches = 1,
	@level = 1,
	@show_no_karta = 0,
	@scenario_name = 'test';
*/

if @now is null
begin
	set @now = getdate();
end

declare @today DATE = convert(date, @now);
declare @yesterday DATE = dateadd(day, -1, @today);

drop table if exists #book_today;

select
	codef,
	epon,
	onom,
	convert(int, coalesce(nokarta, 0)) as nokarta,
	case when coalesce(willwork, 0) > 0 and convert(date, mustin) = @today then mustin else null end as mustin,
	case when coalesce(willwork, 0) > 0 and convert(date, mustout) = @today then mustout else null end as mustout,
	case when coalesce(willwork, 0) > 0 and convert(date, mustin_cont) = @today then mustin_cont else null end as mustin_cont,
	case when coalesce(willwork, 0) > 0 and convert(date, mustout_cont) = @today then mustout_cont else null end as mustout_cont
into 
#book_today
from f_fs_book(datediff(day, getdate(), @today), 0, @codefs)
where 
	(datediff(day, @today, active_to) >= 0 or active_to is null);

--select * from #book_today;


drop table if exists #book_yesterday;

select
	codef,
	epon,
	onom,
	convert(int, coalesce(nokarta, 0)) as nokarta,
	case when coalesce(willwork, 0) > 0 then mustout else null end as mustout_yesterday,
	case when coalesce(willwork, 0) > 0 then mustin_cont else null end as mustin_cont_yesterday,
	case when coalesce(willwork, 0) > 0 then mustout_cont else null end as mustout_cont_yesterday
into 
#book_yesterday
from f_fs_book(datediff(day, getdate(), @yesterday), 0, @codefs)
where 
	(datediff(day, @yesterday, active_to) >= 0 or active_to is null)
and (convert(date, mustout) = @today or convert(date, mustout_cont) = @today or convert(date, mustin_cont) = @today);

--select * from #book_yesterday;


drop table if exists #book

select
	coalesce(t.codef, y.codef) as codef,
	coalesce(t.epon, y.epon) as epon,
	coalesce(t.onom, y.onom) as onom,
	case when (t.nokarta = 1 or y.nokarta = 1) then 1 else 0 end as nokarta,
	mustin,
	mustout,
	mustin_cont,
	mustout_cont,
	mustout_yesterday,
	mustin_cont_yesterday,
	mustout_cont_yesterday
into #book
from #book_today t
full join #book_yesterday y on t.codef = y.codef


if @show_no_karta = 0
begin
	delete from #book where (nokarta = 1);
end

--select * from #book


drop table if exists #book_normalized;

select u.*
into #book_normalized
from #book
cross apply (
	values
	(codef, epon, onom, 'must', 'in', mustin),
	(codef, epon, onom, 'must', 'out', mustout),
	(codef, epon, onom, 'must', 'in', mustin_cont),
	(codef, epon, onom, 'must', 'out', mustout_cont),
	(codef, epon, onom, 'must', 'out', mustout_yesterday),
	(codef, epon, onom, 'must', 'in', mustin_cont_yesterday),
	(codef, epon, onom, 'must', 'out', mustout_cont_yesterday)
) u (codef, epon, onom, incident_source, incident_type, incident_datetime)
where incident_datetime is not null;

--select * from #book_normalized;


drop table if exists #punches_today;

select
	b.codef,
	b.epon,
	b.onom,
	date1 as punch_datetime,
	tipos
into #punches_today
from #book b
join
    fs_clock_rec2 f on f.codef = b.codef and convert(date, date1) = @today and f.date1 <= @now
left join
    api_fs_clock_rec2 a on a.id = f.id and a.api_state = 'ok' 
where 
	(@only_ergani_punches = 0 or a.id is not null)

--select * from #punches_today


drop table if exists #punches_yesterday;

select
	b.codef,
	b.epon,
	b.onom,
	date1 as punch_datetime,
	tipos
into #punches_yesterday
from #book b
join
    fs_clock_rec2 f on f.codef = b.codef and convert(date, date1) = @yesterday
left join
    api_fs_clock_rec2 a on a.id = f.id and a.api_state = 'ok'
where 
	(@only_ergani_punches = 0 or a.id is not null)

--select * from #punches_yesterday


drop table if exists #incidents

select *
	into #incidents
	from #book_normalized
union
	select
		codef,
		epon,
		onom,
		'punch_today' as incident_source,
		case 
			when tipos = 1 then 'out' 
			else 'in'
		end as incident_type,
		punch_datetime as incident_datetime
	from #punches_today
union
	select
		codef,
		epon,
		onom,
		'punch_yesterday' as incident_source,
		case 
			when tipos = 1 then 'out' 
			else 'in'
		end as incident_type,
		punch_datetime as incident_datetime
	from #punches_yesterday

--select * from #incidents;


drop table if exists #stats;

select
	b.codef,
	b.epon,
	b.onom,
	work_date=@today,
	b.nokarta,
	b.mustin,
	b.mustout,
	b.mustin_cont,
	b.mustout_cont,
	b.mustin_cont_yesterday,
	b.mustout_cont_yesterday,
	b.mustout_yesterday,

	case when last_punch_yesterday.codef is not null then last_punch_yesterday.last_punch_yesterday else '' end as last_punch_yesterday,
	case when today_punches_agg.codef is not null then today_punches_agg.today_punches else '' end as today_punches,

	case when previous_must.codef is not null and previous_must.incident_type = 'in' then 1 else 0 end as is_previous_mustin,
	case when previous_must.codef is not null and previous_must.incident_type = 'out' then 1 else 0 end as is_previous_mustout,

	case when next_must.codef is not null and next_must.incident_type = 'in' then 1 else 0 end as is_next_mustin,
	case when next_must.codef is not null and next_must.incident_type = 'out' then 1 else 0 end as is_next_mustout,

	case when first_must_today.codef is not null and first_must_today.incident_type = 'in' then 1 else 0 end as is_first_must_in,
	case when first_must_today.codef is not null and first_must_today.incident_type = 'out' then 1 else 0 end as is_first_must_out,

	case when last_must_today.codef is not null and last_must_today.incident_type = 'in' then 1 else 0 end as is_last_must_in,
	case when last_must_today.codef is not null and last_must_today.incident_type = 'out' then 1 else 0 end as is_last_must_out,

	case when first_punch_today.codef is not null and first_punch_today.incident_type = 'in' then 1 else 0 end as is_first_punch_in,
	case when first_punch_today.codef is not null and first_punch_today.incident_type = 'out' then 1 else 0 end as is_first_punch_out,

	case when last_punch_today.codef is not null and last_punch_today.incident_type = 'in' then 1 else 0 end as is_last_punch_in,
	case when last_punch_today.codef is not null and last_punch_today.incident_type = 'out' then 1 else 0 end as is_last_punch_out,

	case when last_punch_yesterday.codef is not null and last_punch_yesterday.incident_type = 'in' then 1 else 0 end as is_last_punch_yesterday_in,
	case when last_punch_yesterday.codef is not null and last_punch_yesterday.incident_type = 'out' then 1 else 0 end as is_last_punch_yesterday_out,

	case when punch_in_count.codef is not null then punch_in_count.incident_cnt else 0 end as punch_in_count,
	case when punch_out_count.codef is not null then punch_out_count.incident_cnt else 0 end as punch_out_count,

	case when previous_must_in_count.codef is not null then previous_must_in_count.incident_cnt else 0 end as previous_must_in_count,
	case when previous_must_out_count.codef is not null then previous_must_out_count.incident_cnt else 0 end as previous_must_out_count,

	case when total_must_in_count.codef is not null then total_must_in_count.incident_cnt else 0 end as total_must_in_count,
	case when total_must_out_count.codef is not null then total_must_out_count.incident_cnt else 0 end as total_must_out_count,

	case when yesterday_punch_in_count.codef is not null then yesterday_punch_in_count.incident_cnt else 0 end as yesterday_punch_in_count,
	case when yesterday_punch_out_count.codef is not null then yesterday_punch_out_count.incident_cnt else 0 end as yesterday_punch_out_count

into #stats
from #book b
outer apply (
	 select top 1
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_datetime <= @now
	 order by incident_datetime desc
) previous_must
outer apply (
	 select top 1
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_datetime > @now
	 order by incident_datetime asc
) next_must
outer apply (
	 select top 1 
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 order by incident_datetime desc
) last_must_today
outer apply (
	 select top 1 
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 order by incident_datetime
) first_must_today
outer apply (
	 select top 1 
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_today'
	 order by incident_datetime desc
) last_punch_today
outer apply (
	 select top 1 
		codef,
		incident_type
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_today'
	 order by incident_datetime
) first_punch_today
outer apply (
	 select top 1 
		codef,
		incident_type,
		format(incident_datetime, 'HH:mm') + '(' + upper(incident_type) + ')' as last_punch_yesterday
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_yesterday'
	 order by incident_datetime desc
) last_punch_yesterday
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_today'
	 and incident_type = 'in'
	 group by codef
) punch_in_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_today'
	 and incident_type = 'out'
	 group by codef
) punch_out_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_yesterday'
	 and incident_type = 'in'
	 group by codef
) yesterday_punch_in_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'punch_yesterday'
	 and incident_type = 'out'
	 group by codef
) yesterday_punch_out_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_type = 'in'
	 and incident_datetime <= @now
	 group by codef
) previous_must_in_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_type = 'out'
	 and incident_datetime <= @now
	 group by codef
) previous_must_out_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_type = 'in'
	 group by codef
) total_must_in_count
outer apply (
	 select top 1 
		codef,
		count(codef) as incident_cnt
	 from #incidents
	 where 
		 codef = b.codef 
	 and incident_source = 'must'
	 and incident_type = 'out'
	 group by codef
) total_must_out_count
outer apply (
	select
		codef,
		string_agg(format(incident_datetime, 'HH:mm') + '(' + upper(incident_type) + ')', ' ') within group (order by incident_datetime) as today_punches
	from #incidents
	where 
		codef = b.codef
	and incident_source = 'punch_today'
	group by codef
) today_punches_agg


if @level = 0
begin
	select * from #stats;
	return;
end


drop table if exists #final_data;


declare @sql nvarchar(max) = '';
declare @dynamic_cases nvarchar(max) = '';


select @dynamic_cases = string_agg(
	'case when ' + boolean_formula +
	' then ''' + replace(comment_if_true, '''', '''''') + ''' end',
	', '
)
from employee_asafeies_scenarios
where scenario_type = 'formula' and scenario_name in (select trim(value) from string_split(@scenario_name, ','));


create table #final_data (
	codef nvarchar(100),
	epon nvarchar(100),
	onom nvarchar(100),
	work_date date,
	mustin datetime,
	mustout datetime,
	mustin_cont datetime,
	mustout_cont datetime,
	mustin_cont_yesterday datetime,
	mustout_cont_yesterday datetime,
	mustout_yesterday datetime,
	last_punch_yesterday nvarchar(max),
	today_punches nvarchar(max),
	missed_punch nvarchar(max),
	comments nvarchar(max),
	comments2 nvarchar(max),
	missed_punch_today int,
	missed_punch_yesterday int
);

set @sql = '
	insert into #final_data select
		codef,
		epon,
		onom,
		work_date = null,
		mustin,
		mustout,
		mustin_cont,
		mustout_cont,
		mustin_cont_yesterday,
		mustout_cont_yesterday,
		mustout_yesterday,
		last_punch_yesterday,
		today_punches,
		missed_punch = '''',
		comments = coalesce(trim(concat_ws(char(10), ' + @dynamic_cases + ')), ''''),
		comments2 = '''',
		missed_punch_today = 0,
		missed_punch_yesterday = 0
	from #stats;
';


exec sp_executesql @sql;


update #final_data set work_date = @today;
update #final_data set comments = 'Seems ok.' where comments = '';
update #final_data set missed_punch_today = 1, missed_punch = today_punches where comments like '%Missed Punch Today.%';
update #final_data set missed_punch_yesterday = 1 where comments like '%Employee has a missed punch from yesterday.%';


if @level = 1
begin
	select * from #final_data order by codef, work_date;
	return;
end

if @level = 2
begin
	select * from #final_data
	where comments <> 'Seems ok.'
	order by codef, work_date;
	return;
end

if @level = 3
begin
	select * from #final_data 
	where
		missed_punch_today = 1
	or  missed_punch_yesterday = 1
	order by codef, work_date;
	return;
end

end
