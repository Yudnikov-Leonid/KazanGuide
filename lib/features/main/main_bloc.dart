import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/data/routes_repository.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:kazan_guide/main.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final RoutesRepository _routesRepository;

  MainBloc({required RoutesRepository routesRepository})
    : _routesRepository = routesRepository,
      super(MainLoadingState()) {
    on<MainEventLoad>(_onLoad);
  }

  Future<void> _onLoad(MainEventLoad event, Emitter<MainState> emit) async {
    emit(MainLoadingState());
    try {
      final routes = await _routesRepository.loadRoutes();

      emit(MainLoadedState(data: routes));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(
        MainFailedState(
          message:
              'Произошла ошибка при получении маршрутов${FlavorConfig.isDev() ? ':\n\n$e' : ''}',
        ),
      );
    }
  }
}

/// events
abstract class MainEvent {}

class MainEventLoad extends MainEvent {}

/// states
abstract class MainState {}

class MainLoadingState extends MainState {}

class MainLoadedState extends MainState {
  final List<RouteData> data;

  MainLoadedState({required this.data});
}

class MainFailedState extends MainState {
  final String message;

  MainFailedState({required this.message});
}
