import 'package:flutter/material.dart';
import 'db.dart';

class ViewUsers extends StatefulWidget {
  @override
  _ViewUsersState createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stored Users")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _userData.isEmpty
            ? Center(child: Text("No users found."))
            : ListView.builder(
                itemCount: _userData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_userData[index]['username']),
                      subtitle: Text("Password: ${_userData[index]['password']}"),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
