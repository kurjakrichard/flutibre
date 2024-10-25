import 'package:flutibre/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/data_export.dart';
import '../utils/utils.dart';
import 'screens.dart';

class Home extends ConsumerWidget {
  static Home builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const Home();
  const Home({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return MobileHome(bookList: bookList());
    } else if (isTablet) {
      return TabletHome(
        bookList: bookList(count: 1.5),
        bookDetail: bookDetails(),
      );
    } else if (isDesktop) {
      return DesktopHome(
        bookList: bookList(count: 1.5),
        bookDetail: bookDetails(),
      );
    } else {
      return DesktopHome(
        bookList: bookList(count: 1.5),
        bookDetail: bookDetails(),
      );
    }
  }

  Widget sideBar() {
    return const Center(child: Text('SideBar'));
  }

  Widget bookDetails() {
    return const Detail();
  }

  Widget bookList({double count = 1.0}) {
    return GridList(count: count);
  }
}

String details =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id neque libero. Donec finibus sem viverra, luctus nisi ac, semper enim. Vestibulum in mi feugiat, mattis erat suscipit, fermentum quam. Mauris non urna sed odio congue rhoncus. \nAliquam a dignissim ex. Suspendisse et sem porta, consequat dui et, placerat tortor. Sed elementum nunc a blandit euismod. Cras condimentum faucibus dolor. Etiam interdum egestas sagittis. Aliquam vitae molestie eros. Cras porta felis ac eros pellentesque, sed lobortis mi eleifend. Praesent ut.';

final List<Book> books = [
  Book(
    id: 1,
    title: 'CorelDraw untuk Tingkat Pemula Sampai Mahir',
    author: 'Jubilee Enterprise',
    price: 'Rp 50.000',
    image: 'res/corel.jpg',
    path: 'res/Richard Powers - Orfeo.epub',
    last_modified: '',
    description: details,
    rating: 3.5,
    pages: 123,
  ),
  Book(
      id: 2,
      title: 'Buku Pintar Drafter Untuk Pemula Hingga Mahir',
      author: 'Widada',
      price: 'Rp 55.000',
      image: 'res/drafter.jpg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 4.5,
      pages: 200),
  Book(
      id: 3,
      title: 'Adobe InDesign: Seri Panduan Terlengkap',
      author: 'Jubilee Enterprise',
      price: 'Rp 60.000',
      image: 'res/indesign.jpg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 5.0,
      pages: 324),
  Book(
      id: 4,
      title: 'Pemodelan Objek Dengan 3Ds Max 2014',
      author: 'Wahana Komputer',
      price: 'Rp 58.000',
      image: 'res/max_3d.jpeg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 3.0,
      pages: 200),
  Book(
      id: 5,
      title: 'Penerapan Visualisasi 3D Dengan Autodesk Maya',
      author: 'Dhani Ariatmanto',
      price: 'Rp 90.000',
      image: 'res/maya.jpeg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 4.8,
      pages: 234),
  Book(
      id: 6,
      title: 'Teknik Lancar Menggunakan Adobe Photoshop',
      author: 'Jubilee Enterprise',
      price: 'Rp 57.000',
      image: 'res/photoshop.jpg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 4.5,
      pages: 240),
  Book(
      id: 7,
      title: 'Adobe Premiere Terlengkap dan Termudah',
      author: 'Jubilee Enterprise',
      price: 'Rp 56.000',
      image: 'res/premier.jpg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 4.8,
      pages: 432),
  Book(
      id: 8,
      title: 'Cad Series : Google Sketchup Untuk Desain 3D',
      author: 'Wahana Komputer',
      price: 'Rp 55.000',
      image: 'res/sketchup.jpeg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 4.5,
      pages: 321),
  Book(
      id: 9,
      title: 'Webmaster Series : Trik Cepat Menguasai CSS',
      author: 'Wahana Komputer',
      price: 'Rp 54.000',
      image: 'res/webmaster.jpeg',
      path: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 3.5,
      pages: 431),
];
