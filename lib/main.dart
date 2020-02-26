import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

//REF
//https://www.youtube.com/watch?v=WnJZOi57oTY

void main() => runApp(flutterSpech());

class flutterSpech extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterTextSpeech(),
      ),
    );
  }
}

class FlutterTextSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    Future _speak(String text) async {
      //print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("pt-BR");
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: textEditingController,
          ),
          RaisedButton(
            child: Text("Falar"),
            onPressed: () => _speak(textEditingController.text),
          ),
        ],
      ),
    );
  }
}
