create table dbo.employee_asafeies_scenarios (
    scenario_id      int identity(1,1) primary key,
    scenario_name    nvarchar(50)   default '',
    scenario_type    nvarchar(50)   default 'formula',
    boolean_formula  nvarchar(max)  default '',
    comment_if_true  nvarchar(max)  default '',
    comment_if_false nvarchar(max)  default ''
);