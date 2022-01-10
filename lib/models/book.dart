class Book {
  int? id;
  String title;
  String? sort;
  String? timesamp;
  String? pubdate;
  String? seriesIndex;
  String authorSort;
  String? isbn;
  String? lccn;
  String path;
  int? flags;
  String? uuid;
  bool? hasCover;
  String? lastModified;

  get getId => this.id;
  set setId(id) => this.id = id;
  get getTitle => this.title;
  set setTitle(title) => this.title = title;
  get getSort => this.sort;
  set setSort(sort) => this.sort = sort;
  get getTimesamp => this.timesamp;
  set setTimesamp(timesamp) => this.timesamp = timesamp;
  get getPubdate => this.pubdate;
  set setPubdate(pubdate) => this.pubdate = pubdate;
  get getSeriesIndex => this.seriesIndex;
  set setSeriesIndex(seriesIndex) => this.seriesIndex = seriesIndex;
  get getAuthorSort => this.authorSort;
  set setAuthorSort(authorSort) => this.authorSort = authorSort;
  get getIsbn => this.isbn;
  set setIsbn(isbn) => this.isbn = isbn;
  get getLccn => this.lccn;
  set setLccn(lccn) => this.lccn = lccn;
  get getPath => this.path;
  set setPath(path) => this.path = path;
  get getFlags => this.flags;
  set setFlags(flags) => this.flags = flags;
  get getUuid => this.uuid;
  set setUuid(uuid) => this.uuid = uuid;
  get getHasCover => this.hasCover;
  set setHasCover(hasCover) => this.hasCover = hasCover;
  get getLastModified => this.lastModified;
  set setLastModified(lastModified) => this.lastModified = lastModified;

  Book({
    required this.title,
    required this.authorSort,
    required this.path,
  });

  Book.withId(
    this.id,
    this.title,
    this.authorSort,
    this.path,
  );

  // Convert a Book object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['path'] = path;

    return map;
  }

  // Convert a Map object into a Book object
  /** Book.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    authorSort = map['authorSort'];
    path = map['path'];
  }**/
}
