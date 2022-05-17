import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_bloc/scr/home/model/tarefa.dart';
import 'package:todo_list_bloc/scr/service/persistence_repository.dart';

void main() {
  final repo = DataPersistenceService();

  test("Chamar read deve retornar uma List<Tarefa>", () async {
    expect((await repo.read()), isA<List<Tarefa>>());
  });

  test("Chamar clear deve retornar true", () async {
    var result = await repo.clear();
    expect(result, equals(true));
  });

  test("Chamar persist passando uma lista vazia deve retornar true", () async {
    var result = await repo.persist([]);
    expect(result, equals(true));
  });

  test("Chamar persist passando uma lista com itens deve retornar true",
      () async {
    var result = await repo.persist([Tarefa('tarefa1', '', true)]);
    expect(result, equals(true));
  });

  test(
      "Chamar persist uma segunda vez e chamar read deve retornar o dado da segunda chamada",
          () async {
        await repo.persist([Tarefa('tarefa1', '', true)]);
        await repo.persist([Tarefa('tarefa2', '', true)]);
        var result = await repo.read();
        expect(result, equals([Tarefa('tarefa2', '', true)]));
      });

  test("Chamar read após um clear em uma lista que continha itens deve retornar uma lista vazia",
          () async {
            await repo.persist([Tarefa('tarefa1', '', true)]);
            await repo.clear();
            var result = await repo.read();
        expect(result, equals([]));
      });
}
