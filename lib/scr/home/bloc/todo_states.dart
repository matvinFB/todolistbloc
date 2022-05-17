import 'package:equatable/equatable.dart';
import 'package:todo_list_bloc/scr/home/model/tarefa.dart';


abstract class TodoState extends Equatable{
  List<Tarefa> _todoList;

  TodoState([todoList]) : _todoList = todoList ?? [];

  List<Tarefa> get todoList => _todoList;

  @override
  List<Object?> get props => [todoList];

}

class CarregandoTodoList extends TodoState{
  CarregandoTodoList():super();

}

class CarregadaTodoList extends TodoState{
  CarregadaTodoList(List<Tarefa>todoList): super(todoList);
}

class ErrorTodoList extends TodoState{}

class Inicial extends TodoState{
  Inicial():super();
}
