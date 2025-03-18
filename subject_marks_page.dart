import 'package:flutter/material.dart';

class SubjectMarksPage extends StatelessWidget {
  const SubjectMarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for subjects and marks
    final List<Map<String, dynamic>> subjects = [
      {'name': 'Mathematics', 'marks': 85, 'icon': Icons.calculate},
      {'name': 'Physics', 'marks': 78, 'icon': Icons.science},
      {'name': 'Chemistry', 'marks': 82, 'icon': Icons.biotech},
      {'name': 'Biology', 'marks': 90, 'icon': Icons.eco},
      {'name': 'Computer Science', 'marks': 95, 'icon': Icons.computer},
      {'name': 'English', 'marks': 88, 'icon': Icons.menu_book},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Marks'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Subject Marks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Subject',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Marks',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40), // Space for icons
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Subject List
            Expanded(
              child: ListView.separated(
                itemCount: subjects.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return ListTile(
                    leading: Icon(subject['icon'], color: Colors.deepPurple),
                    title: Text(
                      subject['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '${subject['marks']} / 100',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
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
