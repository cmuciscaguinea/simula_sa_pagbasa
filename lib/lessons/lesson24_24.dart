import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_4/aralin_page.dart';

class Lesson24_24 extends StatefulWidget {
  @override
  _Lesson24_24State createState() => _Lesson24_24State();
}

class _Lesson24_24State extends State<Lesson24_24> with WidgetsBindingObserver {
  final String title = 'Aralin 24.24';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1;

  final String textContent = '''
Si Bibong ay nasa bangka.
Siya ay may saging.
Kinain ni Bibong ang isang saging.
Binigyan niya si Aling Maring.
Tuwang-tuwa siya sa binigay na saging.
''';

  List<String> words = [];

  final List<int> wordTimings = [
    0, 930, 1860, 2790, 3720, // Si Bibong ay nasa bangka. (3.72 sec)
    4660, 5600, 6540, 7400, // Siya ay may saging. (3.89 sec)
    8280, 9160, 10040, 10920, 11800, 12680, 13560, // Kinain ni Bibong ang isang saging. (5.63 sec)
    14600, 15640, 16680, 17720, 18760, 19800, // Binigyan niya si Aling Maring. (4.55 sec)
    20900, 22000, 23100, 24200, 25300, 26400, 27500 // Tuwang-tuwa siya sa binigay na saging. (5.30 sec)
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
    const audioPath = 'audio/Pagbasa24.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        currentWordIndex = 0;
      });
      _syncTextWithAudio();

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            isPlaying = false;
            currentWordIndex = -1;
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
        if (mounted && isPlaying) {
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
        title: Text('Pagbasa 24', style: GoogleFonts.lexendDeca()),
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
                'Ang Saging ni Bibong',
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