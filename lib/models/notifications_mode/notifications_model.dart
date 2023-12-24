class NotificationsModel {
  final String code;
  final String msg;
  final NotificationData data;
  final PaginationMeta meta;

  NotificationsModel(
      {required this.code,
      required this.msg,
      required this.data,
      required this.meta});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      code: json['code'],
      msg: json['msg'],
      data: NotificationData.fromJson(json['data']),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class NotificationData {
  final List<NotificationItem> unread;
  final List<NotificationItem> read;

  NotificationData({required this.unread, required this.read});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      unread: (json['unread'] as List)
          .map((i) => NotificationItem.fromJson(i))
          .toList(),
      read: (json['read'] as List)
          .map((i) => NotificationItem.fromJson(i))
          .toList(),
    );
  }
}

class NotificationItem {
  final int id;
  final String type;
  final String stockName;
  final String title;
  final String message;
  final String createdAt;

  NotificationItem(
      {required this.id,
      required this.type,
      required this.stockName,
      required this.title,
      required this.message,
      required this.createdAt});

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      type: json['type'],
      stockName: json['stock_name'],
      title: json['title'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}

class PaginationMeta {
  final int perPage;
  final dynamic prevPage;
  final dynamic currentPage;
  final String nextPage;
  final String nextPageUrl;
  final dynamic prevPageUrl;

  PaginationMeta(
      {required this.perPage,
      this.prevPage,
      this.currentPage,
      required this.nextPage,
      required this.nextPageUrl,
      this.prevPageUrl});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      perPage: json['per_page'],
      prevPage: json['prev_page'],
      currentPage: json['current_page'],
      nextPage: json['next_page'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}
