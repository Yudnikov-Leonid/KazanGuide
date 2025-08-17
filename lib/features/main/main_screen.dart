import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazan_guide/core/data/route_data.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/triple_app_bar.dart';
import 'package:kazan_guide/features/main/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TripleAppBar(context, title: "Tri"),
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
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: state.data.map<Widget>(_Item.new).toList(),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    ),
  );
}

class _Item extends StatelessWidget {
  const _Item(this.data);

  final RouteData data;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: AppColors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            data.routeName,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      Container(height: 180, color: Colors.amber),
    ],
  );
}
