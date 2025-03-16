import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AdvisoryPage extends StatefulWidget {
  const AdvisoryPage({super.key});

  @override
  _AdvisoryPageState createState() => _AdvisoryPageState();
}

class _AdvisoryPageState extends State<AdvisoryPage> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    setTtsLanguage();
  }

  void setTtsLanguage() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> advisories = [
      'Monitor soil moisture levels are low due to upcoming dry conditions.',
      'Consider applying fertilizer to improve crop yield.',
      'Pest infestation detected. Apply pesticides immediately.',
      'Check for signs of disease on leaves and stems.',
      'Ensure proper irrigation to prevent water stress.',
      'Protect crops from frost damage during cold nights.',
      'Control weeds to reduce competition for resources.',
      'Prune plants to improve air circulation and sunlight penetration.',
      'Harvest crops at the optimal time for best quality.',
      'Store harvested crops properly to prevent spoilage.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advisory', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB7E1CD),
              Color(0xFFE0F2F1),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: advisories.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        advisories[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.speaker_phone),
                      tooltip: 'Listen',
                      onPressed: () => speak(advisories[index]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
