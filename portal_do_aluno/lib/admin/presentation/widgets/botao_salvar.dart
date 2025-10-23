import 'package:flutter/material.dart';

class BotaoSalvar extends StatefulWidget {
  final Future<void> Function() salvarconteudo;
  const BotaoSalvar({super.key, required this.salvarconteudo});

  @override
  State<BotaoSalvar> createState() => _BotaoSalvarState();
}

class _BotaoSalvarState extends State<BotaoSalvar> {
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
        label: isLoading ? const Text('Salvando...') : const Text('Salvar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5921F3),
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
                  await widget.salvarconteudo();
                } catch (e) {
                  return debugPrint('Erro ao salvar: $e');
                }
                setState(() => isLoading = false);
              },
      ),
    );
  }
}
