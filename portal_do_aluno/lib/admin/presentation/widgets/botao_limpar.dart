import 'package:flutter/material.dart';

class BotaoLimpar extends StatefulWidget {
  final Future<void> Function() limparconteudo;
  const BotaoLimpar({super.key, required this.limparconteudo});

  @override
  State<BotaoLimpar> createState() => _BotaoLimparState();
}

class _BotaoLimparState extends State<BotaoLimpar> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save),
        label: isLoading ? const Text('Limpando...') : const Text('Limpar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 194, 0, 26),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                setState(() => isLoading = true);
                try {
                  await widget.limparconteudo();
                } catch (e) {
                  return debugPrint('Erro ao Limpar: $e');
                }
                setState(() => isLoading = false);
              },
      ),
    );
  }
}
