import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/shared/widgets/global_loading.dart';

class LoadingService {
  static OverlayEntry? _overlayEntry;

   void showLoading( BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) =>  const  GlobalLoading(),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

   void hideLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
