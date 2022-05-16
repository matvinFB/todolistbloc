abstract class TodoEvent{

}

class AddTarefa extends TodoEvent{
  String nome;
  String descricao;

  AddTarefa(this.nome, this.descricao);
}

class EditarTarefa extends TodoEvent{
  int Index;
  String nome;
  String descricao;

  EditarTarefa(this.Index, this.nome, this.descricao);
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

