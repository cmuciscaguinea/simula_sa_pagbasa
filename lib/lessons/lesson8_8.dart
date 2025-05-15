import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simula_sa_pagbasa/aralin_page.dart';

class Lesson8_8 extends StatefulWidget {
  @override
  _Lesson8_8State createState() => _Lesson8_8State();
}

class _Lesson8_8State extends State<Lesson8_8> with WidgetsBindingObserver {
  final String title = 'Aralin 8.8';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentWordIndex = -1;
  Duration _currentPosition = Duration.zero;
  Timer? _syncTimer;

  final String textContent = '''
Mama, mama.
May mais sa mesa.
Ang mais ay isa.
May mais si Emi sa mesa.
''';

  List<String> words = [];

  final List<int> wordTimings = [
    0, 1350,
    2700, 3488, 4276, 5064,
    5852, 6657, 7462, 8267,
    9060, 9870, 10680, 11490, 12300, 13110,
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
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isPaused = false;
          _currentWordIndex = -1; // ✅ Clear red highlight
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
    final pos = await _audioPlayer.getCurrentPosition();
    _currentPosition = pos ?? Duration.zero;
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
    const audioPath = 'audio/Pagbasa8.mp3';
    await _audioPlayer.play(AssetSource(audioPath));
    _isPlaying = true;
    _isPaused = false;
    _currentPosition = Duration.zero;
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

    // ✅ Fallback to force-clear red highlight
    Future.delayed(Duration(milliseconds: wordTimings.last + 500), () {
      if (mounted && _isPlaying) {
        setState(() {
          _currentWordIndex = -1;
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
        title: Text('Pagbasa 8', style: GoogleFonts.lexendDeca()),
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
                'Mais sa Mesa',
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
