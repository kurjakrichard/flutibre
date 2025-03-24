// ignore_for_file: non_constant_identifier_names

class Data {
  int id;
  int book;
  String format;
  int uncompressed_size;
  String name;

  Data({
    required this.id,
    required this.book,
    required this.format,
    required this.uncompressed_size,
    this.name = '',
  });

  Data.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        format = res['format'],
        uncompressed_size = res['uncompressed_size'],
        name = res['name'];

  Map<String, Object?> toMap() {
    return {
      'book': book,
      'format': format,
      'uncompressed_size': uncompressed_size,
      'name': name,
    };
  }
}
