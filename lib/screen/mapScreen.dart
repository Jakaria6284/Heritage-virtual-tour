import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/model.dart'; // Import your Item model
import '../main.dart'; // Ensure to import your HomeScreen class
import 'displayScreen.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({Key? key}) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  // Fetch item from Firestore by document name
  Future<Item?> _fetchItem(String documentName) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('jk').doc(documentName).get();
    if (documentSnapshot.exists) {
      return Item.fromFirestore(documentSnapshot.data() as Map<String, dynamic>);
    }
    return null; // Return null if the document doesn't exist
  }

  // Show marker dialog with location name and navigate to HomeScreen
  void _showMarkerDialog(BuildContext context, String locationName, Item item) {
    showDialog(context: context, builder: (BuildContext contect){
      return AlertDialog();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location"),
          content: Text(locationName),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Close"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to HomeScreen with anotherImage and audio
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      anotherImage: item.anotherImage, // Pass anotherImage
                      audioFile: item.audio, // Pass audio
                    ),
                  ),
                );
              },
              child: Text("Visit"),
            ),
          ],
        );
      },
    );
  }

  // Handle marker click
  void _onMarkerTap(BuildContext context, String locationName, String documentName) async {
    final item = await _fetchItem(documentName);
    if (item != null) {
      _showMarkerDialog(context, locationName, item);
    } else {
      // Handle the case where the item is not found (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          double originalImageWidth = 800.0;
          double originalImageHeight = 600.0;

          double imageAspectRatio = originalImageWidth / originalImageHeight;
          double screenAspectRatio = screenWidth / screenHeight;

          double scaledImageWidth, scaledImageHeight;
          if (screenAspectRatio > imageAspectRatio) {
            scaledImageHeight = screenHeight;
            scaledImageWidth = screenHeight * imageAspectRatio;
          } else {
            scaledImageWidth = screenWidth;
            scaledImageHeight = screenWidth / imageAspectRatio;
          }

          double widthScale = scaledImageWidth / originalImageWidth;
          double heightScale = scaledImageHeight / originalImageHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/final.png',
                  fit: BoxFit.cover,
                ),
              ),


             //lal bag fort
              Positioned(
                left: (0.20 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.10 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location: Soshi lodge Mymensing", "soshilodgeMymensing"); // Use document name
                  },

                    child: Image.asset(
                      'assets/house.png',
                      width: 60.0,
                      height: 60.0,

                  ),
                ),
              ),



              Positioned(
                left: (0.90 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.40 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location 1: Lalbagh Fort", "lalbagfort"); // Use document name
                  },
                  child: IconButton(
                      onPressed: (){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context)=>DisplayScreen())
                        );
                      },
                      icon:Icon(
                        Icons.change_circle_outlined,
                        color: Colors.black,
                        size: 80,
                      )
                  )
                ),
              ),





              Positioned(
                left: (0.25 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.40 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location 1: Lalbagh Fort", "lalbagfort"); // Use document name
                  },
                  child: Image.asset(
                    'assets/red-fort.png',
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),







              Positioned(
                left: (0.30 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.23 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location : Tajhat place Rangpur", "tajhatplaceRangpur"); // Use document name
                  },
                  child: Image.asset(
                    'assets/buckingham-palace.png',
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),






              Positioned(
                left: (0.40 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.55 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location : Baliati Jamidar Bari", "BaliatiJamidarBari"); // Use document name
                  },
                  child: Image.asset(
                    'assets/tarashbhaban.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),



              Positioned(
                left: (0.60 * originalImageWidth) * widthScale + (screenWidth - scaledImageWidth) / 2,
                top: (0.65 * originalImageHeight) * heightScale + (screenHeight - scaledImageHeight) / 2,
                child: GestureDetector(
                  onTap: () {
                    _onMarkerTap(context, "Location : Puthia Rajbari", "puthiaRajbari"); // Use document name
                  },
                  child: Image.asset(
                    'assets/puthia.png',
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),





            ],
          );
        },
      ),
    );
  }
}
