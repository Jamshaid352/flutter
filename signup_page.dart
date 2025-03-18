import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedGender;
  XFile? _image;
  int _charCount = 50;
  int _wordCount = 15;
  bool _isEmailValid = true;
  bool _isAddressValid = true;

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _validateEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(value);
    });
  }

  void _validateAddress(String value) {
    int charCount = 50 - value.length;
    int wordCount = 15 - value.split(RegExp(r'\s+')).length;
    bool isValid = value.length >= 10 && value.split(RegExp(r'\s+')).length >= 5;
    
    setState(() {
      _charCount = charCount.clamp(0, 50);
      _wordCount = wordCount.clamp(0, 15);
      _isAddressValid = isValid;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Must have 1 upper, 1 lower, 1 number, 1 special, 6+ chars';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedGender != null && _image != null) {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing users
      List<String> users = prefs.getStringList('users') ?? [];

      // Check if email already exists
      bool emailExists = users.any((user) {
        Map<String, dynamic> userData = jsonDecode(user);
        return userData['email'] == _emailController.text;
      });

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email already registered")));
        return;
      }

      // Save new user
      Map<String, String> newUser = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'gender': _selectedGender!,
        'address': _addressController.text,
        'image': _image!.path
      };

      users.add(jsonEncode(newUser));
      await prefs.setStringList('users', users);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Registered")));

      // Redirect to Login Page
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _isEmailValid ? null : "Enter a valid email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _validateEmail,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onChanged: (value) => setState(() {}),
                  validator: _validatePassword,
                ),
                if (_passwordController.text.isNotEmpty)
                  Text(
                    _validatePassword(_passwordController.text) ?? "Strong Password!",
                    style: TextStyle(
                      color: _validatePassword(_passwordController.text) == null ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedGender = value),
                  decoration: const InputDecoration(labelText: "Gender"),
                  validator: (value) => value == null ? 'Select a gender' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    errorText: _isAddressValid ? null : "Min 10 chars & 5 words required",
                  ),
                  maxLength: 50,
                  onChanged: _validateAddress,
                ),
                Text("Remaining: $_charCount chars, $_wordCount words"),
                const SizedBox(height: 10),
                _image != null
                    ? kIsWeb
                        ? Image.network(_image!.path, height: 100)
                        : Image.file(File(_image!.path), height: 100)
                    : const Text("No image selected"),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Choose Image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
