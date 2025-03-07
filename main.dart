import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baba Guru Nanak University',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png', // Ensure the file exists in assets folder
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.white);
              },
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'BABA GURU NANAK UNIVERSITY NANKANA SAHIB',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // About Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Baba Guru Nanak University',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '''Baba Guru Nanak University (BGNU) is a public sector university located in District Nankana Sahib, Punjab, Pakistan. 
It aims to facilitate 10,000 to 15,000 students worldwide. The foundation stone was laid on October 28, 2019, by the Prime Minister of Pakistan. 
The Government of Punjab formally passed the Baba Guru Nanak University Nankana Sahib Act 2020 (X of 2020) on July 2, 2020.

The university is designed to follow the standards of world-renowned institutions, with faculties in Medicine, Pharmacy, Engineering, Computer Science, 
Languages, Music, and Social Sciences. An initial budget of PKR 6 billion has been allocated for this project, to be spent in three phases. 
Phase-I construction is already underway.

Dr. Muhammad Afzal was appointed as the first Vice Chancellor. The university has signed MOUs with Govt. Guru Nanak (Post Graduate) College and Govt. 
Guru Nanak Associate College for Women for technical assistance and temporary classroom arrangements until the academic building is completed.

Admissions for the Fall 2024 semester will be announced soon, with academic programs already prepared. The university has also introduced 
the Centre of Excellence for Baba Guru Nanak & Sikh Cultural Heritage, along with a dedicated chair for Punjab Studies.''',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            // Image Below About Section
            // Image Below About Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10,
                ), // Optional: Rounded corners
                child: Image.asset(
                  'assets/images/vc.png',
                  height: 150, // Adjusted height
                  width: 300, // Adjusted width
                  fit: BoxFit.contain, // Ensures the whole image is visible
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.deepPurple,
              width: double.infinity,
              child: const Center(
                child: Text(
                  '© 2025 Baba Guru Nanak University | All Rights Reserved',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
