import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String uid;
  final String nome;
  final String email;
  final String fotoUrl;
  final String cpf;
  final String telefone;
  final Timestamp? criadoEm;
  final Timestamp? ultimoLogin;
  final bool ativo;

  UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.fotoUrl,
    this.cpf = '',
    this.telefone = '',
    this.criadoEm,
    this.ultimoLogin,
    this.ativo = true,
  });

  UserModel copyWith({
    String? uid,
    String? nome,
    String? email,
    String? fotoUrl,
    String? cpf,
    String? telefone,
    Timestamp? criadoEm,
    Timestamp? ultimoLogin,
  }) => UserModel(
    uid: uid ?? this.uid,
    nome: nome ?? this.nome,
    email: email ?? this.email,
    fotoUrl: fotoUrl ?? this.fotoUrl,
    cpf: cpf ?? this.cpf,
    telefone: telefone ?? this.telefone,
    criadoEm: criadoEm ?? this.criadoEm,
    ultimoLogin: ultimoLogin ?? this.ultimoLogin,
    
  );



  factory UserModel.fromMap(Map<String, dynamic> map, String id){
    return UserModel(
      uid: id,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      fotoUrl: map['foto_url'] ?? '',
      cpf: map['cpf'] ?? '',
      telefone: map['telefone'] ?? '',
      criadoEm: map['criado_em'],
      ultimoLogin: map['ultimo_login'],
      ativo: map['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'email': email,
      'foto_url': fotoUrl,
      'cpf': cpf,
      'telefone': telefone,
      'criado_em': criadoEm ?? FieldValue.serverTimestamp(),
      'ultimo_login': ultimoLogin ?? FieldValue.serverTimestamp(),
      'ativo': ativo,
    };
  }
}