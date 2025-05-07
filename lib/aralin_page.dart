import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aralin_detail_page.dart';
import 'aralin_3_page.dart';
import 'aralin_4_page.dart';
import 'aralin_5_page.dart'; // New import for Aralin 5 Ii
import 'aralin_6_page.dart';
import 'aralin_7_page.dart';
import 'aralin_8_page.dart';
import 'aralin_9_page.dart';
import 'aralin_10_page.dart';
import 'aralin_11_page.dart';
import 'aralin_12_page.dart';
import 'aralin_13_page.dart';
import 'aralin_14_page.dart';
import 'aralin_15_page.dart';
import 'aralin_16_page.dart';
import 'aralin_17_page.dart';
import 'aralin_18_page.dart';
import 'aralin_19_page.dart';
import 'aralin_20_page.dart';
import 'aralin_21_page.dart';
import 'aralin_22_page.dart';
import 'aralin_23_page.dart';
import 'aralin_24_page.dart';
import 'aralin_25_page.dart';
import 'aralin_26_page.dart'; // Import for Aralin 26
// import 'aralin_55_page.dart'; // Import for Aralin 55 Op

class AralinPage extends StatefulWidget {
  @override
  _AralinPageState createState() => _AralinPageState();
}

class _AralinPageState extends State<AralinPage> {
  final List<Map<String, String>> aralinList = [
    {'title': 'Aralin 1 Mm', 'audioPath': 'audio/Aralin 1 - Mm.mp3'},
    {'title': 'Aralin 2 Ss', 'audioPath': 'audio/Aralin 2 - Ss.mp3'},
    {'title': 'Aralin 3 Aa', 'audioPath': 'audio/Aralin 3 - Aa.mp3'},
    {'title': 'Aralin 4 Ang', 'audioPath': 'audio/Aralin 4 - ang.mp3'},
    {'title': 'Aralin 5 Ii', 'audioPath': 'audio/Aralin 5 - Ii.mp3'}, // New Aralin 5 Ii
    // {'title': 'Aralin 55 Op', 'audioPath': 'audio/Aralin 55 - Op.mp3'}, // New Aralin 55 Op
    {'title': 'Aralin 6 Oo', 'audioPath': 'audio/Aralin 6 - Oo (2).mp3'},
    {'title': 'Aralin 7 Ay', 'audioPath': 'audio/Aralin 7 - Ay.mp3'},
    {'title': 'Aralin 8 Ee', 'audioPath': 'audio/Aralin 8 - Ee.mp3'},
    {'title': 'Aralin 9 Uu', 'audioPath': 'audio/Aralin 9 - Uu.mp3'}, 
    {'title': 'Aralin 10 Bb', 'audioPath': 'audio/Aralin 10 - Bb.mp3'},
    {'title': 'Aralin 11 Tt', 'audioPath': 'audio/Aralin 11 - Tt.mp3'},
    {'title': 'Aralin 12 Kk', 'audioPath': 'audio/Aralin 12 - Kk.mp3'},
    {'title': 'Aralin 13 Ll', 'audioPath': 'audio/Aralin 13 - Ll.mp3'},
    {'title': 'Aralin 14 Yy', 'audioPath': 'audio/Aralin 14 Yy.mp3'},
    {'title': 'Aralin 15 Mga', 'audioPath': 'audio/Aralin 15 - Mga.mp3'},
    {'title': 'Aralin 16 Nn', 'audioPath': 'audio/Aralin 16 - Nn.mp3'},
    {'title': 'Aralin 17 Gg', 'audioPath': 'audio/Aralin 17 - Gg.mp3'},
    {'title': 'Aralin 18 Rr', 'audioPath': 'audio/Aralin 18 - Rr.mp3'},
    {'title': 'Aralin 19 Pp', 'audioPath': 'audio/Aralin 19 - Pp.mp3'},
    {'title': 'Aralin 20 Ng', 'audioPath': 'audio/Aralin 20 - Ng.mp3'},
    {'title': 'Aralin 21 Dd', 'audioPath': 'audio/Aralin 21 - Dd.mp3'},
    {'title': 'Aralin 22 Hh', 'audioPath': 'audio/Aralin 22 - Hh.mp3'},
    {'title': 'Aralin 23 Ww', 'audioPath': 'audio/Aralin 23 - Ww.mp3'},
    {'title': 'Aralin 24 -ng', 'audioPath': 'audio/Aralin 24 - Ng.mp3'},
    {'title': 'Aralin 25 ng-', 'audioPath': 'audio/Aralin 25 - Ng-.mp3'},
    // {'title': 'Aralin 26 Kambal Katinig', 'audioPath': 'audio/Aralin 26 - Kambal Katinig.mp3'},
  ];

