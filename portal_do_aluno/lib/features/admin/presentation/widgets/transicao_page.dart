import 'package:flutter/cupertino.dart';

class TransicaoPage extends StatefulWidget {
  final Widget child;
  const TransicaoPage({super.key, required this.child});

  @override
  State<TransicaoPage> createState() => _TransicaoPageState();
}

class _TransicaoPageState extends State<TransicaoPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: widget.child,
    );
  }
}
