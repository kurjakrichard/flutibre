import 'package:go_router/go_router.dart';
import '../../screens/screens.dart';
import '../config.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: Home.builder,
  ),
  GoRoute(
    path: RouteLocation.insertBook,
    parentNavigatorKey: navigationKey,
    builder: InsertBook.builder,
  ),
  GoRoute(
    path: RouteLocation.updateBook,
    parentNavigatorKey: navigationKey,
    builder: UpdateBook.builder,
  ),
];
