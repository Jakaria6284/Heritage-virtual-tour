import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';  // Import the Lottie package

class Aiscreen extends StatefulWidget {
  const Aiscreen({super.key});

  @override
  State<Aiscreen> createState() => _AiscreenState();
}

class _AiscreenState extends State<Aiscreen> {
  TextEditingController _controller = TextEditingController();
  List<String> aiResponses = [];  // List to store AI responses
  final ScrollController _scrollController = ScrollController();  // Controller to scroll to the latest message
  bool isLoading = false;  // Track loading state

  void airesponse() {
    String inputText = _controller.text.trim();
    final gemini = Gemini.instance;

    if (inputText.isNotEmpty) {
      setState(() {
        isLoading = true;  // Set loading state to true
      });

      gemini.streamGenerateContent(inputText).listen(
            (value) {
          // Log the response from the stream
          log('Received value: $value');

          setState(() {
            aiResponses.add(value.output ?? 'No response');  // Add response to the list
            isLoading = false;  // Set loading state to false once the response is received
          });
          _scrollToBottom();
        },
        onError: (e) {
          log('Stream error: $e');  // Log the error if there's an issue with the stream
          setState(() {
            isLoading = false;  // Stop loading on error
          });
        },
      );
    } else {
      log("No generation because input box is empty");
    }
  }

  // Function to scroll to the bottom of the chat
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Function to handle bold text and bullet points formatting
  TextSpan _buildFormattedText(String text) {
    final List<TextSpan> spans = [];
    final regexBold = RegExp(r'(\*\*([^\*]+)\*\*)');  // Regex to detect '**some word**'
    final regexBullet = RegExp(r'(\*([^\*]+))');  // Regex to detect '*some word'

    int lastIndex = 0;

    // Find all matches of bold text and build the TextSpans
    final matchesBold = regexBold.allMatches(text);
    final matchesBullet = regexBullet.allMatches(text);

    // Merge both matches (bold and bullet)
    final allMatches = [
      ...matchesBold,
      ...matchesBullet,
    ];

    allMatches.sort((a, b) => a.start.compareTo(b.start));  // Sort matches by position

    // Add spans for each match
    for (final match in allMatches) {
      // Add text before the match (non-bold, non-bullet text)
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(fontWeight: FontWeight.normal),
        ));
      }

      if (match.group(0)?.startsWith("**") == true) {
        // This is bold text
        spans.add(TextSpan(
          text: match.group(2),  // The actual bolded word
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(0)?.startsWith("*") == true) {
        // This is a bullet point
        spans.add(TextSpan(
          text: '• ${match.group(2)}',  // Add bullet point
          style: TextStyle(fontWeight: FontWeight.normal),
        ));
      }

      lastIndex = match.end;
    }

    // Add any remaining text after the last match
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(fontWeight: FontWeight.normal),
      ));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ask Any Question to AI"),
      ),
      body: Column(
        children: [
          // Expanded area for displaying AI responses
          Expanded(
            child: ListView.builder(
              controller: _scrollController,  // Attach the ScrollController
              padding: EdgeInsets.all(8.0),
              itemCount: aiResponses.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: RichText(
                    text: _buildFormattedText(aiResponses[index]),
                  ),
                );
              },
            ),
          ),

          // Display loading animation while waiting for response
          if (isLoading)
            Center(  // Wrap with Center to position in the middle
              child: Lottie.asset(
                'assets/loading.json',
                width: 500,
                height: 200,
              ),
            ),

          // User input field and send button at the bottom
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Enter text',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,  // Circle color
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    onPressed: airesponse,  // Send button
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,  // Icon size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
