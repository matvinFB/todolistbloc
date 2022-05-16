import 'package:todo_list_bloc/scr/home/model/tarefa.dart';

class ItemExcluido{
  Tarefa tarefa;
  int indexPreExclusao;

  ItemExcluido(this.tarefa, this.indexPreExclusao);
}