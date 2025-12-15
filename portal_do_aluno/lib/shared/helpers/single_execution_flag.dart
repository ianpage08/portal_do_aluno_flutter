class SingleExecutionFlag {
  // Indica se a ação já foi executada
  bool _executed = false;

  // Retorna se já executou
  bool get hasExecuted => _executed;

  // Executa a ação apenas uma vez
  Future<void> execute(Future<void> Function() action) async {
    if (_executed) return;

    // Bloqueia novas execuções
    _executed = true;

    // Executa a ação protegida
    await action();
  }

  // Reseta a flag para novo uso
  void reset() {
    _executed = false;
  }
}
