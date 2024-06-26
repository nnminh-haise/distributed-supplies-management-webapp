# Stored procedures

---

## Một số chú ý:

Cú pháp xoá SP:

```sql
DROP PROCEDURE <tên SP>
```


## SP_GET_USER_INFO_BY_LOGIN

Source code: [SP_GET_USER_INFO_BY_LOGIN](./SP_GET_USER_INFO_BY_LOGIN.sql)

Usecase: Tại trang đăng nhập, khi người dùng nhập vào login name (không dùng username) thì sẽ dùng login name này và gọi SP này để lấy các thông tin:

- Mã nhân viên (MANV)
- Họ và tên (HOTEN)
- Tên nhóm quyền (TENNHOM): là tên của nhóm quyền như: Công ty, Chi nhánh hay Người dùng.

## SP_LIST_ALL_EMPLOYEES

Source code: [SP_LIST_ALL_EMPLOYEES](./SP_LIST_ALL_EMPLOYEES.sql)

Usecase: Lấy danh sách nhân viên dựa trên role

- Nếu role `CongTy` sẽ cho lựa chọn chi nhánh và lấy danh sách nhân viên ở chi nhánh đó
- Đối với role `ChiNhanh` sẽ lấy danh sách nhân viên ở chi nhánh hiện tại

Cú pháp sử dụng:

```sql
EXEC SP_LIST_ALL_EMPLOYEES `CongTy` `CN1`
-- OR
EXEC SP_LIST_ALL_EMPLOYEES `ChiNhanh` null
```


## SP_LIST_ALL_SUPLLIES

Source code: [SP_LIST_ALL_SUPLLIES](./SP_LIST_ALL_SUPLLIES.sql)

Usecase: sử dụng để lấy danh sách vật tư.

Cú pháp sử dụng:

```sql
EXEC SP_LIST_ALL_SUPLLIES
```

## SP_CHECK_EXIST_EMPLOYEE_ID

Source code: [SP_CHECK_EXIST_EMPLOYEE_ID](./SP_CHECK_EXIST_EMPLOYEE_ID.sql)

Usecase: Sử dụng để kiểm tra một mã nhân viên đã tồn tại hay chưa

Lưu ý:
- LINK0 nối Server phân mảnh tới Server 3 (Server tra cứu)
- LINK1 nối Server phân mảnh này với Server phân mảnh còn lại

Cú pháp sử dụng: Kiểm tra xem mã nhân viên 20 có tồn tại hay không

```sql
DECLARE @RESULT int
EXEC @RESULT = SP_CHECK_EXIST_EMPLOYEE_ID 20
SELECT @RESULT
```

## SP_CHANGE_BRANCH

Source code: [SP_CHANGE_BRANCH](SP_CHANGE_BRANCH.sql)

Usecase: chuyển nhân viên từ chi nhánh này sang chi nhánh khác mà không ảnh hưởng đến tính toàn vẹn dữ liệu, mã nhân viên sẽ không bị trùng.

SP có sử dụng Transaction để đảm bảo được tính toàn vẹn dữ liệu của cơ sở dữ liệu trong trường hợp có xảy ra sự cố khiến cho SP bị dừng hoặc là có mâu thuẫn với ràng buộc toàn vẹn của cơ sở dữ liệu.

Chú ý: nếu `SP_CHANGE_BRANCH` chạy mà gặp lỗi **"MSDTC on server is unavailable"** thì nghĩa là dịch vụ MSDTC chưa được bật. Do đó, cần phải bật dịch vụ theo các bước sau:

1. Bấm Windows Start -> Settings -> Control Panel -> Administrative tools -> Services.
1. Tìm từ khoá **"Distributed Transaction Coordinator"**, chuột phải và chọn Start.
1. Vào Properties -> Startup type -> đổi sang automatic để tự động chạy dịch vụ này.

Cú pháp sử dụng: Chuyển nhân viên có mã nhân viên là 14 sang chi nhánh 1.

```sql
EXEC SP_CHANGE_BRANCH 14, 'CN1';
```

## SP_CHECK_EXIST_STORAGE_ID

Source code: [SP_CHECK_EXIST_STORAGE_ID](./SP_CHECK_EXIST_STORAGE_ID.sql)

Usecase: kiểm tra mã kho có tồn tại hay không. SP trả về 1 tương ứng với tồn tại và 0 trong trường hợp ngược lại.

