import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Bai3Page extends StatelessWidget {
  const Bai3Page({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RichText'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Hello World big
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 28),
                children: const [
                  TextSpan(text: 'Hello ', style: TextStyle(color: Colors.green)),
                  TextSpan(text: 'World', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Row 2: Hello World small with emoji
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 22, color: Colors.black87),
                children: [
                  TextSpan(text: 'Hello ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  TextSpan(text: 'World ', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w700)),
                  TextSpan(text: '👋'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Email line
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  const TextSpan(text: 'Contact me via: '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.email, size: 18, color: Colors.blue.shade700),
                    ),
                  ),
                  TextSpan(
                    text: 'Email',
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () => _open('mailto:me@example.com'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Phone line
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700),
                children: [
                  const TextSpan(text: 'Call Me: ', style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(
                    text: '+1234987654321',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => _open('tel:+1234987654321'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Blog line
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700),
                children: [
                  const TextSpan(text: 'Read My Blog '),
                  TextSpan(
                    text: 'HERE',
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () => _open('https://example.com/blog'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


