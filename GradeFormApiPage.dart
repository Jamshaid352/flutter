import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';

class InsertGradePage extends StatefulWidget {
  const InsertGradePage({super.key});

  @override
  State<InsertGradePage> createState() => _InsertGradePageState();
}

class _InsertGradePageState extends State<InsertGradePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  String? _selectedCourseName;
  String? _selectedSemester;
  String? _selectedCreditHours;

  bool _isSubmitting = false;
  String _responseMessage = '';
  bool _isSuccess = false;

  List<String> _courseNames = [];

  final List<String> _semesterOptions = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> _creditHourOptions = ['1', '2', '3', '4'];

  final String _postUrl = 'https://devtechtop.com/management/public/api/grades';
  final String _coursesUrl = 'https://bgnuerp.online/api/get_courses?user_id=12122';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(_coursesUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _courseNames = List<String>.from(data.map((e) => e['subject_name'].toString()));
        });
      }
    } catch (e) {
      debugPrint("Course fetch error: $e");
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _responseMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_postUrl),
        body: {
          'user_id': _userIdController.text.trim(),
          'course_name': _selectedCourseName!,
          'semester_no': _selectedSemester!,
          'credit_hours': _selectedCreditHours!,
          'marks': _marksController.text.trim(),
        },
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
          _responseMessage = 'Data Submitted Successfully!';
        });
      } else {
        setState(() {
          _isSuccess = false;
          _responseMessage = jsonData['message'] ?? 'Submission failed.';
        });
      }
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _responseMessage = 'Error: $e';
      });
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Insert Grade', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                validator: (value) => value == null || value.isEmpty ? 'Enter User ID' : null,
              ),
              const SizedBox(height: 12),
              DropdownSearch<String>(
                items: _courseNames,
                selectedItem: _selectedCourseName,
                onChanged: (val) => setState(() => _selectedCourseName = val),
                popupProps: const PopupProps.menu(showSearchBox: true),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: 'Course Name'),
                ),
                validator: (value) => value == null ? 'Select course' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedSemester,
                decoration: const InputDecoration(labelText: 'Semester'),
                items: _semesterOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSemester = val),
                validator: (value) => value == null ? 'Select semester' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCreditHours,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                items: _creditHourOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCreditHours = val),
                validator: (value) => value == null ? 'Select credit hours' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _marksController,
                decoration: const InputDecoration(labelText: 'Marks (0-100)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter marks';
                  final m = int.tryParse(value);
                  if (m == null || m < 0 || m > 100) return 'Marks must be 0–100';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Data'),
              ),
              if (_responseMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _responseMessage,
                    style: TextStyle(color: _isSuccess ? Colors.green : Colors.red),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
