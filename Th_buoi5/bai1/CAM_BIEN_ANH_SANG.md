# Hướng dẫn Cảm biến Ánh sáng

## Tổng quan
Ứng dụng "Bản đồ nhiệt Sân trường" sử dụng mô phỏng cảm biến ánh sáng vì hầu hết thiết bị di động không có cảm biến ánh sáng trực tiếp. Hệ thống mô phỏng này được thiết kế để tạo ra dữ liệu thực tế và có thể kiểm soát được.

## Cách hoạt động

### 1. Mô phỏng dựa trên thời gian
- **6h-10h**: Ánh sáng tăng dần (200-600 lux)
- **10h-14h**: Ánh sáng đỉnh điểm (600-800 lux) 
- **14h-18h**: Ánh sáng giảm dần (800-200 lux)
- **18h-6h**: Ánh sáng rất thấp (5-20 lux)

### 2. Mô phỏng dựa trên vị trí GPS
- **Dưới cây**: Giảm 200-300 lux (tối hơn)
- **Khu vực mở**: Tăng 300 lux (sáng hơn)
- **Gần tòa nhà**: Giảm 100-150 lux (có bóng)
- **Trong nhà**: Giảm 400 lux (rất tối)

### 3. Biến động thực tế
- Thêm biến động ngẫu nhiên ±100 lux để mô phỏng mây, bóng râm
- Cập nhật mỗi giây để tạo cảm giác thực tế

## Điều khiển thủ công

### Các kịch bản mô phỏng
1. **Nắng** (Bright Sunny): +400 lux
   - Mô phỏng trời nắng đẹp, không mây
   - Phù hợp cho khu vực giữa sân trường

2. **Mây** (Partly Cloudy): +200 lux
   - Mô phỏng trời có mây, ánh sáng vừa phải
   - Phù hợp cho thời tiết bình thường

3. **Dưới cây** (Under Tree): -300 lux
   - Mô phỏng dưới tán cây rậm rạp
   - Phù hợp cho khu vực có nhiều cây xanh

4. **Bóng tòa nhà** (Building Shadow): -150 lux
   - Mô phỏng trong bóng râm của tòa nhà
   - Phù hợp cho hành lang, góc khuất

5. **Trong nhà** (Indoor): -400 lux
   - Mô phỏng ánh sáng trong nhà
   - Phù hợp cho phòng học, thư viện

6. **Đêm** (Night): -500 lux
   - Mô phỏng ban đêm, ánh sáng rất yếu
   - Phù hợp cho thời gian tối

## Cách sử dụng trong thực tế

### Giai đoạn 1: Thu thập dữ liệu
1. Mở ứng dụng và chuyển đến tab "Trạm Khảo sát"
2. Đợi ứng dụng khởi tạo cảm biến
3. Quan sát giá trị ánh sáng hiện tại
4. Sử dụng các nút mô phỏng để thay đổi kịch bản ánh sáng:
   - Nhấn "Nắng" khi ở giữa sân trường
   - Nhấn "Dưới cây" khi ở dưới tán cây
   - Nhấn "Bóng tòa nhà" khi ở hành lang
   - Nhấn "Trong nhà" khi vào phòng học
5. Nhấn "Ghi Dữ liệu tại Điểm này" để lưu

### Giai đoạn 2: Phân tích dữ liệu
1. Chuyển đến tab "Bản đồ Dữ liệu"
2. Quan sát các giá trị ánh sáng khác nhau:
   - **Cao (>800 lux)**: Khu vực sáng, nắng
   - **Trung bình (200-800 lux)**: Khu vực bình thường
   - **Thấp (<200 lux)**: Khu vực tối, có bóng râm
3. So sánh với vị trí thực tế để xác nhận tính chính xác

## Giá trị tham khảo

### Ánh sáng tự nhiên
- **Nắng trực tiếp**: 10,000-25,000 lux
- **Nắng gián tiếp**: 1,000-5,000 lux
- **Trời có mây**: 1,000-2,000 lux
- **Trong bóng râm**: 100-1,000 lux
- **Hoàng hôn**: 10-100 lux
- **Ban đêm**: 0.1-1 lux

### Ánh sáng nhân tạo
- **Văn phòng**: 300-500 lux
- **Phòng học**: 300-500 lux
- **Hành lang**: 100-200 lux
- **Cầu thang**: 50-100 lux

## Lưu ý quan trọng

1. **Mô phỏng không hoàn toàn chính xác**: Đây chỉ là mô phỏng, không phải cảm biến thật
2. **Sử dụng cho mục đích giáo dục**: Giúp hiểu về đo lường ánh sáng
3. **So sánh tương đối**: Quan trọng là so sánh giữa các điểm khác nhau
4. **Ghi chú vị trí**: Nên ghi chú vị trí thực tế khi thu thập dữ liệu

## Troubleshooting

### Ánh sáng không thay đổi
- Kiểm tra xem có đang chạy mô phỏng không
- Thử nhấn các nút mô phỏng khác nhau
- Khởi động lại ứng dụng nếu cần

### Giá trị không hợp lý
- Kiểm tra thời gian trong ngày
- Đảm bảo GPS đang hoạt động
- Thử thay đổi kịch bản mô phỏng

### Ứng dụng chậm
- Đóng các ứng dụng khác
- Kiểm tra dung lượng lưu trữ
- Khởi động lại thiết bị nếu cần

