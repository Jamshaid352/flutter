import 'package:flutter/material.dart';

class TextBoxDisplayPage extends StatefulWidget {
  const TextBoxDisplayPage({super.key});

  @override
  createState() => _TextBoxDisplayPageState();
}

class _TextBoxDisplayPageState extends State<TextBoxDisplayPage> {
  final _controller = TextEditingController();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter & Show Name')),
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
            ElevatedButton(onPressed: () => setState(() => _name = _controller.text), child: const Text('Show Name')),
            const SizedBox(height: 10),
            Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
