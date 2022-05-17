import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:todo_list_bloc/scr/home/bloc/todo_bloc.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_events.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_states.dart';
import 'package:todo_list_bloc/scr/home/model/tarefa.dart';
import 'package:todo_list_bloc/scr/service/persistence_repository.dart';

import 'todo_bloc_test.mocks.dart';

class PersServiceMock extends Mock implements IDataPersistenceService{}

@GenerateMocks([DataPersistenceService])
void main(){
  final repo = MockDataPersistenceService();
  late TodoListBloc bloc;

  setUp((){
    bloc = TodoListBloc(repo);
    when(repo.persist(any)).thenAnswer((_) async => Future.value(true));
    when(repo.clear()).thenAnswer((_) async => Future.value(true));
    when(repo.read()).thenAnswer((_) async => Future<List<Tarefa>>.value([Tarefa('tarefa1',' ', false)]));
    bloc.add(CarregarTarefas());
  });

  tearDown((){
    bloc.close();
  });

  test('Deve mostrar o estado Inicial', () {
    expect(bloc.state, isA<Inicial>());
  });

  blocTest<TodoListBloc, TodoState>(
    "Adicionar uma tarefa só com nome deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(AddTarefa('tarefa1','')),
    expect: () => [CarregadaTodoList([Tarefa('tarefa1','', false)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Adicionar uma tarefa com nome e descrição deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(AddTarefa('tarefa1','descricao')),
    expect: () => [CarregadaTodoList([Tarefa('tarefa1','descricao', false)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Adicionar uma tarefa sem nome nem descrição deve emitir um estado ErrorTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(AddTarefa('','')),
    expect: () => [isA<ErrorTodoList>(), isA<CarregadaTodoList>()],
  );

  blocTest<TodoListBloc, TodoState>(
    "Adicionar uma tarefa sem nome nem descrição deve emitir um estado ErrorTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(AddTarefa('','asv')),
    expect: () => [isA<ErrorTodoList>(), isA<CarregadaTodoList>()],
  );

  blocTest<TodoListBloc, TodoState>(
    "Editar uma tarefa deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo)..add(AddTarefa('tarefa1','')),
    act: (bloc) => bloc.add(EditarTarefa(0, 'tarefa2', '')),
    expect: () => [CarregadaTodoList([Tarefa('tarefa2','', false)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Editar uma tarefa fora da lista deve emitir um estado de ErrorTodoList depois CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(EditarTarefa(0, 'tarefa2', '')),
    expect: () => [ isA<ErrorTodoList>(), isA<CarregadaTodoList>()],
  );

  blocTest<TodoListBloc, TodoState>(
    "Remover uma tarefa deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo)..add(AddTarefa('tarefa1',''))..add(AddTarefa('tarefa2','')),
    act: (bloc) => bloc.add(RemoverTarefa(1)),
    expect: () => [CarregadaTodoList([Tarefa('tarefa1','',false)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Remover a segunda tarefa de uma lista com duas tarefas deve emitir um estado CarregadaTodoList com a segunda",
    build: () => TodoListBloc(repo)..add(AddTarefa('tarefa1',''))..add(AddTarefa('tarefa2','')),
    act: (bloc) => bloc.add(RemoverTarefa(0)),
    expect: () => [CarregadaTodoList([Tarefa('tarefa2','',false)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Remover uma tarefa  de uma lista com um item deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo)..add(AddTarefa('tarefa1','')),
    act: (bloc) => bloc.add(RemoverTarefa(0)),
    expect: () => [CarregadaTodoList([])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Remover uma tarefa fora da lista deve emitir deve emitir um estado ErrorTodoList depois CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(RemoverTarefa(0)),
    expect: () => [ isA<ErrorTodoList>(), isA<CarregadaTodoList>()],
  );

  blocTest<TodoListBloc, TodoState>(
    "Remover todas as tarefas deve emitir um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(LimparTarefas()),
    expect: () => [CarregadaTodoList([])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Desfazer a exclusão deve retornar um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(DesfazerExclusao()),
    expect: () => [isA<CarregadaTodoList>()],
  );


  blocTest<TodoListBloc, TodoState>(
    "Carregar tarefas deve retornar um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc){
      bloc.add(CarregarTarefas());
    },
    expect: () => [isA<CarregadaTodoList>()],
  );

  blocTest<TodoListBloc, TodoState>(
    "Inverter estado tarefa deve retornar um estado CarregadaTodoList",
    build: () => TodoListBloc(repo)..add(AddTarefa('tarefa1','')),
    act: (bloc) => bloc.add(InverterEstadoTarefa(0)),
    expect: () => [CarregadaTodoList([Tarefa('tarefa1','', true)])],
  );

  blocTest<TodoListBloc, TodoState>(
    "Inverter estado de uma tarefa fora da lista deve retornar um estado CarregadaTodoList",
    build: () => TodoListBloc(repo),
    act: (bloc) => bloc.add(InverterEstadoTarefa(1)),
    expect: () => [isA<ErrorTodoList>(), isA<CarregadaTodoList>()],
  );

}

