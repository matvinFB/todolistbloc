class Pilha<E> {
  final _list = <E>[];

  void push(E val) => _list.add(val);

  E? pop(){
    if(isEmpty == true) return null;
    E topo = _list.last;
    _list.removeLast();
    return topo;
  }

  E top() => _list.last;

  bool get isEmpty => _list.isEmpty;
}