Cú pháp sử dụng: Xem mã kho "TX" có tồn tại hay không

```sql
DECLARE @result INT
EXEC @result = SP_CHECK_EXIST_STORAGE_ID 'TX'
SELECT @result
```

## SP_CHECK_EXIST_SUPPLY_ID

Source code: [SP_CHECK_EXIST_SUPPLY_ID](./SP_CHECK_EXIST_SUPPLY_ID.sql)

Usecase: kiểm tra mã vật tư đã tồn tại trong DB hay chưa? Nếu có thì SP trả về 1, ngược lại trả về 0.

**Lưu ý:** SP sẽ thực hiện kiểm tra trên phân mảnh hiện tại, nếu không có sẽ thực hiện kiểm tra ở phân mảnh khác. Cuối cùng nếu không có ở cả 2 phân mảnh thì trả về 0, nghĩa là mã vật tư chưa tồn tại.

Cú pháp sử dụng: Kiểm tra mã vật tư "M02" có tồn tại hay không?

```sql
DECLARE @result INT
EXEC @result = SP_CHECK_EXIST_SUPPLY_ID 'M02'
SELECT @result
```

## SP_CHECK_EXIST_ORDER_ID

Source code: [SP_CHECK_EXIST_ORDER_ID](./SP_CHECK_EXIST_ORDER_ID.sql)

Usecase: kiểm tra mã đơn hàng đã tồn tại trong DB hay chưa? Nếu có thì SP trả về 1, ngược lại trả về 0.

**Lưu ý:** SP sẽ thực hiện kiểm tra trên phân mảnh hiện tại, nếu không có sẽ thực hiện kiểm tra ở phân mảnh khác. Cuối cùng nếu không có ở cả 2 phân mảnh thì trả về 0, nghĩa là mã đơn hàng chưa tồn tại.

Cú pháp sử dụng: Kiểm tra mã đơn hàng "M02" có tồn tại hay không?

```sql
DECLARE @result INT
EXEC @result = SP_CHECK_EXIST_ORDER_ID 'MDDH02'
SELECT @result
```

## SP_CHECK_EXIST_IMPORT_ID

Source code: [SP_CHECK_EXIST_IMPORT_ID](./SP_CHECK_EXIST_IMPORT_ID.sql)

Usecase: kiểm tra mã phiếu nhập đã tồn tại trong DB hay chưa? Nếu có thì SP trả về 1, ngược lại trả về 0.

**Lưu ý:** SP sẽ thực hiện kiểm tra trên phân mảnh hiện tại, nếu không có sẽ thực hiện kiểm tra ở phân mảnh khác. Cuối cùng nếu không có ở cả 2 phân mảnh thì trả về 0, nghĩa là mã phiếu nhập chưa tồn tại.

Cú pháp sử dụng: Kiểm tra mã phiếu nhập "PN01" có tồn tại hay không?

```sql
DECLARE @result INT
EXEC @result = SP_CHECK_EXIST_IMPORT_ID 'PN01'
SELECT @result
```

## SP_CHECK_EXIST_EXPORT_ID

Source code: [SP_CHECK_EXIST_EXPORT_ID](./SP_CHECK_EXIST_EXPORT_ID.sql)

Usecase: kiểm tra mã phiếu xuất đã tồn tại trong DB hay chưa? Nếu có thì SP trả về 1, ngược lại trả về 0.

**Lưu ý:** SP sẽ thực hiện kiểm tra trên phân mảnh hiện tại, nếu không có sẽ thực hiện kiểm tra ở phân mảnh khác. Cuối cùng nếu không có ở cả 2 phân mảnh thì trả về 0, nghĩa là mã phiếu xuất chưa tồn tại.

Cú pháp sử dụng: Kiểm tra mã phiếu xuất "PX03" có tồn tại hay không?

```sql
DECLARE @result INT
EXEC @result = SP_CHECK_EXIST_EXPORT_ID 'PX03'
SELECT @result
```

## SP_UPDATE_SUPPLY_QUANTITY

Source code: [SP_UPDATE_SUPPLY_QUANTITY](./SP_UPDATE_SUPPLY_QUANTITY.sql)

Usecase: cập nhật số lượng tồn của vật tư khi bị thay đổi. Khi lặp phiếu nhập thì số lượng vật tư tăng, ngược lại giảm số lượng vật tư khi có lập phiếu xuất.

