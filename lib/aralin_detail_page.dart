import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AralinDetailPage extends StatefulWidget {
  final String title;
  final String audioPath;

  AralinDetailPage({super.key, required this.title, required this.audioPath});

  @override
  _AralinDetailPageState createState() => _AralinDetailPageState();
}

class _AralinDetailPageState extends State<AralinDetailPage> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player when widget is removed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Stop audio if the app is closed or goes to the background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing audio
      await _audioPlayer.play(AssetSource(widget.audioPath));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> _markLessonAsDone() async {
    await _audioPlayer.stop(); // Stop audio when marking as done
    setState(() {
      isPlaying = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.title, true); // Save lesson as completed
  }

  @override
  Widget build(BuildContext context) {
    List<String> splitTitle = widget.title.split(' ');
    String letter = splitTitle.sublist(2).join(' ');

    return Scaffold(
      appBar: AppBar(
        title: Text('${splitTitle[0]} ${splitTitle[1]}', style: GoogleFonts.comicNeue()),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop(); // Stop audio on back navigation
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(flex: 2), // Add space at the top
          Text(
            letter,
            textAlign: TextAlign.center,
            style: GoogleFonts.lexendDeca(
              fontSize: 180, // Reduce font size slightly to fit better
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40), // Adjust space between text and button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                  onPressed: _playSound,
                ),
              ),
            ],
          ),
          Spacer(flex: 3), // Add more space after button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: GoogleFonts.lexendDeca(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _markLessonAsDone(); // Mark lesson as done and stop audio
                  Navigator.pop(context); // Return to previous screen
                },
                child: const Text('Susunod'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
