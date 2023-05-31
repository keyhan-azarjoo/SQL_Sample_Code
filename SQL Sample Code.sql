

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionFiles]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	<Keyhan,,azarjoo>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Insert_VersionFiles]

	 @Str_Type as nvarchar(10) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_FileSize nvarchar(20) = " ",
	 @Str_CRC as nvarchar(5) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @Int_PartNo as int = 0,
	 @Bin_FileContent as varbinary(MAX),
	 @str_StartData as nvarchar(10) = " ",
	 @str_FinishData as nvarchar(10) = " ",
	 @str_description as nvarchar(max) = " "
	 



AS

BEGIN
	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()
	


	INSERT INTO Tbl_VersionFiles 
	
		(Str_Type,Str_FileName,Str_FileSize,Str_CRC,Str_VersionNo,Int_PartNo,Bin_FileContent,Str_Date,Str_Time,Str_Description)

	 VALUES 
	 
		(@Str_Type,@Str_FileName,@Str_FileSize,@Str_CRC,@Str_VersionNo,@Int_PartNo,@Bin_FileContent,@Str_Date,@Str_Time,@Str_Description)
	

END


GO







-- ========================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetServerInfoForDiag]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_GetServerInfoForDiag]
GO

-- =================================================================
-- Author:		 Keyhan Azarjoo
-- Create date:  January 16,2019
-- Description:	 
-- =================================================================

CREATE PROCEDURE [dbo].[SP_GetServerInfoForDiag]

	@int_state as int

AS

if @int_state = 0
-- GetBackup

BEGIN
	declare @Db_Name as nvarchar(500)

	set @Db_Name = ( select top 1 DBList_Name from Db_ParsicMaster.dbo.TBL_DBList where DBList_IsActive = 1)


	select top 3 backset.database_name as 'Database Name', backset.server_name as 'Server Name', backset.machine_name as 'Computer Name' ,db_BackAddress.physical_device_name 'Address', backset.backup_finish_date as 'Date',   backset.compressed_backup_size as 'Size'
	
	from msdb.dbo.backupset as backset left join msdb.dbo.backupmediafamily as db_BackAddress 
	on backset.media_set_id = db_BackAddress.media_set_id
	where database_name =  @Db_Name and catalog_media_number = 1  order by Date desc
end

if @int_state = 1
-- dreamLab send


select Str_OutSourceName as Name,Str_WebServiceURL as URL,Str_UserName as UserName, Str_Password as 'Password' ,
(select Count(distinct Frk_OutSourceAdmitID) as 'Count'  from Tbl_OutSourceAdmit where Frk_OutSourceContractorID = Tbl_OutSource.Prk_OutSourceID and cast(Str_AdmitDate as datetime) > cast(DATEADD(DD,-30, getdate()) as datetime)) as 'Month Count',
(select Count(distinct Frk_OutSourceAdmitID) as 'Count'  from Tbl_OutSourceAdmit where Frk_OutSourceContractorID = Tbl_OutSource.Prk_OutSourceID and cast(Str_AdmitDate as datetime) = cast(getdate() as datetime)) as 'Today Count',
(select Top 1  Str_AdmitDate from Tbl_OutSourceAdmit where Frk_OutSourceContractorID = Tbl_OutSource.Prk_OutSourceID order by Str_AdmitDate desc) as 'Last'
from Tbl_OutSource
where Int_ContractorID <> '' and Str_Password <> '' and Str_UserName <> '' and Str_WebServiceURL <> ''
GO
-- ========================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionDescriptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionDescriptions]
GO

Create PROCEDURE [dbo].[SP_Insert_VersionDescriptions]
-- =============================================
-- Author:	<Keyhan,,azarjoo>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
	 @frk_ParsicUserID as int = 0,
	 @Str_VersionNumber nvarchar(10) = '',
	 @str_Title nvarchar(200) = '',
	 @str_Description as nvarchar(MAX) =  '',
	 @int_Order int = 0,
	 @bit_Visibility as bit = 0,
	 @bit_LerningTips as bit = 0,
	 @int_Code as int = 0
AS


BEGIN
	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)


	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()


	INSERT INTO Tbl_VersionReleaseVDescription
	
		(frk_ParsicUserID,Str_VersionNumber,str_Title,str_Description,int_Order,str_Date,str_Time,bit_Visibility,bit_LerningTips,int_Code)

	 VALUES 	 

		(@frk_ParsicUserID,@Str_VersionNumber,@str_Title,@str_Description,@int_Order,@Str_Date,@Str_Time,@bit_Visibility,@bit_LerningTips,@int_Code)

	
END


GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionFiles]
GO


CREATE PROCEDURE [dbo].[SP_Insert_VersionFiles]
-- =============================================
-- Author:	<Keyhan,,azarjoo>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
	 @Str_Type as nvarchar(50) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_FileSize nvarchar(20) = " ",
	 @Str_CRC as nvarchar(5) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @Int_PartNo as int = 0,
	 @Bin_FileContent as varbinary(MAX),
	 @str_StartData as nvarchar(10) = " ",
	 @str_FinishData as nvarchar(10) = " ",
	 @str_description as nvarchar(max) = " "

	 

AS


BEGIN

	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)


	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()

	

	INSERT INTO Tbl_VersionFiles 

		(Str_Type,Str_FileName,Str_FileSize,Str_CRC,Str_VersionNo,Int_PartNo,Bin_FileContent,Str_Date,Str_Time,Str_Description)

	 VALUES 

		(@Str_Type,@Str_FileName,@Str_FileSize,@Str_CRC,@Str_VersionNo,@Int_PartNo,@Bin_FileContent,@Str_Date,@Str_Time,@Str_Description)

END

GO
-- ========================================================================================================


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ClientComputerInformation]') AND type in (N'P', N'PC'))

DROP PROCEDURE [dbo].[SP_Insert_ClientComputerInformation]

GO







CREATE PROCEDURE [dbo].[SP_Insert_ClientComputerInformation]

-- =============================================

-- Author:	<Keyhan,,azarjoo>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

	 @Str_ComputerName nvarchar(100) = " ",

	 @Str_IP nvarchar(20) = " ",

	 @Str_XMLInformation as nvarchar(MAX) = " ",

	 @Str_LabUserName as nvarchar(500) = " ",

	 @Str_Description as nvarchar(MAX) = " "

	 

AS



BEGIN

	 declare @str_Date as nvarchar(10)

	 declare @str_Time as nvarchar(10)



	 set @str_Date = dbo.GetNowDate()

	 set @str_Time = dbo.GetNowTime()

	

	delete from Tbl_ClientComputerInformation where Str_ComputerName = @Str_ComputerName





	INSERT INTO Tbl_ClientComputerInformation 

	

		(Str_ComputerName,Str_IP,Str_LabUserName,Str_XMLInformation,Str_Description,Str_Date,Str_Time)



	 VALUES 

	 

		(@Str_ComputerName,@Str_IP,@Str_LabUserName,@Str_XMLInformation,@Str_Description,@Str_Date,@Str_Time)

END

GO


-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ResultWay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_ResultWay]

GO

-- =============================================
-- Author:		Keyhan Azarjooooo
-- Create date: Oct 02,2019
-- Description:
-- =============================================
Create PROCEDURE [dbo].[SP_Get_ResultWay]

	 @Str_StartDate as nvarchar(10) = '1995/01/01',
	 @Str_FinishDate nvarchar(10) = '2095/01/01',
	 @int_state as int = 1

