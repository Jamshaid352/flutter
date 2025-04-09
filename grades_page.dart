import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('grades.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, 
      onCreate: _createDB, 
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS grades");
        _createDB(db, newVersion);
      }
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE grades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentname TEXT,
        fathername TEXT,
        progname TEXT,
        shift TEXT,
        rollno TEXT,
        coursecode TEXT,
        coursetitle TEXT,
        credithours TEXT,
        obtainedmarks TEXT,
        mysemester TEXT
      )
    ''');
  }

  Future<void> insertGrade(Map<String, dynamic> grade) async {
    final db = await instance.database;
    await db.insert(
      'grades',
      grade,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchGrades() async {
    final db = await instance.database;
    return await db.query('grades');
  }

  Future<void> deleteGrade(int id) async {
    final db = await instance.database;
    await db.delete('grades', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearGrades() async {
    final db = await instance.database;
    await db.delete('grades');
  }
}

class GradePage extends StatefulWidget {
  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  List<Map<String, dynamic>> _grades = [];

  Future<void> _fetchGradesFromAPI() async {
    final response = await http.get(Uri.parse("https://bgnuerp.online/api/gradeapi"));

    if (response.statusCode == 200) {
      List<dynamic> apiData = jsonDecode(response.body);
      await DatabaseHelper.instance.clearGrades();

      for (var grade in apiData) {
        await DatabaseHelper.instance.insertGrade({
          'studentname': grade['studentname'] ?? 'N/A',
          'fathername': grade['fathername'] ?? 'N/A',
          'progname': grade['progname'] ?? 'N/A',
          'shift': grade['shift'] ?? 'N/A',
          'rollno': grade['rollno'] ?? 'N/A',
          'coursecode': grade['coursecode'] ?? 'N/A',
          'coursetitle': grade['coursetitle'] ?? 'N/A',
          'credithours': grade['credithours'] ?? 'N/A',
          'obtainedmarks': (grade['obtainedmarks'] == "" || grade['obtainedmarks'] == null) ? 'Not Available' : grade['obtainedmarks'],
          'mysemester': grade['mysemester'] ?? 'N/A',
        });
      }

      await _loadGradesFromDB();
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Failed to load data!")),
      );
    }
  }

  Future<void> _loadGradesFromDB() async {
    final data = await DatabaseHelper.instance.fetchGrades();
    setState(() {
      _grades = data;
    });
  }

  void _resetData() async {
    await DatabaseHelper.instance.clearGrades();
    setState(() {
      _grades = [];
    });
  }

  Future<void> _deleteGrade(int id) async {
    await DatabaseHelper.instance.deleteGrade(id);
    _loadGradesFromDB();
  }

  @override
  void initState() {
    super.initState();
    _loadGradesFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grade Data")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _fetchGradesFromAPI,
                child: Text("Load Data"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetData,
                child: Text("Reset Data"),
              ),
            ],
          ),
          Expanded(
            child: _grades.isEmpty
                ? Center(child: Text("No Data Available"))
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Student Name")),
                          DataColumn(label: Text("Father Name")),
                          DataColumn(label: Text("Program")),
                          DataColumn(label: Text("Shift")),
                          DataColumn(label: Text("Roll No")),
                          DataColumn(label: Text("Course Code")),
                          DataColumn(label: Text("Course Title")),
                          DataColumn(label: Text("Credit Hours")),
                          DataColumn(label: Text("Obtained Marks")),
                          DataColumn(label: Text("Semester")),
                          DataColumn(label: Text("Action")),
                        ],
                        rows: _grades
                            .map(
                              (grade) => DataRow(cells: [
                                DataCell(Text(grade['studentname'] ?? 'N/A')),
                                DataCell(Text(grade['fathername'] ?? 'N/A')),
                                DataCell(Text(grade['progname'] ?? 'N/A')),
                                DataCell(Text(grade['shift'] ?? 'N/A')),
                                DataCell(Text(grade['rollno'] ?? 'N/A')),
                                DataCell(Text(grade['coursecode'] ?? 'N/A')),
                                DataCell(Text(grade['coursetitle'] ?? 'N/A')),
                                DataCell(Text(grade['credithours'] ?? 'N/A')),
                                DataCell(Text(grade['obtainedmarks'] ?? 'Not Available')),
                                DataCell(Text(grade['mysemester'] ?? 'N/A')),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteGrade(grade['id'] ?? 0),
                                  ),
                                ),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
