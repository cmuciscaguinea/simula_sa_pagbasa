import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../lessons/lesson2.dart'; // Adjusted to import Lesson4

class AralinDetailPage4 extends StatefulWidget {
  final String title;
  final String audioPath;

  AralinDetailPage4({super.key, required this.title, required this.audioPath});

  @override
  _AralinDetailPage4State createState() => _AralinDetailPage4State();
}

class _AralinDetailPage4State extends State<AralinDetailPage4> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of audio player when widget is removed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Stop audio if the app is closed or goes to the background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _audioPlayer.stop();
    }
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing audio
      await _audioPlayer.play(AssetSource(widget.audioPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> splitTitle = widget.title.split(' ');
    String letter = 'Ang';

    return Scaffold(
      appBar: AppBar(
        title: Text('${splitTitle[0]} ${splitTitle[1]}', style: GoogleFonts.lexendDeca()),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop(); // Stop audio when going back
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
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                fontSize: 190,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play Button
                Container(
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
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                    onPressed: _playSound,
                  ),
                ),
                const SizedBox(width: 20),
                // Next Button
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                    onPressed: () {
                      _audioPlayer.stop(); // Stop audio before navigating to Lesson4
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Lesson4(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
