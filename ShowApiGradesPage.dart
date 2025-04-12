import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowGradePage extends StatefulWidget {
  const ShowGradePage({super.key});

  @override
  State<ShowGradePage> createState() => _ShowGradePageState();
}

class _ShowGradePageState extends State<ShowGradePage> {
  List<dynamic> _grades = [];
  bool _isLoading = false;
  String _responseMessage = '';

  final String _getUrl = 'https://devtechtop.com/management/public/api/select_data';

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(_getUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _grades = data is List ? data : (data['data'] ?? []);
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to load data.';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Show Grades', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Show Data'),
            ),
            const SizedBox(height: 20),
            if (_responseMessage.isNotEmpty)
              Text(_responseMessage, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: _grades.isEmpty
                  ? const Center(child: Text('No data loaded yet.'))
                  : ListView.builder(
                      itemCount: _grades.length,
                      itemBuilder: (context, index) {
                        final g = _grades[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(g['course_name'] ?? 'No Course'),
                            subtitle: Text('User ID: ${g['user_id']} | Marks: ${g['marks']}'),
                            trailing: Text('Sem: ${g['semester_no']}'),
                          ),
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
