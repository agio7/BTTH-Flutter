import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController _mapController;
  LatLng _pickedLocation = const LatLng(21.0285, 105.8542); // Hà Nội

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _pickedLocation = position.target;
    });
  }

  void _confirmLocation() {
    Navigator.pop(context, _pickedLocation);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location on Map"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation,
                    zoom: 16,
                  ),
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                const Center(
                  child: Icon(Icons.location_pin, size: 50, color: Colors.red),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Search for a location...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Tìm kiếm địa điểm
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Nền xanh
                        foregroundColor: Colors.white, // Chữ trắng
                      ),
                      child: const Text("Search",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // In đậm
                        ),),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Đẩy nút về bên phải
                  children: [
                    TextButton(
                      onPressed: _cancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 12, // Chữ nhỏ
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _confirmLocation,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(
                          fontSize: 12, // Chữ nhỏ
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
