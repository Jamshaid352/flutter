import 'package:flutter/material.dart';
import 'students_data.dart'; // Import the student data

class StudentsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students List")),
      body: SingleChildScrollView(
        child: Column(
          children: students.map((student) {
            return Container(
              margin: EdgeInsets.all(10),
              height: 250, // Set height for stack container
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        student["image"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // Dark Overlay for Better Text Visibility
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  
                  // Student Details
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student["name"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Age: ${student["age"]}",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          student["email"]!,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
