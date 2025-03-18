import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  CalculatorPageState createState() => CalculatorPageState();
}

class CalculatorPageState extends State<CalculatorPage> { // Remove underscore (_)
  final TextEditingController value1Controller = TextEditingController();
  final TextEditingController value2Controller = TextEditingController();
  String selectedOperation = '+'; 
  double? result; 

  void calculateResult() {
    double? num1 = double.tryParse(value1Controller.text);
    double? num2 = double.tryParse(value2Controller.text);

    if (num1 == null || num2 == null) {
      setState(() {
        result = null; 
      });
      return;
    }

    switch (selectedOperation) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = (num2 != 0) ? num1 / num2 : null;
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: value1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Value 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: value2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Value 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedOperation,
              decoration: const InputDecoration(
                labelText: 'Select Operation',
                border: OutlineInputBorder(),
              ),
              items: ['+', '-', '*', '/']
                  .map((op) => DropdownMenuItem(
                        value: op,
                        child: Text(op),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOperation = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            Text(
              'Result: ${result != null ? result.toString() : 'Enter valid values'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateResult,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
