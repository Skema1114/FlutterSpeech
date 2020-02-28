import 'package:flutterspeech/banco_dados/dao/Configuracao_DAO.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//REF
//https://www.youtube.com/watch?v=-rQ_OmPj300
//https://www.youtube.com/watch?v=WnJZOi57oTY

void main() {
  runApp(FlutteSpeech());
}

class FlutteSpeech extends StatelessWidget {
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
  final FlutterTts flutterTts = FlutterTts();
  final ConfiguracaoDAO _configuracaoDAO = ConfiguracaoDAO();
  SpeechRecognition _speechRecognition;
  bool _isAvaliable = false;
  bool _isListening = false;
  bool modoConfiguracao = false;
  Color fundoTela = Colors.white;
  Color configuracaoCor = Colors.deepPurple[200];
  double tamanhoFonte = 24.0;
  String resultText = '';

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    solicitarPermissao();
  }

  Future solicitarPermissao() async {
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
        solicitarPermissao();
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
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.unknown:
        break;
      default:
    }
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() => _isAvaliable = result));
    _speechRecognition.setRecognitionStartedHandler(
        () => setState(() => _isListening = true));
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() {
        resultText = speech;
        configuracaoPorVoz(resultText);
      })
    );
    _speechRecognition.setRecognitionCompleteHandler(
        () => setState(() => _isListening = false));
    _speechRecognition
        .activate()
        .then((result) => setState(() => _isAvaliable = result));
  }

  void configuracaoPorVoz(String comando) {
    switch (comando.toLowerCase()) {
      case "configuração ativada":
        configuracaoCor = Colors.red;
        modoConfiguracao = true;
        flutterTts.speak("modo de configuração ativado!");
        Toast.show("Modo de configuração ATIVADO!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      case "configuração desativada":
        configuracaoCor = Colors.deepPurple[200];
        modoConfiguracao = false;
        flutterTts.speak("modo de configuração desativado!");
        Toast.show("Modo de configuração DESATIVADO!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      case "fundo vermelho":
        if (modoConfiguracao == true) {
          fundoTela = Colors.red;
          flutterTts.speak("A cor do background foi alterada para vermelho");
        }
        break;
      case "fundo azul":
        if (modoConfiguracao == true) {
          fundoTela = Colors.blue;
          flutterTts.speak("A cor do background foi alterada para azul");
        }
        break;
      case "fundo padrão":
        if (modoConfiguracao == true) {
          fundoTela = Colors.white;
          flutterTts.speak("A cor do background foi alterada para o padrão");
        }
        break;
      case "tamanho da fonte grande":
        if (modoConfiguracao == true) {
          tamanhoFonte = 40.0;
          flutterTts.speak("O tamanho da fonte foi alterado para 40");
        }
        break;
      case "tamanho da fonte pequena":
        if (modoConfiguracao == true) {
          tamanhoFonte = 8.0;
          flutterTts.speak("O tamanho da fonte foi alterado para 8");
        }
        break;
      case "tamanho da fonte padrão":
        if (modoConfiguracao == true) {
          tamanhoFonte = 24.0;
          flutterTts.speak("O tamanho da fonte foi alterado para o padrão");
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    Future _speak(String text) async {
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
                color: configuracaoCor,
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
                        labelText: 'Escreva algo aqui',
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
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'configuração [ativada ou desativada]\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'fundo [vermelho, azul e padrão]\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'tamanho da fonte [grande, pequena e padrão]',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
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
