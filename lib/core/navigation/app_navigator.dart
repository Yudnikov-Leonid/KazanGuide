import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kazan_guide/core/navigation/pages.dart';

typedef AppPages = List<AppPage>;

class AppNavigator extends StatefulWidget {
  const AppNavigator({required this.initialState, super.key});

  final AppPages initialState;

  static void change(
    BuildContext context,
    AppPages Function(AppPages pages) fn,
  ) => context.findAncestorStateOfType<_AppNavigatorState>()?.change(fn);

  static void push(BuildContext context, AppPage page) =>
      change(context, (state) => [...state, page]);

  static void pop(BuildContext context) => change(context, (state) {
    if (state.length > 1) state.removeLast();
    return state;
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  AppPages get state => _state;
  late AppPages _state;

  @override
  void initState() {
    _state = widget.initialState;
    super.initState();
  }

  void change(AppPages Function(AppPages pages) fn) {
    if (!mounted) return;

    final next = fn(_state.toList());

    if (next.isEmpty || listEquals(_state, next)) return;
    _state = next;

    setState(() {});
  }

  void _onDidRemovePage(Page<Object?> page) {
    change((pages) => pages..removeWhere((e) => e.key == page.key));
  }

  @override
  Widget build(BuildContext context) =>
      Navigator(pages: _state, onDidRemovePage: _onDidRemovePage);
}
