import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageListScreenh(),
    );
  }
}

class ImageListScreenh extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"name": "Jamshaid Ali", "image": "assets/images/jam.jpg"},
    {"name": "Kashif", "image": "assets/images/im2.jpg"},
    {"name": "Maqsood", "image": "assets/images/im3.jpg"},
    {"name": "Muzammal", "image": "https://images.app.goo.gl/2heHeG8vrUeGjRCe7"},
    {"name": "Ahmad", "image": "https://images.app.goo.gl/hf7TAvSRQysbWghC9"},
    {"name": "Ali", "image": "https://images.app.goo.gl/aycqYMZomUkkPVUD9"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Horizontal Image List")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Row(
          children: items.map((item) {
            return Container(
              width: 200, // Fixed width for each container
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Name Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        item["name"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Image Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item["image"]!.contains("http")
                          ? Image.network(item["image"]!, height: 150, width: 150, fit: BoxFit.cover)
                          : Image.asset(item["image"]!, height: 150, width: 150, fit: BoxFit.cover),
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
