create database [Children'sSchoolOfArts_V] collate SQL_Latin1_General_CP1_CI_AS
go

use [Children'sSchoolOfArts_V]

create table ClassTypes
(
    CT_ID   int identity
        primary key,
    CT_Name nvarchar(10)
)
go

create table Classrooms
(
    CLR_ID     int identity
        primary key,
    CLR_Number int not null
)
go

create table CEquipments
(
    CEQ_ID       int identity
        primary key,
    CEQ_CLR_ID   int           not null
        references Classrooms,
    CEQ_Name     nvarchar(max) not null,
    CEQ_Quantity int           not null
)
go

create table Courses
(
    CR_ID          int identity
        primary key,
    CR_Name        nvarchar(20)  not null,
    CR_Description nvarchar(max) not null
)
go

create table CourseDevOnClasses
(
    CDC_ID    int identity
        primary key,
    CDC_CR_ID int not null
        references Courses,
    CDC_Form  int not null
)
go

create table Classes
(
    CL_ID     int identity
        primary key,
    CL_Name   nvarchar(10) not null,
    CL_CDC_ID int          not null
        references CourseDevOnClasses
)
go

create unique index Classes_CL_Name_uindex
    on Classes (CL_Name)
go

create table GradesTypes
(
    GT_ID   int identity
        primary key,
    GT_Name nvarchar(15)
)
go

create table ParentStatuses
(
    PS_ID   int identity
        constraint ParentStatuses_pk
            primary key,
    PS_Name nvarchar(15) not null
)
go

create table Quarters
(
    Q_ID   int identity
        constraint Quarters_pk
            primary key,
    Q_From date not null,
    Q_By   date not null
)
go

create table Roles
(
    R_ID   int identity
        primary key,
    R_Name nvarchar(30) not null
)
go

create table Accounts
(
    AC_ID       int identity
        primary key,
    AC_Login    nvarchar(50)  not null
        unique,
    AC_Password nvarchar(max) not null,
    AC_Role     int           not null
        references Roles
)
go

create table Children
(
    AL_CH_ID    int           not null
        primary key
        references Accounts
            on delete cascade,
    CH_FullName nvarchar(max) not null,
    CH_Age      int           not null
)
go

create table Classes_Children
(
    CCH_CH_ID int not null
        references Children,
    CCH_CL_ID int not null
        references Classes
)
go

create table Parents
(
    AL_PR_ID    int           not null
        primary key
        references Accounts
            on delete cascade,
    PR_FullName nvarchar(max) not null,
    PR_Age      int           not null,
    PR_Status   int           not null
        constraint Parents_ParentStatuses_PS_ID_fk
            references ParentStatuses,
    PR_Phone    nvarchar(15)  not null
        unique,
    PR_email    nvarchar(60)
)
go



create table Parents_Children
(
    PC_PR_ID int not null
        references Parents,
    PC_CH_ID int not null
        references Children
)
go

create table ScheduleOnDays
(
    SOD_ID      int identity
        primary key,
    SOD_CL_ID   int not null
        references Classes,
    SOD_Day     int not null,
    SOD_Week    int not null,
    SOD_Quarter int not null
        constraint ScheduleOnDays_Quarters_Q_ID_fk
            references Quarters
)
go

create table Statuses
(
    ST_ID   int identity
        primary key,
    ST_Name nvarchar(20) not null
)
go

create table CDC_Children
(
    CC_CH_ID  int           not null
        references Children,
    CC_CDC_ID int           not null
        references CourseDevOnClasses,
    CC_ST_ID  int default 2 not null
        references Statuses,
    CC_Grade  int default 0 not null
)
go

create table Courses_Children
(
    CC_CH_ID int           not null
        references Children,
    CC_CR_ID int           not null
        references Courses,
    CC_ST_ID int default 2 not null
        references Statuses,
    CC_Grade int default 0 not null
)
go

create table Subjects
(
    S_ID          int identity
        primary key,
    S_Name        nvarchar(max) not null,
    S_Description nvarchar(max) not null
)
go

create table CoursesDCOnSubjects
(
    COS_ID     int identity
        primary key,
    COS_CDC_ID int not null
        references CourseDevOnClasses,
    COS_S_ID   int not null
        references Subjects
)
go

create table Grades
(
    G_ID    int identity
        constraint Grades_pk
            primary key,
    G_CH_ID int         not null
        references Children,
    G_Data  date        not null,
    G_S_ID  int         not null
        references Subjects,
    G_Grade nvarchar(5) not null,
    G_GT_ID int         not null
        references GradesTypes,
)
go

create table HoursOnSubject
(
    HOT_ID    int identity
        constraint HoursOnTopics_pk
            primary key,
    HOT_S_ID  int not null
        constraint HoursOnSubject_Subjects_S_ID_fk
            references Subjects,
    HOT_CT_ID int not null
        references ClassTypes,
    HOT_Hours int not null
)
go

create table TEquipments
(
    TEQ_ID     int identity
        primary key,
    TEQ_HOS_ID int           not null
        constraint TEquipments_HoursOnTopics_HOT_ID_fk
            references HoursOnSubject,
    TEQ_Name   nvarchar(max) not null
)
go

create table Teachers
(
    T_AC_ID       int           not null
        primary key
        references Accounts
            on delete cascade,
    T_FullName    nvarchar(max) not null,
    T_YearsOfWork int           not null,
    T_Age         int           not null,
    T_phone       nvarchar(15)  not null
        unique,
    T_email       nvarchar(60)
)
go

create table Teachers_Subjects
(
    TS_T_ID int not null
        references Teachers,
    TS_S_ID int not null
        references Subjects
)
go

create table TimeIntervals
(
    TI_ID    int identity
        primary key,
    TI_Begin time(0) not null,
    TI_End   time(0) not null
)
go

create table Schedule_Subjects
(
    SS_ID     int identity
        primary key,
    SS_SOD_ID int  not null
        references ScheduleOnDays,
    SS_S_ID   int  not null
        references Subjects,
    SS_TI_ID  int  not null
        references TimeIntervals,
    SS_CLR_ID int  not null
        references Classrooms,
    SS_T_ID   int  not null
        references Teachers,
    SS_CT_ID  int  not null
        references ClassTypes,
    SS_From   date not null,
    SS_By     date not null
)
go

create table Schedule_Subjects_Dates
(
    SSD_ID     int identity
        primary key,
    SSD_SOD_ID int  not null
        references ScheduleOnDays,
    SSD_S_ID   int  not null
        references Subjects,
    SSD_TI_ID  int  not null
        references TimeIntervals,
    SSD_CLR_ID int  not null
        references Classrooms,
    SSD_T_ID   int  not null
        references Teachers,
    SSD_CT_ID  int  not null
        references ClassTypes,
    SSD_Date   date not null
)
go

create trigger instead_of_delete_acc
    on Accounts
    instead of delete
    as
    begin
        declare @role int= (select AC_Role from deleted);
        if (@role = 1)
            begin
                delete from Courses_Children where CC_CH_ID = (select AC_ID from deleted);
                delete from CDC_Children where CC_CH_ID = (select AC_ID from deleted);
                delete from Parents_Children where PC_CH_ID = (select AC_ID from deleted);
                delete from Grades where G_CH_ID = (select AC_ID from deleted);
                delete from Classes_Children where CCH_CH_ID = (select AC_ID from deleted);
                delete from Children where AL_CH_ID = (select AC_ID from deleted);
            end
        else if (@role = 2)
            begin
                delete from Parents_Children where PC_PR_ID = (select AC_ID from deleted);
                delete from Parents where AL_PR_ID = (select AC_ID from deleted);
            end
        else
            begin
                delete from Teachers where T_AC_ID = (select AC_ID from deleted);
            end
    end

CREATE procedure get_schedule(@ch_date date, @class nvarchar(max)) as
begin
    set datefirst 1;
    declare @sod_id int= (select SOD_ID
                          from ScheduleOnDays
                          where SOD_CL_ID =
                                (select CL_ID from Classes where CL_Name like @class)
                            and SOD_Day = datepart(weekday, @ch_date)
                            and SOD_Week = ((datepart(week, @ch_date) - 1) % 2))
    select SS_ID, SS_SOD_ID, SS_S_ID, SS_TI_ID, SS_CLR_ID, SS_T_ID, SS_CT_ID
    into #temptable
    from Schedule_Subjects
    where SS_SOD_ID = @sod_id;
    declare @temp_table_on_day table
                               (
                                   TT_ID     int primary key,
                                   TT_SOD_ID int  not null,
                                   TT_S_ID   int  not null,
                                   TT_TI_ID  int  not null,
                                   TT_CLR_ID int  not null,
                                   TT_T_ID   int  not null,
                                   TT_CT_ID  int  not null,
                                   TT_Date   date not null
                               );
    insert @temp_table_on_day (TT_ID, TT_SOD_ID, TT_S_ID, TT_TI_ID, TT_CLR_ID, TT_T_ID, TT_CT_ID, TT_Date)
    select *
    from Schedule_Subjects_Dates
    WHERE SSD_SOD_ID = @sod_id;
    while (1 = 1)
        begin
            if (Not EXISTS(select * from @temp_table_on_day))
                break;
            if (@ch_date = (select top (1) TT_Date from @temp_table_on_day))
                begin
                    declare @temp_t table
                                    (
                                        T_ID     int primary key,
                                        T_SOD_ID int not null,
                                        T_S_ID   int not null,
                                        T_TI_ID  int not null,
                                        T_CLR_ID int not null,
                                        T_T_ID   int not null,
                                        T_CT_ID  int not null
                                    );
                    insert into @temp_t (T_ID, T_SOD_ID, T_S_ID, T_TI_ID, T_CLR_ID, T_T_ID, T_CT_ID)
                    select top (1) TT_ID, TT_SOD_ID, TT_S_ID, TT_TI_ID, TT_CLR_ID, TT_T_ID, TT_CT_ID
                    from @temp_table_on_day;

                    if (exists(select *
                               from #temptable
                               where SS_TI_ID = (select top (1) TT_TI_ID from @temp_table_on_day)))
                        begin
                            update #temptable
                            set SS_S_ID   = (select T_S_ID from @temp_t),
                                SS_CLR_ID = (select T_CLR_ID from @temp_t),
                                SS_T_ID   = (select T_T_ID from @temp_t),
                                SS_CT_ID  = (select T_CT_ID from @temp_t)
                            where SS_TI_ID = (select T_TI_ID from @temp_t);
                        end
                    else
                        begin
                            insert into #temptable (SS_SOD_ID, SS_S_ID, SS_TI_ID, SS_CLR_ID, SS_T_ID, SS_CT_ID)
                            values ((select T_SOD_ID from @temp_t),
                                    (select T_S_ID from @temp_t),
                                    (select T_TI_ID from @temp_t),
                                    (select T_CLR_ID from @temp_t),
                                    (select T_T_ID from @temp_t),
                                    (select T_CT_ID from @temp_t))
                        end
                end
            DELETE TOP (1) FROM @temp_table_on_day
        end
    select * from #temptable;
    drop table #temptable;
    return;
end
go

create procedure set_schedule(@new_id int= null, @new_sod int, @new_s int, @new_ti int, @new_clr int, @new_t int,
                              @new_ct int, @new_d_from date, @new_d_by date) as
begin
    begin transaction a
        begin
            --проверка на достаточность оборудования в аудитории
            declare @quantity int= (select count(*)
                                    from ScheduleOnDays
                                             join Classes C on C.CL_ID = ScheduleOnDays.SOD_CL_ID
                                    where SOD_ID = @new_sod);
            declare @needed_equipment table
                                      (
                                          nq_name     nvarchar(max) not null,
                                          nq_quantity int
                                      );
            insert into @needed_equipment(nq_name)
            select TE.TEQ_Name
            from HoursOnSubject
                     join TEquipments TE on HoursOnSubject.HOT_ID = TE.TEQ_HOS_ID
            where HOT_S_ID = @new_s
              and HOT_CT_ID = @new_ct;
            update @needed_equipment set nq_quantity = @quantity;
            declare @held_equipment table
                                    (
                                        hq_name     nvarchar(max) not null,
                                        hq_quantity int           not null
                                    );
            insert into @held_equipment(hq_name, hq_quantity)
            select distinct ceq_name, ceq_quantity
            from CEquipments
            where CEQ_CLR_ID = @new_clr;
            while (1 = 1)
                begin
                    if (Not EXISTS(select * from @held_equipment))
                        break;
                    declare @hq_n nvarchar(max) = (select top (1) hq_name from @held_equipment),
                        @hq_q int = (select top (1) hq_quantity from @held_equipment)
                    delete from @needed_equipment where nq_name = @hq_n and nq_quantity < @hq_q;

                    delete top (1) from @held_equipment;
                end
            if (EXISTS(select * from @needed_equipment))
                begin
                    print N'Error, в классе недостаточно оборудования';
                    rollback transaction;
                    return;
                end
            print N'Все хорошо';

            --проверка преподавателя
            if (not exists(select *
                           from Teachers_Subjects
                           where TS_T_ID = @new_t
                             and TS_S_ID = @new_s))
                begin
                    print N'Error, учитель не преподает этот предмет';
                    rollback transaction;
                    return;
                end

            if (@new_id is null)
                begin
                    --проверка на свободность аудитории
                    if (EXISTS(select *
                               from Schedule_Subjects
                               where SS_SOD_ID = @new_sod
                                 and SS_TI_ID = @new_ti
                                 and SS_CLR_ID = @new_clr))
                        begin
                            print N'Error, аудитория уже занята';
                            rollback transaction;
                            return;
                        end
                    print N'Все хорошо';

                    --проверка на свободность преподователя
                    if (EXISTS(select *
                               from Schedule_Subjects
                               where SS_SOD_ID = @new_sod
                                 and SS_TI_ID = @new_ti
                                 and SS_T_ID = @new_t))
                        begin
                            print N'Error, учитель занят';
                            rollback transaction;
                            return;
                        end
                    print N'Все хорошо';

                    print N'Все хорошо';
                    insert into Schedule_Subjects
                    values (@new_sod, @new_s, @new_ti, @new_clr, @new_t, @new_ct, @new_d_from, @new_d_by)
                end
            else
                begin
                    if (not exists(select *
                                   from Schedule_Subjects
                                   where SS_ID = @new_id))
                        begin
                            print N'Error, нет такой записи в расписании';
                            rollback transaction;
                            return;
                        end
                    --проверка на свободность аудитории
                    if (EXISTS(select *
                               from Schedule_Subjects
                               where SS_ID != @new_id
                                 and SS_SOD_ID = @new_sod
                                 and SS_TI_ID = @new_ti
                                 and SS_CLR_ID = @new_clr))
                        begin
                            print N'Error, аудитория уже занята';
                            rollback transaction;
                            return;
                        end
                    print N'Все хорошо';

                    --проверка на свободность преподователя
                    if (EXISTS(select *
                               from Schedule_Subjects
                               where SS_ID != @new_id
                                 and SS_SOD_ID = @new_sod
                                 and SS_TI_ID = @new_ti
                                 and SS_T_ID = @new_t))
                        begin
                            print N'Error, учитель занят';
                            rollback transaction;
                            return;
                        end
                    print N'Все хорошо';

                    print N'Все хорошо';
                    update Schedule_Subjects
                    set SS_SOD_ID = @new_sod,
                        SS_S_ID   = @new_s,
                        SS_TI_ID  = @new_ti,
                        SS_CLR_ID = @new_clr,
                        SS_T_ID   = @new_t,
                        SS_CT_ID  = @new_ct,
                        SS_From   = @new_d_from,
                        SS_By     = @new_d_by
                    where SS_ID = @new_id;
                end
            commit transaction;
        end
end
go

insert into Roles (R_Name)
values (N'child'),
       (N'parent'),
       (N'teacher');

insert into Accounts (AC_Login, AC_Password, AC_Role)
values (N'child1', N'27cfbe367a1294dc60aef746fb69e797', 1),
       (N'child2', N'bf94099de6e08e39478cee3d06c5fe47', 1),
       (N'child3', N'08fda666c89a81db2667d287bd951481', 1),
       (N'parent1', N'34f83b4b453db075f374fa73365b8283', 2),
       (N'parent2', N'df7d26c91d5b0b52c51f813d4f335833', 2),
       (N'parent3', N'087e0475b564420ccc87e843add346fd', 2),
       (N'teacher1', N'41c8949aa55b8cb5dbec662f34b62df3', 3),
       (N'teacher2', N'ccffb0bb993eeb79059b31e1611ec353', 3),
       (N'teacher3', N'82470256ea4b80343b27afccbca1015b', 3);

insert into Children (AL_CH_ID, CH_FullName, CH_Age)
values (1, N'Brianna Fitzgerald', 10),
       (2, N'Donnell Cantu', 6),
       (3, N'Cecil Miranda', 9);

insert into ParentStatuses (PS_Name)
values (N'mother'),
       (N'father'),
       (N'other');

insert into Parents (AL_PR_ID, PR_FullName, PR_Age, PR_Status, PR_Phone, PR_email)
values (4, N'Burt Braun', 38, 1, N'+79487292136', null),
       (5, N'Samual Bautista', 40, 2, N'+79237478219', N'chelsey.hills54@yahoo.com'),
       (6, N'Landon Blankenship', 45, 3, N'+79875494186', N'willy.schuppe40@gmail.com');

insert into Teachers (T_AC_ID, T_FullName, T_YearsOfWork, T_Age, T_phone, T_email)
values (7, N'Neil Reese', 13, 43, N'+79857124340', N'elsie30@hotmail.com'),
       (8, N'Jana Carr', 7, 45, N'+79845912214', N'orville_swift@yahoo.com'),
       (9, N'Morton Vang', 5, 41, N'+79514309147', N'susan89@yahoo.com');

insert into Statuses (ST_Name)
values (N'not taken'),
       (N'in progress'),
       (N'completed');

insert into GradesTypes (GT_Name)
values (N'homework'),
       (N'class work'),
       (N'attendance'),
       (N'test'),
       (N'final grade');

insert into Quarters (Q_From, Q_By)
values (N'2022-09-03', N'2022-10-26'),
       (N'2022-11-06', N'2022-12-28'),
       (N'2023-01-14', N'2023-03-22'),
       (N'2023-04-01', N'2023-05-31');

insert into Classrooms (CLR_Number)
values (111),
       (112),
       (113),
       (114),
       (201),
       (202),
       (203),
       (204),
       (205),
       (206);

insert into ClassTypes (CT_Name)
values (N'lecture'),
       (N'practice'),
       (N'laboratory');

insert into Subjects (S_Name, S_Description)
values (N'Art1',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Art2',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Art3',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Mus1',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Mus2',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Mus3',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Prog1',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Prog2',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.'),
       (N'Prog3',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.');

insert into TimeIntervals (TI_Begin, TI_End)
values (N'08:00:00', N'09:30:00'),
       (N'09:40:00', N'11:10:00'),
       (N'11:20:00', N'12:50:00'),
       (N'13:30:00', N'15:00:00'),
       (N'15:10:00', N'16:40:00'),
       (N'16:50:00', N'18:20:00');

insert into Courses (CR_Name, CR_Description)
values (N'Art',
        N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ultricies odio id dapibus consectetur. Cras non augue nisl. Nunc non semper purus. Donec malesuada quam tortor, vitae accumsan mi elementum vel. Praesent suscipit ligula id sodales placerat. Duis molestie, elit at ultricies porta, eros lacus faucibus turpis, vel tempor odio enim et mi. Donec ante metus, ultrices vel sollicitudin sit amet, sagittis molestie dolor.'),
       (N'Music',
        N'Nam vel laoreet felis. Ut tristique, diam sit amet bibendum bibendum, quam eros accumsan libero, ac pretium lacus elit fermentum augue. Nulla convallis venenatis lorem, eu commodo mi aliquam non. Vestibulum nisl est, sagittis et mollis et, ultricies non mi. Nullam ut libero id ligula tincidunt vulputate. Praesent felis dolor, congue nec bibendum sed, vehicula at risus. Nullam non justo finibus, interdum eros a, facilisis erat. Duis ornare risus eu mauris ultrices, id vestibulum odio luctus. Ut posuere odio nec purus efficitur tristique.'),
       (N'Programming',
        N'Nam accumsan venenatis augue, at convallis sem hendrerit et. Nam posuere lacus sit amet mattis volutpat. Maecenas molestie pretium sapien, non congue quam ultrices non. Phasellus sit amet quam et ex pellentesque sagittis hendrerit id massa. Donec congue dolor ac leo varius fringilla. Nunc rhoncus risus id tellus ultricies laoreet. Nunc at augue ex. Curabitur eu velit a velit rutrum finibus. Proin augue arcu, commodo vitae hendrerit sed, semper semper velit. Nam nulla tellus, pellentesque eu diam eu, vestibulum dictum ex. Aenean purus nisl, consectetur sed risus ultricies, tincidunt suscipit tellus.');

insert into CourseDevOnClasses (CDC_CR_ID, CDC_Form)
values (1, 1),
       (2, 1),
       (3, 1),
       (1, 2),
       (2, 2),
       (3, 2),
       (2, 3),
       (3, 3);

insert into Classes (CL_Name, CL_CDC_ID)
values (N'A2', 4),
       (N'B1', 2),
       (N'C1', 3);

insert into Classes_Children (CCH_CH_ID, CCH_CL_ID)
values (1, 1),
       (1, 2),
       (1, 3),
       (2, 1),
       (2, 2),
       (3, 3);

insert into Parents_Children (PC_PR_ID, PC_CH_ID)
values (5, 1),
       (5, 2),
       (4, 3),
       (6, 3);

insert into Teachers_Subjects (TS_T_ID, TS_S_ID)
values (7, 1),
       (8, 2),
       (9, 3),
       (7, 4),
       (8, 5),
       (9, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (7, 1),
       (8, 2),
       (9, 3),
       (7, 4),
       (8, 5),
       (9, 6);

insert into Grades (G_CH_ID, G_Data, G_S_ID, G_Grade, G_GT_ID)
values (2, N'2012-03-09', 1, N'28', 2),
       (3, N'2012-07-05', 9, N'87', 4),
       (1, N'2012-09-19', 4, N'86', 2),
       (1, N'2013-09-12', 2, N'83', 5),
       (3, N'2014-01-23', 8, N'98', 1),
       (2, N'2014-09-04', 6, N'57', 4),
       (2, N'2015-02-13', 2, N'n', 3),
       (2, N'2018-09-02', 2, N'59', 2),
       (1, N'2020-08-14', 6, N'39', 4),
       (1, N'2020-09-22', 1, N'n', 3),
       (3, N'2021-09-16', 3, N'40', 2),
       (1, N'2021-11-24', 6, N'n', 3),
       (3, N'2021-12-20', 1, N'55', 1),
       (2, N'2021-12-21', 3, N'89', 2),
       (1, N'2022-12-27', 5, N'46', 2);

insert into Courses_Children (CC_CH_ID, CC_CR_ID, CC_ST_ID, CC_Grade)
values (1, 1, 3, 70),
       (2, 2, 2, 0),
       (3, 3, 2, 0),
       (1, 2, 2, 0),
       (1, 3, 2, 0);

insert into CoursesDCOnSubjects (COS_CDC_ID, COS_S_ID)
values (7, 8),
       (7, 7),
       (7, 2),
       (1, 1),
       (2, 5),
       (5, 8),
       (1, 1),
       (4, 8),
       (1, 2),
       (1, 7),
       (7, 3),
       (6, 7),
       (5, 2),
       (1, 7),
       (8, 5),
       (4, 4),
       (4, 1),
       (2, 3),
       (8, 6),
       (3, 4),
       (5, 5),
       (4, 4),
       (1, 5),
       (4, 5),
       (5, 8),
       (1, 5),
       (8, 5),
       (3, 4),
       (8, 1),
       (2, 4),
       (2, 9),
       (2, 3),
       (3, 3),
       (2, 3),
       (8, 8),
       (3, 1),
       (4, 6),
       (3, 8),
       (4, 2),
       (1, 1),
       (3, 2),
       (6, 3),
       (4, 8),
       (1, 4),
       (4, 6),
       (1, 8),
       (7, 6),
       (5, 9),
       (6, 2),
       (6, 2);

insert into CDC_Children (CC_CH_ID, CC_CDC_ID, CC_ST_ID, CC_Grade)
values (1, 1, 3, 70),
       (2, 1, 3, 100),
       (3, 2, 2, 0),
       (2, 3, 2, 0),
       (1, 4, 2, 0),
       (1, 5, 2, 0);

insert into HoursOnSubject (HOT_S_ID, HOT_CT_ID, HOT_Hours)
values (7, 1, 52),
       (2, 1, 32),
       (1, 1, 64),
       (6, 1, 28),
       (9, 3, 61),
       (3, 1, 44),
       (3, 2, 51),
       (7, 2, 29),
       (8, 2, 39),
       (2, 2, 31),
       (9, 2, 51),
       (9, 1, 27),
       (1, 2, 53),
       (5, 3, 67),
       (7, 3, 38),
       (8, 3, 24),
       (6, 3, 43),
       (4, 3, 59),
       (4, 2, 41),
       (6, 2, 70),
       (8, 1, 39),
       (4, 1, 45),
       (2, 3, 54),
       (1, 3, 26),
       (3, 3, 22),
       (5, 1, 44),
       (5, 2, 67);

SET IDENTITY_INSERT TEquipments ON;
insert into TEquipments (TEQ_ID, TEQ_HOS_ID, TEQ_Name)
values (1, 5, N'computer'),
       (2, 18, N'paints'),
       (3, 16, N'paints'),
       (4, 4, N'chair'),
       (5, 14, N'chair'),
       (6, 7, N'computer'),
       (7, 6, N'computer'),
       (8, 24, N'table'),
       (9, 20, N'chair'),
       (10, 1, N'brushes'),
       (11, 11, N'computer'),
       (12, 11, N'computer'),
       (13, 21, N'paints'),
       (14, 14, N'brushes'),
       (15, 22, N'computer'),
       (16, 25, N'brushes'),
       (17, 13, N'computer'),
       (18, 8, N'easel'),
       (19, 10, N'chair'),
       (20, 6, N'computer'),
       (21, 11, N'easel'),
       (22, 6, N'brushes'),
       (23, 6, N'computer'),
       (24, 10, N'table'),
       (25, 27, N'table'),
       (26, 12, N'table'),
       (27, 23, N'chair'),
       (28, 25, N'brushes'),
       (29, 20, N'chair'),
       (30, 21, N'chair'),
       (31, 20, N'brushes'),
       (32, 12, N'chair'),
       (33, 2, N'easel'),
       (34, 19, N'easel'),
       (35, 16, N'brushes'),
       (36, 25, N'computer'),
       (37, 15, N'computer'),
       (38, 6, N'table'),
       (39, 23, N'computer'),
       (40, 21, N'paints'),
       (41, 13, N'chair'),
       (42, 10, N'paints'),
       (43, 6, N'paints'),
       (44, 12, N'easel'),
       (45, 9, N'table'),
       (46, 17, N'easel'),
       (47, 23, N'table'),
       (48, 15, N'computer'),
       (49, 4, N'brushes'),
       (50, 6, N'brushes'),
       (51, 11, N'paints'),
       (52, 25, N'table'),
       (53, 3, N'easel'),
       (54, 18, N'table'),
       (55, 7, N'paints'),
       (56, 22, N'chair'),
       (57, 20, N'brushes'),
       (58, 15, N'table'),
       (59, 3, N'chair'),
       (60, 4, N'table'),
       (61, 10, N'easel'),
       (62, 10, N'paints'),
       (63, 2, N'chair'),
       (64, 6, N'paints'),
       (65, 10, N'chair'),
       (66, 11, N'brushes'),
       (67, 16, N'table'),
       (68, 9, N'computer'),
       (69, 25, N'easel'),
       (70, 22, N'brushes'),
       (71, 19, N'table'),
       (72, 25, N'paints'),
       (73, 6, N'paints'),
       (74, 23, N'easel'),
       (75, 4, N'easel'),
       (76, 12, N'chair'),
       (77, 1, N'brushes'),
       (78, 27, N'table'),
       (79, 22, N'chair'),
       (80, 20, N'easel'),
       (81, 10, N'paints'),
       (82, 6, N'paints'),
       (83, 3, N'table'),
       (84, 19, N'brushes'),
       (85, 16, N'easel'),
       (86, 21, N'brushes'),
       (87, 10, N'easel'),
       (88, 19, N'easel'),
       (89, 24, N'paints'),
       (90, 10, N'computer');
SET IDENTITY_INSERT TEquipments OFF;

insert into CEquipments (CEQ_CLR_ID, CEQ_Name, CEQ_Quantity)
values (6, N'chair', 30),
       (4, N'table', 29),
       (2, N'computer', 21),
       (10, N'easel', 21),
       (4, N'paints', 29),
       (9, N'brushes', 25),
       (1, N'chair', 22),
       (5, N'table', 25),
       (8, N'computer', 25),
       (3, N'easel', 30),
       (7, N'paints', 30),
       (5, N'brushes', 23),
       (6, N'paints', 24),
       (4, N'brushes', 23),
       (7, N'chair', 25);

insert into ScheduleOnDays (SOD_CL_ID, SOD_Day, SOD_Week, SOD_Quarter)
values  (1, 1, 1, 1),
        (2, 1, 1, 1),
        (3, 1, 1, 1);

insert into Schedule_Subjects (SS_SOD_ID, SS_S_ID, SS_TI_ID, SS_CLR_ID, SS_T_ID, SS_CT_ID, SS_From, SS_By)
values  (1, 1, 1, 1, 7, 1, N'2022-09-01', N'2022-10-31'),
        (1, 4, 2, 2, 7, 1, N'2022-09-01', N'2022-10-31'),
        (1, 7, 3, 3, 7, 1, N'2022-09-01', N'2022-10-31'),
        (2, 2, 2, 5, 8, 2, N'2022-09-01', N'2022-10-31'),
        (3, 5, 4, 6, 8, 3, N'2022-09-01', N'2022-10-31'),
        (1, 9, 1, 2, 9, 3, N'2022-09-01', N'2022-10-31');

insert into Schedule_Subjects_Dates (SSD_SOD_ID, SSD_S_ID, SSD_TI_ID, SSD_CLR_ID, SSD_T_ID, SSD_CT_ID, SSD_Date)
values  (1, 1, 5, 1, 7, 1, N'2022-09-12'),
        (1, 2, 3, 2, 8, 2, N'2022-09-17'),
        (2, 3, 1, 3, 9, 3, N'2022-09-24'),
        (3, 4, 4, 4, 7, 1, N'2022-09-28'),
        (3, 5, 5, 5, 8, 2, N'2022-09-29');
