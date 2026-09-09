class ItemsModel {
  int itemsId;
  int itemsCategories;
  String itemsName;
  String itemsNameAr;
  String itemsDesc;
  String itemsDescrAr;
  String itemsImages;
  int itemsCount;
  int itemsActive;
  int itemsPrice;
  int itemsDiscount;
  String itemsDate;

  ItemsModel(
      {
       required this.itemsId,
      required this.itemsCategories,
      required this.itemsName,
      required this.itemsNameAr,
      required this.itemsDesc,
      required this.itemsDescrAr,
      required this.itemsImages,
      required this.itemsCount,
      required this.itemsActive,
      required this.itemsPrice,
      required this.itemsDiscount,
      required this.itemsDate});

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      itemsId: json['items_id'],
      itemsCategories: json['items_categories'],
      itemsName: json['items_name'],
      itemsNameAr: json['items_name_ar'],
      itemsDesc: json['items_desc'],
      itemsDescrAr: json['items_descr_ar'],
      itemsImages: json['items_images'],
      itemsCount: json['items_count'],
      itemsActive: json['items_active'],
      itemsPrice: json['items_price'],
      itemsDiscount: json['items_discount'],
      itemsDate: json['items_date']
    );
  }


}