import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// RegistrationDetailsPage - Displays all user registration details stored in SharedPreferences
class RegistrationDetailsPage extends StatefulWidget {
  const RegistrationDetailsPage({super.key});

  @override
  RegistrationDetailsPageState createState() => RegistrationDetailsPageState();
}

class RegistrationDetailsPageState extends State<RegistrationDetailsPage> {
  List<Map<String, String>> _registrations = []; // Stores multiple user registrations

  @override
  void initState() {
    super.initState();
    _loadData(); // Load saved user data
  }

  /// Loads all stored user data from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedRegistrations = prefs.getStringList('registrations') ?? [];

    setState(() {
      _registrations = storedRegistrations
          .map((entry) {
            var data = entry
                .replaceAll('{', '')
                .replaceAll('}', '')
                .split(', ')
                .map((e) => e.split(': '))
                .map((kv) => MapEntry(kv[0].trim(), kv[1].trim()))
                .toList();
            
            return Map<String, String>.fromEntries(data);
          })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Registered Users")),
      body: _registrations.isEmpty
          ? const Center(child: Text("No registrations found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _registrations.length,
              itemBuilder: (context, index) {
                final reg = _registrations[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(75),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Email: ${reg['email']}", style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 5),
                      Text("Contact: ${reg['contact']}", style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Status: ${reg['status']}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            reg['status'] == 'Active' ? Icons.check_circle : Icons.cancel,
                            color: reg['status'] == 'Active' ? Colors.green : Colors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
