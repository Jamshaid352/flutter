import 'package:flutter/material.dart';
import 'db.dart'; // Ensure this file exists

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<Map<String, dynamic>> _userData = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    List<Map<String, dynamic>> data = await DatabaseHelper.instance.getUsers();
    setState(() {
      _userData = data;
    });
  }

  void _submitData() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage("Please enter both username and password.");
      return;
    }

    await DatabaseHelper.instance.insertUser(username, password);
    _usernameController.clear();
    _passwordController.clear();
    _loadUsers();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Form (SQLite)")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username or Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            Text("Stored Users:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_userData[index]['username']),
                    subtitle: Text(_userData[index]['password']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
