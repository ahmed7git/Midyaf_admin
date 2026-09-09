import 'package:admin/data/model/order_model.dart';

class AdminDashboardModel {
  final AdminOverviewModel overview;
  final AdminOrdersStatsModel orderStats;
  final AdminStockStatsModel stockStats;
  final List<AdminSalesChartPoint> chartData;
  final List<AdminTopItemModel> topItems;
  final List<AdminLowStockItemModel> lowStockItems;
  final List<OrderModel> recentOrders;

  AdminDashboardModel({
    required this.overview,
    required this.orderStats,
    required this.stockStats,
    required this.chartData,
    required this.topItems,
    required this.lowStockItems,
    required this.recentOrders,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      overview: AdminOverviewModel.fromJson(json['overview'] ?? {}),
      orderStats: AdminOrdersStatsModel.fromJson(json['order_stats'] ?? {}),
      stockStats: AdminStockStatsModel.fromJson(json['stock_stats'] ?? {}),
      chartData: (json['chart_data'] as List?)
              ?.map((e) => AdminSalesChartPoint.fromJson(e))
              .toList() ??
          [],
      topItems: (json['top_items'] as List?)
              ?.map((e) => AdminTopItemModel.fromJson(e))
              .toList() ??
          [],
      lowStockItems: (json['low_stock_items'] as List?)
              ?.map((e) => AdminLowStockItemModel.fromJson(e))
              .toList() ??
          [],
      recentOrders: (json['recent_orders'] as List?)
              ?.map((e) => OrderModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory AdminDashboardModel.dummy() {
    return AdminDashboardModel(
      overview: AdminOverviewModel(
        totalRevenue: 15480.0,
        totalOrders: 120,
        totalUsers: 340,
        activeDrivers: 5,
        averageOrderValue: 65.5,
        growthPercentage: 12.5,
      ),
      orderStats: AdminOrdersStatsModel(
        pending: 4,
        preparing: 6,
        ready: 2,
        onTheWay: 5,
        delivered: 103,
        cancelled: 1,
      ),
      stockStats: AdminStockStatsModel(
        inStock: 85,
        lowStock: 6,
        outOfStock: 2,
        totalProducts: 93,
      ),
      chartData: [
        AdminSalesChartPoint(dayName: "السبت", date: "2026-08-25", amount: 1500, orderCount: 20),
        AdminSalesChartPoint(dayName: "الأحد", date: "2026-08-26", amount: 2100, orderCount: 28),
        AdminSalesChartPoint(dayName: "الإثنين", date: "2026-08-27", amount: 1800, orderCount: 24),
        AdminSalesChartPoint(dayName: "الثلاثاء", date: "2026-08-28", amount: 2400, orderCount: 32),
        AdminSalesChartPoint(dayName: "الأربعاء", date: "2026-08-29", amount: 2000, orderCount: 27),
        AdminSalesChartPoint(dayName: "الخميس", date: "2026-08-30", amount: 2900, orderCount: 39),
        AdminSalesChartPoint(dayName: "الجمعة", date: "2026-08-31", amount: 3200, orderCount: 45),
      ],
      topItems: [
        AdminTopItemModel(itemId: 1, itemName: "Burger", itemNameAr: "وجبة برجر مميز", itemImage: "", categoryName: "وجبات سريعة", totalQuantitySold: 45, totalRevenue: 1350),
        AdminTopItemModel(itemId: 2, itemName: "Pizza", itemNameAr: "بيتزا إيطالية مشكل", itemImage: "", categoryName: "بيتزا وفطائر", totalQuantitySold: 38, totalRevenue: 1140),
      ],
      lowStockItems: [],
      recentOrders: [
        OrderModel(orderId: 101, orderStatus: 0, orderPrice: 75, orderTotalprice: 85, orderPaymentmethod: 1, orderType: 0, orderCreated: "2026-08-31 08:00:00"),
        OrderModel(orderId: 102, orderStatus: 1, orderPrice: 120, orderTotalprice: 135, orderPaymentmethod: 0, orderType: 0, orderCreated: "2026-08-31 07:30:00"),
      ],
    );
  }
}

class AdminOverviewModel {
  final double totalRevenue;
  final int totalOrders;
  final int totalUsers;
  final int activeDrivers;
  final double averageOrderValue;
  final double growthPercentage;

  AdminOverviewModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalUsers,
    required this.activeDrivers,
    required this.averageOrderValue,
    required this.growthPercentage,
  });

  factory AdminOverviewModel.fromJson(Map<String, dynamic> json) {
    return AdminOverviewModel(
      totalRevenue: (json['total_revenue'] != null)
          ? double.tryParse(json['total_revenue'].toString()) ?? 0.0
          : 0.0,
      totalOrders: (json['total_orders'] != null)
          ? int.tryParse(json['total_orders'].toString()) ?? 0
          : 0,
      totalUsers: (json['total_users'] != null)
          ? int.tryParse(json['total_users'].toString()) ?? 0
          : 0,
      activeDrivers: (json['active_drivers'] != null)
          ? int.tryParse(json['active_drivers'].toString()) ?? 0
          : 0,
      averageOrderValue: (json['avg_order_value'] != null)
          ? double.tryParse(json['avg_order_value'].toString()) ?? 0.0
          : 0.0,
      growthPercentage: (json['growth_percentage'] != null)
          ? double.tryParse(json['growth_percentage'].toString()) ?? 0.0
          : 0.0,
    );
  }
}

class AdminOrdersStatsModel {
  final int pending;
  final int preparing;
  final int ready;
  final int onTheWay;
  final int delivered;
  final int cancelled;

