import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  const ProfilePage({super.key, required this.email});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('who_login');
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersData = prefs.getStringList('users') ?? [];

    for (String user in usersData) {
      Map<String, dynamic> userData = jsonDecode(user);
      if (userData['email'].toLowerCase() == email.toLowerCase()) {
        return userData; // Found the logged-in user
      }
    }
    return null; // User not found
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("User not found!")));
        }

        var user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user['image'] != null && user['image'].isNotEmpty)
                  Image.file(File(user['image']), height: 100)
                else
                  const Icon(Icons.person, size: 100),

                const SizedBox(height: 20),
                Text("Email: ${user['email']}", style: const TextStyle(fontSize: 18)),
                Text("Gender: ${user['gender']}", style: const TextStyle(fontSize: 18)),
                Text("Address: ${user['address']}", style: const TextStyle(fontSize: 18)),
                
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
