import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

//REF
//https://www.youtube.com/watch?v=-rQ_OmPj300

void main() => runApp(flutterSpech());

class flutterSpech extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvaliable = false;
  bool _isListening = false;

  String resultText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvaliable = result),
    );
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );
    _speechRecognition.activate().then(
          (result) => setState(() => _isAvaliable = result),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if (_isListening) {
                      _speechRecognition.cancel().then(
                            (result) => setState(() {
                              _isListening = result;
                              resultText = "";
                            }),
                          );
                    }
                  },
                  child: Icon(Icons.cancel),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.pink,
                  onPressed: () {
                    if (_isAvaliable && !_isListening) {
                      _speechRecognition
                          .listen(
                            locale: "en_US",
                          )
                          .then((result) => print('$result'));
                    }
                  },
                  child: Icon(Icons.mic),
                ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    if (_isListening) {
                      _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result),
                          );
                    }
                  },
                  child: Icon(Icons.stop),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
