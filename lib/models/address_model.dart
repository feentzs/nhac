class AddressModel{
  final String bairro;
  final String cep;
  final String cidade;
  final String complemento;
  final String estado;
  final String numero;
  final bool padrao;
  final String rua;

  AddressModel({
    required this.bairro,
    required this.cep,
    required this.cidade,
    this.complemento = '',
    required this.estado,
    required this.numero,
    this.padrao = false,
    required this.rua,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map){
    return AddressModel(
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

  Map<String, dynamic> toMap(){
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