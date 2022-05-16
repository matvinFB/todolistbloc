import 'package:todo_list_bloc/scr/home/model/tarefa.dart';

abstract class TodoState{
  List<Tarefa> _todoList;

  TodoState([todoList]) : _todoList = todoList ?? [];

  List<Tarefa> get todoList => _todoList;

}

class CarregandoTodoList extends TodoState{
  CarregandoTodoList():super();
}

class CarregadaTodoList extends TodoState{
  CarregadaTodoList(List<Tarefa>todoList): super(todoList);
}

class ErrorTodoList extends TodoState{
  ErrorTodoList():super();
}

class Inicial extends TodoState{
  Inicial():super();
}
