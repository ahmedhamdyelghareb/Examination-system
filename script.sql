USE [ITI examination system]
GO
/****** Object:  Table [dbo].[Choices]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Choices](
	[QNUM] [int] NOT NULL,
	[Choice] [nvarchar](max) NOT NULL,
	[choice_num] [varchar](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MCQ_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MCQ_questions](
	[QNUM] [int] IDENTITY(1,1) NOT NULL,
	[Qhead] [nvarchar](max) NOT NULL,
	[Correct_Ans] [nvarchar](max) NOT NULL,
	[Grade] [int] NOT NULL,
	[Topic_id] [int] NOT NULL,
	[is_active] [int] NOT NULL,
	[choice_num] [varchar](1) NULL,
	[choice2] [nvarchar](max) NULL,
	[choice3] [nvarchar](max) NULL,
 CONSTRAINT [PK_MCQ] PRIMARY KEY CLUSTERED 
(
	[QNUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[V_mcq_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[V_mcq_questions]
as 
select q.Qhead,c.Choice,c.QNUM
from MCQ_questions q, Choices c
where q.QNUM=c.QNUM
GO
/****** Object:  Table [dbo].[Exams_TF]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams_TF](
	[EXAMS_ID] [int] NOT NULL,
	[TF_ID] [int] NOT NULL,
 CONSTRAINT [PK_EXAMS_TF] PRIMARY KEY CLUSTERED 
(
	[EXAMS_ID] ASC,
	[TF_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Exams_MCQ]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams_MCQ](
	[Exams_id] [int] NOT NULL,
	[MCQ_ID] [int] NOT NULL,
 CONSTRAINT [PK_Exams_MCQ] PRIMARY KEY CLUSTERED 
(
	[Exams_id] ASC,
	[MCQ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TF_Questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TF_Questions](
	[QNUM] [int] IDENTITY(1,1) NOT NULL,
	[Qhead] [nvarchar](max) NOT NULL,
	[Correct_ans] [char](1) NOT NULL,
	[Grade] [int] NOT NULL,
	[Topic_id] [int] NOT NULL,
	[is_active] [int] NOT NULL,
 CONSTRAINT [PK_TF_Questions] PRIMARY KEY CLUSTERED 
(
	[QNUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[Vexam]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Vexam]
as
select Qhead, Choice,Choices.choice_num,Exams_id
from Exams_MCQ emcq inner join MCQ_questions
on emcq.MCQ_ID=MCQ_questions.QNUM 
join choices 
on Choices.QNUM=MCQ_questions.QNUM
union all
select Qhead, '','' ,EXAMS_ID
from Exams_TF etf inner join TF_Questions
on etf.TF_ID=TF_Questions.QNUM
GO
/****** Object:  View [dbo].[Vexam_v2]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Vexam_v2]
as
select qhead,Correct_Ans,choice2,choice3,Exams_id
from Exams_MCQ emcq inner join MCQ_questions
on emcq.MCQ_ID=MCQ_questions.QNUM 

union all
select Qhead, '','' ,'',EXAMS_ID
from Exams_TF etf inner join TF_Questions
on etf.TF_ID=TF_Questions.QNUM 
GO
/****** Object:  View [dbo].[V_Questions_grade]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[V_Questions_grade]
as
select qhead,Topic_id,grade,Exams_id,choice_num as correct_ans,QNUM,choice2,choice3--,Correct_Ans
from Exams_MCQ emcq inner join MCQ_questions
on emcq.MCQ_ID=MCQ_questions.QNUM 

union all
select qhead,Topic_id, grade ,EXAMS_ID,Correct_ans,QNUM,'',''--,Correct_ans
from Exams_TF etf inner join TF_Questions
on etf.TF_ID=TF_Questions.QNUM
GO
/****** Object:  Table [dbo].[Student_EXAM]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_EXAM](
	[Student_id] [int] NOT NULL,
	[Exam_id] [int] NOT NULL,
	[ans_Q1] [char](10) NULL,
	[ans_Q2] [char](10) NULL,
	[ans_Q3] [char](10) NULL,
	[ans_Q4] [char](10) NULL,
	[ans_Q5] [char](10) NULL,
	[ans_Q6] [char](10) NULL,
	[ans_Q7] [char](10) NULL,
	[ans_Q8] [char](10) NULL,
	[ans_Q9] [char](10) NULL,
	[ans_Q10] [char](10) NULL,
	[st_grade] [int] NULL,
 CONSTRAINT [PK_Student_EXAM] PRIMARY KEY CLUSTERED 
(
	[Student_id] ASC,
	[Exam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[student_answer]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[student_answer]
as
select student_id,Exam_id,ans
from Student_EXAM
unpivot
(
ans
for stu_ans in (ans_q1,ans_q2,ans_q3,ans_q4,ans_q5,ans_q6,ans_q7,ans_q8,ans_q9,ans_q10)
) as ppvv
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[Course_id] [int] NOT NULL,
	[Course_desc] [nvarchar](50) NULL,
	[Course_name] [nchar](10) NOT NULL,
	[Duration] [int] NOT NULL,
	[is_active] [int] NOT NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[Course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Departments]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[Dept_id] [int] NOT NULL,
	[Dept_name] [nchar](10) NOT NULL,
	[Manager] [int] NOT NULL,
	[is_active] [int] NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Dept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXAMS]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXAMS](
	[Exam_ID] [int] IDENTITY(1,1) NOT NULL,
	[Model_Ans] [text] NULL,
	[Total_Grade] [int] NULL,
	[Passing_Grade] [int] NULL,
	[is_active] [int] NOT NULL,
	[inst_id] [int] NULL,
	[topic_id] [int] NULL,
 CONSTRAINT [PK_EXAMS] PRIMARY KEY CLUSTERED 
(
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Inst_course]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inst_course](
	[Course_id] [int] NOT NULL,
	[Inst_id] [int] NOT NULL,
 CONSTRAINT [PK_Inst_course] PRIMARY KEY CLUSTERED 
(
	[Course_id] ASC,
	[Inst_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Instructors]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructors](
	[Inst_id] [int] NOT NULL,
	[Inst_name] [nchar](10) NOT NULL,
	[Salary] [int] NOT NULL,
	[Address] [nvarchar](50) NULL,
	[Dept_id] [int] NULL,
	[is_active] [int] NOT NULL,
	[course_id] [int] NULL,
 CONSTRAINT [PK_Instructors] PRIMARY KEY CLUSTERED 
(
	[Inst_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Student_Topics]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_Topics](
	[Student_id] [int] NOT NULL,
	[Topic_id] [int] NOT NULL,
	[stu_mark] [int] NULL,
 CONSTRAINT [PK_Student_Topics] PRIMARY KEY CLUSTERED 
(
	[Student_id] ASC,
	[Topic_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[Student_id] [int] NOT NULL,
	[FNmame] [nchar](10) NOT NULL,
	[LName] [nchar](10) NOT NULL,
	[Age] [int] NOT NULL,
	[Address] [nvarchar](50) NULL,
	[Department_id] [int] NOT NULL,
	[is_active] [int] NOT NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[Student_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Topics]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topics](
	[topic_id] [int] NOT NULL,
	[Topic_Name] [nvarchar](50) NOT NULL,
	[Course_id] [int] NOT NULL,
	[is_active] [int] NOT NULL,
 CONSTRAINT [PK_Topics] PRIMARY KEY CLUSTERED 
(
	[topic_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Topics_EXAMS]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topics_EXAMS](
	[Topic_id] [int] NOT NULL,
	[Exam_id] [int] NOT NULL,
 CONSTRAINT [PK_Topics_EXAMS] PRIMARY KEY CLUSTERED 
(
	[Topic_id] ASC,
	[Exam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Courses] ADD  CONSTRAINT [DF_Courses_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Departments] ADD  CONSTRAINT [DF_Departments_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[EXAMS] ADD  CONSTRAINT [DF_EXAMS_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Instructors] ADD  CONSTRAINT [DF_Instructors_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[MCQ_questions] ADD  CONSTRAINT [DF_MCQ_questions_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Students] ADD  CONSTRAINT [DF_Students_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[TF_Questions] ADD  CONSTRAINT [DF_TF_Questions_is_active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Topics] ADD  CONSTRAINT [DF_Topics_is_active_1]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Choices]  WITH CHECK ADD  CONSTRAINT [FK_Choices_MCQ] FOREIGN KEY([QNUM])
REFERENCES [dbo].[MCQ_questions] ([QNUM])
GO
ALTER TABLE [dbo].[Choices] CHECK CONSTRAINT [FK_Choices_MCQ]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_Instructors] FOREIGN KEY([Manager])
REFERENCES [dbo].[Instructors] ([Inst_id])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK_Departments_Instructors]
GO
ALTER TABLE [dbo].[EXAMS]  WITH CHECK ADD  CONSTRAINT [FK_EXAMS_Topics] FOREIGN KEY([topic_id])
REFERENCES [dbo].[Topics] ([topic_id])
GO
ALTER TABLE [dbo].[EXAMS] CHECK CONSTRAINT [FK_EXAMS_Topics]
GO
ALTER TABLE [dbo].[Exams_MCQ]  WITH CHECK ADD  CONSTRAINT [FK_Exams_MCQ_EXAMS] FOREIGN KEY([Exams_id])
REFERENCES [dbo].[EXAMS] ([Exam_ID])
GO
ALTER TABLE [dbo].[Exams_MCQ] CHECK CONSTRAINT [FK_Exams_MCQ_EXAMS]
GO
ALTER TABLE [dbo].[Exams_MCQ]  WITH CHECK ADD  CONSTRAINT [FK_Exams_MCQ_MCQ] FOREIGN KEY([MCQ_ID])
REFERENCES [dbo].[MCQ_questions] ([QNUM])
GO
ALTER TABLE [dbo].[Exams_MCQ] CHECK CONSTRAINT [FK_Exams_MCQ_MCQ]
GO
ALTER TABLE [dbo].[Exams_TF]  WITH CHECK ADD  CONSTRAINT [FK_Exams_TF_EXAMS] FOREIGN KEY([EXAMS_ID])
REFERENCES [dbo].[EXAMS] ([Exam_ID])
GO
ALTER TABLE [dbo].[Exams_TF] CHECK CONSTRAINT [FK_Exams_TF_EXAMS]
GO
ALTER TABLE [dbo].[Exams_TF]  WITH CHECK ADD  CONSTRAINT [FK_EXAMS_TF_TF_Questions] FOREIGN KEY([TF_ID])
REFERENCES [dbo].[TF_Questions] ([QNUM])
GO
ALTER TABLE [dbo].[Exams_TF] CHECK CONSTRAINT [FK_EXAMS_TF_TF_Questions]
GO
ALTER TABLE [dbo].[Inst_course]  WITH CHECK ADD  CONSTRAINT [FK_Inst_course_Courses] FOREIGN KEY([Course_id])
REFERENCES [dbo].[Courses] ([Course_id])
GO
ALTER TABLE [dbo].[Inst_course] CHECK CONSTRAINT [FK_Inst_course_Courses]
GO
ALTER TABLE [dbo].[Inst_course]  WITH CHECK ADD  CONSTRAINT [FK_Inst_course_Instructors] FOREIGN KEY([Inst_id])
REFERENCES [dbo].[Instructors] ([Inst_id])
GO
ALTER TABLE [dbo].[Inst_course] CHECK CONSTRAINT [FK_Inst_course_Instructors]
GO
ALTER TABLE [dbo].[Instructors]  WITH CHECK ADD  CONSTRAINT [FK_Instructors_Courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([Course_id])
GO
ALTER TABLE [dbo].[Instructors] CHECK CONSTRAINT [FK_Instructors_Courses]
GO
ALTER TABLE [dbo].[Instructors]  WITH CHECK ADD  CONSTRAINT [FK_Instructors_Departments] FOREIGN KEY([Dept_id])
REFERENCES [dbo].[Departments] ([Dept_id])
GO
ALTER TABLE [dbo].[Instructors] CHECK CONSTRAINT [FK_Instructors_Departments]
GO
ALTER TABLE [dbo].[MCQ_questions]  WITH CHECK ADD  CONSTRAINT [FK_MCQ_questions_Topics] FOREIGN KEY([Topic_id])
REFERENCES [dbo].[Topics] ([topic_id])
GO
ALTER TABLE [dbo].[MCQ_questions] CHECK CONSTRAINT [FK_MCQ_questions_Topics]
GO
ALTER TABLE [dbo].[Student_EXAM]  WITH CHECK ADD  CONSTRAINT [FK_Student_EXAM_EXAMS] FOREIGN KEY([Exam_id])
REFERENCES [dbo].[EXAMS] ([Exam_ID])
GO
ALTER TABLE [dbo].[Student_EXAM] CHECK CONSTRAINT [FK_Student_EXAM_EXAMS]
GO
ALTER TABLE [dbo].[Student_EXAM]  WITH CHECK ADD  CONSTRAINT [FK_Student_EXAM_Students] FOREIGN KEY([Student_id])
REFERENCES [dbo].[Students] ([Student_id])
GO
ALTER TABLE [dbo].[Student_EXAM] CHECK CONSTRAINT [FK_Student_EXAM_Students]
GO
ALTER TABLE [dbo].[Student_Topics]  WITH CHECK ADD  CONSTRAINT [FK_Student_Topics_Students] FOREIGN KEY([Student_id])
REFERENCES [dbo].[Students] ([Student_id])
GO
ALTER TABLE [dbo].[Student_Topics] CHECK CONSTRAINT [FK_Student_Topics_Students]
GO
ALTER TABLE [dbo].[Student_Topics]  WITH CHECK ADD  CONSTRAINT [FK_Student_Topics_Topics] FOREIGN KEY([Topic_id])
REFERENCES [dbo].[Topics] ([topic_id])
GO
ALTER TABLE [dbo].[Student_Topics] CHECK CONSTRAINT [FK_Student_Topics_Topics]
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Departments] FOREIGN KEY([Department_id])
REFERENCES [dbo].[Departments] ([Dept_id])
GO
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Departments]
GO
ALTER TABLE [dbo].[TF_Questions]  WITH CHECK ADD  CONSTRAINT [FK_TF_Questions_Topics] FOREIGN KEY([Topic_id])
REFERENCES [dbo].[Topics] ([topic_id])
GO
ALTER TABLE [dbo].[TF_Questions] CHECK CONSTRAINT [FK_TF_Questions_Topics]
GO
ALTER TABLE [dbo].[Topics]  WITH CHECK ADD  CONSTRAINT [FK_Topics_Courses] FOREIGN KEY([Course_id])
REFERENCES [dbo].[Courses] ([Course_id])
GO
ALTER TABLE [dbo].[Topics] CHECK CONSTRAINT [FK_Topics_Courses]
GO
ALTER TABLE [dbo].[Topics_EXAMS]  WITH CHECK ADD  CONSTRAINT [FK_Topics_EXAMS_EXAMS] FOREIGN KEY([Exam_id])
REFERENCES [dbo].[EXAMS] ([Exam_ID])
GO
ALTER TABLE [dbo].[Topics_EXAMS] CHECK CONSTRAINT [FK_Topics_EXAMS_EXAMS]
GO
ALTER TABLE [dbo].[Topics_EXAMS]  WITH CHECK ADD  CONSTRAINT [FK_Topics_EXAMS_Topics] FOREIGN KEY([Topic_id])
REFERENCES [dbo].[Topics] ([topic_id])
GO
ALTER TABLE [dbo].[Topics_EXAMS] CHECK CONSTRAINT [FK_Topics_EXAMS_Topics]
GO
/****** Object:  StoredProcedure [dbo].[answer_exam]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[answer_exam] @exam_id int
as
if exists (select @exam_id from EXAMS)
begin
select choice_num
from Exams_MCQ emcq inner join MCQ_questions
on emcq.MCQ_ID=MCQ_questions.QNUM and emcq.Exams_id=@exam_id 
union all
select Correct_ans 
from Exams_TF etf inner join TF_Questions
on etf.TF_ID=TF_Questions.QNUM and etf.EXAMS_ID=@exam_id
end
GO
/****** Object:  StoredProcedure [dbo].[correct_exam]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[correct_exam] (@stu_id int , @exam_id int) 
as
begin
if(@stu_id in(select Student_id from Student_EXAM where Exam_id=@exam_id) )--and @exam_id in (select Exam_ID from Student_EXAM))
	begin
			IF OBJECT_ID('tempdb..#stu_ans') IS NOT NULL
			drop table #stu_ans
			IF OBJECT_ID('tempdb..#model_ans') IS NOT NULL
			drop table #model_ans

			declare @stu_mark int=0
			declare @grade int=0
			declare @ans nvarchar(1)
			declare @m_ans nvarchar(1)
			declare @topic_id int
			select @topic_id= topic_id from v_questions_grade where Exams_id=@exam_id
			select @topic_id
			create table #stu_ans  (id int identity,ans nvarchar(1))
			create table #model_ans  (id int identity,grade int , correct_ans nvarchar(1))
		
			insert into #stu_ans
			select ans  from student_answer where student_id=@stu_id and Exam_id=@exam_id
		 
			insert into #model_ans 
			select grade, correct_ans from v_questions_grade where Exams_id=@exam_id

			declare @correct_ans table (id int,grade int , correct_ans nvarchar(1),stu_ans nvarchar(1))
			insert into @correct_ans
			select #model_ans.id,grade,correct_ans,ans 
			from #model_ans,#stu_ans 
			where #model_ans.id=#stu_ans.id

			declare correct_exam cursor
			for 
			select grade,correct_ans,stu_ans from @correct_ans
			
			open correct_exam
			fetch correct_exam into @grade,@ans,@m_ans
			
				While( @@fetch_status=0)
				begin
					if @ans=@m_ans
							set @stu_mark+=@grade 
					fetch correct_exam into @grade,@ans,@m_ans
				end
			
	end
close correct_exam
deallocate correct_exam
update Student_EXAM
set st_grade=@stu_mark
where Student_id=@stu_id and Exam_id=@exam_id
update Student_Topics
set stu_mark=@stu_mark
where Topic_id=@topic_id and Student_id=@stu_id
end
GO
/****** Object:  StoredProcedure [dbo].[course_topics]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[course_topics] @course_id int
as
select Topic_Name
from Topics
where Course_id=@course_id
GO
/****** Object:  StoredProcedure [dbo].[Delete_From_Course]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Delete_From_Course](@ID int)
as
if exists (select Course_id from Courses where Course_id = @ID)
update Courses set is_active = 0
where Course_id = @ID
else 
print 'Course ID is not found'
return
GO
/****** Object:  StoredProcedure [dbo].[Delete_From_Department]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Delete_From_Department] (@Depart_ID int)
as
begin try
update Departments set is_active = 0
where dept_id = @Depart_ID
end try
begin catch
select 'Error..'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[delete_from_Instructor]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[delete_from_Instructor] @ins_id int
as 
begin try
update Instructors set is_active = 0
where Inst_id = @ins_id
end try
begin catch
	select 'the ID not found'
end catch
GO
/****** Object:  StoredProcedure [dbo].[delete_from_mcq]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[delete_from_mcq]
(@qhead nvarchar(max))
as
begin try
if @qhead in (select qhead from MCQ_questions)
begin
update MCQ_questions
set is_active=0
where qhead=@qhead
end
end try
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[delete_from_Student]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[delete_from_Student] @std_id int
as 
begin try
update Students set is_active = 0
where Student_id = @std_id
end try
begin catch
	select 'the ID not found'
end catch
GO
/****** Object:  StoredProcedure [dbo].[delete_from_tf_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[delete_from_tf_questions] @qhead nvarchar(max)
as
begin try
if(@qhead in (select qhead from TF_Questions)) 
begin
update TF_Questions 
set is_active=1
where Qhead=@qhead
end
end try
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[Delete_From_Topic]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Delete_From_Topic](@Topic_ID int)
as
begin try
update Topics set is_active =0
where topic_id = @Topic_ID and is_active = 1
end try
begin catch
select 'Error'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[delete_mcq_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[delete_mcq_question] @qhead nvarchar(max)
as
if @qhead in (select qhead from MCQ_questions)
	begin
		delete from MCQ_questions where Qhead=@qhead
	end
else 
	select 'this question does not exist'
GO
/****** Object:  StoredProcedure [dbo].[delete_tf_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[delete_tf_question] @qhead nvarchar(max)
as
if @qhead in (select qhead from TF_Questions)
	begin
		delete from TF_Questions where Qhead=@qhead
	end
else 
	select 'this question does not exist'


GO
/****** Object:  StoredProcedure [dbo].[exam_q_student_ans]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[exam_q_student_ans] @exam_id int, @stu_id int
as
begin
if(@stu_id in(select Student_id from Student_EXAM where Exam_id=@exam_id) )--and @exam_id in (select Exam_ID from Student_EXAM))
	begin
			IF OBJECT_ID('tempdb..#stu_ans1') IS NOT NULL
			drop table #stu_ans1
			IF OBJECT_ID('tempdb..#model_ans1') IS NOT NULL
			drop table #model_ans1

			create table #stu_ans1  (id int identity,ans nvarchar(1))
			create table #model_ans1  (id int identity,grade int , correct_ans nvarchar(1),qhead nvarchar(max),choice2 nvarchar(max),choice3 nvarchar(max))
		
			insert into #stu_ans1
			select ans  from student_answer where student_id=@stu_id and Exam_id=@exam_id
		 
			insert into #model_ans1 
			select grade, correct_ans,qhead,choice2,choice3 from v_questions_grade where Exams_id=@exam_id

			declare @correct_ans table (id int,grade int,qhead nvarchar(max),choice2 nvarchar(max),choice3 nvarchar(max) , correct_ans nvarchar(1),stu_ans nvarchar(1))
			insert into @correct_ans
			select #model_ans1.id,#model_ans1.grade,#model_ans1.qhead,#model_ans1.choice2,#model_ans1.choice3,#model_ans1.correct_ans,ans 
			from #model_ans1,#stu_ans1 
			where #model_ans1.id=#stu_ans1.id
			
			select * from @correct_ans 
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Generate_exam]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Generate_exam] @Ins_ID int, @Topic_ID int , @MCQ_NUM int , @TF_NUM int 
as
if exists(select @Topic_ID from Topics)
begin
declare @tot_exam_grade int=0
insert into EXAMS(inst_id,topic_id)
	values(@Ins_ID,@Topic_ID)

	declare @examID int = SCOPE_IDENTITY()

declare @temptable table
(examid int, qid int,grade int)

insert into @temptable(qid,grade)
select top(@MCQ_NUM) QNUM,Grade from MCQ_questions 
where Topic_id = @Topic_ID
order by NEWID()

select @tot_exam_grade=sum(grade) from @temptable

update @temptable set examid =@examID

insert into Exams_MCQ select examid,qid  from @temptable

declare @temptable1 table
(examid int, qid int,grade int)

insert into @temptable1(qid,grade)
select top(@TF_NUM) QNUM,Grade from TF_Questions 
where Topic_id = @Topic_ID
order by NEWID()

select @tot_exam_grade+=sum(grade) from @temptable1

update @temptable1 set examid =@examID
insert into Exams_TF select examid,qid from @temptable1

update EXAMS
set Total_Grade=@tot_exam_grade
where Exam_ID=@examID

end
GO
/****** Object:  StoredProcedure [dbo].[Insert_Into_Course]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Insert_Into_Course]
(@Course_ID int,@Course_Name varchar(50),@Course_Duration int)
as
begin try
insert into Courses(Course_id,Course_name,Duration) values(@Course_ID,@Course_Name,@Course_Duration)
end try
begin catch
print 'Course ID is already exists!'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[Insert_Into_Department]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Insert_Into_Department]
(@Depart_ID int, @Depart_Name varchar(50), @Manager int)
as
begin try
insert into departments(Dept_id,Dept_name,Manager) values(@Depart_ID,@Depart_Name,@Manager)
end try
begin catch
select 'Error'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[insert_into_Instructor]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insert_into_Instructor] @Ins_id int , @Ins_name varchar(20) , @Ins_Sal int , @Ins_Add varchar(20) , @Dept_id int
as
begin try
insert into Instructors(Inst_id,Inst_name,Salary,Address,Dept_id)
values(@Ins_id , @Ins_name , @Ins_Sal , @Ins_Add , @Dept_id)
end try
begin catch
	select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[insert_into_mcq_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[insert_into_mcq_questions]
(@qhead nvarchar(max), @c1 nvarchar(50), @c2 nvarchar(50) , 
@ans nvarchar(50), @grade int ,@topic_id int, @is_active int=1)
as
begin try
if  @topic_id  in(select topic_id from Topics) and @qhead not in (select qhead from MCQ_questions)
	BEGIN
		insert into MCQ_questions(Qhead,Correct_Ans,Grade,Topic_id,is_active,choice_num)
		values (@qhead,@ans,@grade,@topic_id,@is_active,3)

		 declare @qnum int  =SCOPE_IDENTITY()

		insert into Choices(qnum,Choice,choice_num)
		values(@qnum,@c1,1)
		insert into Choices(qnum,choice,choice_num)
		values(@qnum,@c2,2)
		insert into Choices(qnum,Choice,choice_num)
		values(@qnum,@ans,3)
	END
end try 
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[insert_into_mcq_questions_v2]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insert_into_mcq_questions_v2]
(@qhead nvarchar(max), @c1 nvarchar(50), @c2 nvarchar(50) , 
@ans nvarchar(50), @grade int ,@topic_id int, @is_active int=1)
as
begin try
if  @topic_id  in(select topic_id from Topics) and @qhead not in (select qhead from MCQ_questions)
	BEGIN
		insert into MCQ_questions(Qhead,Correct_Ans,Grade,Topic_id,is_active,choice2,choice3)
		values (@qhead,@ans,@grade,@topic_id,@is_active,@c1,@c2)
	END
end try 
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[Insert_into_student]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Insert_into_student] (@std_id int,@std_fname varchar(20), @std_lname varchar(20),@std_age int,@std_add varchar(20),@dept_id int)
as
begin try
	insert into Students (Student_id,FNmame,LName,Age,Address,Department_id)
	values(@std_id,@std_fname,@std_lname,@std_age,@std_add,@dept_id)
end try
begin catch
	select 'Error'
end catch
GO
/****** Object:  StoredProcedure [dbo].[insert_into_tf_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insert_into_tf_questions]
(@qhead nvarchar(max),@ans char(1),@grade int,@topic_id int, @is_active int=1)
as
begin try
if(@qhead not in (select qhead from TF_Questions)) and( @ans like 't' or @ans like 'f')and (@topic_id in (select topic_id from Topics))
begin
insert into TF_Questions(Qhead,Correct_ans,Grade,Topic_id,is_active)
values(@qhead,@ans,@grade,@topic_id,@is_active)
end
end try
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[Insert_Into_Topic]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Insert_Into_Topic]
(@Topic_ID int,@Topic_Name varchar(50),@Course_ID int)
as
begin try
insert into topics(topic_id,Topic_Name,Course_id) values(@Topic_ID,@Topic_Name,@Course_ID)
end try
begin catch
select 'Error'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[insert_mcq_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insert_mcq_question] @Qhead nvarchar(max),
							  @correct_ans char(1), 
							  @grade int,
							  @ch1 nvarchar(50),
							  @ch2 nvarchar(50),
							  @ch3 nvarchar(50)
as
if (@Qhead in (select Qhead from MCQ_questions))
   and ( @correct_ans like @ch1 or @correct_ans like @ch2 or @correct_ans like @ch3)
   begin
   declare @x int 
   insert into MCQ_questions(Qhead,Correct_ans,Grade)
   values(@Qhead,@correct_ans,@grade)
   select @x =  qnum from inserted
   insert into Choices(QNUM,Choice)
   values(@x,@ch1)
   insert into Choices(QNUM,Choice)
   values(@x,@ch2)
   insert into Choices(QNUM,Choice)
   values(@x,@ch3)
   end
else if @Qhead in (select Qhead from MCQ_questions)
	select'this question is already in the database'
	else if @correct_ans like @ch1 or @correct_ans like @ch2 or @correct_ans like @ch3
		select 'the answer is not valid'

GO
/****** Object:  StoredProcedure [dbo].[insert_TF_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insert_TF_question] 
							 @Qhead nvarchar(max),
							 @correct_ans char(1), 
							 @grade int,
							 @topic_name nvarchar(50)
as
if (@Qhead in (select Qhead from TF_questions))
   and (@correct_ans not like 't' or @correct_ans not like 'f')
   and @topic_name in (select topic_name from Topics )
   begin
   insert into TF_Questions(Qhead,Correct_ans,Grade)
   values(@Qhead,@correct_ans,@grade)
   end
else if @Qhead in (select Qhead from TF_questions)
	select'this question is already in the database'
	else if @correct_ans not like 't' or @correct_ans not like 'f'
		select 'the answer is not in the right format'
	else if (@topic_name in (select topic_name from Topics))
		select 'this topic does not exists'

GO
/****** Object:  StoredProcedure [dbo].[inst_course_stu_num]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[inst_course_stu_num] @inst_id int
as
select Course_name,count(st.Student_id) as stu_number
from Instructors i,Students s,Courses c,Student_Topics st,Topics t
where i.Inst_id=@inst_id and i.Course_id=c.Course_id 
		and S.Student_id=st.Student_id and t.Course_id=c.Course_id
group by Course_name
GO
/****** Object:  StoredProcedure [dbo].[Select_From_Course]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Select_From_Course]
as
select CS.Course_id ,CS.Course_name,CS.Duration,CS.Course_desc from Courses CS
where is_active = 1
return
GO
/****** Object:  StoredProcedure [dbo].[Select_From_Department]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Select_From_Department]
as
select D.Dept_id,D.Dept_name,D.Manager from Departments D
where is_active = 1
return
GO
/****** Object:  StoredProcedure [dbo].[select_from_Instructor]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[select_from_Instructor]
as 
select I.Inst_id , I.Inst_name ,I.Salary ,I.Address, I.Dept_id  from Instructors I
where is_active = 1
GO
/****** Object:  StoredProcedure [dbo].[select_from_Student]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[select_from_Student]
as 
select S.Student_id , S.FNmame + S.LName as [Full Name] , S.Address ,S.Age , S.Department_id from Students S
where is_active = 1

GO
/****** Object:  StoredProcedure [dbo].[select_from_tf_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[select_from_tf_questions]
--(@qhead nvarchar(max),@ans char(1),@grade int,@topic_id int, @is_active int=1)
as
begin try
select Qhead,Correct_ans,Grade,Topic_id from TF_Questions
end try
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[Select_From_Topic]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Select_From_Topic]
as
select T.topic_id , T.Topic_Name , T.Course_id from Topics T
where is_active = 1
return
GO
/****** Object:  StoredProcedure [dbo].[student_department]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[student_department]
as
select FNmame+' '+LName,Age as full_name,Address,Departments.Dept_name
from Students,Departments
where Students.Department_id=Departments.Dept_id
GO
/****** Object:  StoredProcedure [dbo].[student_marks_courses]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[student_marks_courses] @stu_id int
as
select sum(stu_mark),Course_name
from Student_Topics,Topics,Courses
where Student_id=@stu_id and Topics.Course_id=Courses.Course_id
group by Course_name

GO
/****** Object:  StoredProcedure [dbo].[studentInfoByDepNO]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[studentInfoByDepNO] @depID int
as 
select Student_id ,FNmame+' '+LName as full_name,age,Address
from Students
where Department_id=@depID

GO
/****** Object:  StoredProcedure [dbo].[topic_mcq_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[topic_mcq_question] @topic_name nvarchar(50)
as
if @topic_name in (select Topic_Name from Topics)
	begin
		select *
		from v_mcq_questions 	
	end
else 
	select 'this topic does not exist'

GO
/****** Object:  StoredProcedure [dbo].[topic_tf_question]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[topic_tf_question] @topic_name nvarchar(50)
as
if @topic_name in (select Topic_Name from Topics)
	begin
		select Qhead,t.Topic_Name,QNUM
		from TF_Questions q, Topics t
		where q.Topic_id=t.topic_id
		order by NEWID()
	end
else 
	select 'this topic does not exist'


GO
/****** Object:  StoredProcedure [dbo].[Update_In_Course]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Update_In_Course]
(@Course_ID int,@Course_Name varchar(50),@Course_Duration int)
as
if exists (select Course_id from Courses where Course_id = @Course_ID)
update Courses set Course_name = @Course_Name ,Duration = @Course_Duration
where Course_id = @Course_ID
else 
print 'Course ID not Found!'
return
GO
/****** Object:  StoredProcedure [dbo].[Update_In_Department]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Update_In_Department]
(@Dept_ID int, @Dept_Name varchar(50), @Manager int)
as
begin try
update Departments set dept_name = @Dept_Name,manager = @Manager
where dept_id = @Dept_ID 
end try
begin catch
select 'Error..'
end catch 
return
GO
/****** Object:  StoredProcedure [dbo].[Update_In_Topic]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Update_In_Topic]
(@Topic_ID int,@Topic_Name varchar(50),@Course_ID int)
as
begin try
update Topics set topic_name = @Topic_Name 
where topic_id = @Topic_ID and is_active = 1
end try
begin catch
select 'Error..'
end catch
return
GO
/****** Object:  StoredProcedure [dbo].[update_into_mcq_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_into_mcq_questions]
(@qhead nvarchar(max), @c1 nvarchar(50), @c2 nvarchar(50) , 
@ans nvarchar(50), @grade int ,@topic_id int, @is_active int=1)
as
begin try
if  @topic_id in(select topic_id from Topics) and @qhead not in (select qhead from MCQ_questions)
	BEGIN
		declare @qnum int
		select @qnum= QNUM from MCQ_questions where Qhead=@qhead
		delete from MCQ_questions where qnum=@qnum
		delete from choices where qnum=@qnum

		insert into MCQ_questions(Qhead,Correct_Ans,Grade,Topic_id,is_active,choice_num)
		values (@qhead,@ans,@grade,@topic_id,@is_active,3)

		 set @qnum =SCOPE_IDENTITY()

		insert into Choices(qnum,Choice,choice_num)
		values(@qnum,@c1,1)
		insert into Choices(qnum,choice,choice_num)
		values(@qnum,@c2,2)
		insert into Choices(qnum,Choice,choice_num)
		values(@qnum,@ans,3)
	END
end try 
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[update_mcq_questions_v2]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[update_mcq_questions_v2]
(@qhead nvarchar(max), @c1 nvarchar(max), @c2 nvarchar(max) , 
@ans nvarchar(max), @grade int ,@topic_id int, @is_active int=1)
as
begin try
if  @topic_id in(select topic_id from Topics) and @qhead not in (select qhead from MCQ_questions)
	BEGIN
		delete from MCQ_questions where Qhead=@qhead

		insert into MCQ_questions(qhead,correct_ans,grade,topic_id,is_active,choice2,choice3)
		values(@qhead,@ans,@grade,@topic_id,@is_active,@c1,@c2)
	END
end try 
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[update_on_Instructor]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[update_on_Instructor](@Ins_id int , @Ins_name varchar(20) , @Ins_Sal int , @Ins_Add varchar(20))
as
begin try
update instructors set inst_name = @Ins_name , salary = @Ins_Sal , address = @Ins_Add
where Inst_id = @Ins_id
end try
begin  catch
	select 'Error'
end catch
GO
/****** Object:  StoredProcedure [dbo].[update_on_Student]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_on_Student](@std_id int , @std_fname varchar(20),@std_lname varchar(20) , @std_age int , @std_Add varchar(20))
as
if exists(select Student_id from Students where Student_id=@std_id)
begin
update Students set FNmame = @std_fname ,lname = @std_lname ,age = @std_age , address = @std_Add
where Student_id = @std_id and is_active = 1
end
else
	print 'the ID not found'
return
GO
/****** Object:  StoredProcedure [dbo].[update_tf_questions]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[update_tf_questions]
(@qhead nvarchar(max),@ans char(1),@grade int,@topic_id int, @is_active int=1)
as
begin try
if(@qhead in (select qhead from TF_Questions)) and( @ans like 't' or @ans like 'f')and (@topic_id in (select topic_id from Topics))
begin
delete from TF_Questions where Qhead=@qhead

insert into TF_Questions(Qhead,Correct_ans,Grade,Topic_id,is_active)
values(@qhead,@ans,@grade,@topic_id,@is_active)
end
end try
begin catch
select 'Error..'
end catch
GO
/****** Object:  StoredProcedure [dbo].[View_Exam]    Script Date: 12/15/2019 6:34:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[View_Exam] @ex_num int
as
begin try
/*
select Qhead, Choice,Choices.choice_num
from Exams_MCQ emcq inner join MCQ_questions
on emcq.MCQ_ID=MCQ_questions.QNUM and emcq.Exams_id=@ex_num 
join choices 
on Choices.QNUM=MCQ_questions.QNUM
union all
select Qhead, '','' 
from Exams_TF etf inner join TF_Questions
on etf.TF_ID=TF_Questions.QNUM and etf.EXAMS_ID=@ex_num*/
select qhead,correct_ans,choice2,choice3 from vexam_v2 where Exams_ID=@ex_num

end try
begin catch
	select 'Error..'
end catch
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'holds all the choices of the MCQ questions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Choices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'hold all the exams created for all the topics' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EXAMS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'holds all questions from the type multiple choices ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MCQ_questions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'hold all the true or false Questions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TF_Questions'
GO
