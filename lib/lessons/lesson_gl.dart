// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_application_4/aralin_page.dart';

// class LessonGl extends StatefulWidget {
//   @override
//   _LessonGlState createState() => _LessonGlState();
// }

// class _LessonGlState extends State<LessonGl> with WidgetsBindingObserver {
//   final String title = 'Aralin GL'; // Title to track completion in SharedPreferences
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   int currentWordIndex = 0;

//   final String textContent = '''
// Ang guro ay nagtuturo ng leksyon.
// Gamit ang libro sa klase ng guro.
// Lahat ng estudyante ay nakikinig.
// ''' ;

//   List<String> words = [];
//   final int totalAudioDuration = 17000; // Audio duration in milliseconds (17 seconds)

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     words = textContent.split(RegExp(r'\s+')); // Split text into words
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
//       setState(() {
//         isPlaying = false;
//       });
//     }
//   }

//   Future<void> markLessonAsDone(BuildContext context) async {
//     await _audioPlayer.stop();
//     setState(() {
//       isPlaying = false;
//     });

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(title, true);

//     // Navigate to AralinPage
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => AralinPage()),
//     );
//   }

//   void _playText() async {
//     const audioPath = 'audio/LessonGl.mp3'; // Updated audio file path

//     try {
//       await _audioPlayer.stop();
//       await _audioPlayer.play(AssetSource(audioPath));
//       setState(() {
//         isPlaying = true;
//         currentWordIndex = 0; // Reset to first word
//       });
//       _syncTextWithAudio();
//     } catch (e) {
//       print('Error playing sound: $e');
//     }
//   }

//   void _syncTextWithAudio() {
//     int wordCount = words.length;
//     int durationPerWord = (totalAudioDuration / wordCount).round(); // Time per word in milliseconds

//     for (int i = 0; i < wordCount; i++) {
//       Future.delayed(Duration(milliseconds: i * durationPerWord), () {
//         if (mounted) {
//           setState(() {
//             currentWordIndex = i;
//           });
//         }
//       });
//     }

//     Future.delayed(Duration(milliseconds: totalAudioDuration), () {
//       if (mounted) {
//         setState(() {
//           currentWordIndex = wordCount - 1;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double fontSize = MediaQuery.of(context).size.width * 0.07;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: Text('Lesson GL', style: GoogleFonts.lexendDeca()),
//         backgroundColor: Colors.green,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             _audioPlayer.stop();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Sa Klase',
//                 style: GoogleFonts.lexendDeca(
//                   fontSize: 40,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(20.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: RichText(
//                   text: TextSpan(
//                     children: words.asMap().entries.map((entry) {
//                       int index = entry.key;
//                       String word = entry.value;

//                       return TextSpan(
//                         text: '$word ',
//                         style: GoogleFonts.comicNeue(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: index == currentWordIndex ? Colors.red : Colors.black,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               IconButton(
//                 icon: const Icon(Icons.play_circle_outline, color: Colors.green, size: 60),
//                 onPressed: _playText,
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             textStyle: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           onPressed: () => markLessonAsDone(context),
//           child: const Text('Susunod'),
//         ),
//       ),
//     );
//   }
// }
