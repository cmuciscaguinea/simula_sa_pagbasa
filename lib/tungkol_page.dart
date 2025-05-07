import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TungkolPage extends StatelessWidget {
  final List<String> memberNames = [
    'Edison R. Mecisamente (Developer)',
    'Mark Harold L. Palmares (Researcher)',
  ];

  final String aboutApp =
      'Marungko Approach Simula sa Pagbasa is an innovative mobile learning tool designed to enhance reading skills among grades 1–3 students using the Marungko Approach. '
      'This app integrates phonics, alphabet recognition, and vocabulary development into an engaging and interactive platform that encourages young learners to develop foundational literacy skills.\n\n'
      'Key features include guided lessons, audio pronunciation, and game-based activities, making it both educational and enjoyable.';

final String collaborationDetails =
    'Our excellent professors, Mr. Kent Levi Bonifacio, Mrs. Gladys S. Ayunar, Mrs. Nathalie Joy G. Casildo and Mrs. Jinky G. Marcelo, led this collaborative endeavor. Their knowledge and input were crucial throughout the project\'s development.\n\n'
    'We especially thank Filipino teacher Mrs. Florentina O. Naduma, for her expert voice and sound recordings that guaranteed proper pronunciation and improved the educational value of the app.\n\n'
    'We also extend our gratitude to Mr. Weenkie Jhon A. Marcelo, School Principal of Musuan Integrated School, for his continued support and encouragement throughout the development of this app.';


  final String counterparts =
      'Marungko Approach Simula sa Pagbasa builds on the legacy of other groundbreaking projects under the CISC KIDS initiative:\n\n'
      '1. CISC KIDS: Reading Comprehension - Focuses on enhancing comprehension skills through technology.\n'
      '2. CISC KIDS: Beginning Reading English Fuller Approach - Integrates phonics, vocabulary building, and alphabet mastery.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tungkol',
          style: GoogleFonts.lexendDeca(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // App Title
            Center(
              child: Text(
                'Marungko Approach',
                style: GoogleFonts.lexendDeca(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
            const Divider(height: 40, thickness: 1),

            _buildSectionTitle('About the App'),
            const SizedBox(height: 10),
            _buildSectionContent(aboutApp),
            const Divider(height: 40, thickness: 1),

            _buildSectionTitle('Collaboration'),
            const SizedBox(height: 10),
            _buildSectionContent(collaborationDetails),
            const Divider(height: 40, thickness: 1),

            _buildSectionTitle('Development Team'),
            const SizedBox(height: 10),
            ...memberNames.map((name) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '• $name',
                style: GoogleFonts.lexendDeca(
                  fontSize: 16,
                ),
              ),
            )),
            const Divider(height: 40, thickness: 1),

            _buildSectionTitle('Related Projects'),
            const SizedBox(height: 10),
            _buildSectionContent(counterparts),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lexendDeca(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green[700],
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: GoogleFonts.lexendDeca(
        fontSize: 16,
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }
}