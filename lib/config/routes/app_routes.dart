import 'package:go_router/go_router.dart';
import '../../screens/screens.dart';
import '../config.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: Home.builder,
  ),
  GoRoute(
    path: RouteLocation.bookDetails,
    parentNavigatorKey: navigationKey,
    builder: BookDetails.builder,
  ),
  GoRoute(
    path: RouteLocation.updateBook,
    parentNavigatorKey: navigationKey,
    builder: UpdateBook.builder,
  ),
];
