import 'package:flutter/material.dart';
import 'package:kindnesstracker/Model/model.dart';
import 'package:kindnesstracker/Tile/displayTile.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final ScrollController _scrollController = ScrollController();

  List<item> items = [
    item(image: 'assets/un1.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni2.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni3.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/un1.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni2.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni3.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/un1.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni2.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni3.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/un1.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni2.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni3.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/un1.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni2.jpg', name: "Sohid Bir Mughdo Tour"),
    item(image: 'assets/uni3.jpg', name: "Sohid Bir Mughdo Tour"),


    // Add other items...
  ];

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(

          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text("What will you explore today?",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 35,

              ),),
            ),
            SizedBox(
              height: 6,
            ),

            Text("Choose a theme to lose yourself in",style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,

            ),),

            SizedBox(
              height: 30,
            ),

            Stack(
              children: [
                SizedBox(
                  height: height*0.9,
                  child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return DisplayTile(items: items[index]);
                      },
                    ),
                ),

                Positioned(
                  top: height * 0.45,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _scrollLeft,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.45,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: _scrollRight,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("Developed by Jakaria_ICT7_BUP",style: TextStyle(
              fontSize: 12,
              color: Colors.black
            ),),
            SizedBox(
              height: 20,
            ),
              ]
        ),
      ),


    );
  }
}
