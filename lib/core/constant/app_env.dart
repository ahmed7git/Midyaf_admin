/// 🔐 إدارة المفاتيح الحساسة ومتغيرات البيئة بأمان (Environment & Secrets Management)
/// يتم حقن القيم في وقت التشغيل أو البناء عبر `--dart-define` أو `--dart-define-from-file=.env`
class AppEnv {
  /// الرابط الأساسي لسيرفر الباك إند
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://wicmn.alwaysdata.net/delever',
  );

  /// مفتاح خرائط جوجل أو Mapbox إن وجد
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  /// مفتاح ترخيص الإشعارات أو الخدمات الإضافية
  static const String appSecretKey = String.fromEnvironment(
    'APP_SECRET_KEY',
    defaultValue: '',
  );

  /// توكن خريطة Mapbox لتتبع حركة السائقين ومسار الطلبات
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: 'pk.eyJ1Ijoid2ljbW4iLCJhIjoiY21ydnBhNXN1MHJjaTJ4c2NsMTVzZnByMSJ9.r4GmKGZtnUX9AOVwcsPHxQ',
  );
}
