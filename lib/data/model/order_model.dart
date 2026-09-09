class OrderModel {
  int? cartId, cartOrder, cartCount, itemsId;
  double? itemsPrice, itemsDiscount;
  String? itemsName, itemsNameAr, itemsImages;

  int? orderId,
      orderUserid,
      orderAddressid,
      orderType,
      orderCoupon,
      orderStatus,
      orderPaymentmethod;
  double? orderDelivery, orderPrice, orderTotalprice, orderRateing;
  String? orderCreated, orderNotrateing;

  int? addressId, addressUserid;
  String? addressName, addressCity, addressStreet, addressCreated;
  double? addressLat, addressLong;

  String? couponName;
  double? couponDiscount;
  double? itemDiscountedPrice, finalTotalPrice;

  // 👤 بيانات العميل (Customer Details)
  String? userName, userPhone, userEmail;

  OrderModel({
    this.cartId,
    this.cartOrder,
    this.cartCount,
    this.itemsId,
    this.itemsName,
    this.itemsNameAr,
    this.itemsImages,
    this.itemsPrice,
    this.itemsDiscount,
    this.orderId,
    this.orderUserid,
    this.orderAddressid,
    this.orderType,
    this.orderDelivery,
    this.orderPrice,
    this.orderCoupon,
    this.orderCreated,
    this.orderStatus,
    this.orderPaymentmethod,
    this.orderTotalprice,
    this.orderRateing,
    this.orderNotrateing,
    this.addressId,
    this.addressName,
    this.addressCity,
    this.addressStreet,
    this.addressLat,
    this.addressLong,
    this.addressUserid,
    this.addressCreated,
    this.couponName,
    this.couponDiscount,
    this.itemDiscountedPrice,
    this.finalTotalPrice,
    this.userName,
    this.userPhone,
    this.userEmail,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final double? rawItemPrice = double.tryParse(
        json['items_price']?.toString() ??
        json['itemsprice']?.toString() ??
        json['item_price']?.toString() ??
        json['price']?.toString() ??
        '');

    final double? rawDiscount = double.tryParse(
        json['items_discount']?.toString() ??
        json['itemsdiscount']?.toString() ??
        json['discount']?.toString() ??
        '');

    final double? rawItemPriceDiscount = double.tryParse(
        json['items_pricediscount']?.toString() ??
        json['itemspricediscount']?.toString() ??
        json['item_pricediscount']?.toString() ??
        '');

    final double? rawItemTotalPrice = double.tryParse(
        json['final_total_price']?.toString() ??
        json['itemstotalprice']?.toString() ??
        json['itemprice']?.toString() ??
        json['itemspricecount']?.toString() ??
        '');

    final double? parsedLat = double.tryParse(
        json['address_lat']?.toString() ??
        json['addresslat']?.toString() ??
        json['lat']?.toString() ??
        '');

    final double? parsedLong = double.tryParse(
        json['address_long']?.toString() ??
        json['addresslong']?.toString() ??
        json['long']?.toString() ??
        '');

    return OrderModel(
      cartId: int.tryParse(json['cart_id']?.toString() ?? json['cartid']?.toString() ?? ''),
      cartOrder: int.tryParse(json['cart_order']?.toString() ?? json['cartorders']?.toString() ?? ''),
      cartCount: int.tryParse(json['cart_count']?.toString() ?? json['countitems']?.toString() ?? json['cartcount']?.toString() ?? '') ?? 1,
      itemsId: int.tryParse(json['items_id']?.toString() ?? json['itemsid']?.toString() ?? ''),
      itemsName: (json['items_name'] ?? json['itemsname'])?.toString(),
      itemsNameAr: (json['items_name_ar'] ?? json['itemsname_ar'] ?? json['itemsnamear'])?.toString(),
      itemsImages: (json['items_images'] ?? json['itemsimage'] ?? json['items_image'])?.toString(),
      itemsPrice: rawItemPrice,
      itemsDiscount: rawDiscount,
      orderId: int.tryParse(json['order_id']?.toString() ?? json['orders_id']?.toString() ?? ''),
      orderUserid: int.tryParse(
        json['order_userid']?.toString() ??
        json['orders_usersid']?.toString() ??
        json['orders_userid']?.toString() ??
        json['users_id']?.toString() ??
        json['usersid']?.toString() ??
        json['user_id']?.toString() ??
        json['address_userid']?.toString() ??
        ''),
      orderAddressid: int.tryParse(json['order_addressid']?.toString() ?? json['orders_address']?.toString() ?? ''),
      orderType: int.tryParse(json['order_type']?.toString() ?? json['orders_type']?.toString() ?? ''),
      orderDelivery: double.tryParse(json['order_delivery']?.toString() ?? json['orders_pricedelivery']?.toString() ?? ''),
      orderPrice: double.tryParse(json['order_price']?.toString() ?? json['orders_price']?.toString() ?? ''),
      orderCoupon: int.tryParse(json['order_coupon']?.toString() ?? json['orders_coupon']?.toString() ?? ''),
      orderCreated: (json['order_created'] ?? json['orders_datetime'] ?? json['orders_created'])?.toString(),
      orderNotrateing: (json['order_notrateing'] ?? json['orders_notrating'])?.toString(),
      orderStatus: int.tryParse(json['order_status']?.toString() ?? json['orders_status']?.toString() ?? ''),
      orderPaymentmethod: int.tryParse(json['order_paymentmethod']?.toString() ?? json['orders_paymentmethod']?.toString() ?? ''),
      orderTotalprice: double.tryParse(json['order_totalprice']?.toString() ?? json['orders_totalprice']?.toString() ?? ''),
      orderRateing: double.tryParse(json['order_rateing']?.toString() ?? json['orders_rating']?.toString() ?? ''),
      addressId: int.tryParse(json['address_id']?.toString() ?? ''),
      addressName: json['address_name']?.toString(),
      addressCity: json['address_city']?.toString(),
      addressStreet: json['address_street']?.toString(),
      addressLat: parsedLat,
      addressLong: parsedLong,
      addressUserid: int.tryParse(json['address_userid']?.toString() ?? ''),
      addressCreated: json['address_created']?.toString(),
      couponName: (json['coupon_name'] ?? json['couponname'] ?? json['coupon_title'])?.toString(),
      couponDiscount: double.tryParse(
          json['coupon_discount']?.toString() ??
          json['coupondiscount']?.toString() ??
          json['coupon_count']?.toString() ??
          ''),
      itemDiscountedPrice: rawItemPriceDiscount,
      finalTotalPrice: rawItemTotalPrice,
      userName: (json['users_name'] ?? json['user_name'] ?? json['username'] ?? json['customer_name'])?.toString(),
      userPhone: (json['users_phone'] ?? json['user_phone'] ?? json['phone'] ?? json['customer_phone'])?.toString(),
      userEmail: (json['users_email'] ?? json['user_email'] ?? json['email'] ?? json['customer_email'])?.toString(),
    );
  }

  double get itemRowTotal {
    if (finalTotalPrice != null && finalTotalPrice! > 0) {
      return finalTotalPrice!;
    }
    if (itemDiscountedPrice != null && itemDiscountedPrice! > 0) {
      return itemDiscountedPrice! * (cartCount ?? 1);
    }
    if (itemsPrice != null && itemsPrice! > 0) {
      double unit = itemsPrice!;
      if (itemsDiscount != null && itemsDiscount! > 0) {
        unit = unit - (unit * itemsDiscount! / 100);
      }
      return unit * (cartCount ?? 1);
    }
    return 0.0;
  }

  double get totalForDisplay =>
      orderTotalprice ?? ((orderPrice ?? 0.0) + (orderDelivery ?? 0.0));
}
