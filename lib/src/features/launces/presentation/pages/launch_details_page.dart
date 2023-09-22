import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';

import '../blocs/details/launch_detail_cubit.dart';

@RoutePage()
class LaunchDetailsPage extends StatelessWidget {
  const LaunchDetailsPage({
    super.key,
    required this.id,
    required this.missionName,
  });

  final String id;
  final String missionName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaunchDetailCubit>(
      create: (context) => getIt<LaunchDetailCubit>()..getLaunchById(id),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(missionName),
        ),
        body: BlocBuilder<LaunchDetailCubit, LaunchDetailState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => Skeletonizer(
                  child: _LaunchDetails(
                launch: LaunchDetailModel.fake(),
              )),
              error: (message) => Center(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              success: (launch) {
                return _LaunchDetails(launch: launch);
              },
            );
          },
        ),
      ),
    );
  }
}

class _LaunchDetails extends StatelessWidget {
  const _LaunchDetails({required this.launch});
  final LaunchDetailModel launch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (launch.links.patch.large.isNotEmpty) ...[
            Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF5F5F7),
              ),
              child: CachedNetworkImage(
                imageUrl: launch.links.patch.large,
                width: MediaQuery.sizeOf(context).width,
                height: 200,
                fit: BoxFit.contain,
                cacheKey: 'launch_${launch.id}_large_patch_${launch.links.patch.large}',
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      launch.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      launch.dateString,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Skeleton.shade(
                shade: true,
                child: Chip(
                  label: Text(
                    launch.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: launch.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8C8C8C),
            ),
          ),
          const Divider(
            color: Color(0xFF8C8C8C),
            height: 16,
          ),
          const SizedBox(height: 8),
          Text(
            launch.details,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Rocket Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8C8C8C),
            ),
          ),
          const Divider(
            color: Color(0xFF8C8C8C),
            height: 16,
          ),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Name :',
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: Text(
                  launch.rocket!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Company :',
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: Text(
                  launch.rocket!.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Country :',
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: Text(
                  launch.rocket!.country,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Site Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8C8C8C),
            ),
          ),
          const Divider(
            color: Color(0xFF8C8C8C),
            height: 16,
          ),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Name :',
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: Text(
                  launch.site!.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
