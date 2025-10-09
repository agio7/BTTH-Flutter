import 'package:flutter/material.dart';

class Bai4Page extends StatelessWidget {
  const Bai4Page({super.key});

  void _onPress(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pressed $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Buttons'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary
            ElevatedButton(
              onPressed: () => _onPress(context, 'primary'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('AppButton.primary()'),
            ),
            const SizedBox(height: 12),
            // Primary disabled
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('AppButton.primary() - disabled'),
            ),
            const SizedBox(height: 12),
            // Outlined
            OutlinedButton(
              onPressed: () => _onPress(context, 'outlined'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('AppButton.outlined()'),
            ),
            const SizedBox(height: 12),
            // Gradient
            GradientButton(
              onTap: () => _onPress(context, 'gradient'),
              label: 'AppButton.gradient()',
              colors: const [Color(0xFF3E4DB6), Color(0xFF1C275C)],
            ),
            const SizedBox(height: 12),
            // Accent gradient (green)
            GradientButton(
              onTap: () => _onPress(context, 'accentGradient'),
              label: 'AppButton.accentGradient()',
              colors: const [Color(0xFF44D39B), Color(0xFF2CAF7A)],
            ),
            const SizedBox(height: 24),
            // Text button enabled
            Center(
              child: TextButton(
                onPressed: () => _onPress(context, 'text'),
                child: const Text('AppTextButton()'),
              ),
            ),
            const SizedBox(height: 8),
            // Text button disabled
            const Center(
              child: TextButton(
                onPressed: null,
                child: Text('disabled AppTextButton()'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.colors,
  });

  final VoidCallback onTap;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}


