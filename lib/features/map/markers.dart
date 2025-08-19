import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:num_remap/num_remap.dart';

/// multipoint
class MapMultiMarker {
  final double animationPos;
  final VoidCallback action;
  final ValueChanged<int> onTapOnElement;
  final RouteMultiPointData point;
  final int index;

  MapMultiMarker({
    required this.animationPos,
    required this.action,
    required this.onTapOnElement,
    required this.point,
    required this.index,
  });

  Marker marker() {
    final iText = (index + 1).toString();
    final count = point.points.length;

    return Marker(
      rotate: true,
      height: 120,
      width: 120,
      point: LatLng(point.lat, point.long),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity:
                animationPos - 0.6 < 0 ? 0 : animationPos.remap(0.6, 1, 0, 0.5),
            child: Stack(children: _getSticks(count)),
          ),

          InkWell(
            onTap: action,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red,
                  ),
                ),
                Opacity(
                  opacity: 1 - animationPos,
                  child: Text(
                    iText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Opacity(
                  opacity: animationPos,
                  child: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),

          Opacity(
            opacity:
                animationPos - 0.5 < 0 ? 0 : animationPos.remap(0.5, 1, 0, 1),
            child: Stack(children: _getPoints(count, iText, onTapOnElement)),
          ),
        ],
      ),
    );
  }

  Widget _marker(String name, VoidCallback action) => InkWell(
    onTap: action,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.red,
            border: Border.all(
              color: Colors.white,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

  Widget _stick(
    double angle, {
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) => Positioned(
    right: right,
    top: top,
    bottom: bottom,
    left: left,
    child: Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(width: 4, height: 50, color: Colors.black),
    ),
  );

  List<Widget> _getSticks(int count) => [
    _stick(25, right: 47, top: 15),
    _stick(57, right: 35, top: 25),
    _stick(123, right: 35, bottom: 25),
    _stick(155, right: 47, bottom: 15),
    _stick(205, left: 47, bottom: 15),
    _stick(237, left: 45, bottom: 30),
    _stick(303, left: 35, top: 25),
    _stick(335, left: 47, top: 15),
  ].sublist(0, count);

  List<Widget> _getPoints(int count, String iText, ValueChanged<int> onTap) => [
    Positioned(
      right: 25,
      top: 0,
      child: _marker('$iText.1', () {
        onTap(0);
      }),
    ),
    Positioned(
      right: 0,
      top: 25,
      child: _marker('$iText.2', () {
        onTap(1);
      }),
    ),
    Positioned(
      right: 0,
      bottom: 25,
      child: _marker('$iText.3', () {
        onTap(2);
      }),
    ),
    Positioned(
      right: 25,
      bottom: 0,
      child: _marker('$iText.4', () {
        onTap(3);
      }),
    ),
    Positioned(
      left: 25,
      bottom: 0,
      child: _marker('$iText.5', () {
        onTap(4);
      }),
    ),
    Positioned(
      left: 0,
      bottom: 25,
      child: _marker('$iText.6', () {
        onTap(5);
      }),
    ),
    Positioned(
      left: 0,
      top: 25,
      child: _marker('$iText.7', () {
        onTap(6);
      }),
    ),
    Positioned(
      left: 25,
      top: 0,
      child: _marker('$iText.8', () {
        onTap(7);
      }),
    ),
  ].sublist(0, count);
}

/// single point
class MapSingleMarker {
  Marker marker(VoidCallback action, RouteSinglePointData point, int index) =>
      Marker(
        rotate: true,
        height: 40,
        width: 40,
        point: LatLng(point.lat, point.long),
        child: InkWell(
          onTap: action,
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
                (index + 1).toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}
