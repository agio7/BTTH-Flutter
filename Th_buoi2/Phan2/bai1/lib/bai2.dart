import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Bai2Page extends StatefulWidget {
  const Bai2Page({super.key});

  @override
  State<Bai2Page> createState() => _Bai2PageState();
}

class _Bai2PageState extends State<Bai2Page> {
  bool _expanded = true; // default shows full as in screenshot

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không mở được liên kết')),
      );
    }
  }

  Future<void> _callPhone(String phone) async {
    await _openUrl('tel:$phone');
  }

  Future<void> _sendEmail(String email) async {
    await _openUrl('mailto:$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Rich Text Example'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3),
                    children: [
                      TextSpan(
                        text: 'Flutter',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl('https://flutter.dev'),
                      ),
                      const TextSpan(
                        text:
                            ' is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. First described in 2015, ',
                      ),
                      TextSpan(
                        text: 'Flutter',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl('https://flutter.dev'),
                      ),
                      const TextSpan(
                        text: ' was released in May 2017.\n  Contact on ',
                      ),
                      TextSpan(
                        text: '+910000210056',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _callPhone('+910000210056'),
                      ),
                      const TextSpan(text: '. Our email address is '),
                      TextSpan(
                        text: 'test@examplemail.org',
                        style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _sendEmail('test@examplemail.org'),
                      ),
                      const TextSpan(text: '.\nFor more details check '),
                      TextSpan(
                        text: 'https://www.google.com',
                        style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl('https://www.google.com'),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  maxLines: _expanded ? null : 4,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Read less' : 'Read more',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