  AdminOrdersStatsModel({
    required this.pending,
    required this.preparing,
    required this.ready,
    required this.onTheWay,
    required this.delivered,
    required this.cancelled,
  });

  factory AdminOrdersStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminOrdersStatsModel(
      pending: int.tryParse(json['pending']?.toString() ?? '0') ?? 0,
      preparing: int.tryParse(json['preparing']?.toString() ?? '0') ?? 0,
      ready: int.tryParse(json['ready']?.toString() ?? '0') ?? 0,
      onTheWay: int.tryParse(json['on_the_way']?.toString() ?? '0') ?? 0,
      delivered: int.tryParse(json['delivered']?.toString() ?? '0') ?? 0,
      cancelled: int.tryParse(json['cancelled']?.toString() ?? '0') ?? 0,
    );
  }
}

class AdminStockStatsModel {
  final int inStock;
  final int lowStock;
  final int outOfStock;
  final int totalProducts;

  AdminStockStatsModel({
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
    required this.totalProducts,
  });

  factory AdminStockStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStockStatsModel(
      inStock: int.tryParse(json['in_stock']?.toString() ?? '0') ?? 0,
      lowStock: int.tryParse(json['low_stock']?.toString() ?? '0') ?? 0,
      outOfStock: int.tryParse(json['out_of_stock']?.toString() ?? '0') ?? 0,
      totalProducts: int.tryParse(json['total_products']?.toString() ?? '0') ?? 0,
    );
  }
}

class AdminSalesChartPoint {
  final String dayName;
  final String date;
  final double amount;
  final int orderCount;

  AdminSalesChartPoint({
    required this.dayName,
    required this.date,
    required this.amount,
    required this.orderCount,
  });

  factory AdminSalesChartPoint.fromJson(Map<String, dynamic> json) {
    return AdminSalesChartPoint(
      dayName: json['day_name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      orderCount: int.tryParse(json['order_count']?.toString() ?? '0') ?? 0,
    );
  }
}

class AdminTopItemModel {
  final int itemId;
  final String itemName;
  final String itemNameAr;
  final String itemImage;
  final String categoryName;
  final int totalQuantitySold;
  final double totalRevenue;

  AdminTopItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemNameAr,
    required this.itemImage,
    required this.categoryName,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  factory AdminTopItemModel.fromJson(Map<String, dynamic> json) {
    return AdminTopItemModel(
      itemId: int.tryParse(json['items_id']?.toString() ?? '0') ?? 0,
      itemName: json['items_name']?.toString() ?? '',
      itemNameAr: json['items_name_ar']?.toString() ?? '',
      itemImage: json['items_images']?.toString() ?? '',
      categoryName: json['categories_name_ar']?.toString() ??
          json['categories_name']?.toString() ??
          '',
      totalQuantitySold:
          int.tryParse(json['total_sold']?.toString() ?? '0') ?? 0,
      totalRevenue:
          double.tryParse(json['total_revenue']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class AdminLowStockItemModel {
  final int itemId;
  final String itemName;
  final String itemNameAr;
  final String itemImage;
  final int currentCount;

  AdminLowStockItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemNameAr,
    required this.itemImage,
    required this.currentCount,
  });

  factory AdminLowStockItemModel.fromJson(Map<String, dynamic> json) {
    return AdminLowStockItemModel(
      itemId: int.tryParse(json['items_id']?.toString() ?? '0') ?? 0,
      itemName: json['items_name']?.toString() ?? '',
      itemNameAr: json['items_name_ar']?.toString() ?? '',
      itemImage: json['items_images']?.toString() ?? '',
      currentCount: int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
    );
  }
}
