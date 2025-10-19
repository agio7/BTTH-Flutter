# Ứng dụng "Bản đồ nhiệt Sân trường"

## Mô tả
Ứng dụng Flutter để thu thập và trực quan hóa dữ liệu môi trường tại nhiều địa điểm khác nhau trong sân trường, sử dụng các cảm biến của điện thoại.

## Tính năng chính

### 1. Màn hình "Trạm Khảo sát"
- **Hiển thị dữ liệu trực tiếp:**
  - Cường độ Ánh sáng (lux) - mô phỏng dựa trên thời gian trong ngày
  - Độ "Năng động" - tính toán độ lớn vector gia tốc từ gia tốc kế
  - Cường độ Từ trường - độ lớn vector từ trường từ từ kế
- **Nút "Ghi Dữ liệu tại Điểm này":**
  - Lấy tọa độ GPS chính xác
  - Thu thập tất cả giá trị cảm biến hiện tại
  - Lưu dữ liệu với timestamp vào file JSON

### 2. Màn hình "Bản đồ Dữ liệu"
- **Danh sách điểm khảo sát:** Hiển thị tất cả dữ liệu đã thu thập
- **Trực quan hóa dữ liệu:**
  - 🌞 Ánh sáng: Icon mặt trời với màu sắc theo cường độ
  - 👣 Năng động: Icon bước chân với màu sắc theo độ rung động
  - 🧲 Từ trường: Icon nam châm với màu sắc theo cường độ từ trường
- **Thống kê:** Hiển thị tổng số điểm, giá trị trung bình, min/max

## Cài đặt và Chạy

### Yêu cầu
- Flutter SDK (phiên bản 3.9.0 trở lên)
- Android Studio / VS Code với Flutter extension
- Thiết bị Android/iOS hoặc emulator

### Cài đặt
1. Clone repository hoặc tải source code
2. Mở terminal trong thư mục dự án
3. Chạy lệnh:
```bash
flutter pub get
```

### Chạy ứng dụng
```bash
flutter run
```

## Cách sử dụng

### Giai đoạn 1: Thu thập dữ liệu
1. Mở ứng dụng và chuyển đến tab "Trạm Khảo sát"
2. Đợi ứng dụng khởi tạo cảm biến (có thể mất vài giây)
3. Di chuyển đến các địa điểm khác nhau trong sân trường
4. Quan sát sự thay đổi của dữ liệu cảm biến trên màn hình
5. Nhấn nút "Ghi Dữ liệu tại Điểm này" để lưu dữ liệu

### Giai đoạn 2: Phân tích dữ liệu
1. Chuyển đến tab "Bản đồ Dữ liệu"
2. Xem danh sách tất cả điểm đã thu thập
3. Phân tích các mẫu dữ liệu:
   - Khu vực nào có ánh sáng cao nhất/thấp nhất?
   - Điểm nào có độ "năng động" cao/thấp?
   - Có điểm nào có từ trường bất thường không?

## Gợi ý địa điểm khảo sát

### Điểm sáng nhất
- Giữa sân trường vào lúc trời nắng
- Gần cửa sổ hoặc khu vực mở

### Điểm tối nhất
- Dưới tán cây rậm rạp
- Góc khuất, hành lang có mái che

### Điểm "tĩnh" nhất
- Góc yên tĩnh, không có người qua lại
- Đặt điện thoại xuống đất và chờ giá trị ổn định

### Điểm "năng động" nhất
- Gần sân bóng rổ, khu vực có nhiều người qua lại
- Cầm điện thoại trên tay và đi bộ

### Điểm có từ trường bất thường
- Gần các vật thể kim loại lớn: cột cờ, cột gôn, hàng rào sắt
- Nắp cống kim loại, thiết bị điện

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── survey_point.dart    # Model dữ liệu điểm khảo sát
├── services/
│   ├── sensor_service.dart  # Xử lý cảm biến và GPS
│   └── storage_service.dart # Lưu trữ dữ liệu JSON
└── screens/
    ├── survey_station_screen.dart  # Màn hình Trạm Khảo sát
    └── data_map_screen.dart        # Màn hình Bản đồ Dữ liệu
```

## Dependencies

- `sensors_plus`: Đọc dữ liệu từ gia tốc kế và từ kế
- `location`: Lấy tọa độ GPS
- `path_provider`: Quản lý đường dẫn file
- `permission_handler`: Xử lý quyền truy cập

## Lưu ý

- Ứng dụng cần quyền truy cập vị trí để hoạt động
- Dữ liệu được lưu cục bộ trong thiết bị
- Cảm biến ánh sáng được mô phỏng dựa trên thời gian trong ngày
- Để có kết quả chính xác, nên khảo sát ít nhất 15 điểm khác nhau

## Troubleshooting

### Lỗi quyền truy cập
- Kiểm tra cài đặt quyền truy cập vị trí trong Settings
- Đảm bảo ứng dụng có quyền truy cập cảm biến

### Dữ liệu không hiển thị
- Kiểm tra kết nối GPS
- Đảm bảo thiết bị có cảm biến gia tốc kế và từ kế
- Thử khởi động lại ứng dụng

### Lỗi lưu dữ liệu
- Kiểm tra quyền truy cập storage
- Đảm bảo có đủ dung lượng lưu trữ