import 'package:flutter/material.dart';
import 'package:kindnesstracker/Model/model.dart';

class DisplayTile extends StatelessWidget {
  final item items; // Ensure this is the correct casing
  const DisplayTile({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 400, // Set a fixed height
      width: 300, // Set desired width
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: AssetImage(items.image),
          fit: BoxFit.cover, // Ensures the image covers the entire container
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xA51E1A1A), // Semi-transparent background for text visibility
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              items.name, // Item title
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
