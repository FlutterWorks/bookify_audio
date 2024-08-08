import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (b, index) {
                        return GestureDetector(
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: AutoSizeText(
                                  'রবীন্দ্রনাথ ঠাকুর',
                                  maxLines: 1,
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  const PersonInfo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonInfo extends StatelessWidget {
  const PersonInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height,
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Replace with actual image URL
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                'Person\'s Name', // Replace with actual name
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date of Birth:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'January 1, 1900', // Replace with actual DOB
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date of Death:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'December 31, 1980', // Replace with actual DOD
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Biography:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet accumsan tortor. Sed vel risus vitae quam gravida consectetur. Vivamus vitae ex sed dui accumsan tempor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet accumsan tortor. Sed vel risus vitae quam gravida consectetur. Vivamus vitae ex sed dui accumsan tempor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet accumsan tortor. Sed vel risus vitae quam gravida consectetur. Vivamus vitae ex sed dui accumsan tempor.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet accumsan tortor',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Famous poetry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Gitanjali, Kabuliwala,The Home and the World, Chokher Bali,Sadhana: The Realization of Life etc',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
