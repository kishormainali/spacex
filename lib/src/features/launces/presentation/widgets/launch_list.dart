import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';

import '../blocs/launches/launch_bloc.dart';
import 'launch_item.dart';

class LaunchList extends StatelessWidget {
  const LaunchList({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return context.read<LaunchBloc>().refresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
            context.read<LaunchBloc>().fetchMore();
            return true;
          }
          return false;
        },
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            BlocBuilder<LaunchBloc, LaunchState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SliverFillRemaining(
                    fillOverscroll: false,
                    child: _LaunchListShimmer(),
                  ),
                  error: (message) => SliverFillRemaining(
                    fillOverscroll: false,
                    child: Center(
                      child: Text(message),
                    ),
                  ),
                  success: (launches, isFetching) {
                    if (launches.isEmpty) return const _EmptyLaunchList();
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          if (index == launches.length && isFetching) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                            );
                          }
                          final launch = launches[index];
                          return LaunchItem(launch: launch);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemCount: isFetching ? launches.length + 1 : launches.length,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLaunchList extends StatelessWidget {
  const _EmptyLaunchList();

  @override
  Widget build(BuildContext context) {
    final isFromSearch = context.watch<LaunchBloc>().searchController.text.isNotEmpty;
    return SliverFillRemaining(
      fillOverscroll: false,
      child: Center(
        child: Text(
          isFromSearch ? 'No matching launches found.' : 'Currently there are no launches.',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _LaunchListShimmer extends StatelessWidget {
  const _LaunchListShimmer();

  final LaunchModel launch = const LaunchModel(
    id: 'randomIdForShimmer',
    name: 'Random Name',
    dateLocal: '2006-03-25T10:30:00+12:00',
    success: true,
    links: LaunchLinkModel(
      patch: LaunchPatchModel(
        small: 'https://images2.imgbox.com/f9/4a/ZboXReNb_o.png',
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) => LaunchItem(launch: launch),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: 10,
      ),
    );
  }
}
