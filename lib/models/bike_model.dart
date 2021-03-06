class Bike {
  String? id;
  String? licensePlate;
  String? color;
  String? modelYear;
  String? ownerId;
  String? categoryId;
  int? status;
  String? ownerPhone;
  String? ownerName;
  String? address;
  double? rating;
  int? numberOfRating;
  String? brandName;
  String? categoryName;
  String? imgPath;
  String? cateName;
  Bike.empty();
  Bike(
      {required this.id,
      required this.licensePlate,
      required this.color,
      required this.modelYear,
      required this.ownerId,
      required this.categoryId,
      required this.status,
      required this.ownerPhone,
      required this.ownerName,
      required this.address,
      required this.rating,
      required this.numberOfRating,
      required this.brandName,
      required this.categoryName,
      required this.imgPath,
      this.cateName});
  factory Bike.jsonFrom(Map<String, dynamic> json) {
    return Bike(
        id: json['id'],
        licensePlate: json['licensePlate'],
        color: json['color'],
        modelYear: json['modelYear'],
        ownerId: json['ownerId'],
        categoryId: json['categoryId'],
        status: json['status'],
        ownerPhone: json['ownerPhone'] ?? "",
        ownerName: json['ownerName'] ?? "Unknow",
        address: json['address'] ?? "",
        rating: json['rating'] == null ? 0.0 : json['rating'].toDouble(),
        numberOfRating: json['numberOfRating'] ?? 0,
        brandName: json['brandName'] ?? "",
        categoryName: json['categoryName'] ?? "",
        imgPath: json['imgPath'] ?? "defaultimage.jpg",
        cateName: json['cateName'] ?? "");
  }
}
