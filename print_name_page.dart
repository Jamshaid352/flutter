import 'package:flutter/material.dart';

class PrintNamePage extends StatelessWidget {
  const PrintNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name'),
        backgroundColor: Colors.deepPurple, // Add a color for visibility
      ),
      body: const Center(
        child: Text(
          'Jamshaid Ali',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
