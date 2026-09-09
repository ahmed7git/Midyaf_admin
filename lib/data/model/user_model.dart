class UserModel {
  int adminId;
  String adminName;
  String adminPhone;
  String adminEmail;
  String adminPassword;
  int adminRole;
  String adminLastLogin;
  int adminStatus;
  String adminImage;
  int adminVerfiycode;
  int adminApprove;
  String adminCreated;

  UserModel(
      {
       required this.adminId,
       required this.adminName,
       required this.adminPhone,
       required this.adminEmail,
       required this.adminPassword,
       required this.adminRole,
       required this.adminLastLogin,
       required this.adminStatus,
       required this.adminImage,
       required this.adminVerfiycode,
       required this.adminApprove,
       required this.adminCreated});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      adminId: json['admin_id'],
      adminName: json['admin_name'],
      adminPhone: json['admin_phone'],
      adminEmail: json['admin_email'],
      adminPassword: json['admin_password'],
      adminRole: json['admin_role'],
      adminLastLogin: json['admin_last_login'],
      adminStatus: json['admin_status'],
      adminImage: json['admin_image'],
      adminVerfiycode: json['admin_verfiycode'],
      adminApprove: json['admin_approve'],
      adminCreated: json['admin_created'],
    );
  }


  
}