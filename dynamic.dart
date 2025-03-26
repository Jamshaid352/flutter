import 'package:flutter/material.dart';
import 'array.dart'; // Import the array data

class DynamicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Image List")),
      body: ListView.builder(
        itemCount: items.length, // Use the imported list
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
                Text(
                  items[index]["name"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                items[index]["image"]!.contains("http")
                    ? Image.network(items[index]["image"]!,
                        height: 150, width: 150, fit: BoxFit.cover)
                    : Image.asset(items[index]["image"]!,
                        height: 150, width: 150, fit: BoxFit.cover),
              ],
            ),
          );
        },
      ),
    );
  }
}
