SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SP_REPORT_SUPPLIES_LIST
AS
BEGIN
	SELECT MAVT, TENVT, DVT, SOLUONGTON FROM Vattu WITH(INDEX(IX_Vattu_TENVT));
END
GO
