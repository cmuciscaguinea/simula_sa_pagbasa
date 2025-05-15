import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson21_21 extends StatefulWidget {
  @override
  _Lesson21_21State createState() => _Lesson21_21State();
}

class _Lesson21_21State extends State<Lesson21_21> with WidgetsBindingObserver {
  final String title = 'Aralin 21.21';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentWordIndex = -1;
  Timer? _syncTimer;

  final String textContent = '''
Sa dulo ay may daan.
Daan ito papunta sa dagat.
May dampa malapit sa dagat.
Pumunta si Dina sa dampa.
Dala ni Dina ang alaga na daga.
''';

  List<String> words = [];

  final List<int> wordTimings = [
    0, 800, 1600, 2400, 3220,
    4020, 4820, 5620, 6420, 7220, 8110,
    8910, 9710, 10510, 11310, 12390,
    13190, 13990, 14790, 15590, 16390, 17220,
    18020, 18820, 19620, 20420, 21220, 22020, 22820, 23620, 24420, 25220, 26020, 26820, 27620
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isPaused = false;
          _currentWordIndex = -1;
        });
      }
    });
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
    const audioPath = 'audio/Pagbasa21.mp3';
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
        title: Text('Pagbasa 21', style: GoogleFonts.lexendDeca()),
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
                'Si Dina',
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