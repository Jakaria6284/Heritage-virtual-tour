import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:kindnesstracker/screen/aiScreen.dart';
import 'package:kindnesstracker/screen/displayScreen.dart';
import 'package:kindnesstracker/screen/mapScreen.dart';
import 'package:kindnesstracker/screen/mapScreen.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Variable to track if Firebase initialization was successful
  bool isFirebaseInitialized = false;

  try {
    // Initialize Gemini (assuming it's synchronous)
    Gemini.init(apiKey: 'AIzaSyAY8EWYFrbh26r7oUo-T6SdXRgAXXcwkzA');

    // Initialize Firebase if running on the web
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyA5An5dm5exwjX9agp_dwhj6qdTqWLBRRI",
          authDomain: "emergency-help-c6266.firebaseapp.com",
          projectId: "emergency-help-c6266",
          storageBucket: "emergency-help-c6266.appspot.com",
          messagingSenderId: "54619204460",
          appId: "1:54619204460:web:e8a4339cc9a3f19899a149",
          measurementId: "G-RT23QC42QR",
        ),
      );
      isFirebaseInitialized = true;
      print("Firebase initialization successful.");
    }
  } catch (e) {
    print("Error during initialization: $e");
  }

  // Check if both Firebase and Gemini are initialized successfully
  if (isFirebaseInitialized) {
    print("Connect Gemini");
  }

  // Run the main application
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FullScreenImage(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String anotherImage;
  final String audioFile;
  const HomeScreen({super.key, required this.anotherImage, required this. audioFile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<PanoramaState> _panoKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
    _playAudio(); // Automatically play the audio on start
  }

  // Function to zoom in
  void zoomIn() {
    final currentState = _panoKey.currentState;
    if (currentState != null) {
      final currentZoom = currentState.scene!.camera.zoom;
      currentState.setZoom(currentZoom + 0.3);
    }
  }

  // Function to zoom out
  void zoomOut() {
    final currentState = _panoKey.currentState;
    if (currentState != null) {
      final currentZoom = currentState.scene!.camera.zoom;
      currentState.setZoom(currentZoom - 0.3);
    }
  }

  // Function to play the audio file
  Future<void> _playAudio() async {
    if (!_isMuted) {
      await _audioPlayer.play(UrlSource(widget.audioFile)); // Ensure the correct path
    }
  }

  // Function to stop the audio
  Future<void> _stopAudio() async {
    await _audioPlayer.stop(); // Stop the audio
  }

  // Function to toggle mute/unmute
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });

    if (_isMuted) {
      _stopAudio(); // Stop audio if muted
    } else {
      _playAudio(); // Play audio if unmuted
    }
  }

  // Function to toggle fullscreen mode
  void toggleFullscreen() {
    if (html.document.fullscreenElement == null) {
      html.document.documentElement!.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player when the screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Set height to 0
        child: AppBar(
          backgroundColor: Colors.transparent, // Transparent background
        ),
      ),
      body: Stack(
        children: [
          Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                double yScroll = event.scrollDelta.dy;
                if (yScroll <= 0) {
                  zoomIn();
                }
                if (yScroll > 0) {
                  zoomOut();
                }
              }
            },
            child: PanoramaViewer(
                key: _panoKey,
                animSpeed: 0.1,
                child:  Image.network(widget.anotherImage)
            ),
          ),
          // Add Zoom buttons on top-right corner with white circular background
          Positioned(
            bottom: 30,
            right: 10,
            child: Row(
              children: [
                _buildControlButton(
                  icon: Icons.add,
                  onPressed: zoomIn,
                ),
                const SizedBox(width: 10),
                _buildControlButton(
                  icon: Icons.remove,
                  onPressed: zoomOut,
                ),
              ],
            ),
          ),
          // Mute/Unmute button on bottom-left corner with white circular background
          Positioned(
            bottom: 30,
            left: 10,
            child: Column(
              children: [
                _buildControlButton(
                  icon: _isMuted ? Icons.play_circle : Icons.pause,
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),

          Positioned(
            top: 30,
            left: 10,
            child: Column(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context,

                      MaterialPageRoute(builder: (context)=>
                          Aiscreen()

                      )

                  );

                },
                    child: Text("ASK AI",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),)

                )
              ],
            ),
          ),



          // Fullscreen button on the bottom-right corner
          Positioned(
            bottom: 30,
            left: 80,
            child: _buildControlButton(
              icon: Icons.fullscreen,
              onPressed: toggleFullscreen,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a button with white circular background
  Widget _buildControlButton({required IconData icon, required void Function() onPressed}) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // White background
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.black, // Black icon color for better visibility
        iconSize: 30, // Icon size
      ),
    );
  }
}