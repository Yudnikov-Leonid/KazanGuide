import 'package:flutter/cupertino.dart';
import 'package:kazan_guide/features/map/map_repository.dart';

class Dependencies {
  late final MapRepository mapRepository;

  Widget inject({required Widget child}) =>
      InheritedDependencies(dependencies: this, child: child);

  static Dependencies of(BuildContext context) =>
      (context
                  .getElementForInheritedWidgetOfExactType<
                    InheritedDependencies
                  >()!
                  .widget
              as InheritedDependencies)
          .dependencies;
}

class InheritedDependencies extends InheritedWidget {
  const InheritedDependencies({
    required this.dependencies,
    required super.child,
    super.key,
  });

  final Dependencies dependencies;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
