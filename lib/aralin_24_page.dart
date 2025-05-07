import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../lessons/lesson24.dart'; // Adjusted to import Lesson24

class AralinDetailPage24 extends StatefulWidget {
  final String title;
  final String audioPath;

  AralinDetailPage24({super.key, required this.title, required this.audioPath});

  @override
  _AralinDetailPage24State createState() => _AralinDetailPage24State();
}

class _AralinDetailPage24State extends State<AralinDetailPage24> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _audioPlayer.stop();
    }
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(widget.audioPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String letter = '-ng'; // Updated to -ng

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.comicNeue()),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              letter,
              style: GoogleFonts.lexendDeca(
                fontSize: 200,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(Icons.play_arrow, _playSound),
                const SizedBox(width: 20),
                _buildIconButton(
                  Icons.arrow_forward,
                  () {
                    _audioPlayer.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Lesson24()), // Updated to Lesson24
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.5),
            spreadRadius: 10,
            blurRadius: 15,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
