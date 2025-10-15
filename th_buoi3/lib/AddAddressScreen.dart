import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapPickerScreen.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add New Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const Icon(Icons.close), // Chỉ hiển thị, không có onPressed
          ],
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipient Name
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Recipient Name",
                    hintText: "Nguyễn Văn A",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),


                // Phone Number
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "0912345678",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),


                // Province/City
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Province/City",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedProvince,
                  items: ["Hà Nội", "Hồ Chí Minh", "Đà Nẵng"]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProvince = value;
                    });
                  },
                ),
                const SizedBox(height: 25),

                // District
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "District",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDistrict,
                  items: ["Quận 1", "Quận 2", "Quận 3"]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                ),
                const SizedBox(height: 25),

                // Ward
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Ward",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedWard,
                  items: ["Phường A", "Phường B", "Phường C"]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWard = value;
                    });
                  },
                ),
                const SizedBox(height: 25),

                // Address Details
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Address Details",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 25),

                // Select on Map button
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                    );

                    if (result != null && result is LatLng) {
                      // TODO: lưu tọa độ hoặc hiển thị
                      print("Picked location: ${result.latitude}, ${result.longitude}");
                    }
                  },

                  icon: const Icon(Icons.map_outlined),
                  label: const Text("Select on Map"),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: save address
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Save Address"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
