import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';

class PointFullDetailsScreen extends StatefulWidget {
  const PointFullDetailsScreen({required this.pointId, super.key});

  final String pointId;

  @override
  State<PointFullDetailsScreen> createState() => _PointFullDetailsScreenState();
}

class _PointFullDetailsScreenState extends State<PointFullDetailsScreen> {
  late final RouteSinglePointData _point;

  @override
  void initState() {
    _point = Dependencies.of(
      context,
    ).routesRepository.getSinglePointById(widget.pointId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final split = _point.fullDescription.split('||');

    return Scaffold(
      appBar: TripleAppBar(
        context,
        title: _point.pointName,
        leadingFunction: () {
          context.pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...split.map((e) {
                if (e.startsWith('image:')) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Image.asset('assets/images/${e.substring(6)}'),
                    ),
                  );
                }

                if (e.startsWith('quote:')) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
                    child: SelectableText(
                      e.substring(6),
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                if (e.startsWith('poetry:')) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 50,
                      top: 16,
                      bottom: 16,
                    ),
                    child: SelectableText(
                      e.substring(7),
                      textAlign: TextAlign.start,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                if (e.startsWith('padding:')) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SelectableText(
                      e.substring(8),
                      textAlign: TextAlign.start,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                if (e.isEmpty) return const SizedBox();

                return SelectableText(
                  e,
                  textAlign: TextAlign.justify,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              const SizedBox(height: 16),
              if (_point.fullDescription.isNotEmpty)
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.navigate_before), Text('Назад')],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
