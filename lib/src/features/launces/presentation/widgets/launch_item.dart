import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex/src/core/core.dart';

import '../../data/models/models.dart';

class LaunchItem extends StatelessWidget {
  const LaunchItem({
    super.key,
    required this.launch,
  });

  final LaunchModel launch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushRoute(LaunchDetailsRoute(id: launch.id, missionName: launch.name)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      launch.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      launch.dateString,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Skeleton.shade(
                      shade: true,
                      child: Chip(
                        label: Text(launch.status),
                        backgroundColor: launch.color,
                        shape: const StadiumBorder(),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
            if (launch.links.patch.small.isNotEmpty) ...[
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CachedNetworkImage(
                  imageUrl: launch.links.patch.small,
                  cacheKey: 'launch-${launch.id}-small-patch-${launch.links.patch.small}',
                  width: 80,
                  height: 80,
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
