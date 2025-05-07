import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_4/aralin_page.dart';

class Lesson13_13 extends StatefulWidget {
  @override
  _Lesson13_13State createState() => _Lesson13_13State();
}

class _Lesson13_13State extends State<Lesson13_13> with WidgetsBindingObserver {
  final String title = 'Aralin 13.13';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1; // Initialize to -1 to hide highlight initially

  final String textContent = '''
Si Lili ay may laso.
Ang laso ay may lila.
Ang laso ay luma.
Baka kay lola ang laso ni Lili.
''';

  List<String> words = [];

  // Updated custom timestamps for each word in milliseconds
  final List<int> wordTimings = [
    // "Si Lili ay may laso." (4.07 seconds, 5 words)
    0, 814, 1628, 2442, 3256,

    // "Ang laso ay may lila." (3.65 seconds, 4 words)
    4070, 4983, 5896, 6809,

    // "Ang laso ay luma." (3.30 seconds, 4 words)
    7720, 8545, 9370, 10195,

    // "Baka kay lola ang laso ni Lili." (5.50 seconds, 8 words)
    11125, 11813, 12499, 13187, 13875, 14563, 15251, 15939,
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
    const audioPath = 'audio/Pagbasa13.mp3';

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
        title: Text('Pagbasa 13', style: GoogleFonts.lexendDeca()),
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
                'Si Lili',
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
