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
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/map/map_bloc.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({required this.route, super.key});

  final RouteData route;

  static const kazanLocation = LatLng(55.830433, 49.066082);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) => Scaffold(
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
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
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
                            .mapIndexed(
                              (i, point) => Marker(
                                height: 50,
                                width: 40,
                                point: LatLng(point.lat, point.long),
                                child: InkWell(
                                  onTap: () {
                                    AppNavigator.push(
                                      context,
                                      PointDetailsPage(point),
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      Text(
                                        (i + 1).toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
