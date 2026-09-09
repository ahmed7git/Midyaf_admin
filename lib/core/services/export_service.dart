import 'dart:io';
import 'package:admin/data/model/admin_dashboard_model.dart';
import 'package:admin/data/model/order_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportReportService {
  // 1. تصدير لوحة القيادة إلى Excel
  static Future<void> exportDashboardToExcel(AdminDashboardModel? dashboard) async {
    try {
      if (dashboard == null) {
        Get.snackbar("تنبيه", "لا توجد بيانات متاحة للتصدير حالياً");
        return;
      }

      final StringBuffer csv = StringBuffer();
      csv.write('\uFEFF'); // دعم الحروف العربية

      csv.writeln("تقرير لوحة القيادة والإيرادات الشامل");
      csv.writeln("تاريخ التصدير,${DateTime.now().toString().split('.')[0]}");
      csv.writeln("");

      csv.writeln("المؤشر,القيمة");
      csv.writeln("إجمالي الإيرادات,${dashboard.overview.totalRevenue.toStringAsFixed(2)} ر.س");
      csv.writeln("إجمالي الطلبات,${dashboard.overview.totalOrders}");
      csv.writeln("متوسط السلة,${dashboard.overview.averageOrderValue.toStringAsFixed(2)} ر.س");
      csv.writeln("إجمالي المستخدمين,${dashboard.overview.totalUsers}");
      csv.writeln("الكباتن النشطين,${dashboard.overview.activeDrivers}");
      csv.writeln("معدل النمو,${dashboard.overview.growthPercentage}%");
      csv.writeln("");

      csv.writeln("حالة الطلب,العدد");
      csv.writeln("بانتظار الموافقة,${dashboard.orderStats.pending}");
      csv.writeln("قيد التجهيز,${dashboard.orderStats.preparing}");
      csv.writeln("جاهز للتسليم,${dashboard.orderStats.ready}");
      csv.writeln("مع المندوب,${dashboard.orderStats.onTheWay}");
      csv.writeln("مكتمل,${dashboard.orderStats.delivered}");
      csv.writeln("ملغي,${dashboard.orderStats.cancelled}");
      csv.writeln("");

      csv.writeln("المخزون,العدد");
      csv.writeln("متوفر بالمخزن,${dashboard.stockStats.inStock}");
      csv.writeln("قارب على النفاد,${dashboard.stockStats.lowStock}");
      csv.writeln("نفد من المخزن,${dashboard.stockStats.outOfStock}");
      csv.writeln("إجمالي المنتجات,${dashboard.stockStats.totalProducts}");
      csv.writeln("");

      csv.writeln("اليوم,التاريخ,المبلغ (ر.س),عدد الطلبات");
      for (var point in dashboard.chartData) {
        csv.writeln("${point.dayName},${point.date},${point.amount},${point.orderCount}");
      }

      final directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/dashboard_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(filePath);
      await file.writeAsString(csv.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: 'تقرير لوحة القيادة والإيرادات',
        ),
      );
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تصدير الملف: $e");
    }
  }

  // 2. تصدير قائمة الطلبات إلى Excel
  static Future<void> exportOrdersToExcel(List<OrderModel> orders) async {
    try {
      if (orders.isEmpty) {
        Get.snackbar("تنبيه", "لا توجد طلبات لتصديرها");
        return;
      }

      final StringBuffer csv = StringBuffer();
      csv.write('\uFEFF');
      csv.writeln("رقم الطلب,العميل,طريقة الدفع,نوع التوصيل,السعر,التوصيل,الإجمالي,الحالة,تاريخ الطلب");

      for (var order in orders) {
        String statusText;
        switch (order.orderStatus) {
          case 0: statusText = "بانتظار الموافقة"; break;
          case 1: statusText = "قيد التجهيز"; break;
          case 2: statusText = "جاهز"; break;
          case 3: statusText = "مع المندوب"; break;
          case 4: statusText = "مكتمل"; break;
          default: statusText = "ملغي";
        }

        csv.writeln(
          '${order.orderId},"${order.orderUserid}","${order.orderPaymentmethod == 1 ? 'بطاقة' : 'كاش'}","${order.orderType == 1 ? 'استلام' : 'توصيل'}",${order.orderPrice ?? 0},${order.orderDelivery ?? 0},${order.totalForDisplay},"$statusText","${order.orderCreated ?? ''}"',
        );
      }

      final directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/orders_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(filePath);
      await file.writeAsString(csv.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: 'تقرير الطلبات الشامل',
        ),
      );
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تصدير تقرير الطلبات: $e");
    }
  }

  // 3. تصدير ملخص إداري منسق
  static Future<void> exportReportPDF(AdminDashboardModel? dashboard) async {
    try {
      if (dashboard == null) {
        Get.snackbar("تنبيه", "لا توجد بيانات متاحة حالياً");
        return;
      }

      final StringBuffer doc = StringBuffer();
      doc.writeln("================================================");
      doc.writeln("           تقرير الإدارة والعمليات الشامل         ");
      doc.writeln("================================================");
      doc.writeln("التاريخ: ${DateTime.now().toString().split('.')[0]}");
      doc.writeln("------------------------------------------------");
      doc.writeln("📊 ملخص الإيرادات والمبيعات:");
      doc.writeln("  - إجمالي الإيرادات: ${dashboard.overview.totalRevenue.toStringAsFixed(2)} ر.س");
      doc.writeln("  - إجمالي الطلبات: ${dashboard.overview.totalOrders} طلب");
      doc.writeln("  - متوسط قيمة الطلب: ${dashboard.overview.averageOrderValue.toStringAsFixed(2)} ر.س");
      doc.writeln("  - عدد المستخدمين: ${dashboard.overview.totalUsers}");
      doc.writeln("  - الكباتن النشطين: ${dashboard.overview.activeDrivers}");
      doc.writeln("  - نسبة النمو: ${dashboard.overview.growthPercentage}%");
      doc.writeln("------------------------------------------------");
      doc.writeln("📦 تقرير المخزون:");
      doc.writeln("  - أصناف متوفرة: ${dashboard.stockStats.inStock}");
      doc.writeln("  - أصناف قاربت على النفاد: ${dashboard.stockStats.lowStock}");
      doc.writeln("  - أصناف نفدت: ${dashboard.stockStats.outOfStock}");
      doc.writeln("  - إجمالي المنتجات: ${dashboard.stockStats.totalProducts}");
      doc.writeln("------------------------------------------------");
      doc.writeln("🚚 حالات الطلبات:");
      doc.writeln("  - بانتظار الموافقة: ${dashboard.orderStats.pending}");
      doc.writeln("  - قيد التجهيز: ${dashboard.orderStats.preparing}");
      doc.writeln("  - مع الكابتن: ${dashboard.orderStats.onTheWay}");
      doc.writeln("  - مكتملة: ${dashboard.orderStats.delivered}");
      doc.writeln("================================================");

      final directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/management_summary_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(filePath);
      await file.writeAsString(doc.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: 'ملخص التقرير الإداري',
        ),
      );
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تصدير التقرير: $e");
    }
  }
}