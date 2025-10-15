import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  DateTime? _selectedDate;
  String? _gender = "Nam";
  bool _isAgree = false;

  // Chọn ngày sinh
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Kiểm tra các trường bắt buộc
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    // Kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email không hợp lệ")),
      );
      return;
    }

    // Kiểm tra số điện thoại: chỉ gồm chữ số và độ dài hợp lệ (ví dụ: 10 chữ số)
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số điện thoại không hợp lệ")),
      );
      return;
    }

    // Kiểm tra mật khẩu
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu phải có ít nhất 6 ký tự")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu xác nhận không khớp")),
      );
      return;
    }

    // Kiểm tra checkbox điều khoản
    if (!_isAgree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn phải đồng ý với điều khoản")),
      );
      return;
    }

    // Nếu tất cả hợp lệ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng ký thành công!")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Nền xanh
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Đăng Ký Tài Khoản",
              style: TextStyle(fontWeight: FontWeight.bold,
              color: Colors.white,),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tạo tài khoản để bắt đầu trải nghiệm",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.person, size: 28),
          ),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Họ & tên",
                hintText: "Nguyễn Văn A",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "example@gmail.com",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                hintText: "0123456789",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 25),

            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
                hintText: "Nhập mật khẩu",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),

            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu",
                hintText: "Nhập lại mật khẩu",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),


            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: "Ngày sinh"),
                child: Text(
                  _selectedDate == null
                      ? "Chọn ngày sinh"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text("Giới tính"),
            RadioListTile(
              title: const Text("Nam"),
              value: "Nam",
              groupValue: _gender,
              onChanged: (value) {
                setState(() => _gender = value.toString());
              },
            ),
            RadioListTile(
              title: const Text("Nữ"),
              value: "Nữ",
              groupValue: _gender,
              onChanged: (value) {
                setState(() => _gender = value.toString());
              },
            ),
            RadioListTile(
              title: const Text("Khác"),
              value: "Khác",
              groupValue: _gender,
              onChanged: (value) {
                setState(() => _gender = value.toString());
              },
            ),

            CheckboxListTile(
              value: _isAgree,
              onChanged: (value) {
                setState(() => _isAgree = value!);
              },
              title: const Text("Tôi đồng ý với điều khoản sử dụng"),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Đăng Ký"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
