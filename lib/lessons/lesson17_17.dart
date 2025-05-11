import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson17_17 extends StatefulWidget {
  @override
  _Lesson17_17State createState() => _Lesson17_17State();
}

class _Lesson17_17State extends State<Lesson17_17> with WidgetsBindingObserver {
  final String title = 'Aralin 17.17';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1; // Initialize to -1 to hide highlight initially

  final String textContent = '''
Si Gibo ay may gansa.
Ang gansa ay si Gali.
Sa ilog naliligo si Gali.
Si Gali ay malusog.
Kasama si Gibo at Gali.
''';

  List<String> words = [];

  // Updated custom timestamps for each word in milliseconds
  final List<int> wordTimings = [
    // "Si Gibo ay may gansa." (3.58 seconds, 5 words, ~716 ms per word)
    0, 716, 1432, 2148, 2864,

    // "Ang gansa ay si Gali." (3.83 seconds, 5 words, ~766 ms per word)
    3580, 4346, 5112, 5878, 6644,

    // "Sa ilog naliligo si Gali." (4.09 seconds, 5 words, ~818 ms per word)
    7410, 8228, 9046, 9864, 10682,

    // "Si Gali ay malusog." (3.80 seconds, 4 words, ~950 ms per word)
    11490, 12440, 13390, 14340,

    // "Kasama si Gibo at Gali." (3.76 seconds, 5 words, ~752 ms per word)
    15290, 16042, 16794, 17546, 18298,
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
      currentWordIndex = -1;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()),
    );
  }

  void _playText() async {
    const audioPath = 'audio/Pagbasa17.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        currentWordIndex = 0;
      });
      _syncTextWithAudio();

      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          currentWordIndex = -1;
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
        title: Text('Pagbasa 17', style: GoogleFonts.lexendDeca()),
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
                'Ang Gansa si Gibo',
                style: GoogleFonts.lexendDeca(
                  fontSize: 35,
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
            textStyle: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold),
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
