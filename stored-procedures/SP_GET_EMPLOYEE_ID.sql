CREATE PROCEDURE SP_GET_EMPLOYEE_ID
  @MACN NVARCHAR(3)
AS
BEGIN
  -- * GET THE LAST DIGIT INDICATE THAT BRANCH
  DECLARE @BRANCH_INDICATOR INT;
  SET @BRANCH_INDICATOR = CAST(SUBSTRING(@MACN, 3, 1) AS INT);

  -- * COUNT NUMBER OF BRANCH
  DECLARE @NUMBER_OF_BRANCH INT;
  SELECT
    @NUMBER_OF_BRANCH = COUNT(ID)
  FROM
    LINK2.QLVT_DATHANG.DBO.CHINHANH;

  -- * COUNT NUMBER OF EMPLOYEE OF THE GIVEN BRANCH
  DECLARE @NUMBER_OF_EMPLOYEE INT;
  SELECT
    @NUMBER_OF_EMPLOYEE = COUNT(MANV)
  FROM
    LINK0.QLVT_DATHANG.DBO.NHANVIEN
  WHERE
    MACN = @MACN;
  
  -- * RETURN THE NEW EMPLOYEE ID FOR THE GIVEN BRANCH
  RETURN (@BRANCH_INDICATOR + @NUMBER_OF_EMPLOYEE * @NUMBER_OF_BRANCH);
END;
