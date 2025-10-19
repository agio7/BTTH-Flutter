# Tính năng Phát hiện Che Màn hình

## Tổng quan
Ứng dụng "Bản đồ nhiệt Sân trường" đã được cải thiện để có thể phát hiện khi màn hình thiết bị bị che và tự động giảm cường độ ánh sáng mô phỏng. Điều này làm cho mô phỏng cảm biến ánh sáng trở nên thực tế hơn.

## Cách hoạt động

### 1. Phát hiện che màn hình
- **Sử dụng gia tốc kế**: Phân tích dữ liệu từ gia tốc kế để phát hiện khi thiết bị được đặt úp xuống
- **Điều kiện phát hiện**: 
  - Trục Z < -8.0 (thiết bị úp xuống)
  - Trục X và Y gần 0 (thiết bị nằm phẳng)
- **Phản ứng**: Giảm cường độ ánh sáng -800 lux khi phát hiện che màn hình

### 2. Khôi phục ánh sáng
- **Phát hiện mở màn hình**: Khi thiết bị được nâng lên hoặc xoay
- **Khôi phục**: Trở về giá trị ánh sáng bình thường
- **Logging**: Ghi log khi phát hiện che/mở màn hình

## Cách sử dụng

### Bật/Tắt tính năng
1. Mở ứng dụng → Tab "Trạm Khảo sát"
2. Tìm phần "Mô phỏng Ánh sáng"
3. Sử dụng switch "Phát hiện che màn hình" để bật/tắt
4. Khi bật: Ánh sáng sẽ giảm khi che màn hình
5. Khi tắt: Ánh sáng không thay đổi khi che màn hình

### Test tính năng
1. **Bật phát hiện che màn hình**
2. **Quan sát giá trị ánh sáng hiện tại**
3. **Đặt thiết bị úp xuống bàn** (màn hình hướng xuống)
4. **Quan sát**: Giá trị ánh sáng sẽ giảm đáng kể (khoảng -800 lux)
5. **Nâng thiết bị lên**: Giá trị ánh sáng sẽ trở về bình thường

## Lợi ích

### 1. Thực tế hơn
- Mô phỏng cảm biến ánh sáng thật
- Phản ứng với hành động của người dùng
- Tạo trải nghiệm tương tác

### 2. Giáo dục
- Hiểu cách cảm biến ánh sáng hoạt động
- Học về mối quan hệ giữa ánh sáng và môi trường
- Thực hành với dữ liệu thực tế

### 3. Linh hoạt
- Có thể bật/tắt theo ý muốn
- Không ảnh hưởng đến các tính năng khác
- Dễ dàng test và thử nghiệm

## Kỹ thuật

### Thuật toán phát hiện
```dart
bool isFaceDown = event.z < -8.0 && event.x.abs() < 2.0 && event.y.abs() < 2.0;
```

### Xử lý sự kiện
- **Che màn hình**: `_screenCoverModifier = -800.0`
- **Mở màn hình**: `_screenCoverModifier = 0.0`
- **Cập nhật real-time**: Mỗi giây một lần

### Tích hợp với mô phỏng
- Kết hợp với mô phỏng thời gian
- Kết hợp với mô phỏng vị trí
- Kết hợp với điều khiển thủ công

## Troubleshooting

### Không phát hiện che màn hình
1. **Kiểm tra switch**: Đảm bảo "Phát hiện che màn hình" đang bật
2. **Kiểm tra gia tốc kế**: Đảm bảo thiết bị có gia tốc kế
3. **Thử lại**: Đặt thiết bị úp xuống bàn phẳng
4. **Kiểm tra log**: Xem console để debug

### Phát hiện sai
1. **Điều chỉnh độ nhạy**: Có thể cần thay đổi ngưỡng phát hiện
2. **Kiểm tra môi trường**: Tránh rung động mạnh
3. **Test nhiều lần**: Để đảm bảo tính ổn định

### Hiệu suất
1. **Tối ưu**: Chỉ chạy khi cần thiết
2. **Battery**: Không ảnh hưởng đáng kể đến pin
3. **Smooth**: Cập nhật mượt mà không lag

## Mở rộng

### Cải tiến có thể
1. **Độ nhạy điều chỉnh được**: Cho phép người dùng điều chỉnh ngưỡng
2. **Nhiều mức che**: Phát hiện che một phần vs che hoàn toàn
3. **Machine learning**: Học từ hành vi người dùng
4. **Tích hợp camera**: Sử dụng camera để phát hiện ánh sáng thật

### Ứng dụng khác
1. **Game**: Tương tác với ánh sáng
2. **IoT**: Điều khiển thiết bị thông minh
3. **Health**: Theo dõi thời gian sử dụng thiết bị
4. **Education**: Học về cảm biến và môi trường

## Kết luận

Tính năng phát hiện che màn hình làm cho ứng dụng "Bản đồ nhiệt Sân trường" trở nên thực tế và tương tác hơn. Người dùng có thể:

- **Trải nghiệm thực tế**: Cảm biến ánh sáng phản ứng với hành động
- **Học tập hiệu quả**: Hiểu về mối quan hệ giữa ánh sáng và môi trường
- **Linh hoạt sử dụng**: Bật/tắt theo nhu cầu

Tính năng này đặc biệt hữu ích cho việc giáo dục và nghiên cứu khoa học! 🎉

