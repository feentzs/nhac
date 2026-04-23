class EnderecoModel {
  final String idDocumento;
  final String bairro;
  final String cep;
  final String cidade;
  final String complemento;
  final String estado;
  final String numero;
  final bool padrao;
  final String rua;

  EnderecoModel({
    required this.idDocumento,
    required this.bairro,
    required this.cep,
    required this.cidade,
    this.complemento = '',
    required this.estado,
    required this.numero,
    this.padrao = false,
    required this.rua,
  });

  factory EnderecoModel.fromMap(Map<String, dynamic> map, String docId) {
    return EnderecoModel(
      idDocumento: docId,
      bairro: map['bairro'] ?? '',
      cep: map['cep'] ?? '',
      cidade: map['cidade'] ?? '',
      complemento: map['complemento'] ?? '',
      estado: map['estado'] ?? '',
      numero: map['numero'] ?? '',
      padrao: map['padrao'] ?? false,
      rua: map['rua'] ?? '',
    );
  }

  EnderecoModel copyWith({
    String? idDocumento,
    String? bairro,
    String? cep,
    String? cidade,
    String? complemento,
    String? estado,
    String? numero,
    bool? padrao,
    String? rua,
  }) =>
      EnderecoModel(
        idDocumento: idDocumento ?? this.idDocumento,
        bairro: bairro ?? this.bairro,
        cep: cep ?? this.cep,
        cidade: cidade ?? this.cidade,
        complemento: complemento ?? this.complemento,
        estado: estado ?? this.estado,
        numero: numero ?? this.numero,
        padrao: padrao ?? this.padrao,
        rua: rua ?? this.rua,
      );


  Map<String, dynamic> toMap() {
    return {
      'bairro': bairro,
      'cep': cep,
      'cidade': cidade,
      'complemento': complemento,
      'estado': estado,
      'numero': numero,
      'padrao': padrao,
      'rua': rua,
    };
  }
}