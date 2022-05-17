abstract class TodoEvent{

}

class AddTarefa extends TodoEvent{
  String nome;
  String descricao;

  AddTarefa(this.nome, this.descricao);
}

class EditarTarefa extends TodoEvent{
  int _index;
  String _nome;
  String _descricao;

  EditarTarefa(this._index, this._nome, this._descricao);

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get index => _index;

  set index(int value) {
    _index = value;
  }
}

class InverterEstadoTarefa extends TodoEvent{
  int index;
  InverterEstadoTarefa(this.index);
}

class RemoverTarefa extends TodoEvent{
  int index;
  RemoverTarefa(this.index);
}

class LimparTarefas extends TodoEvent{}

class DesfazerExclusao extends TodoEvent{}

class CarregarTarefas extends TodoEvent{}