AS

 if @int_state = 1
 BEGIN

    Declare @SMSText as nvarchar(max) =''
	Declare @GeneratedShortLinkCount as bigint

	Declare @LastRobotActivity as nvarchar(max)=''

	Declare @WebCount as bigint=0
	Declare @RobotCount as bigint=0
	Declare @ParsiLabCount as bigint=0
	Declare @ShortLinkCount as bigint=0
	Declare @SelfServiceCount as bigint=0


	Declare @LastDbName as nvarchar(max)=''
	Declare @LastDbBackup as nvarchar(max)=''
	Declare @LabVersion as nvarchar(max)=''




	select top 1 @SMSText= Str_MessageText  from Tbl_SMS_Profile where Str_ProfileToken='SMSNotLimited'

	select top 1 @GeneratedShortLinkCount= count(*)   from Tbl_SMS_Queue  where Str_MessageText like '%pws.ir%'

	select top 1 @LastRobotActivity = Str_Date + ' ' + Str_Time   from Tbl_BotLog_Patient  order by Prk_BotLog_Patient_AutoID DESC


	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LogRemoteDeliveryResult]') AND type in (N'U'))
	BEGIN

		select top 1 @WebCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=0  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @RobotCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=1  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ParsiLabCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=2  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ShortLinkCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=3  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @SelfServiceCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=4  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	END


	set @LastDbName = (select isnull((select top 1 isnull(DBList_Name,'') from Db_ParsicMaster.dbo.TBL_DBList where DBList_IsActive=1),''))


	if @LastDbName <> ''
	begin
			set @LastDbBackup = (select isnull((SELECT top 1 isnull( cast(bs.backup_start_date as nvarchar(max)),'') FROM msdb.dbo.backupmediafamily bmf JOIN msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id WHERE bs.database_name = @LastDbName ORDER BY bmf.media_set_id DESC),''))
	end


	set @LabVersion = (select isnull((select top 1 isnull(Option_Value,'') from cTBL_Option where Option_ID='DataBaseVer'),''))



	SELECT dbo.Get_SysOption('ParsicLabID') as ParsicLabID,
		   @SMSText as SMSText,@GeneratedShortLinkCount as GeneratedShortLinkCount,@WebCount as WebCount,@RobotCount as RobotCount,@ParsiLabCount as ParsiLabCount,@ShortLinkCount as ShortLinkCount,@SelfServiceCount as SelfServiceCount
		   ,@LabVersion as LabVersion,dbo.Get_SysOption('LabWebSiteURL') as LabWebSiteURL,@LastDbName as Str_LastDataBaseName,
		   @LastDbBackup as LastDbBackupDate ,SERVERPROPERTY('productversion') as SQLVersion, SERVERPROPERTY ('productlevel') as SQLServicePack, SERVERPROPERTY ('edition') as SQLEdition

 END

GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ResultWay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_ResultWay]
GO

-- =============================================
-- Author:		Keyhan Azarjooooo
-- Create date: Oct 02,2019
-- Description:
-- =============================================
Create PROCEDURE [dbo].[SP_Get_ResultWay]

	 @Str_StartDate as nvarchar(10) = '1995/01/01',
	 @Str_FinishDate nvarchar(10) = '2095/01/01',
	 @int_state as int = 1

AS

 if @int_state = 1
 BEGIN

    Declare @SMSText as nvarchar(max) =''
	Declare @GeneratedShortLinkCount as bigint

	Declare @LastRobotActivity as nvarchar(max)=''

	Declare @WebCount as bigint=0
	Declare @RobotCount as bigint=0
	Declare @ParsiLabCount as bigint=0
	Declare @ShortLinkCount as bigint=0
	Declare @SelfServiceCount as bigint=0
	Declare @NemomegiriDarbeManzel as bigint=0
	Declare @PazireshOnlineErsali as bigint=0
	Declare @SorathesabeErsali as bigint=0
	Declare @PardakhteErsali as bigint=0
	Declare @PardakhteOnline as bigint=0
	Declare @Linkeferestadeshode as bigint=0

	Declare @LastDbName as nvarchar(max)=''
	Declare @LastDbBackup as nvarchar(max)=''
	Declare @LabVersion as nvarchar(max)=''




	select top 1 @SMSText= Str_MessageText  from Tbl_SMS_Profile where Str_ProfileToken='SMSNotLimited'

	select top 1 @GeneratedShortLinkCount= count(*)   from Tbl_SMS_Queue  where Str_MessageText like '%pws.ir%'  and cast(Tbl_SMS_Queue.Str_Send_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Tbl_SMS_Queue.Str_Send_Date as datetime) <= cast(@Str_FinishDate as datetime)

	select top 1 @LastRobotActivity = Str_Date + ' ' + Str_Time   from Tbl_BotLog_Patient  order by Prk_BotLog_Patient_AutoID DESC


	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LogRemoteDeliveryResult]') AND type in (N'U'))
	BEGIN

		select top 1 @WebCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=0  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @RobotCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=1  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ParsiLabCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=2  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ShortLinkCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=3  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @SelfServiceCount = count(*)  from Tbl_LogRemoteDeliveryResult where Int_Source=4  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	END

	Select top 1 @NemomegiriDarbeManzel = count(*) from Tbl_RequestPreAdmit where cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)
	Select top 1 @PazireshOnlineErsali = count(*) from TBL_AdmitPatient where int_SaveFrom =1 and cast(Str_AdmitDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_AdmitDate as datetime) <= cast(@Str_FinishDate as datetime)
	select top 1 @SorathesabeErsali =  count(*) from Tbl_ContractorBill where  cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)
	select top 1 @PardakhteErsali =  count(*) from Tbl_PayAccount  where  cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
	Select top 1 @PardakhteOnline = count(*) from Tbl_OnlinePaymentInvoice   where  cast(Str_LogCreateDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogCreateDate as datetime) <= cast(@Str_FinishDate as datetime)
	select top 1 @Linkeferestadeshode =  count(*) from Tbl_SMS_Queue where Str_MessageText like '%pws.ir%'  and  cast(Str_Schedule_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Schedule_Date as datetime) <= cast(@Str_FinishDate as datetime)


	set @LastDbName = (select isnull((select top 1 isnull(DBList_Name,'') from Db_ParsicMaster.dbo.TBL_DBList where DBList_IsActive=1),''))


	if @LastDbName <> ''
	begin
			set @LastDbBackup = (select isnull((SELECT top 1 isnull( cast(bs.backup_start_date as nvarchar(max)),'') FROM msdb.dbo.backupmediafamily bmf JOIN msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id WHERE bs.database_name = @LastDbName ORDER BY bmf.media_set_id DESC),''))
	end


	set @LabVersion = (select isnull((select top 1 isnull(Option_Value,'') from cTBL_Option where Option_ID='DataBaseVer'),''))



	SELECT dbo.Get_SysOption('ParsicLabID') as ParsicLabID,
		   @SMSText as SMSText,@GeneratedShortLinkCount as GeneratedShortLinkCount,@WebCount as WebCount,@RobotCount as RobotCount,@ParsiLabCount as ParsiLabCount,@ShortLinkCount as ShortLinkCount,@SelfServiceCount as SelfServiceCount
		   ,@NemomegiriDarbeManzel as 'DarbeManzl', @PazireshOnlineErsali as 'PazireshOnlineErsali', @SorathesabeErsali as 'SoratHesabeersali', @PardakhteErsali as 'Pardakhteersali', @PardakhteOnline as 'PardakhteOnline', @Linkeferestadeshode as 'linkeferestadeshode'
		   ,@LabVersion as LabVersion,dbo.Get_SysOption('LabWebSiteURL') as LabWebSiteURL,@LastDbName as Str_LastDataBaseName,
		   @LastDbBackup as LastDbBackupDate ,SERVERPROPERTY('productversion') as SQLVersion, SERVERPROPERTY ('productlevel') as SQLServicePack, SERVERPROPERTY ('edition') as SQLEdition

 END
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ResultWay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_ResultWay]

GO

-- =============================================
-- Author:		Keyhan Azarjooooo
-- Create date: Oct 02,2019
-- Description:
-- =============================================
Create PROCEDURE [dbo].[SP_Get_ResultWay]

	 @Str_StartDate as nvarchar(10) = '1995/01/01',
	 @Str_FinishDate nvarchar(10) = '2095/01/01',
	 @int_state as int = 1

