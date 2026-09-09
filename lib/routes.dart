import 'package:admin/bindings/home_binding.dart';
import 'package:admin/bindings/items_binding.dart';
import 'package:admin/bindings/login_binding.dart';
import 'package:admin/core/constant/reoute.dart';
import 'package:admin/screen/view/auth/login.dart';
import 'package:admin/screen/view/category/addcategories.dart';
import 'package:admin/screen/view/category/categories.dart';
import 'package:admin/screen/view/category/editcategories.dart';
import 'package:admin/screen/view/homenav.dart';
import 'package:admin/screen/view/items/additems.dart';
import 'package:admin/screen/view/items/edititems.dart';
import 'package:admin/screen/view/items/items.dart';
import 'package:admin/screen/view/notificatio/notipage.dart';
import 'package:admin/screen/view/order/TrackingScreen.dart';
import 'package:admin/screen/view/order/orderdetils.dart';
import 'package:admin/screen/view/splash/splash_screen.dart';
import 'package:admin/screen/view/users/adduser.dart';
import 'package:admin/screen/view/users/viewuser.dart';
import 'package:admin/screen/widgets/order/orderhome/homeorder.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
  GetPage(name: AppRoutes.login, page: () => const Login(), binding: LoginBinding()),
  GetPage(name: AppRoutes.home, page: () => const Homenav(), binding: HomeBinding()),
  GetPage(name: AppRoutes.categories, page: () => const Categories()),
  GetPage(name: AppRoutes.items, page: () => const Items(), binding: ItemsBinding()),
  GetPage(name: AppRoutes.addUser, page: () => const AddUser()),
  GetPage(name: AppRoutes.viewUser, page: () => const ViewUser()),
  GetPage(name: AppRoutes.addcategory, page: () => const AddCategories()),
  GetPage(name: AppRoutes.editcategory, page: () => const EditCategory()),
  GetPage(name: AppRoutes.additem, page: () => const AddItem()),
  GetPage(name: AppRoutes.edititem, page: () => const Edititems()),
  GetPage(name: AppRoutes.orders, page: () => const OrderHome()),
  GetPage(name: AppRoutes.orderdetil, page: () => const Orderdetils()),
  GetPage(name: AppRoutes.tracking, page: () => const TrackingScreen()),
  GetPage(name: AppRoutes.notifications, page: () => const Notipage()),
];