  late Future<Set<String>> _completedLessons;

  @override
  void initState() {
    super.initState();
    _completedLessons = _getCompletedLessons();
  }

  Future<Set<String>> _getCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  void _navigateToLesson(BuildContext context, String title, String audioPath) {
    Widget nextPage;
    switch (title) {
      case 'Aralin 3 Aa':
        nextPage = AralinDetailPage3(title: title, audioPath: audioPath);
        break;
      case 'Aralin 4 Ang':
        nextPage = AralinDetailPage4(title: title, audioPath: audioPath);
        break;
      case 'Aralin 5 Ii': // New case for Aralin 5 Ii
        nextPage = AralinDetailPage5(title: title, audioPath: audioPath);
        break;
      case 'Aralin 6 Oo':
        nextPage = AralinDetailPage6(title: title, audioPath: audioPath);
        break;
      case 'Aralin 7 Ay':
        nextPage = AralinDetailPage7(title: title, audioPath: audioPath);
        break;
      case 'Aralin 8 Ee':
        nextPage = AralinDetailPage8(title: title, audioPath: audioPath);
        break;
      case 'Aralin 9 Uu':
        nextPage = AralinDetailPage9(title: title, audioPath: audioPath);
        break;
      case 'Aralin 10 Bb':
        nextPage = AralinDetailPage10(title: title, audioPath: audioPath);
        break;
      case 'Aralin 11 Tt':
        nextPage = AralinDetailPage11(title: title, audioPath: audioPath);
        break;
      case 'Aralin 12 Kk':
        nextPage = AralinDetailPage12(title: title, audioPath: audioPath);
        break;
      case 'Aralin 13 Ll':
        nextPage = AralinDetailPage13(title: title, audioPath: audioPath);
        break;
      case 'Aralin 14 Yy':
        nextPage = AralinDetailPage14(title: title, audioPath: audioPath);
        break;
      case 'Aralin 15 Mga':
        nextPage = AralinDetailPage15(title: title, audioPath: audioPath);
        break;
      case 'Aralin 16 Nn':
        nextPage = AralinDetailPage16(title: title, audioPath: audioPath);
        break;
      case 'Aralin 17 Gg':
        nextPage = AralinDetailPage17(title: title, audioPath: audioPath);
        break;
      case 'Aralin 18 Rr':
        nextPage = AralinDetailPage18(title: title, audioPath: audioPath);
        break;
      case 'Aralin 19 Pp':
        nextPage = AralinDetailPage19(title: title, audioPath: audioPath);
        break;
      case 'Aralin 20 Ng':
        nextPage = AralinDetailPage20(title: title, audioPath: audioPath);
        break;
      case 'Aralin 21 Dd':
        nextPage = AralinDetailPage21(title: title, audioPath: audioPath);
        break;
      case 'Aralin 22 Hh':
        nextPage = AralinDetailPage22(title: title, audioPath: audioPath);
        break;
      case 'Aralin 23 Ww':
        nextPage = AralinDetailPage23(title: title, audioPath: audioPath);
        break;
      case 'Aralin 24 -ng':
        nextPage = AralinDetailPage24(title: title, audioPath: audioPath);
        break;
      case 'Aralin 25 ng-':
        nextPage = AralinDetailPage25(title: title, audioPath: audioPath);
        break;
      case 'Aralin 26 Kambal Katinig':
        nextPage = AralinDetailPage26(title: title, audioPath: audioPath);
        break;
      default:
        nextPage = AralinDetailPage(title: title, audioPath: audioPath);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    ).then((_) {
      setState(() {
        _completedLessons = _getCompletedLessons();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mga Aralin'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: FutureBuilder<Set<String>>(
        future: _completedLessons,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final completedLessons = snapshot.data ?? {};

          return ListView.builder(
            itemCount: aralinList.length,
            itemBuilder: (context, index) {
              String title = aralinList[index]['title']!;
              String audioPath = aralinList[index]['audioPath']!;
              bool isCompleted = completedLessons.contains(title);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _navigateToLesson(context, title, audioPath),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      if (isCompleted)
                        const Icon(Icons.check, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
