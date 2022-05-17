import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_bloc/scr/home/bloc/todo_states.dart';
import 'package:todo_list_bloc/scr/home/model/tarefa.dart';
import 'package:todo_list_bloc/scr/ui_constants.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_events.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Tarefa> _todoList = [];
  final TextEditingController _nomeTarefaController = TextEditingController();
  final TextEditingController _descricaoTarefaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _todoBloc = context.read<TodoListBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        backgroundColor: CONST_PRIMARY_COLOR,
        actions: [
          IconButton(
              onPressed: () {
                _todoBloc.add(DesfazerExclusao());
              },
              icon: Icon(Icons.undo)),
          IconButton(
              onPressed: () {
                _todoBloc.add(LimparTarefas());
              },
              icon: Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                _infoDialogBox();
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          BlocBuilder<TodoListBloc, TodoState>(
            builder: (BuildContext context, state) {
              if (state is Inicial) {
                _todoBloc.add(CarregarTarefas());
              }

              _todoList = state.todoList;
              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {

                    return Column(
                      children: [
                        GestureDetector(
                          child: Card(
                            child: SizedBox(
                              height: 65,
                              child: Row(
                                children: [
                                  LayoutBuilder(
                                      builder: (ctx, cons){
                                        return ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                          child: Container(
                                            height: cons.maxHeight,
                                            width: 7,
                                            color: _todoList[index].check == true? CONST_POSITIVE : CONST_NEGATIVE,
                                          ),
                                        );
                                      }
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  //INFORMAÇÕES PRINCIPAIS DA TAREFA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _todoList[index].nome,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: CONST_PRIMARY_LETTER_COLOR
                                          ),
                                        ),
                                        Text(
                                          _todoList[index].descricao,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: CONST_SECONDARY_LETTER_COLOR
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 20,
                                    thickness: 1,
                                    indent: 5,
                                    endIndent: 5,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 25,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Checkbox(
                                        activeColor: CONST_PRIMARY_COLOR,
                                          value: _todoList[index].check,
                                          onChanged: (_) {
                                            _todoBloc
                                                .add(InverterEstadoTarefa(index));
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      padding:
                                      const EdgeInsets.only(left: 5, right: 15),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: CONST_PRIMARY_COLOR,
                                      ),
                                      onPressed: () {
                                        _tarefaDialogBox(_todoBloc,
                                            tarefa: _todoList[index], index: index);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      padding:
                                      const EdgeInsets.only(left: 5, right: 15),
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _todoBloc.add(RemoverTarefa(index));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _todoBloc.add((InverterEstadoTarefa(index)));
                          },
                          onDoubleTap: () {
                            _tarefaDialogBox(_todoBloc,
                                tarefa: _todoList[index], index: index);
                          },
                          onHorizontalDragEnd: (_) {
                            _todoBloc.add(RemoverTarefa(index));
                          },
                        ),
                        index == _todoList.length-1? SizedBox(height: 70,): Container()
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 5);
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _tarefaDialogBox(_todoBloc);
          },
          backgroundColor: CONST_PRIMARY_COLOR,
          child: Icon(Icons.add)),
    );
  }

  Future _tarefaDialogBox(todoBloc, {tarefa, index}) {
    if (tarefa != null) {
      _nomeTarefaController.text = tarefa.nome;
      _descricaoTarefaController.text = tarefa.descricao;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0))),
            content: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  color: CONST_PRIMARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(170))),
              child: Center(
                child: SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: TextField(
                          controller: _nomeTarefaController,
                          decoration:
                              InputDecoration(labelText: 'Título da Tarefa'),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: TextField(
                            controller: _descricaoTarefaController,
                            decoration:
                                InputDecoration(labelText: 'Descrição')),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white
                                    //primary: Color.fromRGBO(255, 250, 240, 1),
                                    ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _nomeTarefaController.clear();
                                  _descricaoTarefaController.clear();
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: CONST_PRIMARY_COLOR,
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white
                                    //primary: Color.fromRGBO(255, 250, 240, 1),
                                    ),
                                onPressed: () {
                                  if (tarefa == null) {
                                    todoBloc.add(AddTarefa(
                                        _nomeTarefaController.text,
                                        _descricaoTarefaController.text));
                                  } else {
                                    todoBloc.add(EditarTarefa(
                                        index,
                                        _nomeTarefaController.text,
                                        _descricaoTarefaController.text));
                                  }

                                  _nomeTarefaController.clear();
                                  _descricaoTarefaController.clear();

                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.add,
                                  color: CONST_PRIMARY_COLOR,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
  Future _infoDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0))),
            content: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  color: CONST_PRIMARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(170))),
              child: const Center(
                child: Text(
                  "Clique único: marca/desmarca a tarefa.\n\n"+
                    "Duplo clique: abre a edição.\n\n"+
                    "Arrastar para a direita: exlui.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                ),
              )
            ),
          );
        });
  }
}
