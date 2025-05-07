import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MahirapPage extends StatefulWidget {
  const MahirapPage({super.key});

  @override
  _MahirapPageState createState() => _MahirapPageState();
}

class _MahirapPageState extends State<MahirapPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> _imagesWithAnswers = [
    {'answer': 'Ng', 'audio': 'audio/ng1.mp3'},
    {'answer': 'Ng nanay', 'audio': 'audio/Aralin 20 - ng nanay.mp3'},
    {'answer': 'Ng aso', 'audio': 'audio/Aralin 20 - ng aso.mp3'},
    {'answer': 'Ng maya', 'audio': 'audio/Aralin 20 - ng maya.mp3'},
    {'answer': 'Ulo nang usa', 'audio': 'audio/Aralin 20 - ulo ng osa.mp3'},
  ];

  List<Map<String, String>> _remainingItems = [];
  List<String> _choices = [];
  String _correctAnswer = '';
  String _selectedAudio = '';
  String _feedbackMessage = '';
  bool _isGameOver = false;
  bool _hasAnswered = false;
  Map<String, Color> _buttonColors = {};
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _remainingItems = List.from(_imagesWithAnswers)..shuffle();
    _isGameOver = false;
    _score = 0;
    _loadNextQuestion();
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void _loadNextQuestion() async {
    // Stop any currently playing audio before loading next question
    await _stopAudio();
    
    if (_remainingItems.isEmpty) {
      setState(() {
        _isGameOver = true;
      });
      return;
    }

    final selectedItem = _remainingItems.removeAt(0);

    setState(() {
      _correctAnswer = selectedItem['answer']!;
      _selectedAudio = selectedItem['audio']!;
      _choices = _generateChoices(_correctAnswer);
      _initializeButtonColors();
      _feedbackMessage = '';
      _hasAnswered = false;
    });
  }

  List<String> _generateChoices(String correctAnswer) {
    Map<String, List<String>> choicesMap = {
      'Ng': ['Ng', 'Baba', 'Taba', 'Daba'],
      'Ng nanay': ['Hado', 'Ng nanay', 'Luto', 'Suko'],
      'Ng aso': ['Keto', 'Buto', 'Ng aso', 'Tito'],
      'Ng maya': ['Tita', 'Kita', 'Kika', 'Ng maya'],
      'Ulo nang usa': ['Ulo nang usa', 'Kababa', 'Kawewe', 'Lubas'],
    };

    List<String> choices = choicesMap[correctAnswer]!;
    choices.shuffle();
    return choices;
  }

  void _initializeButtonColors() {
    _buttonColors = {};
    for (var choice in _choices) {
      _buttonColors[choice] = Colors.orangeAccent.shade100;
    }
  }

  void _playSound() async {
    try {
      await _stopAudio(); // Stop any currently playing audio first
      await _audioPlayer.play(AssetSource(_selectedAudio));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _checkAnswer(String answer) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      if (answer == _correctAnswer) {
        _feedbackMessage = 'Tama Ka!';
        _buttonColors[answer] = Colors.green.shade500;
        _score++;
      } else {
        _feedbackMessage = 'Mali Ka!';
        _buttonColors[answer] = Colors.red.shade400;
      }
    });
  }

  void _bumalikSaMenu() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahirap Game'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _bumalikSaMenu,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.purple.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isGameOver) ...[
                  const Text(
                    'Anong salita ang tunog na ito?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill, color: Colors.orangeAccent),
                    iconSize: 60,
                    onPressed: _playSound,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: _choices.map((choice) => _buildChoiceButton(choice)).toList(),
                    ),
                  ),
                  if (_feedbackMessage.isNotEmpty)
                    Text(
                      _feedbackMessage,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _feedbackMessage == 'Tama Ka!' ? Colors.green : Colors.redAccent,
                      ),
                    ),
                ] else ...[
                  Text(
                    'Tapos Na!\nTamang Sagot: $_score / ${_imagesWithAnswers.length}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _bumalikSaMenu,
                    child: const Text(
                      'Bumalik sa Menu',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isGameOver ? _resetGame : _loadNextQuestion,
                  child: Text(
                    _isGameOver ? 'Ulitin' : 'Susunod',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(String choice) {
    return SizedBox(
      width: 140,
      height: 60, // Same height for all buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColors[choice],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => _checkAnswer(choice),
        child: Text(
          choice[0].toUpperCase() + choice.substring(1).toLowerCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: choice == 'Ulo nang usa' ? 14 : 17, // Smaller font for longer text
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}