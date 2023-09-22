import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';

export 'router.gr.dart';

@AutoRouterConfig()
@singleton
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LaunchRouter.page,
          path: '/',
          initial: true,
          children: [
            AutoRoute(
              page: LaunchRoute.page,
              path: 'launches',
              initial: true,
            ),
            AutoRoute(
              page: LaunchDetailsRoute.page,
              path: 'launches/:id',
            ),
            RedirectRoute(path: '*', redirectTo: 'launches'),
          ],
        ),
      ];
}
