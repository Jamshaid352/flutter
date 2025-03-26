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
      home: ImageListScreen(),
    );
  }
}

class ImageListScreen extends StatelessWidget {
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
      appBar: AppBar(title: Text("Image List")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5),
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
                      items[index]["name"]!,
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
                    child: items[index]["image"]!.contains("http")
                        ? Image.network(items[index]["image"]!, height: 150, width: 150, fit: BoxFit.cover)
                        : Image.asset(items[index]["image"]!, height: 150, width: 150, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
