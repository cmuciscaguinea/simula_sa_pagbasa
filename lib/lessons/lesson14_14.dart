import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson14_14 extends StatefulWidget {
  @override
  _Lesson14_14State createState() => _Lesson14_14State();
}

class _Lesson14_14State extends State<Lesson14_14> with WidgetsBindingObserver {
  final String title = 'Aralin 14.14';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1; // Initialize to -1 to hide highlight initially

  final String textContent = '''
Si kuya ay masaya.
Siya ay may yoyo.
Ito ay biyaya.
Sumama si kuya kay yaya.
Sila ay masaya.
''';

  List<String> words = [];

  // Updated custom timestamps for each word in milliseconds
  final List<int> wordTimings = [
    // "Si kuya ay masaya." (3.23 seconds, 4 words)
    0, 808, 1616, 2424,

    // "Siya ay may yoyo." (2.86 seconds, 4 words)
    3230, 3945, 4660, 5375,

    // "Ito ay biyaya." (2.73 seconds, 3 words)
    6090, 7000, 7910,

    // "Sumama si kuya kay yaya." (4.03 seconds, 5 words)
    8640, 9446, 10252, 11058, 11864,

    // "Sila ay masaya." (2.40 seconds, 4 words)
    12870, 13470, 14070, 14670,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    words = textContent.split(RegExp(r'\s+'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentWordIndex = -1; // Reset highlight
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()),
    );
  }

  void _playText() async {
    const audioPath = 'audio/Pagbasa14.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        currentWordIndex = 0; // Start with the first word
      });
      _syncTextWithAudio();

      // Reset highlight when audio finishes
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          currentWordIndex = -1; // Remove highlight when audio ends
          isPlaying = false;
        });
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _syncTextWithAudio() {
    for (int i = 0; i < wordTimings.length; i++) {
      Future.delayed(Duration(milliseconds: wordTimings[i]), () {
        if (mounted) {
          setState(() {
            currentWordIndex = i;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Pagbasa 14', style: GoogleFonts.lexendDeca()),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Si Kuya',
                style: GoogleFonts.lexendDeca(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: RichText(
                  text: TextSpan(
                    children: words.asMap().entries.map((entry) {
                      int index = entry.key;
                      String word = entry.value;

                      return TextSpan(
                        text: '$word ',
                        style: GoogleFonts.lexendDeca(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: index == currentWordIndex ? Colors.red : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              IconButton(
                icon: const Icon(Icons.play_circle_outline, color: Colors.green, size: 60),
                onPressed: _playText,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () => markLessonAsDone(context),
          child: const Text('Susunod'),
        ),
      ),
    );
  }
}
