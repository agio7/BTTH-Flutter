import 'package:flutter/material.dart';

class Bai5Page extends StatelessWidget {
  const Bai5Page({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6C63FF);
    const lightPurple = Color(0xFFE6E0FF);

    final lessons = const [
      'Introduction to Flutter',
      'Installing Flutter on Windows',
      'Setup Emulator on Windows',
      'Creating Our First App',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const FlutterLogo(size: 120),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
                    ),
                    child: const Icon(Icons.play_arrow, color: purple, size: 34),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Flutter Complete Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text('Created by Dear Programmer', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 2),
            const Text('55 Videos', style: TextStyle(color: Colors.black45)),
            const SizedBox(height: 16),

            // Tabs (simple buttons)
            Container(
              decoration: BoxDecoration(
                color: lightPurple.withOpacity(0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Videos'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBAEF8),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Description'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lessons list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: purple,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text(lessons[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('20 min 50 sec'),
                  onTap: () {},
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