Cú pháp sử dụng:

1. Nhập vật tư:

```sql
EXEC SP_UPDATE_SUPPLY_QUANTITY 'IMPORT', 'PZ5', 130
```

1. Xuất vật tư:

```sql
EXEC SP_UPDATE_SUPPLY_QUANTITY 'EXPORT', 'PZ4', 50
```

## SP_FIND_ALL_ORDER_DONT_HAVE_IMPORT

Source code: [SP_FIND_ALL_ORDER_DONT_HAVE_IMPORT](./SP_FIND_ALL_ORDER_DONT_HAVE_IMPORT.sql)

Usecase: Tìm những đơn đặt hàng (đơn hàng) không có phiếu nhập.

**Chú ý:** Đơn đặt hàng không có chi tiết đơn đặt hàng sẽ không được xuất hiện trong kết quả, vì một khi tồn tại đơn đặt hàng thì phải có chi tiết mới được coi là một đơn đặt hàng hợp lệ.

Output mẫu:

| Mã số đơn hàng | Ngày | Nhà cung cấp | Họ tên nhân viên | Tên vật tư | Số lượng | Đơn giá |
| :---: | :---: | :--- | :--- | :--- | :---: | :---: |
| A | 01/01/2024 | Sun House | Nguyễn Văn A | Máy lạnh Panasonic | 100 | 3,000,000 |

## SP_REPORT_OF_PERCENTAGE_OF_IMPORT_AND_EXPORT

Source code: [SP_REPORT_OF_PERCENTAGE_OF_IMPORT_AND_EXPORT](./SP_REPORT_OF_PERCENTAGE_OF_IMPORT_AND_EXPORT.sql)

Usecase: tổng hợp số tiền nhập xuất theo từng ngày trong khoảng thời gian từ ngày A đến ngày B. Cho biết tỉ lệ phần trăm của từng ngày so với tổng số ngày (từ A - B) và tổng số tiền trong khoảng ngày đó.

Output mẫu:

| Ngày | Nhập | Tỉ lệ nhập | Xuất | Tỉ lệ xuất |
| :---: | ---: | :---: | ---: | :---: |
| DD/MM/YYYY | 1,000,000 | 10 | 1,000,000 | 20 |
| DD/MM/YYYY | 0 | 0 | 1,000,000 | 20 |
| DD/MM/YYYY | 1,000,000 | 10 | 0 | 0 |
| ... | | | |
| Tổng cộng | X,000,000 | | Y,000,000 | |

Cú pháp sử dụng: In ra tổng hợp tỉ lệ nhập xuất từ ngày 1 tháng 3 đến ngày 31 tháng 3 năm 2024.

```sql
EXEC SP_REPORT_OF_PERCENTAGE_OF_IMPORT_AND_EXPORT '2024-03-01' '2024-03-31'
```

## SP_LIST_DETAIL_QUANTITY_AND_PRICE_OF_IMPORT_OR_EXPORT

Source code: [SP_LIST_DETAIL_QUANTITY_AND_PRICE_OF_IMPORT_OR_EXPORT](./SP_LIST_DETAIL_QUANTITY_AND_PRICE_OF_IMPORT_OR_EXPORT.sql)

Usecase: sử dụng để lấy thống kê chi tiết số lượng và trị giá hàng nhập hoặc xuất.

**Lưu ý:** Nếu Login thuộc role `CongTy` thì sẽ tổng hợp từ cả hai chi nhánh, ngược lại với các role khác thì sẽ chỉ tổng hợp ở chi nhánh hiện tại đang ở.

Cú pháp sử dụng: Lấy bảng thống kê chi tiết số lượng và trị giá hàng nhập với role `CongTy`

```sql
EXEC SP_LIST_DETAIL_QUANTITY_AND_PRICE_OF_IMPORT_OR_EXPORT 'CongTy' 'NHAP' '2024-03-01' '2024-03-31'
```

## SP_REPORT_EMPLOYEE_WORKING_STATUS

Source code: [SP_REPORT_EMPLOYEE_WORKING_STATUS](./SP_REPORT_EMPLOYEE_WORKING_STATUS.sql)

Usecase: Báo cáo tình trạng làm việc của nhân viên trong một khoảng thời gian từ ngày A đến ngày B.
