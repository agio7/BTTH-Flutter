import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class BalanceGameScreen extends StatefulWidget {
  const BalanceGameScreen({super.key});

  @override
  State<BalanceGameScreen> createState() => _BalanceGameScreenState();
}

class _BalanceGameScreenState extends State<BalanceGameScreen> {
  // Vị trí của quả bi
  double ballX = 0;
  double ballY = 0;
  
  // Vị trí của đích
  double targetX = 150;
  double targetY = 300;
  
  // Kích thước màn hình
  double screenWidth = 0;
  double screenHeight = 0;
  
  // Kích thước quả bi và đích
  static const double ballSize = 50;
  static const double targetSize = 50;
  
  // Biến để kiểm tra trạng thái game
  bool gameWon = false;
  
  // Hệ số điều khiển độ nhạy
  static const double sensitivity = 5.0;
  
  // Biến để làm mượt chuyển động
  double velocityX = 0;
  double velocityY = 0;
  static const double friction = 0.95;
  static const double maxVelocity = 10.0;

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
  }

  void _startAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!gameWon) {
        setState(() {
          // Cập nhật vận tốc dựa trên gia tốc kế
          velocityX += event.x * sensitivity;
          velocityY -= event.y * sensitivity; // Đảo ngược trục Y
          
          // Giới hạn vận tốc tối đa
          velocityX = velocityX.clamp(-maxVelocity, maxVelocity);
          velocityY = velocityY.clamp(-maxVelocity, maxVelocity);
          
          // Cập nhật vị trí
          ballX -= velocityX;
          ballY += velocityY;
          
          // Áp dụng ma sát
          velocityX *= friction;
          velocityY *= friction;
          
          // Giới hạn quả bi trong màn hình
          _constrainBallPosition();
          
          // Kiểm tra điều kiện thắng
          _checkWinCondition();
        });
      }
    });
  }

  void _constrainBallPosition() {
    if (screenWidth > 0 && screenHeight > 0) {
      ballX = ballX.clamp(0, screenWidth - ballSize);
      ballY = ballY.clamp(0, screenHeight - ballSize);
    }
  }

  void _checkWinCondition() {
    // Tính khoảng cách giữa tâm quả bi và tâm đích
    double ballCenterX = ballX + ballSize / 2;
    double ballCenterY = ballY + ballSize / 2;
    double targetCenterX = targetX + targetSize / 2;
    double targetCenterY = targetY + targetSize / 2;
    
    double distance = sqrt(pow(ballCenterX - targetCenterX, 2) + pow(ballCenterY - targetCenterY, 2));
    
    // Nếu khoảng cách nhỏ hơn tổng bán kính của quả bi và đích
    if (distance < (ballSize + targetSize) / 2) {
      gameWon = true;
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chúc mừng!'),
          content: const Text('Bạn đã đưa quả bi vào đích thành công!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Chơi lại'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      gameWon = false;
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
      velocityX = 0;
      velocityY = 0;
      
      // Tạo vị trí đích mới ngẫu nhiên
      final random = Random();
      targetX = random.nextDouble() * (screenWidth - targetSize);
      targetY = random.nextDouble() * (screenHeight - targetSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
    // Khởi tạo vị trí ban đầu của quả bi ở giữa màn hình
    if (ballX == 0 && ballY == 0) {
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Lăn Bi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Chơi lại',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue, Colors.blue],
          ),
        ),
        child: Stack(
          children: [
            // Đích (cố định)
            Positioned(
              left: targetX,
              top: targetY,
              child: Container(
                width: targetSize,
                height: targetSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 4),
                  color: Colors.white.withOpacity(0.3),
                ),
                child: const Center(
                  child: Icon(
                    Icons.flag,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // Quả bi (sẽ di chuyển)
            Positioned(
              left: ballX,
              top: ballY,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // Hướng dẫn
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Nghiêng điện thoại để điều khiển quả bi vào đích!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
