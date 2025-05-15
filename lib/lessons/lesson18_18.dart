import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson18_18 extends StatefulWidget {
  @override
  _Lesson18_18State createState() => _Lesson18_18State();
}

class _Lesson18_18State extends State<Lesson18_18> with WidgetsBindingObserver {
  final String title = 'Aralin 18.18';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentWordIndex = -1;
  Timer? _syncTimer;

  final String textContent = '''
Si Rosa ay guro.
Guro siya nina Remi.
Nag-aaral sila sa umaga.
Masaya sina Remi sa guro nila.
''';

  List<String> words = [];

  final List<int> wordTimings = [
    0, 670, 1340, 2010,
    2680, 3525, 4370, 5215,
    6060, 6848, 7636, 8424, 9212,
    11536, 12304, 13072, 13840, 14608, 15376,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    words = textContent.split(RegExp(r'\s+'));
    _audioPlayer.onPlayerComplete.listen(_handleAudioComplete);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _isPaused = false;
        _currentWordIndex = -1;
      });
    }
  }

  void _handleAudioComplete(void _) {
    _syncTimer?.cancel();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _isPaused = false;
        _currentWordIndex = -1;
      });
    }
  }

  Future<void> _stopPlayback() async {
    _syncTimer?.cancel();
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
      _currentWordIndex = -1;
    });
  }

  Future<void> _pausePlayback() async {
    await _audioPlayer.pause();
    _isPaused = true;
    _syncTimer?.cancel();
    setState(() {});
  }

  Future<void> _resumeOrPlay() async {
    if (_isPaused) {
      await _audioPlayer.resume();
      _isPaused = false;
      _isPlaying = true;
      _startTextSync();
      setState(() {});
    } else {
      await _playText();
    }
  }

  Future<void> _playText() async {
    await _stopPlayback();
    const audioPath = 'audio/Pagbasa18.mp3';
    await _audioPlayer.play(AssetSource(audioPath));
    _isPlaying = true;
    _isPaused = false;
    _startTextSync();
    setState(() {});
  }

  void _startTextSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      final pos = await _audioPlayer.getCurrentPosition();
      final ms = pos?.inMilliseconds ?? 0;

      int wordIndex = -1;
      for (int i = 0; i < wordTimings.length; i++) {
        if (ms >= wordTimings[i]) {
          wordIndex = i;
        } else {
          break;
        }
      }

      if (mounted) {
        setState(() {
          _currentWordIndex = wordIndex;
        });
      }
    });
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _stopPlayback();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AralinPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Pagbasa 18', style: GoogleFonts.lexendDeca()),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _stopPlayback();
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
                'Si Rosa R. Romero',
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
                          color: index == _currentWordIndex ? Colors.red : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? (_isPaused ? Icons.play_circle_outline : Icons.pause_circle_outline)
                      : Icons.play_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                onPressed: () {
                  if (_isPlaying && !_isPaused) {
                    _pausePlayback();
                  } else {
                    _resumeOrPlay();
                  }
                },
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
