// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../lessons/lesson25.dart'; // Adjusted to import Lesson25

// class AralinDetailPage25 extends StatefulWidget {
//   final String title;
//   final String audioPath;

//   AralinDetailPage25({super.key, required this.title, required this.audioPath});

//   @override
//   _AralinDetailPage25State createState() => _AralinDetailPage25State();
// }

// class _AralinDetailPage25State extends State<AralinDetailPage25> with WidgetsBindingObserver {
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       _audioPlayer.stop();
//     }
//   }

//   void _playSound() async {
//     try {
//       await _audioPlayer.stop();
//       await _audioPlayer.play(AssetSource(widget.audioPath));
//     } catch (e) {
//       print('Error playing sound: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String letter = 'ng-'; // Updated to ng-

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: GoogleFonts.comicNeue()),
//         backgroundColor: Colors.green,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             _audioPlayer.stop();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               letter,
//               style: GoogleFonts.lexendDeca(
//                 fontSize: 200,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 80),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildIconButton(Icons.play_arrow, _playSound),
//                 const SizedBox(width: 20),
//                 _buildIconButton(
//                   Icons.arrow_forward,
//                   () {
//                     _audioPlayer.stop();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Lesson25()), // Updated to Lesson25
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
//     return Container(
//       width: 70,
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.green,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.green.withOpacity(0.5),
//             spreadRadius: 10,
//             blurRadius: 15,
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white, size: 30),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_4/aralin_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AralinDetailPage25 extends StatefulWidget {
  final String title;
  final String audioPath;

  AralinDetailPage25({super.key, required this.title, required this.audioPath});

  @override
  _AralinDetailPage25State createState() => _AralinDetailPage25State();
}

class _AralinDetailPage25State extends State<AralinDetailPage25> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    }
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(widget.audioPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.comicNeue()),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ng-',
              style: GoogleFonts.lexendDeca(fontSize: 200, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(Icons.play_arrow, _playSound),
                const SizedBox(width: 20),
                _buildIconButton(Icons.arrow_forward, () {
                  _audioPlayer.stop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Lesson25()));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), spreadRadius: 10, blurRadius: 15)],
      ),
      child: IconButton(icon: Icon(icon, color: Colors.white, size: 30), onPressed: onPressed),
    );
  }
}

class Lesson25 extends StatefulWidget {
  @override
  _Lesson25State createState() => _Lesson25State();
}

class _Lesson25State extends State<Lesson25> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  final List<String> wordList = ['nga nge ngi ngo ngu', 'nganga', 'nguso', 'banga', 'langka'];

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
      setState(() => isPlaying = false);
    }
  }

  Future<void> markLessonAsDone(BuildContext context) async {
    await _audioPlayer.stop();
    setState(() => isPlaying = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Aralin 25 ng-', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Lesson25_25()));
  }

  void _playSound(String word) async {
    String audioPath = 'audio/Aralin 25 - $word.mp3';
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() => isPlaying = true);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aralin 25', style: GoogleFonts.comicNeue()),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: wordList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(wordList[index], style: GoogleFonts.lexendDeca(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  IconButton(icon: Icon(Icons.play_circle_outline, color: Colors.green, size: 40), onPressed: () => _playSound(wordList[index])),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(icon: Icon(Icons.arrow_forward, color: Colors.green, size: 40), onPressed: () => markLessonAsDone(context)),
      ),
    );
  }
}

class Lesson25_25 extends StatefulWidget {
  @override
  _Lesson25_25State createState() => _Lesson25_25State();
}

class _Lesson25_25State extends State<Lesson25_25> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentWordIndex = -1;
  final String textContent = 'Masakit ang ngipin ni Nilo.\nPumunta siya sa dentista.\n"Nganga," sabi ng dentista.\nTiningnan ang ngipin niya.\nInalis ang isa. Bungi na siya.';
  final List<int> wordTimings = [0, 770, 1540, 2310, 3080, 3850, 4957, 6064, 7172, 8280, 9567, 10854, 12142, 13429, 14517, 15604, 16692, 17779, 18749, 19719, 20689, 21659, 22629];
  List<String> words = [];

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
      currentWordIndex = -1;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Aralin 25.25', true);
    // Navigate back to the list of all Aralin
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>AralinPage())); // Replace `AralinPage` with your actual page
  }

  void _playText() async {
    const audioPath = 'audio/Pagbasa25.mp3';
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        currentWordIndex = 0;
      });
      _syncTextWithAudio();
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() {
          isPlaying = false;
          currentWordIndex = -1;
        });
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _syncTextWithAudio() {
    for (int i = 0; i < wordTimings.length; i++) {
      Future.delayed(Duration(milliseconds: wordTimings[i]), () {
        if (mounted && isPlaying) setState(() => currentWordIndex = i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Pagbasa 25', style: GoogleFonts.lexendDeca()),
        backgroundColor: Colors.green,
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
                'Ang Bisita sa Dentista',
                style: GoogleFonts.lexendDeca(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center, // Centered text
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                ),
                child: RichText(
                  text: TextSpan(
                    children: words.asMap().entries.map((entry) {
                      return TextSpan(
                        text: '${entry.value} ',
                        style: GoogleFonts.lexendDeca(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: entry.key == currentWordIndex ? Colors.red : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.center, // Centered text
                ),
              ),
              const SizedBox(height: 30),
              IconButton(icon: const Icon(Icons.play_circle_outline, color: Colors.green, size: 60), onPressed: _playText),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => markLessonAsDone(context),
          child: const Text('Susunod'),
        ),
      ),
    );
  }
}
