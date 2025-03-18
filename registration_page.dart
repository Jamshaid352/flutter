import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_detail_page.dart'; // Import the details page

/// Registration Page - Allows users to enter and save their details
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController(); // Email input controller
  final TextEditingController _contactController = TextEditingController(); // Contact input controller
  String _status = 'Active'; // Default status is Active

  /// Saves user data into SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    await prefs.setString('email', _emailController.text); // Save email
    await prefs.setString('contact', _contactController.text); // Save contact number
    await prefs.setString('status', _status); // Save status
  }

  /// Validates and submits the form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) { // Validate form
      await _saveData(); // Save data to SharedPreferences

      if (!mounted) return; // Prevent async context issues

      // Show success message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully Registered!")),
      );

      // Navigate to Registration Details Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationDetailsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Registration")), // App bar title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required"; // Validation message
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter a valid email"; // Validation for valid email
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Spacing

              // Contact Number input field
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: "Contact Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Contact number is required"; // Validation message
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Enter only numbers"; // Ensure only numbers
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Spacing

              // Status selection (Active/Inactive)
              const Text("Status:"),
              Row(
                children: [
                  Radio(
                    value: 'Active',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  const Text("Active"),
                  Radio(
                    value: 'Inactive',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value.toString();
                      });
                    },
                  ),
                  const Text("Inactive"),
                ],
              ),
              const SizedBox(height: 20), // Spacing

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm, // Calls form submission function
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
