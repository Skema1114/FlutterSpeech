import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
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

  final FlutterTts flutterTts = FlutterTts();

  Color fundoTela = Colors.white;
  double tamanhoFonte = 24.0;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    permissionHome();
  }

  Future permissionHome() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler
        .requestPermissions([PermissionGroup.microphone]);
    var permissionStatus = await _permissionHandler
        .checkPermissionStatus(PermissionGroup.microphone);

    switch (result[PermissionGroup.microphone]) {
      case PermissionStatus.granted:
        initSpeechRecognizer();
        break;
      case PermissionStatus.denied:
        permissionHome();
        break;
      case PermissionStatus.disabled:
        Toast.show("PERMISSÃO DESABILITADA", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      case PermissionStatus.restricted:
        Toast.show("PERMISSÃO RESTRITA", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      case PermissionStatus.unknown:
        Toast.show("PERMISSÃO UNKNOW", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      default:
    }

    switch (permissionStatus) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.denied:
        Toast.show("Precisa dar permissão de acesso ao Microfone", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      case PermissionStatus.disabled:
        // do something
        break;
      case PermissionStatus.restricted:
        // do something
        break;
      case PermissionStatus.unknown:
        // do something
        break;
      default:
    }
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
      (String speech) => setState(() {
        resultText = speech;
        configuracaoPorVoz(resultText);
      }),
    );
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );
    _speechRecognition.activate().then(
          (result) => setState(() => _isAvaliable = result),
        );
  }

  void configuracaoPorVoz(String comando) {
    switch (comando) {
      case "backgound vermelho":
        fundoTela = Colors.red;
        flutterTts.speak("A cor do background foi alterada para vermelho");
        break;
      case "backgound azul":
        fundoTela = Colors.blue;
        flutterTts.speak("A cor do background foi alterada para azul");
        break;
      case "backgound padrão":
        fundoTela = Colors.blue;
        flutterTts.speak("A cor do background foi alterada para o padrão");
        break;
      case "tamanho da fonte maior":
        tamanhoFonte = 40.0;
        flutterTts.speak("O tamanho da fonte foi alterado para 40");
        break;
      case "tamanho da fonte menor":
        tamanhoFonte = 8.0;
        flutterTts.speak("O tamanho da fonte foi alterado para 8");
        break;
      case "tamanho da fonte padrão":
        tamanhoFonte = 24.0;
        flutterTts.speak("O tamanho da fonte foi alterado para o padrão");
        break;
      // =================
      case "Backgound vermelho":
        fundoTela = Colors.red;
        flutterTts.speak("A cor do background foi alterada para vermelho");
        break;
      case "Backgound azul":
        fundoTela = Colors.blue;
        flutterTts.speak("A cor do background foi alterada para azul");
        break;
      case "Backgound padrão":
        fundoTela = Colors.blue;
        flutterTts.speak("A cor do background foi alterada para o padrão");
        break;
      case "Tamanho da fonte maior":
        tamanhoFonte = 40.0;
        flutterTts.speak("O tamanho da fonte foi alterado para 40");
        break;
      case "Tamanho da fonte menor":
        tamanhoFonte = 8.0;
        flutterTts.speak("O tamanho da fonte foi alterado para 8");
        break;
      case "Tamanho da fonte padrão":
        tamanhoFonte = 24.0;
        flutterTts.speak("O tamanho da fonte foi alterado para o padrão");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    Future _speak(String text) async {
      //print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("pt_BR");
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: fundoTela,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.pink,
                  onPressed: () {
                    if (_isAvaliable && !_isListening) {
                      _speechRecognition
                          .listen(
                        locale: "pt_BR",
                      )
                          .then((result) {
                        print('$result');
                      });
                    }
                  },
                  child: Icon(Icons.mic),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.deepPurple[200],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(
                  fontSize: tamanhoFonte,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: 'Escreva algo',
                        focusColor: Colors.white,
                      )),
                  RaisedButton(
                    child: Text("Falar"),
                    onPressed: () {
                      _speak(textEditingController.text);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  children: <Widget>[
                    Text('backgound vermelho'),
                    Text('backgound azul'),
                    Text('backgound padrão'),
                    Text('tamanho da fonte maior'),
                    Text('tamanho da fonte menor'),
                    Text('tamanho da fonte padrão'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
