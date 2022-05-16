import '../home/model/tarefa.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IDataPersistenceService{
  Future<bool> persist(List<Tarefa>todoList);
  Future<List<Tarefa>> read();
  Future<bool> clear();
}

class DataPersistenceService implements IDataPersistenceService{

  DataPersistenceService();


  @override
  Future<bool> clear() async{
    var prefs = await SharedPreferences.getInstance() as SharedPreferences;
    return await prefs.remove("todoList");
  }

  @override
  Future<bool> persist(List<Tarefa> todoList) async{
    var prefs = await SharedPreferences.getInstance() as SharedPreferences;

    String todoListJson = jsonEncode(todoList);

    return await prefs.setString("todoList", todoListJson);
  }

  @override
  Future<List<Tarefa>> read() async{
    var prefs = await SharedPreferences.getInstance() as SharedPreferences;

    var todoListString = prefs.getString("todoList")??"[]";

    List<dynamic> todoListJson = jsonDecode(todoListString);

    List<Tarefa> todoList = [];

    for(dynamic i in todoListJson){
      todoList.add(Tarefa.fromJson(i));
    }

    return todoList;
  }

}