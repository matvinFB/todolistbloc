import 'package:todo_list_bloc/scr/home/model/tarefa.dart';


abstract class TodoState{
  List<Tarefa> _todoList;

  TodoState([todoList]) : _todoList = todoList ?? [];

  List<Tarefa> get todoList => _todoList;
}

class CarregandoTodoList extends TodoState{
  CarregandoTodoList():super();

  @override
  bool operator ==(Object other ) {
    var temp = other as List<Tarefa>;
    for(int i = 0; i<_todoList.length; i++){
      if(_todoList[i] != temp[i]){
        return false;
      }
    }
    return identical(this, other) || runtimeType == other.runtimeType &&
        _todoList == temp.toString().hashCode;
  }


  @override
  int get hashCode => this.toString().hashCode;

  @override
  String toString() {
    return 'TodoState{_todoList: $_todoList}';
  }
}

class CarregadaTodoList extends TodoState{
  CarregadaTodoList(List<Tarefa>todoList): super(todoList);
}

class ErrorTodoList extends TodoState{}

class Inicial extends TodoState{
  Inicial():super();
}
