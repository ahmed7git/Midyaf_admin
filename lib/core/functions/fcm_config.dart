import 'package:admin/controller/admin/admin_dashboard_controller.dart';
import 'package:admin/controller/orders/orderaccrpted_controller.dart';
import 'package:admin/controller/orders/oreder_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> setupFCMChannels() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );
}

void showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

Future<void> requestPermissionAndSetupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showLocalNotification(message);
    requestnotifiOrder(message.data);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.subscribeToTopic("delivery");
  await FirebaseMessaging.instance.subscribeToTopic("admins");
}

Future<void> subscribeToUserTopic(String userid) async {
  await FirebaseMessaging.instance.subscribeToTopic("admins$userid");
}

/// تحديث شاشات الطلبات ولوحة التحكم تلقائياً وفورياً عند استلام أي إشعار طلب
void requestnotifiOrder(Map<String, dynamic> data) {
  // 1. تحديث صفحة الطلبات الجارية / الجديدة
  if (Get.isRegistered<OrderController>()) {
    Get.find<OrderController>().getdata(isBackground: true);
  }

  // 2. تحديث صفحة الطلبات المقبولة
  if (Get.isRegistered<OrderaccptedController>()) {
    Get.find<OrderaccptedController>().getdata(isBackground: true);
  }

  // 3. تحديث إحصائيات لوحة التحكم والعمليات
  if (Get.isRegistered<AdminDashboardControllerImp>()) {
    Get.find<AdminDashboardControllerImp>().getDashboardStats(isRefresh: true);
  }
}