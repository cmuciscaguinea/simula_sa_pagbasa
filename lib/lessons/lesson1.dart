import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../aralin_page.dart'; // Corrected path to import AralinPage

class Lesson1 extends StatefulWidget {
  @override
  _Lesson1State createState() => _Lesson1State();
}

class _Lesson1State extends State<Lesson1> with WidgetsBindingObserver {
  final String title = 'Aralin 3 Aa'; // Title to match for completion in SharedPreferences
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _audioPlayer.stop(); // Stop audio when navigating away
    setState(() {
      isPlaying = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true); // Mark "Aralin 3 Aa" as completed

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()),
    );
  }

  void _playSound(String word) async {
    String audioPath;
    switch (word.toLowerCase()) {
      case 'ma':
        audioPath = 'audio/Aralin 3 - ma.mp3';
        break;
      case 'sa':
        audioPath = 'audio/Aralin 3 - sa.mp3';
        break;
      case 'ama':
        audioPath = 'audio/Aralin 3 - ama.mp3';
        break;
      case 'asa':
        audioPath = 'audio/Aralin 3 - asa.mp3';
        break;
      case 'sama':
        audioPath = 'audio/Aralin 3 - sama.mp3';
        break;
      case 'masa':
        audioPath = 'audio/Aralin 3 - masa.mp3';
        break;
      case 'sasama':
        audioPath = 'audio/Aralin 3 - sasama.mp3';
        break;
      case 'sa ama':
        audioPath = 'audio/Aralin 3 - sa_ama.mp3';
        break;
      case 'masama':
        audioPath = 'audio/Aralin 3 - masama.mp3';
        break;
      case 'sama-sama':
        audioPath = 'audio/Aralin 3 - sama_sama.mp3';
        break;
      default:
        return;
    }

    print("Attempting to play: $audioPath");

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> wordList = [
      'ma',
      'sa',
      'ama',
      'asa',
      'masa',
      'sama',
      'sasama',
      'masama',
      'sa ama',
      'sama-sama',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Aralin 3', style: GoogleFonts.lexendDeca()),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop(); // Stop audio on back navigation
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double fontSize = constraints.maxWidth * 0.08;
          return ListView.builder(
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              String word = wordList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            word,
                            style: GoogleFonts.lexendDeca(
                              fontSize: fontSize.clamp(20, 50),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.play_circle_outline, color: Colors.green, size: 40),
                        onPressed: () => _playSound(word),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: GoogleFonts.lexendDeca(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => markLessonAsDone(context),
          child: const Text('Susunod'),
        ),
      ),
    );
  }
}
