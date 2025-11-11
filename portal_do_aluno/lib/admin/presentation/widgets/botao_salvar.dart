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
            : const Icon(Icons.save, color: Colors.white),
        label: isLoading
            ? const Text('Salvando...')
            : const Text('Salvar', style: TextStyle(color: Colors.white)),
        style: Theme.of(context).elevatedButtonTheme.style,
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
