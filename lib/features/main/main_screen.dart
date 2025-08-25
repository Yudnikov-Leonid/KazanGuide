import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/main/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(
      context,
      title: "Tri",
      textStyle: TextStyle(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.light
                ? AppColors.green
                : Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    body: BlocProvider<MainBloc>(
      create: (context) => MainBloc()..add(MainEventLoad()),
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
                    children: state.data.map<Widget>(_Item.new).toList(),
                  );
                } else {
                  return GridView.count(
                    padding: const EdgeInsets.all(8),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.7 / 1,
                    children: state.data.map<Widget>(_Item.new).toList(),
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
  const _Item(this.route);

  final RouteData route;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      AppNavigator.push(context, RouteDetailsPage(route));
    },
    child: Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.red,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              route.routeName,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Image.asset(
            'assets/images/${route.routeImage}',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
