import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kindnesstracker/Model/model.dart';
import 'package:kindnesstracker/main.dart';

class DisplayTile extends StatelessWidget {
  final Item items;

  const DisplayTile({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                anotherImage: items.anotherImage,
                audioFile: items.audio,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: [
              // Cached network image
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: 300,
                child: CachedNetworkImage(
                  imageUrl: items.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              // Centered text overlay
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height * 0.4, // Adjust this value to center vertically
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xA51E1A1A), // Semi-transparent background for text visibility
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      items.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
