import 'package:flutterspeech/banco_dados/configuracao_db.dart';
import 'package:flutterspeech/modelo/configuracao.dart';
import 'package:sqflite/sqflite.dart';

class ConfiguracaoDAO {
  static const String _nomeTabela = 'configuracao';
  static const String _id = 'id';
  static const String _tamanhoFonte = 'tamanho_fonte';
  static const String _modoConfiguracao = 'modo_configuracao';
  static const String _fundoTela = 'fundo_tela';
  static const String tableSqlContato = 'CREATE TABLE $_nomeTabela('
      '$_id INTEGER PRIMARY KEY, '
      '$_tamanhoFonte REAL, '
      '$_modoConfiguracao TEXT, '
      '$_fundoTela TEXT)';

  Future<int> save(Configuracao configuracao) async {
    final Database db = await getDatabase();
    Map<String, dynamic> configuracaoMap = _toMap(configuracao);
    return db.insert(_nomeTabela, configuracaoMap);
  }

  Future<List<Configuracao>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> resutado = await db.query(_nomeTabela);
    List<Configuracao> configuracoes = _toList(resutado);
    return configuracoes;
  }

  Map<String, dynamic> _toMap(Configuracao configuracao) {
    final Map<String, dynamic> configuracaoMap = Map();
    configuracaoMap['id'] = configuracao.id;
    configuracaoMap['tamanho_fonte'] = configuracao.tamanhoFonte;
    configuracaoMap['modo_configuracao'] = configuracao.modoConfiguracao;
    configuracaoMap['fundo_tela'] = configuracao.fundoTela;
    return configuracaoMap;
  }

  List<Configuracao> _toList(List<Map<String, dynamic>> resutado) {
    final List<Configuracao> configuracoes = List();
    for (Map<String, dynamic> row in resutado) {
      final Configuracao configuracao = Configuracao(
        row[_id],
        row[_tamanhoFonte],
        row[_modoConfiguracao],
        row[_fundoTela],
      );
      configuracoes.add(configuracao);
    }
    return configuracoes;
  }
}