-- SP returns 1 means the ID ís existed, 0 means the ID is not existed

CREATE PROCEDURE SP_CHECK_EXIST_EMPLOYEE_ID
	@MA_NHANVIEN int
AS
BEGIN
    IF (EXISTS(SELECT * FROM LINK0.QLVT_DATHANG.DBO.NHANVIEN AS NV WHERE NV.MANV = @MA_NHANVIEN))
		return 1;
	return 0;
END