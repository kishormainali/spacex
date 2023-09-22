import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/presentation/widgets/spacex_search_bar.dart';

import '../blocs/launches/launch_bloc.dart';
import '../widgets/launch_list.dart';

@RoutePage()
class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaunchBloc>(
      create: (context) => getIt<LaunchBloc>()..get(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SpaceX Launches'),
        ),
        backgroundColor: Colors.black,
        body: const Column(
          children: [
            SpaceXSearchBar(),
            SizedBox(height: 20),
            Expanded(child: LaunchList()),
          ],
        ),
      ),
    );
  }
}
