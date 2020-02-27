class Configuracao{
  final int id;
  final double tamanhoFonte;
  final String modoConfiguracao;
  final String fundoTela;

  Configuracao(this.id, this.tamanhoFonte, this.modoConfiguracao, this.fundoTela);

  @override
  String toString() {
    return 'Configuracao{id: $id, tamanhoFonte: $tamanhoFonte, modoConfiguracao: $modoConfiguracao, fundoTela: $fundoTela}';
  }
}