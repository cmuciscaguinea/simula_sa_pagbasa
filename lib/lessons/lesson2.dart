import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'lesson2_2.dart'; // Updated to import the new file

class Lesson4 extends StatefulWidget {
  @override
  _Lesson4State createState() => _Lesson4State();
}

class _Lesson4State extends State<Lesson4> with WidgetsBindingObserver {
  final String title = 'Aralin 4 Ang';
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
      MaterialPageRoute(builder: (context) => Lesson2_2Page()),
    );
  }

  void _playSound(String word) async {
    String audioPath;
    switch (word.toLowerCase()) {
      case 'ang ama':
        audioPath = 'audio/Aralin 4 - ang_ama.mp3';
        break;
      case 'ang masa':
        audioPath = 'audio/Aralin 4 - ang_masa.mp3';
        break;
      case 'ang sasama':
        audioPath = 'audio/Aralin 4 - ang_sasama.mp3';
        break;
      case 'ang mama':
        audioPath = 'audio/Aralin 4 - ang_mama.mp3';
        break;
      case 'ang asa':
        audioPath = 'audio/Aralin 4 - ang_asa.mp3'; 
        break;
      // case 'ang sama':
      //   audioPath = 'audio/Aralin 4 - ang_sama.mp3';
        // break;
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
      'ang ama',
      'ang masa',
      'ang sasama',
      'ang mama',
      'ang asa',
      // 'ang sama',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Aralin 4', style: GoogleFonts.lexendDeca()),
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
