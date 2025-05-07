// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'lesson_gl.dart'; // Updated to import the next lesson file

// class Lesson5 extends StatefulWidget {
//   @override
//   _Lesson5State createState() => _Lesson5State();
// }

// class _Lesson5State extends State<Lesson5> with WidgetsBindingObserver {
//   final String title = 'Aralin -5 Gl'; // Updated the title to "Gl"
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;

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

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LessonGl()), // Navigate to the next lesson
//     );
//   }

//   void _playSound(String word) async {
//     String audioPath;
//     switch (word.toLowerCase()) {
//       case 'gl':
//         audioPath = 'audio/Lesson -5 - gl.mp3';
//         break;
//       case 'globe':
//         audioPath = 'audio/Lesson -5 - globe.mp3';
//         break;
//       case 'glass':
//         audioPath = 'audio/Lesson -5 - glass.mp3';
//         break;
//       case 'glow':
//         audioPath = 'audio/Lesson -5 - glow.mp3';
//         break;
//       case 'glide':
//         audioPath = 'audio/Lesson -5 - glide.mp3';
//         break;
//       default:
//         return;
//     }

//     print("Attempting to play: $audioPath");

//     try {
//       await _audioPlayer.stop();
//       await _audioPlayer.play(AssetSource(audioPath));
//       setState(() {
//         isPlaying = true;
//       });
//     } catch (e) {
//       print('Error playing sound: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<String> wordList = [
//       'gl',
//       'globe',
//       'glass',
//       'glow',
//       'glide',
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lesson -5', style: GoogleFonts.comicNeue()),
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
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double fontSize = constraints.maxWidth * 0.08;
//           return ListView.builder(
//             itemCount: wordList.length,
//             itemBuilder: (context, index) {
//               String word = wordList[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           word,
//                           style: GoogleFonts.comicNeue(
//                             fontSize: fontSize.clamp(20, 50),
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.play_circle_outline, color: Colors.green, size: 40),
//                         onPressed: () => _playSound(word),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: IconButton(
//           icon: Icon(Icons.arrow_forward, color: Colors.green, size: 40),
//           onPressed: () => markLessonAsDone(context),
//         ),
//       ),
//     );
//   }
// }
