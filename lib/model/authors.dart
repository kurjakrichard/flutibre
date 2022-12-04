class Authors {
  int id;
  String name;
  String? sort;
  String link;

  Authors({
    required this.id,
    required this.name,
    this.sort,
    this.link = '',
  });

  Authors.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        sort = res["sort"],
        link = res["link"];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'sort': sort,
      'link': link,
    };
  }
}
