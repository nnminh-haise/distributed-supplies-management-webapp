CREATE PROCEDURE SP_REPORT_OF_PERCENTAGE_OF_IMPORT_AND_EXPORT
    @ROLE NVARCHAR(8),
    @FROM_DATE DATETIME,
    @TO_DATE DATETIME
AS
BEGIN
    IF (@ROLE = 'CONGTY')
        BEGIN
            DECLARE @TOTAL_IMPORT INT;
            DECLARE @TOTAL_EXPORT INT;

            -- CALCULATE TOTAL IMPORT
            SELECT
                @TOTAL_IMPORT = SUM(CTPN.SOLUONG * CTPN.DONGIA)
            FROM LINK2.QLVT_DATHANG.DBO.PhieuNhap AS PN
            INNER JOIN LINK2.QLVT_DATHANG.DBO.CTPN AS CTPN ON PN.MAPN = CTPN.MAPN
            WHERE PN.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            -- CALCULATE TOTAL EXPORT
            SELECT
                @TOTAL_EXPORT = SUM(CTPX.SOLUONG * CTPX.DONGIA)
            FROM LINK2.QLVT_DATHANG.DBO.PhieuXuat AS PX
            INNER JOIN LINK2.QLVT_DATHANG.DBO.CTPX AS CTPX ON PX.MAPX = CTPX.MAPX
            WHERE PX.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            SELECT
                PN.NGAY AS NGAY,
                SUM(CTPN.SOLUONG * CTPN.DONGIA) AS NHAP,
                SUM(CTPN.SOLUONG * CTPN.DONGIA) * 100 / @TOTAL_IMPORT AS TI_LE_NHAP
            INTO #TOTAL_IMPORT_DETAILS
            FROM LINK2.QLVT_DATHANG.DBO.PhieuNhap AS PN
            INNER JOIN LINK2.QLVT_DATHANG.DBO.CTPN AS CTPN ON PN.MAPN = CTPN.MAPN
            WHERE PN.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            SELECT
                PX.NGAY AS NGAY,
                SUM(CTPX.SOLUONG * CTPX.DONGIA) AS NHAP,
                SUM(CTPX.SOLUONG * CTPX.DONGIA) * 100 / @TOTAL_EXPORT AS TI_LE_NHAP
            INTO #TOTAL_EXPORT_DETAILS
            FROM LINK2.QLVT_DATHANG.DBO.PhieuXuat AS PX
            INNER JOIN LINK2.QLVT_DATHANG.DBO.CTPX AS CTPX ON PX.MAPX = CTPX.MAPX
            WHERE PX.NGAY BETWEEN @FROM_DATE AND @TO_DATE
            
            SELECT 
                #TOTAL_IMPORT_DETAILS.NGAY AS NGAY,
                ISNULL(#TOTAL_IMPORT_DETAILS.NHAP, 0) AS NHAP,
                ISNULL(#TOTAL_IMPORT_DETAILS.TI_LE_NHAP, 0) AS TI_LE_NHAP,
                ISNULL(#TOTAL_EXPORT_DETAILS.NHAP, 0) AS XUAT,
                ISNULL(#TOTAL_EXPORT_DETAILS.TI_LE_NHAP, 0) AS TI_LE_XUAT
            FROM #TOTAL_IMPORT_DETAILS
            FULL OUTER JOIN #TOTAL_EXPORT_DETAILS
            ON #TOTAL_IMPORT_DETAILS.NGAY = #TOTAL_EXPORT_DETAILS.NGAY
            GROUP BY #TOTAL_IMPORT_DETAILS.NGAY
        END
    ELSE
        BEGIN
        DECLARE @TOTAL_IMPORT INT;
            DECLARE @TOTAL_EXPORT INT;

            -- CALCULATE TOTAL IMPORT
            SELECT
                @TOTAL_IMPORT = SUM(CTPN.SOLUONG * CTPN.DONGIA)
            FROM PhieuNhap AS PN
            INNER JOIN CTPN AS CTPN ON PN.MAPN = CTPN.MAPN
            WHERE PN.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            -- CALCULATE TOTAL EXPORT
            SELECT
                @TOTAL_EXPORT = SUM(CTPX.SOLUONG * CTPX.DONGIA)
            FROM PhieuXuat AS PX
            INNER JOIN CTPX AS CTPX ON PX.MAPX = CTPX.MAPX
            WHERE PX.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            SELECT
                PN.NGAY AS NGAY,
                SUM(CTPN.SOLUONG * CTPN.DONGIA) AS NHAP,
                SUM(CTPN.SOLUONG * CTPN.DONGIA) * 100 / @TOTAL_IMPORT AS TI_LE_NHAP
            INTO #TOTAL_IMPORT_DETAILS
            FROM PhieuNhap AS PN
            INNER JOIN CTPN AS CTPN ON PN.MAPN = CTPN.MAPN
            WHERE PN.NGAY BETWEEN @FROM_DATE AND @TO_DATE

            SELECT
                PX.NGAY AS NGAY,
                SUM(CTPX.SOLUONG * CTPX.DONGIA) AS NHAP,
                SUM(CTPX.SOLUONG * CTPX.DONGIA) * 100 / @TOTAL_EXPORT AS TI_LE_NHAP
            INTO #TOTAL_EXPORT_DETAILS
            FROM PhieuXuat AS PX
            INNER JOIN CTPX AS CTPX ON PX.MAPX = CTPX.MAPX
            WHERE PX.NGAY BETWEEN @FROM_DATE AND @TO_DATE
            
            SELECT 
                #TOTAL_IMPORT_DETAILS.NGAY AS NGAY,
                ISNULL(#TOTAL_IMPORT_DETAILS.NHAP, 0) AS NHAP,
                ISNULL(#TOTAL_IMPORT_DETAILS.TI_LE_NHAP, 0) AS TI_LE_NHAP,
                ISNULL(#TOTAL_EXPORT_DETAILS.NHAP, 0) AS XUAT,
                ISNULL(#TOTAL_EXPORT_DETAILS.TI_LE_NHAP, 0) AS TI_LE_XUAT
            FROM #TOTAL_IMPORT_DETAILS
            FULL OUTER JOIN #TOTAL_EXPORT_DETAILS
            ON #TOTAL_IMPORT_DETAILS.NGAY = #TOTAL_EXPORT_DETAILS.NGAY
            GROUP BY #TOTAL_IMPORT_DETAILS.NGAY
        END
END