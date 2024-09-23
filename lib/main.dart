import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:kindnesstracker/screen/displayScreen.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      await _audioPlayer.play(AssetSource('frontViewVoice.mp3')); // Ensure the correct path
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
              child: Image.asset('assets/bridge.jpg'), // Your panorama image here
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