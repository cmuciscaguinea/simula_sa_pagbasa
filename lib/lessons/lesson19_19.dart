import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson19_19 extends StatefulWidget {
  @override
  _Lesson19_19State createState() => _Lesson19_19State();
}

class _Lesson19_19State extends State<Lesson19_19> with WidgetsBindingObserver {
  final String title = 'Aralin 19.19'; // Title to track completion in SharedPreferences
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1; // Initialize to -1 to hide highlight initially

  final String textContent = '''
Si Pepito ay may pusa.
Apat ang mga pusa niya.
Paborito ni Pepito ang pusa na puti.
Pinakakain niya ito ng tinapay.
''';

  List<String> words = [];

  // New word timings (in milliseconds)
  final List<int> wordTimings = [
    0, 888, 1776, 2664, 3552, 4440, // Si Pepito ay may pusa. (4.44 sec)
    5288, 6136, 6984, 7832, 8680, // Apat ang mga pusa niya. (4.24 sec)
    9556, 10714, 11872, 13030, 14188, 15346, // Paborito ni Pepito ang pusa na puti. (6.95 sec)
    16204, 17032, 17860, 18688, 19516, 20344, // Pinakakain niya ito ng tinapay. (4.97 sec)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    words = textContent.split(RegExp(r'\s+')); // Split text into words
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
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentWordIndex = -1; // Reset highlight
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);

    // Navigate to AralinPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()),
    );
  }

  void _playText() async {
    const audioPath = 'audio/Pagbasa19.mp3'; // Updated audio file path

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        currentWordIndex = 0; // Start highlighting from the first word
      });
      _syncTextWithAudio();

      // Reset state when audio finishes
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            isPlaying = false;
            currentWordIndex = -1; // Hide highlight
          });
        }
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
        title: Text('Pagbasa 19', style: GoogleFonts.lexendDeca()),
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
                'Pusa ni Pepito',
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