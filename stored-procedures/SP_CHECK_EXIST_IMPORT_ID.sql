CREATE PROCEDURE SP_CHECK_EXIST_IMPORT_ID
    @MAPN nChar(8)
AS
BEGIN
	IF (EXISTS(SELECT * FROM PhieuNhap WHERE MAPN = @MAPN))
		RETURN 1;
	ELSE IF (EXISTS(SELECT * FROM LINK1.QLVT_DATHANG.DBO.PhieuNhap WHERE MAPN = @MAPN))
		RETURN 1;
	RETURN 0;
END