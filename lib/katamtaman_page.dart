import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class KatamtamanPage extends StatefulWidget {
  const KatamtamanPage({super.key});

  @override
  _KatamtamanPageState createState() => _KatamtamanPageState();
}

class _KatamtamanPageState extends State<KatamtamanPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> _itemsWithAnswers = [
    {'answer': 'Ii', 'audio': 'audio/Ii2.mp3'},
    {'answer': 'Isa', 'audio': 'audio/Aralin 5 - isa.mp3'},
    {'answer': 'Misa', 'audio': 'audio/Aralin 5 - misa.mp3'},
    {'answer': 'Mais', 'audio': 'audio/Aralin 5 - mais.mp3'},
    {'answer': 'Sisi', 'audio': 'audio/Aralin 5 - sisi.mp3'},
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
    _remainingItems = List.from(_itemsWithAnswers)..shuffle();
    _isGameOver = false;
    _score = 0;
    _loadNextItem();
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void _loadNextItem() async {
    // Stop any currently playing audio before loading next item
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
    switch (correctAnswer) {
      case 'Ii':
        return ['Ii', 'Ee', 'Aa', 'Uu'];
      case 'Isa':
        return ['Misa', 'Isa', 'Lisa', 'Sisa'];
      case 'Misa':
        return ['Misa', 'Sisa', 'Isa', 'Siko'];
      case 'Mais':
        return ['Mani', 'Manga', 'Mais', 'Manok'];
      case 'Sisi':
        return ['Siko', 'Sako', 'Sisi', 'Sisa'];
      default:
        return [];
    }
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
        title: const Text('Katamtaman Game'),
        backgroundColor: Colors.purpleAccent,
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
                colors: [Colors.purple.shade50, Colors.lightBlue.shade50],
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
                      color: Colors.purpleAccent,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill, color: Colors.purpleAccent),
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
                    'Tapos Na!\nTamang Sagot: $_score / ${_itemsWithAnswers.length}',
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
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isGameOver ? _resetGame : _loadNextItem,
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
      height: 60,
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
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
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