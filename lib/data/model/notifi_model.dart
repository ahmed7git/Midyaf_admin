class NotificationModel {
  int notificationId;
  String notificationTitle;
  String notificationBody;
  int notificationStatus;
  String notificationCreated;
  int notificationUserid;

  NotificationModel(
      {
       required this.notificationId,
      required this.notificationTitle,
      required this.notificationBody,
      required this.notificationStatus,
      required this.notificationCreated,
      required this.notificationUserid
      });

   factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
    notificationId : json['notification_id'],
    notificationTitle : json['notification_title'],
    notificationBody : json['notification_body'],
    notificationStatus : json['notification_status'],
    notificationCreated : json['notification_created'],
    notificationUserid : json['notification_userid'],
  );
  }

  Map<String, dynamic> toJson() {
    return
    { 'notification_id' :  notificationId,
     'notification_title' :  notificationTitle,
     'notification_body'   :notificationBody,
     'notification_status'  : notificationStatus,
     'notification_created'  : notificationCreated,
     'notification_userid'   :notificationUserid,
    };
  }
}