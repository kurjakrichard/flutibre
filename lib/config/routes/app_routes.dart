import 'package:flutibre/screens/desktop/desktop_home.dart';
import 'package:go_router/go_router.dart';
import '../../screens/desktop/desktop_details.dart';
import '../config.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: DesktopHome.builder,
  ),
  GoRoute(
    path: RouteLocation.desktopDetails,
    parentNavigatorKey: navigationKey,
    builder: DesktopDetails.builder,
  ),
];
