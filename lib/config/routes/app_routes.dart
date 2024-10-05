import 'package:go_router/go_router.dart';
import '../../screens/home.dart';
import '../config.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: Home.builder,
  ),
];
