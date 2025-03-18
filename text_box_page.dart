import 'package:flutter/material.dart';

class TextBoxPage extends StatefulWidget {
  const TextBoxPage({super.key});

  @override
  createState() => _TextBoxPageState();
}

class _TextBoxPageState extends State<TextBoxPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Box')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200, height: 40, // ✅ Smaller text box
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8)),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => debugPrint(_controller.text), child: const Text('Print')),
          ],
        ),
      ),
    );
  }
}
