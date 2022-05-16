import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_events.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_states.dart';
import 'package:todo_list_bloc/scr/home/model/tarefa.dart';
import 'package:todo_list_bloc/scr/home/model/undo_model.dart';

import '../../estrutura_de_dados/pilha.dart';
import '../../service/persistence_repository.dart';

class TodoListBloc extends Bloc<TodoEvent, TodoState>{

  Pilha<ItemExcluido> _pilhaItensExluidos = Pilha<ItemExcluido>();

  IDataPersistenceService persistenceService;

  TodoListBloc(this.persistenceService) : super(Inicial()){
    on<AddTarefa>(_onAddTarefa);
    on<RemoverTarefa>(_onRemoverTarefa);
    on<EditarTarefa>(_onEditarTarefa);
    on<InverterEstadoTarefa>(_onInverterEstadoTarefa);
    on<LimparTarefas>(_onLimparTarefas);
    on<DesfazerExclusao>(_onDesfazerExclusao);
    on<CarregarTarefas>(_onCarregarTarefas);
  }

 

  _onAddTarefa(event, emit) async{
    List<Tarefa> todoList = state.todoList;

    if(event.nome == ''){
      emit(ErrorTodoList);
      sleep(Duration(seconds: 1));
      emit(CarregadaTodoList(todoList));
      return;
    }else{
      Tarefa novaTarefa = Tarefa(event.nome, event.descricao);
      todoList.add(novaTarefa);
      emit(CarregadaTodoList(todoList));
      persistenceService.persist(state.todoList);
    }

  }

  _onRemoverTarefa(event, emit){
    List<Tarefa> todoList = state.todoList;
    _pilhaItensExluidos.push(ItemExcluido(state.todoList[event.index],  event.index));
    todoList.removeAt(event.index);
    emit(CarregadaTodoList(todoList));
    persistenceService.persist(state.todoList);
  }

  _onEditarTarefa(event, emit){
    var lista = state.todoList;
    try{
      state.todoList[event.Index].nome =
      (event.nome ?? state.todoList[event.Index].nome);
      state.todoList[event.Index].descricao =
      (event.descricao ?? state.todoList[event.Index].descricao);
    }catch(e){
      emit(ErrorTodoList());
    }
    emit(CarregadaTodoList(lista));
    persistenceService.persist(state.todoList);
  }

  _onLimparTarefas(event, emit){

    for(int i = 0 ; i < state.todoList.length ; i++){
      _pilhaItensExluidos.push(
          ItemExcluido(state.todoList[i], i));
    }
    emit(CarregadaTodoList([]));
    persistenceService.clear();
  }

  _onDesfazerExclusao(event, emit){
    var listaTodo = state.todoList;
    if(!_pilhaItensExluidos.isEmpty){
      ItemExcluido ultimoExcluido = _pilhaItensExluidos.pop()!;

      ultimoExcluido.indexPreExclusao < listaTodo.length ?
        state.todoList.insert(ultimoExcluido.indexPreExclusao, ultimoExcluido.tarefa) :
        state.todoList.add(ultimoExcluido.tarefa);
    }
    emit(CarregadaTodoList(listaTodo));
    persistenceService.persist(state.todoList);
  }

  _onCarregarTarefas(event, emit) async{
    var todoList  = await persistenceService.read();
    emit(CarregadaTodoList(todoList));

  }

  _onInverterEstadoTarefa(event, emit){
    var todoList = state.todoList;
    todoList[event.index].check = !todoList[event.index].check;
    emit(CarregadaTodoList(todoList));
    persistenceService.persist(state.todoList);
  }

  }