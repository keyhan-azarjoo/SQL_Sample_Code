-- For each transaction use Transaction and commit at the end to avoid errors and corruption in the database

DECLARE @id UNIQUEIDENTIFIER = N'9febd836-9b5e-4dbb-bc29-7e4fa4616f0c';
DECLARE @time DATETIME = GETDATE();

BEGIN TRANSACTION; -- start the transaction

BEGIN TRY

		-- body  start the transaction
		


-- if everything is successful, commit the transaction
COMMIT TRANSACTION; -- commit the transaction
END TRY

BEGIN
CATCH
-- an error occurred, rollback the transaction
ROLLBACK TRANSACTION; -- rollback the transaction

-- handle or log the error as needed
PRINT 'error: ' + ERROR_MESSAGE();
END CATCH; 


--======================================================================================================================================




