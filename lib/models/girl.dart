class ImageDetails {
  final String imagePath;
  final String price;
  final String photographer;
  final String title;
  final String details;
  bool isSelected = false;
  ImageDetails(
      {required this.imagePath,
      required this.price,
      required this.photographer,
      required this.title,
      required this.details,
      this.isSelected = false});
}
