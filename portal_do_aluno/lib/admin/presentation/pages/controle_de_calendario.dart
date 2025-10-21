import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ControleDeCalendario extends StatefulWidget {
  const ControleDeCalendario({super.key});

  @override
  State<ControleDeCalendario> createState() => _ControleDeCalendarioState();
}

class _ControleDeCalendarioState extends State<ControleDeCalendario> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Gestao de Calendario'),
      body: Center(
        child: Text('Controle de Calendario'),
      ),
    );
  }
}