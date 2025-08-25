import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/curver_animation_w_save_listener.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/map/map_bloc.dart';
import 'package:kazan_guide/features/map/markers.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({required this.route, super.key});

  final RouteData route;

  static const kazanLocation = LatLng(55.830433, 49.066082);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final _mapController = MapController();
  final Map<LatLng, (AnimationController, CurvedAnimationWSaveListener)>
  _animationControllers = {};

  @override
  void initState() {
    final multiPoints = widget.route.points.whereType<RouteMultiPointData>();

    for (final point in multiPoints) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
      final animation = CurvedAnimationWSaveListener(
        parent: controller,
        curve: Curves.ease,
      )..addListener(() {
        setState(() {});
      });
      _animationControllers.addAll({point.latLng: (controller, animation)});
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationControllers.forEach((_, v) {
      v.$1.dispose();
      v.$2
        ..removeAllListeners()
        ..dispose();
    });
    super.dispose();
  }

  void _resetAllAnimations() {
    _animationControllers.forEach((_, v) {
      if (v.$2.value > 0) {
        v.$1.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: TripleAppBar(
      context,
      title: widget.route.routeName,
      leadingFunction: () {
        AppNavigator.pop(context);
      },
    ),
    body: BlocProvider(
      create:
          (context) =>
              MapBloc(mapRepository: Dependencies.of(context).mapRepository)
                ..add(
                  MapEventLoadRoutes(
                    points: widget.route.points.map((e) => e.latLng),
                  ),
                ),
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapStateFailed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final points = widget.route.points;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      widget.route.points.isEmpty
                          ? MapScreen.kazanLocation
                          : LatLng(points.first.lat, points.first.long),
                  initialZoom: 14,
                  maxZoom: 18,
                  onPointerDown: (_, _) {
                    _resetAllAnimations();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.kazanGuide.kazanGuide',
                  ),
                  if (state is MapStateBase && state.routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: state.routePoints,
                          color: AppColors.green,
                          strokeWidth: 3,
                          pattern: StrokePattern.dashed(segments: const [8, 8]),
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers:
                        points
                            .mapIndexed((i, point) {
                              if (point is RouteSinglePointData) {
                                return MapSingleMarker().marker(
                                  () {
                                    AppNavigator.push(
                                      context,
                                      PointDetailsPage(point),
                                    );
                                  },
                                  point,
                                  i,
                                );
                              } else {
                                return MapMultiMarker(
                                  animationPos:
                                      _animationControllers[point.latLng]!
                                          .$2
                                          .value,
                                  action: () {
                                    final animationController =
                                        _animationControllers[point.latLng]!.$1;
                                    final animation =
                                        _animationControllers[point.latLng]!.$2;

                                    if (animation.value == 1) {
                                      animationController.reverse();
                                    } else if (animation.value == 0) {
                                      _resetAllAnimations();
                                      animationController.forward();
                                    }
                                  },
                                  onTapOnElement: (index) {
                                    AppNavigator.push(
                                      context,
                                      PointDetailsPage(point.points[index]),
                                    );
                                  },
                                  point: point as RouteMultiPointData,
                                  index: i,
                                ).marker();
                              }
                            })
                            .sorted((a, b) => a.height > b.height ? 1 : 0)
                            .toList(),
                  ),
                  const CurrentLocationLayer(),
                ],
              ),

              /// кнопка для перемещения на текущее положение пользователя
              // Positioned(
              //   bottom: 5,
              //   right: 5,
              //   child: IconButton(
              //     onPressed: () async {
              //       try {
              //         final location = await Geolocator.getCurrentPosition();
              //
              //         _mapController.move(
              //           LatLng(location.latitude, location.longitude),
              //           _mapController.camera.zoom,
              //         );
              //       } catch (e) {}
              //     },
              //     icon: const Icon(Icons.location_searching),
              //   ),
              // ),
            ],
          );
        },
      ),
    ),
  );
}
