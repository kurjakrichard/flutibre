import 'dart:io';
import 'package:open_filex/open_filex.dart';

class FileService {
  void openFile(String path) {
    OpenFilex.open(path);
  }

  Future<File> copyFile({
    required String oldpath,
    required String newpath,
  }) async {
    File oldFile = File(oldpath);
    return await File(newpath).create(recursive: true).then((File file) {
      return oldFile.copy(newpath);
    });
  }

  Future<void> deleteBook(String oldPath) async {
    Directory dir = Directory(oldPath);
    Directory parentDir = dir.parent;
    await dir.delete(recursive: true);
    bool isEmpty = await Directory(parentDir.path).list().isEmpty;
    if (isEmpty) {
      parentDir.delete(recursive: true);
    }
  }
}