AS

 if @int_state = 1
 BEGIN
	
	-- =========================================================================================================================
	-- نوبت دهی اینترنتی
	Declare @InternetQueueAll as bigint=0
	Declare @InternetQueueViaParsilab as bigint=0
	Declare @InternetQueueViaWeb as bigint=0

	
	Select Count(*) as AllCount,Count(Case When Frk_Source=2 Then 1 End) as ParsilabCount,Count(Case When Frk_Source=1 Then 1 End) as WebCount
	Into #Tbl_InternetQueue
	From Tbl_InternetQueue
	Where cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	Set @InternetQueueAll = (Select Top 1 AllCount From #Tbl_InternetQueue)
	Set @InternetQueueViaParsilab = (Select Top 1 ParsilabCount From #Tbl_InternetQueue)
	Set @InternetQueueViaWeb = (Select Top 1 WebCount From #Tbl_InternetQueue)
	-- =========================================================================================================================


	-- درخواست پیش پذیرش
	Declare @RequestPreAdmitAll as bigint=0
	Declare @RequestPreAdmitViaRobot as bigint=0
	Declare @RequestPreAdmitViaParsilab as bigint=0
	Declare @RequestPreAdmitViaWeb as bigint=0
	Declare @RequestPreAdmitViaCentral as bigint=0


	Select Count(*) as AllCount,Count(Case When Int_RequesterSource=1 Then 1 End) as RobotCount,Count(Case When Int_RequesterSource=2 Then 1 End) as WebCount,Count(Case When Int_RequesterSource=3 Then 1 End) as ParsilabCount,Count(Case When Int_RequesterSource=4 Then 1 End) as CentralCount
	Into #Tbl_RequestPreAdmit
	From Tbl_RequestPreAdmit
	Where cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	Set @RequestPreAdmitAll = (Select Top 1 AllCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaRobot = (Select Top 1 RobotCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaParsilab = (Select Top 1 ParsilabCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaWeb = (Select Top 1 WebCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaCentral = (Select Top 1 CentralCount From #Tbl_RequestPreAdmit)

	--=========================================================================================================================

	
	-- پذیرش ارسالی از وب سایت
	Declare @PazireshOnlineErsali as bigint=0
	Select top 1 @PazireshOnlineErsali = count(*) from TBL_AdmitPatient where int_SaveFrom =1 and cast(Str_AdmitDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_AdmitDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- پرداخت آنلاین
	Declare @PardakhteOnlineSuccess as bigint=0
	Select top 1 @PardakhteOnlineSuccess = count(*) from Tbl_OnlinePaymentInvoice   where Int_TransactionState = 6 And cast(Str_LogCreateDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogCreateDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- نمونه گیری درب منزل
	Declare @NemomegiriDarbeManzel as bigint=0
	Select top 1 @NemomegiriDarbeManzel = count(*) from Tbl_RequestPreAdmit where Bit_HomeSampling=1 And Frk_OutsiteSampler > 0 And Frk_PreAdmitID > 0 And cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- تایید آزمایشگاه راه دور
	Declare @LabConfirmViaParsiTel as bigint=0
	Select top 1 @LabConfirmViaParsiTel = count(distinct FRK_AdmitPatient) from Tbl_LogLabConfirm   where Str_Description like N'%پارسیتل%' And cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- دریافت جواب غیرحضوری
	Declare @WebCount as bigint=0
	Declare @RobotCount as bigint=0
	Declare @ParsiLabCount as bigint=0
	Declare @ShortLinkCount as bigint=0
	Declare @SelfServiceCount as bigint=0

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LogRemoteDeliveryResult]') AND type in (N'U'))
	BEGIN

		select top 1 @WebCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=0  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @RobotCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=1  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ParsiLabCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=2  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ShortLinkCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=3  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @SelfServiceCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=4  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	END

	--=========================================================================================================================

	-- لینک فرستاده شده
	Declare @Linkeferestadeshode as bigint=0
	select top 1 @Linkeferestadeshode =  count(*) from Tbl_SMS_Queue where Str_MessageText like '%pws.ir%'  and  cast(Str_Schedule_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Schedule_Date as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================


	-- عمومی
	Declare @SMSText as nvarchar(max) =''
	Declare @LastDbName as nvarchar(max)=''
	Declare @LastDbBackup as nvarchar(max)=''
	Declare @LabVersion as nvarchar(max)=''


	select top 1 @SMSText= Str_MessageText  from Tbl_SMS_Profile where Str_ProfileToken='SMSNotLimited'
	
	


	set @LastDbName = (select isnull((select top 1 isnull(DBList_Name,'') from Db_ParsicMaster.dbo.TBL_DBList where DBList_IsActive=1),''))


	if @LastDbName <> ''
	begin
			set @LastDbBackup = (select isnull((SELECT top 1 isnull( cast(bs.backup_start_date as nvarchar(max)),'') FROM msdb.dbo.backupmediafamily bmf JOIN msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id WHERE bs.database_name = @LastDbName ORDER BY bmf.media_set_id DESC),''))
	end


	set @LabVersion = (select isnull((select top 1 isnull(Option_Value,'') from cTBL_Option where Option_ID='DataBaseVer'),''))



	--=========================================================================================================================
	

	SELECT @InternetQueueAll as InternetQueueAll,@InternetQueueViaParsilab as InternetQueueViaParsilab,@InternetQueueViaWeb as InternetQueueViaWeb,
			@RequestPreAdmitAll as RequestPreAdmitAll,@RequestPreAdmitViaRobot as RequestPreAdmitViaRobot,@RequestPreAdmitViaParsilab as RequestPreAdmitViaParsilab,@RequestPreAdmitViaWeb as RequestPreAdmitViaWeb,@RequestPreAdmitViaCentral as RequestPreAdmitViaCentral,
			@PazireshOnlineErsali as PazireshOnlineErsali,
			@PardakhteOnlineSuccess as PardakhteOnlineSuccess,
			@NemomegiriDarbeManzel as NemomegiriDarbeManzel,
			@LabConfirmViaParsiTel as LabConfirmViaParsiTel,
			@WebCount as WebCount,@RobotCount as RobotCount,@ParsiLabCount as ParsiLabCount,@ShortLinkCount as ShortLinkCount,@SelfServiceCount as SelfServiceCount,
			@Linkeferestadeshode as Linkeferestadeshode,
			@SMSText as SMSText,@LastDbBackup as LastDbBackup,@LabVersion as LabVersion,
			dbo.Get_SysOption('ParsicLabID') as ParsicLabID,
			dbo.Get_SysOption('LabWebSiteURL') as LabWebSiteURL,@LastDbName as Str_LastDataBaseName,
			SERVERPROPERTY('productversion') as SQLVersion, SERVERPROPERTY ('productlevel') as SQLServicePack, SERVERPROPERTY ('edition') as SQLEdition
	

 END

GO



-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Tbl_BackupSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Update_Tbl_BackupSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SP_Update_Tbl_BackupSchedule]

	 @Prk_BackupSchedule_AutoID	 as int = 0,
	 @Frk_UserID as int = 0,
	 @Str_Type as nvarchar(30) = '',
	 @Str_Name as nvarchar(500) = '',
	 @Str_Ocuure  as nvarchar(30),
	 @Bit_Saturday as bit = False,
	 @Bit_Sunday as  bit = False,
	 @Bit_Monday as bit = False,
	 @Bit_Tuesday as bit = False, 
	 @Bit_Wednesday as bit = False, 
	 @Bit_Thursday as bit = False, 
	 @Bit_Friday as bit = False, 
	 @Str_DBNames as nvarchar(1000) = '',
	 @Bit_OccuresOnAt as bit = False, 
	 @Str_OccuresOnAtTime as nvarchar(10) = '' , 
	 @Bit_OccuresEvery as bit = False,  
	 @Str_OccuresEveryMinute as nvarchar(10) = '',
	 @Str_StartAtTime as nvarchar(10) = '',
	 @Str_FinishAtTime as nvarchar(10) = '',
	 @Str_Description as nvarchar(Max) = '',
	 @Str_IISNetworkPath as nvarchar(500) = '',
	 @Str_IISPath as nvarchar(500) = '',
	 @Bit_Enabled as bit = 1


AS

BEGIN


	 begin
	 UPdate Tbl_BackupSchedule 
	
						SET 
						Frk_UserID = @Frk_UserID,
						Str_Name = @Str_Name,
						Bit_Enabled = @Bit_Enabled,
						Str_Type = @Str_Type,
						Str_Ocuure = @Str_Ocuure,
						Bit_Saturday = @Bit_Saturday,
						Bit_Sunday = @Bit_Sunday,
						Bit_Monday = @Bit_Monday,
						Bit_Tuesday = @Bit_Tuesday,
						Bit_Wednesday = @Bit_Wednesday,
						Bit_Thursday = @Bit_Thursday,
						Bit_Friday=@Bit_Friday,
						Str_DbNames=@Str_DbNames,
						Bit_OccuresOnAt=@Bit_OccuresOnAt,
						Str_OccuresOnAtTime=@Str_OccuresOnAtTime,
						Bit_OccuresEvery=@Bit_OccuresEvery,
						Str_OccuresEveryMinute=@Str_OccuresEveryMinute,
						Str_StartAtTime=@Str_StartAtTime,
						Str_FinishAtTime=@Str_FinishAtTime,
						Str_Description=@Str_Description,
						Str_IISNetworkPath=@Str_IISNetworkPath,
						Str_IISPath=@Str_IISPath


				where Prk_BackupSchedule_AutoID = @Prk_BackupSchedule_AutoID	
						


	 end

end
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Update_Full_Diff_BackupLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SP_Update_Full_Diff_BackupLogs]

		@FullDiffLabsBackupLogsID as int = 0,
		@Str_BackupSize as nvarchar(20) = " ",
		@Str_ChkSum as nvarchar(10) = " ",
		@Str_Backup_start_date_for_check as nvarchar(500) = " ",
		@Str_FinishDate as nvarchar(10) = " ",
		@Str_FinishTime as nvarchar(10) = " ",
		@Str_IISBackupPath as nvarchar(MAX) = " ",
	   	@Str_ErrorLog as nvarchar(MAX) = " ",
		@Bit_TransferToFTP as bit = 0,
	   	@Str_FtpPath as nvarchar(MAX) = " ",
		@Str_Description as nvarchar(MAX) = " ",
		@Int_Status as int = 0


AS

BEGIN


	 begin
	 UPdate Tbl_Full_Diff_BackupLogs 
	
						SET 
						Str_BackupSize = @Str_BackupSize,
						Str_ChkSum = @Str_ChkSum,
						Str_Backup_start_date_for_check = @Str_Backup_start_date_for_check,
						Str_FinishDate = @Str_FinishDate,
						Str_FinishTime = @Str_FinishTime,
						Str_IISBackupPath = @Str_IISBackupPath,
						Str_ErrorLog = @Str_ErrorLog,
						Bit_TransferToFTP = @Bit_TransferToFTP,
						Str_FtpPath = @Str_FtpPath,
						Str_Description = @Str_Description,
						Int_Status = @Int_Status
						
				where Prk_FullDiffLabsBackupLogs_AutoID = @FullDiffLabsBackupLogsID		
						


	 end

end
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_BackupSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_BackupSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================

CREATE PROCEDURE [dbo].[SP_Get_BackupSchedule]

AS

		SELECT * from Tbl_BackupSchedule
	
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================



CREATE PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]

		@Type as nvarchar(10) = 'Full',
		@Count as int = 10
AS

BEGIN

	select top (@Count) * from Tbl_Full_Diff_BackupLogs where Str_BackupType = @Type order by Prk_FullDiffLabsBackupLogs_AutoID desc

end
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_Full_Diff_BackupLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================



CREATE PROCEDURE [dbo].[SP_Insert_Full_Diff_BackupLogs]

		@Frk_BackupScheduleID as int = 0,
		@Frk_Repository as int = -1,
		@Str_DBName as nvarchar(500) = " ",
	   	@Str_BackupType as nvarchar(50) = " ",
		@Str_BackupSize as nvarchar(20) = " ",
		@Str_ChkSum as nvarchar(10) = " ",
		@Int_LastReception as bigint = 0,
		@Str_Backup_start_date_for_check as nvarchar(500) = " ",
		@Str_FinishDate as nvarchar(10) = " ",
		@Str_FinishTime as nvarchar(10) = " ",
		@Str_DBBackupPath as nvarchar(MAX) = " ",
		@Str_IISBackupPath as nvarchar(MAX) = " ",
	   	@Str_ErrorLog as nvarchar(MAX) = " ",
		@Bit_TransferToFTP as bit = 0,
	   	@Str_FtpPath as nvarchar(MAX) = " ",
		@Str_Description as nvarchar(MAX) = " ",
		@Int_Status as int = 0


AS

BEGIN

	 declare @str_CreationDate as nvarchar(10)
	 declare @str_CreationTime as nvarchar(10)

	 set @str_CreationDate = dbo.GetNowDate()
	 set @str_CreationTime = dbo.GetNowTime()




	 begin
	 INSERT INTO Tbl_Full_Diff_BackupLogs 
	
						(Frk_BackupScheduleID,Frk_Repository,Str_DBName,Str_BackupType,Str_BackupSize,Int_LastReception,Str_Backup_start_date_for_check,Str_StartDate,Str_StartTime,Str_FinishDate,Str_FinishTime,Str_DBBackupPath,Str_IISBackupPath,Str_ErrorLog,Bit_TransferToFTP,Str_FtpPath,Str_Description,Int_Status)

						VALUES 
	 

						(@Frk_BackupScheduleID,@Frk_Repository,@Str_DBName,@Str_BackupType,@Str_BackupSize,@Int_LastReception,@Str_Backup_start_date_for_check,@str_CreationDate,@str_CreationTime,@Str_FinishDate,@Str_FinishTime,@Str_DBBackupPath,@Str_IISBackupPath,@Str_ErrorLog,@Bit_TransferToFTP,@Str_FtpPath,@Str_Description,@Int_Status)
	
	 SELECT SCOPE_IDENTITY()
	 end

end
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_BackupSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Delete_BackupSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================

Create PROCEDURE [dbo].[SP_Delete_BackupSchedule]

	 @int_BackupScheduleID as int = 0

AS


BEGIN

	Delete From Tbl_BackupSchedule where Prk_BackupSchedule_AutoID = @int_BackupScheduleID

end 

GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_BackupSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_BackupSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================


CREATE PROCEDURE [dbo].[SP_Insert_BackupSchedule]

	 @Frk_UserID as int = 0,
	 @Str_Type as nvarchar(30) = '',
	 @Str_Name as nvarchar(500) = '',
	 @Str_Ocuure  as nvarchar(30),
	 @Bit_Saturday as bit = False,
	 @Bit_Sunday as  bit = False,
	 @Bit_Monday as bit = False,
	 @Bit_Tuesday as bit = False, 
	 @Bit_Wednesday as bit = False, 
	 @Bit_Thursday as bit = False, 
	 @Bit_Friday as bit = False, 
	 @Str_DBNames as nvarchar(1000) = '',
	 @Bit_OccuresOnAt as bit = False, 
	 @Str_OccuresOnAtTime as nvarchar(10) = '' , 
	 @Bit_OccuresEvery as bit = False,  
	 @Str_OccuresEveryMinute as nvarchar(10) = '',
	 @Str_StartAtTime as nvarchar(10) = '',
	 @Str_FinishAtTime as nvarchar(10) = '',
	 @Str_Description as nvarchar(Max) = '',
	 @Str_IISNetworkPath as nvarchar(500) = '',
	 @Str_IISPath as nvarchar(500) = '',
	 @Bit_Enabled as bit = false


AS

BEGIN

	 declare @str_CreationDate as nvarchar(10)
	 declare @str_CreationTime as nvarchar(10)

	 set @str_CreationDate = dbo.GetNowDate()
	 set @str_CreationTime = dbo.GetNowTime()

	 INSERT INTO Tbl_BackupSchedule 
	
						(Frk_UserID,Bit_Enabled,Str_Type,Str_Name,Str_Ocuure,Bit_Saturday,Bit_Sunday,Bit_Monday,Bit_Tuesday,Bit_Wednesday,Bit_Thursday,Bit_Friday,Str_DBNames,Bit_OccuresOnAt,Str_OccuresOnAtTime,Bit_OccuresEvery,Str_OccuresEveryMinute,Str_StartAtTime,Str_FinishAtTime,Str_Description,Str_IISNetworkPath,Str_IISPath,Str_Date,Str_Time)

						VALUES 
	 
						(@Frk_UserID,@Bit_Enabled,@Str_Type,@Str_Name,@Str_Ocuure,@Bit_Saturday,@Bit_Sunday,@Bit_Monday,@Bit_Tuesday,@Bit_Wednesday,@Bit_Thursday,@Bit_Friday,@Str_DBNames,@Bit_OccuresOnAt,@Str_OccuresOnAtTime,@Bit_OccuresEvery,@Str_OccuresEveryMinute,@Str_StartAtTime,@Str_FinishAtTime,@Str_Description,@Str_IISNetworkPath,@Str_IISPath,@str_CreationDate,@str_CreationTime)

	

	
END

GO

-- ========================================================================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Full_Diff_BackupLogs]') AND type in (N'U'))
BEGIN
-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================


CREATE TABLE [dbo].[Tbl_Full_Diff_BackupLogs](
	[Prk_FullDiffLabsBackupLogs_AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Frk_BackupScheduleID] [int] NULL,
	[Frk_Repository] [int] NULL,
	[Str_DBName] [nvarchar](500) NULL,
	[Str_BackupType] [nvarchar](50) NULL,
	[Str_BackupSize] [nvarchar](20) NULL,
	[Str_ChkSum] [nvarchar](10) NULL,
	[Int_LastReception] [bigint] NULL,
	[Str_Backup_start_date_for_check] [nvarchar](500) NULL,
	[Str_StartDate] [nvarchar](10) NULL,
	[Str_StartTime] [nvarchar](10) NULL,
	[Str_FinishDate] [nvarchar](10) NULL,
	[Str_FinishTime] [nvarchar](10) NULL,
	[Str_DBBackupPath] [nvarchar](max) NULL,
	[Str_IISBackupPath] [nvarchar](max) NULL,
	[Str_ErrorLog] [nvarchar](max) NULL,
	[Bit_TransferToFTP] [bit] NULL,
	[Str_FtpPath] [nvarchar](max) NULL,
	[Str_Description] [nvarchar](max) NULL,
	[Int_Status] [int] NULL,
 CONSTRAINT [PK_Tbl_Full_Diff_BackupLogs] PRIMARY KEY CLUSTERED 
(
	[Prk_FullDiffLabsBackupLogs_AutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO

-- ========================================================================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_BackupSchedule]') AND type in (N'U'))
BEGIN
-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================

CREATE TABLE [dbo].[Tbl_BackupSchedule](
	[Prk_BackupSchedule_AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Frk_UserID] [int] NULL,
	[Str_Name] [nvarchar](500) NULL,
	[Bit_Enabled] [bit] NULL,
	[Str_Type] [nvarchar](30) NULL,
	[Str_Ocuure] [nvarchar](50) NULL,
	[Bit_Saturday] [bit] NULL,
	[Bit_Sunday] [bit] NULL,
	[Bit_Monday] [bit] NULL,
	[Bit_Tuesday] [bit] NULL,
	[Bit_Wednesday] [bit] NULL,
	[Bit_Thursday] [bit] NULL,
	[Bit_Friday] [bit] NULL,
	[Str_DbNames] [nvarchar](1000) NULL,
	[Bit_OccuresOnAt] [bit] NULL,
	[Str_OccuresOnAtTime] [nvarchar](10) NULL,
	[Bit_OccuresEvery] [bit] NULL,
	[Str_OccuresEveryMinute] [nvarchar](10) NULL,
	[Str_StartAtTime] [nvarchar](10) NULL,
	[Str_FinishAtTime] [nvarchar](10) NULL,
	[Str_Description] [nvarchar](max) NULL,
	[Str_IISNetworkPath] [nvarchar](500) NULL,
	[Str_IISPath] [nvarchar](500) NULL,
	[Str_Date] [nvarchar](10) NULL,
	[Str_Time] [nvarchar](10) NULL,
 CONSTRAINT [PK_Tbl_BackupSchedule] PRIMARY KEY CLUSTERED 
(
	[Prk_BackupSchedule_AutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

end

GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================



CREATE PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]

		@Type as nvarchar(10) = 'Full',
		@Count as int = 10,
		@DBName as nvarchar(500)=''
AS

BEGIN

	select top (@Count) * from Tbl_Full_Diff_BackupLogs where Str_BackupType = @Type And (@DBName='' Or Str_DBName = @DBName) order by Prk_FullDiffLabsBackupLogs_AutoID desc

end
GO

-- ========================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_VersionFiles]
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: July 06,2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Get_VersionFiles]

	 @Str_Type as nvarchar(50) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @int_state as int = 0

AS

 if @int_state = 1
 BEGIN

      SELECT * FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END
 else if @int_state = 2
 BEGIN
 
      SELECT Str_VersionNo FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
  END
  else if @int_state = 3
 BEGIN
 
      SELECT Str_Type,Str_VersionNo,Int_PartNo, Str_FileSize, Str_CRC FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END

-- ========================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_VersionFiles]
GO


-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: July 06,2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Get_VersionFiles]

	 @Str_Type as nvarchar(50) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @int_state as int = 0

AS

 if @int_state = 1
 BEGIN

      SELECT * FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END
 else if @int_state = 2
 BEGIN
 
      SELECT Str_VersionNo FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
  END
  else if @int_state = 3
 BEGIN
 
      SELECT Str_Type,Str_VersionNo,Int_PartNo, Str_FileSize, Str_CRC FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END
   else if @int_state = 4
 BEGIN


	declare @DbListName as nvarchar(100)
	declare @t as table(DbName nvarchar(100),DbVerC nvarchar(100),DbVerQ nvarchar(10),DbVerJ nvarchar(10),DbVerS nvarchar(10), PrintCatcherDB_Ver nvarchar(10))

	Declare cur cursor for ( 

			select DBList_Name from Db_ParsicMaster.dbo.TBL_DBList

		)

		open cur
		fetch next from cur into @DbListName


		while @@fetch_status = 0
		begin

			Insert Into @t 
			exec('select ''' + @DbListName + ''' as DBName, ( select Option_Value from ' + @DbListName + '.dbo.cTBL_Option where Option_ID = ''DataBaseVer'' ) as DataBaseVer ,  ( select Option_Value from ' + @DbListName + '.dbo.cTBL_Option where Option_ID = ''QualityControlDB_Ver'' ) as QualityControlDB_Ver ,  ( select Option_Value from ' + @DbListName + '.dbo.cTBL_Option where Option_ID = ''JournalDB_Ver'' ) as JournalDB_Ver  ,  ( select Option_Value from ' + @DbListName + '.dbo.cTBL_Option where Option_ID = ''StorageDB_Ver'' ) as StorageDB_Ver  ,  ( select Option_Value from ' + @DbListName + '.dbo.cTBL_Option where Option_ID = ''PrintCatcherDB_Ver'' ) as PrintCatcherDB_Ver ')

			fetch next from cur into @DbListName
		
		end

		close cur
		deallocate cur

		Select * from @t 



 
 END


-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Full_Diff_BackupSubLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_Full_Diff_BackupSubLogs]
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================

CREATE PROCEDURE [dbo].[SP_Insert_Full_Diff_BackupSubLogs]

		@Frk_BackupScheduleID as int = 0,
		@Frk_FullDiffLabsBackupID as int = 0,
		@Frk_Repository as int = -1,
		@Str_DBName as nvarchar(500) = " ",
	   	@Str_BackupType as nvarchar(50) = " ",

		@Str_BackupPath as nvarchar(MAX) = " ",
	   	@Str_ErrorLog as nvarchar(MAX) = " ",
	   	@Str_FtpPath as nvarchar(MAX) = " ",
		@Str_Description as nvarchar(MAX) = " ",
		@Int_Order as int = 0,
		@Int_WholeCount as int = 0

AS
BEGIN
	 declare @str_CreationDate as nvarchar(10)
	 declare @str_CreationTime as nvarchar(10)
	 set @str_CreationDate = dbo.GetNowDate()
	 set @str_CreationTime = dbo.GetNowTime()
	 begin
		INSERT INTO Tbl_Full_Diff_BackupSubLogs
				   (Frk_FullDiffLabsBackupID
				   ,Frk_BackupScheduleID
				   ,Frk_Repository
				   ,Str_DBName
				   ,Str_BackupType
				   ,Str_Date
				   ,Str_Time
				   ,Str_BackupPath
				   ,Str_ErrorLog
				   ,Str_FtpPath
				   ,Int_Order
				   ,Int_Count
				   ,Str_Description
				   )
			 VALUES
				   (@Frk_FullDiffLabsBackupID 
				   ,@Frk_BackupScheduleID
				   ,@Frk_Repository
				   ,@Str_DBName
				   ,@Str_BackupType
				   ,@str_CreationDate
				   ,@str_CreationTime
				   ,@Str_BackupPath
				   ,@Str_ErrorLog
				   ,@Str_FtpPath
				   ,@Int_Order
				   ,@Int_WholeCount
				   ,@Str_Description)
	 end

end
Go

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionFiles]
GO


CREATE PROCEDURE [dbo].[SP_Insert_VersionFiles]
-- =============================================
-- Author:	<Keyhan,,azarjoo>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
	 @Str_Type as nvarchar(50) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_FileSize nvarchar(20) = " ",
	 @Str_CRC as nvarchar(5) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @Int_PartNo as int = 0,
	 @Bin_FileContent as varbinary(MAX),
	 @str_StartData as nvarchar(10) = " ",
	 @str_FinishData as nvarchar(10) = " ",
	 @str_description as nvarchar(max) = " "

	 

AS


BEGIN

	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)


	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()

	

	INSERT INTO Tbl_VersionFiles 

		(Str_Type,Str_FileName,Str_FileSize,Str_CRC,Str_VersionNo,Int_PartNo,Bin_FileContent,Str_Date,Str_Time,Str_Description)

	 VALUES 

		(@Str_Type,@Str_FileName,@Str_FileSize,@Str_CRC,@Str_VersionNo,@Int_PartNo,@Bin_FileContent,@Str_Date,@Str_Time,@Str_Description)

END

GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]
GO


-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================


CREATE  PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]

		@Int_State as int = 0,
		@Type as nvarchar(10) = 'Full',
		@Count as int = 10,
		@DBName as nvarchar(500)=''
AS

BEGIN
	if(@Int_State = 0)
		begin
			select top (@Count) * from Tbl_Full_Diff_BackupLogs where Str_BackupType = @Type And (@DBName='' Or Str_DBName = @DBName) And Str_BackupSize>0 order by Prk_FullDiffLabsBackupLogs_AutoID desc
		end
	else if(@Int_State = 1)
		begin
			select top (@Count) * from Tbl_Full_Diff_BackupLogs order by Prk_FullDiffLabsBackupLogs_AutoID desc
		end
end

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Full_Diff_BackupLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: June 1 ,2020
-- Description:
-- =============================================



CREATE PROCEDURE [dbo].[SP_Get_Full_Diff_BackupLogs]

		@Type as nvarchar(10) = 'Full',
		@Count as int = 10,
		@DBName as nvarchar(500)=''
AS

BEGIN

	select top (@Count) * from Tbl_Full_Diff_BackupLogs where Str_BackupType = @Type And (@DBName='' Or Str_DBName = @DBName) And Str_BackupSize>0 order by Prk_FullDiffLabsBackupLogs_AutoID desc

end
GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_LastAutoBackupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_LastAutoBackupInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	 Keyhan Azarjoo
-- Create date: November 15 ,2020
-- Description:
-- =============================================

CREATE PROCEDURE [dbo].[SP_Get_LastAutoBackupInfo]

@Int_State as int = 0

AS

if @Int_State = 0
begin
select 
(select Option_Value  from TBL_Option where Option_ID = 'RecieptLabName') as 'Lab Name'
,(select top 1 Frk_ParsicUserID  from Tbl_VersionReleaseVSplitsSubLogs where Str_Description = 'SqlTransaction Commited' order by Prk_VersionReleaseVSubLogs_AutoID desc) as 'Parsic UserID'
,(select top 1 Option_Value from cTBL_Option where Option_ID = 'DataBaseVer') as 'Version'
,(select top 1 dbo.MiladiTOShamsi(Str_StartDate) +'     '+ Str_StartTime as 'Full' from Tbl_Full_Diff_BackupLogs where cast(Str_BackupSize as bigint) <>0 and Str_BackupType = 'Full' and Int_Status = 1 order by Prk_FullDiffLabsBackupLogs_AutoID desc) as 'Last Full Backup Date'
,(select top 1 (cast(Str_BackupSize as bigint)/1024/1024) as 'Full Size KB' from Tbl_Full_Diff_BackupLogs where cast(Str_BackupSize as bigint) <>0 and Str_BackupType = 'Full' and Int_Status = 1 order by Prk_FullDiffLabsBackupLogs_AutoID desc) as 'Last Full Backup Size MB'
,(select top 1 dbo.MiladiTOShamsi(Str_StartDate) +'     '+ Str_StartTime as 'Diff' from Tbl_Full_Diff_BackupLogs where cast(Str_BackupSize as bigint) <>0 and Str_BackupType = 'Diff' and Int_Status = 1 order by Prk_FullDiffLabsBackupLogs_AutoID desc) as 'Last Diff Backup Date'
,(select top 1 (cast(Str_BackupSize as bigint)/1024) as 'Diff Size KB' from Tbl_Full_Diff_BackupLogs where cast(Str_BackupSize as bigint) <>0 and Str_BackupType = 'Diff' and Int_Status = 1 order by Prk_FullDiffLabsBackupLogs_AutoID desc) as 'Last Diff Backup Size KB'
end

if @Int_State = 1
begin

select * from Tbl_Full_Diff_BackupLogs where cast(Str_BackupSize as bigint) <>0 and Str_BackupType = 'Full' and Int_Status = 1 and cast(Str_StartDate as datetime) > dateadd(day,-8 , (CAST(dbo.GetNowDate() as datetime))) order by Prk_FullDiffLabsBackupLogs_AutoID desc

end

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ClientComputerInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_ClientComputerInformation]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Keyhan Azarjoo
-- Create date: Dec 12,2020
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[SP_Insert_ClientComputerInformation]


	 @Str_SerialNumber as nvarchar(100) = '',
	 @Str_ComputerName as nvarchar(100) = " ",
	 @Str_IP as nvarchar(20) = " ",
	 @Str_XMLInformation as nvarchar(MAX) = " ",
	 @Str_LabUserName as nvarchar(500) = " ",
	 @Str_Description as nvarchar(MAX) = " "

AS

BEGIN

	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()

	delete from Tbl_ClientComputerInformation where Str_SerialNumber = @Str_SerialNumber

	INSERT INTO Tbl_ClientComputerInformation 

		(Str_SerialNumber,Str_ComputerName,Str_IP,Str_LabUserName,Str_XMLInformation,Str_Description,Str_Date,Str_Time)

	 VALUES 

		(@Str_SerialNumber,@Str_ComputerName,@Str_IP,@Str_LabUserName,@Str_XMLInformation,@Str_Description,@Str_Date,@Str_Time)

END

GO

-- ========================================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ResultWay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_ResultWay]

GO


-- =============================================
-- Author:		Keyhan Azarjooooo
-- Create date: Oct 02,2019
-- Description:
-- =============================================
Create PROCEDURE [dbo].[SP_Get_ResultWay]

	 @Str_StartDate as nvarchar(10) = '1995/01/01',
	 @Str_FinishDate nvarchar(10) = '2095/01/01',
	 @int_state as int = 1

AS

 if @int_state = 1
 BEGIN
	
	-- =========================================================================================================================
	-- کل بیماران
	Declare @AllPatient as bigint=0

	Set @AllPatient = (select Count (PRK_AdmitPatient) from pTBL_AdmitPatient where cast(Str_AdmitDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_AdmitDate as datetime) <= cast(@Str_FinishDate as datetime))
	--=========================================================================================================================
	-- نوبت دهی اینترنتی
	Declare @InternetQueueAll as bigint=0
	Declare @InternetQueueViaParsilab as bigint=0
	Declare @InternetQueueViaWeb as bigint=0

	
	Select Count(*) as AllCount,Count(Case When Frk_Source=2 Then 1 End) as ParsilabCount,Count(Case When Frk_Source=1 Then 1 End) as WebCount
	Into #Tbl_InternetQueue
	From Tbl_InternetQueue
	Where cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	Set @InternetQueueAll = (Select Top 1 AllCount From #Tbl_InternetQueue)
	Set @InternetQueueViaParsilab = (Select Top 1 ParsilabCount From #Tbl_InternetQueue)
	Set @InternetQueueViaWeb = (Select Top 1 WebCount From #Tbl_InternetQueue)
	--=========================================================================================================================


	-- درخواست پیش پذیرش
	Declare @RequestPreAdmitAll as bigint=0
	Declare @RequestPreAdmitViaRobot as bigint=0
	Declare @RequestPreAdmitViaParsilab as bigint=0
	Declare @RequestPreAdmitViaWeb as bigint=0
	Declare @RequestPreAdmitViaCentral as bigint=0


	Select Count(*) as AllCount,Count(Case When Int_RequesterSource=1 Then 1 End) as RobotCount,Count(Case When Int_RequesterSource=2 Then 1 End) as WebCount,Count(Case When Int_RequesterSource=3 Then 1 End) as ParsilabCount,Count(Case When Int_RequesterSource=4 Then 1 End) as CentralCount
	Into #Tbl_RequestPreAdmit
	From Tbl_RequestPreAdmit
	Where cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	Set @RequestPreAdmitAll = (Select Top 1 AllCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaRobot = (Select Top 1 RobotCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaParsilab = (Select Top 1 ParsilabCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaWeb = (Select Top 1 WebCount From #Tbl_RequestPreAdmit)
	Set @RequestPreAdmitViaCentral = (Select Top 1 CentralCount From #Tbl_RequestPreAdmit)

	--=========================================================================================================================

	
	-- پذیرش ارسالی از وب سایت
	Declare @PazireshOnlineErsali as bigint=0
	Select top 1 @PazireshOnlineErsali = count(distinct(PRK_AdmitPatient)) from TBL_AdmitPatient where int_SaveFrom =1 and cast(Str_AdmitDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_AdmitDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- پرداخت آنلاین
	Declare @PardakhteOnlineSuccess as bigint=0
	Select top 1 @PardakhteOnlineSuccess = count(*) from Tbl_OnlinePaymentInvoice   where Int_TransactionState = 6 And cast(Str_LogCreateDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogCreateDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- نمونه گیری درب منزل
	Declare @NemomegiriDarbeManzel as bigint=0
	Select top 1 @NemomegiriDarbeManzel = count(*) from Tbl_RequestPreAdmit where Bit_HomeSampling=1 And Frk_OutsiteSampler > 0 And Frk_PreAdmitID > 0 And cast(Str_LogDate as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_LogDate as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- تایید آزمایشگاه راه دور
	Declare @LabConfirmViaParsiTel as bigint=0
	Select top 1 @LabConfirmViaParsiTel = count(distinct FRK_AdmitPatient) from Tbl_LogLabConfirm   where Str_Description like N'%پارسیتل%' And cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================

	-- دریافت جواب غیرحضوری
	Declare @WebCount as bigint=0
	Declare @RobotCount as bigint=0
	Declare @ParsiLabCount as bigint=0
	Declare @ShortLinkCount as bigint=0
	Declare @SelfServiceCount as bigint=0

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LogRemoteDeliveryResult]') AND type in (N'U'))
	BEGIN

		select top 1 @WebCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=0  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @RobotCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=1  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ParsiLabCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=2  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @ShortLinkCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=3  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)
		select top 1 @SelfServiceCount = count(distinct Frk_AdmitID)  from Tbl_LogRemoteDeliveryResult where Int_Source=4  and cast(Str_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Date as datetime) <= cast(@Str_FinishDate as datetime)

	END

	--=========================================================================================================================

	-- لینک فرستاده شده
	Declare @Linkeferestadeshode as bigint=0
	select top 1 @Linkeferestadeshode =  count(distinct(Frk_AdmitID)) from Tbl_SMS_Queue where Str_MessageText like '%pws.ir%'  and  cast(Str_Schedule_Date as datetime) >= cast(@Str_StartDate as datetime) and cast(Str_Schedule_Date as datetime) <= cast(@Str_FinishDate as datetime)

	--=========================================================================================================================


	-- عمومی
	Declare @SMSText as nvarchar(max) =''
	Declare @LastDbName as nvarchar(max)=''
	Declare @LastDbBackup as nvarchar(max)=''
	Declare @LabVersion as nvarchar(max)=''


	select top 1 @SMSText= Str_MessageText  from Tbl_SMS_Profile where Str_ProfileToken='SMSNotLimited'
	
	


	set @LastDbName = (select isnull((select top 1 isnull(DBList_Name,'') from Db_ParsicMaster.dbo.TBL_DBList where DBList_IsActive=1),''))


	if @LastDbName <> ''
	begin
			set @LastDbBackup = (select isnull((SELECT top 1 isnull( cast(bs.backup_start_date as nvarchar(max)),'') FROM msdb.dbo.backupmediafamily bmf JOIN msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id WHERE bs.database_name = @LastDbName ORDER BY bmf.media_set_id DESC),''))
	end


	set @LabVersion = (select isnull((select top 1 isnull(Option_Value,'') from cTBL_Option where Option_ID='DataBaseVer'),''))



	--=========================================================================================================================
	

	SELECT  @AllPatient as AllPatient, @InternetQueueAll as InternetQueueAll,@InternetQueueViaParsilab as InternetQueueViaParsilab,@InternetQueueViaWeb as InternetQueueViaWeb,
			@RequestPreAdmitAll as RequestPreAdmitAll,@RequestPreAdmitViaRobot as RequestPreAdmitViaRobot,@RequestPreAdmitViaParsilab as RequestPreAdmitViaParsilab,@RequestPreAdmitViaWeb as RequestPreAdmitViaWeb,@RequestPreAdmitViaCentral as RequestPreAdmitViaCentral,
			@PazireshOnlineErsali as PazireshOnlineErsali,
			@PardakhteOnlineSuccess as PardakhteOnlineSuccess,
			@NemomegiriDarbeManzel as NemomegiriDarbeManzel,
			@LabConfirmViaParsiTel as LabConfirmViaParsiTel,
			@WebCount as WebCount,@RobotCount as RobotCount,@ParsiLabCount as ParsiLabCount,@ShortLinkCount as ShortLinkCount,@SelfServiceCount as SelfServiceCount,
			@Linkeferestadeshode as Linkeferestadeshode,
			@SMSText as SMSText,@LastDbBackup as LastDbBackup,@LabVersion as LabVersion,
			dbo.Get_SysOption('ParsicLabID') as ParsicLabID,
			dbo.Get_SysOption('LabWebSiteURL') as LabWebSiteURL,@LastDbName as Str_LastDataBaseName,
			SERVERPROPERTY('productversion') as SQLVersion, SERVERPROPERTY ('productlevel') as SQLServicePack, SERVERPROPERTY ('edition') as SQLEdition
	

 END

-- ========================================================================================================



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Create_Restore_DbBackup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Create_Restore_DbBackup]
GO
CREATE PROCEDURE [dbo].[SP_Create_Restore_DbBackup]

	 @Str_DbName as nvarchar(100) = ' ',
	 @Str_Path nvarchar(500) = ' ',
	 @int_state as int = 0

AS

	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()
	
 if @int_state = 1
 BEGIN
	Set @Str_Path = @Str_Path + @Str_DbName + Replace(@str_Date,'/','') + Replace(@str_Time,':','') + '.bak'
      BACKUP DATABASE @Str_DbName 
	  TO DISK = @Str_Path 
	  WITH FORMAT, 
		COMPRESSION; 
 END



  if @int_state = 2
  BEGIN
	RESTORE DATABASE @Str_DbName FROM DISK = @Str_Path
  END


GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_VersionFiles]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Tbl_VersionFiles](
		[Prk_CentralVersionFiles_AutoID] [int] IDENTITY(1,1) NOT NULL,
		[Str_Type] [nvarchar](10) NULL,
		[Str_FileName] [nvarchar](50) NULL,
		[Str_FileSize] [nvarchar](20) NULL,
		[Str_CRC] [nvarchar](5) NULL,
		[Str_VersionNo] [nvarchar](10) NULL,
		[Int_PartNo] [int] NULL,
		[Bin_FileContent] [varbinary](max) NULL,
		[Str_Date] [nvarchar](10) NULL,
		[Str_Time] [nvarchar](10) NULL,
		[Str_Description] [nvarchar](max) NULL,
	 CONSTRAINT [PK_Tbl_CentralVersionFiles] PRIMARY KEY CLUSTERED 
	(
		[Prk_CentralVersionFiles_AutoID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_VersionReleaseVDescription]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Tbl_VersionReleaseVDescription](
		[prk_VersionReleaseVDescription_AutoID] [int] IDENTITY(1,1) NOT NULL,
		[frk_ParsicUserID] [int] NOT NULL,
		[Str_VersionNumber] [nvarchar](10) NOT NULL,
		[str_Title] [nvarchar](200) NOT NULL,
		[str_Description] [nvarchar](max) NOT NULL,
		[int_Order] [int] NULL,
		[str_Date] [nvarchar](10) NOT NULL,
		[str_Time] [nvarchar](10) NOT NULL,
		[bit_Visibility] [bit] NULL,
		[bit_LerningTips] [bit] NULL,
		[int_Code] [int] NULL,
	 CONSTRAINT [PK_Tbl_VersionReleaseVDescription] PRIMARY KEY CLUSTERED 
	(
		[prk_VersionReleaseVDescription_AutoID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_VersionReleaseVLogs]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Tbl_VersionReleaseVLogs](
		[Prk_VersionReleaseLogs_AutoID] [int] IDENTITY(1,1) NOT NULL,
		[Frk_VersionReleaseID] [int] NULL,
		[Frk_ParsicUserID] [int] NOT NULL,
		[Str_VersionFrom] [nvarchar](5) NOT NULL,
		[Str_VersionTo] [nvarchar](5) NOT NULL,
		[Str_ErrorLog] [nvarchar](max) NULL,
		[Str_Description] [nvarchar](max) NULL,
		[Int_AppType] [nvarchar](50) NULL,
		[Int_LogType] [int] NULL,
		[Str_ComputerName] [nvarchar](100) NULL,
		[Str_DataBaseName] [nvarchar](100) NULL,
		[Bit_IsExe] [bit] NULL,
		[Str_ExeSize] [nvarchar](50) NULL,
		[Bit_IsActiveDB] [bit] NULL,
		[Str_Date] [nvarchar](10) NULL,
		[Str_Time] [nvarchar](10) NULL,
	 CONSTRAINT [PK_Tbl_VersionReleaseVLogs] PRIMARY KEY CLUSTERED 
	(
		[Prk_VersionReleaseLogs_AutoID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	End
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_VersionReleaseVSplitsSubLogs]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Tbl_VersionReleaseVSplitsSubLogs](
		[Prk_VersionReleaseVSubLogs_AutoID] [int] IDENTITY(1,1) NOT NULL,
		[Frk_ParsicUserID] [int] NOT NULL,
		[Str_ComputerName] [nvarchar](100) NULL,
		[Str_DbName] [nvarchar](100) NULL,
		[Bit_Exe] [bit] NULL,
		[Str_Version] [nvarchar](20) NULL,
		[Int_Order] [int] NULL,
		[Int_WholeCount] [int] NULL,
		[Str_ErrorLog] [nvarchar](max) NULL,
		[Str_Description] [nvarchar](max) NULL,
		[Str_Date] [nvarchar](10) NULL,
		[Str_Time] [nvarchar](10) NULL,
	 CONSTRAINT [PK_Tbl_VersionReleaseVSplitsSubLogs] PRIMARY KEY CLUSTERED 
	(
		[Prk_VersionReleaseVSubLogs_AutoID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	End
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionReleaseVLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionReleaseVLogs]
GO
CREATE PROCEDURE [dbo].[SP_Insert_VersionReleaseVLogs]
	 @Int_State as int = 0,
	 @Frk_VersionReleaseID as int = 0,
	 @Frk_ParsicUserID as int = 0,
	 @Str_Version as nvarchar(20) = '',
	 @Str_VersionFrom as nvarchar(5) = '',
	 @Str_VersionTo as nvarchar(5) =  '',
	 @Str_ErrorLog as nvarchar(MAX) = '',
	 @Str_Description as nvarchar(MAX) = '',
	 @Int_AppType as int = 0, 
	 @Int_LogType as int = 0, 
	 @Str_ComputerName as nvarchar(100) =  '',
	 @Str_DataBaseName as nvarchar(100) =  '',
	 @Bit_IsActiveDB as bit = 0,
	 @Bit_IsEXE as bit = 0, 
	 @Str_ExeSize as nvarchar(50) = '',
	 @Int_WholeCount as int = 0,
	 @Int_Order as int = 0
	 
AS

BEGIN
	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()
	

	if @Int_State = 0
	begin

		INSERT INTO Tbl_VersionReleaseVLogs
	
			(Frk_VersionReleaseID, Frk_ParsicUserID, Str_VersionFrom, Str_VersionTo, Str_ErrorLog, Str_Description, Int_AppType, Int_LogType, Str_ComputerName, Str_DataBaseName, Bit_IsExe, Str_ExeSize, Bit_IsActiveDB , Str_Date, Str_Time)

		 VALUES 
	 
			(@Frk_VersionReleaseID, @Frk_ParsicUserID, @Str_VersionFrom, @Str_VersionTo, @Str_ErrorLog, @Str_Description, @Int_AppType, @Int_LogType, @Str_ComputerName, @Str_DataBaseName, @Bit_IsEXE, @Str_ExeSize, @Bit_IsActiveDB, @str_Date,@str_Time)
	end


	if @Int_State = 1
	begin

		INSERT INTO Tbl_VersionReleaseVSplitsSubLogs
	
			(Frk_ParsicUserID, Str_ComputerName, Str_DbName, Bit_Exe, Str_Version, Int_Order, Int_WholeCount, Str_ErrorLog, Str_Description, Str_Date, Str_Time)

		 VALUES 
	 
			(@Frk_ParsicUserID, @Str_ComputerName, @Str_DataBaseName, @Bit_IsEXE, @Str_Version, @Int_Order, @Int_WholeCount, @Str_ErrorLog, @Str_Description, @str_Date,@str_Time)
	end
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionDescriptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionDescriptions]
GO

Create PROCEDURE [dbo].[SP_Insert_VersionDescriptions]
	 @frk_ParsicUserID as int = 0,
	 @Str_VersionNumber nvarchar(10) = '',
	 @str_Title nvarchar(200) = '',
	 @str_Description as nvarchar(MAX) =  '',
	 @int_Order int = 0,
	 @bit_Visibility as bit = 0,
	 @bit_LerningTips as bit = 0,
	 @int_Code as int = 0
AS

BEGIN
	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()
	


	INSERT INTO Tbl_VersionReleaseVDescription
	
		(frk_ParsicUserID,Str_VersionNumber,str_Title,str_Description,int_Order,str_Date,str_Time,bit_Visibility,bit_LerningTips,int_Code)

	 VALUES 
	 
		(@frk_ParsicUserID,@Str_VersionNumber,@str_Title,@str_Description,@int_Order,@Str_Date,@Str_Time,@bit_Visibility,@bit_LerningTips,@int_Code)
	
END


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Insert_VersionFiles]
GO

CREATE PROCEDURE [dbo].[SP_Insert_VersionFiles]
	 @Str_Type as nvarchar(10) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_FileSize nvarchar(20) = " ",
	 @Str_CRC as nvarchar(5) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @Int_PartNo as int = 0,
	 @Bin_FileContent as varbinary(MAX),
	 @str_StartData as nvarchar(10) = " ",
	 @str_FinishData as nvarchar(10) = " ",
	 @str_description as nvarchar(max) = " "

AS

BEGIN
	 declare @str_Date as nvarchar(10)
	 declare @str_Time as nvarchar(10)

	 set @str_Date = dbo.GetNowDate()
	 set @str_Time = dbo.GetNowTime()
	


	INSERT INTO Tbl_VersionFiles 
	
		(Str_Type,Str_FileName,Str_FileSize,Str_CRC,Str_VersionNo,Int_PartNo,Bin_FileContent,Str_Date,Str_Time,Str_Description)

	 VALUES 
	 
		(@Str_Type,@Str_FileName,@Str_FileSize,@Str_CRC,@Str_VersionNo,@Int_PartNo,@Bin_FileContent,@Str_Date,@Str_Time,@Str_Description)
	

END


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_VersionFiles]
GO
CREATE PROCEDURE [dbo].[SP_Get_VersionFiles]

	 @Str_Type as nvarchar(10) = " ",
	 @Str_FileName nvarchar(50) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @int_state as int = 0

AS

 if @int_state = 1
 BEGIN

      SELECT * FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END
 else if @int_state = 2
 BEGIN
 
      SELECT Str_VersionNo FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
 
 END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_VersionFiles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Delete_VersionFiles]
GO
Create PROCEDURE [dbo].[SP_Delete_VersionFiles]

	 @Str_Type as nvarchar(10) = " ",
	 @Str_VersionNo nvarchar(10) = " ",
	 @Str_Name as nvarchar(Max) = " ",
	 @int_state as int = 0

AS
if @int_state = 1
	BEGIN
 
      DELETE FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type
	End
if @int_state = 2
	BEGIN
 
      DELETE FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type and Str_FileName = @Str_Name
 
	END
if @int_state = 3
	BEGIN
 
      DELETE FROM Tbl_VersionFiles WHERE Str_Type = @Str_Type and Str_FileName <> @Str_Name
 
	END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_VersionReleaseLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Get_VersionReleaseLogs]
GO
Create PROCEDURE [dbo].[SP_Get_VersionReleaseLogs]

	 @Int_Count as int = 20,
	 @Bit_FromTop as bit = True,
	 @int_state as int = 0

AS

declare @MyDate as nvarchar(10)

set @MyDate = dbo.GetNowDate()


 if @int_state = 1
 BEGIN
	 if @Bit_FromTop = 1
		 BEGIN
			select *  from Tbl_VersionReleaseVLogs
		 end
	 else
		 begin 
	 		select *  from Tbl_VersionReleaseVLogs order by Prk_VersionReleaseLogs_AutoID desc
		 end
 END

  if @int_state = 2
 BEGIN
	 if @Bit_FromTop = 1
		BEGIN
			select *  from Tbl_VersionReleaseVSplitsSubLogs
		end
	 else
		begin
	 		select *  from Tbl_VersionReleaseVSplitsSubLogs order by Prk_VersionReleaseVSubLogs_AutoID desc
		end
 END
 if @int_state = 3
 BEGIN
	 if @Bit_FromTop = 1
		 BEGIN
			select top (@Int_Count) *  from Tbl_VersionReleaseVLogs
		 end
	 else
		 begin
	 		select top (@Int_Count) *  from Tbl_VersionReleaseVLogs order by Prk_VersionReleaseLogs_AutoID desc
		 end
 END
  if @int_state = 4
 BEGIN
	 if @Bit_FromTop = 1
		 BEGIN
			select top (@Int_Count) *  from Tbl_VersionReleaseVSplitsSubLogs
		 end
	 else
		 begin
	 		select top (@Int_Count) *  from Tbl_VersionReleaseVSplitsSubLogs order by Prk_VersionReleaseVSubLogs_AutoID desc
		 end
 END

  if @int_state = 5
 BEGIN
			select top 1 *  from Tbl_VersionReleaseVLogs  where Str_Description Like '%Error%' or Str_ErrorLog like '%Error%' order by Prk_VersionReleaseLogs_AutoID desc
 END
  if @int_state = 6
 BEGIN
			select *  from Tbl_VersionReleaseVSplitsSubLogs where Str_Description Like '%Error%' or Str_ErrorLog like '%Error%' order by Prk_VersionReleaseVSubLogs_AutoID desc
 END
   if @int_state = 7
 BEGIN
			select *  from Tbl_VersionReleaseVLogs  where Str_Description Like '%Success%' or Str_ErrorLog like '%Success%' order by Prk_VersionReleaseLogs_AutoID desc
 END
  if @int_state = 8
 BEGIN 
			select *  from Tbl_VersionReleaseVSplitsSubLogs where Str_Description Like '%Success%' or Str_ErrorLog like '%Success%' order by Prk_VersionReleaseVSubLogs_AutoID desc
 END
   if @int_state = 9
 BEGIN
			select *  from Tbl_VersionReleaseVSplitsSubLogs where Str_Date = @MyDate
 END
   if @int_state = 10
 BEGIN
			select *  from Tbl_VersionReleaseVSplitsSubLogs  where Bit_Exe = 1
 END
GO


ALTER TABLE dbo.[Tbl_VersionFiles]
ALTER COLUMN Str_Type nvarchar(50)
Go





