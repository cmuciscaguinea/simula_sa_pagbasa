import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart'; // Import AralinPage

class AralinDetailPage26 extends StatefulWidget {
  final String title;
  final String audioPath;

  AralinDetailPage26({super.key, required this.title, required this.audioPath});

  @override
  _AralinDetailPage26State createState() => _AralinDetailPage26State();
}

class _AralinDetailPage26State extends State<AralinDetailPage26> with WidgetsBindingObserver {
  final String title = 'Aralin 26 Kambal Katinig';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

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
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()), // Navigate to AralinPage
    );
  }

  void _playSound(String word) async {
    String audioPath;
    switch (word.toLowerCase()) {
      case 'braso':
        audioPath = 'audio/Aralin26_braso.mp3';
        break;
      case 'prinsesa':
        audioPath = 'audio/Aralin26_prinsesa.mp3';
        break;
      case 'graba':
        audioPath = 'audio/Aralin26_graba.mp3';
        break;
      case 'prito':
        audioPath = 'audio/Aralin26_prito.mp3';
        break;
      case 'graso':
        audioPath = 'audio/Aralin26_graso.mp3';
        break;
      case 'prutas':
        audioPath = 'audio/Aralin26_prutas.mp3';
        break;
      case 'gripo':
        audioPath = 'audio/Aralin26_gripo.mp3';
        break;
      case 'krus':
        audioPath = 'audio/Aralin26_krus.mp3';
        break;
      case 'globo':
        audioPath = 'audio/Aralin26_globo.mp3';
        break;
      case 'klima':
        audioPath = 'audio/Aralin26_klima.mp3';
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
      'braso',
      'prinsesa',
      'graba',
      'prito',
      'graso',
      'prutas',
      'gripo',
      'krus',
      'globo',
      'klima',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson 26', style: GoogleFonts.lexendDeca()),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
                        child: Text(
                          word,
                          style: GoogleFonts.comicNeue(
                            fontSize: fontSize.clamp(20, 50),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
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
        child: IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.green, size: 40),
          onPressed: () => markLessonAsDone(context), // Modified to navigate to AralinPage
        ),
      ),
    );
  }
}
