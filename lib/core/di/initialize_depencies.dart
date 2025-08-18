import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/features/map/map_repository.dart';
import 'package:kazan_guide/main.dart';

Future<Dependencies> initializeDependencies() async {
  final dependencies = Dependencies();

  for (final step in _steps) {
    try {
      step.call(dependencies);
    } catch (e, st) {
      logger.e('Error while initialization ${step.name}', stackTrace: st);
      rethrow;
    }
  }

  return dependencies;
}

List<_InitializationStep> _steps = [
  _InitializationStep(
    name: 'Repositories',
    call: (dependencies) {
      dependencies.mapRepository = MapRepositoryImpl();
    },
  ),
];

class _InitializationStep {
  final String name;
  final Function(Dependencies) call;

  _InitializationStep({required this.name, required this.call});
}
