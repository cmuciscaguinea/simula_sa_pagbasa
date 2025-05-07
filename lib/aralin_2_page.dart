import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
// import 'lessons/lesson2.dart'; // Updated import to lesson2.dart

class AralinDetailPage extends StatelessWidget {
  final String title;
  final String audioPath;

  AralinDetailPage({super.key, required this.title, required this.audioPath});

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play the sound for the specific lesson
  void _playSound() async {
    try {
      print('Playing sound: $audioPath'); // Debugging to check file path
      await _audioPlayer.play(AssetSource(audioPath)); // Play the sound from the correct asset path
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split the title into 'ARALIN 1' and the actual letters (e.g., 'Mm')
    List<String> splitTitle = title.split(' ');
    String letter = 'Ss'; // Set to 'Ss' directly

    return Scaffold(
      appBar: AppBar(
        title: Text(splitTitle[0] + ' ' + splitTitle[1], style: GoogleFonts.lexendDeca()), // Display 'ARALIN 1'
        backgroundColor: Colors.green,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Displaying 'Ss' in the center with a larger font size for kids' reading apps
            Text(
              letter,
              textAlign: TextAlign.center, // Center align the letter
              style: GoogleFonts.lexendDeca(
                fontSize: 200, // Larger size for readability in a children's reading app
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change the color to black
              ),
            ),
            const SizedBox(height: 80),
            // Row for Play and Right buttons (Removed Left button)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play button
                Container(
                  width: 70, // Adjust size for the play button
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
                    onPressed: _playSound, // Play sound when pressed
                  ),
                ),
                const SizedBox(width: 20), // Space between buttons
                // Right button
                Container(
                  width: 60, // Adjust size for the right button
                  height: 60,
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
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                    onPressed: () {
                      // // Navigate to lesson2.dart when the forward button is pressed
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Lesson2(), // Navigate to Lesson2 widget from lesson2.dart
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
