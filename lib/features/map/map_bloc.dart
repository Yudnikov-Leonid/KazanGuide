import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazan_guide/features/map/map_repository.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:kazan_guide/main.dart';
import 'package:latlong2/latlong.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository _mapRepository;

  MapBloc({required MapRepository mapRepository})
    : _mapRepository = mapRepository,
      super(MapStateBase(routePoints: [])) {
    on<MapEventLoadRoutes>(_onLoad);
  }

  Future<void> _onLoad(MapEventLoadRoutes event, Emitter<MapState> emit) async {
    Iterable<LatLng> routes = [];
    try {
      routes = await _mapRepository.getRoutes(event.points.toList());
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(
        MapStateFailed(
          message:
              'Не удалось построить маршрут${FlavorConfig.isDev() ? ': ${e}' : ''}',
        ),
      );
    } finally {
      emit(MapStateBase(routePoints: routes.toList()));
    }
  }
}

/// events
abstract class MapEvent {}

class MapEventLoadRoutes extends MapEvent {
  final Iterable<LatLng> points;

  MapEventLoadRoutes({required this.points});
}

///
abstract class MapState {}

class MapStateBase extends MapState {
  final List<LatLng> routePoints;

  MapStateBase({required this.routePoints});
}

class MapStateFailed extends MapState {
  final String message;

  MapStateFailed({required this.message});
}
