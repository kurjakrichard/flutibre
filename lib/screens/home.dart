import 'package:flutibre/providers/providers.dart';
import 'package:flutibre/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/data_export.dart';
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
    // Use media query to get the screen size
    var screenSize = MediaQuery.of(context).size;

    // Define breakpoints for different screen sizes
    double breakpointSmall = 600.0;
    double breakpointMedium = 1100.0;

    if (screenSize.width < breakpointSmall) {
      return MobileHome(bookList: bookList(1));
    } else if (screenSize.width < breakpointMedium) {
      return TabletHome(
        bookList: bookList(1.5),
        bookDetail: bookDetails(),
      );
    } else {
      return DesktopHome(
        bookList: bookList(1.5),
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

  Widget bookList(double count) {
    return GridList(count: count, books: books);
  }
}

String details =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id neque libero. Donec finibus sem viverra, luctus nisi ac, semper enim. Vestibulum in mi feugiat, mattis erat suscipit, fermentum quam. Mauris non urna sed odio congue rhoncus. \nAliquam a dignissim ex. Suspendisse et sem porta, consequat dui et, placerat tortor. Sed elementum nunc a blandit euismod. Cras condimentum faucibus dolor. Etiam interdum egestas sagittis. Aliquam vitae molestie eros. Cras porta felis ac eros pellentesque, sed lobortis mi eleifend. Praesent ut.';

final List<Book> books = [
  Book(
      id: 1,
      title: 'CorelDraw untuk Tingkat Pemula Sampai Mahir',
      writer: 'Jubilee Enterprise',
      price: 'Rp 50.000',
      image: 'res/corel.jpg',
      description: details,
      rating: 3.5,
      pages: 123),
  Book(
      id: 2,
      title: 'Buku Pintar Drafter Untuk Pemula Hingga Mahir',
      writer: 'Widada',
      price: 'Rp 55.000',
      image: 'res/drafter.jpg',
      description: details,
      rating: 4.5,
      pages: 200),
  Book(
      id: 3,
      title: 'Adobe InDesign: Seri Panduan Terlengkap',
      writer: 'Jubilee Enterprise',
      price: 'Rp 60.000',
      image: 'res/indesign.jpg',
      description: details,
      rating: 5.0,
      pages: 324),
  Book(
      id: 4,
      title: 'Pemodelan Objek Dengan 3Ds Max 2014',
      writer: 'Wahana Komputer',
      price: 'Rp 58.000',
      image: 'res/max_3d.jpeg',
      description: details,
      rating: 3.0,
      pages: 200),
  Book(
      id: 5,
      title: 'Penerapan Visualisasi 3D Dengan Autodesk Maya',
      writer: 'Dhani Ariatmanto',
      price: 'Rp 90.000',
      image: 'res/maya.jpeg',
      description: details,
      rating: 4.8,
      pages: 234),
  Book(
      id: 6,
      title: 'Teknik Lancar Menggunakan Adobe Photoshop',
      writer: 'Jubilee Enterprise',
      price: 'Rp 57.000',
      image: 'res/photoshop.jpg',
      description: details,
      rating: 4.5,
      pages: 240),
  Book(
      id: 7,
      title: 'Adobe Premiere Terlengkap dan Termudah',
      writer: 'Jubilee Enterprise',
      price: 'Rp 56.000',
      image: 'res/premier.jpg',
      description: details,
      rating: 4.8,
      pages: 432),
  Book(
      id: 8,
      title: 'Cad Series : Google Sketchup Untuk Desain 3D',
      writer: 'Wahana Komputer',
      price: 'Rp 55.000',
      image: 'res/sketchup.jpeg',
      description: details,
      rating: 4.5,
      pages: 321),
  Book(
      id: 9,
      title: 'Webmaster Series : Trik Cepat Menguasai CSS',
      writer: 'Wahana Komputer',
      price: 'Rp 54.000',
      image: 'res/webmaster.jpeg',
      description: details,
      rating: 3.5,
      pages: 431),
];
