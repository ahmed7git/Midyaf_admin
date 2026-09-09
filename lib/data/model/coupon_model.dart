class CouponModel {
  int? couponId;
  String? couponName;
  int? couponCount;
  double? couponDiscount;
  String? couponExpiredate;
  int? couponType;
  int? couponStatus;

  CouponModel({
    this.couponId,
    this.couponName,
    this.couponCount,
    this.couponDiscount,
    this.couponExpiredate,
    this.couponType = 1,
    this.couponStatus = 1,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: int.tryParse(json['coupon_id']?.toString() ?? ''),
      couponName: json['coupon_name']?.toString() ?? '',
      couponCount: int.tryParse(json['coupon_count']?.toString() ?? '0') ?? 0,
      couponDiscount: double.tryParse(json['coupon_discount']?.toString() ?? '0') ?? 0.0,
      couponExpiredate: json['coupon_expiredate']?.toString() ?? '',
      couponType: int.tryParse(json['coupon_type']?.toString() ?? '1') ?? 1,
      couponStatus: int.tryParse(json['coupon_status']?.toString() ?? '1') ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'coupon_name': couponName,
      'coupon_count': couponCount,
      'coupon_discount': couponDiscount,
      'coupon_expiredate': couponExpiredate,
      'coupon_type': couponType,
      'coupon_status': couponStatus,
    };
  }

  bool get isActive {
    if (couponStatus == 0) return false;
    if (couponExpiredate != null && couponExpiredate!.isNotEmpty) {
      try {
        final exp = DateTime.parse(couponExpiredate!);
        if (exp.isBefore(DateTime.now())) return false;
      } catch (_) {}
    }
    return (couponCount ?? 0) > 0;
  }
}
