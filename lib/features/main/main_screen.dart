import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/data/route_data.dart' as route_data;
import 'package:kazan_guide/core/di/dependencies.dart';
import 'package:kazan_guide/core/navigation/app_routes.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/main/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(
      context,
      title: "Tri",
      textStyle: context.textTheme.bodyLarge?.copyWith(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.light
                ? AppColors.green
                : Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 26,
      ),
    ),
    body: BlocProvider<MainBloc>(
      create:
          (context) => MainBloc(
            routesRepository: Dependencies.of(context).routesRepository,
          )..add(MainEventLoad()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MainFailedState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  KButton(
                    onPressed: () {
                      context.read<MainBloc>().add(MainEventLoad());
                    },
                    child: const Text('Повторить попытку'),
                  ),
                ],
              ),
            );
          }

          if (state is MainLoadedState) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children:
                        state.data
                            .map<Widget>((e) => _Item(e, isLandscape: false))
                            .toList(),
                  );
                } else {
                  return GridView.count(
                    padding: const EdgeInsets.all(8),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,

                    /// 32 is crossAxisSpacing + padding
                    childAspectRatio: (context.screenSize.width - 32) / 2 / 236,
                    children:
                        state.data
                            .map<Widget>((e) => _Item(e, isLandscape: true))
                            .toList(),
                  );
                }
              },
            );
          }

          return const SizedBox();
        },
      ),
    ),
  );
}

class _Item extends StatelessWidget {
  const _Item(this.route, {required this.isLandscape});

  final route_data.RouteData route;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) => Container(
    height: 220,
    margin: const EdgeInsets.only(bottom: 16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        // print('aspectRatio: $aspectRatio, maxWidth: ${constraints.maxWidth}, maxHeight: ${constraints.maxHeight}');
        final isExpanded = aspectRatio > 3;

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            context.pushNamed(
              AppRoutes.routeDetails,
              queryParameters: {'id': route.id},
            );
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  child: Align(
                    alignment:
                        isExpanded ? Alignment.center : Alignment.topLeft,
                    child: Text(
                      route.routeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: isExpanded ? 0 : 1,
                      child: SizedBox(
                        width: isExpanded ? 300 : null,
                        height: 180,
                        child: Image.asset(
                          'assets/images/${route.routeImage}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 6,
                                  ),
                                  child: Text(
                                    route.routeDescription,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: double.infinity,
                                color: AppColors.green,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Пройти',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
