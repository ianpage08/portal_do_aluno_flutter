String limitarCampo(String texto, int limite) {
  if (texto.length > limite) {
    return '${texto.substring(0, limite)}...';
  }
  return texto;
}
