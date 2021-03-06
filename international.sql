USE [InitialRegistration]
GO
/****** Object:  User [IAUEC\a_atarodi]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [IAUEC\a_atarodi] FOR LOGIN [IAUEC\a_atarodi] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IAUEC\a_rohani]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [IAUEC\a_rohani] FOR LOGIN [IAUEC\a_rohani] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IAUEC\f_sassani]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [IAUEC\f_sassani] FOR LOGIN [IAUEC\f_sassani] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IAUEC\s_teimoory]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [IAUEC\s_teimoory] FOR LOGIN [IAUEC\s_teimoory] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [reg_user]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [reg_user] FOR LOGIN [reg_user] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [teamuser]    Script Date: 11/10/2020 12:31:49 PM ******/
CREATE USER [teamuser] FOR LOGIN [teamuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IAUEC\a_atarodi]
GO
ALTER ROLE [db_owner] ADD MEMBER [IAUEC\a_rohani]
GO
ALTER ROLE [db_owner] ADD MEMBER [IAUEC\s_teimoory]
GO
ALTER ROLE [db_owner] ADD MEMBER [reg_user]
GO
ALTER ROLE [db_owner] ADD MEMBER [teamuser]
GO
/****** Object:  Schema [Discount]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE SCHEMA [Discount]
GO
/****** Object:  Schema [International]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE SCHEMA [International]
GO
/****** Object:  Schema [NoExamEntrance]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE SCHEMA [NoExamEntrance]
GO
/****** Object:  Schema [useraccess]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE SCHEMA [useraccess]
GO
/****** Object:  UserDefinedTableType [dbo].[discountTableType]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE TYPE [dbo].[discountTableType] AS TABLE(
	[Type] [int] NULL,
	[Number] [varchar](350) NULL,
	[Percentage] [int] NULL,
	[IsDisposable] [bit] NULL DEFAULT ((0)),
	[IsUsage] [bit] NULL DEFAULT ((0))
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentType]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE TYPE [dbo].[StudentType] AS TABLE(
	[term] [int] NULL,
	[vorodi] [tinyint] NULL,
	[stcode] [varchar](11) NULL,
	[name] [varchar](30) NULL,
	[family] [varchar](70) NULL,
	[namep] [varchar](40) NULL,
	[idd] [varchar](20) NULL,
	[idd_meli] [varchar](20) NULL,
	[sex] [tinyint] NULL,
	[magh] [tinyint] NULL,
	[idreshSazman] [varchar](10) NULL,
	[year_tav] [numeric](4, 0) NULL,
	[radif_gh] [varchar](10) NULL,
	[rotbeh_gh] [varchar](10) NULL,
	[nomreh_gh] [varchar](10) NULL,
	[par] [varchar](15) NULL,
	[dav] [varchar](15) NULL,
	[id_paziresh] [int] NULL,
	[tel] [varchar](50) NULL,
	[mobile] [varchar](20) NULL,
	[email] [varchar](70) NULL,
	[code_posti] [varchar](20) NULL,
	[addressd] [varchar](200) NULL,
	[AcceptationDescription] [nvarchar](300) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentTypeFromAmozeshYar]    Script Date: 11/10/2020 12:31:50 PM ******/
CREATE TYPE [dbo].[StudentTypeFromAmozeshYar] AS TABLE(
	[term] [int] NULL,
	[vorodi] [tinyint] NULL,
	[stcode] [varchar](11) NULL,
	[name] [varchar](30) NULL,
	[family] [varchar](70) NULL,
	[idd] [varchar](20) NULL,
	[idd_meli] [varchar](20) NULL,
	[sex] [tinyint] NULL,
	[magh] [tinyint] NULL,
	[idreshSazman] [varchar](10) NULL,
	[bomi] [tinyint] NULL,
	[mobile] [varchar](20) NULL,
	[AcceptationDescription] [nvarchar](300) NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ConvertAlphabet]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_ConvertAlphabet](@text varchar(max)) 
RETURNS varchar(max)
AS
BEGIN
   DECLARE @Rst varchar(max)
 
   SET @Rst=REPLACE(@text,'ي','ی')
   SET @Rst=REPLACE(@Rst,'ئ','ی')
   SET @Rst=REPLACE(@Rst,'ك','ک')
   SET @Rst=REPLACE(@Rst,'آ','ا')
   SET @Rst=REPLACE(@Rst,'أ','ا')
   SET @Rst=REPLACE(@Rst,'إ','ا')
   SET @Rst=REPLACE(@Rst,'ۀ','ه')
   SET @Rst=REPLACE(@Rst,'ة','ه')
   SET @Rst=REPLACE(@Rst,'ؤ','و')
   SET @Rst=REPLACE(@Rst,'ء','')
   RETURN @Rst
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetGusetStudentDocStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION	[dbo].[fn_GetGusetStudentDocStatus]( @docStatus int)
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CASE @docStatus 
		    WHEN 1 THEN 'بارگذاری مدرک'
		    WHEN 2 THEN 'تایید شده'
			WHEN 3 THEN 'رد شده'
		    ELSE  'نامشخص'   
		  END 
END 
--SELECT dbo.fn_GetGusetStudentDocStatus(1)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetGusetStudentDocType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION	[dbo].[fn_GetGusetStudentDocType]( @docType int)
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CASE @docType 
		    WHEN 16 THEN 'کارت دانشجویی'
		    WHEN 17 THEN 'نامه مهمانی'
		    ELSE  'نامشخص'   
		  END 
END 
--SELECT dbo.fn_GetGusetStudentDocType(16)

--==========================================
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetLetterStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION	[dbo].[fn_GetLetterStatus]( @letterStatus int)
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CASE @letterStatus 
		     WHEN 0 THEN 'بار گذاری نشده'
			 WHEN 1 THEN 'بارگذاری شده'
			 WHEN 2 THEN 'تایید شده'
			 WHEN 3 THEN 'رد شده'
			ELSE  'تعیین نشده'    
		  END 
END 
--SELECT dbo.fn_GetLetterStatus(3)
--==========================================
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetRequestStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION	[dbo].[fn_GetRequestStatus]( @reqstatus int)
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CASE @reqstatus    
			WHEN 0 THEN 'ورود اطلاعات فردی' 
			WHEN 1 THEN 'بارگذاری مدارک'
			WHEN 2 THEN 'تایید اطلاعات فردی'
			WHEN 3 THEN 'رد درخواست مهمانی'
			WHEN 4 THEN 'منتقل شده به سیدا بدون انتخاب واحد'
			WHEN 5 THEN 'منتقل شده به سیدا با انتخاب واحد'
			ELSE  'تعیین نشده'   
	      END 
END 
--SELECT dbo.fn_GetRequestStatus(-1)
--==========================================
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetStdCartstatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION	[dbo].[fn_GetStdCartstatus]( @stdCartstatus int)
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CASE @stdCartstatus 
		    WHEN 2 THEN 'تایید شده'
		    WHEN 3 THEN 'رد شده'
		    ELSE  'تعیین نشده'   
		  END 
END 
--SELECT dbo.fn_GetStdCartstatus(2)
--==========================================
GO
/****** Object:  UserDefinedFunction [dbo].[fnNumberToWord_Persian]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[fnNumberToWord_Persian](@pNumber AS VARCHAR(100))
RETURNS NVARCHAR(2000)
AS
BEGIN
	IF LEN(ISNULL(@pNumber, '')) = 0  RETURN NULL

	IF (PATINDEX('%[^0-9.-]%', @pNumber) > 0)
	   OR (LEN(@pNumber) -LEN(REPLACE(@pNumber, '-', '')) > 1)
	   OR (LEN(@pNumber) -LEN(REPLACE(@pNumber, '.', '')) > 1)
	   OR (CHARINDEX('-', @pNumber) > 1)
		RETURN 'خطا'
	
	IF PATINDEX('%[^0]%', @pNumber) = 0  RETURN 'صفر'
	IF (CHARINDEX('.', @pNumber) = 1) SET @pNumber='0'+@pNumber
	
	DECLARE @Negative  AS VARCHAR(5) = '';
	IF LEFT(@pNumber, 1) = '-'
	BEGIN
	    SET @pNumber = SUBSTRING(@pNumber, 2, 100)
	    SET @Negative  = 'منفی '
	END
	---------------------------------------------------------------------
	DECLARE @NumberTitle TABLE (val  INT,Title NVARCHAR(100));	
	INSERT INTO @NumberTitle (val,Title)
	VALUES(0, '')
		,(1, 'یک') ,(2, 'دو')	,(3, 'سه')	,(4, 'چهار')
		,(5,'پنج'),(6, 'شش'),(7, 'هفت'),(8, 'هشت')
		,(9, 'نه'),(10, 'ده'),(11, 'یازده'),(12, 'دوازده')
		,(13, 'سیزده'),(14, 'چهارده')	,(15, 'پانزده'),(16, 'شانزده')
		,(17, 'هفده'),(18, 'هجده'),(19, 'نوزده'),(20, 'بیست')
		,(30, 'سی'),(40, 'چهل'),(50, 'پنجاه'),(60, 'شصت')
		,(70, 'هفتاد'),(80, 'هشتاد'),(90, 'نود'),(100, 'صد')
		,(200, 'دویست'),(300, 'سیصد'),(400, 'چهارصد'),(500, 'پانصد')
		,(600, 'ششصد'),(700, 'هفتصد'),(800, 'هشتصد'),(900, 'نهصد')
	
	DECLARE @PositionTitle TABLE (id  INT,Title NVARCHAR(100));			
	INSERT INTO @PositionTitle (id,title)
	VALUES (1, '')	,(2, 'هزار'),(3, 'میلیون'),(4, 'میلیارد'),(5, 'تریلیون')
		,(6, 'کوادریلیون'),(7, 'کوینتیلیون'),(8, 'سیکستیلون'),(9, 'سپتیلیون')
		,(10, 'اکتیلیون'),(11, 'نونیلیون'),(12, 'دسیلیون')
		,(13, 'آندسیلیون'),(14, 'دودسیلیون'),(15, 'تریدسیلیون')
		,(16, 'کواتردسیلیون'),(17, 'کویندسیلیون'),(18, 'سیکسدسیلیون')
		,(19, 'سپتندسیلیون'),(20, 'اکتودسیلیوم'),(21, 'نومدسیلیون')		
	
	DECLARE @DecimalTitle TABLE (id  INT,Title NVARCHAR(100));		
	INSERT INTO @DecimalTitle (id,Title)
	VALUES( 1 ,'' ),(2 , 'صدم'),(3 , 'هزارم')
		,(4 , 'ده-هزارم'),(5 , 'صد-هزارم'),(6 , 'میلیون ام')
		,(7 , 'ده-میلیون ام'),(8 , 'صد-میلیون ام'),(9 , 'میلیاردم')
		,(10 , 'ده-میلیاردم')
	---------------------------------------------------------------------
	
	DECLARE @IntegerNumber NVARCHAR(100),
			@DecimalNumber NVARCHAR(100),
			@PointPosition INT =case CHARINDEX('.', @pNumber) WHEN 0 THEN LEN(@pNumber)+1 ELSE CHARINDEX('.', @pNumber) END
			
	SET @IntegerNumber= LEFT(@pNumber, @PointPosition - 1)
	SET @DecimalNumber= '?' + SUBSTRING(@pNumber, @PointPosition + 1, LEN(@pNumber))
	SET @DecimalNumber=  SUBSTRING(@DecimalNumber,2, len(@DecimalNumber )-PATINDEX('%[^0]%', REVERSE (@DecimalNumber)))
	SET @pNumber= @IntegerNumber
    while (len(@DecimalNumber)=1)
    begin
    set @DecimalNumber =@DecimalNumber + '0'
    end


	--DECLARE @IntegerNumber NVARCHAR(100),
	--@DecimalNumber NVARCHAR(100),
	--@PointPosition INT =case CHARINDEX('.', @pNumber) WHEN 0 THEN LEN(@pNumber)+1 ELSE CHARINDEX('.', @pNumber) END
 
	--SET @pNumber=replace(rtrim(replace(@pNumber,'0',' ')),' ','0');
	--SET @IntegerNumber= LEFT(@pNumber, @PointPosition - 1)
	--SET @DecimalNumber= SUBSTRING(@pNumber, @PointPosition+1 , LEN(@pNumber))
  
	--SET @pNumber= @IntegerNumber


	---------------------------------------------------------------------
	DECLARE @Number AS INT
	DECLARE @MyNumbers TABLE (id INT IDENTITY(1, 1), Val1 INT, Val2 INT, Val3 INT)
	
	WHILE (@pNumber) <> '0'
	BEGIN
	    SET @number = CAST(SUBSTRING(@pNumber, LEN(@pNumber) -2, 3)AS INT)	
	    
		INSERT INTO @MyNumbers
		SELECT (@Number % 1000) -(@Number % 100),
		CASE 
			WHEN @Number % 100 BETWEEN 10 AND 19 THEN @Number % 100
			ELSE (@Number % 100) -(@Number % 10)
		END,
		CASE 
			WHEN @Number % 100 BETWEEN 10 AND 19 THEN 0
			ELSE @Number % 10
		END
	    
	    IF LEN(@pNumber) > 2
	        SET @pNumber = LEFT(@pNumber, LEN(@pNumber) -3)
	    ELSE
	        SET @pNumber = '0'
	END
	---------------------------------------------------------------------	
	DECLARE @Str AS NVARCHAR(2000) = '';

	SELECT @Str += REPLACE(REPLACE(LTRIM(RTRIM(nt1.Title + ' ' + nt2.Title + ' ' + nt3.title)),'  ',' '),' ', ' و ')
	       + ' ' + pt.title + ' و '
	FROM   @MyNumbers  AS mn
	       INNER JOIN @PositionTitle pt
	            ON  pt.id = mn.id
	       INNER JOIN @NumberTitle nt1
	            ON  nt1.val = mn.Val1
	       INNER JOIN @NumberTitle nt2
	            ON  nt2.val = mn.Val2
	       INNER JOIN @NumberTitle nt3
	            ON  nt3.val = mn.Val3
	WHERE  (nt1.val + nt2.val + nt3.val > 0)
	ORDER BY pt.id DESC
	
	IF @IntegerNumber='0'  
		SET @Str=CASE WHEN PATINDEX('%[^0]%', @DecimalNumber) > 0 THEN @Negative ELSE '' END + 'صفر'
	ELSE
		SET @Str = @Negative  + LEFT (@Str, LEN(@Str) -2)
		
    DECLARE @PTitle NVARCHAR(100)=ISNULL((SELECT Title FROM @DecimalTitle WHERE id=LEN(@DecimalNumber)),'')
	SET @Str += ISNULL(' و '+[dbo].[fnNumberToWord_Persian](@DecimalNumber) +' '+@PTitle,'')
	RETURN @str
END
GO
/****** Object:  UserDefinedFunction [dbo].[magh2]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[magh2] (@roz  tinyint )
RETURNS   tinyint
 AS  
 BEGIN 

declare @ss  tinyint
set @ss=''

  if @roz=1
    set @ss=2
  if @roz=2
    set @ss=1
  if @roz=3
    set @ss=5
  if @roz=4
    set @ss=4
  if @roz=5
    set @ss=6
  if @roz=6
    set @ss=7
  if @roz=7
    set @ss=3
  if @roz=8
    set @ss=8

return @ss
  
 END
GO
/****** Object:  UserDefinedFunction [dbo].[MiladiTOShamsi]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[MiladiTOShamsi] (@MDate  DateTime)  
RETURNS Varchar(10)
AS  
BEGIN 
   DECLARE @SYear  as Integer
   DECLARE @SMonth  as Integer
   DECLARE @my_mah varchar(2)
   declare @my_day varchar(2)
   DECLARE @SDay  as Integer
   DECLARE @AllDays  as float
   DECLARE @ShiftDays  as float
   DECLARE @OneYear  as float
   DECLARE @LeftDays  as float
   DECLARE @YearDay  as Integer
   DECLARE @Farsi_Date  as Varchar(100) 
   SET @MDate=@MDate-CONVERT(char,@MDate,114)

  SET @ShiftDays=466699   +2
  SET @OneYear= 365.24199


   SET @SYear = 0
   SET @SMonth = 0
   SET @SDay = 0
   SET @AllDays  = CAst(@Mdate as Real)

   SET @AllDays = @AllDays + @ShiftDays

  SET @SYear = (@AllDays / @OneYear) --trunc
  SET @LeftDays = @AllDays - @SYear * @OneYear

  if (@LeftDays < 0.5)
  begin
    SET @SYear=@SYear+1
    SET @LeftDays = @AllDays - @SYear * @OneYear
  end;

  SET @YearDay = @LeftDays --trunc
  if (@LeftDays - @YearDay) >= 0.5 
    SET @YearDay=@YearDay+1

  if ((@YearDay / 31) > 6 )
  begin
    SET @SMonth = 6
    SET @YearDay=@YearDay-(6 * 31)
    SET @SMonth= @SMonth+( @YearDay / 30)
    if (@YearDay % 30) <> 0 
      SET @SMonth=@SMonth+1
    SET @YearDay=@YearDay-((@SMonth - 7) * 30)
  end 
  else
  begin
    SET @SMonth = @YearDay / 31
    if (@YearDay % 31) <> 0 
      SET @SMonth=@SMonth+1 
    SET @YearDay=@YearDay-((@SMonth - 1) * 31)
  end
  SET @SDay = @YearDay
  SET @SYear=@SYear+1


if @SMonth <10 begin 
   set @my_mah='0'+str(@SMonth,1)
end else begin
	set @my_mah = str(@SMonth,2)
end   
if @sday <10 begin
   set @my_day='0'+str(@Sday,1)
end else begin
	set @my_day = str(@Sday,2)
end   

 
 SET @Farsi_Date =   CAST (@SYear   as VarChar(10)) + '/' + @my_mah + '/' + @my_day
 Return @Farsi_Date



END





GO
/****** Object:  UserDefinedFunction [dbo].[pagetype]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[pagetype](@TypeID int )
 returns varchar(30)
 as
 begin
 declare @ret varchar(30)
 set @ret=case @TypeID
 when 0 then 'صفحه ورود'
 when 1 then 'اطلاعات فردی'
 when 2 then 'اطلاعات تحصیلی'
 when 3 then 'وظیفه'
 when 4 then 'سهمیه'
 when 5 then 'پیش نمایش اطلاعات'
 when 6 then 'ورود مدارک'
 when 7 then 'پیش نمایش مدارک'
 when 8 then 'پرداخت'
 when 9 then 'نمایش شماره دانشجویی'
 when 10 then 'انتخاب محل امتحان'
 else '' end
 return @ret

 end







GO
/****** Object:  UserDefinedFunction [dbo].[PersianToGregorian]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PersianToGregorian]
(
	@DateStr	varchar(10)
)
RETURNS datetime
AS
BEGIN
	
	
declare @YYear int,@MMonth int,@DDay int,@epbase int,@epyear int,@mdays int,@persian_jdn int,@i int,@j int,@l int,@n int,@TMPRESULT varchar(10),@IsValideDate int,@TempStr varchar(20),@TmpDateStr varchar(10)

SET @i=charindex('/',@DateStr)
IF LEN(@DateStr) - CHARINDEX('/', @DateStr,CHARINDEX('/', @DateStr,1)+1) = 4
BEGIN
	IF ( ISDATE(@TmpDateStr) =1 )
		return @TmpDateStr
	ELSE
		return NULL
END
ELSE
	SET @TmpDateStr = @DateStr
	IF ((@i<>0) and
	(ISNUMERIC(REPLACE(@TmpDateStr,'/',''))=1) and
	(charindex('.',@TmpDateStr)=0))
	BEGIN
		SET @YYear=CAST(SUBSTRING(@TmpDateStr,1,@i-1) AS INT)
		IF ( @YYear< 1300 )
			SET @YYear =@YYear + 1300
		IF @YYear > 9999
			return NULL
		SET @TempStr= SUBSTRING(@TmpDateStr,@i+1,Len(@TmpDateStr))
		SET @i=charindex('/',@TempStr)
		SET @MMonth=CAST(SUBSTRING(@TempStr,1,@i-1) AS INT)
		SET @MMonth=@MMonth-- -1
		SET @TempStr= SUBSTRING(@TempStr,@i+1,Len(@TempStr))
		SET @DDay=CAST(@TempStr AS INT)
		SET @DDay=@DDay-- - 1
		IF ( @YYear >= 0 )
			SET @epbase = @YYear - 474
		Else
			SET @epbase = @YYear - 473
		SET @epyear = 474 + (@epbase % 2820)
		IF (@MMonth <= 7 )
			SET @mdays = ((@MMonth) - 1) * 31
		Else
			SET @mdays = ((@MMonth) - 1) * 30 + 6
		SET @persian_jdn =(@DDay) + @mdays + CAST((((@epyear * 682) - 110) / 2816) as int) + (@epyear - 1) * 365 + CAST((@epbase / 2820) as int ) * 1029983 + (1948321 - 1)
		IF (@persian_jdn > 2299160)
		BEGIN
			SET @l = @persian_jdn + 68569
			SET @n = CAST(((4 * @l) / 146097) as int)
			SET @l = @l - CAST(((146097 * @n + 3) / 4) as int)
			SET @i = CAST(((4000 * (@l + 1)) / 1461001) as int)
			SET @l = @l - CAST( ((1461 * @i) / 4) as int) + 31
			SET @j = CAST(((80 * @l) / 2447) as int)
			SET @DDay = @l - CAST( ((2447 * @j) / 80) as int)
			SET @l = CAST((@j / 11) as int)
			SET @MMonth = @j + 2 - 12 * @l
			SET @YYear = 100 * (@n - 49) + @i + @l
		END
		SET @TMPRESULT=Cast(@MMonth as varchar(2))+'/'+CAST(@DDay as Varchar(2))+'/'+CAST(@YYear as varchar(4))
		return Cast(@TMPRESULT as datetime)
	END
	RETURN NULL
END
GO
/****** Object:  UserDefinedFunction [dbo].[Ret_Idresh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Ret_Idresh](@codesazman varchar(10))
RETURNS  numeric(18,0)
as
begin
declare @ReshId  numeric(18,0)
select @ReshId=id from amozesh.dbo.fresh where codesazman=@codesazman
return @ReshId
end
GO
/****** Object:  UserDefinedFunction [dbo].[Shahrie]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Shahrie]
(@Variable int,
@fix int)
RETURNS int
as
begin
declare @Price int
if @Variable<>0
set @Price=@Variable
if @fix <>0
set @Price=@fix
return @Price
 end
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aaa$]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aaa$](
	[F1] [float] NULL,
	[F2] [nvarchar](255) NULL,
	[F3] [nvarchar](255) NULL,
	[F4] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AllAlterText]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllAlterText](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [varchar](max) NULL,
	[Category] [tinyint] NULL,
	[StatusID] [int] NULL,
 CONSTRAINT [PK_EmailBodyText] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Children]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Children](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[stcode] [varchar](9) NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[BirthDate] [date] NULL,
	[Gender] [bit] NULL,
 CONSTRAINT [PK_Children] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Control]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Control](
	[Control_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Has_PosPayment] [bit] NULL,
	[StartReg_Date] [char](10) NULL,
	[EndReg_Date] [char](10) NULL,
	[Term] [char](7) NULL,
	[LevelId] [tinyint] NULL,
 CONSTRAINT [PK_Control] PRIMARY KEY CLUSTERED 
(
	[Control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Danesh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Danesh](
	[id] [int] NOT NULL,
	[DaneshName] [varchar](50) NULL,
 CONSTRAINT [PK_Danesh] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NULL,
	[Number] [nvarchar](350) NULL,
	[Percentage] [float] NULL,
	[IsDisposable] [bit] NULL,
	[IsUsage] [bit] NULL,
 CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[doc_image]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[doc_image](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[id_scan] [numeric](18, 0) NOT NULL,
	[stcode] [varchar](11) NOT NULL,
	[doc_image] [image] NULL,
	[deleted] [bit] NULL,
	[name_karbar] [varchar](50) NULL,
	[date_scan] [varchar](8) NULL,
	[time_scan] [varchar](5) NULL,
 CONSTRAINT [PK_doc_image] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[id_scan] ASC,
	[stcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EduLevel]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EduLevel](
	[ID] [tinyint] NOT NULL,
	[Id_sazman] [tinyint] NULL,
	[id_sida] [tinyint] NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_EduLevel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[ManagerID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[End_Madrak]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[End_Madrak](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Sida_ID] [int] NULL,
	[LevelName] [varchar](50) NULL,
 CONSTRAINT [PK_End_Madrak] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventName]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventName](
	[id] [int] NOT NULL,
	[EventName] [nvarchar](50) NULL,
 CONSTRAINT [PK_EventName] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamPlace]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamPlace](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Stcode] [varchar](11) NOT NULL,
	[ID_Exam_Place] [numeric](18, 0) NOT NULL,
	[SaveDate] [varchar](10) NULL,
 CONSTRAINT [PK_ExamPlace] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fcoding]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fcoding](
	[id] [numeric](18, 0) NOT NULL,
	[idtypecoding] [numeric](18, 0) NOT NULL,
	[namecoding] [varchar](100) NULL,
	[nameidtypecoding] [varchar](50) NULL,
	[codemoadel] [varchar](10) NULL,
	[moadel_feraghat] [tinyint] NULL,
	[moadel_nezam] [varchar](10) NULL,
	[myid] [numeric](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Field]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Field](
	[Field_ID] [bigint] NOT NULL,
	[Field_Name] [varchar](100) NULL,
	[Sida_ID] [bigint] NULL,
	[Code_Baygan] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Field_old]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Field_old](
	[Field_ID] [bigint] NOT NULL,
	[Field_Name] [varchar](100) NULL,
	[Sida_ID] [bigint] NULL,
	[Code_Baygan] [varchar](10) NULL,
 CONSTRAINT [PK_Field] PRIMARY KEY CLUSTERED 
(
	[Field_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fnewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fnewStudent](
	[term] [int] NOT NULL,
	[vorodi] [tinyint] NOT NULL,
	[stcode] [varchar](11) NOT NULL,
	[stcodeTemp] [varchar](11) NULL,
	[name] [varchar](30) NULL,
	[family] [varchar](70) NULL,
	[namep] [varchar](40) NULL,
	[idd] [varchar](20) NULL,
	[idd_meli] [varchar](20) NULL,
	[sex] [tinyint] NULL,
	[magh] [tinyint] NULL,
	[idreshSazman] [varchar](10) NULL,
	[idresh] [numeric](18, 0) NULL,
	[year_tav] [int] NULL,
	[date_tav] [varchar](10) NULL,
	[radif_gh] [varchar](10) NULL,
	[rotbeh_gh] [varchar](10) NULL,
	[nomreh_gh] [varchar](10) NULL,
	[code_posti] [varchar](20) NULL,
	[tel] [varchar](50) NULL,
	[mobile] [varchar](20) NULL,
	[email] [varchar](70) NULL,
	[Province] [tinyint] NULL,
	[City] [int] NULL,
	[addressd] [varchar](200) NULL,
	[enteghal] [tinyint] NULL,
	[dateenteghal] [varchar](10) NULL,
	[idgeraesh] [numeric](18, 0) NULL,
	[nobat] [tinyint] NULL,
	[par] [varchar](15) NULL,
	[dav] [varchar](15) NULL,
	[date_sabtenam] [varchar](10) NULL,
	[mahal_tav] [numeric](18, 0) NULL,
	[mahal_sodor] [numeric](18, 0) NULL,
	[tahol] [numeric](18, 0) NULL,
	[end_madrak] [numeric](18, 0) NULL,
	[din] [numeric](18, 0) NULL,
	[resh_endmadrak] [numeric](18, 0) NULL,
	[date_endmadrak] [varchar](10) NULL,
	[avrg_payeh] [varchar](5) NULL,
	[dip_avrg] [varchar](5) NULL,
	[sahmeh] [numeric](18, 0) NULL,
	[sahmeh_Ostan] [varchar](50) NULL,
	[university] [numeric](18, 0) NULL,
	[bomi] [numeric](18, 0) NULL,
	[jesm] [numeric](18, 0) NULL,
	[meliat] [numeric](18, 0) NULL,
	[job] [varchar](200) NULL,
	[sal_vorod] [numeric](18, 0) NULL,
	[janbazi_darsad] [tinyint] NULL,
	[janbazi_nesbat] [varchar](50) NULL,
	[janbaz_rayaneh] [varchar](20) NULL,
	[azadeh_modat] [int] NULL,
	[nezamvazife] [int] NULL,
	[mahal_khedmat] [int] NULL,
	[ersal_name] [bit] NULL,
	[khedmat_add] [varchar](350) NULL,
	[ozv_basij] [bit] NULL,
	[ozv_lib] [bit] NULL,
	[status] [tinyint] NULL,
	[id_paziresh] [int] NULL,
	[IsInstallment] [bit] NULL,
	[DataEnterDate] [varchar](10) NULL,
	[permitted] [bit] NULL,
	[resh_mortabet] [int] NULL,
	[Madrak_Status] [int] NULL,
	[StudentLeaveStatus] [int] NULL,
	[StateWelfare] [int] NOT NULL,
	[StateWelfareLetter] [varchar](50) NULL,
	[IsEmployed] [bit] NULL,
	[StateWelfareLetterDate] [varchar](10) NULL,
	[StateWelfareState] [int] NULL,
	[DisabilityType] [int] NULL,
	[UniversityType] [int] NULL,
	[JobProvince] [int] NULL,
	[JobCity] [int] NULL,
	[JobAddress] [nvarchar](200) NULL,
	[JobTel] [varchar](50) NULL,
	[JobPostalcode] [varchar](20) NULL,
	[JobType] [int] NULL,
	[JobTime] [int] NULL,
	[JobContract] [int] NULL,
	[JobPosition] [int] NULL,
	[ConnectionType] [int] NULL,
	[DeviceType] [int] NULL,
	[SpouseFirstName] [varchar](30) NULL,
	[SpouseLastName] [varchar](70) NULL,
	[SpouseIsEmployed] [bit] NULL,
	[SpouseJobTitle] [varchar](200) NULL,
	[Accessories] [varchar](50) NULL,
	[InternetProvider] [int] NULL,
	[IntroductionMethod] [int] NULL,
	[LocalFacilities] [varchar](50) NULL,
	[LocalFacilityUnit] [int] NULL,
	[ReligionBranches] [numeric](18, 0) NULL,
	[SimultaneousEntrance] [numeric](18, 0) NULL,
	[SimultaneousField] [numeric](18, 0) NULL,
	[SimultaneousLevel] [numeric](18, 0) NULL,
	[SimultaneousUni] [numeric](18, 0) NULL,
	[SimultaneousUniType] [numeric](18, 0) NULL,
	[SimultaneousStudy] [numeric](18, 0) NOT NULL,
	[AcceptationDescription] [nvarchar](300) NULL,
	[InsertedIntoAmoozeshyar] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Group]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Group](
	[GroupId] [int] NOT NULL,
	[GroupName] [varchar](50) NULL,
	[DaneshID] [int] NULL,
 CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupManager]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupManager](
	[ID_UserLogin] [int] NOT NULL,
	[ID_Group] [int] NULL,
	[magh] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuestCollege]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestCollege](
	[CollegeId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_GuestCollege] PRIMARY KEY CLUSTERED 
(
	[CollegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuestCourse]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestCourse](
	[GuestCourseId] [int] IDENTITY(1,1) NOT NULL,
	[did] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[Term] [varchar](7) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuestStudentsDocs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestStudentsDocs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[stcode] [varchar](11) NOT NULL,
	[GuestStudentInfoID] [int] NULL,
	[Filename] [nvarchar](50) NULL,
	[Address] [varchar](200) NULL,
	[CategoryId] [int] NULL,
	[DocumentStatus] [tinyint] NULL,
	[Note] [nvarchar](max) NULL,
	[DocTerm] [varchar](7) NOT NULL,
 CONSTRAINT [PK_GuestStudentsDocs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuestStudentsInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestStudentsInfo](
	[ID] [int] IDENTITY(10000,1) NOT NULL,
	[stcode] [nvarchar](10) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[FatherName] [nvarchar](50) NULL,
	[IdNo] [decimal](18, 0) NULL,
	[NationalCode] [nchar](10) NULL,
	[BirthDate] [nvarchar](50) NULL,
	[IssuePlace] [int] NULL,
	[RequestStatus] [tinyint] NOT NULL,
	[Email] [varchar](100) NULL,
	[Mobile] [nvarchar](50) NULL,
	[UniversityId] [int] NOT NULL,
	[ExamPlaceId] [int] NULL,
	[FieldId] [int] NOT NULL,
	[LevelId] [int] NOT NULL,
	[RequestRegisterDate] [datetime] NULL,
	[RequestTerm] [varchar](7) NOT NULL,
	[Gender] [tinyint] NULL,
	[Note] [nvarchar](max) NULL,
	[LetterNo] [nvarchar](50) NULL,
	[LetterDate] [nvarchar](50) NULL,
	[EntranceYear] [varchar](10) NULL,
	[Address] [nvarchar](max) NULL,
	[CollegeId] [int] NOT NULL,
 CONSTRAINT [PK_PersInfo_Vasaya] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Help]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Help](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[HelpBodyText] [varchar](max) NULL,
	[RowID] [int] NULL,
	[TypeId] [int] NULL,
 CONSTRAINT [PK_Help] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[img_t1]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[img_t1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[img] [image] NULL,
 CONSTRAINT [PK_img_t1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Keywords]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Keywords](
	[KeywordID] [int] IDENTITY(1,1) NOT NULL,
	[KeyWordText] [varchar](150) NULL,
	[DocCategoryId] [int] NULL,
 CONSTRAINT [PK_Keywords] PRIMARY KEY CLUSTERED 
(
	[KeywordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Moghayerat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Moghayerat](
	[stcode] [varchar](11) NULL,
	[address] [varchar](200) NULL,
	[moghayerat_type] [int] NULL,
	[eslahat] [varchar](200) NULL,
	[wrong] [varchar](70) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MoghayeratType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MoghayeratType](
	[MoghayeratID] [int] NULL,
	[Moghayerat] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[newfcoding]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[newfcoding](
	[id] [numeric](18, 0) NOT NULL,
	[idtypecoding] [numeric](18, 0) NOT NULL,
	[namecoding] [varchar](100) NULL,
	[nameidtypecoding] [varchar](50) NULL,
	[codemoadel] [varchar](10) NULL,
	[moadel_feraghat] [tinyint] NULL,
	[moadel_nezam] [varchar](10) NULL,
	[myid] [numeric](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NOT NULL,
	[Result] [int] NULL,
	[RetrivalRefNo] [varchar](550) NULL,
	[AmountTrans] [bigint] NOT NULL,
	[RequestKey] [nvarchar](250) NOT NULL,
	[AppStatus] [nvarchar](70) NULL,
	[StudentCode] [nvarchar](250) NULL,
	[tterm] [varchar](7) NOT NULL,
	[BankID] [int] NOT NULL,
	[MiladiDate] [datetime] NOT NULL,
	[PersianDate] [varchar](10) NOT NULL,
	[TransMiladiDate] [datetime] NULL,
	[TransPersianDate] [varchar](20) NULL,
	[TraceNumber] [bigint] NULL,
	[CardHolder] [nvarchar](350) NULL,
	[CardNumber] [varchar](30) NULL,
	[PayType] [tinyint] NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentReciept]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentReciept](
	[RecieptID] [bigint] IDENTITY(1,1) NOT NULL,
	[RecieptNumber] [varchar](50) NULL,
	[RecieptDate] [varchar](10) NULL,
	[RecieptAmount] [bigint] NULL,
	[stcode] [varchar](11) NULL,
	[SubmitDate] [datetime] NULL,
	[term] [varchar](7) NULL,
 CONSTRAINT [PK_PaymentReciept] PRIMARY KEY CLUSTERED 
(
	[RecieptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestChangeField](
	[RequestID] [int] IDENTITY(1,1) NOT NULL,
	[iddMeli] [varchar](15) NULL,
	[OldField] [int] NULL,
	[NewField] [int] NULL,
	[ComposeOrReply] [int] NULL,
	[UserId] [int] NULL,
	[RequestText] [varchar](700) NULL,
	[StatusRequest] [int] NULL,
	[RequestDate] [varchar](10) NULL,
	[IsRead] [bit] NULL,
	[OldStcode] [varchar](11) NULL,
	[NewStcode] [varchar](11) NULL,
	[CodeParvandeh] [varchar](50) NULL,
	[SalAzmoon] [varchar](50) NULL,
 CONSTRAINT [PK_RequestChangeField] PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reshte961$]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reshte961$](
	[F1] [float] NULL,
	[F2] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Setting]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Setting](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[FieldId] [int] NULL,
	[LevelId] [int] NULL,
	[StartDate] [varchar](10) NULL,
	[StartTime] [varchar](10) NULL,
	[EndDate] [varchar](10) NULL,
	[EndTime] [varchar](10) NULL,
	[Term] [varchar](10) NULL,
	[StatusType] [int] NULL,
	[Status] [int] NULL,
	[NaghsDate] [varchar](10) NULL,
	[UnitLetterDate] [varchar](10) NULL,
 CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sheet1$]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet1$](
	[F1] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sheet2$]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet2$](
	[F1] [float] NULL,
	[F2] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[St_Doc_Status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[St_Doc_Status](
	[id] [int] NOT NULL,
	[DocStatus] [nvarchar](50) NULL,
 CONSTRAINT [PK_St_Doc_Status] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[St_documents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[St_documents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[st_code] [varchar](11) NULL,
	[filename] [nvarchar](50) NULL,
	[address] [varchar](200) NULL,
	[category] [int] NULL,
	[Isok] [int] NULL,
	[Note] [text] NULL,
	[Doc_Term] [varchar](50) NULL,
	[id_naghs_msg] [bigint] NULL,
	[RegistrationConfirm] [int] NULL,
 CONSTRAINT [PK_St_documents] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[st_Documents_category]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[st_Documents_category](
	[id] [int] NOT NULL,
	[DocName] [nvarchar](50) NULL,
 CONSTRAINT [PK_st_Documents_category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[St_Status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[St_Status](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[St_Status] [varchar](50) NULL,
	[Status_ID] [int] NULL,
 CONSTRAINT [PK_St_Status] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Stcode] [varchar](11) NULL,
	[EnterDate] [varchar](15) NULL,
	[EnterTime] [varchar](8) NULL,
	[Event] [int] NULL,
	[Status] [int] NULL,
	[term] [varchar](7) NULL,
 CONSTRAINT [PK_StudentLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Ostan]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Ostan](
	[ID] [int] NOT NULL,
	[Title] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Shahrestan]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Shahrestan](
	[ID] [int] NOT NULL,
	[PK_Ostan] [int] NULL,
	[Title] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teladdress$]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teladdress$](
	[F1] [float] NULL,
	[F2] [float] NULL,
	[F3] [float] NULL,
	[F4] [float] NULL,
	[F5] [nvarchar](255) NULL,
	[F6] [float] NULL,
	[F7] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teststamp]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teststamp](
	[test] [timestamp] NULL,
	[id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TuitionFee]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TuitionFee](
	[TuitionId] [bigint] IDENTITY(1,1) NOT NULL,
	[FeildId] [int] NULL,
	[LevelId] [int] NULL,
	[Fee] [bigint] NULL,
	[Insurance] [int] NULL,
	[Service] [int] NULL,
	[Term] [varchar](7) NULL,
 CONSTRAINT [PK_TuitionFee] PRIMARY KEY CLUSTERED 
(
	[TuitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UniAddress]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UniAddress](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](max) NULL,
	[TopTel] [varchar](80) NULL,
	[BottomTel] [varchar](100) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](300) NULL,
 CONSTRAINT [PK_UniAddress] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[University]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[University](
	[UniversityId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_LogType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_LogType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LogType] [varchar](50) NULL,
 CONSTRAINT [PK_User_LogType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[LogDate] [date] NULL,
	[LogTime] [varchar](10) NULL,
	[StCode] [varchar](11) NULL,
	[DocId] [int] NULL,
	[DocStatus] [int] NULL,
	[LogType] [int] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogin](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](300) NULL,
	[RoleID] [int] NULL,
	[SectionId] [int] NULL,
	[Enable] [bit] NULL,
	[ShowAccessTomenu] [bit] NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[id] [int] NOT NULL,
	[RoleName] [nvarchar](50) NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Account]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Account](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[StudentId] [decimal](18, 0) NULL,
	[Password] [nvarchar](200) NOT NULL,
	[ResetPasswordToken] [nvarchar](500) NULL,
	[ResetPasswordTokenExpire] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[Active] [bit] NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Mobile] [nvarchar](20) NULL,
 CONSTRAINT [PK__Address__3214EC0787663FC6] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Address]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Address](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[PersonId] [decimal](18, 0) NULL,
	[AddressType] [tinyint] NULL,
	[Province] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[Street] [nvarchar](100) NULL,
	[Plaque] [nvarchar](100) NULL,
	[PostalCode] [nvarchar](100) NULL,
	[PhoneNo] [nvarchar](30) NULL,
	[PreCodeForMobile] [nvarchar](20) NULL,
	[PreCodeForPhoneNo] [nvarchar](20) NULL,
	[Active] [bit] NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Mobile] [nvarchar](30) NULL,
 CONSTRAINT [PK__StudentI__3214EC07427A78BF] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[CandidateField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[CandidateField](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[StudentId] [decimal](18, 0) NULL,
	[FieldId] [decimal](18, 0) NULL,
	[Active] [bit] NULL,
	[Selected] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[CitizenShip]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[CitizenShip](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[PersonId] [decimal](18, 0) NOT NULL,
	[CountryId] [decimal](18, 0) NULL,
	[DocType] [tinyint] NULL,
	[DocNo] [nvarchar](100) NULL,
	[IssueDate] [datetime] NULL,
	[IssuePlace] [decimal](18, 0) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK__CitizenS__3214EC07995D0334] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Colleges]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Colleges](
	[Id] [decimal](18, 0) NOT NULL,
	[CollegeName] [nvarchar](100) NOT NULL,
	[SIDA_Code] [decimal](18, 0) NULL,
	[LanguageCode] [varchar](20) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_InternationalRegistration.Colleges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Country]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Country](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[LanguageCode] [nvarchar](50) NULL,
	[CountryCode] [nvarchar](50) NULL,
	[PhoneCode] [int] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[EducationDegree]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[EducationDegree](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[SudentId] [decimal](18, 0) NULL,
	[FieldId] [decimal](18, 0) NULL,
	[TotalAverage] [decimal](18, 2) NULL,
	[WrittenAverage] [decimal](18, 2) NULL,
	[EducationDegreePlace] [decimal](18, 0) NULL,
	[UniversityName] [nvarchar](200) NULL,
	[CountryName] [nvarchar](200) NULL,
	[Active] [bit] NULL,
	[EndTimeInLevel] [date] NULL,
	[Level] [tinyint] NULL,
	[FieldTitle] [nvarchar](400) NULL,
 CONSTRAINT [PK__Educatio__3214EC078274A8AD] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[FieldForForeigns]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[FieldForForeigns](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Field_Name] [varchar](300) NULL,
	[LanguageCode] [varchar](20) NULL,
	[CollegeId] [decimal](18, 0) NULL,
	[FieldLevel] [tinyint] NULL,
	[Sida_ID] [bigint] NULL,
	[Code_Baygan] [varchar](20) NULL,
 CONSTRAINT [PK__FieldFor__3214EC07CCD0E8DC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[NewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[NewStudent](
	[term] [int] NOT NULL,
	[vorodi] [tinyint] NOT NULL,
	[stcode] [nvarchar](11) NULL,
	[stcodeTemp] [varchar](11) NULL,
	[name] [nvarchar](100) NULL,
	[family] [nvarchar](200) NULL,
	[namep] [nvarchar](100) NULL,
	[idd] [varchar](20) NULL,
	[idd_meli] [varchar](20) NULL,
	[sex] [tinyint] NULL,
	[magh] [tinyint] NULL,
	[idreshSazman] [nvarchar](10) NULL,
	[idresh] [numeric](18, 0) NULL,
	[year_tav] [int] NULL,
	[date_tav] [varchar](10) NULL,
	[radif_gh] [varchar](10) NULL,
	[rotbeh_gh] [varchar](10) NULL,
	[nomreh_gh] [varchar](10) NULL,
	[code_posti] [varchar](20) NULL,
	[tel] [varchar](50) NULL,
	[mobile] [varchar](20) NULL,
	[email] [varchar](70) NULL,
	[Province] [tinyint] NULL,
	[City] [int] NULL,
	[addressd] [varchar](200) NULL,
	[enteghal] [tinyint] NULL,
	[dateenteghal] [varchar](10) NULL,
	[idgeraesh] [numeric](18, 0) NULL,
	[nobat] [tinyint] NULL,
	[par] [varchar](15) NULL,
	[dav] [varchar](15) NULL,
	[date_sabtenam] [varchar](10) NULL,
	[mahal_tav] [numeric](18, 0) NULL,
	[mahal_sodor] [numeric](18, 0) NULL,
	[tahol] [numeric](18, 0) NULL,
	[end_madrak] [numeric](18, 0) NULL,
	[din] [numeric](18, 0) NULL,
	[resh_endmadrak] [numeric](18, 0) NULL,
	[date_endmadrak] [varchar](10) NULL,
	[avrg_payeh] [varchar](5) NULL,
	[dip_avrg] [varchar](5) NULL,
	[sahmeh] [numeric](18, 0) NULL,
	[sahmeh_Ostan] [varchar](50) NULL,
	[university] [numeric](18, 0) NULL,
	[bomi] [numeric](18, 0) NULL,
	[jesm] [numeric](18, 0) NULL,
	[meliat] [numeric](18, 0) NULL,
	[job] [varchar](200) NULL,
	[sal_vorod] [numeric](18, 0) NULL,
	[janbazi_darsad] [tinyint] NULL,
	[janbazi_nesbat] [varchar](50) NULL,
	[janbaz_rayaneh] [varchar](20) NULL,
	[azadeh_modat] [int] NULL,
	[nezamvazife] [int] NULL,
	[mahal_khedmat] [int] NULL,
	[ersal_name] [bit] NULL,
	[khedmat_add] [varchar](350) NULL,
	[ozv_basij] [bit] NULL,
	[ozv_lib] [bit] NULL,
	[status] [tinyint] NULL,
	[id_paziresh] [int] NULL,
	[IsInstallment] [bit] NULL,
	[DataEnterDate] [varchar](10) NULL,
	[permitted] [bit] NULL,
	[resh_mortabet] [int] NULL,
	[Madrak_Status] [int] NULL,
	[StudentLeaveStatus] [int] NULL,
	[StateWelfare] [int] NOT NULL,
	[StateWelfareLetter] [varchar](50) NULL,
	[IsEmployed] [bit] NULL,
	[StateWelfareLetterDate] [varchar](10) NULL,
	[StateWelfareState] [int] NULL,
	[DisabilityType] [int] NULL,
	[UniversityType] [int] NULL,
	[JobProvince] [int] NULL,
	[JobCity] [int] NULL,
	[JobAddress] [nvarchar](200) NULL,
	[JobTel] [varchar](50) NULL,
	[JobPostalcode] [varchar](20) NULL,
	[JobType] [int] NULL,
	[JobTime] [int] NULL,
	[JobContract] [int] NULL,
	[JobPosition] [int] NULL,
	[ConnectionType] [int] NULL,
	[DeviceType] [int] NULL,
	[SpouseFirstName] [varchar](30) NULL,
	[SpouseLastName] [varchar](70) NULL,
	[SpouseIsEmployed] [bit] NULL,
	[SpouseJobTitle] [varchar](200) NULL,
	[Accessories] [varchar](50) NULL,
	[InternetProvider] [int] NULL,
	[IntroductionMethod] [int] NULL,
	[LocalFacilities] [varchar](50) NULL,
	[LocalFacilityUnit] [int] NULL,
	[ReligionBranches] [numeric](18, 0) NULL,
	[SimultaneousEntrance] [numeric](18, 0) NULL,
	[SimultaneousField] [numeric](18, 0) NULL,
	[SimultaneousLevel] [numeric](18, 0) NULL,
	[SimultaneousUni] [numeric](18, 0) NULL,
	[SimultaneousUniType] [numeric](18, 0) NULL,
	[SimultaneousStudy] [numeric](18, 0) NOT NULL,
	[AcceptationDescription] [nvarchar](300) NULL,
	[RequestId] [decimal](18, 0) NULL,
	[NewStudentId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NewStudentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Person]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Person](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[FatherName] [nvarchar](100) NULL,
	[MotherName] [nvarchar](100) NULL,
	[GrandFatherName] [nvarchar](100) NULL,
	[BirthDate] [date] NULL,
	[BirthPlace] [nvarchar](100) NULL,
	[Gender] [tinyint] NULL,
	[IdNo] [nvarchar](100) NULL,
	[NationalCode] [nvarchar](10) NULL,
	[MarritalType] [tinyint] NULL,
	[IssuePlace] [nvarchar](100) NULL,
	[Active] [bit] NULL,
	[MiddleName] [nvarchar](100) NULL,
	[Job] [nvarchar](100) NULL,
	[RecommenderCode] [nvarchar](100) NULL,
 CONSTRAINT [PK__Person__3214EC079DD7C174] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[RelatedPerson]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[RelatedPerson](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[MainPersonId] [decimal](18, 0) NULL,
	[RelatedPersonId] [decimal](18, 0) NULL,
	[MainPersonRelationType] [tinyint] NULL,
	[RelatedPersonRelationType] [tinyint] NULL,
 CONSTRAINT [PK_RelatedPerson] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Request]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Request](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[StudentId] [decimal](18, 0) NULL,
	[Term] [nvarchar](7) NULL,
	[Status] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[Active] [bit] NULL,
	[CurrentLevel] [tinyint] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK__Request__3214EC078B4622AB] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [International].[Role]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Role](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](100) NULL,
	[DisplayName] [nvarchar](200) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK__Role__3214EC07A74A5BA6] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[Student]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[Student](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[PersonId] [decimal](18, 0) NULL,
	[MarritalStatus] [tinyint] NULL,
	[ChildrenCount] [tinyint] NULL,
	[HealthStatus] [tinyint] NULL,
	[Religien] [tinyint] NULL,
	[Email] [nvarchar](100) NULL,
	[Mobile] [nvarchar](20) NULL,
	[Term] [nvarchar](7) NULL,
	[Language] [varchar](5) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[StudentDocs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[StudentDocs](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[SudentId] [decimal](18, 0) NOT NULL,
	[FileName] [nvarchar](100) NULL,
	[Path] [nvarchar](400) NULL,
	[Category] [int] NULL,
	[DocStatus] [tinyint] NULL,
	[Term] [nvarchar](7) NOT NULL,
	[Active] [bit] NULL,
	[Description] [nvarchar](max) NULL,
	[Web_msg_stu_Idnaghs] [numeric](18, 0) NULL,
 CONSTRAINT [PK__StudentD__3214EC07F039C70D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [International].[StudentDocType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[StudentDocType](
	[Id] [int] NOT NULL,
	[DocNam] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[User]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[User](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](200) NULL,
	[DisplayName] [nvarchar](200) NULL,
	[Password] [nvarchar](400) NOT NULL,
	[ResetPasswordToken] [nvarchar](400) NULL,
	[ResetPasswordTokenExpire] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK__User__3214EC072F4427A7] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[User_Role]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[User_Role](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[UserId] [decimal](18, 0) NULL,
	[RoleId] [decimal](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[UserAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[UserAccess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AreaName] [nvarchar](100) NULL,
	[ControllerName] [nvarchar](100) NOT NULL,
	[ActionName] [nvarchar](100) NOT NULL,
	[ViewName] [nvarchar](100) NOT NULL,
	[RoleId] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK__UserAcce__3214EC071DE46AFE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[UserLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[UserLog](
	[ID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[UserId] [decimal](18, 0) NULL,
	[LogDate] [datetime] NULL,
	[Description] [nvarchar](400) NULL,
	[IP_dev] [nvarchar](100) NULL,
	[UserLogTypeId] [decimal](18, 0) NOT NULL,
	[ModifyId] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [International].[UserLogType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [International].[UserLogType](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [NoExamEntrance].[Documents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NoExamEntrance].[Documents](
	[id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[RequestId] [decimal](18, 0) NOT NULL,
	[FileName] [nchar](100) NULL,
	[Address] [nchar](100) NULL,
	[Category] [int] NULL,
	[Status] [tinyint] NULL,
	[Term] [nvarchar](7) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [NoExamEntrance].[OfflinePayments]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NoExamEntrance].[OfflinePayments](
	[id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[NationalCode] [varchar](10) NOT NULL,
	[Amount] [decimal](18, 0) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OfflinePayments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [NoExamEntrance].[Payment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NoExamEntrance].[Payment](
	[id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[RequestId] [decimal](18, 0) NOT NULL,
	[OrderId] [decimal](18, 0) NULL,
	[Result] [decimal](18, 0) NULL,
	[RetrivalRefNo] [nvarchar](50) NULL,
	[RequestKey] [nvarchar](50) NULL,
	[Amount] [decimal](18, 0) NULL,
	[AppStatus] [nvarchar](20) NULL,
	[Term] [nvarchar](7) NULL,
	[BankId] [int] NULL,
	[TraceNumber] [bigint] NULL,
	[PayType] [int] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_Payment_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [NoExamEntrance].[Request]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NoExamEntrance].[Request](
	[id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NULL,
	[FathersName] [nvarchar](200) NULL,
	[IdNo] [nvarchar](50) NULL,
	[NationalCode] [nvarchar](50) NULL,
	[Gender] [tinyint] NULL,
	[BirthYear] [tinyint] NULL,
	[FieldId] [int] NULL,
	[Religion] [tinyint] NULL,
	[Mobile] [nvarchar](15) NULL,
	[PhoneNo] [nvarchar](50) NULL,
	[PhoneNoPreCode] [nvarchar](50) NULL,
	[Email] [nvarchar](200) NULL,
	[Address] [nvarchar](300) NULL,
	[LastDegreeType] [tinyint] NULL,
	[LastDegreeScore] [float] NULL,
	[CreateDate] [datetime] NULL,
	[Status] [tinyint] NULL,
	[EntranceYear] [int] NULL,
	[StudyingLevel] [int] NULL,
	[StudyingField] [int] NULL,
	[StudyingPlace] [int] NULL,
	[IsStudentNow] [bit] NULL,
	[StudingUniType] [int] NULL,
	[Term] [varchar](7) NULL,
	[EducationalGroup] [nvarchar](100) NULL,
	[BirthDate] [nvarchar](10) NULL,
	[IdLetter] [nvarchar](5) NULL,
	[IdSerie] [int] NULL,
	[IdSerial] [int] NULL,
	[Nationality] [nvarchar](20) NULL,
	[MilitaryStatus] [nvarchar](100) NULL,
	[QuotaStatus] [nvarchar](100) NULL,
	[PhysicalStatus] [nvarchar](100) NULL,
	[LivingPlaceState] [nvarchar](100) NULL,
	[BirthPlaceState] [nvarchar](100) NULL,
	[PostalCode] [decimal](18, 0) NULL,
	[DiplomaTitle] [nvarchar](100) NULL,
	[DiplomaDate] [nvarchar](10) NULL,
	[DiplomaTotalAvg] [decimal](18, 2) NULL,
	[DiplomaWrittenAvg] [decimal](18, 2) NULL,
	[DiplomaRegionCode] [decimal](18, 0) NULL,
	[DiplomaState] [nvarchar](100) NULL,
	[DiplomaCity] [nvarchar](100) NULL,
	[DiplomaSection] [nvarchar](100) NULL,
	[PreUniversityTitle] [nvarchar](100) NULL,
	[PreUniversityDate] [nvarchar](10) NULL,
	[PreUniversityTotalAvg] [decimal](18, 2) NULL,
	[PreUniversityRegionCode] [decimal](18, 0) NULL,
	[PreUniversityState] [nvarchar](100) NULL,
	[PreUniversityCity] [nvarchar](100) NULL,
	[PreUniversitySection] [nvarchar](100) NULL,
	[PreDiplomaState] [nvarchar](100) NULL,
	[PreDiplomaCity] [nvarchar](100) NULL,
	[PreDiplomaSection] [nvarchar](100) NULL,
	[EducationalSystem] [nvarchar](50) NULL,
	[DiscountId] [int] NULL,
 CONSTRAINT [PK_Request] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [useraccess].[AppMenuUserAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [useraccess].[AppMenuUserAccess](
	[AppMenuId] [int] IDENTITY(1,1) NOT NULL,
	[MenuPermissionId] [int] NULL,
	[UserId] [int] NULL,
	[Enable] [bit] NULL,
 CONSTRAINT [PK_AppMenuUserAccess] PRIMARY KEY CLUSTERED 
(
	[AppMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [useraccess].[MenuApps]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [useraccess].[MenuApps](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[MenuName] [nvarchar](100) NULL,
	[MenuLink] [varchar](300) NULL,
	[SectionId] [int] NULL,
	[MenuType] [int] NULL,
	[ImageURL] [varchar](100) NULL,
	[ParentId] [int] NULL,
	[MenuControlName] [varchar](50) NULL,
 CONSTRAINT [PK_MenuApps] PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [useraccess].[Section]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [useraccess].[Section](
	[SectionId] [int] NOT NULL,
	[SectoinName] [nvarchar](50) NULL,
	[DaneshId] [int] NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[SectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [useraccess].[UserFiledAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [useraccess].[UserFiledAccess](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FiledId] [int] NULL,
	[UserId] [int] NULL,
	[Enable] [bit] NULL,
 CONSTRAINT [PK_useraccess.UserFiledAccess] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[requestfield]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[requestfield]
AS
SELECT DISTINCT dbo.fnewStudent.idd_meli, dbo.fnewStudent.name, dbo.fnewStudent.family, dbo.Field.Field_Name AS OldResh, Field_1.Field_Name AS NewResh, dbo.fnewStudent.mobile, dbo.fnewStudent.email
FROM            dbo.RequestChangeField INNER JOIN
                         dbo.fnewStudent ON dbo.RequestChangeField.iddMeli = dbo.fnewStudent.idd_meli INNER JOIN
                         dbo.Field ON dbo.RequestChangeField.OldField = dbo.Field.Field_ID INNER JOIN
                         dbo.Field AS Field_1 ON dbo.Field.Field_ID = Field_1.Field_ID
GO
/****** Object:  View [International].[v_Amozesh_Fresh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP VIEW International.v_Amozesh_Fresh
CREATE VIEW [International].[v_Amozesh_Fresh]
AS
--SELECT  ROW_NUMBER()OVER(ORDER BY ff.SidaFieldId) AS Id , ff.* 
--FROM (
	SELECT  DISTINCT
		f.id AS SidaFieldId
		,(CASE  WHEN ISNULL(g.namegeraesh,'')<>'' THEN f.nameresh+' ( '+g.namegeraesh +' ) ' ELSE f.nameresh END )  AS SidaFieldName  
		,f.codesazman AS CodeSazman 
	FROM amozesh..fresh f 
	LEFT JOIN amozesh..fgeraesh g ON f.id=g.idresh
	WHERE ISNULL(f.codesazman ,'')<>'' AND LTRIM(RTRIM(f.codesazman))>0
--)AS ff
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_stcodeTemp]  DEFAULT ((0)) FOR [stcodeTemp]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_idresh]  DEFAULT ((0)) FOR [idresh]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_Province]  DEFAULT ((1)) FOR [Province]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_City]  DEFAULT ((1)) FOR [City]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_enteghal]  DEFAULT ((0)) FOR [enteghal]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_idgeraesh]  DEFAULT ((0)) FOR [idgeraesh]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_nobat]  DEFAULT ((0)) FOR [nobat]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_date_sabtenam]  DEFAULT ((0)) FOR [date_sabtenam]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_mahal_tav]  DEFAULT ((0)) FOR [mahal_tav]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_mahal_sodor]  DEFAULT ((0)) FOR [mahal_sodor]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_tahol]  DEFAULT ((0)) FOR [tahol]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_end_madrak]  DEFAULT ((0)) FOR [end_madrak]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_din]  DEFAULT ((0)) FOR [din]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_resh_endmadrak]  DEFAULT ((0)) FOR [resh_endmadrak]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_date_endmadrak]  DEFAULT ((0)) FOR [date_endmadrak]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_avrg_payeh]  DEFAULT ((0)) FOR [avrg_payeh]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_dip_avrg]  DEFAULT ((0)) FOR [dip_avrg]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_sahmeh]  DEFAULT ((0)) FOR [sahmeh]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_university]  DEFAULT ((0)) FOR [university]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_bomi]  DEFAULT ((0)) FOR [bomi]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_jesm]  DEFAULT ((0)) FOR [jesm]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_meliat]  DEFAULT ((0)) FOR [meliat]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_sal_vorod]  DEFAULT ((0)) FOR [sal_vorod]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_janbazi_darsad]  DEFAULT ((0)) FOR [janbazi_darsad]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_janbazi_nesbat]  DEFAULT ((0)) FOR [janbazi_nesbat]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_janbaz_parvandeh]  DEFAULT ((0)) FOR [azadeh_modat]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_nezamvazife]  DEFAULT ((0)) FOR [nezamvazife]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_mahal_khedmat]  DEFAULT ((0)) FOR [mahal_khedmat]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_ersal_name]  DEFAULT ((0)) FOR [ersal_name]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_ozv_basij]  DEFAULT ((0)) FOR [ozv_basij]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_ozv_lib]  DEFAULT ((0)) FOR [ozv_lib]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_IsInstallment]  DEFAULT ((0)) FOR [IsInstallment]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_permitted]  DEFAULT ((0)) FOR [permitted]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_Madrak_Status]  DEFAULT ((0)) FOR [Madrak_Status]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF__fnewStude__State__63E3BB6D]  DEFAULT ((0)) FOR [StateWelfare]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  DEFAULT ((0)) FOR [SimultaneousStudy]
GO
ALTER TABLE [dbo].[fnewStudent] ADD  CONSTRAINT [DF_fnewStudent_InsertedIntoAmoozeshyar]  DEFAULT ((0)) FOR [InsertedIntoAmoozeshyar]
GO
ALTER TABLE [dbo].[GuestCollege] ADD  CONSTRAINT [DF_GuestCollege_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[GuestStudentsInfo] ADD  CONSTRAINT [DF_GuestStudentsInfo_Gender]  DEFAULT ((0)) FOR [Gender]
GO
ALTER TABLE [dbo].[GuestStudentsInfo] ADD  CONSTRAINT [DF_GuestStudentsInfo_CollegeId]  DEFAULT ((1)) FOR [CollegeId]
GO
ALTER TABLE [dbo].[Payment] ADD  CONSTRAINT [DF_Payment_BankID]  DEFAULT ((2)) FOR [BankID]
GO
ALTER TABLE [dbo].[RequestChangeField] ADD  CONSTRAINT [DF_RequestChangeField_IsRead]  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Setting] ADD  CONSTRAINT [DF_Setting_UnitLetterDate]  DEFAULT ('-') FOR [UnitLetterDate]
GO
ALTER TABLE [dbo].[St_documents] ADD  CONSTRAINT [DF_St_documents_Isok]  DEFAULT ((1)) FOR [Isok]
GO
ALTER TABLE [dbo].[UserLogin] ADD  CONSTRAINT [DF_UserLogin_Enable]  DEFAULT ((1)) FOR [Enable]
GO
ALTER TABLE [dbo].[UserLogin] ADD  CONSTRAINT [DF_UserLogin_ShowAccessTomenu]  DEFAULT ((0)) FOR [ShowAccessTomenu]
GO
ALTER TABLE [International].[Account] ADD  CONSTRAINT [DF_Address_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [International].[CandidateField] ADD  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [International].[FieldForForeigns] ADD  CONSTRAINT [DF_FieldForForeigns_FieldLevel]  DEFAULT ((4)) FOR [FieldLevel]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_stcodeTemp]  DEFAULT ((0)) FOR [stcodeTemp]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_idresh]  DEFAULT ((0)) FOR [idresh]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_Province]  DEFAULT ((1)) FOR [Province]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_City]  DEFAULT ((1)) FOR [City]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_enteghal]  DEFAULT ((0)) FOR [enteghal]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_idgeraesh]  DEFAULT ((0)) FOR [idgeraesh]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_nobat]  DEFAULT ((0)) FOR [nobat]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_date_sabtenam]  DEFAULT ((0)) FOR [date_sabtenam]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_mahal_tav]  DEFAULT ((0)) FOR [mahal_tav]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_mahal_sodor]  DEFAULT ((0)) FOR [mahal_sodor]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_tahol]  DEFAULT ((0)) FOR [tahol]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_end_madrak]  DEFAULT ((0)) FOR [end_madrak]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_din]  DEFAULT ((0)) FOR [din]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_resh_endmadrak]  DEFAULT ((0)) FOR [resh_endmadrak]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_date_endmadrak]  DEFAULT ((0)) FOR [date_endmadrak]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_avrg_payeh]  DEFAULT ((0)) FOR [avrg_payeh]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_dip_avrg]  DEFAULT ((0)) FOR [dip_avrg]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_sahmeh]  DEFAULT ((0)) FOR [sahmeh]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_university]  DEFAULT ((0)) FOR [university]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_bomi]  DEFAULT ((0)) FOR [bomi]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_jesm]  DEFAULT ((0)) FOR [jesm]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_meliat]  DEFAULT ((0)) FOR [meliat]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_sal_vorod]  DEFAULT ((0)) FOR [sal_vorod]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_janbazi_darsad]  DEFAULT ((0)) FOR [janbazi_darsad]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_janbazi_nesbat]  DEFAULT ((0)) FOR [janbazi_nesbat]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_janbaz_parvandeh]  DEFAULT ((0)) FOR [azadeh_modat]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_nezamvazife]  DEFAULT ((0)) FOR [nezamvazife]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_mahal_khedmat]  DEFAULT ((0)) FOR [mahal_khedmat]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_ersal_name]  DEFAULT ((0)) FOR [ersal_name]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_ozv_basij]  DEFAULT ((0)) FOR [ozv_basij]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_ozv_lib]  DEFAULT ((0)) FOR [ozv_lib]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_IsInstallment]  DEFAULT ((0)) FOR [IsInstallment]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_permitted]  DEFAULT ((0)) FOR [permitted]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF_NewStudent_Madrak_Status]  DEFAULT ((0)) FOR [Madrak_Status]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF__NewStude__State__63E3BB6D]  DEFAULT ((0)) FOR [StateWelfare]
GO
ALTER TABLE [International].[NewStudent] ADD  CONSTRAINT [DF__NewStude__Simul__41AE9EFA]  DEFAULT ((0)) FOR [SimultaneousStudy]
GO
ALTER TABLE [International].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Student] FOREIGN KEY([StudentId])
REFERENCES [International].[Student] ([Id])
GO
ALTER TABLE [International].[Account] CHECK CONSTRAINT [FK_Account_Student]
GO
ALTER TABLE [International].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Person] FOREIGN KEY([PersonId])
REFERENCES [International].[Person] ([Id])
GO
ALTER TABLE [International].[Address] CHECK CONSTRAINT [FK_Address_Person]
GO
ALTER TABLE [International].[CandidateField]  WITH CHECK ADD  CONSTRAINT [FK_CandidateField_FieldForForeigns] FOREIGN KEY([FieldId])
REFERENCES [International].[FieldForForeigns] ([Id])
GO
ALTER TABLE [International].[CandidateField] CHECK CONSTRAINT [FK_CandidateField_FieldForForeigns]
GO
ALTER TABLE [International].[CandidateField]  WITH CHECK ADD  CONSTRAINT [FK_CandidateField_Student] FOREIGN KEY([StudentId])
REFERENCES [International].[Student] ([Id])
GO
ALTER TABLE [International].[CandidateField] CHECK CONSTRAINT [FK_CandidateField_Student]
GO
ALTER TABLE [International].[CitizenShip]  WITH CHECK ADD  CONSTRAINT [FK_International.CitizenShip_International.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [International].[Country] ([Id])
GO
ALTER TABLE [International].[CitizenShip] CHECK CONSTRAINT [FK_International.CitizenShip_International.Country_CountryId]
GO
ALTER TABLE [International].[EducationDegree]  WITH CHECK ADD  CONSTRAINT [FK_EducationDegree_Student] FOREIGN KEY([SudentId])
REFERENCES [International].[Student] ([Id])
GO
ALTER TABLE [International].[EducationDegree] CHECK CONSTRAINT [FK_EducationDegree_Student]
GO
ALTER TABLE [International].[FieldForForeigns]  WITH CHECK ADD  CONSTRAINT [FK_FieldForForeigns_Colleges] FOREIGN KEY([CollegeId])
REFERENCES [International].[Colleges] ([Id])
GO
ALTER TABLE [International].[FieldForForeigns] CHECK CONSTRAINT [FK_FieldForForeigns_Colleges]
GO
ALTER TABLE [International].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_Student] FOREIGN KEY([StudentId])
REFERENCES [International].[Student] ([Id])
GO
ALTER TABLE [International].[Request] CHECK CONSTRAINT [FK_Request_Student]
GO
ALTER TABLE [International].[Student]  WITH CHECK ADD  CONSTRAINT [FK_International.Student_International.Person_PersonId] FOREIGN KEY([PersonId])
REFERENCES [International].[Person] ([Id])
GO
ALTER TABLE [International].[Student] CHECK CONSTRAINT [FK_International.Student_International.Person_PersonId]
GO
ALTER TABLE [International].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Person] FOREIGN KEY([PersonId])
REFERENCES [International].[Person] ([Id])
GO
ALTER TABLE [International].[Student] CHECK CONSTRAINT [FK_Student_Person]
GO
ALTER TABLE [International].[StudentDocs]  WITH CHECK ADD  CONSTRAINT [FK_StudentDocs_Student] FOREIGN KEY([SudentId])
REFERENCES [International].[Student] ([Id])
GO
ALTER TABLE [International].[StudentDocs] CHECK CONSTRAINT [FK_StudentDocs_Student]
GO
ALTER TABLE [International].[StudentDocs]  WITH CHECK ADD  CONSTRAINT [FK_StudentDocs_StudentDocType] FOREIGN KEY([Category])
REFERENCES [International].[StudentDocType] ([Id])
GO
ALTER TABLE [International].[StudentDocs] CHECK CONSTRAINT [FK_StudentDocs_StudentDocType]
GO
ALTER TABLE [International].[User_Role]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([RoleId])
REFERENCES [International].[Role] ([Id])
GO
ALTER TABLE [International].[User_Role] CHECK CONSTRAINT [FK_UserRole_Role]
GO
ALTER TABLE [International].[User_Role]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User] FOREIGN KEY([UserId])
REFERENCES [International].[User] ([Id])
GO
ALTER TABLE [International].[User_Role] CHECK CONSTRAINT [FK_UserRole_User]
GO
ALTER TABLE [International].[UserLog]  WITH CHECK ADD  CONSTRAINT [FK_International.UserLog_International.UserLogType_UserLogTypeId] FOREIGN KEY([UserLogTypeId])
REFERENCES [International].[UserLogType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [International].[UserLog] CHECK CONSTRAINT [FK_International.UserLog_International.UserLogType_UserLogTypeId]
GO
/****** Object:  StoredProcedure [dbo].[Change_Doc_Status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Change_Doc_Status]
@id int,
@Status int,
@Note text
as
begin
update St_documents 
set
Isok=@Status,Note=@Note,Doc_Term=(select termjary from amozesh.dbo.fcounter)
where id=@id
end
GO
/****** Object:  StoredProcedure [dbo].[confirmedsahm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[confirmedsahm]
as
begin
select distinct St_documents.st_code,fnewStudent.name,fnewStudent.family,fnewStudent.idd_meli, 'true' as boolcondition from st_documents
inner join fnewStudent on fnewStudent.stcode=st_documents.st_code
where fnewStudent.status=7 and st_documents.category=10 and st_documents.isok=3
and St_documents.st_code not in(select stcode from amozesh.dbo.mojaz_sabtenam 
where tterm=(select termjary from amozesh.dbo.fcounter))
end
GO
/****** Object:  StoredProcedure [dbo].[Get_All_StudentsByCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Get_All_StudentsByCategory]
@FromCategory int,
@ToCategory int,
@FromStatus int,
@ToStatus int
AS
BEGIN
if(@FromStatus<=6)
begin
declare @WhereClause varchar(max) = '';
if(@FromCategory=8) --nezam
set @WhereClause=' AND (St_documents.Isok = 1 or St_documents.Isok=4)'
if(@FromCategory=10) --sahmiye
set @WhereClause=' AND ((st_code in(select st_code from St_documents where category=10 and Isok>2) 
and st_code in(select st_code from St_documents where(category=7 and Isok=1))) or (St_documents.Isok = 1 AND fnewStudent.sex=2) or (St_documents.Isok = 1 AND fnewStudent.sex=1 AND st_code in(select st_code from St_documents where (St_documents.category >= 8) AND (St_documents.category <= 9) AND (St_documents.Isok not in(1,2,3,4)))))'
if(@FromCategory=1)--pers img
set @WhereClause=' AND ((St_documents.Isok = 1 AND fnewStudent.sex=2) or (St_documents.Isok = 1 AND fnewStudent.sex=1 AND st_code in(select st_code from St_documents where (St_documents.category >= 8) AND (St_documents.category <= 9) AND (St_documents.Isok not in(1,2,3,4))))) AND ((Isok=1 and sahmeh=0)or(Isok=1 and sahmeh>0 and st_code in(select st_code from St_documents where category=10 and Isok=5) 
and st_code in(select st_code from St_documents where(category=7 and Isok=5)))) AND ((Isok = 1 AND StateWelfare = 0) OR (Isok = 1 AND StateWelfare > 0 AND st_code in (SELECT st_code FROM St_documents WHERE category = 20 AND Isok = 5)))'-- or (St_documents.Isok = 5 AND fnewStudent.status=6 and category=1)
if(@FromCategory=12)--edu
set @WhereClause=' AND St_documents.Isok=4'
if(@FromCategory=20)
set @WhereClause=' AND St_documents.Isok=1'

declare @Query varchar(max);
set @Query=' SELECT DISTINCT fnewStudent.stcode, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli, Field.Field_Name,Payment.tterm as term,fnewStudent.vorodi,St_documents.Isok,St_documents.id,DocStatus,fnewStudent.term as stterm, CASE fnewStudent.magh WHEN 2 THEN ''کارشناسی'' WHEN 3 THEN ''کارشناسی ارشد'' WHEN 6 THEN ''دکتری'' END as LevelName, fnewStudent.AcceptationDescription
 '+' FROM            fnewStudent LEFT JOIN Payment ON fnewStudent.stcode = Payment.StudentCode and Payment.AppStatus = ''COMMIT'' LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code Left join St_Doc_Status
 ON St_Doc_Status.id=St_documents.isok
 '+' WHERE        (St_documents.category >='+ CONVERT(varchar(3), @FromCategory)+') AND (St_documents.category <= '+CONVERT(varchar(3),@ToCategory)+')  AND (status='+CONVERT(varchar(3),@FromStatus)+' OR status='+CONVERT(varchar(3),@ToStatus)+')'+@WhereClause
execute(@query)
end

if(@FromStatus=9)
begin
	if(@FromCategory=8)--نظام وظیفه
	begin
		SELECT DISTINCT fnewStudent.stcode, fnewStudent.name, fnewStudent.family,fnewStudent.nezamvazife,fcoding.namecoding as nezamstatus, fnewStudent.idd_meli, Field.Field_Name,Payment.tterm as term,fnewStudent.vorodi,St_documents.Isok,St_documents.id,fnewStudent.term as stterm, CASE fnewStudent.magh WHEN 2 THEN 'کارشناسی' WHEN 3 THEN 'کارشناسی ارشد' WHEN 6 THEN 'دکتری' END as LevelName, fnewStudent.AcceptationDescription
		 FROM            fnewStudent LEFT JOIN Payment ON fnewStudent.stcode = Payment.StudentCode and Payment.AppStatus = 'COMMIT' LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code left join amozesh.dbo.fcoding
		 ON              amozesh.dbo.fcoding.id=fnewStudent.nezamvazife
		WHERE       amozesh.dbo.fcoding.idtypecoding=7 and (St_documents.category >= CONVERT(varchar(3), @FromCategory)) AND (St_documents.category <= CONVERT(varchar(3),@ToCategory))  AND (status=CONVERT(varchar(3),@FromStatus) OR status=CONVERT(varchar(3),@ToStatus)) and (Isok!=3 and Isok!=2) 
	end
	else
	begin
		if(@FromCategory=1 or @FromCategory=10 or @FromCategory=12 or @FromCategory=20)--عکس، سهمیه، مدرک تحصیلی
		begin
			SELECT DISTINCT fnewStudent.stcode, fnewStudent.name, fnewStudent.family,fnewStudent.nezamvazife, fnewStudent.idd_meli, Field.Field_Name,Payment.tterm as term,fnewStudent.vorodi,St_documents.Isok,St_documents.id,fnewStudent.term as stterm, CASE fnewStudent.magh WHEN 2 THEN 'کارشناسی' WHEN 3 THEN 'کارشناسی ارشد' WHEN 6 THEN 'دکتری' END as LevelName, fnewStudent.AcceptationDescription
			FROM            fnewStudent LEFT JOIN Payment ON fnewStudent.stcode = Payment.StudentCode and Payment.AppStatus = 'COMMIT' LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code 
			WHERE			(St_documents.category >= CONVERT(varchar(3), @FromCategory)) AND (St_documents.category <= CONVERT(varchar(3),@ToCategory))  AND (status=CONVERT(varchar(3),@FromStatus) OR status=CONVERT(varchar(3),@ToStatus)) AND Isok NOT IN (2,3)
		end
		else
		begin
			if(@FromCategory=7)
			begin
				SELECT DISTINCT fnewStudent.stcode, fnewStudent.name, fnewStudent.family,fnewStudent.nezamvazife, fnewStudent.idd_meli, Field.Field_Name,Payment.tterm as term,fnewStudent.vorodi,St_documents.Isok,fnewStudent.term as stterm, CASE fnewStudent.magh WHEN 2 THEN 'کارشناسی' WHEN 3 THEN 'کارشناسی ارشد' WHEN 6 THEN 'دکتری' END as LevelName, fnewStudent.AcceptationDescription
				FROM            fnewStudent LEFT JOIN Payment ON fnewStudent.stcode = Payment.StudentCode and Payment.AppStatus = 'COMMIT' LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code 
				WHERE			(St_documents.category = CONVERT(varchar(3), @FromCategory) OR St_documents.category = CONVERT(varchar(3),@ToCategory)) AND (status=CONVERT(varchar(3),@FromStatus) OR status=CONVERT(varchar(3),@ToStatus)) AND Isok NOT IN (2,3)
			end
			else
			begin
				SELECT DISTINCT fnewStudent.stcode, fnewStudent.name, fnewStudent.family,fnewStudent.nezamvazife, fnewStudent.idd_meli, Field.Field_Name,Payment.tterm as term,fnewStudent.vorodi,St_documents.Isok,St_documents.id,fnewStudent.term as stterm, CASE fnewStudent.magh WHEN 2 THEN 'کارشناسی' WHEN 3 THEN 'کارشناسی ارشد' WHEN 6 THEN 'دکتری' END as LevelName, fnewStudent.AcceptationDescription
				FROM            fnewStudent LEFT JOIN Payment ON fnewStudent.stcode = Payment.StudentCode and Payment.AppStatus = 'COMMIT' LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code 
				WHERE			(St_documents.category >= CONVERT(varchar(3), @FromCategory)) AND (St_documents.category <= CONVERT(varchar(3),@ToCategory))  AND (status=CONVERT(varchar(3),@FromStatus) OR status=CONVERT(varchar(3),@ToStatus)) AND Isok NOT IN (2,3)
			end
		end
	end
end
end
GO
/****** Object:  StoredProcedure [dbo].[Get_All_StudentsByCategoryGroup]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Get_All_StudentsByCategoryGroup]
@UserId int,
@FromCategory int,
@ToCategory int,
@FromStatus int,
@ToStatus int,
@FieldId int
AS
BEGIN
declare @isok varchar(70);
if(@FromStatus<=6)
begin
SELECT DISTINCT fnewStudent.stcode,St_Doc_Status.DocStatus as DocStatus ,St_documents.Isok as isok, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli, Field.Field_Name as Field_Name, fnewStudent.email
, Field_1.namecoding as resh,EduLevel.name as maghname,substring(CONVERT(varchar(3), term),1,2) as term,vorodi,term as stterm
FROM            fnewStudent 
				LEFT OUTER JOIN Field ON fnewStudent.idreshSazman = Field.Field_ID 
				LEFT OUTER JOIN amozesh.dbo.fcoding AS Field_1 ON fnewStudent.resh_endmadrak = Field_1.id 
				LEFT OUTER JOIN St_documents ON fnewStudent.stcode = St_documents.st_code 
				LEFT join EduLevel ON EduLevel.Id_sazman=fnewStudent.magh
				left join St_Doc_Status on St_Doc_Status.id=St_documents.Isok

WHERE        (St_documents.category >= @FromCategory) AND (St_documents.category <= @ToCategory) AND (St_documents.Isok = 1) AND 
                         (fnewStudent.status = @FromStatus OR
                         fnewStudent.status = @ToStatus) and fnewStudent.idreshSazman=@FieldId and stcode in(select studentcode from Payment where AppStatus='COMMIT' and (PayType=1 or PayType=3) 
						 --and  tterm=(select termjary from amozesh.dbo.fcounter)
						 )
						 and Field_1.idtypecoding=4 
order by term asc
end
if(@FromStatus=9 AND @FromCategory<>2)
begin

SELECT DISTINCT fnewStudent.stcode,St_Doc_Status.DocStatus as DocStatus,St_documents.Isok as isok, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli, Field.Field_Name as Field_Name, fnewStudent.email, Field_1.namecoding as resh
,EduLevel.name as maghname,substring(CONVERT(varchar(3), term),1,2) as term,vorodi,fnewStudent.term as stterm
FROM            fnewStudent LEFT OUTER JOIN
                         Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN
                         amozesh.dbo.fcoding AS Field_1 ON fnewStudent.resh_endmadrak = Field_1.id LEFT OUTER JOIN
                         St_documents ON fnewStudent.stcode = St_documents.st_code left join EduLevel
						 on EduLevel.Id_sazman=fnewStudent.magh
						  left join St_Doc_Status on St_Doc_Status.id=St_documents.Isok
WHERE        (St_documents.category >= @FromCategory) AND (St_documents.category <= @ToCategory) AND (St_documents.Isok = 5 or St_documents.Isok = 4 or Isok=1) AND 
                         (fnewStudent.status = @FromStatus OR
                         fnewStudent.status = @ToStatus) and fnewStudent.idreshSazman=@FieldId
						 and Field_1.idtypecoding=4 
order by term asc
end
if(@FromCategory=2)
begin
SELECT DISTINCT fnewStudent.stcode,St_Doc_Status.DocStatus as DocStatus ,St_documents.Isok as isok, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli, Field.Field_Name as Field_Name, fnewStudent.email
, Field_1.namecoding as resh,EduLevel.name as maghname,substring(CONVERT(varchar(3), term),1,2) as term,vorodi,term as stterm
FROM            fnewStudent LEFT OUTER JOIN
                         Field ON fnewStudent.idreshSazman = Field.Field_ID LEFT OUTER JOIN
                         amozesh.dbo.fcoding AS Field_1 ON fnewStudent.resh_endmadrak = Field_1.id LEFT OUTER JOIN
                         St_documents ON fnewStudent.stcode = St_documents.st_code left join EduLevel
						 on EduLevel.Id_sazman=fnewStudent.magh
						 left join St_Doc_Status on St_Doc_Status.id=St_documents.Isok
WHERE        (St_documents.category >= @FromCategory) AND (St_documents.category <= @ToCategory) AND (St_documents.Isok = 1) AND 
                         (fnewStudent.status = @FromStatus OR
                         fnewStudent.status = @ToStatus) and fnewStudent.idreshSazman=@FieldId 
						 and Field_1.idtypecoding=4 
order by term asc
end
end
GO
/****** Object:  StoredProcedure [dbo].[GET_ALLStudent_By_stcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GET_ALLStudent_By_stcode]
@stcode varchar(11)
,@idd_meli varchar(20)
as
begin
if(@idd_meli='0')
SELECT  fnewStudent.stcode, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli,address,filename,Isok,Note,docName,status
,Field.Field_Name as nameresh,fnewStudent.idresh,(amozesh.dbo.magh(dbo.magh2(fnewStudent.magh)))as magh,fnewStudent.email
FROM            St_documents LEFT OUTER JOIN
                         fnewStudent ON fnewStudent.stcode = St_documents.st_code LEFT OUTER JOIN
						
						Field on Field.Field_ID=fnewStudent.idreshSazman  left outer join
						st_Documents_category ON st_Documents_category.id=St_documents.category 
						
WHERE      ( stcode=@stcode)
if(@idd_meli<>'0')
SELECT  fnewStudent.stcode, fnewStudent.name, fnewStudent.family, fnewStudent.idd_meli,address,filename,Isok,Note,docName,status
,Field.Field_Name as nameresh,fnewStudent.idresh,(amozesh.dbo.magh(dbo.magh2(fnewStudent.magh)))as magh,fnewStudent.email
FROM            St_documents LEFT OUTER JOIN
                         fnewStudent ON fnewStudent.stcode = St_documents.st_code
						 LEFT OUTER JOIN	Field on Field.Field_ID=fnewStudent.idreshSazman
						  LEFT OUTER JOIN st_Documents_category ON st_Documents_category.id=St_documents.category
WHERE      ( idd_meli=@idd_meli)
end
GO
/****** Object:  StoredProcedure [dbo].[Get_DocStudent_NotIn_Amozpic]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_DocStudent_NotIn_Amozpic]
as
begin
select * from fnewStudent where status=7 and stcode not in(select stcode from amozpic.dbo.doc_image)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_AddNoExamEntranceRequest]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AddNoExamEntranceRequest]
	  @FirstName				nvarchar(200)
	, @LastName					nvarchar(200)
	, @FathersName				nvarchar(200)
	, @IdNo						nvarchar(200)
	, @NationalCode				nvarchar(200)
	, @Gender					tinyint
	, @BirthYear				tinyint
	, @FieldId					int
	, @Religion					tinyint
	, @Mobile					nvarchar(15)
	, @PhoneNo					nvarchar(50)
	, @PhoneNoPreCode			nvarchar(50)
	, @Email					nvarchar(200)
	, @Address					nvarchar(300)
	, @LastDegreeType			tinyint
	, @LastDegreeScore			float
	, @CreateDate				datetime
	,@entranceYear				int
	,@studyingLevel				int
	,@studyingField				int
	,@studyingPlace				int
	,@isStudentNow				bit
	,@studingUniType			int	
	,@Term						varchar(7)	
	
	,@birthDate					nvarchar(10)
	,@idSerial					int
	,@idSerie					int
	,@idLetter					nvarchar(5)
	,@nationality				nvarchar(20)
	,@militaryStatus			nvarchar(100)
	,@quotaStatus				nvarchar(100)
	,@physicalStatus			nvarchar(100)
	,@livingPlaceState			nvarchar(100)
	,@birthPlaceState			nvarchar(100)
	,@educationalGroup			nvarchar(100)

	,@postalCode				decimal(18, 0)
	,@diplomaTitle				nvarchar(100)
	,@diplomaDate				nvarchar(10)
	,@diplomaTotalAvg			decimal(18, 2)
	,@diplomaWrittenAvg			decimal(18, 2)
	,@diplomaRegionCode			decimal(18, 0)
	,@diplomaState				nvarchar(100)
	,@diplomaCity				nvarchar(100)
	,@diplomaSection			nvarchar(100)
	,@preuniversityTitle		nvarchar(100) = null
	,@preuniversityDate			nvarchar(10) = null
	,@preuniversityTotalAvg		decimal(18, 2) = null
	,@preuniversityRegionCode	decimal(18, 0) = null
	,@preuniversityState		nvarchar(100)
	,@preuniversityCity			nvarchar(100)
	,@preuniversitySection		nvarchar(100)
	,@preDiplomaState			nvarchar(100)
	,@preDiplomaCity			nvarchar(100)
	,@preDiplomaSection			nvarchar(100)
	,@educationalSystem			nvarchar(50)



AS
BEGIN
	INSERT INTO NoExamEntrance.Request
	(FirstName, LastName, FathersName, IdNo, NationalCode, Gender, BirthYear, FieldId, Religion, Mobile, PhoneNo, PhoneNoPreCode, Email, [Address], LastDegreeType, LastDegreeScore, CreateDate
	,[EntranceYear],[StudyingLevel],[StudyingField],[StudyingPlace],[IsStudentNow],StudingUniType,[Status], Term, BirthDate, IdSerial, IdSerie, IdLetter, Nationality, MilitaryStatus
	, QuotaStatus, PhysicalStatus, LivingPlaceState, BirthPlaceState, EducationalGroup, PostalCode, DiplomaTitle, DiplomaDate, DiplomaTotalAvg, DiplomaWrittenAvg, DiplomaRegionCode
	, DiplomaState, DiplomaCity, DiplomaSection, PreUniversityTitle, PreUniversityDate, PreUniversityTotalAvg, PreUniversityRegionCode, PreUniversityState, PreUniversityCity, PreUniversitySection
	, PreDiplomaState, PreDiplomaCity, PreDiplomaSection, EducationalSystem)
	VALUES (@FirstName, @LastName, @FathersName, @IdNo, @NationalCode, @Gender, @BirthYear, @FieldId, @Religion, @Mobile, @PhoneNo, @PhoneNoPreCode, @Email, @Address, @LastDegreeType, @LastDegreeScore, @CreateDate
	,@entranceYear,@studyingLevel,@studyingField,@studyingPlace,@isStudentNow,@studingUniType,1, @Term, @birthDate, @idSerial, @idSerie, @idLetter, @nationality, @militaryStatus
	, @quotaStatus, @physicalStatus, @livingPlaceState, @birthPlaceState, @educationalGroup, @postalCode, @diplomaTitle, @diplomaDate, @diplomaTotalAvg, @diplomaWrittenAvg, @diplomaRegionCode
	, @diplomaState, @diplomaCity, @diplomaSection, @preuniversityTitle, @preuniversityDate, @preuniversityTotalAvg, @preuniversityRegionCode, @preuniversityState, @preuniversityCity
	, @preuniversitySection, @preDiplomaState, @preDiplomaCity, @preDiplomaSection, @educationalSystem)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddOrUpdateGuestCourse]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AddOrUpdateGuestCourse]
	@GuestCourseId	int = 0
	,@did			int
	,@Capacity		int
	,@Term			varchar(7)
	,@Active		bit
AS
BEGIN
	IF (@GuestCourseId > 0)
	BEGIN
		UPDATE GuestCourse
		SET did = @did, Capacity = @Capacity, Term = @Term, Active = @Active
		WHERE GuestCourseId = @GuestCourseId
	END
	ELSE
	BEGIN
		INSERT INTO GuestCourse (did, Capacity, Term, Active)
		VALUES (@did, @Capacity, @Term, @Active)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddOrUpdateGuestStudentInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AddOrUpdateGuestStudentInfo]
	@ID						int = 0,
	@stcode					nvarchar(9),
	@FirstName				nvarchar(50),
	@LastName				nvarchar(50),
	@FatherName				nvarchar(50),
	@IdNo					decimal(18, 0),
	@NationalCode			nchar(10),
	@BirthDate				nvarchar(50),
	@IssuePlace				int,
	@Email					varchar(100),
	@Mobile					nvarchar(50),
	@UniversityId			int,
	@ExamPlaceId			int,
	@FieldId				int,
	@LevelId				int,
	@RequestRegisterDate	datetime,
	@RequestStatus			tinyint,
	@RequestTerm			varchar(7),
	@Gender					tinyint,
	@Note					nvarchar(MAX),
	@Year					varchar(2),
	@CollegeId				int

AS
BEGIN
	IF (NOT EXISTS(SELECT ID FROM GuestStudentsInfo WHERE stcode = @stcode AND RequestTerm = @RequestTerm))
	BEGIN
		INSERT INTO GuestStudentsInfo (FirstName, LastName, FatherName, stcode, IdNo, NationalCode, BirthDate, IssuePlace, Email, Mobile, UniversityId, ExamPlaceId, FieldId, LevelId
		, RequestRegisterDate, RequestStatus, RequestTerm, Gender, Note, EntranceYear, CollegeId)
		VALUES (@FirstName, @LastName, @FatherName, @stcode, @IdNo, @NationalCode, @BirthDate, @IssuePlace, @Email, @Mobile, @UniversityId, @ExamPlaceId, @FieldId, @LevelId
		, @RequestRegisterDate, @RequestStatus, @RequestTerm, @Gender, @Note, @Year, @CollegeId)
		SELECT @@IDENTITY AS [@@IDENTITY]
	END
	ELSE
	BEGIN
		UPDATE GuestStudentsInfo
		SET FirstName = @FirstName, LastName = @LastName, FatherName = @FatherName, stcode = @stcode, IdNo = @IdNo, NationalCode = @NationalCode, BirthDate = BirthDate
		, IssuePlace = @IssuePlace, Email = @Email, Mobile = @Mobile, UniversityId = @UniversityId, ExamPlaceId = @ExamPlaceId, FieldId = @FieldId, LevelId = @LevelId
		, RequestRegisterDate = @RequestRegisterDate, RequestStatus = @RequestStatus, RequestTerm = @RequestTerm, Gender = @Gender, Note = @Note, EntranceYear = @Year
		, CollegeId = @CollegeId
		WHERE  stcode = @stcode
		AND RequestTerm = @RequestTerm
		SELECT ID FROM GuestStudentsInfo WHERE stcode = @stcode AND RequestTerm = @RequestTerm
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddOrUpdateGuestStudentsDoc]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AddOrUpdateGuestStudentsDoc]
	@ID			int = 0,
	@stcode		varchar(9),
	@FileName	varchar(25),
	@Address	varchar(MAX),
	@CategoryId	int,
	@Term		varchar(7),
	@Status		int = 1
AS
BEGIN
	IF (@ID = 0 AND NOT EXISTS(SELECT * FROM GuestStudentsDocs WHERE stcode = @stcode AND DocTerm = @Term AND CategoryId = @CategoryId))
	BEGIN
		INSERT INTO GuestStudentsDocs ([stcode], [Filename], [Address], [CategoryId], [DocumentStatus], [DocTerm])
		VALUES (@stcode, @FileName, @Address, @CategoryId, @Status, @Term)
	END
	ELSE IF (EXISTS(SELECT * FROM GuestStudentsDocs WHERE stcode = @stcode AND DocTerm = @Term AND CategoryId = @CategoryId))
	BEGIN
		UPDATE GuestStudentsDocs
		SET [Filename] = @FileName, [Address] = @Address, [DocumentStatus] = @Status
		WHERE stcode = @stcode
		AND DocTerm = @Term
		AND CategoryId = @CategoryId
	END
	ELSE
	BEGIN
		UPDATE GuestStudentsDocs
		SET [Filename] = @FileName, [Address] = @Address, [DocumentStatus] = @Status
		WHERE ID = @ID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddOrUpdateNoExamOfflinePayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AddOrUpdateNoExamOfflinePayment]
	  @NationalCode	varchar(10)
	, @Amount		decimal(18,0)
	, @PaymentDate	datetime
AS
BEGIN
	IF(EXISTS(SELECT * FROM NoExamEntrance.OfflinePayments WHERE NationalCode = @NationalCode))
	BEGIN
		UPDATE NoExamEntrance.OfflinePayments SET Amount = @Amount, PaymentDate = @PaymentDate WHERE NationalCode = @NationalCode
	END
	ELSE
	BEGIN
		INSERT INTO NoExamEntrance.OfflinePayments (NationalCode, Amount, PaymentDate) VALUES (@NationalCode, @Amount, @PaymentDate)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddOrUpdateStudent_digit_parvandeh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROC [dbo].[Sp_InsertGuestStudentDocsToAmozpicDb]
--@id_scan int
--,@stcode nvarchar(15)
--,@doc_image image
--AS
--IF NOT EXISTS(SELECT * FROM amozpic.dbo.doc_image img WHERE img.stcode=@stcode AND img.id_scan=@id_scan)
--BEGIN
--	INSERT INTO amozpic.dbo.doc_image(id_scan, stcode,doc_image	 )
--	VALUES( @id_scan,@stcode,@doc_image  )
--END

--DROP PROC [dbo].[SP_Update_amozpic]
--DROP PROC [dbo].[Sp_AddOrUpdate_digit_parvandeh]

CREATE PROC [dbo].[Sp_AddOrUpdateStudent_digit_parvandeh]  
  @stcode numeric(18, 0)
, @docimage	IMAGE	
, @type_archive	numeric(18, 0)
, @sender	varchar(200)	
, @ip	varchar(20)	
, @computer_name	varchar(100)
--, @is_guest bit = 0

AS
BEGIN 
  	DECLARE @type_pic NVARCHAR(8)='jpg'
	DECLARE @form_sida NVARCHAR(8)='scan'
	
	DECLARE @date_send NVARCHAR(8)=( SELECT InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ))
	DECLARE @time_send NVARCHAR(10)= (SELECT FORMAT(GETDATE(),'hh:mm tt'))--(select CONVERT(varchar(15),CAST(getdate() AS TIME),100))
	
	DECLARE @for_stu NVARCHAR(8)=NULL
	DECLARE @date_seen NVARCHAR(8)=NULL
	DECLARE @time_seen NVARCHAR(8)=NULL
	
	IF NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive)
	BEGIN
		INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida , for_stu ,date_seen ,time_seen )
		VALUES( @stcode,@type_pic ,@docimage, @type_archive , @sender , @ip , @date_send , @time_send , @computer_name , @form_sida , @for_stu ,@date_seen ,@time_seen )
	END
   
    ELSE IF EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive)
	BEGIN
		UPDATE [digit_archive_sida4].[dbo].[digit_parvandeh]
		SET pic_=@docimage ,sender=@sender , ip=@ip ,date_send=@date_send , time_send=@time_send ,computer_name=@computer_name
		WHERE stcode=@stcode AND type_archive=@type_archive	
	END	
	
	--IF (@is_guest=0 )-- if student not be guest 
	--BEGIN
	--	IF EXISTS( SELECT * from amozesh.dbo.fnaghs_stu WHERE stcode=@stcode and idnaghs=8 )
	--	begin
	--		delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=8
	--		DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
	--		   AND id=(SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='1')
	--	end
	--END  
END

--SELECT TOP 1 * from amozpic.dbo.doc_image
--SELECT TOP 1 * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] 




GO
/****** Object:  StoredProcedure [dbo].[SP_AddStudentChild]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AddStudentChild]
	@stcode		varchar(9),
	@FirstName	nvarchar(50),
	@LastName	nvarchar(50),
	@BirthDate	date,
	@Gender		bit
AS
BEGIN
	INSERT INTO Children (stcode, BirthDate, FirstName, LastName, Gender) VALUES (@stcode, @BirthDate, @FirstName, @LastName, @Gender)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_changePaymentTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_changePaymentTerm]
@OrderID bigint
as
begin
UPDATE       Payment
SET                tterm =(select termjary from amozesh.dbo.fcounter)
WHERE        (OrderID = @OrderID)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_check_EnableDisableUser]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_check_EnableDisableUser]
@userId int
as
begin
select Enable from UserLogin
where UserId=@userId
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Check_ExistDocsByCategoryAndStCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani
-- alter date: <alter Date,,>
-- Description:	Check_ExistDocs
-- =============================================
CREATE PROCEDURE [dbo].[SP_Check_ExistDocsByCategoryAndStCode]
@stCode varchar(11)
,@Category int
AS
BEGIN
	Select * From St_documents WHERE category=@Category AND st_code=@stCode
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Check_Have_RequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Check_Have_RequestChangeField]
@iddmeli varchar(11)='0'
,@parNo varchar(10)='0' --='374709'
,@salAzmoon varchar(10)='0'
as
begin
select * from RequestChangeField  rcf
	WHERE rcf.ComposeOrReply=1  AND rcf.StatusRequest=1
	 AND(rcf.iddMeli=@iddMeli OR @iddMeli='0'  ) 
	AND					  
	(
		 ( rcf.SalAzmoon=@salAzmoon  OR @salAzmoon='0' ) AND
		 (rcf.CodeParvandeh=@parNo OR @parNo='0') 
	 )
		 
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Check_Idvazekol_RequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Check_Idvazekol_RequestChangeField]
@idd_meli varchar(11)
,@idreshsazman numeric(18,0)
as
begin 
select idvazkol from  amozesh.dbo.fsf
where stcode=@idd_meli and idresh=dbo.Ret_Idresh(@idreshsazman)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckDocStuas_ConvToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CheckDocStuas_ConvToSida]
@StCode varchar(11)
as
begin
select * from St_documents where st_code=@StCode and Isok<>3 and category<>11
end
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckDuplicateTraceNumber]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CheckDuplicateTraceNumber]
@TraceNumber bigint
as
BEGIN
	SELECT * 
	FROM Payment
	WHERE TraceNumber = @TraceNumber and AppStatus in ('TRANSFERRED', 'COMMIT')
end
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckOrderID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CheckOrderID]
@orderId bigint 
,@bankId int

AS
BEGIN
	declare @Id bigint

set @Id=(select OrderID from Payment where OrderID=@orderId)
	
	if @Id>0
	select @Id
	else
	select 0
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckStDocStatusByCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CheckStDocStatusByCategory]
	@stCode varchar(11),
	@Category int
AS
BEGIN
	Select * From St_documents Where st_code=@stCode AND category=@Category
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CheckStudentCancelledAndInDebt]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CheckStudentCancelledAndInDebt]
	@NationalCode  varchar(50)
AS
BEGIN
	SELECT * FROM amozesh.dbo.fsf f
	WHERE idvazkol IN (3,5,6)
	AND idd_meli = @NationalCode
	AND stcode NOT IN (
		SELECT stcode FROM Supplementary_test.Request.Tbl_StudentRequest
		WHERE RequestTypeID = 16
		AND f.stcode = StCode
		AND Erae_Be >= 18
	)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckStudentExpelledAndInDebt]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CheckStudentExpelledAndInDebt]
	@NationalCode  varchar(50)
AS
BEGIN
	SELECT * FROM amozesh.dbo.fsf f
	WHERE idvazkol IN (8,9,10,11)
	AND idd_meli = @NationalCode
	--AND stcode NOT IN (
	--	SELECT stcode FROM Supplementary_test.Request.Tbl_StudentRequest
	--	WHERE RequestTypeID = 14
	--	AND f.stcode = StCode
	--	AND Erae_Be < 17
	--)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckStudentGratuationDebt]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CheckStudentGratuationDebt]
	@StCode varchar(11)
AS
BEGIN
	SELECT * FROM Supplementary_test.Request.Tbl_StudentRequest
	WHERE RequestTypeID = 15 
	AND Erae_Be >= 24 
	AND StCode = @StCode
END

--exec [dbo].[SP_CheckStudentGratuationDebt] '930295663'
GO
/****** Object:  StoredProcedure [dbo].[SP_Control_UniAddress]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Control_UniAddress]
@Address varchar(MAX),
@TopTel varchar(80),
@BottomTel varchar(100),
@Fax varchar(50),
@Email varchar(300)
as
BEGIN
declare @Count int
-----------------------------------------
set @count=(select COUNT(id) from UniAddress)
-----------------------------------------
if @Count=0
begin
INSERT INTO UniAddress
                         (Address, TopTel, BottomTel, Fax, Email)
VALUES        (@Address,@TopTel,@BottomTel,@Fax,@Email)
end
------------------------------------------
if @Count=1
begin
if @Address<>''
update UniAddress
set 
Address=@Address
if @TopTel<>''
update UniAddress
set 
TopTel=@TopTel
if @BottomTel<>''
update UniAddress
set 
BottomTel=@BottomTel
if @Fax<>''
update UniAddress
set 
Fax=@Fax
if @Email<>''
update UniAddress
set 
Email=@Email
end
------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ConvertNoExamOfflinePayments]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ConvertNoExamOfflinePayments]
	  @NationalCode		varchar(10)
	, @Term				varchar(7)
	, @OrderId			bigint
AS
BEGIN

	DECLARE @stcode varchar(9) = (
		SELECT 
		s.stcode
		FROM NoExamEntrance.Request r
		JOIN NoExamEntrance.Payment p ON r.id=p.RequestId 
		JOIN dbo.fnewStudent s ON r.NationalCode=s.idd_meli AND s.idreshSazman=LEFT(r.FieldId, LEN(r.FieldId) - 2) AND s.magh=2
		WHERE r.NationalCode=@NationalCode AND p.AppStatus='TRANSFERRED'
	)


	INSERT INTO Payment (OrderID, Result, RetrivalRefNo, AmountTrans, RequestKey, AppStatus, StudentCode, tterm, BankID, MiladiDate, PersianDate, TraceNumber, PayType)
	SELECT @OrderId, 0, 1, Amount, 1, 'COMMIT', @stcode, @Term, 2, PaymentDate, dbo.MiladiTOShamsi(PaymentDate), '99999', 3 FROM NoExamEntrance.OfflinePayments WHERE NationalCode = @NationalCode

	DELETE FROM NoExamEntrance.OfflinePayments WHERE NationalCode = @NationalCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ConvertNoExamPayments]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ConvertNoExamPayments]
	  @paymentId	decimal(18,0)
	, @term			varchar(7)	
AS
BEGIN
	--DECLARE @stcode varchar(9) = (
	--SELECT stcode FROM NoExamEntrance.Request r, NoExamEntrance.Payment p, fnewStudent f
	--WHERE p.RequestId = r.id
	--AND p.AppStatus='COMMIT'
	--AND r.Status=2
	--AND f.idd_meli=r.NationalCode
	--AND f.idreshSazman = LEFT(r.FieldId, LEN(r.FieldId) - 2)
	--AND p.id=@paymentId
	--)
	DECLARE @stcode varchar(9) = (
		SELECT 
		s.stcode
		FROM NoExamEntrance.Request r
		JOIN NoExamEntrance.Payment p ON r.id=p.RequestId 
		JOIN dbo.fnewStudent s ON r.NationalCode=s.idd_meli AND s.idreshSazman=LEFT(r.FieldId, LEN(r.FieldId) - 2) AND s.magh=2
		WHERE p.id=@paymentId
	)

	INSERT INTO Payment(OrderID, Result, RetrivalRefNo, AmountTrans, RequestKey, AppStatus, StudentCode, tterm, BankID, MiladiDate, PersianDate, TraceNumber, PayType)
	--SELECT OrderId, Result, RetrivalRefNo, Amount, RequestKey, AppStatus, @stcode, @term, BankId, CreateDate, dbo.MiladiTOShamsi(CreateDate), TraceNumber, PayType 
	--FROM NoExamEntrance.Payment 
	SELECT t.OrderId, t.Result, t.RetrivalRefNo, t.Amount, t.RequestKey, t.AppStatus, t.stcode, t.term, t.BankId, t.CreateDate, t.PersianDate, t.TraceNumber, t.PayType 
	FROM (
		SELECT 		
		p.OrderId
		,p.Result
		,p.RetrivalRefNo
		,p.Amount
		,p.RequestKey
		,p.AppStatus
		,s.stcode
		,p.term
		,p.BankId
		,p.CreateDate
		,dbo.MiladiTOShamsi(p.CreateDate) AS 'PersianDate'		
		,p.TraceNumber
		,p.PayType
		FROM NoExamEntrance.Request r
		JOIN NoExamEntrance.Payment p ON r.id=p.RequestId
		JOIN dbo.fnewStudent s ON r.NationalCode=s.idd_meli AND s.idreshSazman=LEFT(r.FieldId, LEN(r.FieldId) - 2) AND s.magh=2 
		WHERE p.id=@paymentId 
	) AS t
	UPDATE NoExamEntrance.Payment SET AppStatus='TRANSFERRED' WHERE id = @paymentId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateNoExamEntrancePayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CreateNoExamEntrancePayment]
	  @requestId	decimal(18, 0)
	, @orderid		decimal(18, 0)
	, @result		decimal(18, 0)
	, @requestKey	nvarchar(50)
	, @amount		decimal(18, 0)
	, @term			nvarchar(7)
	, @traceNumber	bigint
	, @bankId		int
	, @CreateDate	datetime


AS
BEGIN
	INSERT INTO NoExamEntrance.Payment (requestId,orderid,result,requestKey,amount,term,traceNumber,bankId,CreateDate)
	VALUES (@requestId,@orderid,@result,@requestKey,@amount,@term,@traceNumber,@bankId,@CreateDate)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CreatePonyRequestForAboutGraduation]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CreatePonyRequestForAboutGraduation]
	@stcode  varchar(50)
AS
BEGIN
if not exists(select * from Supplementary.Request.Tbl_StudentRequest where StCode = @stcode and RequestTypeID = 15 and RequestLogID <> 5)
begin
	INSERT INTO Supplementary.Request.Tbl_StudentRequest (StCode, RequestTypeID,RequestLogID, Erae_Be, CreateDate, IsPrinted, Term, BayganiOk, MashmoolanOk, IsOnline, IsRead)
	VALUES (@stcode, 15, 10, 12, InitialRegistration.dbo.MiladiTOShamsi(GETDATE()),0, (select termjary from amozesh.dbo.fcounter), 0,0,1,0)
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CreatePonyRequestForExpelled]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CreatePonyRequestForExpelled]
	@NationalCode  varchar(50)
AS
BEGIN
	
	IF NOT EXISTS(
		SELECT * FROM amozesh.dbo.fsf f
		WHERE idvazkol IN (8,9,10,11)
		AND idd_meli = @NationalCode
		AND stcode NOT IN (
			SELECT stcode FROM Supplementary_test.Request.Tbl_StudentRequest
			WHERE RequestTypeID = 14
			AND f.stcode = StCode
			AND Erae_Be < 17
		)
	)
	BEGIN
		declare @stcode varchar(15)
		SELECT TOP 1 @stcode = stcode FROM amozesh.dbo.fsf f 
		WHERE idvazkol IN (8,9,10,11)
		AND idd_meli = @NationalCode
		ORDER BY sal_vorod desc, nimsal_vorod desc
		INSERT INTO Supplementary_test.Request.Tbl_StudentRequest (StCode, RequestTypeID,RequestLogID, Erae_Be, CreateDate, IsPrinted, Term, BayganiOk, MashmoolanOk, IsOnline, IsRead)
		VALUES (@stcode, 14, 10, 11, InitialRegistration.dbo.MiladiTOShamsi(GETDATE()),0, (select termjary from amozesh.dbo.fcounter), 0,0,1,0)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateStudentInstallment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CreateStudentInstallment]
	@national_code varchar(10)
AS
BEGIN
	Update fnewStudent set IsInstallment=1 where idd_meli=@national_code
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteAllStudentDocs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteAllStudentDocs]
	@StCode varchar(11)
AS
BEGIN
	DELETE FROM St_documents
	WHERE st_code = @StCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeletefromFnaghsStu]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_DeletefromFnaghsStu]
@stcode varchar(11),
@idnaghs int
as
begin
 delete from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@idnaghs
end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteFromStDoc]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_DeleteFromStDoc]
@category int,
@stcode varchar(11)
as
begin
delete from St_documents where st_code=@stcode and category=@category
end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteGuestCourse]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteGuestCourse]
	@GuestCourseId	int
AS
BEGIN
	DELETE FROM GuestCourse WHERE GuestCourseId = @GuestCourseId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteGuestStudentsDoc]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteGuestStudentsDoc]
	@Id		int
AS
BEGIN
	DELETE FROM GuestStudentsDocs WHERE ID = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteMadarekNotConfirmed]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_DeleteMadarekNotConfirmed]
@stcode varchar(11)
as
begin
delete from St_documents where st_code=@stcode and Isok!=3
end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteNoExamOfflinePayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteNoExamOfflinePayment]
	@NationalCode		varchar(10)
AS
BEGIN
	DELETE FROM NoExamEntrance.OfflinePayments WHERE NationalCode = @NationalCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeletePayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeletePayment]
	@OrderId bigint
AS
BEGIN
	DELETE FROM Payment WHERE OrderId = @OrderId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeletePicFnaghs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_DeletePicFnaghs]
@stcode varchar(11)
as
begin

 delete from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=8

delete from amozesh.dbo.web_msg_stu where stcode=@stcode and sharh like N'%عکس%'

if exists(select * from St_documents where st_code=@stcode and st_code not in(select st_code from St_documents where  Isok<>3 and category<>11 ))
begin
if not exists(select status from fnewStudent where stcode=@stcode and status=7)
begin

update fnewStudent
set status=7
where stcode=@stcode



end
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_EnableDisableUsers]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_EnableDisableUsers]
@UserId int,
@Enable bit
as
begin
update UserLogin
set Enable=@Enable
where UserId=@UserId
end
GO
/****** Object:  StoredProcedure [dbo].[SP_ExistField_Tuition]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ExistField_Tuition]
@FeildId int
,@term varchar(7)
as 
begin
SELECT        FeildId, Term, TuitionId
FROM            TuitionFee
where FeildId=@FeildId AND Term=@term
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_ALL_Control_By_AllFixField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_ALL_Control_By_AllFixField]
as
begin
SELECT        Service_Fee, Insurance_Fee, Entrance_Year, AllField_Fix, AllField_FixFee, Term, LevelId,name
FROM            Control left join EduLevel
ON EduLevel.Id_sazman=Control.LevelId
where AllField_Fix=1
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_All_Payment_ByPayId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_All_Payment_ByPayId]
@PayId tinyint
as
begin
Select * from payment where PayType=@PayId and AppStatus != 'TRANSFERRED'
order by PersianDate desc
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_All_StudentLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_All_StudentLog]
as
begin
Select * from StudentLog
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_All_Term]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_All_Term]
as
begin
select distinct term
,substring(CONVERT(varchar(3), term),1,2)
+'-'+Cast(convert(int,substring(CONVERT(varchar(3), term),1,2))+1 as varchar(3))
+'-'+Cast(substring(CONVERT(varchar(3), term),3,1) as varchar(3)) as tterm
 from fnewstudent
order by term desc
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_All_UsersInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_Get_All_UsersInfo]
@UserId int
as
begin
declare @IsAdmin int
declare @DaneshID int
set @IsAdmin=(select cast(RoleID as int) from UserLogin
 where UserId=@UserId)
 set @DaneshID=(select cast(DaneshID as int) from UserLogin
 where UserId=@UserId)
 
 if @IsAdmin=1
 begin
SELECT        UserLogin.UserId, UserLogin.Name, UserLogin.UserName, UserLogin.Password, UserLogin.RoleID, 
               UserLogin.DaneshID, UserRole.RoleName,fdanesh.namedanesh

FROM            UserLogin Left Outer JOIN
                         UserRole ON UserLogin.RoleID = UserRole.id
						 left outer join
						 amozesh.dbo.fdanesh ON fdanesh.id=UserLogin.DaneshID
end
if @IsAdmin=2 
Begin
SELECT        UserLogin.UserId, UserLogin.Name, UserLogin.UserName, UserLogin.Password, UserLogin.RoleID, 
               UserLogin.DaneshID, UserRole.RoleName,fdanesh.namedanesh

FROM            UserLogin Left Outer JOIN
                         UserRole ON UserLogin.RoleID = UserRole.id
						 left outer join
						 amozesh.dbo.fdanesh ON fdanesh.id=UserLogin.DaneshID
						 where DaneshID=@DaneshID
End
if @IsAdmin=6 OR @IsAdmin=7 OR @IsAdmin=8
Begin
SELECT        UserLogin.UserId, UserLogin.Name, UserLogin.UserName, UserLogin.Password, UserLogin.RoleID, 
               UserLogin.DaneshID, UserRole.RoleName,fdanesh.namedanesh

FROM            UserLogin Left Outer JOIN
                         UserRole ON UserLogin.RoleID = UserRole.id
						 left outer join
						 amozesh.dbo.fdanesh ON fdanesh.id=UserLogin.DaneshID
						 where UserId=@UserId
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_AllDocImgByCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_AllDocImgByCategory]
@stcode varchar(11)

as
begin
select address,filename,category from St_documents
where category>1 AND st_code=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_AllTerm_Fnewstudents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_AllTerm_Fnewstudents]
as
begin
select distinct term from fnewStudent

end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_AllTuition]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_AllTuition]
@term varchar(10)
as
begin
SELECT        TuitionId, FeildId, LevelId, Fee, Insurance, Service, Term,Field_Name,EduLevel.name
FROM          TuitionFee left join Field
              ON TuitionFee.FeildId=Field.Field_ID left join EduLevel
			  ON TuitionFee.LevelId=EduLevel.ID
			  where Term=@term
order by LevelId
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Check_MoghayeratButton]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_Check_MoghayeratButton]
@stcode varchar(11)
as
begin
select count (moghayerat_type) as moghayerat_type from Moghayerat
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_CodeByganToField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_CodeByganToField]
as
begin
select * from Field

where Code_Baygan is null and Field_ID in(select distinct idreshSazman  from fnewStudent  
where  (term=substring((select termjary from amozesh.dbo.fcounter),1,2)+substring((select termjary from amozesh.dbo.fcounter),7,1)
or ( term<substring((select termjary from amozesh.dbo.fcounter),1,2)+substring((select termjary from amozesh.dbo.fcounter),7,1) and status<7)))
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_ConfirmDocs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_ConfirmDocs]
@stcode varchar(11)
as
begin
select [address],[filename],category from St_documents
where   st_code=@stcode and Isok=3
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_ConfirmedSahmie]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_ConfirmedSahmie]
as
begin
select distinct St_documents.st_code,fnewStudent.name,fnewStudent.family,fnewStudent.idd_meli from st_documents
inner join fnewStudent on fnewStudent.stcode=st_documents.st_code
where fnewStudent.status=9 and st_documents.category=10 and st_documents.isok=5
and St_documents.st_code not in(select stcode from amozesh.dbo.mojaz_sabtenam 
where tterm=(select termjary from amozesh.dbo.fcounter))
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Get_DocLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_Get_DocLog]
@stcode varchar(11),
@DocId int
as 
begin
select dbo.MiladiTOShamsi(logdate) as logdate,LogTime,DocName,St_Doc_Status.DocStatus,Name,User_LogType.LogType,DocId,Description from UserLog left join St_documents
ON St_documents.id=UserLog.DocId left join st_Documents_category
ON St_documents.category=st_Documents_category.id left join St_Doc_Status
ON UserLog.DocStatus=St_Doc_Status.id left join UserLogin
ON UserLogin.UserId=UserLog.UserId left join User_LogType
ON User_LogType.id=UserLog.LogType
where UserLog.StCode=@stcode and category=@DocId
end

GO
/****** Object:  StoredProcedure [dbo].[SP_Get_eslahat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_eslahat]
@stcode varchar(11),
@moghayerat_type varchar(20)
as
begin
select eslahat from Moghayerat where stcode=@stcode and moghayerat_type=@moghayerat_type
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_FieldAndMaghAllstudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_FieldAndMaghAllstudent]
@levelId tinyint
,@term varchar(10)
as 
begin
select distinct idreshsazman,magh from fnewStudent
where magh=@levelId and term=substring(@term,1,2)+substring(@term,7,1)
or (magh=@levelId and term<substring(@term,1,2)+substring(@term,7,1) and status<7)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_FieldHasCodeBaygan]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_FieldHasCodeBaygan]
as 
begin
select * from Field
where Code_Baygan is not null
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_FieldName_ByFieldId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_FieldName_ByFieldId]
@fieldId int
as
begin
select * from Field where Field_ID=@fieldId
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_FieldofGroup]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_FieldofGroup]
@IDGroup int
as
begin
select amozesh.dbo.fresh.codesazman as idreshte, amozesh.dbo.fresh.nameresh as namereshte from amozesh.dbo.fresh
where amozesh.dbo.fresh.idgroup=@IDGroup
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_fnewstudents_somedetails]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_fnewstudents_somedetails]
@stcode varchar(11)
as
begin
select name,family,namep,idd,idd_meli,sex,nezamvazife,sahmeh from fnewStudent
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_GroupNameofGroupManager]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_GroupNameofGroupManager]
@ID_UserLogin int
as
begin
select amozesh.dbo.fgroup.namegroup as namegroup,amozesh.dbo.fgroup.id as idgroup from amozesh.dbo.fgroup
inner join InitialRegistration.dbo.GroupManager on InitialRegistration.dbo.GroupManager.ID_Group=amozesh.dbo.fgroup.id
where InitialRegistration.dbo.GroupManager.ID_UserLogin=@ID_UserLogin
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_idreshsazman_bystcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_idreshsazman_bystcode]
@stcode varchar(11)
as
begin
select idreshsazman from fnewStudent
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Mellikart]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_Mellikart]
@stcode varchar(11)
as
begin
select distinct address from Moghayerat where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Moghayerat_per_student]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_Moghayerat_per_student]
@stcode varchar(11),
@moghayerat_type int
as
begin
select stcode,moghayerat_type from Moghayerat 
where
stcode=@stcode and moghayerat_type=@moghayerat_type
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_MoghayeratList]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_MoghayeratList]
as
begin
select Moghayerat.stcode,Moghayerat.moghayerat_type as moghayerat_Type ,Moghayerat as moghayeratname,Moghayerat.[address] from Moghayerat
inner join MoghayeratType on MoghayeratID=Moghayerat.moghayerat_type
where eslahat is  null
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_MojazStudents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_MojazStudents]
as
begin
select m.stcode as stcode
	,f.name as name 
	,f.family as family
	,f.idd_meli as idd_meli
	,f.janbaz_rayaneh as rayaneh 
	FROM amozesh.dbo.mojaz_sabtenam as m
	inner join InitialRegistration.dbo.fnewStudent as f on f.stcode=m.stcode
 where m.iduser is null and m.tterm=(select termjary from amozesh.dbo.fcounter)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_OrderIDperPayType]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create procedure [dbo].[SP_Get_OrderIDperPayType]
   @PayType tinyint,
   @OrderID bigint
   as
   begin
   SELECT OrderID from Payment
   where PayType=@PayType and OrderID=@OrderID
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Payment_changeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_Payment_changeField]
@levelId int,
@FieldId int,
@stcode varchar(11)
,@term varchar(10)
as
declare @fee bigint
declare @sahmie int
begin
set @sahmie = (select sahmeh from fnewStudent where stcode = @stcode)
if(ISNULL(@sahmie, 0) > 0)
begin
set @fee=(select Insurance+Service from TuitionFee where LevelId=@levelId and FeildId=@FieldId and Term=@term)
end
else
begin
set @fee=(select fee+Insurance+Service from TuitionFee where LevelId=@levelId and FeildId=@FieldId and Term=@term)
end
select @fee-Isnull(sum(AmountTrans),0) from Payment where StudentCode=@stcode and AppStatus='COMMIT' and PayType<4
end

GO
/****** Object:  StoredProcedure [dbo].[SP_Get_PersonalImage]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_PersonalImage]
@stcode varchar(11)
as
begin
select address,filename from St_documents
where category=1 AND st_code=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Riznomarat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_Get_Riznomarat]
  @stcode int,
  @isok int
  as
  begin
  select [address],[filename] from St_documents
  where st_code=@stcode and category=11 and isok=@isok
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_RiznomarateTaeid]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_RiznomarateTaeid]
@idresh int,
@maghta int,
@isok int
as
begin
select distinct fnewStudent.stcode as stcode,fnewStudent.name as name,
fnewStudent.family as family,fnewStudent.email as email,Field.Field_Name as field_name
 from fnewStudent
inner join Field on fnewStudent.resh_endmadrak=Field.Field_ID
left join St_documents on St_documents.st_code=fnewStudent.stcode
where fnewStudent.status=4 and (St_documents.category=11)
 and fnewStudent.idreshSazman=@idresh and fnewStudent.magh=@maghta and St_documents.Isok=@isok
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Setting]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_Setting]
@daneshId int
,@term varchar(10)
as
begin
if(@daneshId>0)
begin
select *,CASE LevelId 
  WHEN 2 THEN 'کارشناسی' 
  WHEN 3 THEN 'کارشناسی ارشد'  
  WHEN 6 THEN 'دکتری' 
 
END as LevelName,CASE StatusType 
  WHEN 1 THEN 'بسته شدن برای همه' 
  WHEN 2 THEN 'بسته شدن بر اساس وضعیت'  

 
END as StatusTypeName,
CASE Status 
  WHEN 0 THEN 'بدون شرط'
  WHEN 1 THEN 'وارد شده' 
  WHEN 2 THEN 'ورود اطلاعات'  
  WHEN 3 THEN 'ارسال مدارک'
  WHEN 4 THEN 'پرداخت'
END as StatusName  from Setting left join amozesh.dbo.fresh
ON fresh.id=Setting.FieldId
where iddanesh=@daneshId and Term=@term
end
if(@daneshId=0)
begin
select distinct *,CASE LevelId 
  WHEN 2 THEN 'کارشناسی' 
  WHEN 3 THEN 'کارشناسی ارشد'  
  WHEN 6 THEN 'دکتری' 
 
END as LevelName,CASE StatusType 
  WHEN 1 THEN 'بسته شدن برای همه' 
  WHEN 2 THEN 'بسته شدن بر اساس وضعیت'  

 
END as StatusTypeName,
CASE Status 
  WHEN 0 THEN 'بدون شرط'
  WHEN 1 THEN 'وارد شده' 
  WHEN 2 THEN 'ورود اطلاعات'  
  WHEN 3 THEN 'ارسال مدارک'
  WHEN 4 THEN 'پرداخت'
END as StatusName from Setting left join amozesh.dbo.fresh
ON fresh.id=Setting.FieldId where Term=@term

end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_StatuFnewstudents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_StatuFnewstudents]
@stcode varchar(11)
as
begin
select status from fnewStudent where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_StatusByStcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_StatusByStcode]
@stcode varchar(11)
as
begin
select status from fnewStudent where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_StcodeByIddMeli]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_StcodeByIddMeli]
@idd_meli varchar(20)
as
begin
select stcode from fnewStudent where idd_meli=@idd_meli
order by status desc
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_stcodeByIddmeliField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Get_stcodeByIddmeliField]
@idd_meli varchar(20),
@idresh varchar(10) 
as
begin
select stcode from fnewStudent where idd_meli=@idd_meli and idreshSazman=@idresh and (status<8 or status=9)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_get_StudentInfo_ByiddMeli_status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_get_StudentInfo_ByiddMeli_status]
@iddmeli varchar(20)
as
begin
Select * from fnewstudent where idd_meli=@iddmeli AND status>3 AND status<8
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_StudentInfoByDataEnterDate]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_StudentInfoByDataEnterDate]
@DataEnterDate varchar(10)
as
begin
select name,family,idd_meli,mobile,email 
from fnewStudent 
where DataEnterDate=@DataEnterDate
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_StudentMark]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_StudentMark]
@StCode varchar(11)
as
begin
SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, 
                         st_Documents_category.DocName, St_Doc_Status.DocStatus, St_documents.id
FROM            St_documents INNER JOIN
                         st_Documents_category ON St_documents.category = st_Documents_category.id INNER JOIN
                         St_Doc_Status ON St_documents.Isok = St_Doc_Status.id
WHERE        (St_documents.st_code = @StCode and category=11 and Isok<>3)
ORDER BY St_documents.category asc
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Uniaddress]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Get_Uniaddress]
as
begin
select * From UniAddress
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllCityByProvinceID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani
-- alter date: <alter Date,,>
-- Description:	Get All Province
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllCityByProvinceID]
@ProvinceID int
AS
BEGIN
	Select * from Tbl_Shahrestan where PK_Ostan=@ProvinceID Order by Title
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllDanesh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllDanesh]
as
begin
Select * From amozesh.dbo.fdanesh
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllDocStNotRiz]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllDocStNotRiz]
@status int
,@Stcode varchar(11)
AS
BEGIN
if @Stcode=0
begin
select * from fnewStudent where status=@status 
and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
	and stcode in
 (select stcode from St_documents
 inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
  where category=1 and Isok=3 and fnewStudent.sex=1 and fnewStudent.sahmeh>0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
    in(select st_code from St_documents where category=7 and Isok=3 and st_code 
	in(select st_code from St_documents where category=8 and Isok=3 and st_code
	in(select st_code from St_documents where category=9 and Isok=3 and st_code 
	in(select st_code from St_documents where category=10 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3 )))))))))))
	
or stcode in
 (select st_code from St_documents
  inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
  where category=1 and Isok=3 and fnewStudent.sex=2 and fnewStudent.sahmeh>0  and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
    in(select st_code from St_documents where category=7 and Isok=3 and st_code 
	in(select st_code from St_documents where category=10 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3 )))))))))

	 or stcode in
	 (select st_code from St_documents
	 inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
	  where category=1 and Isok=3 and fnewStudent.sex=1 and fnewStudent.sahmeh=0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
	in(select st_code from St_documents where category=8 and Isok=3 and st_code
	in(select st_code from St_documents where category=9 and Isok=3 and st_code 
	in(select st_code from St_documents where category=12 and Isok=3
	)))))))))
	
	or stcode in
	(select st_code from St_documents
	inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
	 where category=1 and Isok=3 and fnewStudent.sex=2 and fnewStudent.sahmeh=0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3
	)))))))
	
	
end
if @Stcode>0
begin
select * from fnewStudent where stcode=@Stcode
and stcode in
 (select stcode from St_documents
 inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
  where category=1 and Isok=3 and fnewStudent.sex=1 and fnewStudent.sahmeh>0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
    in(select st_code from St_documents where category=7 and Isok=3 and st_code 
	in(select st_code from St_documents where category=8 and Isok=3 and st_code
	in(select st_code from St_documents where category=9 and Isok=3 and st_code 
	in(select st_code from St_documents where category=10 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3 )))))))))))
	
or stcode in
 (select st_code from St_documents
  inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
  where category=1 and Isok=3 and fnewStudent.sex=2 and fnewStudent.sahmeh>0  and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
    in(select st_code from St_documents where category=7 and Isok=3 and st_code 
	in(select st_code from St_documents where category=10 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3 )))))))))

	 or stcode in
	 (select st_code from St_documents
	 inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
	  where category=1 and Isok=3 and fnewStudent.sex=1 and fnewStudent.sahmeh=0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
	in(select st_code from St_documents where category=8 and Isok=3 and st_code
	in(select st_code from St_documents where category=9 and Isok=3 and st_code 
	in(select st_code from St_documents where category=12 and Isok=3
	)))))))))
	
	or stcode in
	(select st_code from St_documents
	inner join fnewStudent on fnewStudent.stcode=St_documents.st_code
	 where category=1 and Isok=3 and fnewStudent.sex=2 and fnewStudent.sahmeh=0 and st_code 
in(select st_code from St_documents where category=2 and isok=3 and st_code
 in(select st_code from St_documents where category=3 and Isok=3 and st_code
  in(select st_code from St_documents where category=4 and Isok=3 and st_code 
  in(select st_code from St_documents where category=5 and Isok=3 and st_code
   in(select st_code from St_documents where category=6 and Isok=3 and st_code
	in(select st_code from St_documents where category=12 and Isok=3
	)))))))
 	and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllEduLevel]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani
-- alter date: <alter Date,,>
-- Description:	Get All EduLevel
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllEduLevel]

AS
BEGIN
	Select * from EduLevel
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllExamPlaces]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_GetAllExamPlaces]
as
begin
select * from amozesh.dbo.Students_Exam_Place where IsActive=1
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllFixPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllFixPayment]
@term char(7)
,@LevelId tinyint
,@FieldId int
,@stcode varchar(11)
AS
BEGIN
declare @inst int
declare @fee int
set @inst=(select cast(IsInstallment as int) from fnewStudent where stcode=@stcode)
if(@FieldId=0)
begin
set @fee =(select AllField_FixFee from [Control]
	where  term=@term and LevelId=@LevelId)
	
	end
if(@FieldId>0)
begin
set @fee =(select Variable fee from [TuitionFee]
	where  term=@term and LevelId=@LevelId and FeildId=@FieldId)	
	
	end

	if(@inst>0)
	begin
	if(@LevelId=2)
	select 3920000
	if(@LevelId=3)
	select 5920000
	if(@LevelId=6)
	select 10920000
	end
	if(@inst=0)
	begin
	select @fee
	end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllGroup]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllGroup]
@userId int
as
begin
select fresh.nameresh+' '+isnull(fgeraesh.namegeraesh,'') as nameresh,fresh.codesazman
 from useraccess.UserFiledAccess inner join amozesh.dbo.fresh
ON fresh.id=UserFiledAccess.FiledId left join amozesh.dbo.fgeraesh
ON fgeraesh.idresh=fresh.id
where UserId=@userId and Enable=1
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllGroup_ByUserAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllGroup_ByUserAccess]
@iddanesh numeric(18,0)
,@UserId int
as
begin
select * From amozesh.dbo.fgroup 
left join
UserAccess ON UserAccess.GroupId=fgroup.id
where iddanesh=2 AND fgroup.id in(select GroupId from UserAccess) AND UserId=103
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllProvince]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani
-- alter date: <alter Date,,>
-- Description:	Get All Province
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllProvince]
AS
BEGIN
	Select * from Tbl_Ostan Order by Title
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllStatusForGuestStudents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetAllStatusForGuestStudents]
AS

SELECT DISTINCT i.RequestStatus AS StdStatus ,StatusText=CASE i.RequestStatus
							WHEN 0 THEN 'ورود اطلاعات فردی'
							WHEN 1 THEN 'بارگذاری مدارک'
							WHEN 2 THEN 'تایید اطلاعات فردی'
							WHEN 3 THEN 'رد درخواست مهمانی'
							WHEN 4 THEN 'منتقل شده به سیدا بدون انتخاب واحد'
							WHEN 5 THEN 'منتقل شده به سیدا با انتخاب واحد'
							ELSE 'نامشخص'
						END
                            

 FROM dbo.GuestStudentsInfo i
 ORDER BY i.RequestStatus


 

















GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllstStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAllstStatus]
AS
BEGIN
select * from St_Status
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllStudentsForInsertIntoSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetAllStudentsForInsertIntoSida]
AS
BEGIN
	SELECT DISTINCT fs.stcode,St_Doc_Status.DocStatus as DocStatus ,sd.Isok as isok, fs.name, fs.family, fs.idd_meli, Field.Field_Name as Field_Name
	, fs.email, Field_1.namecoding as resh,EduLevel.name as maghname,substring(CONVERT(varchar(3), term),1,2) as term,vorodi,term as stterm
	FROM            fnewStudent fs
					LEFT OUTER JOIN Field ON fs.idreshSazman = Field.Field_ID 
					LEFT OUTER JOIN amozesh.dbo.fcoding AS Field_1 ON fs.resh_endmadrak = Field_1.id 
					LEFT OUTER JOIN St_documents sd ON fs.stcode = sd.st_code 
					LEFT join EduLevel ON EduLevel.Id_sazman=fs.magh
					left join St_Doc_Status on St_Doc_Status.id=sd.Isok
	WHERE       sd.category in (11,12)
	AND			sd.Isok in(4,5)
	AND			fs.status = 6
	AND			(sd.RegistrationConfirm is null or sd.RegistrationConfirm = 0)
	AND			stcode in(select st_code from St_documents where category = 1 and Isok = 5 and stcode = fs.stcode)
	and			stcode in(select studentcode from Payment where AppStatus='COMMIT' and (PayType=1 or PayType=3) and st_code = fs.stcode)
	and			Field_1.idtypecoding=4 
	order by term asc
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAlterTextByCat_Status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetAlterTextByCat_Status]
@category tinyint
,@status int
AS
BEGIN
	select * from AllAlterText where StatusID=@status and Category=@category
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetCity]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: 1393/05/16
-- Description:	City
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetCity]
@PK_Ostan int
AS
BEGIN
select Title from Tbl_Shahrestan where PK_Ostan=@PK_Ostan
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetComInfoByStcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetComInfoByStcode]
@stcode varchar(11)
AS
BEGIN
	select stcode,email,mobile from fnewStudent
	where stcode=@stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetConfirmedFieldChanges]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetConfirmedFieldChanges]
	@NationalCode	varchar(10)
AS
BEGIN
	SELECT * FROM RequestChangeField
	WHERE iddMeli = @NationalCode
	AND ComposeOrReply = 2
	AND StatusRequest = 2
	ORDER BY RequestID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetControlInfoByLevelId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetControlInfoByLevelId] 
	@LevelId int
	,@term varchar(7)
	,@fieldId int
AS
BEGIN
	Select * from TuitionFee where LevelId=@LevelId and FeildId=@fieldId AND Term=@term
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetCourseByDidAndTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetCourseByDidAndTerm]
	@did			int
	,@Term			varchar(7)
	,@GetFromSida	bit
AS
BEGIN
	IF(@GetFromSida = 1)
	BEGIN
		SELECT ak.saatklass, o.name + ' ' + o.family AS TeacherName, d.namedars, d.dcode AS CourseCode, r.namedanesh AS CollegeName, ak.tterm AS Term, ak.did AS did
		FROM amozesh..ara_klas ak, amozesh..ara_ost_klas aok, amozesh..fostad o, amozesh..fdars d, amozesh..fresh r
		WHERE ak.did = @did
		AND ak.tterm = '95-96-2'--@Term
		AND aok.tterm = ak.tterm
		AND aok.did = ak.did
		AND o.code_ostad = aok.idostad
		AND ak.codedars = d.dcode
		AND r.id = ak.idresh
	END
	ELSE
	BEGIN
		SELECT * FROM GuestCourse
		WHERE did = @did
		AND Term = '95-96-2'--@Term
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetCurrentTermStatistics]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetCurrentTermStatistics]
	@term	varchar(7)='98-99-2'
	,@term2 varchar(7)='99-00-1'
AS
BEGIN
	select (tbl.ارشد+ (tbl.[ثبت نام در محل 1] + tbl.[ثبت نام در محل 2] + tbl.[کارشناسی با آزمون]+tbl.[کارشناسی بی آزمون عادی])) as [کل ثبت نام],tbl.ارشد ,(tbl.[ثبت نام در محل 1] + tbl.[ثبت نام در محل 2] + tbl.[کارشناسی با آزمون]+tbl.[کارشناسی بی آزمون عادی]) as [تمامی کارشناسی ها], tbl.[کارشناسی با آزمون],tbl.[کارشناسی بی آزمون عادی],tbl.[ثبت نام در محل 1],tbl.[ثبت نام در محل 2], tbl.[کل انصرافی 1], tbl.[کل انصرافی 2]
from(
	select 
	(select count(distinct stcode) as arshadCount from fnewStudent f, Payment p
	where f.stcode = p.StudentCode
	and (p.tterm=@term or p.tterm=@term2)
	and p.AppStatus = 'COMMIT' and magh=3) as [ارشد],
	(select count(distinct stcode) from fnewStudent f, Payment p
	where f.stcode = p.StudentCode
	and (p.tterm=@term or p.tterm=@term2)
	and p.AppStatus = 'COMMIT' and magh=2 and   idreshSazman  in (20803,20315)) as [کارشناسی با آزمون],
	(
	(select count(distinct stcode) from fnewStudent f, Payment p
	where f.stcode = p.StudentCode
	and (p.tterm=@term or p.tterm=@term2)
	and p.AppStatus = 'COMMIT' and magh=2 and   idreshSazman not in (20803,20315))-(
	select COUNT(distinct r.id)  from NoExamEntrance.Request as r,NoExamEntrance.Payment as p where r.id=p.RequestId 
	and p.AppStatus='TRANSFERRED')-1
	) as[کارشناسی بی آزمون عادی],
	((select COUNT(distinct r.id)  from NoExamEntrance.Request as r,NoExamEntrance.Payment as p where r.id=p.RequestId 
	and (p.AppStatus='commit' or p.AppStatus='TRANSFERRED') and r.Term=@term)) as [ثبت نام در محل 1],
	((select COUNT(distinct r.id)  from NoExamEntrance.Request as r,NoExamEntrance.Payment as p where r.id=p.RequestId 
	and (p.AppStatus='commit' or p.AppStatus='TRANSFERRED') and r.Term=@term2)) as [ثبت نام در محل 2],
	(select COUNT(distinct f.stcode) from fnewStudent f, Payment p where f.stcode = p.StudentCode and p.AppStatus='COMMIT' and p.PayType=1 and p.tterm=@term2 and f.status=10) as [کل انصرافی 2],
	(select COUNT(distinct f.stcode) from fnewStudent f, Payment p where f.stcode = p.StudentCode and p.AppStatus='COMMIT' and p.PayType=1 and p.tterm=@term and f.status=10) as [کل انصرافی 1]
) as tbl
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocByDocID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani
-- alter date: <alter Date,,>
-- Description:	GetDocByDocID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDocByDocID]
@DocId int
AS
BEGIN
	SELECT        filename, address, id, category, Isok, Note, st_code,name,family, RegistrationConfirm
FROM            St_documents left join fnewStudent
ON fnewStudent.stcode=St_documents.st_code
WHERE        (id = @DocId)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocs_bystcodeCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_GetDocs_bystcodeCategory]
@stcode varchar(11),
@category int
as
begin
select * from St_documents
where st_code=@stcode and category=@category
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocuments_By_StCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetDocuments_By_StCode]
@stcode varchar(11)
as
begin
SELECT        st_code, filename, address, category, Isok, Note,DocName, RegistrationConfirm
FROM            St_documents left join st_Documents_category
ON st_Documents_category.id=St_documents.category
where st_code=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocuments_By_StCode_SahimeDoc_Status_Category]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetDocuments_By_StCode_SahimeDoc_Status_Category]
@stcode varchar(11)
,@Fromcategory int
,@Tocategory int
as
begin
declare @status int;
set @status=(select status from fnewStudent where stcode=@stcode)
if(@status<=6)
begin
SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, 
                         st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
FROM            St_documents INNER JOIN
                         st_Documents_category ON St_documents.category = st_Documents_category.id INNER JOIN
                         fnewStudent ON St_documents.st_code = fnewStudent.stcode
WHERE        (St_documents.st_code = @stcode) AND (St_documents.Isok = 1) AND ((St_documents.category = @Fromcategory) or (St_documents.category = @Tocategory))
end
if(@status=9)
begin
SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, 
                         st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
FROM            St_documents INNER JOIN
                         st_Documents_category ON St_documents.category = st_Documents_category.id INNER JOIN
                         fnewStudent ON St_documents.st_code = fnewStudent.stcode
WHERE        (St_documents.st_code = @stcode) AND (St_documents.Isok = 1 OR St_documents.Isok = 5) AND ((St_documents.category = @Fromcategory) or (St_documents.category = @Tocategory))
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocuments_By_StCode_Status_Category]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetDocuments_By_StCode_Status_Category]
@stcode varchar(11)
,@Fromcategory int
,@Tocategory int
,@FromIsOk int = 0
,@ToIsOk int = 0

as
begin
		declare @status int;
		set @status=(select status from fnewStudent where stcode=@stcode)
		--===================================
		if(@status<=6)
		begin
			if(@Fromcategory=8 OR @Fromcategory=18 ) --8,9,15,18,19 vaziyat khedmati daneshjoo
			begin
				SELECT        
				   St_documents.st_code
				   , St_documents.filename
				   , St_documents.address
				   , St_documents.category
				   , St_documents.Isok
				   , St_documents.Note
				   , fnewStudent.name
				   ,fnewStudent.family
				   ,st_Documents_category.DocName
				   , St_documents.id
				   , fnewStudent.idd_meli
				   ,avrg_payeh,sahmeh
				   ,janbaz_rayaneh
				   ,janbazi_darsad
				   ,janbazi_nesbat
				   ,azadeh_modat
				FROM            St_documents
									   INNER JOIN st_Documents_category ON St_documents.category = st_Documents_category.id 
									   INNER JOIN fnewStudent ON St_documents.st_code = fnewStudent.stcode
				WHERE        (St_documents.st_code = @stcode)  
				AND (
					  (((St_documents.category BETWEEN @Fromcategory AND  @Tocategory) OR St_documents.category=15) AND Isok IN (1,4) )
			  
					  --OR(((St_documents.category BETWEEN @Fromcategory AND  @Tocategory)  and(Isok=5) ))--for cat 18 ,19 ke karshnash upload mikonad
				   )   
			end
			--===================================
			IF(@Fromcategory<>8 AND @Fromcategory<>18)
			begin
				IF(@FromIsOk = 0)
				begin
					SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, fnewStudent.name,fnewStudent.family,
											 st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
					FROM          St_documents 
								  INNER JOIN  st_Documents_category ON St_documents.category = st_Documents_category.id 
								  INNER JOIN  fnewStudent ON St_documents.st_code = fnewStudent.stcode
					WHERE        (St_documents.st_code = @stcode)  AND (St_documents.category BETWEEN @Fromcategory AND  @Tocategory) AND Isok IN (1,4)
		        end
				else
				begin
					SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, fnewStudent.name,fnewStudent.family,
											 st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
					FROM          St_documents 
								  INNER JOIN  st_Documents_category ON St_documents.category = st_Documents_category.id 
								  INNER JOIN  fnewStudent ON St_documents.st_code = fnewStudent.stcode
					WHERE        (St_documents.st_code = @stcode)  AND (St_documents.category BETWEEN @Fromcategory AND  @Tocategory) AND (Isok = @FromIsOk OR Isok = @ToIsOk)
				end
			end
		end
		
		--####################################
		--####################################

		IF(@status=9)
		BEGIN			
			if(@Fromcategory=8 OR @Fromcategory=18)
			begin
				SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, fnewStudent.name,fnewStudent.family,
										 st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
				FROM          St_documents 
							  INNER JOIN  st_Documents_category ON St_documents.category = st_Documents_category.id 
							  INNER JOIN fnewStudent ON St_documents.st_code = fnewStudent.stcode
				WHERE        (St_documents.st_code = @stcode)  
					 AND ((St_documents.category BETWEEN @Fromcategory AND  @Tocategory)OR St_documents.category=15) and(Isok<>3)			
			end
			--===================================
			if(@Fromcategory<>8 AND @Fromcategory<>18)
			begin
				SELECT        St_documents.st_code, St_documents.filename, St_documents.address, St_documents.category, St_documents.Isok, St_documents.Note, fnewStudent.name,fnewStudent.family,
										 st_Documents_category.DocName, St_documents.id, fnewStudent.idd_meli,avrg_payeh,sahmeh,janbaz_rayaneh,janbazi_darsad,janbazi_nesbat,azadeh_modat
				FROM          St_documents 
							  INNER JOIN  st_Documents_category ON St_documents.category = st_Documents_category.id 
							  INNER JOIN  fnewStudent ON St_documents.st_code = fnewStudent.stcode
				WHERE        (St_documents.st_code = @stcode)  AND (St_documents.category BETWEEN @Fromcategory AND  @Tocategory) and(Isok<>3)
	
			END
		end
END
--EXECUTE SP_GetDocuments_By_StCode_Status_Category '960014272' ,2,6
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocumentsByCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDocumentsByCategory]
@Cat_id int
AS
BEGIN
	SELECT   dbo.St_documents.st_code, dbo.St_Doc_Status.DocStatus,dbo.St_Doc_Status.id as Status_id, dbo.st_Documents_category.DocName,
	dbo.st_Documents_category.id as Cat_id, dbo.St_documents.filename,dbo.St_documents.Isok
FROM          dbo.St_documents   LEFT OUTER JOIN dbo.st_Documents_category 
 ON dbo.st_Documents_category.id = dbo.St_documents.category 
INNER JOIN  dbo.St_Doc_Status ON dbo.St_documents.id = dbo.St_Doc_Status.id 
where dbo.st_Documents_category.id=@Cat_id
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocumentsByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDocumentsByStatus]
@Status_id int
AS
BEGIN
	SELECT   dbo.St_documents.st_code, dbo.St_Doc_Status.DocStatus,dbo.St_Doc_Status.id as Status_id, dbo.st_Documents_category.DocName,
	dbo.st_Documents_category.id as Cat_id, dbo.St_documents.filename,dbo.St_documents.Isok
FROM          dbo.St_documents   LEFT OUTER JOIN dbo.st_Documents_category 
 ON dbo.st_Documents_category.id = dbo.St_documents.category 
INNER JOIN  dbo.St_Doc_Status ON dbo.St_documents.id = dbo.St_Doc_Status.id 
where dbo.St_Doc_Status.id=@Status_id
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocumentsByStatusAndCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDocumentsByStatusAndCategory]
@Status_id int
,@Category_id int
AS
BEGIN
	SELECT   dbo.St_documents.st_code, dbo.St_Doc_Status.DocStatus,dbo.St_Doc_Status.id as Status_id, dbo.st_Documents_category.DocName,
	dbo.st_Documents_category.id as Cat_id, dbo.St_documents.filename,dbo.St_documents.Isok
FROM          dbo.St_documents   LEFT OUTER JOIN dbo.st_Documents_category 
 ON dbo.st_Documents_category.id = dbo.St_documents.category 
INNER JOIN  dbo.St_Doc_Status ON dbo.St_documents.id = dbo.St_Doc_Status.id 
where dbo.St_Doc_Status.id=@Status_id and  dbo.St_documents.category=@Category_id
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetDocumentsByStCodeAndCategory]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetDocumentsByStCodeAndCategory]
@stcode varchar(11)
,@Category int
as
begin
SELECT       id, st_code, filename, address, category, Isok, Note
FROM            St_documents
where st_code=@stcode and Category=@Category
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetExamPlaceByID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetExamPlaceByID]
@ID int
as
begin
select * from amozesh.dbo.Students_Exam_Place where ID=@ID
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetExamplaceByStcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetExamplaceByStcode]
@stcode varchar(11)
as
begin
select * from ExamPlace where Stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetFieldNameByFieldId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetFieldNameByFieldId] 
	@fieldId	INT
AS
BEGIN
	SELECT * FROM Field WHERE Field_ID = @fieldId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestCourseAndMarks]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetGuestCourseAndMarks]
	@GuestStudentInfoId	int,
	@Term				varchar(7)
AS
BEGIN
	SELECT g.ID, dars.namedars AS CourseTitle, vt.mark, [dbo].[fnNumberToWord_Persian](vt.mark) AS PersianMark, dars.v_amali, dars.v_nazari
	FROM GuestStudentsInfo g
	JOIN amozesh..vahedinterm vt ON vt.stcode = g.stcode AND vt.tterm = '95-96-2'--g.RequestTerm
	JOIN amozesh..ara_klas klas ON klas.did = vt.did AND klas.tterm = '95-96-2'--g.RequestTerm
	JOIN amozesh..fdars dars ON dars.dcode = klas.codedars
	WHERE g.ID = @GuestStudentInfoId
	AND g.RequestTerm = @Term
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestCourseById]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetGuestCourseById]
	@GuestCourseId	int
AS
BEGIN
	SELECT gc.*, ak.saatklass, o.name + ' ' + o.family AS TeacherName, d.namedars, d.dcode AS CourseCode, r.namedanesh AS CollegeName
	FROM GuestCourse gc, amozesh..ara_klas ak, amozesh..ara_ost_klas aok, amozesh..fostad o, amozesh..fdars d, amozesh..fresh r
	WHERE gc.Term = '95-96-2'--@Term
	AND gc.Capacity > 0
	AND ak.did = gc.did
	AND ak.tterm = gc.Term
	AND aok.tterm = gc.Term
	AND aok.did = gc.did
	AND o.code_ostad = aok.idostad
	AND ak.codedars = d.dcode
	AND r.id = ak.idresh
	AND gc.GuestCourseId = @GuestCourseId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestCourseList]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetGuestCourseList]
	@Term		varchar(7)
	,@GetAll	bit = 0
AS
BEGIN
	SELECT gc.*, ak.saatklass, o.name + ' ' + o.family AS TeacherName, d.namedars, d.dcode AS CourseCode, r.namedanesh AS CollegeName
	FROM GuestCourse gc, amozesh..ara_klas ak, amozesh..ara_ost_klas aok, amozesh..fostad o, amozesh..fdars d, amozesh..fresh r
	WHERE (gc.Active = 1 OR @GetAll = 1)
	AND gc.Term = '95-96-2'--@Term
	AND gc.Capacity > 0
	AND ak.did = gc.did
	AND ak.tterm = gc.Term
	AND aok.tterm = gc.Term
	AND aok.did = gc.did
	AND o.code_ostad = aok.idostad
	AND ak.codedars = d.dcode
	AND r.id = ak.idresh
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestListInTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetGuestListInTerm]
	@Term	varchar(7)
AS
BEGIN
	SELECT g.stcode, g.FirstName + ' ' + g.LastName AS FullName, g.NationalCode, g.UniversityId, uni.namecoding AS UniversityTitle, EntranceYear
	, CASE
		WHEN g.RequestStatus = 0 THEN 'ورود اطلاعات فردی'
		WHEN g.RequestStatus = 1 THEN 'بارگذاری مدارک'
		WHEN g.RequestStatus = 2 THEN 'تایید اطلاعات فردی'
		WHEN g.RequestStatus = 3 THEN 'رد درخواست میهمانی'
		WHEN g.RequestStatus = 4 THEN 'منتقل شده به سیدا بدون انتخاب واحد'
		WHEN g.RequestStatus = 5 THEN 'منتقل شده به سیدا با انتخاب واحد'
	END AS StatusTitle
	FROM GuestStudentsInfo g, amozesh..fcoding uni
	WHERE RequestTerm = @Term
	AND uni.id = g.UniversityId
	AND uni.idtypecoding = 1
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestStudentDocByStCodeAndTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[SP_GetGuestStudentDocByStCode]

CREATE PROCEDURE [dbo].[SP_GetGuestStudentDocByStCodeAndTerm]
	@stcode varchar(9) ,
	@term   VARCHAR(7) --='96-97-2',
	
AS
BEGIN
	SELECT	d.*,g.LetterNo ,g.LetterDate
	FROM	GuestStudentsDocs as d
	        JOIN dbo.GuestStudentsInfo as g ON g.stcode = d.stcode AND g.RequestTerm=d.DocTerm
	WHERE	d.stcode=@stcode AND d.DocTerm=@term 
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_GetGuestStudentInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_GetGuestStudentInfo]
	@ID		int = 0
	,@StCode	varchar(9) = ''
	,@term		varchar(9)
	,@UserId	int = 0
AS 
BEGIN
IF(@ID > 0)
BEGIN
	SELECT 
		g.*
		, IssuePlace.namecoding  AS IssuePlaceTitle
		,ExamPlace.Name_City AS CityName
		,EducationField.namecoding AS FieldTitle
		,u.namecoding AS UniversityName
		FROM dbo.GuestStudentsInfo  g 
			JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=13) AS IssuePlace     ON IssuePlace.id = g.IssuePlace
			JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=4 ) AS EducationField ON EducationField.id = g.FieldId
			JOIN (SELECT p.id, p.Name_City, p.Address FROM amozesh..Students_Exam_Place AS p WHERE p.IsActive=1) AS ExamPlace ON ExamPlace.ID = g.ExamPlaceId
			JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
		WHERE g.ID = @ID --AND g.RequestTerm=@term
END
ELSE IF(@StCode<>'')
 BEGIN
		SELECT 
		g.*
		, IssuePlace.namecoding  AS IssuePlaceTitle
		,ExamPlace.Name_City AS CityName
		,EducationField.namecoding AS FieldTitle
		,u.namecoding AS UniversityName
		
		FROM dbo.GuestStudentsInfo  g 
			JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=13) AS IssuePlace     ON IssuePlace.id = g.IssuePlace
			JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=4 ) AS EducationField ON EducationField.id = g.FieldId
			JOIN (SELECT p.id, p.Name_City, p.Address FROM amozesh..Students_Exam_Place AS p WHERE p.IsActive=1) AS ExamPlace ON ExamPlace.ID = g.ExamPlaceId
			JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
		WHERE
		 g.stcode = @StCode AND g.RequestTerm=@term
END
ELSE IF(@UserId > 0)
BEGIN
	SELECT 
		g.*
		, IssuePlace.namecoding  AS IssuePlaceTitle
		,ExamPlace.Name_City AS CityName
		,EducationField.namecoding AS FieldTitle
		,u.namecoding AS UniversityName
		FROM dbo.GuestStudentsInfo  g 
		JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=13) AS IssuePlace     ON IssuePlace.id = g.IssuePlace
		JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=4 ) AS EducationField ON EducationField.id = g.FieldId
		JOIN (SELECT p.id, p.Name_City, p.Address FROM amozesh..Students_Exam_Place AS p WHERE p.IsActive=1) AS ExamPlace ON ExamPlace.ID = g.ExamPlaceId
		JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
		LEFT JOIN useraccess.Section s ON s.DaneshId = g.CollegeId
		WHERE  (g.RequestStatus = 1 or g.RequestStatus = 2 OR		
					(
						--when user loads letter after sending his info and stdoc to sida
						g.RequestStatus > 3
						AND EXISTS(SELECT doc.stcode FROM dbo.GuestStudentsDocs AS doc WHERE DocumentStatus=1  AND DocTerm=@term)
						--and mehman_az letter va tarikh -> null
					)	
				)
		       AND g.stcode IN(SELECT doc.stcode FROM dbo.GuestStudentsDocs AS doc WHERE DocumentStatus=1  AND DocTerm=@term   ) 
			   AND g.RequestTerm=@term
			   AND s.SectionId IN(SELECT SectionId FROM UserLogin WHERE UserId = @UserId)
END
ELSE
BEGIN
	SELECT 
		g.*
		, IssuePlace.namecoding  AS IssuePlaceTitle
		,ExamPlace.Name_City AS CityName
		,EducationField.namecoding AS FieldTitle
		,u.namecoding AS UniversityName
		FROM dbo.GuestStudentsInfo  g 
		JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=13) AS IssuePlace     ON IssuePlace.id = g.IssuePlace
		JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=4 ) AS EducationField ON EducationField.id = g.FieldId
		JOIN (SELECT p.id, p.Name_City, p.Address FROM amozesh..Students_Exam_Place AS p WHERE p.IsActive=1) AS ExamPlace ON ExamPlace.ID = g.ExamPlaceId
		JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
		WHERE  (g.RequestStatus = 1 or g.RequestStatus = 2 OR		
					(
						--when user loads letter after sending his info and stdoc to sida
						g.RequestStatus > 3
						AND EXISTS(SELECT doc.stcode FROM dbo.GuestStudentsDocs AS doc WHERE DocumentStatus=1  AND DocTerm=@term)
						--and mehman_az letter va tarikh -> null
					)	
				)
		       AND g.stcode IN(SELECT doc.stcode FROM dbo.GuestStudentsDocs AS doc WHERE DocumentStatus=1  AND DocTerm=@term   ) 
			   AND g.RequestTerm=@term  
end

END

--EXEC Sp_GetGuestStudentInfo

GO
/****** Object:  StoredProcedure [dbo].[SP_GetGuestStudentOpenRequest]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetGuestStudentOpenRequest]
	 @stcode		varchar(9)
	,@NationalCode	varchar(10)
	,@Term			varchar(7)
AS
BEGIN
	SELECT g.*, IssuePlace.namecoding  AS IssuePlaceTitle, ExamPlace.Name_City AS CityName, EducationField.namecoding AS FieldTitle, u.namecoding AS UniversityName
	FROM dbo.GuestStudentsInfo  g 
	JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=13) AS IssuePlace     ON IssuePlace.id = g.IssuePlace
	JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding=4 ) AS EducationField ON EducationField.id = g.FieldId
	JOIN (SELECT p.id, p.Name_City, p.Address FROM amozesh..Students_Exam_Place AS p WHERE p.IsActive=1) AS ExamPlace ON ExamPlace.ID = g.ExamPlaceId
	JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
	WHERE g.stcode = @stcode
	AND g.NationalCode = @NationalCode
	AND g.RequestTerm = @Term
	AND g.RequestStatus <> 3
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_GetGuestStudentsDocs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Sp_GetGuestStudentsDocs](@stcode varchar(11))
AS
BEGIN
    DECLARE @currentTerm	NVARCHAR(10)= (SELECT termjary from amozesh.dbo.fcounter)
	SELECT * 
		FROM dbo.GuestStudentsDocs stdoc		
		WHERE stdoc.stcode=@stcode
		AND stdoc.CategoryId IN(16,17)
		--AND (stdoc.DocumentStatus=1 OR stdoc.DocumentStatus=3) --1=uploding doc 2=fail doc
		AND stdoc.DocTerm=@currentTerm		
END

--EXEC dbo.Sp_GetGuestStudentsDocs '940195940'

GO
/****** Object:  StoredProcedure [dbo].[SP_GetHelpBodyByID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetHelpBodyByID]
@id int
as
begin
select HelpBodyText from Help where
id=@id
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetLastActiveInfoFromAmozesh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetLastActiveInfoFromAmozesh]
	@NationalCode varchar(10)
AS
BEGIN
	SELECT TOP 1 * FROM amozesh.dbo.fsf
	WHERE idd_meli = @NationalCode
	AND (idvazkol = 1 OR idvazkol = 17)
	ORDER BY sal_vorod  DESC, nimsal_vorod DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetLastNoExamRequestByNationalCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetLastNoExamRequestByNationalCode]
	@nationalCode	nvarchar(10)
AS
BEGIN
	SELECT TOP 1 * FROM NoExamEntrance.Request WHERE NationalCode = @nationalCode ORDER BY CreateDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetLastPaymentTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetLastPaymentTerm]
	@stcode	varchar(9)
AS
BEGIN
	select top 1 tterm from fnewStudent f, Payment p where f.stcode = @stcode and f.stcode = p.StudentCode and p.AppStatus='COMMIT' order by tterm desc
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetLevel]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: 1393/05/16
-- Description:	Level
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetLevel]
@id int
AS
BEGIN
select name from EduLevel where Id_sazman=@id
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetMobileBy_StCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetMobileBy_StCode]
@stcode varchar(10)
--,@term INT=-1
AS

	SELECT f.stcode ,f.mobile 
	FROM dbo.fnewStudent f 
	WHERE 
		f.stcode=@stcode
		AND RTRIM( LTRIM(f.mobile) ) <>''
		AND f.mobile IS NOT NULL 
		AND f.mobile NOT IN('00000000000','11111111111','22222222222','33333333333','44444444444','55555555555','66666666666','77777777777','88888888888','99999999999')
		

--EXEC SP_GetMobileBy_StCode '960014272' 




--SELECT COUNT( f.mobile),f.mobile 
--FROM dbo.fnewStudent f 
--WHERE  
--RTRIM( LTRIM(f.mobile) )<>''
--AND f.mobile IS NOT NULL 
--AND f.mobile NOT IN('00000000000','11111111111','22222222222','33333333333','44444444444','55555555555','66666666666','77777777777','88888888888','99999999999')

--GROUP BY f.mobile
--HAVING COUNT( mobile)>1
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNaghsDate]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetNaghsDate]
@stcode varchar(11)
as
begin
declare @magh int;
declare @idresh varchar(10)
DECLARE @term varchar(10)
DECLARE @idreshsazman varchar(10)

set @magh=(select magh from fnewStudent where stcode=@stcode)
set @idreshsazman=(select idreshsazman from fnewStudent where stcode=@stcode)
set @idresh=(select id from amozesh.dbo.fresh where codesazman=@idreshsazman)
set @term=(select termjary from amozesh.dbo.fcounter)
select naghsdate from Setting where LevelId=@magh and FieldId=@idresh and Term=@term
END

--SELECT * FROM dbo.Setting WHERE LevelId=3 and FieldId=21050 and Term='95-96-2'--(select termjary from amozesh.dbo.fcounter)
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNameCoding]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNameCoding]
@idtypecoding numeric(18,0)
AS
BEGIN
declare @q varchar(500)
set @q='SELECT        id, idtypecoding, namecoding
FROM          amozesh.dbo.fcoding
WHERE        (idtypecoding = '+ Cast(@idtypecoding as varchar)+')'
if @idtypecoding=6
set @q=@q+' ORDER BY id'
else
set @q=@q+'ORDER BY namecoding'

exec (@q)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamCommitRequestsByNationalCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetNoExamCommitRequestsByNationalCode]
	@NationalCode	varchar(10)
AS
BEGIN
	SELECT RequestId, FieldId, Field_Name, PaymentCreateDate , sum(Amount) as 'Amount' FROM (
		SELECT r.id as 'RequestId', r.FieldId, p.Amount, f.Field_Name, p.CreateDate as 'PaymentCreateDate'
		FROM NoExamEntrance.Request r, NoExamEntrance.Payment p, Field f
		WHERE r.id = p.RequestId AND p.AppStatus = 'COMMIT' AND cast(cast(f.Field_ID as nvarchar(20)) + '21' as int) = r.FieldId AND r.NationalCode = @NationalCode
	) m group by RequestId, FieldId, Field_Name, PaymentCreateDate
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamEntranceByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetNoExamEntranceByStatus]
	@status		tinyint
AS
BEGIN
	SELECT * FROM NoExamEntrance.Request WHERE Status = @status
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamOfflinePayments]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNoExamOfflinePayments]
	@NationalCode	varchar(10) = null
AS
BEGIN
	IF(@NationalCode IS NOT NULL)
	BEGIN
		SELECT * FROM NoExamEntrance.OfflinePayments WHERE NationalCode = @NationalCode
	END
	ELSE
	BEGIN
		SELECT * FROM NoExamEntrance.OfflinePayments
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamPaymentByRefID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetNoExamPaymentByRefID]
	@refId	nvarchar(50)
AS
BEGIN
	SELECT * FROM NoExamEntrance.Payment WHERE RequestKey = @refId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamPaymentsByAppStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNoExamPaymentsByAppStatus]
	@appStatus		nvarchar(20)
AS
BEGIN
	SELECT * FROM NoExamEntrance.Payment p, NoExamEntrance.Request r WHERE r.id=p.RequestId AND p.AppStatus = @appStatus AND p.TraceNumber > 0
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamPaymentsByRequestIdAndAppStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNoExamPaymentsByRequestIdAndAppStatus]
	  @requestId	decimal(18, 0)
	, @appStatus	varchar(20) = null
AS
BEGIN
	SELECT * FROM NoExamEntrance.Payment WHERE RequestId = 20033 AND ((@appStatus is not null and AppStatus= @appStatus) or @appStatus is null)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamReadyToConvert]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNoExamReadyToConvert]
AS
BEGIN
	SELECT * FROM NoExamEntrance.Request r, NoExamEntrance.Payment p, fnewStudent f
	WHERE p.RequestId = r.id
	AND p.AppStatus='COMMIT'
	AND r.Status=3
	AND f.idd_meli=r.NationalCode
	AND f.idreshSazman = LEFT(r.FieldId, LEN(r.FieldId) - 2)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamRequestById]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetNoExamRequestById]
	@id		decimal(18, 0)
AS
BEGIN
	SELECT r.[id]
      ,r.[FirstName]
      ,r.[LastName]
      ,r.[FathersName]
      ,r.[IdNo]
      ,r.[NationalCode]
      ,r.[Gender]
      ,r.[BirthYear]
      ,r.[FieldId]
      ,r.[Religion]
      ,r.[Mobile]
      ,r.[PhoneNo]
      ,r.[PhoneNoPreCode]
      ,r.[Email]
      ,r.[Address]
      ,r.[LastDegreeType]
      ,round(r.[LastDegreeScore],2) as LastDegreeScore
      ,r.[CreateDate]
      ,r.[Status]
      ,r.[EntranceYear]
      ,r.[StudyingLevel]
      ,r.[StudyingField]
      ,r.[StudyingPlace]
      ,r.[IsStudentNow]
      ,r.[StudingUniType]
      ,r.[Term]
	  ,r.BirthDate
	  ,r.IdSerial
	  ,r.IdSerie
	  ,r.IdLetter
	  ,r.MilitaryStatus
	  ,r.QuotaStatus
	  ,r.EducationalGroup
	  ,r.BirthPlaceState
	  ,r.LivingPlaceState
	  ,r.Nationality
	  ,r.PhysicalStatus
	  ,r.PostalCode
	  ,r.DiplomaTitle
	  ,r.DiplomaDate
	  ,r.DiplomaTotalAvg
	  ,r.DiplomaWrittenAvg
	  ,r.DiplomaRegionCode
	  ,r.DiplomaState
	  ,r.DiplomaCity
	  ,r.DiplomaSection
	  ,r.PreUniversityTitle
	  ,r.PreUniversityDate
	  ,r.PreUniversityTotalAvg
	  ,r.PreUniversityRegionCode
	  ,r.PreUniversityState
	  ,r.PreUniversityCity
	  ,r.PreUniversitySection
	  ,r.PreDiplomaState
	  ,r.PreDiplomaCity
	  ,r.PreDiplomaSection
	  ,r.EducationalSystem
	  , p.*
	  , d.Address as DocAddress
	  , d.FileName
	  FROM NoExamEntrance.Request r, NoExamEntrance.Payment p, NoExamEntrance.Documents d  WHERE r.id=@id AND p.RequestId = r.id and d.RequestId = r.id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNoExamRequestCountByField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetNoExamRequestCountByField]
	@term varchar(7)='99-00-1'
AS
BEGIN
	select Field_ID, Field_Name, count(r.id) as 'RequestCount'
	from NoExamEntrance.Request r, NoExamEntrance.Payment p, Field f
	where p.RequestId = r.id
	and f.Field_ID = CAST(Left(CAST(r.FieldId as nvarchar(7)), 5) as decimal(18,0))
	and r.Term = @term
	and Status = 2
	and (p.AppStatus='COMMIT' or p.AppStatus='TRANSFERRED')
	group by Field_ID, Field_Name
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetNotUsedPaymentInfoBystcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetNotUsedPaymentInfoBystcode]
@stcode bigint
AS
BEGIN
	SELECT *
	FROM Payment p
	WHERE StudentCode = @stcode
	AND AppStatus = 'COMMIT'
	AND PayType = 1
	AND NOT EXISTS(
		SELECT *
		FROM amozesh..fvahdkol
		WHERE stcode = p.StudentCode
		--AND tterm = p.tterm
		)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPaymentInfoByOrderID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetPaymentInfoByOrderID]
@OrderID bigint
AS
BEGIN
	select * from Payment where OrderID=@OrderID and AppStatus != 'TRANSFERRED'
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetPaymentInfoByRefID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetPaymentInfoByRefID]
@RefID nvarchar(250)
AS
BEGIN
	select * from Payment where RequestKey=@RefID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_GetPaymentInfoBystcode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetPaymentInfoBystcode]
@stcode bigint
AS
BEGIN
	select * from Payment where StudentCode=@stcode
	AND AppStatus='COMMIT' and PayType=1
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetRequestChangeFieldByNationalCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetRequestChangeFieldByNationalCode]
	@NationalCode	nvarchar(10)
AS
BEGIN
	SELECt * FROM RequestChangeField
	WHERE iddMeli = @NationalCode
	AND ComposeOrReply = 2
	AND StatusRequest = 2
	ORDER BY RequestID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSahmiePaymentByTermAndEntranceYear]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetSahmiePaymentByTermAndEntranceYear]
@term char(7)
,@LevelId tinyint
,@FeildId int
,@stcode varchar(11)
AS
BEGIN
declare @amount int =0
set @amount=isnull((select sum(AmountTrans) as amount from Payment where StudentCode=@stcode and AppStatus='COMMIT' and PayType<4),0)
select ((Insurance+Service)-@amount) as fee from [TuitionFee]
	where  term=@term and LevelId=@LevelId and FeildId=@FeildId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSettingByfieldId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_GetSettingByfieldId]
@fieldId	int,
@status		int,
@magh		int,
@term		varchar(7)
as
begin
if exists(select * from Setting where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and StartDate=dbo.MiladiTOShamsi(getdate()))
begin
select * from Setting
where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term  and  StartTime<= cast(CAST(DATEPART(hour, getdate()) as varchar(2)) + ':' +
       CAST(DATEPART(minute,getdate())as varchar(2)) as time)
and EndDate>=dbo.MiladiTOShamsi(getdate()) 
end
if exists(select * from Setting where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and EndDate=dbo.MiladiTOShamsi(getdate()) and StatusType=1)
begin
select * from Setting
where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term  and  StartDate<=dbo.MiladiTOShamsi(getdate())
and EndTime>=cast(CAST(DATEPART(hour, getdate()) as varchar(2)) + ':' +
       CAST(DATEPART(minute,getdate())as varchar(2)) as time)
end
if exists(select * from Setting where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and EndDate=dbo.MiladiTOShamsi(getdate()) and StatusType=2)
begin
select * from Setting
where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term  and  StartDate<=dbo.MiladiTOShamsi(getdate())
and  (EndTime>=cast(CAST(DATEPART(hour, getdate()) as varchar(2)) + ':' +
       CAST(DATEPART(minute,getdate())as varchar(2)) as time) or Status<=@status)
end
if exists(select * from Setting where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and EndDate>dbo.MiladiTOShamsi(getdate()) and StartDate<dbo.MiladiTOShamsi(getdate()))
begin
select * from Setting
where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term
end
if exists(select * from Setting where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and EndDate<dbo.MiladiTOShamsi(getdate()) and StatusType=2)
begin
select * from Setting
where FieldId=dbo.Ret_Idresh(@fieldId) and LevelId = @magh and Term=@term and Status<=@status
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSettingByFieldIdAndTerm]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetSettingByFieldIdAndTerm]
	@fieldId	int,
	@magh		int,
	@term		varchar(7)
AS
BEGIN
	SELECT * FROM Setting WHERE FieldId=dbo.Ret_Idresh(@fieldId) AND LevelId = @magh AND Term=@term
END

--SELECT * FROM InitialRegistration.dbo.fnewStudent WHERE idd_meli='5269788349'
-- SELECT * from amozesh.dbo.fresh where codesazman='20808'
--SELECT * FROM Setting WHERE FieldId='104' AND LevelId = 3 AND Term=(select termjary from amozesh.dbo.fcounter)









GO
/****** Object:  StoredProcedure [dbo].[SP_GetStcodeByIddMelliAndStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStcodeByIddMelliAndStatus]
@idd_meli varchar(20)
,@status int
AS
BEGIN
select * from fnewStudent where idd_meli=@idd_meli and status=@status
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStcodeFieldByParms]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROC [dbo].[SP_GetStcodeField]

CREATE procedure [dbo].[SP_GetStcodeFieldByParms]
 @iddMeli varchar(20)='0'
,@parNo varchar(20)='0'
,@salAzmoon INT=0
,@GetAll	bit
AS
BEGIN
DECLARE
@cmd varchar(8000)
SELECT   
	ns.stcode
	, ns.idreshSazman
	, ns.vorodi 
	,'سال '+SUBSTRING(cast(ns.term as varchar(3)),1,2) +'-'+
					 case SUBSTRING(cast(ns.term as varchar(3)),3,1) 
							 WHEN '1' then 'پذیرش مهر' 
							 WHEN '2' then'پذیرش بهمن' 
					 END 
					 +' - '+lev.name
					 +' - '
					 +f.Field_Name as Field_Name
				 
					 ,ns.status
					 ,f.Field_Name as resh
					 ,ns.magh
			   from fnewStudent ns join  Field f on f.Field_ID=ns.idreshSazman
								   LEFT join EduLevel lev on lev.Id_sazman=ns.magh
	   
	   
	    
		   WHERE     (ns.idd_meli=@iddMeli OR @iddMeli='0'  ) 
					 AND					  
					 (
						 ( (SUBSTRING(CAST(ns.term AS NVARCHAR(10)),1,2 )=CAST(@salAzmoon AS VARCHAR(10))) OR @salAzmoon=0 ) AND
						 (ns.par=@parNo OR @parNo='0') 
					 )
					 AND magh <> 6
					 AND (
						 (@GetAll = 0
						 --AND [status] <> 8 
						 --AND [status] < 10
						 AND [status] not in (11,12,13)
						 )
						 OR
						 @GetAll = 1
					)

		   order by ns.status DESC
END

--SELECT * FROM dbo.fnewStudent s where s.stcode='950009817'

--EXEC [dbo].[SP_GetStcodeFieldByParms] '0492713855', '0',0  --idd_meli='0492713855'

--EXEC [dbo].[SP_GetStcodeFieldByParms] '0', '18476',95

--SELECT * FROM dbo.RequestChangeField rcp WHERE rcp.CodeParvandeh='18476' AND rcp.SalAzmoon=95
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStDocByStCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_GetStDocByStCode]
 @category int,
  @stcode varchar(11)
  as
  begin
  select * from St_documents where st_code=@stcode and category=@category
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentByID_Resh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student By Resh Sazman
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentByID_Resh]
@idreshSazman varchar(10)
AS
BEGIN
	Select * from fnewStudent where idreshSazman=@idreshSazman
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentByNezamvazife]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student By nezamvazife
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentByNezamvazife]
@nezamvazife tinyint
AS
BEGIN
	Select fnewStudent.*,fcoding.namecoding from fnewStudent left join fcoding on fcoding.idtypecoding=nezamvazife
	 where nezamvazife=@nezamvazife and fcoding.id=7
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentByProvince]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student By Ostan
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentByProvince]
@Province tinyint
AS
BEGIN
	Select fnewStudent.*,Tbl_Ostan.Title from fnewStudent left join Tbl_Ostan on Tbl_Ostan.ID=Province where Province=@Province
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentBySahmeh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student By sahmeh
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentBySahmeh]
@sahmeh tinyint
AS
BEGIN
	Select fnewStudent.*,fcoding.namecoding from fnewStudent left join fcoding on fcoding.idtypecoding=sahmeh
	 where sahmeh=@sahmeh and fcoding.id=15
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentBySex]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student By sex
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentBySex]
@Sex bit
AS
BEGIN
	Select * from fnewStudent where sex=@Sex
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentChildrens]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentChildrens]
	@stcode		varchar(9)
AS
BEGIN
	SELECT * FROM Children WHERE stcode = @stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentCountInCollege]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentCountInCollege]
	
AS
BEGIN
	SELECT c.CollegeId, COUNT(si.CollegeId) RequestCount
	FROM GuestCollege c
	LEFT OUTER JOIN GuestStudentsInfo si ON si.CollegeId = c.CollegeId
	GROUP BY c.CollegeId
	ORDER BY RequestCount
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentDocsCategoryAndAddress]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentDocsCategoryAndAddress]
AS
BEGIN

select  min(st_code)st_code, min([1]) cat1,min([2]) cat2,min([3]) cat3,min([4]) cat4,min([5]) cat5,min([6]) cat6
,min([7]) cat7,min([8]) cat8,min([9]) cat9,min([10]) cat10,min([11]) cat11
from
(
  select st_code,category,[address]+[filename] as f_add
  from St_documents  
) d
pivot
(
  max(f_add)
  for category in ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11])
) piv
group by st_code
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentDocsCategoryAndAddressByGroup]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentDocsCategoryAndAddressByGroup]

@group numeric(18,0),
@FromCategory int,
@ToCategory int
AS
BEGIN

select min(st_code)st_code,min(name)name,min(family)family,min(idd_meli)idd_meli, min(idd)idd, 
min([1]) cat1,min([2]) cat2,min([3]) cat3,min([4]) cat4,min([5]) cat5,min([6]) cat6
,min([7]) cat7,min([8]) cat8,min([9]) cat9,min([10]) cat10,min([11]) cat11

from
(
  select st_code,name,family,idd_meli,idd,[address]+[filename] as f_add,category
  from St_documents left join fnewStudent on fnewStudent.stcode=St_documents.st_code 
  where Isok=1 and category>=@FromCategory and category<=@ToCategory and st_code in (select stcode from fnewStudent
								where idreshSazman in (select codesazman
								from amozesh.dbo.fresh where idgroup=@group))
) d
pivot
(
  max(f_add)
  for category in ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11])
) piv

group by st_code

END



GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentInfoByNationalIdAndFieldID]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentInfoByNationalIdAndFieldID]
@NationalId varchar(10)
,@FieldID int

AS
BEGIN
	select * from fnewStudent 
	where idd_meli=@NationalId and idreshSazman=@FieldID and (status<8 or status=9)
	order by status desc
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentInfoByStatusAndDepartment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentInfoByStatusAndDepartment]
@Status_id int
,@iddanesh int
,@idresh int
AS
BEGIN
	SELECT   namedanesh,nameresh,dbo.fnewStudent.stcode, dbo.fnewStudent.name,family,namep,idd,idd_meli , [status]	
		FROM          dbo.fnewStudent   LEFT OUTER JOIN 
		amozesh.dbo.fresh on codesazman=idreshSazman 
		where [status]=@Status_id and iddanesh=@iddanesh and codesazman=@idresh
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentInfoBystCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: 93/05/16
-- Description:	Select Student Info
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentInfoBystCode]
@stcode varchar(11)
AS
BEGIN
	select * from fnewStudent
	where stcode=@stcode

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentLeaveRequests]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetStudentLeaveRequests]
@UserId	int
AS
BEGIN
	SELECT st.[name], st.[family], st.[stcode]
	, SUBSTRING(CAST(st.term AS VARCHAR(3)), 0, 3) + '-' + CAST(CONVERT(int, SUBSTRING(CAST(st.term AS VARCHAR(3)), 0, 3)) + 1 AS VARCHAR(2)) + '-' + SUBSTRING(CAST(st.term AS VARCHAR(3)), 3, 1) AS 'AdmissionTerm'
	, l.term AS 'EnrollmentTerm' FROM fnewStudent st
	JOIN (SELECT DISTINCT [stcode], [Event], [term] FROM StudentLog) l ON l.[Stcode] = st.[stcode] AND l.[Event] = 7
	WHERE st.[term] < (Substring(l.[term], 0, 3) + Substring(l.[term], 7, 1))
	and (st.[StudentLeaveStatus] = 0 OR st.[StudentLeaveStatus] is null)
	and st.[status] > 0
	and st.idreshSazman in (
	 select amozesh.dbo.fresh.codesazman from useraccess.UserFiledAccess
	 INNER JOIN amozesh.dbo.fresh ON fresh.id=UserFiledAccess.FiledId
	 LEFT JOIN amozesh.dbo.fgeraesh ON fgeraesh.idresh=fresh.id
	 where UserId=@UserId and Enable=1
	 )
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentLevel]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentLevel]
@stcode varchar(11)
AS
BEGIN
select magh from fnewStudent where stcode=@stcode
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentLogByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetStudentLogByStatus]
@Status int,
@Stcode varchar(11)
as
begin
select * from StudentLog where StudentLog.Status=@Status and Stcode=@Stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetStudentPayment]
@stcode varchar(11),
@paytype int = 0
as
begin
	IF(@paytype = 0)
	BEGIN
		SELECT *,isnull(Payment.TraceNumber,0) AS TraceNumbers
		FROM Payment
		WHERE StudentCode=@stcode
		ORDER BY MiladiDate DESC
	END
	ELSE
	BEGIN
		SELECT *,isnull(Payment.TraceNumber,0) AS TraceNumbers
		FROM Payment
		WHERE StudentCode=@stcode
		AND PayType=@paytype
		ORDER BY MiladiDate DESC
	END
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentReadyToConvert]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentReadyToConvert]
@status int
,@Stcode varchar(11)
AS
BEGIN
if @Stcode=0
begin
select * from fnewStudent where status=@status 
and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
	
	
end
if @Stcode>0
begin
select * from fnewStudent where stcode=@Stcode 	
 	and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
end
END

--select * from fnewStudent 
--WHERE stcode='950280035'	and stcode in (select StudentCode from Payment where AppStatus='COMMIT')

--select * from fnewStudent 
--WHERE status=0 and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentReadyToConvertWithoutConfirmDoc]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentReadyToConvertWithoutConfirmDoc]
--@term varchar(7)
@status int
,@Stcode varchar(11)
AS
BEGIN
if @Stcode=0
begin
		select * from fnewStudent where status=@status and 
	stcode not in (select st_code from St_documents where Isok!=3) 
	and stcode in (select StudentCode from Payment where AppStatus='COMMIT')
	end
if @Stcode>0
begin
select * from fnewStudent where stcode=@Stcode 	and 
stcode in (select StudentCode from Payment where AppStatus='COMMIT')
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentReadyToConvertWithoutPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentReadyToConvertWithoutPayment]
--@term varchar(7)
@status int
,@Stcode varchar(11)
AS
BEGIN
if @Stcode=0
begin
	select * from fnewStudent where status=@status and 
	stcode not in (select st_code from St_documents where Isok!=3)
	
	end
if @Stcode>0
begin
select * from fnewStudent where stcode=@Stcode 	
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentsByLastName]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetStudentsByLastName]
	@LastName NVARCHAR(MAX)
AS
BEGIN
	SELECT * FROM
	(
		SELECT 
		   fnewStudent.stcode
		   , fnewStudent.namep
		   , fnewStudent.name
		   , fnewStudent.family
		   , fnewStudent.idd_meli
		   ,address
		   ,filename
		   ,Isok,Note
		   ,docName
		   ,status
		   ,Field.Field_Name as nameresh
		   ,fnewStudent.idresh
		   ,(amozesh.dbo.magh(dbo.magh2(fnewStudent.magh)))as magh
		   ,fnewStudent.email
		   ,ROW_NUMBER() OVER (PARTITION BY idd_meli ORDER BY stcode DESC) AS RowNumber
		FROM St_documents
		LEFT OUTER JOIN fnewStudent ON fnewStudent.stcode = St_documents.st_code
		LEFT OUTER JOIN	Field on Field.Field_ID=fnewStudent.idreshSazman
		LEFT OUTER JOIN st_Documents_category ON st_Documents_category.id=St_documents.category
		WHERE fnewStudent.family LIKE N'%' + dbo.FN_ConvertAlphabet(@LastName) + '%'
	) tbl
	WHERE tbl.RowNumber = 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentStatusByStCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: <alter Date,,>
-- Description:	Get Student Status of Registration
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetStudentStatusByStCode]
@StCode varchar(11)
AS
BEGIN
	Select * from fnewStudent where stcode=@StCode
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetStudentUnitsFromfvahdkol]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetStudentUnitsFromfvahdkol]
	@stcode varchar(9)
AS
BEGIN
	SELECT * FROM amozesh..fvahdkol WHERE stcode = @stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetUniversityList]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetUniversityList]
	
AS
BEGIN
	--SELECT * FROM University WHERE Active = 1
	SELECT id AS UniversityId, namecoding AS Title
	FROM amozesh..fcoding
	WHERE idtypecoding = 1
	AND (namecoding LIKE N'%آزاد%' OR namecoding LIKE N'%سما%')
	ORDER BY namecoding
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetUserInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetUserInfo]
@UserId int
as
Begin
SELECT        UserLogin.*,UserRole.RoleName,DaneshId
FROM            UserLogin left join UserRole
ON UserRole.id=UserLogin.RoleID left join useraccess.Section
ON useraccess.Section.SectionId=UserLogin.SectionId
WHERE        (UserLogin.UserId = @UserId)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GuestLetterResponse]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GuestLetterResponse]
	@UniversityId	int,
	@Term			varchar(7)
AS
BEGIN
	DECLARE @CourseTerm	nvarchar(5)
	IF(SUBSTRING(@Term, 7, 1) = 1)
		SET @CourseTerm = N'مهر'
	ELSE IF(SUBSTRING(@Term, 7, 1) = 2)
		SET @CourseTerm = N'بهمن'
	ELSE
		SET @CourseTerm = N'تیر'
	SELECT g.ID, g.FirstName + ' ' + g.LastName AS Name, g.IdNo, g.FatherName, g.LetterNo, g.LetterDate, g.RequestTerm, edu.name AS LevelTitle
	, u.namecoding AS UniversityTitle
	, EducationField.namecoding AS FieldTitle
	, dars.namedars AS CourseTitle, vt.mark, [dbo].[fnNumberToWord_Persian](vt.mark) AS PersianMark, dars.v_amali, dars.v_nazari
	, SUBSTRING(@Term,0,6) AS CourseYear, @CourseTerm AS CourseTerm
	FROM GuestStudentsInfo g
	JOIN (SELECT c.id, c.namecoding FROM amozesh..fcoding AS c WHERE c.idtypecoding = 4) AS EducationField ON EducationField.id = g.FieldId
	JOIN amozesh..fcoding u ON u.id = g.UniversityId AND u.idtypecoding = 1
	JOIN EduLevel edu ON edu.Id_sazman = g.LevelId

	JOIN amozesh..vahedinterm vt ON vt.stcode = g.stcode AND vt.tterm = '95-96-2'--g.RequestTerm
	JOIN amozesh..ara_klas klas ON klas.did = vt.did AND klas.tterm = '95-96-2'--g.RequestTerm
	JOIN amozesh..fdars dars ON dars.dcode = klas.codedars

	WHERE g.RequestStatus = 5
	AND UniversityId = @UniversityId
	AND RequestTerm = @Term
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GuestStudentsAnyReportyByParams]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GuestStudentsAnyReportyByParams]
  @Term          VARCHAR(7)   ='-1'
, @RequestStatus nvarchar(20) ='-1'
, @CardStatus    nvarchar(20) ='-1'
, @LetterStatus  nvarchar(20) ='-1'
, @IsReport_Statistical BIT   = 0
AS
BEGIN
	IF(@IsReport_Statistical =1)
		BEGIN
			IF(@CardStatus<>'-1' OR @LetterStatus<>'-1')
			BEGIN	
					SELECT COUNT(gs.stcode) AS Count_n
							,term		      = CASE @Term          WHEN '-1' THEN 'تعیین نشده' ELSE  @Term          END										
							,RequestStatus    = dbo.fn_GetRequestStatus(CAST( @RequestStatus AS INT )) 
							,CardStatus       = dbo.fn_GetStdCartstatus(CAST( @CardStatus    AS INT ))
							,LetterStatus     = dbo.fn_GetLetterStatus (CAST( @LetterStatus  AS INT ))
					
					FROM dbo.GuestStudentsInfo gs
					--JOIN dbo.GuestStudentsDocs gd ON gs.stcode = gd.stcode AND gs.RequestTerm = gd.DocTerm
					--JOIN dbo.GuestStudentsDocs gd2 ON gs.stcode = gd2.stcode AND gs.RequestTerm = gd2.DocTerm
					WHERE 
					    gs.RequestTerm = @Term
						AND (gs.RequestStatus  = cast( @RequestStatus  as int ) OR @RequestStatus  = '-1' )	
						
						AND gs.stcode IN (SELECT gsd.stcode  FROM dbo.GuestStudentsDocs AS gsd WHERE gsd.DocTerm=@Term AND gsd.CategoryId= 16 AND ((gsd.DocumentStatus= cast( @CardStatus as int ) OR @CardStatus = '-1' )    ) )
						AND gs.stcode IN (SELECT gsd2.stcode FROM dbo.GuestStudentsDocs as gsd2 WHERE gsd2.DocTerm=@Term AND  gsd2.CategoryId= 17 AND ((gsd2.DocumentStatus= cast( @LetterStatus as int ) OR @LetterStatus = '-1' )    ) )		
						
						--AND ((gd.DocumentStatus= cast( @CardStatus     as int ) OR @CardStatus     = '-1' )  AND (gd.CategoryId= 16 /*CAST (@CatIdStCard AS INT) OR @CatIdStCard='-1') */  )   ) 
						--AND ((gd.DocumentStatus= cast( @LetterStatus   as int ) OR @LetterStatus   = '-1' )  AND (gd.CategoryId= 17 /*CAST (@CatIdLetter AS INT) OR @CatIdLetter='-1') */ )    )
			END
			------------------------------------------------------------
			ELSE
			BEGIN
				SELECT COUNT(gs.stcode) AS Count_n
							,term		      = CASE @Term          WHEN '-1' THEN 'تعیین نشده' ELSE  @Term          END										
							,RequestStatus    = dbo.fn_GetRequestStatus(CAST( @RequestStatus AS INT )) 
							,CardStatus       = dbo.fn_GetStdCartstatus(CAST( @CardStatus    AS INT ))
							,LetterStatus     = dbo.fn_GetLetterStatus (CAST( @LetterStatus  AS INT ))
					
					FROM dbo.GuestStudentsInfo gs					
	
					WHERE gs.RequestTerm = @Term
						AND (gs.RequestStatus  = cast( @RequestStatus  as int ) OR @RequestStatus  = '-1' )	
					
			 END
			            
		END
   --================================== none statistical report ==========================
	ELSE 
		IF(@CardStatus<>'-1' OR @LetterStatus<>'-1')
		BEGIN
			SELECT  gs.stcode  AS N'شماره دانشجویی'
			       ,gs.FirstName AS N'نام '
				   ,gs.LastName  AS N'نام خانوادگی'
				   ,gs.NationalCode AS N'کد ملی'
				   ,gs.Mobile  AS N'تلفن همرا'				
				   ,tblUniversity.UniversityName AS N'نام دانشگاه'
				   ,ISNULL(gs.EntranceYear,'-----') AS N'سال ورود'
				   ,dbo.fn_GetRequestStatus( gs.RequestStatus ) AS N'وضعیت کلی دانشجوی مهمان'				
				   --,dbo.fn_GetGusetStudentDocType( gd.CategoryId ) AS N'نوع سند'
				   --,dbo.fn_GetGusetStudentDocStatus (gd.DocumentStatus) AS N'وضعیت سند'
			FROM dbo.GuestStudentsInfo gs
			JOIN(SELECT DISTINCT f.id AS UniversityId, f.namecoding AS UniversityName FROM amozesh..fcoding f WHERE f.idtypecoding=1)AS tblUniversity
				ON gs.UniversityId=tblUniversity.UniversityId
			--JOIN dbo.GuestStudentsDocs gd ON gs.stcode = gd.stcode AND gs.RequestTerm = gd.DocTerm
			--JOIN dbo.GuestStudentsDocs gd2 ON gs.stcode = gd2.stcode AND gs.RequestTerm = gd2.DocTerm
			
			WHERE 
					    gs.RequestTerm = @Term
						AND (gs.RequestStatus  = cast( @RequestStatus  as int ) OR @RequestStatus  = '-1' )	

						AND gs.stcode IN (SELECT gsd.stcode  FROM dbo.GuestStudentsDocs as gsd  WHERE gsd.DocTerm=@Term AND gsd.CategoryId= 16 AND ((gsd.DocumentStatus= cast( @CardStatus as int ) OR @CardStatus = '-1' )    ) )
						AND gs.stcode IN (SELECT gsd2.stcode FROM dbo.GuestStudentsDocs as gsd2 WHERE gsd2.DocTerm=@Term AND  gsd2.CategoryId= 17 AND ((gsd2.DocumentStatus= cast( @LetterStatus as int ) OR @LetterStatus = '-1' )    ) )					
						
						--AND ((gd.DocumentStatus= cast( @CardStatus     as int ) OR @CardStatus     = '-1' )  AND (gd.CategoryId= 16 /*CAST (@CatIdStCard AS INT) OR @CatIdStCard='-1') */  )   ) 
						--AND ((gd.DocumentStatus= cast( @LetterStatus   as int ) OR @LetterStatus   = '-1' )  AND (gd.CategoryId= 17 /*CAST (@CatIdLetter AS INT) OR @CatIdLetter='-1') */ )    )
		END

		ELSE
         BEGIN
			SELECT  gs.stcode  AS N'شماره دانشجویی'
			       ,gs.FirstName AS N'نام '
				   ,gs.LastName  AS N'نام خانوادگی'
				   ,gs.NationalCode AS N'کد ملی'
				   ,gs.Mobile  AS N'تلفن همرا'				
				   ,tblUniversity.UniversityName AS N'نام دانشگاه'
				   ,ISNULL(gs.EntranceYear,'-----') AS N'سال ورود'
				   ,dbo.fn_GetRequestStatus( gs.RequestStatus ) AS N'وضعیت کلی دانشجوی مهمان'			
				
			FROM dbo.GuestStudentsInfo gs
			JOIN(SELECT DISTINCT f.id AS UniversityId, f.namecoding AS UniversityName FROM amozesh..fcoding f WHERE f.idtypecoding=1)AS tblUniversity
				ON gs.UniversityId=tblUniversity.UniversityId
		
	
			WHERE gs.RequestTerm = @Term				
				AND (gs.RequestStatus  = cast( @RequestStatus  as int ) OR @RequestStatus  = '-1' )	
								
		 END      

END








GO
/****** Object:  StoredProcedure [dbo].[SP_GuestStudentsListReportByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
--DROP PROC SP_GetAllStatusForGuestStudents
CREATE PROCEDURE [dbo].[SP_GuestStudentsListReportByStatus]
@status INT =-1
,@term VARCHAR(7)='-1'
AS
BEGIN
	IF(@status=-1)
	BEGIN
		SELECT gs.RequestStatus AS status,  statusText= dbo.fn_GetRequestStatus(gs.RequestStatus)  
		   , COUNT(gs.RequestStatus) AS CountOfEachStatus
		FROM dbo.GuestStudentsInfo gs WHERE gs.RequestTerm=@term -- '96-97-1'
		GROUP BY gs.RequestStatus
		ORDER BY status  ASC
    END
    ELSE
    BEGIN
		SELECT 
		f.ID 
		,f.stcode AS N'شماره دانشجویی'
		,f.FirstName AS N'نام'
		,f.LastName AS N'نام خانوادگی'
		,f.NationalCode AS N'کد ملی'
		,f.Mobile AS N'تلفن همراه'
		,tblUniversity.UniversityName AS N'نام دانشگاه'
		,EducationField.FieldName  AS N'عنوان رشته'
		,ISNULL(f.EntranceYear,'-----') AS N'سال ورود'
        FROM dbo.GuestStudentsInfo f 
           JOIN (SELECT DISTINCT fc.id AS UniversityId, fc.namecoding AS UniversityName FROM amozesh..fcoding fc WHERE fc.idtypecoding=1)AS tblUniversity ON tblUniversity.UniversityId = f.UniversityId
		   JOIN (SELECT DISTINCT fc2.id AS FieldId, fc2.namecoding AS FieldName FROM amozesh..fcoding AS fc2 WHERE fc2.idtypecoding=4 ) AS EducationField ON EducationField.FieldId = f.FieldId	
        
		WHERE f.RequestTerm=@term AND f.RequestStatus=@status
	END    
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GuestStudentsReportyByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GuestStudentsReportyByStatus]
@status INT=-1 ,
@selectedTerm NVARCHAR(10)='-1'
AS
BEGIN
	IF(@status=-1 AND @selectedTerm<>'-1')
	begin
		SELECT DISTINCT g.RequestStatus AS Status, COUNT(g.ID) AS CountOfEachStatus
		FROM dbo.GuestStudentsInfo g WHERE g.RequestTerm=@selectedTerm
		GROUP BY  g.RequestStatus
	END
ELSE IF(@status<>-1 AND @selectedTerm<>'-1')
	BEGIN	
		SELECT gs.ID,gs.stcode, gs.NationalCode, gs.FirstName,gs.LastName , gs.UniversityId,gs.RequestTerm AS Term, gs.EntranceYear
		FROM dbo.GuestStudentsInfo gs 
		WHERE gs.RequestStatus=CAST(@status AS TINYINT) AND gs.RequestTerm=@selectedTerm
	END
END
--EXEC SP_GuestStudentsReportyByStatus
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_AllAlterText]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[SP_Insert_AllAlterText]
@Text varchar(MAX)
,@StatusID int
,@Category tinyint
as
begin
INSERT INTO AllAlterText
                         (Text, StatusID,Category)
VALUES        (@Text,@StatusID,@Category)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_AllDocToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_AllDocToSida]
 @id_scan numeric(18,0) --cat
,@stcode varchar(11)
,@doc_image image
,@name_karbar varchar(50)
,@UserId INT 
,@ip NVARCHAR(30) 
,@computer_name NVARCHAR(100)
as
begin
--if  exists(select * from amozesh.dbo.fsf where stcode=@stcode and codebayegan='')
--BEGIN
--	--SELECT  TOP 1 * FROM [digit_archive_sida4].[dbo].[digit_parvandeh]
--DECLARE @type_pic VARCHAR(10)  
--	DECLARE @form_sida NVARCHAR(100)
--	DECLARE @date_send NVARCHAR(10)
--	DECLARE @time_send NVARCHAR(10)

--	declare @termBaygan varchar(5);
--	declare @fsf_sal_vorod varchar(2);
--	declare @magh tinyint;
--	declare @idreshSazman varchar(10);
--	set @termBaygan=(select term from fnewStudent where stcode=@stcode);
--	set @fsf_sal_vorod=(select substring(cast(term as varchar(3)),1,2) from fnewStudent where stcode=@stcode);
--	set @magh=(select magh from fnewStudent where stcode=@stcode);
--	set @idreshSazman=(select idreshSazman from fnewStudent where stcode=@stcode);
--	declare @CodeBaygan varchar(15);
--	set @CodeBaygan='0';
--	if(cast(substring(@termBaygan,1,2) as int)>=94)
--	begin
--		SET @CodeBaygan=( @fsf_sal_vorod+'-'+cast(dbo.magh2(@magh) as varchar(2))+'-'+
--		                 CAST((select Code_Baygan from Field where Field_ID=@idreshSazman) as varchar(10))+'-'+
--						 CAST((select COUNT(amozesh.dbo.fsf.stcode)+1 from amozesh.dbo.fsf where sal_vorod=@fsf_sal_vorod and magh=dbo.magh2(@magh) and codebayegan<>'' and codebayegan<>'0' and codebayegan is not NULL  and idresh in(select dbo.Ret_Idresh(Field_ID) from Field
--		WHERE Code_Baygan=(select Code_Baygan from Field where Field_ID=@idreshSazman)))as varchar(20)))
--	end
--	update amozesh.dbo.fsf
--	set codebayegan=@CodeBaygan
--	where stcode=@stcode
--END
----==================================================
--	set @type_pic  ='jpg'
--	set @form_sida ='scan'
--	set @date_send = ( SELECT RIGHT( InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ) , 8) )
--	set @time_send = (SELECT FORMAT(GETDATE(),'HH:mm')) --24 hour format
--	--(select CONVERT(varchar(15),CAST(getdate() AS TIME),100))
--    --SELECT  CONVERT(VARCHAR(5), GETDATE(), 108) 'hh:mi:ss'

--IF NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@id_scan)
--BEGIN
--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
--	VALUES( @stcode,@type_pic , @doc_image, @id_scan ,@name_karbar ,@ip ,@date_send ,@time_send , @computer_name , @form_sida  )
--END

--ELSE --IF EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@id_scan)
--BEGIN
--		UPDATE [digit_archive_sida4].[dbo].[digit_parvandeh]
--		SET pic_=@doc_image ,sender=@name_karbar , ip=@ip ,date_send=@date_send , time_send=@time_send ,computer_name=@computer_name
--		WHERE stcode=@stcode AND type_archive=@id_scan	
--END	
----==================================================
----Insert into amozpic.dbo.doc_image(id_scan,stcode,doc_image,deleted,name_karbar,date_scan,time_scan)
----values(@id_scan,@stcode,@doc_image,0,@name_karbar,Cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)),'')

--delete from amozesh.dbo.fnaghs_stu 
--WHERE stcode=@stcode and idnaghs=case(@id_scan) 								
--									WHEN 101 then 1		--'روی کارت ملی' 
--									WHEN 100 then 2		--'صفحه اول و دوم شناسنامه'
--									WHEN 107 then 3		--'صفحه سوم و چهارم شناسنامه'
--									WHEN 108 then 4		--'صفحه پنجم و ششم شناسنامه' 
--									WHEN 103 then 6		--'مدرک نظام وظیفه' 
--									WHEN 105 then 7 	--'ریز نمرات' 
--									WHEN 102 then 8		--'عکس پرسنلی' 
--									WHEN 106 then 21	--'سهمیه شاهد' 
--									WHEN 109 then 28	--'پشت کارت ملی' 
--									WHEN 104 then 35	--'مدرک تحصیلی-گواهی موقت' 
--									WHEN 117 then 40	--'برگه معافیت تحصیلی' 
--									WHEN 118 then 42	--'جواب نامه معافیت' 
--									WHEN 119 then 9	    --'نامه موافقت از یگان' 
--									WHEN 121 then 43	--'نامه بهزیستی' 
--								END
----SELECT * FROM amozesh..fcoding f WHERE f.idtypecoding=17 

--declare @naghstype BIGINT;
--set @naghstype=case(@id_scan) 
--					WHEN 100 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='1' ) --'عکس پرسنلی' 
--					WHEN 101 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='2' ) --'صفحه اول و دوم شناسنامه' 
--					WHEN 109 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='3' ) --'پشت کارت ملی' 
--					WHEN 107 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='4' ) --'صفحه سوم و چهارم شناسنامه'
--					WHEN 107 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='5' ) --'صفحه سوم و چهارم شناسنامه'
--					WHEN 108 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='6' ) --'صفحه پنجم و ششم شناسنامه' 
--					WHEN 103 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='8' ) --'پایان خدمت' 
--					WHEN 106 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='10' ) --'سهمیه شاهد' 
--					WHEN 105 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='11' ) --'ریز نمرات'
--					WHEN 104 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='12' ) --'مدرک تحصیلی-گواهی موقت' 
--					WHEN 117 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='15' ) --'برگه معافیت تحصیلی'
--					WHEN 118 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='18' ) --'جواب نامه معافیت' 
--					WHEN 119 then  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='19' ) --'نامه موافقت از یگان' 
--					WHEN 121 THEN  (SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='20' ) --'نامه بهزیستی ' 
--			   END

--delete from amozesh.dbo.web_msg_stu where stcode=@stcode and id=@naghstype

----SELECT * from amozesh.dbo.web_msg_stu 
----SELECT * from amozesh.dbo.fnaghs_stu 

if exists(select * from St_documents where st_code=@stcode and st_code not in(select st_code from St_documents where  Isok<>3 and category<>11 ))
begin
	if not exists(select status from fnewStudent where stcode=@stcode and status=7)
	begin
		update fnewStudentset set [status]=7 WHERE stcode=@stcode
		INSERT INTO UserLog(UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType, Description)
		VALUES (@UserId,GETDATE(),(select CONVERT(varchar(15),CAST(getdate() AS TIME),100)),@stcode,0,0,20,'تکمیل پرونده')
	end
end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_CodeByganToField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_CodeByganToField]
@codebygan varchar(10),
@fieldId int
as
begin
if not exists(select * from Field where Code_Baygan=@codebygan)
begin
update Field
set Code_Baygan=@codebygan
where Field_ID=@fieldId
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_dboAmozeshMojazSabtenam]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_dboAmozeshMojazSabtenam]
@stcode varchar(11),
@datesabt varchar(10),
@timesabt varchar(5)
--@iduser numeric(9,0),
as
BEGIN
DECLARE @currenterm VARCHAR(7)
SET @currenterm =(select amozesh.dbo.fcounter.termjary from amozesh.dbo.fcounter)

IF(NOT EXISTS(SELECT * FROM amozesh..mojaz_antvahed t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
BEGIN
	INSERT into amozesh.dbo.mojaz_antvahed (stcode,tterm,datesabt,timesabt,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,'سیستم ثبت نام')
	INSERT into amozesh.dbo.mojaz_sabtenam (stcode,tterm,datesabt,timesabt,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,'سیستم ثبت نام')
END
END

--select  * FROM amozesh..mojaz_antvahed

--select  * FROM amozesh..mojaz_antvahed WHERE stcode='881054685' AND tterm = (select amozesh.dbo.fcounter.termjary from amozesh.dbo.fcounter)


--EXEC SP_Insert_dboAmozeshMojazSabtenam '950280035','2017-08-14','12'

--select  * FROM amozesh..mojaz_antvahed ORDER BY datesabt DESC
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_EmailBodyText]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[SP_Insert_EmailBodyText]
@EmailBodyText varchar(MAX)
,@StatusID int
as
begin
INSERT INTO EmailBodyText
                         (EmailBodyText, StatusID)
VALUES        (@EmailBodyText,@StatusID)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Help]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_Insert_Help]
@HelpBodyText varchar(MAX)
,@RowID int,
@TypeId int
as
begin
INSERT INTO Help
                         (HelpBodyText, RowID, TypeId)
VALUES        (@HelpBodyText,@RowID,@TypeId)
END



GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_into_fnewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_into_fnewStudent]

@stList StudentType readonly
as
begin
INSERT INTO fnewStudent
                         (
						 term
						 , stcode
						 , name
						 , family
						 , namep
						 , idd
						 , idd_meli
						 , sex
						 , magh
						 , idreshSazman
						 , year_tav
						 , radif_gh
						 , rotbeh_gh
						 , nomreh_gh
						 , par
						 , dav
						 , id_paziresh
						 , vorodi
						 ,DataEnterDate
						 ,tel
						 ,mobile
						 ,email
						 ,addressd
						 ,code_posti
						 ,AcceptationDescription)
select t.term
,t.stcode
,t.name
,t.family
,t.namep
,t.idd
,t.idd_meli
,t.sex
,t.magh
,t.idreshSazman
,t.year_tav
,t.radif_gh
,t.rotbeh_gh
,t.nomreh_gh
,t.par
,t.dav
,t.id_paziresh
,t.vorodi
,dbo.MiladiTOShamsi(GETDATE())
,t.tel
,t.mobile
,t.email
,t.addressd
,t.code_posti
,t.AcceptationDescription
from @stList as t
where not exists (select f.stcode from fnewStudent f where f.stcode=t.stcode )
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_into_fnewStudent_From_AmozeshYar]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_into_fnewStudent_From_AmozeshYar]

@stList StudentTypeFromAmozeshYar readonly
as
begin
select * into #t from @stList s where s.stcode NOT IN (select f.stcode from fnewStudent f )

INSERT INTO fnewStudent
                         (
						 term
						 , stcode
						 , name
						 , family
						 , idd
						 , idd_meli
						 , sex
						 , magh
						 , idreshSazman
						 , vorodi
						 ,DataEnterDate
						 ,mobile
						 ,AcceptationDescription
						 ,bomi
						 ,year_tav)
select t.term
,t.stcode
,t.name
,t.family
,t.idd
,t.idd_meli
,t.sex
,t.magh
,t.idreshSazman
,t.vorodi
,dbo.MiladiTOShamsi(GETDATE())
,t.mobile
,t.AcceptationDescription
,t.bomi
,0
from #t as t
WHERE t.stcode NOT IN (select f.stcode from fnewStudent f )
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Madrak_Status]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Insert_Madrak_Status]
@stcode varchar(11),
@Madrak_Status int
as
begin
update fnewStudent
set Madrak_Status=@Madrak_Status
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_PersonalImage]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_PersonalImage]
 @stcode varchar(11)
,@pic image
,@id_scan numeric(18,0) --cat
,@name_karbar varchar(50)
,@ip NVARCHAR(30) 
,@computer_name NVARCHAR(100)
as
BEGIN
	
	if not exists(select * from amozpic.dbo.stuimage where stcode=@stcode)
	BEGIN   
		INSERT into amozpic.dbo.stuimage(stcode,stu_pic)values(@stcode,@pic)
	end	
	--==================================================

	--DECLARE @type_pic VARCHAR(10)  
	--DECLARE @form_sida NVARCHAR(100)
	--DECLARE @date_send NVARCHAR(10)
	--DECLARE @time_send NVARCHAR(10)
	
	--SET @type_pic  ='jpg'
	--set @form_sida ='scan'
	--set @date_send = ( SELECT InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ))
	--set @time_send = (select CONVERT(varchar(15),CAST(getdate() AS TIME),100))--(SELECT FORMAT(GETDATE(),'hh:mm'))
	----DECLARE @photo varbinary(max) =CAST(@pic AS varbinary)

	--IF NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@id_scan)
	--BEGIN
	--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
	--	VALUES( @stcode,@type_pic , @photo, @id_scan ,@name_karbar ,@ip ,@date_send ,@time_send , @computer_name , @form_sida  )
	--END

	--==================================================
	IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=8)
	BEGIN
		delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=8
		DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
			AND id=(SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category='1')
	END
END

--UPDATE dbo.fnewStudent SET status=6 WHERE stcode='940191977' 
--UPDATE dbo.St_documents  SET Isok=1 WHERE st_code='940191977' AND category IN (1)
--DELETE amozpic..stuimage WHERE stcode='940191977'
--delete digit_archive_sida4..digit_parvandeh WHERE stcode='940191977'
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_RequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_RequestChangeField]
@iddMeli varchar(15),
@OldField int,
@NewField int,
@ComposeOrReply int,
@UserId int,
@RequestText varchar(700),
@StatusRequest int,
@OldStcode varchar(11),
@NewStcode varchar(11)
as
begin
if(@UserId=0)
INSERT INTO RequestChangeField
                         (iddMeli, OldField, NewField, ComposeOrReply, UserId, RequestText, StatusRequest, RequestDate,OldStcode,NewStcode)
VALUES        (@iddMeli,@OldField,@NewField,@ComposeOrReply,null,@RequestText,@StatusRequest,dbo.MiladiTOShamsi(GETDATE()),@OldStcode,@NewStcode)
if(@UserId>0)
INSERT INTO RequestChangeField
                         (iddMeli, OldField, NewField, ComposeOrReply, UserId, RequestText, StatusRequest, RequestDate,OldStcode,NewStcode)
VALUES        (@iddMeli,@OldField,@NewField,@ComposeOrReply,@UserId,@RequestText,@StatusRequest,dbo.MiladiTOShamsi(GETDATE()),@OldStcode,@NewStcode)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Resh_Mortabet]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Insert_Resh_Mortabet]
@stcode varchar(11),
@resh_mortabet int
as
begin
update fnewStudent
set resh_mortabet=@resh_mortabet
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Setting]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_Insert_Setting]
@FieldId int,
@LevelId int,
@StartDate varchar(10),
@StartTime varchar(10),
@EndDate varchar(10),
@EndTime varchar(10),
@StatusType int,
@Status int,
@NaghsDate varchar(10),
@UnitLetterDate varchar(10)
,@term varchar(10)
as
begin
if not exists(select * from Setting where LevelId=@LevelId and FieldId=@FieldId and Term=@term)
begin
INSERT INTO Setting
                         (FieldId, LevelId, StartDate, StartTime, EndDate, EndTime, Term, StatusType, Status,NaghsDate, UnitLetterDate)
VALUES        (@FieldId,@LevelId,@StartDate,@StartTime,@EndDate,@EndTime,@term,@StatusType,@Status,@NaghsDate, @UnitLetterDate)
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Student_Log]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_Student_Log]
@Stcode varchar(11)
,@EnterDate varchar(15)
,@EnterTime varchar(5)='00:00:00'
,@Event int
,@Status int
as 
begin
declare @term varchar(7)
set @term=(select termjary from amozesh.dbo.fcounter) 
INSERT INTO StudentLog
                         (Stcode, EnterDate, EnterTime, Event, Status,Term)
VALUES        (@Stcode,dbo.MiladiTOShamsi(@EnterDate),@EnterTime,@Event,@Status,@term)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_To_fnewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_To_fnewStudent]

@term int,
@vorodi tinyint,
@stcode varchar(11),
@name varchar(30),
@family varchar(70),
@namep varchar(40),
@idd  varchar(20),
@idd_meli varchar(20),
@sex tinyint,
@magh tinyint,
@idreshSazman  varchar(10),
@year_tav numeric(4,0),
@radif_gh  varchar(10),
@rotbeh_gh varchar(10),
@nomreh_gh varchar(10),
@par  varchar(15),
@dav varchar(15),
@id_paziresh int,
@tel varchar(50),
@mobile varchar(20),
@email varchar(70),
@codeposti varchar(20),
@Address varchar(200)
as
begin
INSERT INTO fnewStudent
                         (term, stcode, name, family, namep, idd, idd_meli, sex, magh, idreshSazman, year_tav, radif_gh, rotbeh_gh, nomreh_gh, par, dav, id_paziresh, vorodi,DataEnterDate,tel,mobile,email,addressd,code_posti)
VALUES        (@term,@stcode,@name,@family,@namep,@idd,@idd_meli,@sex,@magh,@idreshSazman,@year_tav,@radif_gh,@rotbeh_gh,@nomreh_gh,@par,@dav,@id_paziresh,@vorodi,dbo.MiladiTOShamsi(getdate()),@tel,@mobile,@email,@Address,@codeposti)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_UserAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_UserAccess]
@UserId int,
@GroupId int,
@Personal bit,
@Education bit,
@Vazife bit,
@Sahmie bit,
@Payment bit,
@PersonalReport bit,
@PaymentReport bit,
@VazifeReport bit,
@SahmieReport bit,
@EducationReport bit,
@LoginReport bit,
@ConfirmPerEduReport bit,
@ConfirmDocReport bit,
@ConfirmPaymentReport bit,
@FinalConfirmReport bit,
@FailedReport bit
as
begin
INSERT INTO UserAccess
                         (UserId, GroupId, Personal, Education, Vazife, Sahmie, Payment, PaymentReport, VazifeReport, SahmieReport, EducationReport, LoginReport, ConfirmPerEduReport, 
                         ConfirmDocReport, ConfirmPaymentReport, FinalConfirmReport, PersonalReport,FailedReport)
VALUES        (@UserId,@GroupId,@Personal,@Education,@Vazife,@Sahmie,@Payment,@PaymentReport,@VazifeReport,@SahmieReport,@EducationReport,@LoginReport,@ConfirmPerEduReport,@ConfirmDocReport,@ConfirmPaymentReport,@FinalConfirmReport,@PersonalReport,@FailedReport)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_UserLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_UserLog]
@UserId int,
@LogDate date,
@LogTime varchar(10),
@StCode varchar(11),
@DocId int,
@DocStatus int,
@LogType int,
@Description varchar(max)
as
begin
INSERT INTO UserLog
                         ( UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@UserId,@LogDate,@LogTime,@StCode,@DocId,@DocStatus,@LogType,@Description)
END



--SELECT *FROM UserLog ORDER BY LogDate DESC

--SELECT *FROM UserLog WHERE StCode='940191977' AND DocId IN(21456, 24448) ORDER BY LogDate DESC 
--DELETE UserLog WHERE StCode='940191977' AND DocId IN(21456, 24448)
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_UserLogin]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Insert_UserLogin]
@Name  varchar(50)
,@UserName varchar(50),
@Password varchar(300),
@RoleID int ,
@SectionId int,
@ShowAccessTomenu bit
as
begin
INSERT INTO UserLogin
                         (Name,UserName, Password, RoleID,SectionId,ShowAccessTomenu)
VALUES        (@Name,@UserName,@Password,@RoleID,@SectionId,@ShowAccessTomenu)
Select @@IDENTITY as UserIdRow
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertCancelStuToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertCancelStuToSida]
@term int
,@stcode varchar(11)
,@name varchar(30)
,@family varchar(70)
,@namep varchar(40)
,@idd varchar(20)
,@idd_meli varchar(20)
,@sex tinyint
,@magh tinyint
,@idreshSazman varchar(10)
,@sal_vorod numeric(18,0)
,@nimsal_vorod tinyint
,@date_tav varchar(10)
,@end_madrak numeric(18,0)
,@university numeric(18,0)
,@date_endmadrak varchar(8)
,@resh_endmadrak numeric(18,0)
,@mahal_tav numeric(18,0)
,@mahal_sodor numeric(18,0)


,@meliat numeric(18,0)
,@jesm numeric(18,0)
,@sahmeh numeric(18,0)
,@tahol numeric(18,0)
,@radif_gh varchar(10)
,@rotbeh_gh varchar(10)
,@nomreh_gh varchar(10)
,@addressd varchar(200)
,@tel varchar(50)
,@avrg_payeh varchar(5)
,@num_davtalab varchar(15)
,@num_par varchar(15)
,@code_posti varchar(20)
,@email varchar(70),

--------fsf

@fsf_family varchar(40)
,@fsf_name varchar(30)
,@fsf_namep varchar(25)
,@fsf_sal_vorod varchar(2)
,@fsf_idPaziresh numeric(18,0)

---------fsf2
,@fsf2_date_endMadrak varchar(10)
,@fsf2_din numeric(18,0)
,@fsf2_nezam numeric(18,0)
,@fsf2_radif_gh numeric(18,0)
,@fsf2_rotbeh_gh numeric(18,0)
,@fsf2_nomreh_gh varchar(15)
,@fsf2_addressd varchar(150)
,@fsf2_email varchar(50)
,@fsf2_code_posti varchar(10)

--Vazeejtemae
,@vazejtemae tinyint
,@modat int
,@code_rayane varchar(20)
,@name_vazejtemae  varchar(50)
,@darsad_tahod varchar(3)
,@sharh varchar(50)

,@hashedPass_StudentLogin nvarchar(max)=NULL  --in supplementary

AS
BEGIN
	DECLARE     @fsf2_@date_tav  VARCHAR(8)

    DECLARE     @ErrorStep       VARCHAR(200)
	DECLARE		@MsgReturn       NVARCHAR(max)=''
	--DECLARE     @ErrorCode  int = @@ERROR	
    BEGIN TRANSACTION tran01
    SAVE TRANSACTION FirstPoint_tran

	BEGIN TRY

		    ----------- Insert into stu-newsida  ---------------------
			if not exists(select * from amozesh.dbo.fnew_stu where stcode=@stcode)
			begin
			    SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnew_stu]';
				INSERT INTO [amozesh].dbo.[fnew_stu]
						   ([term]
						   ,[vorodi]
						   ,[stcode]    
						   ,[family]
						   ,[namep]
						   ,[idd]
						   ,[idd_meli]
						   ,[sex]
						   ,[magh]
						   ,[dorpar]
						   ,[idresh]
						   ,[date_tav]
						   ,[radif_gh]
						   ,[rotbeh_gh]
						   ,[nomreh_gh]
						   ,[code_posti]
						   ,[tel]          
						   ,[email]
						   ,[addressd]                    
						   ,[enteghal]
						   ,[dateenteghal] 
						   ,[idgeraesh]
						   ,[nobat]                   
						   ,[par]
						   ,[dav]
						   ,[name]
						   ,[sahmeh]
						   ,[university]
						   ,[jesm]
						   ,[meliat]
						   ,[end_madrak]
						   ,[din]
						   ,[resh_endmadrak]
						   ,[date_endmadrak]
						   ,[avrg_payeh]
						   ,[sal_vorod]
						   ,[date_sabtenam]
						   ,[mahal_tav]
						   ,[mahal_sodor]
						   ,[tahol]                    
                  
						  )
					 VALUES
						   (@term
						   ,@nimsal_vorod
						   ,@stcode          
						   ,@family
						   ,@namep
						   ,@idd
						   ,@idd_meli
						   ,@sex
						   ,dbo.magh2(@magh)
						   ,1
						   ,dbo.Ret_Idresh(@idreshSazman)
						   ,@date_tav
						   ,@radif_gh
						   ,@rotbeh_gh
						   ,@nomreh_gh
						   ,@code_posti
						   ,@tel           
						   ,@email
						   ,@addressd                    
						   ,1
						   ,dbo.MiladiTOShamsi(GETDATE())  
						   ,0
						   ,1		                      
						   ,@num_par
						   ,@num_davtalab
						   ,@name
						   ,@sahmeh
						   ,@university
						   ,@jesm
						   ,@meliat
						   ,@end_madrak
						   ,@fsf2_din
						   ,@resh_endmadrak
						   ,@date_endmadrak
						   ,@avrg_payeh
						   ,@sal_vorod
						   ,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8))  
						   ,@mahal_tav
						   ,@mahal_sodor
						   ,@tahol
						   )
			END
            
			------------------fsf--------------------

			--set @fsf_family=CAST(@family as varchar(40))
			if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
			BEGIN
				SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf]';
				INSERT Into amozesh.dbo.fsf (
					stcode
					,family
					,name
					,namep
					,idd
					,idd_meli
					,sex
					,dorpar
					,magh
					,idresh
					,sal_vorod
					,nimsal_vorod
					,idvazkol
					,idgeraesh
					,codebayegan
					,payed
					,idpazeresh
					,sal_mali
					,outstu
					,sabt_batakhir
					)
					values
					(
					@stcode
					,@fsf_family
					,@fsf_name
					,@fsf_namep
					,@idd
					,@idd_meli
					,@sex
					,1
					,dbo.magh2(@magh)
					,dbo.Ret_Idresh(@idreshSazman)
					,@fsf_sal_vorod
					,@nimsal_vorod
					,5
					,0
					,0
					,0
					,@fsf_idPaziresh
					,@fsf_sal_vorod
					,0
					,0
					)
					END
                    
					-------------------------fsf2--------------------------

					if not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
					begin	
						if(LEN(@date_tav)=10)
							SET @fsf2_@date_tav=cast(substring(@date_tav,3,8) as varchar(8)) 
						if(LEN(@date_tav)=9)
							SET @fsf2_@date_tav=cast(substring(@date_tav,3,7) as varchar(8)) 
						if(LEN(@date_tav)<=8)
							SET @fsf2_@date_tav=cast(substring(@date_tav,3,6) as varchar(8))
						----------

						if(LEN(@fsf2_date_endMadrak)=10)
							SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
						if(LEN(@fsf2_date_endMadrak)=9)
							SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 

						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf2]';
						Insert Into amozesh.dbo.fsf2 (
						stcode
						,date_tav 
						,end_madrak
						,university 
						,date_endmadrak 
						,resh_endmadrak 
						,mahal_tav 
						,mahal_sodor 
						,din 
						,nezam 
						,meliat
						,jesm 
						,sahmeh 
						,tahol 
						,radif_gh 
						,rotbeh_gh 
						,nomreh_gh 
						,addressd 
						,tel 
						,date_sabt
						,avrg_payeh 
						,num_davtalab 
						,num_par 
						,date_sabtenam 
						,code_posti 
						,email 
						)
						values
						(
						@stcode
						,@fsf2_@date_tav 
						,@end_madrak 
						,@university 
						,@fsf2_date_endMadrak
						,@resh_endmadrak 
						,@mahal_tav 
						,@mahal_sodor
						,@fsf2_din 
						,@fsf2_nezam 
						,@meliat
						,@jesm 
						,@sahmeh
						,@tahol 
						,@fsf2_radif_gh 
						,@fsf2_rotbeh_gh 
						,@fsf2_nomreh_gh 
						,@fsf2_addressd 
						,@tel
						,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
						,@avrg_payeh 
						,@num_davtalab 
						,@num_par 
						,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
						,@fsf2_code_posti 
						,@fsf2_email 
						)
					end
					
					------------------------- fvazejtemae --------------------------

					if(@vazejtemae>0)
					begin
						if not exists(select * from amozesh.dbo.fvazejtemae where stcode=@stcode)
							SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fvazejtemae]';
							INSERT INTO amozesh.dbo.fvazejtemae
							(
							stcode,
							vazejtemae, 
							modat, 
							code_rayane, 
							name_vazejtemae, 
							darsad_tahod, 
							sharh)
							VALUES        
							(
							@stcode,
							@vazejtemae,
							@modat,
							@code_rayane,
							@name_vazejtemae,
							@darsad_tahod,
							@sharh
							)
					END
                    
                  -------------------------amozesh.dbo.web_user------------------------------

					if not exists(select * from amozesh.dbo.web_user where stcode=@stcode)
					BEGIN
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_user]';
						insert into amozesh.dbo.web_user (stcode,password_stu,ok_sabt,ok_sabt_hazf,ctrl_bed_hazf,ctrl_bed_aval,ctrl_batakhir)
						VALUES( @stcode,@idd_meli,0,0,0,0,0 )
					END

					
					---------------------------------Supplementary.dbo.StudentLogin------------------
		if not exists(select * from Supplementary.dbo.StudentLogin where stcode=@stcode)
		BEGIN
			SET @ErrorStep = 'Error in Insert to [Supplementary].[dbo].[StudentLogin]';
			IF(@hashedPass_StudentLogin IS null) SET @hashedPass_StudentLogin=@idd_meli
			insert into Supplementary.dbo.StudentLogin (stcode,Password)
			VALUES( @stcode,@hashedPass_StudentLogin  )
		END
		--------------------------------------------------------------------------------
		
					
		COMMIT TRANSACTION tran01
		SET @MsgReturn='succuss'
	END TRY

	BEGIN CATCH
		 
		  DECLARE @ErrorMessage    NVARCHAR(max)
		  DECLARE @ErrorSeverity   INT
		  DECLARE @ErrorState      INT
			
	   IF @@TRANCOUNT > 0 
	   BEGIN
            ROLLBACK TRANSACTION tran01; 

			SET  @ErrorMessage = ERROR_MESSAGE() + ' occurred at Line_Number:[' + 
								   CAST(ERROR_LINE() AS VARCHAR(50))+ '] and error_number is : ['+
								   CAST(ERROR_NUMBER() as varchar(50)) + '] ====> ErrorStep :'+ @ErrorStep 

			SET  @ErrorSeverity = ERROR_SEVERITY()
			SET  @ErrorState    = ERROR_STATE()
			SET  @MsgReturn     = @ErrorMessage

			--SELECT @MsgReturn = @ErrorStep + 
			--						' ErrorNo == '             + cast(ERROR_NUMBER() as varchar(20)) + 
			--						'===>  ErrorLine == '      + cast(ERROR_LINE() as varchar(20)) + 
			--						'===>  ErrorMessage == '   + ERROR_MESSAGE() +
			--						'===>  ErrorProcedure == ' + ERROR_PROCEDURE()
           RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	   END	
	END CATCH
	
	SELECT @MsgReturn AS MsgReturn

END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertGuestCoursesToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_InsertGuestCoursesToSida]
	@stcode			varchar(9)
	,@did			int
	,@Term			varchar(7)
	,@PersianDate	varchar(8)
	,@Time			varchar(5)

AS
BEGIN
	--SET @Term = '95-96-2'
	DECLARE @Capacity	int = (SELECT Capacity FROM GuestCourse WHERE did = @did AND Term = @Term AND Active = 1) - 1
	DECLARE @zarfklass	int = (SELECT zarfklass FROM amozesh..ara_klas WHERE did = @did AND tterm = @Term) + 1
	DECLARE @zarfporm	int = (SELECT zarfporm FROM amozesh..ara_klas WHERE did = @did AND tterm = @Term) + 1

	INSERT INTO amozesh..vahedinterm (stcode, did, tterm, radif_sabt, typevahead, mark, idvaznom, darsad_hazf, idgroup, typejob, tamdid, datesabtv, timesabtv)
	VALUES (@stcode, @did, @Term, 1, 1, 0.00, 0, 0, 0, 0, 0, @PersianDate, @Time)
	INSERT INTO amozesh..fvahdkol (stcode, term, vazterm, reval)
	VALUES (@stcode, @Term, 1, 1)
	UPDATE amozesh..ara_klas SET zarfklass = @zarfklass, zarfporm = @zarfporm WHERE did = @did AND tterm = @Term
	
	UPDATE GuestCourse SET Capacity = @Capacity WHERE did = @did AND Term = @Term AND Active = 1
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertGuestStudentInfoToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[SP_InsertGuestStudentInfoToSida]
CREATE PROCEDURE [dbo].[SP_InsertGuestStudentInfoToSida]
@stcode VARCHAR(11)
,@name VARCHAR(30)
,@family VARCHAR(70)
,@namep VARCHAR(40)
,@idd VARCHAR(20)
,@idd_meli VARCHAR(10)
,@sex TINYINT
,@date_tav VARCHAR(8)
,@mahal_sodor NUMERIC(18,0)
,@sal_vorod VARCHAR(2)
,@nimsal_vorod TINYINT
,@universityId NUMERIC(18,0) 
--,@idresh NUMERIC(18,0) 
,@magh TINYINT
,@addressd VARCHAR(200)
,@tel VARCHAR(50)
,@email VARCHAR(70)
,@letterNumber varchar(15)
,@letterDate varchar(10)
,@examPlaceId INT
,@term         VARCHAR(7)

--,@hashedPass_web_user nvarchar(max)=NULL      --in amozesh db
,@hashedPass_StudentLogin nvarchar(max)=NULL  --in supplementary


AS
------------------fsf--------------------
BEGIN
    --DECLARE @term			NVARCHAR(10)= (SELECT termjary from amozesh.dbo.fcounter)
	DECLARE @currentDate	NVARCHAR(10)= CAST( SUBSTRING(amozesh.dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 	
	DECLARE @idresh			NUMERIC(18,0)=888
	DECLARE @typeMehman     TINYINT= 2
	DECLARE @nameTypeMehman VARCHAR(30) ='24 ماده'
	DECLARE @typeUniversity TINYINT=1
	DECLARE @exPlaceId      NUMERIC(18,0) =convert(numeric(18,0),@examPlaceId)
	DECLARE @idVazKol       NUMERIC(18,0)=2

	DECLARE @codebayegan	int = 0

	DECLARE     @ErrorStep  varchar(200)
	DECLARE		@MsgReturn  NVARCHAR(max)=''
	--DECLARE     @ErrorCode  int = @@ERROR
	
    BEGIN TRANSACTION tran01
    SAVE TRANSACTION FirstPoint_tran
	BEGIN TRY			
					if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
					BEGIN 
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf]';
						Insert Into amozesh.dbo.fsf (
						stcode
						,family
						,name
						,namep
						,idd
						,idd_meli
						,sex
						,magh
						,idresh
						,sal_vorod --96
						,nimsal_vorod --jari
						,idvazkol
						,codebayegan
						,sal_mali
						)
						values
						(
						@stcode
						,@family
						,@name
						,@namep
						,@idd
						,@idd_meli
						,@sex
						/*,@magh */ , dbo.magh2(@magh)
						,@idresh
						,@sal_vorod
						,@nimsal_vorod
						,@idVazKol
						,@codebayegan
						,@sal_vorod
						)
					END 
				---------------------------fsf2--------------------------
					if not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
					BEGIN
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf2]';
						Insert Into amozesh.dbo.fsf2 (
						stcode
						,date_tav 		
						,university 
						,mahal_sodor 
						,addressd
						,tel 
						,date_sabt
						,date_sabtenam 
						,email 
						)
						values
						(
						@stcode
						,@date_tav 
						,@universityId
						,@mahal_sodor
						,@addressd 
						,@tel
						,@currentDate
						,@currentDate
						,@email
						)
					END 

				--------------------------amozesh.dbo.webmeli_students_ExamPlace--------------------

					if  not exists(select * from amozesh.dbo.webmeli_students_ExamPlace where STCODE=@stcode)
					BEGIN 
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[webmeli_students_ExamPlace]';
						insert into amozesh.dbo.webmeli_students_ExamPlace(STCODE,TTERM,ID_EXAM_PLACE,DATE_SAVE)
						values(@stcode,@term,@exPlaceId,@currentDate)
		
					END 
					---------------------------------amozesh.dbo.web_user------------------------------

					--if not exists(select * from amozesh.dbo.web_user where stcode=@stcode)
					--BEGIN
					--	SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_user]';
					--	IF(@hashedPass_web_user IS null) SET @hashedPass_web_user=@idd_meli
					--	insert into amozesh.dbo.web_user (stcode,password_stu,ok_sabt,ok_sabt_hazf,ctrl_bed_hazf,ctrl_bed_aval,ctrl_batakhir)
					--	VALUES( @stcode,@hashedPass_web_user,0,0,0,0,0 )
					--END

					---------------------------------Supplementary.dbo.StudentLogin------------------------------
					if not exists(select * from Supplementary.dbo.StudentLogin where stcode=@stcode)
					BEGIN
						SET @ErrorStep = 'Error in Insert to [Supplementary].[dbo].[StudentLogin]';
						IF(@hashedPass_StudentLogin IS null) SET @hashedPass_StudentLogin=@idd_meli
						insert into Supplementary.dbo.StudentLogin (stcode,Password)
						VALUES( @stcode,@hashedPass_StudentLogin  )
					END


					---------------------------------amozesh.dbo.fmehman_az ------------------------------

					if not exists(select * from amozesh.dbo.fmehman_az where stcode=@stcode)
					BEGIN
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fmehman_az]';
						insert into amozesh.dbo.fmehman_az (stcode,term,typemehman,nametypemehman,num_nam,date_nam,idazkoja,idresh,idmagh,type_univer)
						VALUES(@stcode,@term,@typeMehman,@nameTypeMehman,@letterNumber,@letterDate,@universityId,@idresh,@magh,@typeUniversity )
					END	
					ELSE if exists(select * from amozesh.dbo.fmehman_az where stcode=@stcode AND (ISNULL( num_nam ,'')='' and ISNULL(date_nam ,'')='') )
                    BEGIN
						UPDATE amozesh.dbo.fmehman_az
						SET num_nam=@letterNumber ,date_nam=@letterDate WHERE stcode=@stcode
					END						
                    
					---------------------------------amozesh.dbo.mobile ------------------------------
					if not exists(select * from amozesh.dbo.mobile AS m where m.stcode=@stcode)
					BEGIN
						SET @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mobile]';
						insert into amozesh.dbo.mobile (stcode,mobile)
						VALUES(@stcode,@tel)		
					END		
		COMMIT TRANSACTION tran01
		SET @MsgReturn='succuss'
	END TRY

	BEGIN CATCH
		 
		  DECLARE @ErrorMessage NVARCHAR(max)
		  DECLARE @ErrorSeverity INT
		  DECLARE @ErrorState INT
			
	   IF @@TRANCOUNT > 0 
	   BEGIN
            ROLLBACK TRANSACTION tran01; 

			SET  @ErrorMessage = ERROR_MESSAGE() + ' occurred at Line_Number:[' + 
								   CAST(ERROR_LINE() AS VARCHAR(50))+ '] and error_number is : ['+
								   CAST(ERROR_NUMBER() as varchar(50)) + +'] ====> ErrorStep :'+ @ErrorStep 

			SET  @ErrorSeverity = ERROR_SEVERITY()
			SET  @ErrorState    = ERROR_STATE()
			SET @MsgReturn      = @ErrorMessage

			--SELECT @MsgReturn = @ErrorStep + 
			--						' ErrorNo == '             + cast(ERROR_NUMBER() as varchar(20)) + 
			--						'===>  ErrorLine == '      + cast(ERROR_LINE() as varchar(20)) + 
			--						'===>  ErrorMessage == '   + ERROR_MESSAGE() +
			--						'===>  ErrorProcedure == ' + ERROR_PROCEDURE()
           RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	   END	
	END CATCH
	
	SELECT @MsgReturn AS MsgReturn

END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoControl]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertIntoControl]

@Service_Fee int
,@Insurance_Fee int
,@StartReg_Date char(10)
,@EndReg_Date char(10)
,@AllField_FixFee bigint
,@LevelId tinyint
,@Term char(7)
,@AllField_Fix bit
,@FieldID int
,@Fix bigint
,@Variable bigint

AS
BEGIN
declare @ControlID int
-------------------------
if @AllField_Fix=1
begin
	Insert Into Control (
	Service_Fee
	,Insurance_Fee
	,StartReg_Date
	,EndReg_Date
	,AllField_FixFee
	,Term
	,LevelId
	,AllField_Fix)
	values(
	@Service_Fee
	,@Insurance_Fee
	,@StartReg_Date
	,@EndReg_Date
	,@AllField_FixFee
	,@Term
	,@LevelId
	,1)
	end
------------------------
	if @AllField_Fix=0
	begin
	Insert Into Control (
	Service_Fee
	,Insurance_Fee
	
	,AllField_FixFee
	,Term
	,LevelId
	,AllField_Fix)
	values(
	0
	,0	
	,0
	,@Term
	,@LevelId
	,0)
set @ControlID=(select @@IDENTITY as RowId)
Insert Into TuitionFee(
FeildId
,LevelId
,Fix
,Variable
,Insurance
,Service
,Term
,ControlId)
values(
@FieldID
,@LevelId
,@Fix
,@Variable
,@Insurance_Fee
,@Service_Fee
,@Term
,@ControlID)
	end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoExamPlace]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertIntoExamPlace]
@Stcode varchar(11),
@ExamPlaceID int
as
begin
if not exists(select stcode from ExamPlace where Stcode=@Stcode)
insert into ExamPlace values(@Stcode,@ExamPlaceID,dbo.MiladiTOShamsi(GETDATE()))
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoFnaghsStu]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertIntoFnaghsStu]
@stcode varchar(11),
@idnaghs int,
@date_mohlat varchar(10),
@datesabt varchar(10),
@timesabt varchar(5),
@nameuser varchar(50),
@num_naghs int
as
begin
if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@idnaghs)
insert into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
values (@stcode,@idnaghs,@date_mohlat,dbo.MiladiTOShamsi(@datesabt),@timesabt,@nameuser,@num_naghs) 
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoMoghayerat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertIntoMoghayerat]
@stcode varchar(11),
@address varchar(200),
@moghayerat_Type int
as
begin
insert  into Moghayerat (stcode,[address],moghayerat_type)  values(@stcode,@address,@moghayerat_Type)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertIntoPayment]
   @OrderID bigint,
   @AmountTrans bigint,
   @StudentCode nvarchar(250),
   @MiladiDate datetime,
   @PersianDate varchar(10),
   @TraceNumber bigint,
   @PayType tinyint
   as
   begin
   if not exists(select * from Payment where AmountTrans=@AmountTrans and RequestKey=1 and
    StudentCode=@StudentCode and TraceNumber=@TraceNumber and PayType=@PayType)
	begin
   insert into Payment 
   (OrderID,Result,AmountTrans,RequestKey,AppStatus,StudentCode,tterm,BankID,MiladiDate,PersianDate,TraceNumber,PayType) 
   values(@OrderID,0,@AmountTrans,'1','COMMIT',@StudentCode,
   (select amozesh.dbo.fcounter.termjary from amozesh.dbo.fcounter),0,@MiladiDate,@PersianDate,@TraceNumber,@PayType)
   end
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertIntoSida]
@term int
,@stcode varchar(11)
,@name varchar(30)
,@family varchar(70)
,@namep varchar(40)
,@idd varchar(20)
,@idd_meli varchar(20)
,@sex tinyint
,@magh tinyint
,@idreshSazman varchar(10)
,@sal_vorod numeric(18,0)
,@nimsal_vorod tinyint
,@date_tav varchar(10)
,@end_madrak numeric(18,0)
,@university numeric(18,0)
,@date_endmadrak varchar(8)
,@resh_endmadrak numeric(18,0)
,@mahal_tav numeric(18,0)
,@mahal_sodor numeric(18,0)


,@meliat numeric(18,0)
,@jesm numeric(18,0)
,@sahmeh numeric(18,0)
,@tahol numeric(18,0)
,@radif_gh varchar(10)
,@rotbeh_gh varchar(10)
,@nomreh_gh varchar(10)
,@addressd varchar(200)
,@tel varchar(50)
,@avrg_payeh varchar(5)
,@num_davtalab varchar(15)
,@num_par varchar(15)
,@code_posti varchar(20)
,@email varchar(70),

--------fsf
@fsf_family varchar(40)

,@fsf_name varchar(30)
,@fsf_namep varchar(25)
,@fsf_sal_vorod varchar(2)
,@fsf_idPaziresh numeric(18,0)
,@fsf_resh_mortabet int

---------fsf2
,@fsf2_date_endMadrak varchar(10)
,@fsf2_din numeric(18,0)
,@fsf2_nezam numeric(18,0)
,@fsf2_radif_gh numeric(18,0)
,@fsf2_rotbeh_gh numeric(18,0)
,@fsf2_nomreh_gh varchar(15)
,@fsf2_addressd varchar(150)
,@fsf2_email varchar(50)
,@fsf2_code_posti varchar(10)
,@fsf2_local1 varchar(1)
,@fsf2_Ostan int
,@fsf2_Shahrestan int

--Vazeejtemae
,@vazejtemae tinyint
,@modat int
,@code_rayane varchar(20)
,@name_vazejtemae  varchar(50)
,@darsad_tahod varchar(3)
,@sharh varchar(50)


AS
BEGIN --A
--------------------------------------------sahmeh sida-------------------------------
declare @sahmehSida numeric(18,0)=0
if(@sahmeh=1) 
begin
 SET @sahmehSida=15
end
if(@sahmeh=2) 
begin
 SET @sahmehSida=20
end
if(@sahmeh=3) 
begin
 SET @sahmehSida=42
end
-------------------------------------------------------------------------------
---Insert into stu-newsida

if(LEN(@fsf2_date_endMadrak)=10)
set @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
if(LEN(@fsf2_date_endMadrak)=9)
set @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 
if not exists(select * from amozesh.dbo.fnew_stu where stcode=@stcode)
BEGIN --B
INSERT INTO [amozesh].dbo.[fnew_stu]
           ([term]
           ,[vorodi]
           ,[stcode]    
           ,[family]
           ,[namep]
           ,[idd]
           ,[idd_meli]
           ,[sex]
           ,[magh]
           ,[dorpar]
           ,[idresh]
           ,[date_tav]
           ,[radif_gh]
           ,[rotbeh_gh]
           ,[nomreh_gh]
           ,[code_posti]
           ,[tel]          
           ,[email]
           ,[addressd]                    
           ,[enteghal]
           ,[dateenteghal] 
		   ,[idgeraesh]
		   ,[nobat]                   
           ,[par]
           ,[dav]
           ,[name]
		   ,[sahmeh]
		   ,[university]
		   ,[jesm]
		   ,[meliat]
		   ,[end_madrak]
		   ,[din]
		   ,[resh_endmadrak]
		   ,[date_endmadrak]
		   ,[avrg_payeh]
		   ,[sal_vorod]
           ,[date_sabtenam]
           ,[mahal_tav]
           ,[mahal_sodor]
           ,[tahol]                    
                  
          )
     VALUES
           (@term
           ,@nimsal_vorod
           ,@stcode          
           ,@family
           ,@namep
           ,@idd
           ,@idd_meli
           ,@sex
           ,dbo.magh2(@magh)
           ,1
           ,dbo.Ret_Idresh(@idreshSazman)
           ,@date_tav
           ,@radif_gh
           ,@rotbeh_gh
           ,@nomreh_gh
           ,@code_posti
           ,@tel           
           ,@email
           ,@addressd                    
           ,1
           ,dbo.MiladiTOShamsi(GETDATE())  
		   ,0
		   ,1		                      
           ,@num_par
           ,@num_davtalab
           ,@name
           ,@sahmehSida
		   ,@university
		   ,@jesm
		   ,@meliat
		   ,@end_madrak
		   ,@fsf2_din
		   ,@resh_endmadrak
          -- ,@date_endmadrak
		  ,@fsf2_date_endMadrak
           ,@avrg_payeh
		   ,@sal_vorod
           ,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8))  
           ,@mahal_tav
           ,@mahal_sodor
           ,@tahol
           )
END --B
------------------fsf--------------------
--declare @termBaygan varchar(5);
--set @termBaygan=(select term from fnewStudent where stcode=@stcode);
--declare @CodeBaygan varchar(15);
--set @CodeBaygan='0';
--if(cast(substring(@termBaygan,1,2) as int)>=94)
--begin
--set @CodeBaygan=(@fsf_sal_vorod+'-'+cast(dbo.magh2(@magh) as varchar(2))+'-'+cast((select Code_Baygan from Field where Field_ID=@idreshSazman) as varchar(10))+'-'+cast((select COUNT(amozesh.dbo.fsf.stcode)+1 from amozesh.dbo.fsf where sal_vorod=@fsf_sal_vorod and magh=dbo.magh2(@magh) and idresh=dbo.Ret_Idresh(@idreshSazman))as varchar(20)))
--end
if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
BEGIN --C
	Insert Into amozesh.dbo.fsf (
stcode
,family
,name
,namep
,idd
,idd_meli
,sex
,dorpar
,magh
,idresh
,sal_vorod
,nimsal_vorod
,idvazkol
,idgeraesh
,codebayegan
,payed
,idpazeresh
,sal_mali
,outstu
,sabt_batakhir
,resh_mortabet

)
values
(
@stcode
,@fsf_family
,@fsf_name
,@fsf_namep
,@idd
,@idd_meli
,@sex
,1
,dbo.magh2(@magh)
,dbo.Ret_Idresh(@idreshSazman)
,@fsf_sal_vorod
,@nimsal_vorod
,1
,0
,''
,0
,@fsf_idPaziresh
,@fsf_sal_vorod
,0
,0
,@fsf_resh_mortabet

)
END --C
-------------------------fsf2--------------------------
if not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
BEGIN --D
declare @fsf2_@date_tav as varchar(8)
if(LEN(@date_tav)=10)
  SET @fsf2_@date_tav=cast(substring(@date_tav,3,8) as varchar(8)) 
if(LEN(@date_tav)=9)
  SET @fsf2_@date_tav=cast(substring(@date_tav,3,7) as varchar(8)) 
if(LEN(@date_tav)<=8)
  SET @fsf2_@date_tav=cast(substring(@date_tav,3,6) as varchar(8))
--------------------------webmeli_students_ExamPlace--------------------
if not exists(select * from ExamPlace where STCODE=@stcode)
BEGIN --E

INSERT INTO ExamPlace
                         (Stcode, ID_Exam_Place, SaveDate)
VALUES        (@stcode,1,dbo.MiladiTOShamsi(GETDATE()))

END --E
if  not exists(select * from amozesh.dbo.webmeli_students_ExamPlace where STCODE=@stcode)
BEGIN --F
insert into amozesh.dbo.webmeli_students_ExamPlace(STCODE,TTERM,ID_EXAM_PLACE,DATE_SAVE)
values(@stcode,(select termjary from amozesh.dbo.fcounter),
(select ID_Exam_Place from ExamPlace where Stcode=@stcode),(select SaveDate from ExamPlace where Stcode=@stcode))
END --F
------------------------------------------------------------------

--if(LEN(@fsf2_date_endMadrak)=10)
--set @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
--if(LEN(@fsf2_date_endMadrak)=9)
--set @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 


Insert Into amozesh.dbo.fsf2 (
stcode
,date_tav 
,end_madrak
,university 
,date_endmadrak 
,resh_endmadrak 
,mahal_tav 
,mahal_sodor 
,din 
,nezam 
,meliat
,jesm 
,sahmeh 
,tahol 
,radif_gh 
,rotbeh_gh 
,nomreh_gh 
,addressd 
,addressm
,Ostan
,Shahrestan
,tel 
,date_sabt
,avrg_payeh 
,num_davtalab 
,num_par 
,date_sabtenam 
,code_posti 
,email 
,local1
)
values
(
@stcode
,@fsf2_@date_tav 
,@end_madrak 
,@university 
,@fsf2_date_endMadrak
,@resh_endmadrak 
,@mahal_tav 
,@mahal_sodor
,@fsf2_din 
,@fsf2_nezam 
,@meliat
,@jesm 
,@sahmehSida
,@tahol 
,@fsf2_radif_gh 
,@fsf2_rotbeh_gh 
,@fsf2_nomreh_gh 
,@fsf2_addressd 
,@fsf2_addressd
,@fsf2_Ostan
,@fsf2_Shahrestan
,@tel
,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
,@avrg_payeh 
,@num_davtalab 
,@num_par 
,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
,@fsf2_code_posti 
,@fsf2_email 
,@fsf2_local1
)
END --D

if(@vazejtemae>0)
BEGIN --G
if not exists(select * from amozesh.dbo.fvazejtemae where stcode=@stcode)
BEGIN --H
INSERT INTO amozesh.dbo.fvazejtemae
(
stcode,
vazejtemae, 
modat, 
code_rayane, 
name_vazejtemae, 
darsad_tahod, 
sharh)
VALUES        
(
@stcode,
@vazejtemae,
@modat,
@code_rayane,
@name_vazejtemae,
@darsad_tahod,
@sharh
)
END --H
END --D
if not exists(select stcode from amozesh.dbo.web_user where stcode=@stcode)
insert into amozesh.dbo.web_user (stcode,password_stu,ok_sabt,ok_sabt_hazf,ctrl_bed_hazf,ctrl_bed_aval,ctrl_batakhir)
select stcode,idd_meli,0,0,0,0,0 from fnewStudent where stcode=@stcode

if not exists(select stcode from amozesh.dbo.mobile where stcode=@stcode)
insert into amozesh.dbo.mobile (stcode,mobile)
select stcode,mobile from fnewStudent where  stcode=@stcode
END --A
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoSt_documents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertIntoSt_documents]
@st_code varchar(11)
,@filename nvarchar(50)
,@address varchar(200)
,@category int
,@isok int =1

AS
BEGIN
	IF NOT EXISTS(SELECT * FROM St_documents WHERE st_code = @st_code AND [filename] = @filename)
	BEGIN
			Insert Into St_documents(
			st_code
			,[filename]
			,[address]
			,category
			,Doc_Term
			,Isok
			
		)
			values(
			@st_code
			,@filename
			,@address
			,@category			
			,(select termjary from amozesh.dbo.fcounter)
			,@isok
		)
	END
	ELSE
    BEGIN
		UPDATE St_documents SET Isok=@isok WHERE st_code = @st_code AND category=@category
	END
    

END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertInToStudentRequest]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertInToStudentRequest]
@stcode varchar(11),
@ReqTypeId	int = 13

as
begin
	if not exists(select * from Supplementary.Request.Tbl_StudentRequest where RequestTypeID=@ReqTypeId and StCode=@stcode)
	begin
		insert into Supplementary.Request.Tbl_StudentRequest (StCode,RequestTypeID,RequestLogID,Erae_Be,MashmulNumber,CreateDate,Term) values(@stcode,@ReqTypeId,10,'11','',substring(dbo.MiladiTOShamsi(GETDATE()),3,8),(select termjary from amozesh.dbo.fcounter))
		select @@IDENTITY as rowId
	end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertIntoTuition]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertIntoTuition]

@Service_Fee int
,@Insurance_Fee int
,@Fee bigint
,@LevelId tinyint
,@Term char(7)
,@FieldID int


AS
BEGIN
if not exists(select * from TuitionFee where LevelId=@LevelId and FeildId=@FieldID and Term=@Term)
INSERT INTO TuitionFee
                         (FeildId, LevelId, Fee, Insurance, Service, Term)
VALUES        (@FieldID,@LevelId,@Fee,@Insurance_Fee,@Service_Fee,@Term)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNoExamDocumnet]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertNoExamDocumnet]
	  @requestId		decimal
	, @filename			nchar(100)
	, @path				nchar(100)
	, @category			int
	, @status			tinyint
	, @term				nvarchar(7)
AS
BEGIN
	INSERT INTO NoExamEntrance.Documents (requestId,[filename],[Address],category,[status],term) VALUES (@requestId,@filename,@path,@category,@status,@term)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertPaymentReciept]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertPaymentReciept]
@RecieptNum varchar(50)
,@RecieptDate varchar(10)
,@RecieptAmount varchar(20)
,@stcode varchar(11)
,@term varchar(7)

as
BEGIN
	Insert into PaymentReciept 
	(RecieptNumber
	,RecieptDate
	,RecieptAmount
	,stcode
	,SubmitDate
	,term
)
	values
(@RecieptNum
	,@RecieptDate
	,@RecieptAmount
	,@stcode
	,getDate()
	,@term
)
END


GO
/****** Object:  StoredProcedure [dbo].[SP_InsertPaymentRequest]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertPaymentRequest]
@orderId int
,@amount bigint
,@stcode varchar(11)
,@tterm varchar(7)
,@RequestKey varchar(250)
,@bankId int

, @Result int = null
, @RefNo varchar(550) = null
, @AppStatus nvarchar(70) = null
, @TraceNumber bigint = null
, @PayType tinyint = null
AS
BEGIN
Insert Into Payment ([OrderID]          
           ,[AmountTrans]
           ,[RequestKey]           
           ,[StudentCode]
           ,[tterm]
           ,[BankID]
		   ,[miladiDate]
           ,[PersianDate]
		   ,[Result]
		   ,[RetrivalRefNo]
		   ,[AppStatus]
		   ,[TraceNumber]
		   ,[PayType]
           )
		   values
		   (@orderId
		   ,@amount
		   ,@RequestKey
		   ,@stcode
		   ,@tterm
		   ,@bankId
		   ,GETDATE()
		   ,dbo.MiladiTOShamsi(GETDATE())
		   , @Result
		   , @RefNo
		   , @AppStatus
		   , @TraceNumber
		   , @PayType
		   )
END


GO
/****** Object:  StoredProcedure [dbo].[SP_InsertStudentPaymentToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertStudentPaymentToSida]
@stcode varchar(11)
,@term varchar(7)
,@serial_pay INT
,@amount money
,@numfish varchar(20)  --=TraceNumber from table payment
,@datefish varchar(10) 
--,@typepay int
AS
BEGIN
declare @df as varchar(8)
if(LEN(@datefish)=10)
	SET @df=cast(substring(@datefish,3,8) as varchar(8)) 
if(LEN(@datefish)=9)
	SET @df=cast(substring(@datefish,3,7) as varchar(8)) 
if(LEN(@datefish)<=8)
	SET @df=@datefish

--declare @typepaySida int
--if(@typepay=1 or @typepay=2)
--set @typepaySida=1
--if(@typepay=3)
--set @typepaySida=71

--select * from amozesh.dbo.payinterm where stcode='940195940' AND numfish=''

if not exists(select * from amozesh.dbo.payinterm where stcode=@stcode AND numfish=@numfish)
Insert into amozesh.dbo.payinterm(
stcode
--,serial_pay --auto increament
,tterm
,idtypepay
,amount
,numfish
,datefish)
values
(
@stcode
--,@serial_pay --auto increament
,@term
,1
,@amount
,@numfish
,@df
)
END

--EXEC  [dbo].[SP_InsertStudentPaymentToSida] '940195940','94-95-1',12920000,'102940224336','93/06/29'

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertToWebMsgStu]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertToWebMsgStu]
@stcode varchar(11),
@id_naghs INT ,
@inserted_id_fornaghs int=-1 output
as
begin
if exists(SELECT * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)
BEGIN

		insert into amozesh.dbo.web_msg_stu (stcode,sharh) 
		VALUES(@stcode,(case(@id_naghs)
							WHEN 1 
							then ('دانشجوی گرامی کپی روی کارت ملی شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 
							
							WHEN 2 
							then ('دانشجوی گرامی صفحه اول شناسنامه شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							WHEN 3 
							then('دانشجوی گرامی صفحه دوم شناسنامه شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد')
  
							when 4 
							then ('دانشجوی گرامی صفحه آخر شناسنامه شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 
 
							WHEN 6
							then ('دانشجوی گرامی مدرک نظام وظیفه شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 
							
							 
							WHEN 8 
							then ('دانشجوی گرامی عکس شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							WHEN 9 
							then ('دانشجوی گرامی نامه موافقت از یگان شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 
							
							WHEN 21 
							then ('دانشجوی گرامی مدرک سهمیه شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							WHEN 28
							then ('دانشجوی گرامی کپی پشت کارت ملی شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد')
							
							WHEN 35 
							then ('دانشجوی گرامی مدرک تحصیلی شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							WHEN 40 
							then ('دانشجوی گرامی برگه معافیت تحصیلی شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							
							WHEN 42 
							then ('دانشجوی گرامی جوابیه نامه معافیت شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 

							WHEN 43 
							then ('دانشجوی گرامی نامه بهزیستی شما در پرونده موجود نیست مهلت تحویل تا تاریخ'+' '+(select date_mohlat from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs)+' '+'می باشد') 


					end) )
		 SET @inserted_id_fornaghs=SCOPE_IDENTITY()--need to save in st_documents table in initial db
		 PRINT @inserted_id_fornaghs
 
		END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LoginNewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_LoginNewStudent]
 @idd_meli varchar(20)='0'
,@family nvarchar(70)='0'
,@dav varchar(15)='0'
,@idd varchar(20)='0'

,@par varchar (15)='0'
,@term  INT=0

AS
BEGIN
declare
@cmd varchar(8000)
set @cmd = 'Select stcode,status,magh,permitted from fnewStudent '
IF (@idd_meli <> '0' and @idd <>'0')
set @cmd = @cmd + 'where idd='''+@idd+''' AND '+'idd_meli='''+@idd_meli + '''' + 'AND status not in(11,12,13)'

else if  (@idd_meli <> '0' and @dav <>'0')
set @cmd = @cmd + 'where dav='''+@dav+''' AND idd_meli='''+@idd_meli+ ''''+ 'AND status not in(11,12,13)'

else if (@idd_meli<> '0' and @family<>'0')
set @cmd = @cmd + 'where family='''+@family+''' AND idd_meli='''+@idd_meli+ ''''+ 'AND status not in(11,12,13)'

ELSE IF(@par<>'0' AND @term<>0)
set @cmd = @cmd + 'where par='''+@par+''' AND SUBSTRING(CAST(term AS NVARCHAR(10)),1,2 )='''  + CAST(@term AS VARCHAR(10))  + ''''+'AND status not in(11,12,13)'

exec (@cmd)

END



 --SELECT * FROM dbo.fnewStudent ns  WHERE  (status<8 or status=9) AND ns.idd_meli='4250354369' AND ns.dav='112053'    ORDER BY ns.term DESC 
 --exec [dbo].[SP_LoginNewStudent] '0' ,'0', '0', '0', '18476' ,95  
 --exec [dbo].[SP_LoginNewStudent] '4250354369' ,'0', '112053', '0', '0' ,0  
 --SELECT SUBSTRING(CAST(term AS NVARCHAR(10)),1,2 ) FROM dbo.fnewStudent
GO
/****** Object:  StoredProcedure [dbo].[SP_PermitStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[SP_PermitStudent]
	@idd_melli varchar(10)
	,@permitted bit
AS
BEGIN
	update fnewStudent set permitted=@permitted where idd_meli=@idd_melli
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Preview_Docs]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Preview_Docs]
@StCode varchar(11)
as
begin
SELECT        St_documents.st_code, St_documents.filename, St_documents.address
              , St_documents.category, St_documents.Isok, St_documents.Note, St_documents.Doc_Term                         
			  ,st_Documents_category.DocName, St_Doc_Status.DocStatus, St_documents.id, St_documents.RegistrationConfirm
FROM            St_documents INNER JOIN
                         st_Documents_category ON St_documents.category = st_Documents_category.id INNER JOIN
                         St_Doc_Status ON St_documents.Isok = St_Doc_Status.id
WHERE        (St_documents.st_code = @StCode)
ORDER BY St_documents.category asc
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_AllCategoriesCount]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_AllCategoriesCount]
@DaneshID int,
@Term varchar(7)
as
begin
if @DaneshID=0
begin
select Field_Name as nameresh,case St_documents.Isok when 1 then 'در حال بررسی' when 2 then 'دارای نقص' when 3 then'تایید نهایی' when 4 then 'تایید مشروط' when 5 then'تایید اولیه' end as DocStatus
,case St_documents.category when 1 then'عکس پرسنلی' when 2 then 'کارت ملی(روی تصویر)' when 3 then'کارت ملی(پشت تصویر)' when 4 then'شناسنامه (صفحه اول و دوم)' 
when 5 then'شناسنامه (صفحه سوم و چهارم)' when 6 then'شناسنامه (صفحه پنجم و ششم)' when 7 then'پشت کارت سهمیه' when 8 then'وضعیت نظام وظیفه(روی مدرک)' 
when 9 then'وضعیت نظام وظیفه(پشت مدرک)' when 10 then 'سهمیه' when 11 then'ریز نمرات' when 12 then'مدرک تحصیلی' when 13 then'قبض پرداخت' end as DocName from Field left join fnewStudent
on fnewStudent.idreshSazman=Field.Field_ID left join St_documents
on fnewStudent.stcode=St_documents.st_code 
where  fnewStudent.status>2 and Doc_Term=@Term
end
if @DaneshID>0
begin
select nameresh,case St_documents.Isok when 1 then 'در حال بررسی' when 2 then 'دارای نقص' when 3 then'تایید نهایی' when 4 then 'تایید مشروط' when 5 then'تایید اولیه' end as DocStatus
,case St_documents.category when 1 then'عکس پرسنلی' when 2 then 'کارت ملی(روی تصویر)' when 3 then'کارت ملی(پشت تصویر)' when 4 then'شناسنامه (صفحه اول و دوم)' 
when 5 then'شناسنامه (صفحه سوم و چهارم)' when 6 then'شناسنامه (صفحه پنجم و ششم)' when 7 then'پشت کارت سهمیه' when 8 then'وضعیت نظام وظیفه(روی مدرک)' 
when 9 then'وضعیت نظام وظیفه(پشت مدرک)' when 10 then 'سهمیه' when 11 then'ریز نمرات' when 12 then'مدرک تحصیلی' when 13 then'قبض پرداخت' end as DocName from amozesh.dbo.fresh left join fnewStudent
on fnewStudent.idreshSazman=fresh.codesazman left join St_documents
on fnewStudent.stcode=St_documents.st_code  left join amozesh.dbo.fgroup
ON amozesh.dbo.fgroup.id=amozesh.dbo.fresh.idgroup
where  fnewStudent.status>2 AND amozesh.dbo.fgroup.iddanesh=@DaneshID and Doc_Term=@Term
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_AllStudentStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_Report_AllStudentStatus]
@DaneshID int,
@term varchar(7)

as
begin
if @DaneshID=0
begin
select fnewStudent.stcode, fnewstudent.status,St_Status,Field_Name as nameresh,EduLevel.name as levelName from fnewStudent 
left join St_Status on St_Status.Status_ID=fnewstudent.status 

left join Field on
fnewStudent.idreshSazman=Field.Field_ID
  left join
 EduLevel ON EduLevel.Id_sazman=fnewStudent.magh 
 where stcode in(select stcode from studentlog where term=@term) and stcode not in(select stcode from amozesh.dbo.fnew_stu where date_sabtenam<'94/11/01')
 union
 (select fnewStudent.stcode, fnewstudent.status,St_Status,Field_Name as nameresh,EduLevel.name as levelName from fnewStudent 
left join St_Status on St_Status.Status_ID=fnewstudent.status 

left join Field on
fnewStudent.idreshSazman=Field.Field_ID
  left join
 EduLevel ON EduLevel.Id_sazman=fnewStudent.magh where fnewStudent.DataEnterDate>'1394/11/01' and status=0)
  order by status
--select distinct fnewStudent.stcode, Field_Name as nameresh,fnewstudent.status,St_Status,Status_ID
--,EduLevel.name as levelName,StudentLog.EnterDate
-- from  Field left join 
--fnewStudent on fnewStudent.idreshSazman=Field.Field_ID
-- left join St_Status on fnewStudent.status=St_Status.Status_ID left join
-- EduLevel ON EduLevel.Id_sazman=fnewStudent.magh left join StudentLog
-- on StudentLog.Stcode=fnewStudent.stcode
-- where Field_ID in (select idreshSazman from fnewStudent) and StudentLog.term=@term
-- order by StudentLog.EnterDate desc
--(select distinct sl2.Stcode as stcode,sl2.Status as status,St_Status,sl2.EnterDate,sl2.EnterTime,Field_Name as nameresh,EduLevel.name as levelName
-- from
--(
--select stcode,max(sl.EnterDate+sl.EnterTime) EnterDate,Term
--from StudentLog sl
--group by stcode,Term
--having term=@term) as a
--left join StudentLog sl2 on a.Stcode=sl2.Stcode
--and sl2.Term=a.Term and sl2.EnterDate=SUBSTRING(a.EnterDate,1,10) and sl2.EnterTime=SUBSTRING(a.EnterDate,11,8)
--left join St_Status on St_Status.Status_ID=sl2.status 
-- left join 
--fnewStudent on sl2.Stcode=fnewStudent.stcode
--left join Field on
--fnewStudent.idreshSazman=Field.Field_ID
--  left join
-- EduLevel ON EduLevel.Id_sazman=fnewStudent.magh
--)
--UNION
--(select distinct fnewStudent.stcode,fnewstudent.status,St_Status,'','', Field_Name as nameresh
--,EduLevel.name as levelName
-- from  Field left join 
--fnewStudent on fnewStudent.idreshSazman=Field.Field_ID
-- left join St_Status on fnewStudent.status=St_Status.Status_ID left join
-- EduLevel ON EduLevel.Id_sazman=fnewStudent.magh 
-- where Field_ID in (select idreshSazman from fnewStudent) and fnewStudent.term=SUBSTRING(@term,1,2)+SUBSTRING(@term,7,1)
--  and (status=0 or status>7)
--)
  end
  if @DaneshID>0
begin

 select distinct fnewStudent.stcode,fnewstudent.status,St_Status,'','', nameresh
,EduLevel.name as levelName
 from  amozesh.dbo.fresh left join 
fnewStudent on fnewStudent.idreshSazman=amozesh.dbo.fresh.codesazman
 left join St_Status on fnewStudent.status=St_Status.Status_ID left join
 EduLevel ON EduLevel.Id_sazman=fnewStudent.magh 
 where codesazman in (select idreshSazman from fnewStudent) and stcode in(select stcode from studentlog where term=@term) and stcode not in(select stcode from amozesh.dbo.fnew_stu where date_sabtenam<'94/11/01')
  and iddanesh=@DaneshID
UNION
(select distinct fnewStudent.stcode,fnewstudent.status,St_Status,'','', nameresh
,EduLevel.name as levelName
 from  amozesh.dbo.fresh left join 
fnewStudent on fnewStudent.idreshSazman=amozesh.dbo.fresh.codesazman
 left join St_Status on fnewStudent.status=St_Status.Status_ID left join
 EduLevel ON EduLevel.Id_sazman=fnewStudent.magh 
 where codesazman in (select idreshSazman from fnewStudent) and fnewStudent.DataEnterDate>'1394/11/01' and status=0
  and iddanesh=@DaneshID
)
 order by status
  end
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Report_ByFieldMagh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_Report_ByFieldMagh]
@magh tinyint,
@idresh numeric(18),
@salvorood varchar(2)
as
begin
select stcode,name,family,idd_meli from amozesh.dbo.fsf 
where magh=@magh and idresh=@idresh and sal_vorod=@salvorood
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_CommitPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_Report_CommitPayment]
@term varchar(10)
as
begin
SELECT        OrderID, AmountTrans, StudentCode, tterm, PersianDate, TraceNumber, CardNumber,
 AppStatus,Field_Name as nameresh,fnewStudent.name,family,mobile,idd_meli,magh,EduLevel.name maghName
FROM            Payment left join
fnewStudent ON fnewStudent.stcode=Payment.StudentCode left join 
Field ON fnewStudent.idreshSazman=Field.Field_ID left join EduLevel on EduLevel.Id_sazman=magh
where idreshSazman in(select Field_ID from Field)  AND AppStatus='COMMIT' and tterm=@term
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_PersonalInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_PersonalInfo]
@iddanesh int
as
begin
if @iddanesh=0
begin
SELECT        stcode,Field.Field_Name as nameresh, name, family,mobile, namep, idd, idd_meli, idreshSazman,category
,st_Documents_category.DocName,DocStatus,Field_1.Field_Name as resh, fnewStudent.email
FROM            St_documents left join
fnewStudent ON St_documents.st_code=fnewStudent.stcode left join
st_Documents_category ON st_Documents_category.id=St_documents.category left join
St_Doc_Status ON St_Doc_Status.id=St_documents.Isok left join
Field ON Field.Field_ID=fnewStudent.idreshSazman  left join
 Field AS Field_1 ON fnewStudent.resh_endmadrak = Field_1.Field_ID

end
if @iddanesh>0
begin
SELECT        stcode, name, family, namep, idd,mobile, idd_meli,fresh.nameresh,amozesh.dbo.fgroup.namegroup
              idreshSazman,category,st_Documents_category.DocName,DocStatus,Field_1.Field_Name as resh, fnewStudent.email
FROM            St_documents left join
fnewStudent ON St_documents.st_code=fnewStudent.stcode left join
amozesh.dbo.fresh ON fresh.codesazman=fnewStudent.idreshSazman left join
amozesh.dbo.fgroup ON fgroup.id=amozesh.dbo.fresh.idgroup left join
st_Documents_category ON st_Documents_category.id=St_documents.category left join
St_Doc_Status ON St_Doc_Status.id=St_documents.Isok left join
 Field AS Field_1 ON fnewStudent.resh_endmadrak = Field_1.Field_ID
where  amozesh.dbo.fgroup.iddanesh=@iddanesh 
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_ReceiptPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_ReceiptPayment]
@Status int
as
begin
SELECT        RecieptID, RecieptNumber, RecieptAmount, PaymentReciept.stcode, SubmitDate, RecieptDate
              ,name,family,idd_meli,mobile,fdanesh.namedanesh
FROM            PaymentReciept left join 
fnewStudent ON fnewStudent.stcode=PaymentReciept.stcode left join
amozesh.dbo.fresh ON fnewStudent.idreshSazman=fresh.codesazman left join
amozesh.dbo.fgroup ON fresh.idgroup=fgroup.id left join
amozesh.dbo.fdanesh ON fgroup.iddanesh=fdanesh.id
where PaymentReciept.stcode in(select st_code from St_documents where Isok=@Status AND category=13)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_StCodeByStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_StCodeByStatus]
@Status int,
@DaneshID int
as
begin
if @DaneshID=0
begin
SELECT        fnewStudent.stcode, fnewStudent.name, fnewStudent.family, fnewStudent.idd, fnewStudent.idd_meli, fnewStudent.mobile, fnewStudent.tel, 
                         fnewStudent.idreshSazman, fnewStudent.status, nameresh
FROM            fnewStudent left JOIN
                          amozesh.dbo.fresh ON fnewStudent.idreshSazman = fresh.codesazman
WHERE        (fnewStudent.status = @Status)
end
if @DaneshID>0
begin
SELECT        fnewStudent.stcode, fnewStudent.name, fnewStudent.family, fnewStudent.idd, fnewStudent.idd_meli, fnewStudent.mobile, fnewStudent.tel, 
                         fnewStudent.idreshSazman, fnewStudent.status, nameresh
FROM            fnewStudent left JOIN
                         amozesh.dbo.fresh ON fnewStudent.idreshSazman = fresh.codesazman left join
						 amozesh.dbo.fgroup ON fgroup.id=fresh.idgroup 
WHERE        (fnewStudent.status = @Status) AND amozesh.dbo.fgroup.iddanesh=@DaneshID
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_StDocInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_StDocInfo]
@iddanesh int,
@Frmcategory int,
@Tocategory int,
@term varchar(10)
as
begin
if @iddanesh=0
begin
SELECT        stcode,nameresh, name, family,mobile, namep, idd, idd_meli, idreshSazman,category,
st_Documents_category.DocName,DocStatus,Note,address,name, fnewStudent.email,fnewStudent.term, case when fnewStudent.magh = 3 then 'کارشناسی ارشد' when fnewStudent.magh = 2 then 'کارشناسی' end as 'Magh'
FROM            St_documents left join
fnewStudent ON St_documents.st_code=fnewStudent.stcode left join
st_Documents_category ON st_Documents_category.id=St_documents.category left join
St_Doc_Status ON St_Doc_Status.id=St_documents.Isok left join
amozesh.dbo.fresh ON fresh.codesazman=fnewStudent.idreshSazman 
right join (select distinct studentcode from Payment where AppStatus='COMMIT' and tterm=@term and PayType<4) as tbl on fnewStudent.stcode = tbl.StudentCode
where category>=@Frmcategory AND category<=@Tocategory and (fnewStudent.status>=4 and fnewStudent.status!=8 and fnewStudent.status!=10)
--and stcode in(select studentcode from Payment where AppStatus='COMMIT' and tterm=@term and PayType<4)

end
if @iddanesh>0
begin
SELECT        stcode,nameresh, name, family,mobile, namep, idd, idd_meli, idreshSazman,category,
st_Documents_category.DocName,DocStatus,Note,address,name, fnewStudent.email,fnewStudent.term, case when fnewStudent.magh = 3 then 'کارشناسی ارشد' when fnewStudent.magh = 2 then 'کارشناسی' end as 'Magh'
FROM            St_documents left join
fnewStudent ON St_documents.st_code=fnewStudent.stcode left join
st_Documents_category ON st_Documents_category.id=St_documents.category left join
St_Doc_Status ON St_Doc_Status.id=St_documents.Isok left join
amozesh.dbo.fresh ON fresh.codesazman=fnewStudent.idreshSazman 
right join (select distinct studentcode from Payment where AppStatus='COMMIT' and tterm=@term and PayType<4) as tbl on fnewStudent.stcode = tbl.StudentCode
where  

category>=@Frmcategory AND category<=@Tocategory and 
(fnewStudent.status>=4 and fnewStudent.status!=8 and fnewStudent.status!=10) 
--and stcode in(select studentcode from Payment where AppStatus='COMMIT' and tterm=@term and PayType<4)
AND fnewStudent.idreshSazman in(select codesazman from amozesh.dbo.fresh where iddanesh=@iddanesh) 
end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_StSahmieDocInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_StSahmieDocInfo]
@Frmcategory int,
@Tocategory int,
@term varchar(10)
as
begin

SELECT        stcode,nameresh, name, family,mobile, namep, idd, idd_meli, idreshSazman,category,
st_Documents_category.DocName,DocStatus,Note,address,name, fnewStudent.email
FROM            St_documents left join
fnewStudent ON St_documents.st_code=fnewStudent.stcode left join
st_Documents_category ON st_Documents_category.id=St_documents.category left join
St_Doc_Status ON St_Doc_Status.id=St_documents.Isok left join
amozesh.dbo.fresh ON fresh.codesazman=fnewStudent.idreshSazman 
where (category=@Frmcategory OR category=@Tocategory) and Doc_Term=@term
end


GO
/****** Object:  StoredProcedure [dbo].[SP_Report_Student_Log]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Report_Student_Log]
@stcode varchar(11)
,@MeliCode varchar(11) 
as
begin
if(@MeliCode='0')
SELECT        StudentLog.id, StudentLog.Stcode, StudentLog.EnterDate, StudentLog.EnterTime, StudentLog.Event, StudentLog.Status, EventName.EventName
FROM            StudentLog INNER JOIN
                         EventName ON StudentLog.Event = EventName.id
WHERE        (StudentLog.Stcode = @stcode)
if(@MeliCode<>'0')
SELECT        StudentLog.id, StudentLog.Stcode, StudentLog.EnterDate, StudentLog.EnterTime, StudentLog.Event, StudentLog.Status, EventName.EventName
FROM            StudentLog INNER JOIN
                         EventName ON StudentLog.Event = EventName.id LEFT OUTER JOIN
                         fnewStudent ON fnewStudent.stcode = StudentLog.Stcode
WHERE        (idd_meli = @MeliCode)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Rollback_GuestStudentDocs_InsertedToDida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Rollback_GuestStudentDocs_InsertedToDida]
@stcode VARCHAR(11)
AS
BEGIN
	--DECLARE @stcode NVARCHAR(10)='940195940'
	DECLARE @res INT=0;
	IF(EXISTS(SELECT * FROM amozesh.dbo.vahedinterm v WHERE v.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.vahedinterm	where stcode=@stcode
		SET @res=@res+1
	end
	--=============================================================================1

	IF(EXISTS(SELECT * FROM amozesh.dbo.payinterm	p WHERE p.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.payinterm WHERE stcode=@stcode
		SET @res=@res+1
	END
    --=============================================================================2

	IF(EXISTS(SELECT * FROM amozesh.dbo.fmehman_az m WHERE m.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fmehman_az WHERE stcode=@stcode
		SET @res=@res+1
	END

    --=============================================================================5

	IF(EXISTS(SELECT * FROM amozesh.dbo.webmeli_students_ExamPlace x WHERE x.STCODE=@stcode	))
	begin
		DELETE from amozesh.dbo.webmeli_students_ExamPlace  WHERE STCODE=@stcode
		SET @res=@res+1
	END
    --=============================================================================6

	IF(EXISTS(SELECT * FROM amozesh.dbo.fvazejtemae v WHERE v.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fvazejtemae	where stcode=@stcode
		SET @res=@res+1
	end
	--=============================================================================7

	IF(EXISTS(SELECT * FROM amozesh.dbo.web_user wu WHERE wu.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.web_user WHERE stcode=@stcode
		SET @res=@res+1
	end
	--=============================================================================8

	IF(EXISTS(SELECT * FROM amozesh.dbo.mobile m WHERE m.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.mobile WHERE stcode=@stcode
		SET @res=@res+1
	END
	

	IF(EXISTS(SELECT * FROM amozesh.dbo.ffraghat ff  WHERE ff.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.ffraghat WHERE stcode=@stcode
		SET @res=@res+1
	END
	
	--=============================================================================4

	IF(EXISTS(SELECT * FROM amozesh.dbo.fsf2 f2 WHERE f2.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fsf2 WHERE stcode=@stcode
		SET @res=@res+1
	END

	--=============================================================================3

	IF(EXISTS(SELECT * FROM amozesh.dbo.fsf f WHERE f.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fsf	WHERE stcode=@stcode
		SET @res=@res+1
	end
    --=============================================================================
	RETURN @res
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Rollback_StudentDocs_InsertedToDida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Rollback_StudentDocs_InsertedToDida]
@stcode VARCHAR(11)
AS
BEGIN
	--DECLARE @stcode NVARCHAR(10)='940195940'
	DECLARE @res INT=0;
	
	--=============================================================================1

	IF(EXISTS(SELECT * FROM amozesh.dbo.payinterm	p WHERE p.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.payinterm WHERE stcode=@stcode
		SET @res=@res+1
	END
    
	IF(EXISTS(SELECT * FROM [Supplementary].[Request].[Tbl_StudentRequest] WHERE stcode=@stcode AND [RequestLogID] = 25 AND [RequestTypeID] in (13,16))
	OR EXISTS(SELECT * FROM amozesh..payinterm WHERE stcode=@stcode AND idtypepay=68)
	)
	BEGIN
		UPDATE Payment SET AppStatus = 'RETURNED' WHERE StudentCode = @stcode
	END
	ELSE
	BEGIN
		UPDATE [Supplementary].[Request].[Tbl_StudentRequest] SET [RequestLogID] = 5 WHERE stcode=@stcode AND [RequestTypeID] in (13,16) AND [RequestLogID] != 25
	END

    --=============================================================================5

	IF(EXISTS(SELECT * FROM amozesh.dbo.webmeli_students_ExamPlace x WHERE x.STCODE=@stcode	))
	begin
		DELETE from amozesh.dbo.webmeli_students_ExamPlace  WHERE STCODE=@stcode
		SET @res=@res+1
	END
    --=============================================================================6

	IF(EXISTS(SELECT * FROM amozesh.dbo.fvazejtemae v WHERE v.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fvazejtemae	where stcode=@stcode
		SET @res=@res+1
	end
	--=============================================================================7

	IF(EXISTS(SELECT * FROM amozesh.dbo.web_user wu WHERE wu.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.web_user WHERE stcode=@stcode
		SET @res=@res+1
	end
	--=============================================================================8

	IF(EXISTS(SELECT * FROM amozesh.dbo.mobile m WHERE m.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.mobile WHERE stcode=@stcode
		SET @res=@res+1
	END
	

	IF(EXISTS(SELECT * FROM amozesh.dbo.ffraghat ff  WHERE ff.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.ffraghat WHERE stcode=@stcode
		SET @res=@res+1
	END
	
	--=============================================================================
	IF(EXISTS(SELECT * FROM amozesh.dbo.log_bedehi_ent_vahed m WHERE m.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.log_bedehi_ent_vahed WHERE stcode=@stcode
		SET @res=@res+1
	END
	--=============================================================================

	--=============================================================================4

	IF(EXISTS(SELECT * FROM amozesh.dbo.fsf2 f2 WHERE f2.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fsf2 WHERE stcode=@stcode
		SET @res=@res+1
	END

	--=============================================================================3

	IF(EXISTS(SELECT * FROM amozesh.dbo.fsf f WHERE f.stcode=@stcode	))
	begin
		DELETE from amozesh.dbo.fsf	WHERE stcode=@stcode
		SET @res=@res+1
	end
    --=============================================================================
	RETURN @res
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SearchNoExamRequestFromNewStudents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SearchNoExamRequestFromNewStudents]
	  @nationalCode	nvarchar(10)
	, @idNo			nvarchar(10)
	, @field		decimal(18, 0)
AS
BEGIN
	SELECT * FROM fnewStudent
	WHERE idd=@idNo
	AND idd_meli=@nationalCode
	AND status IN (4,5,6,7,9)
	AND magh = 2
	--AND idreshSazman = @field--in (20312, 20453, 20915, 20573, 21103, 20481, 20505, 21301, 20531, 20706, 20530, 20381, 20101, 20394, 20328, 20329, 20334, 20311, 20202, 20612, 20517, 20812, 20429, 20454, 20410, 20333, 20511, 21329, 21207, 21209, 21210, 21211, 21260, 21245, 20510, 21602, 41054)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Select_Field]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_Select_Field]
@idd_meli varchar(10)
as
begin
SELECT        fnewStudent.stcode, fnewStudent.idreshSazman, Field.Field_Name,fnewStudent.status
FROM            fnewStudent INNER JOIN
                         Field ON fnewStudent.idreshSazman = Field.Field_ID
WHERE        (fnewStudent.idd_meli = @idd_meli)
end

GO
/****** Object:  StoredProcedure [dbo].[SP_SendSMSAfterPaymentCommit]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SendSMSAfterPaymentCommit]
@stcode varchar(11)
AS
BEGIN
select distinct f.stcode,f.email,f.mobile,'دانشجوی گرامی'+ case when sex=1 then ' جناب آقای ' when sex=2 then ' سرکار خانم ' END
+CONVERT(nvarchar(max), f.family) + ' با سلام، ضمن خوش آمدگویی به شما '
 +'مدارک ارسالی شما توسط کارشناسان معاونت آموزشی واحد حداکثر تا 72 ساعت پس از ثبت نام بررسی خواهد شد و شما می توانید با ورود به سامانه ثبت نام الکترونیکی واحد به آدرس '
+'http://reg.iauec.ac.ir ' +'از نتیجه آن مطلع شوید'+'معاونت فنی واحد الکترونیکی دانشگاه آزاداسلامی ' as smsText
from fnewStudent f

where stcode=@stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SetGuestRequestStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SetGuestRequestStatus]
	@ID		int,
	@Status	int
AS
BEGIN
	UPDATE GuestStudentsInfo SET RequestStatus = @Status WHERE ID = @ID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SetGuestStudentLetterInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SetGuestStudentLetterInfo]
	@LetterDate varchar(10),
	@LetterNo	varchar(15),
	@stcode		varchar(10),
	@Term		varchar(7)
AS
BEGIN
	UPDATE GuestStudentsInfo
	SET LetterNo = @LetterNo, LetterDate = @LetterDate
	WHERE stcode = @stcode
	AND RequestTerm = @Term
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SetNoExamRequestDiscountId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SetNoExamRequestDiscountId]
	@reqId		decimal(18, 0),
	@discountId	int
AS
BEGIN
	UPDATE NoExamEntrance.Request SET DiscountId = @discountId where id = @reqId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SetPaymentStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_SetPaymentStatus]
@OrderID bigint
,@Status varchar(70)
as
BEGIN
UPDATE Payment SET  AppStatus=@Status ,TransMiladiDate=GETDATE() 
where OrderId=@OrderID and AppStatus != 'TRANSFERRED'
end
GO
/****** Object:  StoredProcedure [dbo].[SP_SetRegistrationStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SetRegistrationStatus]
	@stcode		varchar(9),
	@status		int,
	@category	int,
	@comment	nvarchar(max)
AS
BEGIN
	UPDATE St_documents SET RegistrationConfirm = @status, Note = @comment WHERE st_code = @stcode AND category = @category
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SetTraceNumber]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_SetTraceNumber]
@TraceNumber bigint
,@OrderId bigint
as
BEGIN
	UPDATE Payment
	SET TraceNumber = @TraceNumber
	WHERE OrderID = @OrderId and AppStatus != 'TRANSFERRED'
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Show_Compose_Request_ChangeFiled]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Show_Compose_Request_ChangeFiled]
as
begin
SELECT        RequestChangeField.RequestID, RequestChangeField.iddMeli, RequestChangeField.OldField, RequestChangeField.NewField, 
                         RequestChangeField.ComposeOrReply, RequestChangeField.UserId, RequestChangeField.RequestText,
                         RequestChangeField.StatusRequest, RequestChangeField.RequestDate
						 , RequestChangeField.IsRead,Field.Field_Name as NewField,' رشته قبلی: '+ Field_1.Field_Name+' --- '+' رشته جدید: '+ Field.Field_Name as requestDetail
						 ,case when ComposeOrReply=1 then 'درخواست' when ComposeOrReply=2 then 'پاسخ' end as RequestType
						 ,case when StatusRequest=1 then 'در حال بررسی' when StatusRequest=2 then 'تایید درخواست' when StatusRequest=3 then 'رد درخواست' end as statusText
FROM            RequestChangeField INNER JOIN
                         Field ON RequestChangeField.NewField = Field.Field_ID LEFT OUTER JOIN
                         Field AS Field_1 ON RequestChangeField.OldField = Field_1.Field_ID
where ComposeOrReply=1 and IsRead=0 and StatusRequest=1
end
GO
/****** Object:  StoredProcedure [dbo].[SP_SHow_Help]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_SHow_Help]
@TypeId int
as
begin
select * from help
where TypeId=@TypeId
order by rowID 
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Show_help_CMS]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Show_help_CMS]
as
begin
select id,HelpBodyText,RowID ,[dbo].[pagetype](TypeID) as typeid from Help
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Show_RequestChangeFiel_ByiddMeli]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Show_RequestChangeFiel_ByiddMeli]
 @iddMeli varchar(15)='0'
,@parNo varchar(20)='0'
,@salAzmoon varchar(20)='0'

as
begin
SELECT        RequestChangeField.RequestID, RequestChangeField.iddMeli, RequestChangeField.OldField, RequestChangeField.NewField, 
                         RequestChangeField.ComposeOrReply, RequestChangeField.UserId, RequestChangeField.RequestText,
                         RequestChangeField.StatusRequest, RequestChangeField.RequestDate
						 , RequestChangeField.IsRead,Field.Field_Name as NewField,' :رشته قبلی '+ Field_1.Field_Name+' :رشته جدید '+ Field.Field_Name+'  ' as requestDetail
						 ,case when ComposeOrReply=1 then 'درخواست' when ComposeOrReply=2 then 'پاسخ' end as RequestType
						 ,case when StatusRequest=1 then 'در حال بررسی' when StatusRequest=2 then 'تایید درخواست' when StatusRequest=3 then 'رد درخواست' end as statusText
						 ,OldStcode,NewStcode
FROM            RequestChangeField INNER JOIN Field ON RequestChangeField.NewField = Field.Field_ID 
                                   LEFT OUTER JOIN Field AS Field_1 ON RequestChangeField.OldField = Field_1.Field_ID
						
						  WHERE ComposeOrReply=2  AND IsRead=0
							AND(iddMeli=@iddMeli OR @iddMeli='0'  ) 
							AND					  
							(
								 ( SalAzmoon=@salAzmoon  OR @salAzmoon='0' ) AND
								 (CodeParvandeh=@parNo OR @parNo='0') 
							 )
END

--EXEC [SP_Show_RequestChangeFiel_ByiddMeli] '1467472077','0','0'
--EXEC [SP_Show_RequestChangeFiel_ByiddMeli] '0','1102684','93'
--EXEC [SP_Show_RequestChangeFiel_ByiddMeli] '9999999999','0','0' --atbae khareji
--EXEC [SP_Show_RequestChangeFiel_ByiddMeli] '0','806298','93'
--EXEC [SP_Show_RequestChangeFiel_ByiddMeli] '0','912006','93'

--SELECT * FROM dbo.fnewStudent f WHERE f.idd_meli='1467472077'
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_amozpic]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[SP_Update_amozpic]
CREATE procedure [dbo].[SP_Update_amozpic]
@stcode varchar(11),
@type numeric(18,0),
@docimage image
 as
 begin
 if exists(select stcode from amozpic.dbo.doc_image where stcode=@stcode and id_scan=@type)
 begin
		update amozpic.dbo.doc_image
		set doc_image=@docimage,date_scan=Cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8))
		where stcode=@stcode and id_scan=@type
end
if not exists(select stcode from amozpic.dbo.doc_image where stcode=@stcode and id_scan=@type)
begin
insert into amozpic.dbo.doc_image
(id_scan,stcode,doc_image,deleted,name_karbar,date_scan,time_scan)
values(
@type,@stcode,@docimage,0,(select name+' '+family from fnewStudent where stcode=@stcode),Cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)),'')
end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Update_fnewstudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Update_fnewstudent]
@moghayerat_type int,
@stcode varchar(11),
@name varchar(30),
@family varchar(70),
@namep varchar(40),
@idd varchar(20),
@idd_meli varchar(20),
@sex tinyint
as
begin

if (@moghayerat_type=1)
 begin
 update fnewStudent set name=@name where stcode=@stcode
 end
 if (@moghayerat_type=2)
 begin
 update fnewStudent set family=@family where stcode=@stcode
 end
if(@moghayerat_type=3)
 begin
 update fnewStudent set namep=@namep where stcode=@stcode
 end
if(@moghayerat_type=4)
 begin
 update fnewStudent set idd=@idd where stcode=@stcode
 end
if(@moghayerat_type=5)
 begin
 update fnewStudent set idd_meli=@idd_meli where stcode=@stcode
 end
if(@moghayerat_type=6)
 begin
 update fnewStudent set sex=@sex where stcode=@stcode
 end
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_fnewstudentStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_fnewstudentStatus]
@stcode varchar(11)
as
begin
Update fnewStudent set status=10 where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_IdVazekole_ChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_IdVazekole_ChangeField]
@stcode varchar(11)
as 
begin
update amozesh.dbo.fsf
set idvazkol=3
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_IDvazkolFSF]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_IDvazkolFSF]
@stcode varchar(11)
as
begin
update amozesh.dbo.fsf set idvazkol=5 where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_IsReadRequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[SP_Update_IsReadRequestChangeField]
@requestId int
as
begin
update RequestChangeField
set IsRead=1
where RequestID=@requestId
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Moghayerat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Update_Moghayerat]
@stcode varchar(11),
@moghayerat_type int,
@eslahat varchar(200)
as
begin
 UPDATE  Moghayerat
 set eslahat=@eslahat
 where stcode=@stcode and moghayerat_type=@moghayerat_type
 end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Payment_Bystcode_ChageField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Update_Payment_Bystcode_ChageField]
@stcodeNew varchar(11)
,@stcodeOld varchar(11)
as
begin
update Payment
set StudentCode=@stcodeNew
where StudentCode=@stcodeOld
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Payment_RollbacktoCommit]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Update_Payment_RollbacktoCommit]
@OrderID bigint	
as
BEGIN
UPDATE Payment SET  AppStatus='COMMIT' ,TransMiladiDate=GETDATE() 
where OrderId=@OrderID and AppStatus != 'TRANSFERRED'
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_RequestChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_RequestChangeField]
@status int,
@requestText varchar(700),
@userId int,
@RequestID int
as
begin
update RequestChangeField
set IsRead=1,StatusRequest=@status,RequestText=@requestText,UserId=@userId
where RequestID=@RequestID
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Setting]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_Setting]
@query varchar(max)
as
begin
declare @q varchar(max);
set @q='update setting set '+@query
exec(@q)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_StudentLog]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_StudentLog]
@EnterTime varchar(8),
@id int
as
begin
UPDATE       StudentLog
SET                EnterTime = @EnterTime
WHERE        (id = @id)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_wrongMoghayerat]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_Update_wrongMoghayerat]
@wrong varchar(70),
@stcode varchar(11),
@moghayerat_type int
as
begin
Update Moghayerat set wrong=@wrong
where stcode=@stcode and moghayerat_type=@moghayerat_type
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateFnaghsAndExamplace]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateFnaghsAndExamplace]
@NewStcode varchar(11),
@PrevStcode varchar(11)
as
begin

if exists(select stcode from amozesh.dbo.fnaghs_stu where STCODE=@PrevStcode)
update amozesh.dbo.fnaghs_stu set stcode=@NewStcode where stcode=@PrevStcode 
end


GO
/****** Object:  StoredProcedure [dbo].[SP_UpdatefnewSahmie]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdatefnewSahmie]
@stcode varchar(11)
as
begin
update fnewStudent set janbazi_darsad=0, janbazi_nesbat=0, janbaz_rayaneh=0, azadeh_modat=0,sahmeh=0
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdatefnewStateWelfare]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdatefnewStateWelfare]
	@stcode varchar(9)
AS
BEGIN
	UPDATE fnewStudent
	SET StateWelfare = 0, StateWelfareLetter = NULL, StateWelfareLetterDate = NULL, StateWelfareState = NULL, DisabilityType = NULL
	WHERE stcode=@stcode
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateGuestStudentDocs_ReqStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_UpdateGuestStudentDocs_ReqStatus]( @stcode  NVARCHAR(10),@catId INT , @DocStatus TINYINT,@term NVARCHAR(10),@note NVARCHAR(max))
AS
BEGIN
	UPDATE dbo.GuestStudentsDocs 
	SET 
	DocumentStatus=@DocStatus
	,Note =@note
	WHERE stcode=@stcode AND CategoryId=@catId AND DocTerm=@term
END

GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateGuestStudentInfo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROC Sp_UpdateGuestStudentInfo

CREATE PROCEDURE [dbo].[Sp_UpdateGuestStudentInfo](
	 --@ID                   INT
	 @stcode               NVARCHAR(10)
	,@FirstName            NVARCHAR(50)
	,@LastName             NVARCHAR(50)
	,@FatherName           NVARCHAR(50)
	,@IdNo			       DECIMAL(18,0)			
	,@NationalCode         NCHAR(10)
	,@BirthDate            NVARCHAR(50)
	,@IssuePlace           INT
	,@Email			       VARCHAR(100) 
	,@Mobile		       NVARCHAR(50)
	,@UniversityId         INT
	,@ExamPlaceId          INT
	,@FieldId		       INT
	,@LevelId		       INT	
	,@RequestStatus        TINYINT
	,@EntranceYear         NVARCHAR(10)
	,@Gender			   TINYINT
	
)
AS
BEGIN	 
	UPDATE  InitialRegistration.dbo.GuestStudentsInfo
		 SET 		
		 stcode				 =@stcode
		 ,FirstName			 =@FirstName
		 ,LastName			 =@LastName
		 ,FatherName	     =@FatherName
		 ,IdNo				 =@IdNo
		 ,NationalCode		 =@NationalCode
		 ,BirthDate			 =@BirthDate
		 ,IssuePlace		 =@IssuePlace
		 ,Email				 =@Email
		 ,Mobile			 =@Mobile
		 ,UniversityId		 =@UniversityId
		 ,ExamPlaceId		 =@ExamPlaceId
		 ,FieldId			 =@FieldId
		 ,LevelId			 =@LevelId		
		 ,RequestStatus		 =@RequestStatus
		 ,EntranceYear  	 =@EntranceYear 
		 ,Gender			 =@Gender

WHERE stcode=@stcode
							
end



GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateGuestStudentInfo_ReqStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_UpdateGuestStudentInfo_ReqStatus]( @stcode  NVARCHAR(10),@RequestStatus TINYINT,@Note nvarchar(max) )
AS
BEGIN
	UPDATE dbo.GuestStudentsInfo 
	SET 
	 RequestStatus=@RequestStatus
	,Note=@Note
	WHERE stcode=@stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateHelpBodyText]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_UpdateHelpBodyText]
@id int,
@HelpBodyText varchar(max)
as
begin
update Help set HelpBodyText=@HelpBodyText where id=@id
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateMellatPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateMellatPayment]
	@OrderID bigint	
	,@RefID varchar(550)
	,@Status varchar(50)
	,@SaleRef bigint
	,@ResCode int
	,@StCode varchar(11) = ''
	,@PayType int = 0
	,@Amount bigint = 0
	,@PersianDate varchar(10) = ''
	--,@TraceNumber bigint = 0
AS
BEGIN
IF(@StCode <> '')
BEGIN
	UPDATE Payment
	SET RetrivalRefNo=@RefID , AppStatus=@Status , Result=@ResCode , TraceNumber=@SaleRef, PayType = @PayType, AmountTrans = @Amount, PersianDate = @PersianDate
	WHERE OrderId=@OrderID AND StudentCode = @StCode
END
ELSE
BEGIN
	UPDATE Payment
	SET RetrivalRefNo=@RefID , AppStatus=@Status , Result=@ResCode , TraceNumber=@SaleRef
	WHERE OrderId=@OrderID
END

SELECT StudentCode FROM Payment WHERE RequestKey=@RefID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateMellatPaymentNoExam]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateMellatPaymentNoExam]
	@id				decimal(18,0)
	, @appStatus	nvarchar(20)
	, @payType		int
	, @amount		decimal(18,0)
	, @traceNumber	bigint
	, @resCode		decimal(18,0)
AS
BEGIN
	UPDATE NoExamEntrance.Payment SET AppStatus = @appStatus, PayType = @payType, Amount = @amount, TraceNumber = @traceNumber, Result = @resCode WHERE id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateMellatPaymentNoExamAppStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateMellatPaymentNoExamAppStatus]
	@id				decimal(18,0)
	, @appStatus	nvarchar(20)
AS
BEGIN
	UPDATE NoExamEntrance.Payment SET AppStatus = @appStatus WHERE id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateNoExamRequestStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateNoExamRequestStatus]
	  @reqId	decimal(18,0)
	, @status		tinyint
AS
BEGIN
	UPDATE NoExamEntrance.Request SET Status = @status where id = @reqId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateNoteInstDoc]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateNoteInstDoc]
@stcode varchar(11)
as
begin
update St_documents set Note='چک/سفته ضمانت تحویل داده شد' where category=12 and st_code=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSahmeh]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_UpdateSahmeh]
@stcode varchar(11)
as
begin
update fnewStudent set sahmeh=0 where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSidaCustom]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateSidaCustom]
	@stcode	varchar(10),
	@Fields	nvarchar(max)
AS
BEGIN
	DECLARE @Qry varchar(max) = 'UPDATE fsf SET ' + @Fields + ' WHERE stcode = ' + @stcode
	EXECUTE sp_executesql @Qry
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSidaStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateSidaStatus]
	@stcode  varchar(50),
	@status	 int

AS
BEGIN
	update amozesh.dbo.fsf set idvazkol = @status where stcode = @stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSt_documents]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateSt_documents]
@id int
,@filename nvarchar(50)
,@address varchar(200)
,@category int
,@Isok int
,@Note ntext

AS
BEGIN
 


	update St_documents
	set
	[filename]=@filename
	,[address]=@address
	,category=@category
	,Isok=@Isok
	,Note=@Note
	,Doc_Term=(select termjary from amozesh.dbo.fcounter)

	where id=@id
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSt_documents_By_ChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_UpdateSt_documents_By_ChangeField]
@id int
,@filename nvarchar(50)
,@address varchar(200)
,@category int
,@Isok int
,@Note ntext
,@stcode varchar(11)
AS
BEGIN
 


	update St_documents
	set
	[filename]=@filename
	,[address]=@address
	,category=@category
	,Isok=@Isok
	,Note=@Note
	,st_code=@stcode
	where id=@id
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStateWelfareLetter]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateStateWelfareLetter]
	  @stcode					varchar(9)
	, @StateWelfareLetter		varchar(50)
	, @StateWelfareLetterDate	varchar(10)
	, @StateWelfareState		int
	, @DisabilityType			int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE fnewStudent
	SET StateWelfareLetter = @StateWelfareLetter
	, StateWelfareLetterDate = @StateWelfareLetterDate
	, StateWelfareState = @StateWelfareState
	, DisabilityType = @DisabilityType
	WHERE stcode = @stcode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStcodeInExamPlace]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateStcodeInExamPlace]
@stcodeprev varchar(11),
@NewSTCODE varchar(11)
as
begin
if not exists (select stcode from ExamPlace where Stcode=@NewSTCODE)
update ExamPlace set Stcode=@NewSTCODE where Stcode=@stcodeprev
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentAllDocsStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateStudentAllDocsStatus]
	@StCode varchar(11),
	@DocStatus int
AS
BEGIN
	UPDATE St_documents set Isok = @DocStatus where st_code = @StCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentGender]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[SP_UpdateStudentGender]
@stcode varchar(11)
,@gender int
AS
BEGIN
	update fnewStudent set sex=@gender where stcode=@stcode;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentInfoBystCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rais Rohani	
-- alter date: 93/05/16
-- Description:	Select Student Info
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateStudentInfoBystCode]
		@stcode varchar(11)
	  ,@date_tav  varchar(50)     
      ,@code_posti varchar(20)
      ,@tel varchar(50)
      ,@mobile  varchar(20)
      ,@email  varchar(70)
      ,@Province tinyint
      ,@City  int
      ,@addressd  varchar(200)
      ,@mahal_tav  numeric(18,0)
      ,@mahal_sodor  numeric(18,0)
      ,@tahol numeric(18,0)
      ,@end_madrak  numeric(18,0)
      ,@din  numeric(18,0)
      ,@resh_endmadrak  numeric(18,0)
      ,@date_endmadrak  varchar(10)
      ,@avrg_payeh  varchar(5)
      ,@sahmeh  numeric(18,0)
      ,@university  numeric(18,0)
      ,@bomi  numeric(18,0)
      ,@jesm  numeric(18,0)
      ,@meliat  numeric(18,0) 
      ,@janbazi_darsad  tinyint
      ,@janbazi_nesbat  varchar(50)
      ,@janbaz_rayaneh varchar(20)
      ,@azadeh_modat  int
      ,@nezamvazife  int
      ,@mahal_khedmat  int
	  ,@job  varchar(200)
	  ,@sahmeh_Ostan varchar(50)
	  ,@StateWelfare	int = 0
	  ,@StateWelfareLetter	varchar(50) = null
	  ,@StateWelfareLetterDate varchar(10) = null
	  ,@StateWelfareState	int = null
	  ,@DisabilityType		int = null
	  ,@IsEmployed	bit
	  ,@UniversityType		int = null

	  ,@JobType				int = null
	  ,@JobTime				int = null
	  ,@JobContract			int = null
	  ,@JobPosition			int = null
	  ,@ConnectionType		int = null
	  ,@JobProvince			int = null
	  ,@JobCity				int = null
	  ,@JobAddress			nvarchar(200) = null
	  ,@JobTel				varchar(50) = null
	  ,@JobPostalcode		varchar(20) = null

	  ,@SpouseFirstName		varchar(30)	 = null
	  ,@SpouseLastName		varchar(70)	 = null
	  ,@SpouseIsEmployed	bit	 = null
	  ,@SpouseJobTitle		varchar(200) = null
	  ,@Accessories			varchar(50) = null
	  ,@InternetProvider	int = null
	  ,@IntroductionMethod	int = null
	  ,@LocalFacilities		varchar(50)	 = null
	  ,@LocalFacilityUnit	int = null

	  ,@ReligionBranch		int = null

	  ,@SimultaneousEntrance	int = null
	  ,@SimultaneousField		int = null
	  ,@SimultaneousLevel		int = null
	  ,@SimultaneousUni			int = null
	  ,@SimultaneousUniType		int = null
	  ,@SimultaneousStudy		bit = 0

AS
BEGIN
	  
       

UPDATE [dbo].[fnewStudent]
   SET 
    
      date_tav=@date_tav     
      ,code_posti=@code_posti 
      ,tel=@tel 
      ,mobile=@mobile  
      ,email=@email  
      ,Province=@Province 
      ,City=@City  
      ,addressd=@addressd  
      ,mahal_tav=@mahal_tav  
      ,mahal_sodor=@mahal_sodor  
      ,tahol=@tahol 
      ,end_madrak=@end_madrak  
      ,din=@din  
      ,resh_endmadrak=@resh_endmadrak 
      ,date_endmadrak=@date_endmadrak  
      ,avrg_payeh=@avrg_payeh   
      ,sahmeh=@sahmeh  
      ,university=@university  
      ,bomi=@bomi 
      ,jesm=@jesm 
      ,meliat=@meliat      
      ,janbazi_darsad=@janbazi_darsad  
      ,janbazi_nesbat=@janbazi_nesbat  
      ,janbaz_rayaneh=@janbaz_rayaneh 
      ,azadeh_modat=@azadeh_modat  
      ,nezamvazife=@nezamvazife  
      ,mahal_khedmat=@mahal_khedmat  
	  ,job=@job
	  ,sahmeh_Ostan=@sahmeh_Ostan
	  ,StateWelfare = @StateWelfare
	  ,StateWelfareLetter = @StateWelfareLetter
	  ,StateWelfareLetterDate = @StateWelfareLetterDate
	  ,StateWelfareState = @StateWelfareState
	  ,DisabilityType = @DisabilityType
	  ,IsEmployed = @IsEmployed
	  ,UniversityType = @UniversityType
	  ,JobProvince = @JobProvince
	  ,JobCity = @JobCity
	  ,JobAddress = @JobAddress
	  ,JobTel = @JobTel
	  ,JobPostalcode = @JobPostalcode
	  ,JobType=@JobType
	  ,JobTime=@JobTime
	  ,JobContract=@JobContract
	  ,JobPosition=@JobPosition
	  ,ConnectionType=@ConnectionType
	  ,SpouseFirstName=@SpouseFirstName
	  ,SpouseLastName=@SpouseLastName
	  ,SpouseIsEmployed=@SpouseIsEmployed
	  ,SpouseJobTitle=@SpouseJobTitle
	  ,Accessories=@Accessories
	  ,InternetProvider=@InternetProvider
	  ,IntroductionMethod=@IntroductionMethod
	  ,LocalFacilities=@LocalFacilities
	  ,LocalFacilityUnit = @LocalFacilityUnit

	  ,ReligionBranches = @ReligionBranch

	  ,SimultaneousEntrance = @SimultaneousEntrance
	  ,SimultaneousField = @SimultaneousField
	  ,SimultaneousLevel = @SimultaneousLevel
	  ,SimultaneousUni = @SimultaneousUni
	  ,SimultaneousUniType = @SimultaneousUniType
	  ,SimultaneousStudy = @SimultaneousStudy

 
 WHERE stcode=@stcode

END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentInfoOnChangeField]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateStudentInfoOnChangeField]
	@Idd_meli varchar(10),
	@IdResh varchar(10),
	@stcode varchar(9) = ''
AS
BEGIN
	if((select count(*) from fnewStudent where idd_meli = @Idd_meli and status not in(8,10)) > 1)
begin
	if(@stcode = '')
	begin
		if((select top 1 idreshSazman from fnewStudent where idd_meli = @Idd_meli and status not in(8,10) order by status desc) <> @IdResh)
		begin
			declare @oldStCode varchar(11) = (select top 1 stcode from fnewStudent where idd_meli = @Idd_meli and status not in(8,10) order by status desc)
			update f1
			set
			f1.addressd = f2.addressd,
			f1.avrg_payeh = f2.avrg_payeh,
			f1.azadeh_modat = f2.azadeh_modat,
			f1.bomi = f2.bomi,
			f1.City=f2.City,
			f1.code_posti=f2.code_posti,
			f1.date_endmadrak=f2.date_endmadrak,
			f1.date_sabtenam=f2.date_sabtenam,
			f1.date_tav=f2.date_tav,
			f1.dateenteghal=f2.dateenteghal,
			f1.din=f2.din,
			f1.dip_avrg=f2.dip_avrg,
			f1.email=f2.email,
			f1.end_madrak=f2.end_madrak,
			f1.enteghal=f2.enteghal,
			f1.ersal_name=f2.ersal_name,
			f1.family=f2.family,
			f1.janbaz_rayaneh=f2.janbaz_rayaneh,
			f1.janbazi_darsad = f2.janbazi_darsad,
			f1.janbazi_nesbat = f2.janbazi_nesbat,
			f1.jesm= f2.jesm,
			f1.job=f2.job,
			f1.khedmat_add = f2.khedmat_add,
			f1.magh = f2.magh,
			f1.mahal_khedmat = f2.mahal_khedmat,
			f1.mahal_sodor = f2.mahal_sodor,
			f1.mahal_tav = f2.mahal_tav,
			f1.meliat = f2.meliat,
			f1.mobile = f2.mobile,
			f1.name = f2.name,
			f1.namep = f2.namep,
			f1.nezamvazife = f2.nezamvazife,
			f1.nobat = f2.nobat,
			f1.ozv_basij = f2.ozv_basij,
			f1.ozv_lib = f2.ozv_lib,
			f1.Province = f2.Province,
			f1.resh_endmadrak = f2.resh_endmadrak,
			f1.resh_mortabet = f2.resh_mortabet,
			f1.sahmeh = f2.sahmeh,
			f1.sahmeh_Ostan = f2.sahmeh_Ostan,
			f1.sal_vorod = f2.sal_vorod,
			f1.sex = f2.sex,
			f1.[status] = f2.[status],
			f1.stcodeTemp = f2.stcodeTemp,
			f1.tahol = f2.tahol,
			f1.tel = f2.tel,
			f1.university = f2.university,
			f1.vorodi = f2.vorodi,
			f1.year_tav = f2.year_tav
			from fnewStudent f1, (select top 1 * from fnewStudent where idd_meli = @Idd_meli and status not in(8,10) order by status desc) f2
			where f1.idd_meli = @Idd_meli and f1.idreshSazman = @IdResh

			select @oldStCode
		end
	end
	else
	begin
		update f1
			set
			f1.addressd = f2.addressd,
			f1.avrg_payeh = f2.avrg_payeh,
			f1.azadeh_modat = f2.azadeh_modat,
			f1.bomi = f2.bomi,
			f1.City=f2.City,
			f1.code_posti=f2.code_posti,
			f1.date_endmadrak=f2.date_endmadrak,
			f1.date_sabtenam=f2.date_sabtenam,
			f1.date_tav=f2.date_tav,
			f1.dateenteghal=f2.dateenteghal,
			f1.din=f2.din,
			f1.dip_avrg=f2.dip_avrg,
			f1.email=f2.email,
			f1.end_madrak=f2.end_madrak,
			f1.enteghal=f2.enteghal,
			f1.ersal_name=f2.ersal_name,
			f1.family=f2.family,
			f1.janbaz_rayaneh=f2.janbaz_rayaneh,
			f1.janbazi_darsad = f2.janbazi_darsad,
			f1.janbazi_nesbat = f2.janbazi_nesbat,
			f1.jesm= f2.jesm,
			f1.job=f2.job,
			f1.khedmat_add = f2.khedmat_add,
			f1.magh = f2.magh,
			f1.mahal_khedmat = f2.mahal_khedmat,
			f1.mahal_sodor = f2.mahal_sodor,
			f1.mahal_tav = f2.mahal_tav,
			f1.meliat = f2.meliat,
			f1.mobile = f2.mobile,
			f1.name = f2.name,
			f1.namep = f2.namep,
			f1.nezamvazife = f2.nezamvazife,
			f1.nobat = f2.nobat,
			f1.ozv_basij = f2.ozv_basij,
			f1.ozv_lib = f2.ozv_lib,
			f1.Province = f2.Province,
			f1.resh_endmadrak = f2.resh_endmadrak,
			f1.resh_mortabet = f2.resh_mortabet,
			f1.sahmeh = f2.sahmeh,
			f1.sahmeh_Ostan = f2.sahmeh_Ostan,
			f1.sal_vorod = f2.sal_vorod,
			f1.sex = f2.sex,
			f1.[status] = f2.[status],
			f1.stcodeTemp = f2.stcodeTemp,
			f1.tahol = f2.tahol,
			f1.tel = f2.tel,
			f1.university = f2.university,
			f1.vorodi = f2.vorodi,
			f1.year_tav = f2.year_tav
			from fnewStudent f1, (select top 1 * from fnewStudent where idd_meli = @Idd_meli and status not in(8,10) order by status desc) f2
			where f1.stcode = @stcode

			select @stcode
	end
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentPayment]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateStudentPayment]
@Result int
,@RetrivalRefNo varchar(550)
,@AppStatus nvarchar(70)
--,@MiladiDate datetime
--,@PersianDate varchar(20)
,@TraceNumber bigint
--,@CardHolder nvarchar(350)
--,@CardNumber varchar(30)
,@RequestKey nvarchar(250)
AS
BEGIN
	update Payment set 
	Result=@Result
	,RetrivalRefNo=@RetrivalRefNo
	,AppStatus=@AppStatus
	--,TransMiladiDate=@MiladiDate
	--,TransPersianDate=@PersianDate
	,TraceNumber=@TraceNumber
	--,CardHolder=@CardHolder
	--,CardNumber=@CardNumber

	where RequestKey=@RequestKey
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentStatus]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateStudentStatus]
@stcode varchar(11)
,@status int
AS
BEGIN
	update fnewStudent set [status]=@status
	where stcode=@stcode
	if(@status=6 or @status=9 or @status=7)
	begin
		if not exists(select * from StudentLog where Stcode=@stcode and StudentLog.Status=@status)
		begin
			declare @eventId int;
			set @eventId = CASE (@status)
				when 6 then 41 
				when 7 then 34 
				when 9 then 42 
			end;			
			
			INSERT INTO StudentLog(Stcode, EnterDate, EnterTime, Event, Status, term)
			VALUES  (@stcode,dbo.MiladiTOShamsi(getdate()),CONVERT(VARCHAR(8),GETDATE(),108),@eventId,@status,(select termjary from amozesh.dbo.fcounter))
	
		end
	end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStudentStatusAndMobile]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateStudentStatusAndMobile]
@stcode varchar(11)
,@status int
,@mobile varchar(20)
AS
BEGIN
	update fnewStudent set [status]=@status, mobile=@mobile
	where stcode=@stcode
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateUserLogin]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateUserLogin]
	@Name				varchar(50)
	,@UserName			varchar(50)
	,@Password			varchar(300)
	,@RoleID			int
	,@SectionId			int
	,@ShowAccessTomenu	bit
	,@UserId			int
AS
BEGIN
	UPDATE UserLogin
	SET UserName = @UserName, Name = @Name, [Password] = @Password, RoleID = @RoleID, SectionId = @SectionId, ShowAccessTomenu = @ShowAccessTomenu
	WHERE UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_User_ChangePassword]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_User_ChangePassword]
@Pass varchar(300),
@UserId int
as
begin
UPDATE       UserLogin
SET                Password = @Pass
WHERE        (UserId = @UserId)
end
GO
/****** Object:  StoredProcedure [dbo].[SP_UserLogin]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UserLogin]
@UserName varchar(50)

as
begin
SELECT        UserId, UserName, Password, RoleID, SectionId, Name,Enable,ShowAccessTomenu
FROM            UserLogin
WHERE        (UserName = @UserName)
end
GO
/****** Object:  StoredProcedure [dbo].[stp_GetStcodeFieldBy_ParNo]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP PROC [dbo].[SP_GetStcodeFieldBy_ParNo]

CREATE procedure [dbo].[stp_GetStcodeFieldBy_ParNo]
    @parNo varchar(10) --='374709'
   ,@salAzmoon int
   ,@GetAll	bit = 0
AS
BEGIN 

	SELECT  
	  ns.stcode
	 , ns.idreshSazman
	 , ns.vorodi
	 ,'سال '+SUBSTRING(cast(ns.term as varchar(3)),1,2)+'-'+case SUBSTRING(cast(ns.term as varchar(3)),3,1) when '1' then 'پذیرش مهر' when '2' then'پذیرش بهمن' end +' - '+l.name+' - '+f.Field_Name as Field_Name
	 ,ns.status
	 ,f.Field_Name as resh
	FROM fnewStudent ns
	  inner join  Field f on f.Field_ID=ns.idreshSazman
	  left join EduLevel l on l.Id_sazman=ns.magh
	   where ns.par=@parNo AND (SUBSTRING(CAST(ns.term AS NVARCHAR(10)),1,2 ))=@salAzmoon and magh <> 6 and ((@GetAll = 0 AND status not in (8,10,11,12)) OR @GetAll = 1)
	   order by status DESC
END

--EXEC [dbo].[stp_GetStcodeFieldBy_ParNo] '374709',95
GO
/****** Object:  StoredProcedure [dbo].[stp_GetStdCodeByNationalCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[stp_GetStdCodeByNationalCode]
@idd_meli			varchar(50)
,@FilterByStatus	bit
as
begin
select * from fnewStudent where idd_meli=@idd_meli
	and (
	(	@FilterByStatus = 1
		and [status] not in (8,10,11,12,13)
	) OR @FilterByStatus = 0
	)
		
order by status desc
END

--select * from fnewStudent where idd_meli='4250354369'
--EXEC [dbo].[stp_GetStdCodeByNationalCode] '4250354369'

GO
/****** Object:  StoredProcedure [dbo].[stp_GetStudentInfoBy_ShomareParvande_SalTavalod]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_GetStudentInfoBy_ShomareParvande_SalTavalod]
@parNo varchar(15),
@salAzmoon int
AS
BEGIN

 SELECT * FROM dbo.fnewStudent ns WHERE ns.par=@parNo AND (SUBSTRING(CAST(ns.term AS NVARCHAR(10)),1,2 ))=@salAzmoon --and [status] <> 8
END

--EXEC stp_GetStudentInfoBy_ShomareParvande_SalTavalod '374709',95

GO
/****** Object:  StoredProcedure [dbo].[stp_GetStudentInfoParams]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[SP_Get_StudentInfoByIddMeli]

CREATE procedure [dbo].[stp_GetStudentInfoParams]
 @iddMeli varchar(20)='0'
,@parNo varchar(20)='0'
,@salAzmoon INT=0
as
BEGIN
declare
@cmd varchar(8000)
SET @cmd='select * from fnewStudent  '
IF (@iddMeli <> '0')
set @cmd = @cmd + 'where status not in(8,10) and idd_meli='+@iddMeli +'order by Status desc'
ELSE IF(@parNo<>'0' AND @salAzmoon<>0 )
set @cmd = @cmd + 'where status not in(8,10) and  par='+@parNo +
                  'and  SUBSTRING(CAST(term AS NVARCHAR(10)),1,2 )='+CAST(@salAzmoon AS VARCHAR(10))+
				  'order by Status desc'



EXEC(@cmd)

END

--SELECT * from fnewStudent ns WHERE  ns.par='18476' AND SUBSTRING(CAST(ns.term AS NVARCHAR(10)),1,2 )=95

--EXEC [dbo].[stp_GetStudentInfoParams] '0','18476','95'
GO
/****** Object:  StoredProcedure [dbo].[stp_InsertIntoSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_InsertIntoSida]
@term int
,@stcode varchar(11)
,@name varchar(30)
,@family varchar(70)
,@namep varchar(40)
,@idd varchar(20)
,@idd_meli varchar(20)
,@sex tinyint
,@magh tinyint
,@idreshSazman varchar(10)
,@sal_vorod numeric(18,0)
,@nimsal_vorod tinyint
,@date_tav varchar(10)
,@end_madrak numeric(18,0)
,@university numeric(18,0)
,@date_endmadrak varchar(8)
,@resh_endmadrak numeric(18,0)
,@mahal_tav numeric(18,0)
,@mahal_sodor numeric(18,0)
,@meliat numeric(18,0)
,@jesm numeric(18,0)
,@sahmeh numeric(18,0)
,@tahol numeric(18,0)
,@radif_gh varchar(10)
,@rotbeh_gh varchar(10)
,@nomreh_gh varchar(10)
,@addressd varchar(200)
,@tel varchar(50)
,@avrg_payeh varchar(5)
,@num_davtalab varchar(15)
,@num_par varchar(15)
,@code_posti varchar(20)
,@email varchar(70),

--------fsf
@fsf_family varchar(40)
,@fsf_name varchar(30)
,@fsf_namep varchar(25)
,@fsf_sal_vorod varchar(2)
,@fsf_idPaziresh numeric(18,0)
,@fsf_resh_mortabet int

---------fsf2
,@fsf2_date_endMadrak varchar(10)
,@fsf2_din numeric(18,0)
,@fsf2_nezam numeric(18,0)
,@fsf2_radif_gh numeric(18,0)
,@fsf2_rotbeh_gh numeric(18,0)
,@fsf2_nomreh_gh varchar(15)
,@fsf2_addressd varchar(150)
,@fsf2_email varchar(50)
,@fsf2_code_posti varchar(10)
,@fsf2_local1 varchar(1)
,@fsf2_Ostan int
,@fsf2_Shahrestan int

--Vazeejtemae
,@vazejtemae tinyint
,@modat int
,@code_rayane varchar(20)
,@name_vazejtemae  varchar(50)
,@darsad_tahod varchar(3)
,@sharh varchar(50) 

,@tarikhmohlat NVARCHAR(20)
,@userId INT=-1
,@pic image
,@id_scan numeric(18,0) 
,@ip NVARCHAR(30) 
,@computer_name NVARCHAR(100)

,@StateWelfare INT=0

--,@hashedPass_web_user nvarchar(max)=NULL      --in amozesh db
,@hashedPass_StudentLogin nvarchar(max)=NULL  --in supplementary

--,@Return_Message nvarchar(max) OUTPUT

AS
BEGIN --A
--------------------------------------------------------
	
    DECLARE     @ErrorStep  varchar(200)
    DECLARE     @ErrorCode  int                      
	DECLARE     @Return_Message NVARCHAR(max) 

	DECLARE     @tarikhsabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS DATE ) AS NVARCHAR(20)),0,11)
	DECLARE     @zamansabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS TIME ) AS NVARCHAR(20)),0,6)   
	--PRINT @tarikhsabt
	--PRINT @zamansabt
	
	DECLARE     @id_naghs1 INT=1     --کپی کارت ملی
	DECLARE     @id_naghs2 INT=2	 --صفحه اول شناسنامه
	DECLARE     @id_naghs3 INT=3	 --صفحه دوم شناسنامه
	DECLARE     @id_naghs4 INT=4	 --صفحه اخر شناسنامه
	DECLARE     @id_naghs6 INT=6	 --مدرک نظام وظیفه
	DECLARE     @id_naghs7 INT=7	 --ریز نمرات
	DECLARE     @id_naghs8 INT=8	 --عکس
	DECLARE     @id_naghs9 INT=9	 --نامه موافقت از یگان
	DECLARE     @id_naghs21 INT=21	 --مدرک سهمیه
	DECLARE     @id_naghs28 INT=28	 --پشت کارت ملی
	DECLARE     @id_naghs35 INT=35	 --مدرک تحصیلی
	DECLARE     @id_naghs40 INT=40	 --برگه معافیت تحصیلی
	DECLARE     @id_naghs42 INT=42	 --جواب نامه معافیت
	DECLARE     @id_naghs43 INT=43	 --نامه بهزیستی
									 --
	DECLARE     @num_naghs1 INT=1	 --تعداد عکس هایی که برای این تایپ باید در پرونده وجود داشته باشد
	DECLARE     @num_naghs5 INT=5	 --	

	-- return id from amozesh.dbo.web_msg_stu  after insert
	DECLARE     @id_naghs1_msg  BIGINT =-1   --کپی کارت ملی
	DECLARE     @id_naghs2_msg  BIGINT =-1 	 --صفحه اول شناسنامه
	DECLARE     @id_naghs3_msg  BIGINT =-1 	 --صفحه دوم شناسنامه
	DECLARE     @id_naghs4_msg  BIGINT =-1 	 --صفحه اخر شناسنامه
	DECLARE     @id_naghs6_msg  BIGINT =-1 	 --مدرک نظام وظیفه
	DECLARE     @id_naghs7_msg  BIGINT =-1   --ریز نمرات
	DECLARE     @id_naghs8_msg  BIGINT =-1 	 --عکس
	DECLARE     @id_naghs9_msg  BIGINT =-1 	 --نامه موافقت از یگان
	DECLARE     @id_naghs21_msg BIGINT =-1 	 --مدرک سهمیه
	DECLARE     @id_naghs28_msg BIGINT =-1 	 --پشت کارت ملی
	DECLARE     @id_naghs35_msg BIGINT =-1 	 --مدرک تحصیلی
	DECLARE     @id_naghs40_msg BIGINT =-1 	 --برگه معافیت تحصیلی
	DECLARE     @id_naghs42_msg BIGINT =-1 	 --جواب نامه معافیت
	DECLARE     @id_naghs43_msg BIGINT =-1 	 --نامه بهزیستی
	
	
	DECLARE     @r_id BIGINT =-1 	-- return current inserted id from table  [dbo].[SP_InsertToWebMsgStu]
	DECLARE     @currenterm VARCHAR(7) = (select amozesh.dbo.fcounter.termjary from amozesh.dbo.fcounter)
	DECLARE		@datesabt varchar(10) = ( SELECT RIGHT( InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ) , 8) )
    DECLARE     @timesabt varchar(5) = (SELECT FORMAT(GETDATE(),'HH:mm'))	
	DECLARE		@sida_status INT =9

	--params for stuimage in amozpic and [digit_archive_sida4].[dbo].[digit_parvandeh]
	DECLARE @user_name nvarchar(100)=  @name+ ' '+ @family
	DECLARE @type_pic VARCHAR(10) ='jpg' 
	DECLARE @form_sida NVARCHAR(100)='scan'
	DECLARE @date_send NVARCHAR(10)= ( SELECT InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ))
	DECLARE @time_send NVARCHAR(10) = (select CONVERT(varchar(15),CAST(getdate() AS TIME),100))--(SELECT FORMAT(GETDATE(),'hh:mm'))	
	DECLARE @cat_pers_img INT =1
	
	
	SELECT @ErrorCode = @@ERROR
	BEGIN TRANSACTION FirstPoint_tran
    --SAVE TRANSACTION FirstPoint_tran;

	BEGIN TRY 
        ------------------------------------sahmeh sida----------------
		declare @sahmehSida numeric(18,0)=0
		if(@sahmeh=0) BEGIN  SET @sahmehSida=27 END --عادی
		if(@sahmeh=1) BEGIN  SET @sahmehSida=15 END
		if(@sahmeh=2) BEGIN  SET @sahmehSida=20 END
		if(@sahmeh=3) BEGIN  SET @sahmehSida=42 END

		
		---Insert into stu-newsida

		if(LEN(@fsf2_date_endMadrak)=10)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
		if(LEN(@fsf2_date_endMadrak)=9)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 
		
	
		------------------fnew_stu--------------------
		IF not exists(select * from amozesh.dbo.fnew_stu where stcode=@stcode)
		BEGIN 
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnew_stu]';
				INSERT INTO [amozesh].[dbo].[fnew_stu]
						   ([term]
						   ,[vorodi]
						   ,[stcode]    
						   ,[family]
						   ,[namep]
						   ,[idd]
						   ,[idd_meli]
						   ,[sex]
						   ,[magh]
						   ,[dorpar]
						   ,[idresh]
						   ,[date_tav]
						   ,[radif_gh]
						   ,[rotbeh_gh]
						   ,[nomreh_gh]
						   ,[code_posti]
						   ,[tel]          
						   ,[email]
						   ,[addressd]                    
						   ,[enteghal]
						   ,[dateenteghal] 
						   ,[idgeraesh]
						   ,[nobat]                   
						   ,[par]
						   ,[dav]
						   ,[name]
						   ,[sahmeh]
						   ,[university]
						   ,[jesm]
						   ,[meliat]
						   ,[end_madrak]
						   ,[din]
						   ,[resh_endmadrak]
						   ,[date_endmadrak]
						   ,[avrg_payeh]
						   ,[sal_vorod]
						   ,[date_sabtenam]
						   ,[mahal_tav]
						   ,[mahal_sodor]
						   ,[tahol]                    
                  
						  )
					 VALUES
						   (@term
						   ,@nimsal_vorod
						   ,@stcode          
						   ,@family
						   ,@namep
						   ,@idd
						   ,@idd_meli
						   ,@sex
						   ,dbo.magh2(@magh)
						   ,1
						   ,dbo.Ret_Idresh(@idreshSazman)
						   ,@date_tav
						   ,@radif_gh
						   ,@rotbeh_gh
						   ,@nomreh_gh
						   ,@code_posti
						   ,@tel           
						   ,@email
						   ,@addressd                    
						   ,1
						   ,dbo.MiladiTOShamsi(GETDATE())  
						   ,0
						   ,1		                      
						   ,@num_par
						   ,@num_davtalab
						   ,@name
						   ,@sahmehSida
						   ,@university
						   ,@jesm
						   ,@meliat
						   ,@end_madrak
						   ,@fsf2_din
						   ,@resh_endmadrak
						  -- ,@date_endmadrak
						  ,@fsf2_date_endMadrak
						   ,@avrg_payeh
						   ,@sal_vorod
						   ,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8))  
						   ,@mahal_tav
						   ,@mahal_sodor
						   ,@tahol
						   )
		END 

		------------------fsf--------------------
		if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
		BEGIN --C
            SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf]';
			Insert Into amozesh.dbo.fsf (
			stcode
			,family
			,name
			,namep
			,idd
			,idd_meli
			,sex
			,dorpar
			,magh
			,idresh
			,sal_vorod
			,nimsal_vorod
			,idvazkol
			,idgeraesh
			,codebayegan
			,payed
			,idpazeresh
			,sal_mali
			,outstu
			,sabt_batakhir
			,resh_mortabet

			)
		values
			(
			@stcode
			,@fsf_family
			,@fsf_name
			,@fsf_namep
			,@idd
			,@idd_meli
			,@sex
			,1
			,dbo.magh2(@magh)
			,dbo.Ret_Idresh(@idreshSazman)
			,@fsf_sal_vorod
			,@nimsal_vorod
			,1
			,0
			,''
			,0
			,@fsf_idPaziresh
			,@fsf_sal_vorod
			,0
			,0
			,@fsf_resh_mortabet

			)
		END --C
		-------------------------fsf2--------------------------
	    IF not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
		BEGIN  --D
				declare @fsf2_@date_tav as varchar(8)
				if(LEN(@date_tav)=10)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,8) as varchar(8)) 
				if(LEN(@date_tav)=9)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,7) as varchar(8)) 
				if(LEN(@date_tav)<=8)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,6) as varchar(8))				
		        
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf2]';
				Insert Into amozesh.dbo.fsf2 (
				stcode
				,date_tav 
				,end_madrak
				,university 
				,date_endmadrak 
				,resh_endmadrak 
				,mahal_tav 
				,mahal_sodor 
				,din 
				,nezam 
				,meliat
				,jesm 
				,sahmeh 
				,tahol 
				,radif_gh 
				,rotbeh_gh 
				,nomreh_gh 
				,addressd 
				,addressm
				,Ostan
				,Shahrestan
				,tel 
				,date_sabt
				,avrg_payeh 
				,num_davtalab 
				,num_par 
				,date_sabtenam 
				,code_posti 
				,email 
				,local1
				)
				values
				(
				@stcode
				,@fsf2_@date_tav 
				,@end_madrak 
				,@university 
				,@fsf2_date_endMadrak
				,@resh_endmadrak 
				,@mahal_tav 
				,@mahal_sodor
				,@fsf2_din 
				,@fsf2_nezam 
				,@meliat
				,@jesm 
				,@sahmehSida
				,@tahol 
				,@fsf2_radif_gh 
				,@fsf2_rotbeh_gh 
				,@fsf2_nomreh_gh 
				,@fsf2_addressd 
				,@fsf2_addressd
				,@fsf2_Ostan
				,@fsf2_Shahrestan
				,@tel
				,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
				,@avrg_payeh 
				,@num_davtalab 
				,@num_par 
				,cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)) 
				,@fsf2_code_posti 
				,@fsf2_email 
				,@fsf2_local1
				)
		END --D
		--------------------------webmeli_students_ExamPlace--------------------
		if not exists(select * from ExamPlace where STCODE=@stcode)
		BEGIN --E
			SELECT @ErrorStep = 'Error in Insert to [dbo].[ExamPlace]';
			INSERT INTO ExamPlace(Stcode, ID_Exam_Place, SaveDate)
			       VALUES(@stcode,1,dbo.MiladiTOShamsi(GETDATE()))

		END --E

		if  not exists(select * from amozesh.dbo.webmeli_students_ExamPlace where STCODE=@stcode)
		BEGIN --F
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[webmeli_students_ExamPlace]';
			insert into amozesh.dbo.webmeli_students_ExamPlace(STCODE,TTERM,ID_EXAM_PLACE,DATE_SAVE)
			values(@stcode,(select termjary from amozesh.dbo.fcounter),
			(select top 1 ID_Exam_Place from ExamPlace where Stcode=@stcode order by ID desc),(select top 1 SaveDate from ExamPlace where Stcode=@stcode order by ID desc))
		END  --F
		
		--########################################
		--########################################
			  

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs1)
		BEGIN --O
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=1 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs1,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --O	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=1';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs1, @r_id OUTPUT
		SET  @id_naghs1_msg = @r_id
		if(@id_naghs1_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs1_msg
		  WHERE st_code=@stcode AND category=2 --over of national card

		  ---------------------------------------------------		  

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs2)
		BEGIN --M
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=2 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs2,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --M	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=2';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs2, @r_id OUTPUT
		SET @id_naghs2_msg = @r_id
		if(@id_naghs2_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs2_msg
		  WHERE st_code=@stcode AND category=4 --page 1,2  shenasnameh

		  ---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs3)
		BEGIN --N
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=3 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs3,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --N	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=3';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs3, @r_id OUTPUT
		SET   @id_naghs3_msg = @r_id
		if(@id_naghs3_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs3_msg
		  WHERE st_code=@stcode AND category=5 --page 3,4  shenasnameh

	    ---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs4)
		BEGIN --L
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=4 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs4,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --L	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=4';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs4 , @r_id OUTPUT
		SET @id_naghs4_msg = @r_id  --930374167
		if(@id_naghs4_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs4_msg
		  WHERE st_code=@stcode AND category=6 --last page shenasnameh
		---------------------------------------------------
		IF(@sex=1)
		BEGIN  --T
		   if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs6)
		   BEGIN --U
		   	SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=6 and @num_naghs=1 ';
		   	INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
		   	values (@stcode,@id_naghs6,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1)
		   END --U
		   
		   SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=6';
		   EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs6, @r_id OUTPUT
		   SET   @id_naghs6_msg = @r_id
		   IF(@id_naghs6_msg<>-1)
		     UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs6_msg
		     WHERE st_code=@stcode AND category=8-- nezam vazifeh
		END --T  	
		
		---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs7)
		BEGIN --L
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=7 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs7,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --L	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=11';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs7 , @r_id OUTPUT
		SET @id_naghs7_msg = @r_id  --930374167
		if(@id_naghs7_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs7_msg
		  WHERE st_code=@stcode AND category=6 --riz nomarat
		---------------------------------------------------


		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs8)
		BEGIN --K
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=8 and @num_naghs=5 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs8,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs5) 
		END --K	
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=8';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs8 , @r_id OUTPUT
		SET   @id_naghs8_msg = @r_id
		if(@id_naghs8_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs8_msg
		  WHERE st_code=@stcode AND category=1 --aks

		---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs9 )
		BEGIN 
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=9 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs9,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END 
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=9';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs9 , @r_id OUTPUT
		SET   @id_naghs9_msg = @r_id
		if(@id_naghs9_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs9_msg
		  WHERE st_code=@stcode AND category=19 --name movafeghat az yegan
		
		--============================================
		--============================================
		
		------------------fvazejtemae--------------------
		IF(@sahmeh>0)
        BEGIN  --G
					 IF not exists(select * from amozesh.dbo.fvazejtemae where stcode=@stcode)
					 BEGIN  --H
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fvazejtemae]';
						INSERT INTO amozesh.dbo.fvazejtemae
						(
						stcode,
						vazejtemae, 
						modat, 
						code_rayane, 
						name_vazejtemae, 
						darsad_tahod, 
						sharh)
						VALUES        
						(
						@stcode,
						@vazejtemae,
						@modat,
						@code_rayane,
						@name_vazejtemae,
						@darsad_tahod,
						@sharh
						)
					 END --H
				-------------------

				--IF(@sahmeh>0)
				--BEGIN  --R
				   if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs21)
				   BEGIN --S
		   			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=21 and @num_naghs=1 ';
		   			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
		   			values (@stcode,@id_naghs21,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
				   END --S
		   
				   SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=21';
				   EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs21, @r_id OUTPUT
				   SET   @id_naghs21_msg = @r_id
				   IF(@id_naghs21_msg<>-1)
					UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs21_msg
					WHERE st_code=@stcode AND category=10-- sahmiye
			
					------------------mojaz_antvahed--------------------

					IF(NOT EXISTS(SELECT * FROM amozesh..mojaz_antvahed t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
					BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_antvahed]'
						INSERT into amozesh.dbo.mojaz_antvahed (stcode,tterm,datesabt,timesabt,iduser,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,@userId,'سیستم ثبت نام')
					END

					IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_sabtenam t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
					BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_sabtenam]'
						INSERT into amozesh.dbo.mojaz_sabtenam (stcode,tterm,datesabt,timesabt,iduser ,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,@userId ,'سیستم ثبت نام')
					END

					IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_govahi t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
					BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_govahi]'
						INSERT into amozesh.dbo.mojaz_govahi (stcode,tterm,datesabt,timesabt,iduser ,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,@userId ,'سیستم ثبت نام')
					END

					IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_kart t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
					BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_kart]'
						INSERT into amozesh.dbo.mojaz_kart (stcode,tterm,date_sabt) values(@stcode,@currenterm,@datesabt)	
					END
					
						
					INSERT INTO UserLog( UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
					VALUES (@userId,@tarikhsabt,@datesabt,@StCode,0,0,6,'مجوز ثبت نام')
				--END --R

        END --G

		--============================================
		IF(@StateWelfare>0)
		BEGIN
			IF(NOT EXISTS(SELECT * FROM amozesh.dbo.fbehzisti t WHERE t.stcode=@stcode ))
			BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fbehzisti] IF(@StateWelfare>0)'
						INSERT into amozesh.dbo.fbehzisti (stcode,type_sabt,date_nameh,num_nameh ,ostan) 
							SELECT @stcode ,1, StateWelfareLetterDate, StateWelfareLetter, StateWelfareState 
							  FROM InitialRegistration.dbo.fnewStudent WHERE stcode = @stcode						
			END

			IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_sabtenam t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
			BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_sabtenam] IF(@StateWelfare>0)'
						INSERT into amozesh.dbo.mojaz_sabtenam (stcode,tterm,datesabt,timesabt,iduser ,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,@userId ,'سیستم ثبت نام')
			END

			IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_govahi t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
			BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_govahi] IF(@StateWelfare>0)'
						INSERT into amozesh.dbo.mojaz_govahi (stcode,tterm,datesabt,timesabt,iduser ,nameuser) values(@stcode,@currenterm,@datesabt,@timesabt,@userId ,'سیستم ثبت نام')
			END

			IF(NOT EXISTS(SELECT * FROM amozesh.dbo.mojaz_kart t WHERE t.stcode=@stcode AND t.tterm=@currenterm))
			BEGIN
						SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mojaz_kart] IF(@StateWelfare>0)'
						INSERT into amozesh.dbo.mojaz_kart (stcode,tterm,date_sabt) values(@stcode,@currenterm,@datesabt)	
			END
					
						
			INSERT INTO UserLog( UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
			VALUES (@userId,@tarikhsabt,@datesabt,@StCode,0,0,6,'مجوز ثبت نام')

		END
        --============================================

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs28)
		BEGIN --P
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=28 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs28,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --P

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=28';
		EXEC @id_naghs28_msg= [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs28, @r_id OUTPUT
		SET   @id_naghs28_msg = @r_id
		if(@id_naghs28_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs28_msg
		  WHERE st_code=@stcode AND category=3-- back of national card

		---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs35)
		BEGIN --Q
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=35 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs35,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END --Q

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=35';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs35, @r_id OUTPUT
		SET   @id_naghs35_msg = @r_id
	    IF(@id_naghs35_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs35_msg
		  WHERE st_code=@stcode AND category=12-- edu doc

		---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs40)
		BEGIN 
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=40 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs40,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END 

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=40';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs40, @r_id OUTPUT
		SET   @id_naghs40_msg = @r_id
	    IF(@id_naghs40_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs40_msg
		  WHERE st_code=@stcode AND category=15-- barge maoafiyat tahsili

		---------------------------------------------------

		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs42)
		BEGIN 
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=42 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs42,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END 

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=42';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs42, @r_id OUTPUT
		SET   @id_naghs42_msg = @r_id
	    IF(@id_naghs42_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs42_msg
		  WHERE st_code=@stcode AND category=18-- javab name maoafiyat
		
		---------------------------------------------------
		  
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs43)
		BEGIN 
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=43 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs43,@tarikhmohlat,substring(dbo.MiladiTOShamsi(getdate()),3,9),@zamansabt,@user_name,@num_naghs1) 
		END 

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=43';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs43, @r_id OUTPUT
		SET   @id_naghs43_msg = @r_id
	    IF(@id_naghs43_msg<>-1)
		  UPDATE dbo.St_documents SET id_naghs_msg=@id_naghs43_msg
		  WHERE st_code=@stcode AND category=20-- nameh behzisti

		---------------------------------------------------

		--IF not exists(select stcode from amozesh.dbo.web_user where stcode=@stcode)
		--BEGIN --I
		--	SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_user]';
		--	INSERT into amozesh.dbo.web_user (stcode,password_stu,ok_sabt,ok_sabt_hazf,ctrl_bed_hazf,ctrl_bed_aval,ctrl_batakhir)
		--	select stcode,idd_meli,0,0,0,0,0 from fnewStudent where stcode=@stcode
		--END --I


		--IF not exists(select stcode from amozesh.dbo.web_user where stcode=@stcode)
		--BEGIN --I
		--	SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_user]';
		--	IF(@hashedPass_web_user IS null) SET @hashedPass_web_user=@idd_meli
		--	INSERT into amozesh.dbo.web_user (stcode,password_stu,ok_sabt,ok_sabt_hazf,ctrl_bed_hazf,ctrl_bed_aval,ctrl_batakhir)
		--	--select stcode,idd_meli,0,0,0,0,0 from fnewStudent where stcode=@stcode
		--	VALUES( @stcode,@hashedPass_web_user,0,0,0,0,0 )
		--END --I

		---------------------------------Supplementary.dbo.StudentLogin------------------
		if not exists(select * from Supplementary.dbo.StudentLogin where stcode=@stcode)
		BEGIN
			SET @ErrorStep = 'Error in Insert to [Supplementary].[dbo].[StudentLogin]';
			IF(@hashedPass_StudentLogin IS null) SET @hashedPass_StudentLogin=@idd_meli
			insert into Supplementary.dbo.StudentLogin (stcode,Password)
			VALUES( @stcode,@hashedPass_StudentLogin  )
		END
		--------------------------------------------------------------------------------
		
		IF not exists(select stcode from amozesh.dbo.mobile where stcode=@stcode)
		BEGIN	--J
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mobile]';
			INSERT into amozesh.dbo.mobile (stcode,mobile)
			select stcode,mobile from fnewStudent where  stcode=@stcode
        END --J
		---------------------------------------------------

		--insert all payment from payment to payinterm
		DECLARE @idtypepay NUMERIC(9 ,0)=1
		--DECLARE @stcode varchar(11)='940191977'
		SELECT @ErrorStep ='Error in Insert to amozesh.dbo.payinterm';
		INSERT into amozesh.dbo.payinterm(stcode,tterm ,amount,numfish,datefish ,idtypepay)
				SELECT 
				      p.StudentCode
					  ,p.tterm 
					  ,p.AmountTrans 
					  ,CAST( p.TraceNumber AS VARCHAR(20)) 
					  ,CASE  
							WHEN LEN(p.PersianDate)=10 THEN cast(substring(p.PersianDate,3,8) as varchar(8 ) )
							WHEN LEN(p.PersianDate)=9  THEN cast(substring(p.PersianDate,3,7) as varchar(8 ) )															  
							WHEN LEN(p.PersianDate) IN (1,8) THEN cast(p.PersianDate as varchar(8 ) )															 
					   END AS 'PersianDate' 
					  ,@idtypepay AS 'idtypepay'
				FROM dbo.Payment p WHERE p.AppStatus='COMMIT' AND p.PayType=@idtypepay AND p.StudentCode=@stcode 
				       AND cast(p.TraceNumber as varchar(20)) NOT IN (SELECT py.numfish from amozesh.dbo.payinterm py  where stcode=@stcode AND ISNULL(py.numfish,'')<>'' )

		---------------------------------------------------

		if not exists(select * from amozpic.dbo.stuimage where stcode=@stcode)
		BEGIN   
			SELECT @ErrorStep ='Error in Insert to amozpic.dbo.stuimage';
			INSERT into amozpic.dbo.stuimage(stcode,stu_pic)values(@stcode,@pic)
		end	

		--IF NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@id_scan)
		--BEGIN
		--	SELECT @ErrorStep ='Error in Insert to [digit_archive_sida4].[dbo].[digit_parvandeh] when id_scan='+@id_scan;
		--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
		--	VALUES( @stcode,@type_pic , @pic, @id_scan ,@user_name ,@ip ,@date_send ,@time_send , @computer_name , @form_sida  )
		--END

	
		IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8)
		BEGIN
			SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=8';
			delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8

			SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=8';
			DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
				AND id=(SELECT d.id_naghs_msg from dbo.St_documents d WHERE st_code=@stcode AND category=@cat_pers_img)
		END		
		---------------------------------------------------

		
		SELECT @ErrorStep = 'Error in update status=9 [InitialRegistration].[dbo].[fnewStudent] ';
		update fnewStudent set [status]=@sida_status WHERE stcode=@stcode
		---------------------------------------------------			
		
		COMMIT TRANSACTION FirstPoint_tran
		SET @Return_Message='Succussful'
	
	END TRY

	BEGIN CATCH
	   IF @@TRANCOUNT > 0 
	   BEGIN
            ROLLBACK TRANSACTION FirstPoint_tran; -- rollback to FirstPoint_tran        
			SET @Return_Message = @ErrorStep 
									+ ' '+CHAR(13) + CHAR(10)
									+ '*'+CAST(ERROR_NUMBER() as varchar(20)) +CHAR(13) + CHAR(10)+ '*'
									+ '#'+CAST(ERROR_LINE() as varchar(20)) +CHAR(13) + CHAR(10)+ '#'
									+ '~'+ERROR_MESSAGE() +CHAR(13) + CHAR(10) +'~'+
								    + ERROR_PROCEDURE()
									--CHAR(13) + CHAR(10) is new line char in sql
			--select XACT_STATE();
			
	   END	
	END CATCH
	

	SELECT @Return_Message AS Return_Message
	--RETURN @Return_Message
	--------------------------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[stp_UpdateNewStudent_Sahmiye]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dbo.fnewStudent WHERE stcode=@stdcode

--EXEC SP_GetStudentInfoBystCode '950280035'
--SELECT * FROM dbo.fnewStudent WHERE stcode='950280035'
--951	1	950280035	0	پانته ا	عبداللهي	ناصر	4160283101	4160283101	2	3	20611	0	71	1375/1/13	0	0	5290	1967755815	02122056953	09123377082	a@gmail.com	7	82	تهران - جردن - نيلوفر- پلاك 30	0	NULL	0	0	1068050	195509	0	11316	11315	0	8	1	412	1394/5/9	15.00	0	3	7	234	1	6	1	بيکارو000000	0	0	3	1068050	0	0	0	0	NULL	0	0	6	1	0	0	0	NULL	0

CREATE PROC [dbo].[stp_UpdateNewStudent_Sahmiye]
	   @stcode varchar(11)	 
      ,@sahmeh  numeric(18,0)=0
      ,@janbazi_darsad  tinyint=0
      ,@janbazi_nesbat  varchar(50)='0'
      ,@azadeh_modat  int=0
    
    
AS
BEGIN      

UPDATE [dbo].[fnewStudent]
   SET    
       sahmeh=@sahmeh  
      ,janbazi_darsad=@janbazi_darsad  
      ,janbazi_nesbat=@janbazi_nesbat 
      ,azadeh_modat=@azadeh_modat     
 
 WHERE stcode=@stcode
 END

 --EXEC  stp_UpdateNewStudent_Sahmiye '950280035',1,2,'3',10
 

GO
/****** Object:  StoredProcedure [dbo].[update_File_University]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[update_File_University]
@resh_endmadrak numeric(18,0)
,@university numeric(18,0)
,@stcode varchar(11)
as
begin
UPDATE       fnewStudent
SET           resh_endmadrak =@resh_endmadrak, university =@university
where stcode=@stcode
end
GO
/****** Object:  StoredProcedure [dbo].[UploadImage]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[UploadImage](@stcode varchar(11),@imgsamgetimage as image) as

declare  @t  numeric(9)
select @t=count(*) from   stuimage  where stcode=@stcode
if @t is null 
 set @t=0
if @t=0
 insert into stuimage  (stcode,stu_pic) values (@stcode,@imgsamgetimage)
else
update stuimage set stu_pic=@imgsamgetimage  where stcode=@stcode

GO
/****** Object:  StoredProcedure [dbo].[usp_SearchFK]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_SearchFK] 
  @table varchar(256) -- use two part name convention
, @lvl int=0 -- do not change
, @ParentTable varchar(256)='' -- do not change
, @debug bit = 1
as
begin
	set nocount on;
	declare @dbg bit;
	set @dbg=@debug;
	if object_id('tempdb..#tbl', 'U') is null
		create table  #tbl  (id int identity, tablename varchar(256), lvl int, ParentTable varchar(256));
	declare @curS cursor;
	if @lvl = 0
		insert into #tbl (tablename, lvl, ParentTable)
		select @table, @lvl, Null;
	else
		insert into #tbl (tablename, lvl, ParentTable)
		select @table, @lvl,@ParentTable;
	if @dbg=1	
		print replicate('----', @lvl) + 'lvl ' + cast(@lvl as varchar(10)) + ' = ' + @table;
	
	if not exists (select * from sys.foreign_keys where referenced_object_id = object_id(@table))
		return;
	else
	begin -- else
		set @ParentTable = @table;
		set @curS = cursor for
		select tablename=object_schema_name(parent_object_id)+'.'+object_name(parent_object_id)
		from sys.foreign_keys 
		where referenced_object_id = object_id(@table)
		and parent_object_id <> referenced_object_id; -- add this to prevent self-referencing which can create a indefinitive loop;

		open @curS;
		fetch next from @curS into @table;

		while @@fetch_status = 0
		begin --while
			set @lvl = @lvl+1;
			-- recursive call
			exec dbo.usp_SearchFK @table, @lvl, @ParentTable, @dbg;
			set @lvl = @lvl-1;
			fetch next from @curS into @table;
		end --while
		close @curS;
		deallocate @curS;
	end -- else
	if @lvl = 0
		select * from #tbl;
	return;
end
GO
/****** Object:  StoredProcedure [Discount].[sp_CheckDiscountNumber]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Discount].[sp_CheckDiscountNumber]
@number nvarchar(350)

AS 

BEGIN
SELECT * FROM dbo.Discount WHERE Number=@number
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_InsertDiscounts]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Discount].[sp_InsertDiscounts]
@discounts dbo.discountTableType readonly

AS 

BEGIN
insert into [dbo].[Discount] 
select * from @discounts
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_SelectAllDiscount]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Discount].[sp_SelectAllDiscount]

AS 

BEGIN
select * from [dbo].[Discount]
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_SelectAmbassadorsDiscount]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Discount].[sp_SelectAmbassadorsDiscount]
@number nvarchar(350)
AS 

BEGIN
  SELECT r.FirstName+' '+r.LastName AS FullName,r.CreateDate,r.NationalCode,p.Amount FROM [NoExamEntrance].[Request] r 
  JOIN [NoExamEntrance].[Payment] p ON p.RequestId=r.id
  JOIN [dbo].[Discount] d ON d.Id=r.DiscountId
  AND p.AppStatus='COMMIT' WHERE d.Number=@number
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_SelectAmbassadorsDiscountGroupBy]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Discount].[sp_SelectAmbassadorsDiscountGroupBy]
@number nvarchar(350)
AS 

BEGIN
  SELECT r.FirstName+' '+r.LastName AS FullName,r.NationalCode,sum(p.Amount) as Amount,count(*) iteration
  FROM [NoExamEntrance].[Request] r 
  JOIN [NoExamEntrance].[Payment] p ON p.RequestId=r.id
  JOIN [dbo].[Discount] d ON d.Id=r.DiscountId
  AND p.AppStatus='COMMIT' WHERE d.Number='1100'
  group by   r.FirstName,r.LastName,r.NationalCode
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_SelectUserAmbassadorsDiscountByNationalCode]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Discount].[sp_SelectUserAmbassadorsDiscountByNationalCode]
@number nvarchar(350),
@nationalCode nvarchar(50)
AS 

BEGIN
  SELECT r.FirstName+' '+r.LastName AS FullName,dbo.MiladiTOShamsi(convert(varchar,r.CreateDate,111)) as CreateDate,r.NationalCode,p.Amount FROM [NoExamEntrance].[Request] r 
  JOIN [NoExamEntrance].[Payment] p ON p.RequestId=r.id
  JOIN [dbo].[Discount] d ON d.Id=r.DiscountId
  AND p.AppStatus='COMMIT' WHERE d.Number=@number and r.NationalCode=@nationalCode
end
 


GO
/****** Object:  StoredProcedure [Discount].[sp_UpdateDiscountIsUsageById]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Discount].[sp_UpdateDiscountIsUsageById]
@id INT

AS 

BEGIN
update dbo.Discount set IsUsage=1 where Id=@id
end
 


GO
/****** Object:  StoredProcedure [International].[SP_Insert_AllDocToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [International].[SP_Insert_AllDocToSida]
 @id_scan numeric(18,0) --cat
,@stcode varchar(11)
,@doc_image image
,@name_karbar varchar(50)
,@magh TINYINT
,@UserId INT 
,@ip NVARCHAR(30) =''
,@studentId DECIMAL(18 ,0)
as
BEGIN
		--SELECT  TOP 1 * FROM [digit_archive_sida4].[dbo].[digit_parvandeh]
		DECLARE @type_pic VARCHAR(10)  ='jpg'
		DECLARE @form_sida NVARCHAR(100)='scan'
		DECLARE @date_send NVARCHAR(10)=( SELECT RIGHT( InitialRegistration.dbo.MiladiTOShamsi(GETDATE() ) , 8) )
		DECLARE @time_send NVARCHAR(10)= (SELECT FORMAT(GETDATE(),'HH:mm')) --24 hour format
		DECLARE @term int
		declare @termBaygan varchar(5)=''--(select term from fnewStudent where stcode=@stcode);	
		--declare @magh TINYINT=1;--(select magh from fnewStudent where stcode=@stcode);
		declare @idreshSazman varchar(10)=''--(select idreshSazman from fnewStudent where stcode=@stcode);
		declare @fsf_sal_vorod varchar(2)=(select substring(cast(@term as varchar(3)),1,2))--(select substring(cast(term as varchar(3)),1,2) from fnewStudent where stcode=@stcode);
		DECLARE @randCodeBaygan numeric(10,0)=(SELECT CONVERT(numeric(10,0),rand() * 8999999999) + 1000000000)
		
	--if  exists(select * from amozesh.dbo.fsf where stcode=@stcode and codebayegan='')
	--BEGIN		

	--	--declare @CodeBaygan varchar(15)=(
	--	--				@fsf_sal_vorod+'-'+cast(dbo.magh2(@magh) as varchar(2))+'-'+
	--	--	                 CAST((select Code_Baygan from International.FieldForForeigns where Id=@idreshSazman) as varchar(10))+'-'+
	--	--					 CAST((select COUNT(amozesh.dbo.fsf.stcode)+1 from amozesh.dbo.fsf where sal_vorod=@fsf_sal_vorod and magh=dbo.magh2(@magh) and codebayegan<>'' and codebayegan<>'0' and codebayegan is not NULL  and idresh in(select dbo.Ret_Idresh(Field_ID) from Field
	--	--	WHERE Code_Baygan=(select Code_Baygan from Field where Field_ID=@idreshSazman)))as varchar(20)))
    
	--	--update amozesh.dbo.fsf SET codebayegan=@CodeBaygan WHERE stcode=@stcode
	--END

	--==================================================
		--(select CONVERT(varchar(15),CAST(getdate() AS TIME),100))
		--SELECT  CONVERT(VARCHAR(5), GETDATE(), 108) 'hh:mi:ss'

		IF NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@id_scan)
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @doc_image, @id_scan ,@name_karbar ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		ELSE 
		BEGIN
				UPDATE [digit_archive_sida4].[dbo].[digit_parvandeh]
				SET pic_=@doc_image ,sender=@name_karbar , ip=@ip ,date_send=@date_send , time_send=@time_send ,computer_name=@ip
				WHERE stcode=@stcode AND type_archive=@id_scan	
		END	
	--==================================================
	--Insert into amozpic.dbo.doc_image(id_scan,stcode,doc_image,deleted,name_karbar,date_scan,time_scan)
	--values(@id_scan,@stcode,@doc_image,0,@name_karbar,Cast(substring(dbo.MiladiTOShamsi(GETDATE()),3,8) as varchar(8)),'')

	delete from amozesh.dbo.fnaghs_stu WHERE stcode=@stcode AND idnaghs=case(@id_scan) 								
										WHEN 101 then 1		--'روی کارت ملی===> پاسپورت کارت تردد دفترچه پناهندگی و...' 								 	
										WHEN 102 then 8		--'عکس پرسنلی' 										 
										WHEN 104 then 35	--'مدرک تحصیلی پایه' 
									END
	--SELECT * FROM amozesh..fcoding f WHERE f.idtypecoding=17 

	declare @idnaghs BIGINT;
	set @idnaghs=case(@id_scan) 
						WHEN 101 then  (SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Category IN(2,3,4,5) ) --'روی کارت ملی===> پاسپورت کارت تردد دفترچه پناهندگی و...' 		 
						WHEN 102 then  (SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Category=1 ) --'عکس پرسنلی' 
						WHEN 104 then  (SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Category IN (6,7,8) ) --'مدرک تحصیلی-' 
				   END

	delete from amozesh.dbo.web_msg_stu where stcode=@stcode and id=@idnaghs

	--SELECT * from amozesh.dbo.web_msg_stu 
	--SELECT * from amozesh.dbo.fnaghs_stu 

	--if exists(select * from St_documents where st_code=@stcode and st_code not in(select st_code from St_documents where  Isok<>3 and category<>11 ))
	--begin
	--	if not exists(select status from fnewStudent where stcode=@stcode and status=7)
	--	begin
	--		update fnewStudentset set [status]=7 WHERE stcode=@stcode
	--		INSERT INTO UserLog(UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType, Description)
	--		VALUES (@UserId,GETDATE(),(select CONVERT(varchar(15),CAST(getdate() AS TIME),100)),@stcode,0,0,20,'انتقال به سیدا')
	--	end
	--end
	
END


GO
/****** Object:  StoredProcedure [International].[SP_Insert_into_NewStudent]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [International].[SP_Insert_into_NewStudent]
@stList StudentType readonly
as
begin
	INSERT INTO International.NewStudent( term, stcode, name, family, namep, idd, idd_meli, sex, magh, idreshSazman, year_tav, radif_gh
			,rotbeh_gh, nomreh_gh, par, dav, id_paziresh, vorodi,DataEnterDate,tel,mobile,email,addressd,code_posti,AcceptationDescription )

	SELECT t.term,t.stcode,t.name,t.family,t.namep,t.idd,t.idd_meli,t.sex,t.magh,t.idreshSazman,t.year_tav,t.radif_gh
		,t.rotbeh_gh,t.nomreh_gh,t.par,t.dav,t.id_paziresh,t.vorodi,dbo.MiladiTOShamsi(GETDATE()),t.tel,t.mobile,t.email,t.addressd,t.code_posti,t.AcceptationDescription
	FROM @stList as t
	WHERE not exists (select f.stcode from International.NewStudent f where f.stcode=t.stcode )
	
	SELECT 1

END

--go
--CREATE PROCEDURE International.SP_Update_NewStudent
--@stcode NVARCHAR(10)=null
--,@status TINYINT
--AS
--BEGIN
--	IF(ISNULL(@stcode,'')<>'' AND EXISTS( SELECT stcode FROM International.NewStudent WHERE stcode=@stcode ))
--	BEGIN
--			UPDATE International.NewStudent SET status=@status			
--			WHERE stcode=@stcode		
--	END            
--END 
GO
/****** Object:  StoredProcedure [International].[stp_InsertIntoSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [International].[stp_InsertIntoSida]
@requestId DECIMAL(18,0)
,@term INT
,@currenterm VARCHAR(7) 
,@stcode varchar(11)
,@studentId DECIMAL(18,0)
,@name varchar(30)
,@family varchar(70)
,@namep varchar(40)
,@idd_meli varchar(20)--passportId
,@sex tinyint
,@magh tinyint
,@idreshSazman varchar(10)
,@sal_vorod numeric(18,0)
,@nimsal_vorod tinyint
,@date_tav varchar(10)
,@tahol numeric(18,0)
,@radif_gh varchar(10)
,@rotbeh_gh varchar(10)
,@nomreh_gh varchar(10)
,@tarikhmohlat NVARCHAR(20)=null
,@userId INT=-1
,@end_madrak numeric(18,0)=0
,@university numeric(18,0)=0--سایر
,@date_endmadrak varchar(8)=''
,@resh_endmadrak numeric(18,0)=0
,@mahal_tav numeric(18,0)=0--سایر
,@mahal_sodor numeric(18,0)=0--سایر
,@meliat numeric(18,0)=2 --غیر ایرانی
,@jesm numeric(18,0)=6 --سلامت کامل
,@sahmeh numeric(18,0)=0--سایر
,@addressd varchar(200)=''
,@tel nvarchar(50)=''
,@mobile nvarchar(20)=''
,@avrg_payeh varchar(5)=''
,@num_davtalab varchar(15)=''
,@num_par varchar(15)=''
,@code_posti varchar(20)=''
,@email varchar(70)=''
,@ip NVARCHAR(30) =''
	------------------fsf2 params --------------------
,@fsf2_date_endMadrak varchar(10)=''
,@fsf2_din numeric(18,0)=6
,@fsf2_nezam numeric(18,0)=0
,@fsf2_radif_gh numeric(18,0)=0
,@fsf2_rotbeh_gh numeric(18,0)=0
,@fsf2_nomreh_gh varchar(15)=''
,@fsf2_addressd varchar(150)=''
,@fsf2_email varchar(50)=''
,@fsf2_code_posti varchar(10)=''
,@fsf2_local1 varchar(1)='0'
,@fsf2_Ostan INT=0
,@fsf2_Shahrestan INT=0
,@encryptPassForLogin nvarchar(max)=NULL  --in supplementary
,@personalImage VARBINARY(MAX)
,@citizenshipImage VARBINARY(MAX)
,@educationDegreeImage VARBINARY(MAX)
AS
BEGIN --A
--------------------------------------------------------
	
    DECLARE     @ErrorStep  varchar(200)
	DECLARE     @Return_Message NVARCHAR(max) =''
    --DECLARE     @ErrorCode  int  
	--DECLARE     @tarikhsabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS DATE ) AS NVARCHAR(20)),0,11)

	DECLARE     @zamansabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS TIME ) AS NVARCHAR(20)),0,6)  

	DECLARE     @id_naghs1 INT=1     --کارت ملی یا پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
	DECLARE     @id_naghs8 INT=8	 -- عکس پرسنلی
	DECLARE     @id_naghs35 INT=35	 --مدرک  تحصیلی پایه
	
	DECLARE     @num_naghs1 INT=1	 --تعداد عکس هایی که برای این تایپ باید در پرونده وجود داشته باشد
	DECLARE     @num_naghs5 INT=5	 --	

	-- return id from amozesh.dbo.web_msg_stu  after insert
	DECLARE     @id_naghs1_msg  BIGINT =-1    --کارت ملی یا پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
	DECLARE     @id_naghs8_msg  BIGINT =-1 	 -- عکس پرسنلی
	DECLARE     @id_naghs35_msg BIGINT =-1 	 --مدرک  تحصیلی پایه	
	
	DECLARE     @level TINYINT=dbo.magh2(@magh);--تبدیل مقاطع سازمان به مقاطع سیدا
	
	DECLARE		@freshId NUMERIC(18,0)=(SELECT id FROM amozesh.dbo.fresh WHERE codesazman=@idreshSazman)--dbo.Ret_Idresh(@idreshSazman);	
	
	DECLARE     @r_id BIGINT =-1 
	DECLARE		@currenDateFarsi VARCHAR(10)=(select dbo.MiladiTOShamsi(GETDATE()) )
	--DECLARE		@datesabt varchar(10) = ( SELECT RIGHT(@currenDateFarsi , 8) )
	DECLARE		@date_send NVARCHAR(10)= ( SELECT SUBSTRING( dbo.MiladiTOShamsi(GETDATE()),3, 9))
	DECLARE		@time_send NVARCHAR(10) =(SELECT FORMAT(GETDATE(),'hh:mm'))	 --(select CONVERT(varchar(15),CAST(getdate() AS TIME),100))--
	DECLARE		@currentDate NVARCHAR(12)= substring(@currenDateFarsi,3,8)
    DECLARE     @timesabt varchar(5) = (SELECT FORMAT(GETDATE(),'HH:mm'))	

	DECLARE		@sida_status INT =9
	DECLARE		@isr_Request_status INT =8 --تایید کارشناس ثبت نام
	DECLARE		@International_ID_EXAM_PLACE numeric(18, 0) =41 --for international student	
	DECLARE		@NormalizedNationalCode varchar(20)=(SELECT International.fn_NormalizeNationalCode4ISRStudents(@idd_meli))
	DECLARE		@GeneratedCodeBayegan VARCHAR(15)=(SELECT International.fn_GenerateCodeBaygany(@stcode))

	--params for stuimage in amozpic and [digit_archive_sida4].[dbo].[digit_parvandeh]
	DECLARE @user_name nvarchar(100)=  @name+ ' '+ @family
	DECLARE @type_pic VARCHAR(10) ='jpg' 
	DECLARE @form_sida NVARCHAR(100)='scan'
	DECLARE @type_archive_passport NUMERIC(18,0)=101
	DECLARE @type_archive_personalImage NUMERIC(18,0)=102
	DECLARE @type_archive_baseEducation NUMERIC(18,0)=104


	------------------fsf params --------------------
	declare @fsf_name varchar(30)=(SELECT  @name);
	declare @fsf_family varchar(40)=(SELECT @family );
	declare @fsf_namep varchar(25)=(SELECT @namep );
	declare @fsf_sal_vorod varchar(2)=(SELECT @sal_vorod );
	declare @fsf_idPaziresh numeric(18,0)=0;
	declare @fsf_resh_mortabet INT=0;  

	--SELECT @ErrorCode = @@ERROR
	BEGIN TRANSACTION FirstPoint_tran
    --SAVE TRANSACTION FirstPoint_tran;

	BEGIN TRY 
        ------------------------------------sahmeh sida----------------
		declare @sahmehSida numeric(18,0)=0
		if(@sahmeh=0) BEGIN  SET @sahmehSida=27 END --عادی
		if(@sahmeh=1) BEGIN  SET @sahmehSida=15 END
		if(@sahmeh=2) BEGIN  SET @sahmehSida=20 END
		if(@sahmeh=3) BEGIN  SET @sahmehSida=42 END

		
		---Insert into stu-newsida

		if(LEN(@fsf2_date_endMadrak)=10)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
		if(LEN(@fsf2_date_endMadrak)=9)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 
		

		--------------------fnew_stu--------------------
		IF not exists(select * from amozesh.dbo.fnew_stu where stcode=@stcode)
		BEGIN 
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnew_stu]';
				INSERT INTO [amozesh].[dbo].[fnew_stu]([term],[vorodi],[stcode] ,[family] ,[namep]  ,[idd] ,[idd_meli] ,[sex],[magh]
				,[dorpar],[idresh],[date_tav] ,[radif_gh],[rotbeh_gh],[nomreh_gh] ,[code_posti] ,[tel] ,[email],[addressd]  
				,[enteghal],[dateenteghal] ,[idgeraesh],[nobat] ,[par],[dav],[name],[sahmeh],[university],[jesm],[meliat]
				,[end_madrak],[din],[resh_endmadrak],[date_endmadrak],[avrg_payeh],[sal_vorod],[date_sabtenam],[mahal_tav],[mahal_sodor],[tahol])
			   VALUES(@term,@nimsal_vorod,@stcode ,@family,@namep,@idd_meli,@NormalizedNationalCode,@sex,@level,1,@freshId,@date_tav,@radif_gh,@rotbeh_gh,@nomreh_gh
					,@code_posti,@tel ,@email,@addressd ,1,@currenDateFarsi,0,1,@num_par,@num_davtalab,@name,@sahmehSida,@university,@jesm,@meliat,@end_madrak,@fsf2_din,@resh_endmadrak
					 ,@date_endmadrak ,@avrg_payeh,@sal_vorod,cast(@currentDate as varchar(8)),@mahal_tav,@mahal_sodor,@tahol)
		END 

		------------------fsf--------------------
		if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
		BEGIN --C
            SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf]';
			Insert Into amozesh.dbo.fsf (stcode,family,name,namep,idd,idd_meli,sex,dorpar,magh,idresh,sal_vorod,nimsal_vorod,idvazkol
				,idgeraesh,codebayegan,payed,idpazeresh,sal_mali,outstu,sabt_batakhir,resh_mortabet)
			VALUES(@stcode,@fsf_family,@fsf_name,@fsf_namep,@idd_meli,@NormalizedNationalCode,@sex,1,@level,@freshId,@fsf_sal_vorod,@nimsal_vorod,1,0,@GeneratedCodeBayegan,0,@fsf_idPaziresh,@fsf_sal_vorod,0,0,@fsf_resh_mortabet)
		END --C
		-------------------------fsf2--------------------------
	    IF not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
		BEGIN  --D
				declare @fsf2_@date_tav as varchar(8)
				if(LEN(@date_tav)=10)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,8) as varchar(8)) 
				if(LEN(@date_tav)=9)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,7) as varchar(8)) 
				if(LEN(@date_tav)<=8)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,6) as varchar(8))				
		        
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf2]';
				Insert Into amozesh.dbo.fsf2 (stcode,date_tav ,end_madrak,university,date_endmadrak,resh_endmadrak ,mahal_tav,mahal_sodor ,din ,nezam ,meliat,jesm ,sahmeh ,tahol 
					,radif_gh ,rotbeh_gh,nomreh_gh ,addressd ,addressm,Ostan,Shahrestan,tel ,date_sabt,avrg_payeh ,num_davtalab ,num_par ,date_sabtenam ,code_posti,email ,local1)
				VALUES(@stcode,@fsf2_@date_tav ,@end_madrak ,@university ,@fsf2_date_endMadrak,@resh_endmadrak ,@mahal_tav ,@mahal_sodor,@fsf2_din ,@fsf2_nezam ,@meliat,@jesm ,@sahmehSida
					,@tahol ,@fsf2_radif_gh ,@fsf2_rotbeh_gh ,@fsf2_nomreh_gh ,@fsf2_addressd ,@fsf2_addressd,@fsf2_Ostan,@fsf2_Shahrestan,@tel,cast(@currentDate as varchar(8)) 
					,@avrg_payeh ,@num_davtalab ,@num_par ,cast(@currentDate as varchar(8)) ,@fsf2_code_posti,@fsf2_email,@fsf2_local1)
		END --D
		
		if not exists(select * from InitialRegistration.dbo.ExamPlace where STCODE=@stcode)
		BEGIN --E
			SELECT @ErrorStep = 'Error in Insert to [dbo].[ExamPlace]';
			INSERT INTO InitialRegistration.dbo.ExamPlace(Stcode, ID_Exam_Place, SaveDate) VALUES(@stcode,@International_ID_EXAM_PLACE,@currenDateFarsi)
		END --E

		if  not exists(select * from amozesh.dbo.webmeli_students_ExamPlace where STCODE=@stcode)
		BEGIN --F
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[webmeli_students_ExamPlace]';
			insert into amozesh.dbo.webmeli_students_ExamPlace(STCODE,TTERM,ID_EXAM_PLACE,DATE_SAVE)
			VALUES(@stcode,@currenterm,@International_ID_EXAM_PLACE ,@currenDateFarsi)
			
		END  --F

		IF not exists(select stcode from amozesh.dbo.mobile where stcode=@stcode)
		BEGIN	--J
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mobile]';
			INSERT into amozesh.dbo.mobile (stcode,mobile) VALUES(@stcode , @mobile)			
        END --J
		
		-------------------   ذخیره مدرک
		
	    IF (@personalImage IS NOT NULL AND  NOT EXISTS(select * from amozpic.dbo.stuimage where stcode=@stcode))
		BEGIN   
			SELECT @ErrorStep ='Error in Insert to amozpic.dbo.stuimage';
			INSERT into amozpic.dbo.stuimage(stcode,stu_pic)values(@stcode,@personalImage)
		end	
		----------
		IF(@personalImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_personalImage))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @personalImage, @type_archive_personalImage ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		----------
		IF(@citizenshipImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_passport))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @citizenshipImage, @type_archive_passport ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		----------
		IF(@educationDegreeImage IS NOT NULL AND   NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_baseEducation))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @educationDegreeImage, @type_archive_baseEducation ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		
		-------------------- ثبت نقص
		--نقص عکس پرسنلی 
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs8)
		BEGIN --K
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=8 and @num_naghs=5 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs8,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs5) 
		END --K	
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=8';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs8 , @r_id OUTPUT
		SET   @id_naghs8_msg = @r_id
		if(@id_naghs8_msg<>-1)
		  UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST( @id_naghs8_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category=1 --personalimage

		
		 -- نقص پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs1)
		BEGIN --O
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=1 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs1,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs1) 
		END --O	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=1';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs1, @r_id OUTPUT
		SET  @id_naghs1_msg = @r_id
		if(@id_naghs1_msg<>-1)
		  UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST(@id_naghs1_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category IN (2,3,4,5) --pass or similar doc map to national card
		  
		  -------------------------------------------------
		 --- نقص مدرک تحصیلی پایه
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs35)
		BEGIN --Q
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=35 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs35,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs1) 
		END --Q
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=35';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs35, @r_id OUTPUT
		SET   @id_naghs35_msg = @r_id
	    IF(@id_naghs35_msg<>-1)
		   UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST(@id_naghs35_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category IN (6,7,8) --base education documents 		  
		
	
		--------------------حذف نقص ها
		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=8';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=8';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category=1)
		--END	

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=1';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=1';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category IN (2,3,4,5))
		--END	

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=35';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=35';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category IN (6,7,8))
		--END	
		
		IF(EXISTS( SELECT stcode FROM International.NewStudent WHERE stcode=@stcode ))
		BEGIN
			UPDATE International.NewStudent SET name =@name ,family=@family ,namep=@namep, idd=@idd_meli ,idd_meli=@NormalizedNationalCode 
			,radif_gh=@radif_gh ,rotbeh_gh=@rotbeh_gh , nomreh_gh=@nomreh_gh , code_posti=@code_posti , email=@email,addressd=@addressd 
			,din=@fsf2_din ,tahol=@tahol , end_madrak=@end_madrak,jesm=@jesm ,meliat=@meliat,status=@sida_status
			WHERE stcode=@stcode
        END 


		--------------------------------- login service ------------------
		if not exists(select * from Supplementary.dbo.StudentLogin where stcode=@stcode)
		BEGIN
			SET @ErrorStep = 'Error in Insert to [Supplementary].[dbo].[StudentLogin]';
			IF(@encryptPassForLogin IS null) 
				SET @encryptPassForLogin=@NormalizedNationalCode
			insert into Supplementary.dbo.StudentLogin (stcode,Password) VALUES( @stcode,@encryptPassForLogin  )
		END

		---------------- login automation ------------------
		if not exists(select * from amozesh.dbo.web_user where stcode=@stcode)
		BEGIN
			SET @ErrorStep = 'Error in Insert to amozesh.dbo.web_user';
			IF(@encryptPassForLogin IS null) 
				SET @encryptPassForLogin=@NormalizedNationalCode
			insert into amozesh.dbo.web_user (stcode,password_stu,ok_sabt ,ok_sabt_hazf ,ctrl_bed_hazf,ctrl_bed_aval ,ctrl_batakhir ,ctrl_bed_hazf_temp ,ctrl_bed_aval_temp 
																	,password,IS_JAME_BEFORE,IS_JAME_BEFORE_TYPE_MOHTAVA,IS_NATAMAM,SUM_MEHMAN,IS_NATAMAM_KOL,ARSHAD_TAMDID) 
			VALUES( @stcode,@encryptPassForLogin ,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		END
		--------------------------------------------------------------------------------

		IF EXISTS( SELECT * FROM International.Request WHERE Id=@requestId)
		BEGIN
			UPDATE International.Request SET Status=@isr_Request_status WHERE Id=@requestId
		END        

		SET @Return_Message='success'
		COMMIT TRANSACTION FirstPoint_tran
	
	END TRY

	BEGIN CATCH
	   IF @@TRANCOUNT > 0 
	   BEGIN
            ROLLBACK TRANSACTION FirstPoint_tran; -- rollback to FirstPoint_tran        
			SET @Return_Message = @ErrorStep 
									+ ' '+CHAR(13) + CHAR(10)
									+ '*'+CAST(ERROR_NUMBER() as varchar(20)) +CHAR(13) + CHAR(10)+ '*'
									+ '#'+CAST(ERROR_LINE() as varchar(20)) +CHAR(13) + CHAR(10)+ '#'
									+ '~'+ERROR_MESSAGE() +CHAR(13) + CHAR(10) +'~'+
								    + ERROR_PROCEDURE()
									--CHAR(13) + CHAR(10) is new line char in sql
									--select XACT_STATE();
			
	   END	
	END CATCH
	

	SELECT @Return_Message AS Result	
END



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

GO
/****** Object:  StoredProcedure [International].[stp_RollbackTranferedNewStudentInfoToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [International].[stp_RollbackTranferedNewStudentInfoToSida]
--EXEC [International].[stp_RollbackTranferedNewStudentInfoToSida] '983005338' ,53 ,'98-99-2' ,36
CREATE PROCEDURE [International].[stp_RollbackTranferedNewStudentInfoToSida]
@stcode NVARCHAR(10)=NULL
,@studentId DECIMAL(18,0)=-1
,@currentterm VARCHAR(7) =''
,@requestId DECIMAL(18 ,0)=-1
AS
BEGIN
	IF(@stcode IS NOT NULL)
	BEGIN
		DECLARE @type_archive_passport NUMERIC(18,0)=101
		DECLARE @type_archive_personalImage NUMERIC(18,0)=102
		DECLARE @type_archive_baseEducation NUMERIC(18,0)=104
		DECLARE @convertedTerm NVARCHAR(7)=CAST(( SUBSTRING(@currentterm ,0,3)+SUBSTRING(@currentterm ,7,1) ) AS int )	

		delete from amozesh.dbo.fnew_stu where stcode=@stcode
		delete from amozesh.dbo.fsf where stcode=@stcode
		delete from amozesh.dbo.fsf2 where stcode=@stcode
		delete from InitialRegistration.dbo.ExamPlace where STCODE=@stcode
		delete from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=8
		delete  amozesh.dbo.web_msg_stu where stcode=@stcode
		delete from amozesh.dbo.mobile where stcode=@stcode
		delete from Supplementary.dbo.StudentLogin where stcode=@stcode

		delete from amozpic.dbo.stuimage where stcode=@stcode   --pesonalimage
		delete FROM [digit_archive_sida4].[dbo].[digit_parvandeh]  WHERE stcode=@stcode AND type_archive=@type_archive_passport --pasport
		delete FROM [digit_archive_sida4].[dbo].[digit_parvandeh]  WHERE stcode=@stcode AND type_archive=@type_archive_personalImage --pesonalimage
		delete FROM [digit_archive_sida4].[dbo].[digit_parvandeh]  WHERE stcode=@stcode AND type_archive=@type_archive_baseEducation --baseEducation

		UPDATE International.StudentDocs set Web_msg_stu_Idnaghs=null WHERE SudentId=@studentId AND Term=@currentterm AND Category=1 --personalimage
		UPDATE International.StudentDocs set Web_msg_stu_Idnaghs=null WHERE SudentId=@studentId AND Term=@currentterm AND Category IN (6,7,8) --base education documents 	
		UPDATE International.StudentDocs set Web_msg_stu_Idnaghs=null WHERE SudentId=@studentId AND Term=@currentterm AND Category IN (2,3,4,5) --pass or similar doc map to national card

		--از وضعیت 9 به 7 یعنی تایید ریس بین الملل 
		UPDATE International.Request SET Status=7 WHERE id=@requestId
		UPDATE International.NewStudent SET status=0  WHERE term=@convertedTerm AND RequestId=@requestId

		SELECT 1
	END

	SELECT 0	
END


GO
/****** Object:  StoredProcedure [International].[stp_TranferNewStudentDocumentsToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [International].[stp_TranferNewStudentDocumentsToSida]
@stcode NVARCHAR(10)=NULL
,@studentId DECIMAL(18,0)=-1
--,@currentterm VARCHAR(7) =''
,@name varchar(30)=''
,@family varchar(70)=''
,@ip NVARCHAR(20) =''
,@personalImage AS VARBINARY(max)  
,@citizenshipImage AS VARBINARY(max)=null
,@educationDegreeImage AS VARBINARY(max)=null
AS
BEGIN
		DECLARE     @ErrorStep  varchar(200) =''                    
	    DECLARE     @Result NVARCHAR(max) =''
		DECLARE		@type_pic VARCHAR(5)='jpg'
		DECLARE		@type_archive_passport NUMERIC(18,0)=101
		DECLARE		@type_archive_personalImage NUMERIC(18,0)=102
		DECLARE		@type_archive_baseEducation NUMERIC(18,0)=104
		DECLARE		@user_name nvarchar(100)=  @name+ ' '+ @family
		DECLARE		@date_send NVARCHAR(8)= (SELECT SUBSTRING( dbo.MiladiTOShamsi(GETDATE()),3, 9))
		DECLARE		@time_send NVARCHAR(5) = (SELECT FORMAT(GETDATE(),'hh:mm'))	--(select CONVERT(varchar(15),CAST(getdate() AS TIME),100))
		DECLARE		@form_sida NVARCHAR(10)='scan'

		DECLARE     @id_naghs1 INT=1     --کارت ملی یا پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
		DECLARE     @id_naghs8 INT=8	 -- عکس پرسنلی
		DECLARE     @id_naghs35 INT=35	 --مدرک  تحصیلی پایه

		----------------  ذخیره مدارک

	 --  IF (@personalImage IS NOT NULL AND  NOT EXISTS(select * from amozpic.dbo.stuimage where stcode=@stcode))
		--BEGIN   
		--	SELECT @ErrorStep ='Error in Insert to amozpic.dbo.stuimage';
		--	INSERT into amozpic.dbo.stuimage(stcode,stu_pic)values(@stcode,@personalImage)
		--end	
		----------------
		IF(@personalImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_personalImage))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @personalImage, @type_archive_personalImage ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		----------------
		IF(@citizenshipImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_passport))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @citizenshipImage, @type_archive_passport ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END
		----------------
		IF(@educationDegreeImage IS NOT NULL AND   NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_baseEducation))
		BEGIN
			INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
			VALUES( @stcode,@type_pic , @educationDegreeImage, @type_archive_baseEducation ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		END		

		----------------حذف نقص 

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=8';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=8';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currentterm AND category=1)
		--END	
		----------------

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=1';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=1';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currentTerm AND category IN (2,3,4,5))
		--END	
		----------------
		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=35';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=35';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currentTerm AND category IN (6,7,8))
		--END	
		----------------
		--IF(LEN(@ErrorStep)>0)
		--	SET @Result=(SELECT @ErrorStep)
		--ELSE
			SET @Result='success'

		SELECT @Result AS Result	
END
GO
/****** Object:  StoredProcedure [International].[stp_TranferNewStudentInfoToSida]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [International].[stp_TranferNewStudentInfoToSida]
@term INT
,@currenterm VARCHAR(7) 
,@stcode varchar(11)
,@studentId DECIMAL(18,0)
,@name varchar(30)
,@family varchar(70)
,@namep varchar(40)
,@idd_meli varchar(20)--passportId
,@sex tinyint
,@magh tinyint
,@idreshSazman varchar(10)
,@sal_vorod numeric(18,0)
,@nimsal_vorod tinyint
,@date_tav varchar(10)
,@tahol numeric(18,0)
,@radif_gh varchar(10)
,@rotbeh_gh varchar(10)
,@nomreh_gh varchar(10)
,@tarikhmohlat NVARCHAR(20)=null
,@userId INT=-1
,@end_madrak numeric(18,0)=0
,@university numeric(18,0)=0--سایر
,@date_endmadrak varchar(8)=''
,@resh_endmadrak numeric(18,0)=0
,@mahal_tav numeric(18,0)=0--سایر
,@mahal_sodor numeric(18,0)=0--سایر
,@meliat numeric(18,0)=2 --غیر ایرانی
,@jesm numeric(18,0)=6 --سلامت کامل
,@sahmeh numeric(18,0)=0--سایر
,@addressd varchar(200)=''
,@tel nvarchar(50)=''
,@mobile varchar(20)=''
,@avrg_payeh varchar(5)=''
,@num_davtalab varchar(15)=''
,@num_par varchar(15)=''
,@code_posti varchar(20)=''
,@email varchar(70)=''
,@ip NVARCHAR(30) =''
	------------------fsf2 params --------------------
,@fsf2_date_endMadrak varchar(10)=''
,@fsf2_din numeric(18,0)=6
,@fsf2_nezam numeric(18,0)=0
,@fsf2_radif_gh numeric(18,0)=0
,@fsf2_rotbeh_gh numeric(18,0)=0
,@fsf2_nomreh_gh varchar(15)=''
,@fsf2_addressd varchar(150)=''
,@fsf2_email varchar(50)=''
,@fsf2_code_posti varchar(10)=''
,@fsf2_local1 varchar(1)='0'
,@fsf2_Ostan INT=0
,@fsf2_Shahrestan INT=0
--,@personalImage AS VARBINARY(max)  
--,@citizenshipImage AS VARBINARY(max)=null
--,@educationDegreeImage AS VARBINARY(max)=null
AS
BEGIN

	DECLARE     @ErrorStep  varchar(200) =''                    
	DECLARE     @Result NVARCHAR(max) =''
	
	DECLARE     @tarikhsabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS DATE ) AS NVARCHAR(20)),0,11)
	DECLARE     @zamansabt NVARCHAR(20)=SUBSTRING( CAST( CAST( GETDATE() AS TIME ) AS NVARCHAR(20)),0,6)  

	DECLARE     @id_naghs1 INT=1     --کارت ملی یا پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
	DECLARE     @id_naghs8 INT=8	 -- عکس پرسنلی
	DECLARE     @id_naghs35 INT=35	 --مدرک  تحصیلی پایه
	
	DECLARE     @num_naghs1 INT=1	 --تعداد عکس هایی که برای این تایپ باید در پرونده وجود داشته باشد
	DECLARE     @num_naghs5 INT=5	 --	

	-- return id from amozesh.dbo.web_msg_stu  after insert
	DECLARE     @id_naghs1_msg  BIGINT =-1    --کارت ملی یا پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
	DECLARE     @id_naghs8_msg  BIGINT =-1 	 -- عکس پرسنلی
	DECLARE     @id_naghs35_msg BIGINT =-1 	 --مدرک  تحصیلی پایه	
	DECLARE     @level TINYINT=dbo.magh2(@magh);
	DECLARE		@freshId NUMERIC(18,0)=(SELECT id FROM amozesh.dbo.fresh WHERE codesazman=@idreshSazman)--dbo.Ret_Idresh(@idreshSazman);	
	
	DECLARE     @r_id BIGINT =-1 
	DECLARE		@currenDateFarsi VARCHAR(10)=(select dbo.MiladiTOShamsi(GETDATE()) )
	DECLARE		@datesabt varchar(10) = ( SELECT RIGHT(@currenDateFarsi , 8) )
	DECLARE		@date_send NVARCHAR(10)= ( SELECT @currenDateFarsi)
	DECLARE		@time_send NVARCHAR(10) = (select CONVERT(varchar(15),CAST(getdate() AS TIME),100))--(SELECT FORMAT(GETDATE(),'hh:mm'))	
	DECLARE		@currentDate NVARCHAR(12)= substring(@currenDateFarsi,3,8)
    DECLARE     @timesabt varchar(5) = (SELECT FORMAT(GETDATE(),'HH:mm'))	

	--DECLARE		@sida_status INT =9
	DECLARE		@International_ID_EXAM_PLACE numeric(18, 0) =41 --for international student

	--params for stuimage in amozpic and [digit_archive_sida4].[dbo].[digit_parvandeh]
	DECLARE @user_name nvarchar(100)=  @name+ ' '+ @family
	--DECLARE @type_pic VARCHAR(10) ='jpg' 
	--DECLARE @form_sida NVARCHAR(100)='scan'

	DECLARE @type_archive_passport NUMERIC(18,0)=101
	DECLARE @type_archive_personalImage NUMERIC(18,0)=102
	DECLARE @type_archive_baseEducation NUMERIC(18,0)=104


	------------------fsf params --------------------
	declare @fsf_name varchar(30)=(SELECT  @name);
	declare @fsf_family varchar(40)=(SELECT @family );
	declare @fsf_namep varchar(25)=(SELECT @namep );
	declare @fsf_sal_vorod varchar(2)=(SELECT @sal_vorod );
	declare @fsf_idPaziresh numeric(18,0);
	declare @fsf_resh_mortabet INT
	
        ------------------------------------sahmeh sida----------------
		declare @sahmehSida numeric(18,0)=0
		if(@sahmeh=0) BEGIN  SET @sahmehSida=27 END --عادی
		if(@sahmeh=1) BEGIN  SET @sahmehSida=15 END
		if(@sahmeh=2) BEGIN  SET @sahmehSida=20 END
		if(@sahmeh=3) BEGIN  SET @sahmehSida=42 END

		
		---Insert into stu-newsida

		if(LEN(@fsf2_date_endMadrak)=10)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,8) as varchar(8)) 
		if(LEN(@fsf2_date_endMadrak)=9)
			SET @fsf2_date_endMadrak=cast(substring(@fsf2_date_endMadrak,3,7) as varchar(8)) 
		

		--------------------fnew_stu--------------------
		IF not exists(select * from amozesh.dbo.fnew_stu where stcode=@stcode)
		BEGIN 
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnew_stu]';
				INSERT INTO [amozesh].[dbo].[fnew_stu]([term],[vorodi],[stcode] ,[family] ,[namep]  ,[idd] ,[idd_meli] ,[sex],[magh]
				,[dorpar],[idresh],[date_tav] ,[radif_gh],[rotbeh_gh],[nomreh_gh] ,[code_posti] ,[tel] ,[email],[addressd]  
				,[enteghal],[dateenteghal] ,[idgeraesh],[nobat] ,[par],[dav],[name],[sahmeh],[university],[jesm],[meliat]
				,[end_madrak],[din],[resh_endmadrak],[date_endmadrak],[avrg_payeh],[sal_vorod],[date_sabtenam],[mahal_tav],[mahal_sodor],[tahol])
			   VALUES(@term,@nimsal_vorod,@stcode ,@family,@namep,@idd_meli,@idd_meli,@sex,@level,1,@freshId,@date_tav,@radif_gh,@rotbeh_gh,@nomreh_gh
					,@code_posti,@tel ,@email,@addressd ,1,@currenDateFarsi,0,1,@num_par,@num_davtalab,@name,@sahmehSida,@university,@jesm,@meliat,@end_madrak,@fsf2_din,@resh_endmadrak
					 ,@date_endmadrak ,@avrg_payeh,@sal_vorod,cast(@currentDate as varchar(8)),@mahal_tav,@mahal_sodor,@tahol)
		END 

		------------------fsf--------------------
		if not exists(select * from amozesh.dbo.fsf where stcode=@stcode)
		BEGIN --C
            SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf]';
			Insert Into amozesh.dbo.fsf (stcode,family,name,namep,idd,idd_meli,sex,dorpar,magh,idresh,sal_vorod,nimsal_vorod,idvazkol
				,idgeraesh,codebayegan,payed,idpazeresh,sal_mali,outstu,sabt_batakhir,resh_mortabet)
			VALUES(@stcode,@fsf_family,@fsf_name,@fsf_namep,@idd_meli,@idd_meli,@sex,1,@level,@freshId,@fsf_sal_vorod,@nimsal_vorod,1,0,'',0,@fsf_idPaziresh,@fsf_sal_vorod,0,0,@fsf_resh_mortabet)
		END --C
		-------------------------fsf2--------------------------
	    IF not exists(select * from amozesh.dbo.fsf2 where stcode=@stcode)
		BEGIN  --D
				declare @fsf2_@date_tav as varchar(8)
				if(LEN(@date_tav)=10)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,8) as varchar(8)) 
				if(LEN(@date_tav)=9)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,7) as varchar(8)) 
				if(LEN(@date_tav)<=8)
				  SET @fsf2_@date_tav=cast(substring(@date_tav,3,6) as varchar(8))				
		        
				SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fsf2]';
				Insert Into amozesh.dbo.fsf2 (stcode,date_tav ,end_madrak,university,date_endmadrak,resh_endmadrak ,mahal_tav,mahal_sodor ,din ,nezam ,meliat,jesm ,sahmeh ,tahol 
					,radif_gh ,rotbeh_gh,nomreh_gh ,addressd ,addressm,Ostan,Shahrestan,tel ,date_sabt,avrg_payeh ,num_davtalab ,num_par ,date_sabtenam ,code_posti,email ,local1)
				VALUES(@stcode,@fsf2_@date_tav ,@end_madrak ,@university ,@fsf2_date_endMadrak,@resh_endmadrak ,@mahal_tav ,@mahal_sodor,@fsf2_din ,@fsf2_nezam ,@meliat,@jesm ,@sahmehSida
					,@tahol ,@fsf2_radif_gh ,@fsf2_rotbeh_gh ,@fsf2_nomreh_gh ,@fsf2_addressd ,@fsf2_addressd,@fsf2_Ostan,@fsf2_Shahrestan,@tel,cast(@currentDate as varchar(8)) 
					,@avrg_payeh ,@num_davtalab ,@num_par ,cast(@currentDate as varchar(8)) ,@fsf2_code_posti,@fsf2_email,@fsf2_local1)
		END --D
		--------------------------webmeli_students_ExamPlace--------------------
		if not exists(select * from ExamPlace where STCODE=@stcode)
		BEGIN --E
			SELECT @ErrorStep = 'Error in Insert to [dbo].[ExamPlace]';
			INSERT INTO ExamPlace(Stcode, ID_Exam_Place, SaveDate) VALUES(@stcode,@International_ID_EXAM_PLACE,@currenDateFarsi)
		END --E

		if  not exists(select * from amozesh.dbo.webmeli_students_ExamPlace where STCODE=@stcode)
		BEGIN --F
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[webmeli_students_ExamPlace]';
			insert into amozesh.dbo.webmeli_students_ExamPlace(STCODE,TTERM,ID_EXAM_PLACE,DATE_SAVE)
			VALUES(@stcode,@currenterm,@International_ID_EXAM_PLACE ,@currenDateFarsi)
			
		END  --F
		
		--نقص عکس پرسنلی 
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs8)
		BEGIN --K
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=8 and @num_naghs=5 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs8,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs5) 
		END --K	
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=8';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs8 , @r_id OUTPUT
		SET   @id_naghs8_msg = @r_id
		if(@id_naghs8_msg<>-1)
		  UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST( @id_naghs8_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category=1 --personalimage
		  		
		 -- نقص پاسپورت یا دفترچه پناهندگی یا کارت شناسایی یا برگه تردد موقت 
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs1)
		BEGIN --O
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=1 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs1,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs1) 
		END --O	

		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=1';
		EXEC [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs1, @r_id OUTPUT
		SET  @id_naghs1_msg = @r_id
		if(@id_naghs1_msg<>-1)
		  UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST(@id_naghs1_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category IN (2,3,4,5) --pass or similar doc map to national card
		
		 --- نقص مدرک تحصیلی پایه
		if  not exists(select * from amozesh.dbo.fnaghs_stu where stcode=@stcode and idnaghs=@id_naghs35)
		BEGIN --Q
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[fnaghs_stu] when id_naghs=35 and @num_naghs=1 ';
			INSERT into amozesh.dbo.fnaghs_stu (stcode,idnaghs,date_mohlat,datesabt,timesabt,nameuser,num_naghs)
			values (@stcode,@id_naghs35,@tarikhmohlat,substring(@currenDateFarsi,3,9),@zamansabt,@user_name,@num_naghs1) 
		END --Q
		
		SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[web_msg_stu] when id_naghs=35';
		EXEC  [dbo].[SP_InsertToWebMsgStu] @stcode,@id_naghs35, @r_id OUTPUT
		SET   @id_naghs35_msg = @r_id
	    IF(@id_naghs35_msg<>-1)
		   UPDATE International.StudentDocs SET Web_msg_stu_Idnaghs=CAST(@id_naghs35_msg AS [numeric](18, 0))
		  WHERE SudentId=@studentId AND Term=@currenterm AND Category IN (6,7,8) --base education documents 		  
		
		-------------- docs

	 --   IF (@personalImage IS NOT NULL AND  NOT EXISTS(select * from amozpic.dbo.stuimage where stcode=@stcode))
		--BEGIN   
		--	SELECT @ErrorStep ='Error in Insert to amozpic.dbo.stuimage';
		--	INSERT into amozpic.dbo.stuimage(stcode,stu_pic)values(@stcode,@personalImage)
		--end	

		--IF(@personalImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_personalImage))
		--BEGIN
		--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
		--	VALUES( @stcode,@type_pic , @personalImage, @type_archive_personalImage ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		--END
		
		--IF(@citizenshipImage IS NOT NULL AND  NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_passport))
		--BEGIN
		--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
		--	VALUES( @stcode,@type_pic , @citizenshipImage, @type_archive_passport ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		--END
		
		--IF(@educationDegreeImage IS NOT NULL AND   NOT EXISTS(SELECT * FROM [digit_archive_sida4].[dbo].[digit_parvandeh] p WHERE p.stcode=@stcode AND p.type_archive=@type_archive_baseEducation))
		--BEGIN
		--	INSERT INTO [digit_archive_sida4].[dbo].[digit_parvandeh]( stcode,type_pic ,pic_, type_archive , sender , ip , date_send , time_send  , computer_name ,	form_sida )
		--	VALUES( @stcode,@type_pic , @educationDegreeImage, @type_archive_baseEducation ,@user_name ,@ip ,@date_send ,@time_send , @ip , @form_sida  )
		--END

			  
		----------  delete naghs	  

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=8';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs8

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=8';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category=1)
		--END

		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=1';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs1

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=1';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category IN (2,3,4,5))
		--END	


		--IF EXISTS(SELECT * from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35)
		--BEGIN
		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.fnaghs_stu when id_naghs=35';
		--	delete from amozesh.dbo.fnaghs_stu 	WHERE stcode=@stcode and idnaghs=@id_naghs35

		--	SELECT @ErrorStep ='Error in delete from amozesh.dbo.web_msg_stu when id_naghs=35';
		--	DELETE from amozesh.dbo.web_msg_stu where stcode=@stcode 
		--		AND id=(SELECT TOP 1 d.Web_msg_stu_Idnaghs from International.StudentDocs d WHERE d.SudentId=@studentId AND d.Term=@currenterm AND category IN (6,7,8))
		--END	

		IF not exists(select stcode from amozesh.dbo.mobile where stcode=@stcode)
		BEGIN	--J
			SELECT @ErrorStep = 'Error in Insert to [amozesh].[dbo].[mobile]';
			INSERT into amozesh.dbo.mobile (stcode,mobile) VALUES(@stcode , @mobile)			
        END --J

		--IF(LEN(@ErrorStep)>0)
		--	SET @Result=(SELECT @ErrorStep)
		--ELSE
			SET @Result='success'

		SELECT @Result AS Result		
END
GO
/****** Object:  StoredProcedure [useraccess].[SP_DeleteAllUserFiledAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [useraccess].[SP_DeleteAllUserFiledAccess]
	@UserId		int
AS
BEGIN
	DELETE FROM [useraccess].[UserFiledAccess] WHERE UserId = @UserId
END
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_AllSection]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [useraccess].[SP_Get_AllSection]
as
begin
select * from useraccess.Section
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_FreshByDaneshId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_FreshByDaneshId]
@userId int,
@magh int
,@term varchar(10)
as
begin
declare @SectionId int;
set @SectionId=(select SectionId from UserLogin where UserId=@userId)
if(@SectionId>1 AND @SectionId <> 5)
select * from amozesh.dbo.fresh
where iddanesh=(select DaneshId from useraccess.Section where SectionId=@SectionId)
if(@SectionId IN (0,1,5))
begin
if(@magh<>0)
begin

select distinct fresh.id,fresh.nameresh+' '+isnull(namegeraesh,'') as nameresh  from fnewStudent  left join amozesh.dbo.fresh
ON fresh.codesazman=fnewStudent.idreshSazman left join amozesh.dbo.fgeraesh
ON fgeraesh.idresh=fresh.id
where  (term=substring(@term,1,2)+substring(@term,7,1)
or ( term<substring(@term,1,2)+substring(@term,7,1) and status<7))  and fresh.id is not null
and magh=@magh
order by fresh.nameresh+' '+isnull(namegeraesh,'') 
end
if(@magh=0)
begin
select distinct fresh.id,fresh.nameresh+' '+isnull(namegeraesh,'') as nameresh  from fnewStudent  left join amozesh.dbo.fresh
ON fresh.codesazman=fnewStudent.idreshSazman left join amozesh.dbo.fgeraesh
ON fgeraesh.idresh=fresh.id
where  (term=substring(@term,1,2)+substring(@term,7,1)
or ( term<substring(@term,1,2)+substring(@term,7,1) and status<7))  and fresh.id is not null
order by fresh.nameresh+' '+isnull(namegeraesh,'') 
end
end
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_Menu_ByParentId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_Menu_ByParentId]
@menuId int
as
begin
select * from useraccess.MenuApps where MenuId=@menuId
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_Menuapps]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------
CREATE procedure [useraccess].[SP_Get_Menuapps]
@sectionId int,
@userId int
as
begin
declare @parentId int;
set @parentId=(select parentId from useraccess.Section where SectionId=@sectionId)
if(@sectionId<>0)
begin
if(@parentId<>0)
begin
set @sectionId=@parentId
end
select  distinct useraccess.MenuApps.* from useraccess.MenuApps left join useraccess.AppMenuUserAccess
ON AppMenuUserAccess.MenuPermissionId=MenuApps.MenuId left join UserLogin
ON UserLogin.UserId=AppMenuUserAccess.UserId
where ((MenuApps.SectionId=@sectionId or MenuApps.SectionId=9) and MenuType=3) or (MenuType=4 and UserLogin.ShowAccessTomenu=1 and AppMenuUserAccess.UserId=@userId)
or (@sectionId = 5 and MenuApps.SectionId in (1,3) and MenuType=3)
end
if(@sectionId=0)
select * from useraccess.MenuApps where MenuType in(3,4)
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_MenuLink_ByControlName]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [useraccess].[SP_Get_MenuLink_ByControlName]
@MenuControlName varchar(50)
as
begin
select MenuLink from useraccess.MenuApps
where MenuControlName=@MenuControlName
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_RootMenu]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_RootMenu]
@MenuId int
as
 begin
WITH MyCTE
AS ( SELECT MenuName,ParentId,MenuId,MenuType,MenuControlName
FROM useraccess.MenuApps
WHERE MenuId=@MenuId
UNION ALL
SELECT MenuApps.MenuName,MenuApps.ParentId,MenuApps.MenuId,MenuApps.MenuType,MenuApps.MenuControlName
FROM useraccess.MenuApps
INNER JOIN MyCTE ON   MyCTE.ParentId=MenuApps.MenuId
)
select * from MyCTE 
where MyCTE.ParentId=0
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_UseraccessByUserIdAndParentId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_UseraccessByUserIdAndParentId]
@userId int,
@ParentId int
as
begin
select AppMenuUserAccess.*,ParentId,MenuName,MenuControlName,ImageURL,MenuId from useraccess.AppMenuUserAccess left join useraccess.MenuApps
ON MenuApps.MenuId=AppMenuUserAccess.MenuPermissionId
where UserId=@userId and ParentId=@ParentId
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_UserLoginBySectionId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_UserLoginBySectionId]
@sectionId int,
@userId int,
@RoleId int
as
begin
if(@sectionId<>0)
WITH MyCTE
AS ( SELECT RoleName,ParentId,id
FROM UserRole
WHERE id=@RoleId
UNION ALL
SELECT UserRole.RoleName,UserRole.ParentId,UserRole.id
FROM UserRole
INNER JOIN MyCTE ON UserRole.ParentId = MyCTE.id
)
select *,Name+'---'+UserName+'---'+RoleName as Uname from MyCTE left join UserLogin
ON UserLogin.RoleID=MyCTE.id
where SectionId=@sectionId and UserId<>@userId
order by ParentId asc
if(@sectionId=0)
select *,Name+'---'+UserName+'---'+RoleName as Uname from UserLogin left join UserRole
ON UserRole.id=UserLogin.RoleID
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_UserMenuAccess_ByUserId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_UserMenuAccess_ByUserId]
@UserId int,
@AllItems bit
as
begin
if(@AllItems=0)
begin
WITH MyCTE
AS ( 
	SELECT MenuName,ParentId,MenuId,MenuType,MenuControlName,ImageURL
	FROM useraccess.MenuApps
	WHERE ParentId=0
	UNION ALL
	SELECT MenuApps.MenuName,MenuApps.ParentId,MenuApps.MenuId,MenuApps.MenuType,MenuApps.MenuControlName,MenuApps.ImageURL
	FROM useraccess.MenuApps
	INNER JOIN MyCTE ON   MyCTE.MenuId=MenuApps.ParentId
)

select ParentId,max(MenuId) as MenuId 
FROM useraccess.AppMenuUserAccess 
   LEFT join useraccess.MenuApps ON MenuApps.MenuId=AppMenuUserAccess.MenuPermissionId
where MenuPermissionId in(select MenuId from MyCTE) and AppMenuUserAccess.UserId=@UserId and AppMenuUserAccess.Enable=1
group by ParentId
end
if(@AllItems=1)
begin
select * from useraccess.AppMenuUserAccess where UserId=@UserId and Enable=1
end
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Get_UserRole_ByUserId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Get_UserRole_ByUserId]
@userId int
as
begin
select RoleID from UserLogin
where UserId=@userId
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_GetUserFieldAccess_By_UserId]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_GetUserFieldAccess_By_UserId]
@userid int
as
begin
select * from useraccess.UserFiledAccess
where UserId=@userid and Enable=1
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_GetUserRole]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_GetUserRole]
@id int
as
begin
if(@id<>1)
begin
WITH MyCTE
AS ( SELECT RoleName,ParentId,id
FROM UserRole
WHERE id=@id
UNION ALL
SELECT UserRole.RoleName,UserRole.ParentId,UserRole.id
FROM UserRole
INNER JOIN MyCTE ON UserRole.ParentId = MyCTE.id
)
select * from MyCTE 
where ParentId<>1
order by ParentId asc
end
if(@id=1)
begin
WITH MyCTE
AS ( SELECT RoleName,ParentId,id
FROM UserRole
WHERE id=@id
UNION ALL
SELECT UserRole.RoleName,UserRole.ParentId,UserRole.id
FROM UserRole
INNER JOIN MyCTE ON UserRole.ParentId = MyCTE.id
)
select * from MyCTE 
order by ParentId asc
end
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Insert_AppMenuUserAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Insert_AppMenuUserAccess]
@MenuPermissionId int,
@UserId int,
@Enable bit,
@CreatorId int
as
begin
declare @desc nvarchar(max);
set @desc=(select MenuName from useraccess.MenuApps where MenuId=@MenuPermissionId)
if not exists(select * from useraccess.AppMenuUserAccess where UserId=@UserId and MenuPermissionId=@MenuPermissionId)
begin
if(@Enable=1)
begin
INSERT INTO useraccess.AppMenuUserAccess
                         (MenuPermissionId, UserId, Enable)
VALUES        (@MenuPermissionId,@UserId,@Enable)
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,12,@desc)
end
end
if  exists(select * from useraccess.AppMenuUserAccess where UserId=@UserId and MenuPermissionId=@MenuPermissionId)
begin
declare @OldEnableStatus bit;
set @OldEnableStatus=(select Enable from useraccess.AppMenuUserAccess where MenuPermissionId=@MenuPermissionId and UserId=@UserId)
if(@OldEnableStatus=0 and @Enable=1)
begin
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,12,@desc)

end
if(@OldEnableStatus=1 and @Enable=0)
begin
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,13,@desc)

end
update useraccess.AppMenuUserAccess
set Enable=@Enable
where MenuPermissionId=@MenuPermissionId and UserId=@UserId
end
end
GO
/****** Object:  StoredProcedure [useraccess].[SP_Insert_UserFiledAccess]    Script Date: 11/10/2020 12:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [useraccess].[SP_Insert_UserFiledAccess]
@FiledId int,
@UserId int,
@Enable bit,
@CreatorId int
as
begin
declare @desc nvarchar(max);
if exists(select nameresh from amozesh.dbo.fresh left join useraccess.UserFiledAccess ON useraccess.UserFiledAccess.FiledId=fresh.codesazman where FiledId=@FiledId and UserId=@UserId)
set @desc=(select nameresh from amozesh.dbo.fresh left join useraccess.UserFiledAccess ON useraccess.UserFiledAccess.FiledId=fresh.codesazman where FiledId=@FiledId and UserId=@UserId)
if not exists(select nameresh from amozesh.dbo.fresh left join useraccess.UserFiledAccess ON useraccess.UserFiledAccess.FiledId=fresh.codesazman where FiledId=@FiledId and UserId=@UserId)
set @desc=(select nameresh from amozesh.dbo.fresh where id=@FiledId)
if not exists(select * from useraccess.UserFiledAccess where FiledId=@FiledId and UserId=@UserId)
begin
if(@Enable=1)
begin
INSERT INTO useraccess.UserFiledAccess
                         (FiledId, UserId,Enable)
VALUES        (@FiledId,@UserId,@Enable)
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,14,@desc)
end
end
if exists(select * from useraccess.UserFiledAccess where FiledId=@FiledId and UserId=@UserId)
begin
declare @OldEnableStatus bit;
set @OldEnableStatus=(select Enable from useraccess.UserFiledAccess where FiledId=@FiledId and UserId=@UserId)
if(@OldEnableStatus=0 and @Enable=1)
begin
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,14,@desc)
update useraccess.UserFiledAccess
set Enable=@Enable
where FiledId=@FiledId and UserId=@UserId
end
if(@OldEnableStatus=1 and @Enable=0)
begin
INSERT INTO UserLog
                         (UserId, LogDate, LogTime, StCode, DocId, DocStatus, LogType,Description)
VALUES        (@CreatorId,getdate(),CONVERT (time, GETDATE()),CONVERT(varchar(10),@UserId),0,0,15,@desc)
update useraccess.UserFiledAccess
set Enable=@Enable
where FiledId=@FiledId and UserId=@UserId
end


end
end
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد پیغام' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllAlterText', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'متن پیغام' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllAlterText', @level2type=N'COLUMN',@level2name=N'Text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=sms
2=email
3=msg-نوع ارسال' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllAlterText', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllAlterText', @level2type=N'COLUMN',@level2name=N'StatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه تنظیمات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'Control_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'امکان پرداخت از طریق پوز ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'Has_PosPayment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ شروع ثبت نام' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'StartReg_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ پایان ثبت نام' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'EndReg_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'Term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Control', @level2type=N'COLUMN',@level2name=N'LevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه دانشکده ها ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Danesh', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام دانشکده ها' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Danesh', @level2type=N'COLUMN',@level2name=N'DaneshName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EduLevel', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد مقطع سازمان ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EduLevel', @level2type=N'COLUMN',@level2name=N'Id_sazman'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد مقطع سیدا' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EduLevel', @level2type=N'COLUMN',@level2name=N'id_sida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EduLevel', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'End_Madrak', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد آخرین مدرک تحصیلی ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'End_Madrak', @level2type=N'COLUMN',@level2name=N'Sida_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'End_Madrak', @level2type=N'COLUMN',@level2name=N'LevelName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه عملیاتی که توسط دانشجو انجام می شود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventName', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'عملیاتی که در روند ثبت نام توسط دانشجو انجام می شود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EventName', @level2type=N'COLUMN',@level2name=N'EventName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کدها' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fcoding', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع کد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fcoding', @level2type=N'COLUMN',@level2name=N'idtypecoding'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام کد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fcoding', @level2type=N'COLUMN',@level2name=N'namecoding'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه رشته' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Field_old', @level2type=N'COLUMN',@level2name=N'Field_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام رشته' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Field_old', @level2type=N'COLUMN',@level2name=N'Field_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته در سیدا' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Field_old', @level2type=N'COLUMN',@level2name=N'Sida_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نیم سال ورودی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'vorodi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'stcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی موقت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'stcodeTemp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام خانوادگی دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'family'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام پدر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'namep'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسنامه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'idd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کدملی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'idd_meli'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'جنسیت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'sex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'magh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته ای که از سازمان اعلام می شود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'idreshSazman'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته در سیستم سیدا' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'idresh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سال تولد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'year_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ تولد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'date_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ردیف قبولی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'radif_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'رتبه قبولی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'rotbeh_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نمره قبولی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'nomreh_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کدپستی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'code_posti'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تلفن' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'موبایل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'mobile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ایمیل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'استان محل سکونت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'Province'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شهر محل سکونت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'City'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آدرس محل سکونت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'addressd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'انتقال' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'enteghal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ انتقال' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'dateenteghal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد گرایش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'idgeraesh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوبت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'nobat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره پرونده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'par'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره داوطلبی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'dav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ ثبت نام' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'date_sabtenam'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل تولد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'mahal_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل صدور شناسنامه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'mahal_sodor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت تاهل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'tahol'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'end_madrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'دین' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'din'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آخرین رشته تحصیلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'resh_endmadrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ دریافت آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'date_endmadrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'معدل پایه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'avrg_payeh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'معدل دیپلم' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'dip_avrg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سهمیه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'sahmeh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'استان تشکیل پرونده سهمیه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'sahmeh_Ostan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل تحصیل آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'university'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'بومی یا غیر بومی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'bomi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت جسمانی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'jesm'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ملیت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'meliat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شغل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'job'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سال ورود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'sal_vorod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'درصد جانبازی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'janbazi_darsad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نسبت جانبازی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'janbazi_nesbat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد یارانه جانبازی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'janbaz_rayaneh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مدت اسارت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'azadeh_modat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد نظام وظیفه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'nezamvazife'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل خدمت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'mahal_khedmat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ارسال نامه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'ersal_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت روند ثبت نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع قبولی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'id_paziresh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'پرداخت قسطی دارد یا نه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'IsInstallment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ ورود اطلاعات فایل سازمان به دیتابیس' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'DataEnterDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'اجازه ثبت نام دارد یا نه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fnewStudent', @level2type=N'COLUMN',@level2name=N'permitted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه گروه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Group', @level2type=N'COLUMN',@level2name=N'GroupId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام گروه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Group', @level2type=N'COLUMN',@level2name=N'GroupName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام دانشکده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Group', @level2type=N'COLUMN',@level2name=N'DaneshID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کاربر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupManager', @level2type=N'COLUMN',@level2name=N'ID_UserLogin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد گروه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupManager', @level2type=N'COLUMN',@level2name=N'ID_Group'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupManager', @level2type=N'COLUMN',@level2name=N'magh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0= Registred, 1= Document Uploaded, 2= Approved, 3= Rejected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GuestStudentsInfo', @level2type=N'COLUMN',@level2name=N'RequestStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GuestStudentsInfo', @level2type=N'COLUMN',@level2name=N'LevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0= Unknown, 1= Male, 2= Female' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GuestStudentsInfo', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه متون راهنما' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Help', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'متون راهنما' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Help', @level2type=N'COLUMN',@level2name=N'HelpBodyText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره ردیف' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Help', @level2type=N'COLUMN',@level2name=N'RowID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:home-1:personal-2:education-3:vazife-4:sahmie-InfoPreview:5-documents:6-Docpreview:7-payment:8-9:showStudentNumber-نوع متن' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Help', @level2type=N'COLUMN',@level2name=N'TypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه متون پیش فرض' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Keywords', @level2type=N'COLUMN',@level2name=N'KeywordID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'متن' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Keywords', @level2type=N'COLUMN',@level2name=N'KeyWordText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'دسته بندی مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Keywords', @level2type=N'COLUMN',@level2name=N'DocCategoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Moghayerat', @level2type=N'COLUMN',@level2name=N'stcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آدرس کارت ملی ذخیره شده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Moghayerat', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع مغایرت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Moghayerat', @level2type=N'COLUMN',@level2name=N'moghayerat_type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مغایرت اصلاح شده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Moghayerat', @level2type=N'COLUMN',@level2name=N'eslahat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مغایرت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Moghayerat', @level2type=N'COLUMN',@level2name=N'wrong'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه مغایرت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MoghayeratType', @level2type=N'COLUMN',@level2name=N'MoghayeratID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام مغایرت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MoghayeratType', @level2type=N'COLUMN',@level2name=N'Moghayerat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'newfcoding', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع کدینگ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'newfcoding', @level2type=N'COLUMN',@level2name=N'idtypecoding'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام کد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'newfcoding', @level2type=N'COLUMN',@level2name=N'namecoding'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'PaymentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره سفارش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'OrderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نتیجه تراکنش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'Result'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد مرجع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'RetrivalRefNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مبلغ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'AmountTrans'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کلید درخواست' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'RequestKey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت پرداخت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'AppStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'StudentCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'tterm'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد بانک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'BankID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ میلادی پرداخت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'MiladiDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ شمسی پرداخت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'PersianDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ میلادی تراکنش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'TransMiladiDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ناریخ شمسی تراکنش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'TransPersianDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه پرداخت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'TraceNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام دارنده کارت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'CardHolder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره کارت پرداخت کننده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'CardNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع پرداخت-قسط-چک-اینترنتی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'PayType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه فیش پرداخت ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'RecieptID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره قبض فیش پرداخت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'RecieptNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ فیش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'RecieptDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مبلغ فیش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'RecieptAmount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'stcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ ثبت فیش' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'SubmitDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentReciept', @level2type=N'COLUMN',@level2name=N'term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه درخواست تغییر رشته' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'RequestID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کدملی دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'iddMeli'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته قبلی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'OldField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته جدید' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'NewField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:copmose-2:reply-درخواست جدید است یا پاسخ است' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'ComposeOrReply'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کاربربررسی کننده درخواست' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'متن درخواست' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'RequestText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:Check-2:confirm-3:failed-وضعیت درخواست' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'StatusRequest'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ درخواست' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'RequestDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'درخواست خوانده شده یا خیر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RequestChangeField', @level2type=N'COLUMN',@level2name=N'IsRead'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:CloseAll-2:CloseByStatus' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Setting', @level2type=N'COLUMN',@level2name=N'StatusType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه وضعیت مدرک دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_Doc_Status', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع وضعیت مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_Doc_Status', @level2type=N'COLUMN',@level2name=N'DocStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'st_code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام فایل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'filename'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آدرس ذخیره فایل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'دسته بندی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'Isok'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'توضیح علت رد مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم ورود مدرک' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_documents', @level2type=N'COLUMN',@level2name=N'Doc_Term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه دسته بندی مدارک دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'st_Documents_category', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام مدرک دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'st_Documents_category', @level2type=N'COLUMN',@level2name=N'DocName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه وضعیت روند ثبت نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_Status', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع وضعیت روند ثبت نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_Status', @level2type=N'COLUMN',@level2name=N'St_Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد وضعیت دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'St_Status', @level2type=N'COLUMN',@level2name=N'Status_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه عملیات انجام شده توسط دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'Stcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ انجام عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'EnterDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'زمان انجام عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'EnterTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'Event'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت فعلی دانشجو' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترمی که عملیات انجام شده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentLog', @level2type=N'COLUMN',@level2name=N'term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه استان' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tbl_Ostan', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام استان' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tbl_Ostan', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه شهرستان' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tbl_Shahrestan', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام استان' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tbl_Shahrestan', @level2type=N'COLUMN',@level2name=N'PK_Ostan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام شهرستان' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tbl_Shahrestan', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه شهریه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'TuitionId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه رشته' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'FeildId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه مقطع' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'LevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'هزینه شهریه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'Fee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'هزینه بیمه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'Insurance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'هزینه خدمات دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'Service'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم تعریف شهریه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TuitionFee', @level2type=N'COLUMN',@level2name=N'Term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آدرس' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'Address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تلفن هایی که در بالای سایت می باشد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'TopTel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تلفن هایی که در پایین سایت می باشد' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'BottomTel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'فکس' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'Fax'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ایمیل' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UniAddress', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه عملیاتی که توسط کاربر انجام می شود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_LogType', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع عملیاتی که توسط کاربر انجام می شود' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_LogType', @level2type=N'COLUMN',@level2name=N'LogType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه تاریخچه عملیات انجام شده توسط کاربر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'LogID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کاربر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'LogDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'زمان عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'LogTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'StCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه مدرکی که تایید یا رد شده' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'DocId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت مدرک که تایید یا رد شده است' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'DocStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه نوع عملیات' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLog', @level2type=N'COLUMN',@level2name=N'LogType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه کاربر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogin', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام کاربر' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogin', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام کاربری' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogin', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'رمز عبور' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogin', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه سمت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogin', @level2type=N'COLUMN',@level2name=N'RoleID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسه سمت ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserRole', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام سمت' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserRole', @level2type=N'COLUMN',@level2name=N'RoleName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=active , 0=deactive' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'Account', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=iran-home , 2=iran-work , 3=mainCountry-home  ,4=mainCountry-work' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'Address', @level2type=N'COLUMN',@level2name=N'AddressType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=deploma ,2=collage , 3=bachlaor ,4=master ,5=phd' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'EducationDegree', @level2type=N'COLUMN',@level2name=N'Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترم' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'term'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نیم سال ورودی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'vorodi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'stcode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره دانشجویی موقت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'stcodeTemp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام خانوادگی دانشجو' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'family'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام پدر' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'namep'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شناسنامه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'idd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کدملی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'idd_meli'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'جنسیت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'sex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مقطع' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'magh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته ای که از سازمان اعلام می شود' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'idreshSazman'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد رشته در سیستم سیدا' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'idresh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سال تولد' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'year_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ تولد' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'date_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ردیف قبولی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'radif_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'رتبه قبولی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'rotbeh_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نمره قبولی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'nomreh_gh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کدپستی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'code_posti'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تلفن' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'tel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'موبایل' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'mobile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ایمیل' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'استان محل سکونت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'Province'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شهر محل سکونت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'City'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آدرس محل سکونت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'addressd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'انتقال' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'enteghal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ انتقال' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'dateenteghal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد گرایش' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'idgeraesh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوبت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'nobat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره پرونده' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'par'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره داوطلبی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'dav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ ثبت نام' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'date_sabtenam'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل تولد' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'mahal_tav'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل صدور شناسنامه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'mahal_sodor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت تاهل' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'tahol'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'end_madrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'دین' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'din'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'آخرین رشته تحصیلی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'resh_endmadrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ دریافت آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'date_endmadrak'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'معدل پایه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'avrg_payeh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'معدل دیپلم' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'dip_avrg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سهمیه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'sahmeh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'استان تشکیل پرونده سهمیه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'sahmeh_Ostan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل تحصیل آخرین مدرک تحصیلی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'university'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'بومی یا غیر بومی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'bomi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت جسمانی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'jesm'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ملیت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'meliat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شغل' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'job'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'سال ورود' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'sal_vorod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'درصد جانبازی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'janbazi_darsad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نسبت جانبازی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'janbazi_nesbat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد یارانه جانبازی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'janbaz_rayaneh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مدت اسارت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'azadeh_modat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کد نظام وظیفه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'nezamvazife'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'محل خدمت' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'mahal_khedmat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ارسال نامه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'ersal_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'وضعیت روند ثبت نام دانشجو' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نوع قبولی' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'id_paziresh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'پرداخت قسطی دارد یا نه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'IsInstallment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تاریخ ورود اطلاعات فایل سازمان به دیتابیس' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'DataEnterDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'اجازه ثبت نام دارد یا نه' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'permitted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'شماره درخوایت سامانه بین الملل ' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'NewStudent', @level2type=N'COLUMN',@level2name=N'RequestId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=man , 2=woman' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=formal , 2=informal' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MarritalType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=janbaz , 2=sayer naghs ozv , 3=salamat kamel , 4=malool binayee , 5=malool harekati , 6=malool nashenava , 7=malool gooyayee  ,  8=nabina , 9=nashenava' , @level0type=N'SCHEMA',@level0name=N'International', @level1type=N'TABLE',@level1name=N'Student', @level2type=N'COLUMN',@level2name=N'HealthStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1=PersonalImage' , @level0type=N'SCHEMA',@level0name=N'NoExamEntrance', @level1type=N'TABLE',@level1name=N'Documents', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'4:is access menu' , @level0type=N'SCHEMA',@level0name=N'useraccess', @level1type=N'TABLE',@level1name=N'MenuApps', @level2type=N'COLUMN',@level2name=N'MenuType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[10] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Field"
            Begin Extent = 
               Top = 14
               Left = 678
               Bottom = 127
               Right = 848
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fnewStudent"
            Begin Extent = 
               Top = 19
               Left = 248
               Bottom = 211
               Right = 425
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "RequestChangeField"
            Begin Extent = 
               Top = 6
               Left = 461
               Bottom = 186
               Right = 643
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Field_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1920
         Width = 3600
         Width = 1500
         Width = 2190
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'requestfield'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'requestfield'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'requestfield'
GO
