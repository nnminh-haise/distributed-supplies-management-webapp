CREATE PROCEDURE SP_LIST_ALL_EMPLOYEES 
  @PAGE INT,
  @SIZE INT
AS
BEGIN
  DECLARE @OFFSET_VALUE INT = (@PAGE - 1) * @SIZE;

  SELECT
    MANV,
    HO,
    TEN,
    CMND,
    DIACHI,
    NGAYSINH,
    LUONG,
    MACN
  FROM
    NHANVIEN
  WHERE
    TRANGTHAIXOA = 0
  ORDER BY
    MANV DESC,
    TEN ASC,
    HO DESC
  OFFSET @OFFSET_VALUE ROWS
  FETCH NEXT @SIZE ROWS ONLY;

END