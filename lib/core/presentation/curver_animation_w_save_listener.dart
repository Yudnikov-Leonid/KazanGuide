import 'package:flutter/animation.dart';

class CurvedAnimationWSaveListener extends CurvedAnimation {
  CurvedAnimationWSaveListener({required super.parent, required super.curve});

  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  void removeAllListeners() {
    _listeners
      ..forEach(super.removeListener)
      ..clear();
  }
}
