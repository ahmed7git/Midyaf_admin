import 'package:admin/core/constant/app_env.dart';

class Applink {
  static const String server = AppEnv.serverUrl;

  //============================== Images ======================//
  static const String images = "$server/upload";
  static const String categoriesImage = "$images/categories";
  static const String itemsImage = "$images/items";

  //============================== Auth ======================//
  static const String login = "$server/admin/auth/login.php";
  static const String home = "$server/admin/auth/home.php";
  static const String verfiyCode = "$server/admin/verfiycode.php";

  //============================= Categories ==========================//
  static const String addCategory = "$server/admin/categories/add.php";
  static const String viewCategory = "$server/admin/categories/view.php";
  static const String deleteCategory = "$server/admin/categories/delete.php";
  static const String editCategory = "$server/admin/categories/edit.php";

  //============================= Items & Inventory ==========================//
  static const String addItem = "$server/admin/items/add.php";
  static const String viewItems = "$server/admin/items/view.php";
  static const String deleteItem = "$server/admin/items/delete.php";
  static const String editItem = "$server/admin/items/edit.php";
  static const String updateStock = "$server/admin/items/update_stock.php";

  //============================= Users & Drivers ==========================//
  static const String addUser = "$server/admin/users/add.php";
  static const String viewUser = "$server/admin/users/view.php";
  static const String deleteUser = "$server/admin/users/delete.php";
  static const String editUser = "$server/admin/users/edit.php";
  static const String viewDrivers = "$server/admin/delivery/view.php";

  //============================= Orders & Flowchart ==========================//
  static const String order = "$server/admin/order/order.php";
  static const String orderadminaccepte = "$server/admin/not/pendind.php";
  static const String orderaccepted = "$server/admin/order/orderaccpted.php";
  static const String orderdetils = "$server/admin/order/orderdetils.php";
  static const String orderdelete = "$server/admin/order/delete.php";
  static const String orderrate = "$server/admin/order/orderrateing.php";
  static const String updateOrderStatus = "$server/admin/order/update_status.php";
  static const String assignDriver = "$server/admin/order/assign_driver.php";

  //============================= Notifications ==========================//
  static const String notification = "$server/notification/notification.php";
  static const String sendNotification = "$server/admin/notification/send.php";

  //============================= Admin Dashboard & Analytics ==========================//
  static const String adminDashboard = "$server/admin/home/dashboard.php";

  //============================= Coupons ==========================//
  static const String viewCoupon = "$server/admin/coupon/view.php";
  static const String addCoupon = "$server/admin/coupon/add.php";
  static const String deleteCoupon = "$server/admin/coupon/delete.php";
  static const String editCoupon = "$server/admin/coupon/edit.php";

  //============================= Slider & Banners ==========================//
  static const String viewSlider = "$server/admin/slider/view.php";
  static const String addSlider = "$server/admin/slider/add.php";
  static const String deleteSlider = "$server/admin/slider/delete.php";
  static const String editSlider = "$server/admin/slider/edit.php";
  static const String sliderImage = "$images/slider";
}
