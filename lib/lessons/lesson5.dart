import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'lesson5_5.dart'; // Updated to import the appropriate next lesson file

class Lesson5 extends StatefulWidget {
  @override
  _Lesson5State createState() => _Lesson5State();
}

class _Lesson5State extends State<Lesson5> with WidgetsBindingObserver {
  final String title = 'Aralin 5 Ii'; // Updated the title to "Ii"
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
      MaterialPageRoute(builder: (context) => Lesson5_5()), // Navigate to the next lesson
    );
  }

  void _playSound(String word) async {
    String audioPath;
    switch (word.toLowerCase()) {
      case 'mi':
        audioPath = 'audio/Aralin 5 - mi.mp3';
        break;
      case 'si':
        audioPath = 'audio/Aralin 5 - si.mp3';
        break;
      case 'isa':
        audioPath = 'audio/Aralin 5 - isa.mp3';
        break;
      case 'ami':
        audioPath = 'audio/Aralin 5 - ami.mp3';
        break;
      case 'misa':
        audioPath = 'audio/Aralin 5 - misa.mp3';
        break;
      case 'mais':
        audioPath = 'audio/Aralin 5 - mais.mp3';
        break;
      case 'sisi':
        audioPath = 'audio/Aralin 5 - sisi.mp3';
        break;
      case 'iisa':
        audioPath = 'audio/Aralin 5 - iisa.mp3';
        break;
      case 'sa misa':
        audioPath = 'audio/Aralin 5 - sa misa.mp3';
        break;
      case 'ang mais':
        audioPath = 'audio/Aralin 5 - ang mais.mp3';
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
      'mi',
      'si',
      'isa',
      'ami',
      'misa',
      'mais',
      'sisi',
      'iisa',
      'sa misa',
      'ang mais',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Aralin 5', style: GoogleFonts.comicNeue()),
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
                          style: GoogleFonts.lexendDeca(
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
          onPressed: () => markLessonAsDone(context),
        ),
      ),
    );
  }
}
