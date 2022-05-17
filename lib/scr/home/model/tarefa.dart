import 'package:equatable/equatable.dart';

class Tarefa extends Equatable{
  String _nome;
  String _descricao;
  bool _check;

  Tarefa(this._nome, [this._descricao = '', this._check = false]);

  factory Tarefa.fromJson(dynamic tarefa){
    return Tarefa(tarefa['nome'] as String, tarefa['descricao'] as String, tarefa['check'] as bool);
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  bool get check => _check;

  set check(bool value) {
    _check = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome' : this._nome,
      'descricao' : this._descricao,
      'check' : this._check
    };
  }

  @override
  List<Object?> get props => [nome, descricao, check];
}