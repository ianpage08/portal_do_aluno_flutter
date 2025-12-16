import 'package:flutter/material.dart';

class GlobalLoading extends StatelessWidget {
  const GlobalLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
