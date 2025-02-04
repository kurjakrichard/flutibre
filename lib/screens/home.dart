// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutibre/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import '../config/config.dart';
import '../data/data_export.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';

class Home extends ConsumerStatefulWidget {
  static Home builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const Home();
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Book? selectedBook;
  PlatformFile? _pickedfile;
  // ignore: unused_field
  bool _isLoading = false;
  FileService fileService = FileService();
  var allowedExtensions = ['pdf', 'odt', 'epub', 'mobi'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Desktop'),
        ),
        drawer: isDesktop ? null : const SideMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Book? newBook = await pickFile();
            if (newBook != null) {
              // ignore: use_build_context_synchronously
              _insertBook(newBook, context);
            }
          },
          child: const Icon(Icons.add),
        ),
        body: (isMobile)
            ? SafeArea(child: bookList())
            : isTablet
                ? Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: bookList(count: 1.5),
                      ),
                      const VerticalDivider(
                        thickness: 4,
                        color: Colors.transparent,
                      ),
                      Expanded(
                        flex: 1,
                        child: bookDetails(),
                      )
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SideMenu(),
                      ),
                      Expanded(
                        flex: 5,
                        child: bookList(count: 1.5),
                      ),
                      Expanded(
                        flex: 2,
                        child: bookDetails(),
                      )
                    ],
                  ));
  }

  Widget sideBar() {
    return const Center(child: Text('SideBar'));
  }

  Widget bookDetails() {
    return const Detail(
      isPage: false,
    );
  }

  Widget bookList({double count = 1.0}) {
    return GridList(count: count);
  }

  void _insertBook(Book book, BuildContext context) async {
    await ref.read(booksProvider.notifier).addBook(book).then((value) async {
      // ignore: use_build_context_synchronously
      AppAlerts.displaySnackbar(context, 'Update book successfully');
      Book? selectedBook =
          await ref.read(booksProvider.notifier).getBook(value!);
      ref.read(selectedBookProvider.notifier).setSelectedBook(selectedBook!);
      // ignore: use_build_context_synchronously
      context.go(RouteLocation.home);
    });
  }

  Future<Book?> pickFile() async {
    Book? newBook;
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: allowedExtensions);

      if (result != null) {
        _pickedfile = result.files.first;
        // ignore: avoid_print
        print('Name: ${_pickedfile!.name}');
        // ignore: avoid_print
        print('Bytes: ${_pickedfile!.bytes}');
        // ignore: avoid_print
        print('Size: ${_pickedfile!.size}');
        // ignore: avoid_print
        print('Extension: ${_pickedfile!.extension}');
        // ignore: avoid_print
        print('Path: ${_pickedfile!.path}');
        String title = p.basenameWithoutExtension(_pickedfile!.name);
        String format = _pickedfile!.extension.toString();
        String author = 'Unknown author';
        String filename =
            '${removeDiacritics(author)} - ${removeDiacritics(title)}';
        String path = '${removeDiacritics(author)}/${removeDiacritics(title)}';
        newBook = Book(
          author: author,
          title: title,
          description: '',
          image: 'res/corel.jpg',
          last_modified: '',
          path: path,
          filename: filename,
          format: format,
          pages: 0,
          price: '',
          rating: 0,
        );

        await fileService.copyFile(
            oldpath: _pickedfile!.path!,
            newpath:
                '/home/sire/Dokumentumok/ebooks/${newBook.path}/${newBook.filename}.${newBook.format}');
        //await fileService.addFile(_pickedfile);
        //fileService.openFile(_pickedfile!.path!);
      } else {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return newBook;
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
    format: 'epub',
    path: 'res/Richard Powers - Orfeo.epub',
    filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
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
      format: 'epub',
      path: 'res/Richard Powers - Orfeo.epub',
      filename: 'res/Richard Powers - Orfeo.epub',
      last_modified: '',
      description: details,
      rating: 3.5,
      pages: 431),
];
