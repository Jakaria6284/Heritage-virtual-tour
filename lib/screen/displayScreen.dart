import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kindnesstracker/Tile/displayTile.dart';

import '../Model/model.dart';
import 'mapScreen.dart';

class DisplayScreen extends StatefulWidget {

  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {

  final ScrollController _scrollController = ScrollController();

  // Function to fetch data from Firestore
  Future<List<Item>> _fetchItems() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('jk').get();
    return querySnapshot.docs
        .map((doc)=>Item.fromFirestore(doc.data()as Map<String,dynamic>))
        .toList();
  }

  // Scroll left function
  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Scroll right function
  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: _fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            List<Item> items = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(

                    children: [

                      IconButton(
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>FullScreenImage())
                            );
                          },
                          icon:Icon(
                            Icons.change_circle_outlined,
                            color: Colors.black,
                            size: 60,
                          )
                      ),

                       SizedBox(width: 300,),
                      
                       Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          "What will you explore today?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 35,
                          ),

                                            ),
                      ),
                      
                      
          ]
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Choose a theme to lose yourself in",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Horizontal list with scroll buttons
                  Stack(
                    children: [
                      SizedBox(
                        height: height * 0.9,
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
                        top: height * 0.60,
                        left: 16,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: _scrollLeft,
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.60,
                        right: 16,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: _scrollRight,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Developed by Jakaria_ICT7_BUP",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
