import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:kazan_guide/main.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainLoadingState()) {
    on<MainEventLoad>(_onLoad);
  }

  Future<void> _onLoad(MainEventLoad event, Emitter<MainState> emit) async {
    emit(MainLoadingState());
    try {
      final data =
          jsonDecode(await rootBundle.loadString("assets/data/routes.json"))
              as List<dynamic>;

      emit(
        MainLoadedState(data: data.map((e) => RouteData.fromJson(e)).toList()),
      );
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
