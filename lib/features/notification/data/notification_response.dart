class NotificationResponse {
  NotificationResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
    this.statusCode,
  });

  NotificationResponse.fromJson(dynamic json, {this.statusCode}) {
    code = json['code']?.toString();
    message = json['message']?.toString();
    response = json['response'] != null
        ? NotificationPayload.fromJson(json['response'])
        : null;
    traceId = json['traceId']?.toString();
  }

  String? code;
  String? message;
  NotificationPayload? response;
  String? traceId;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['traceId'] = traceId;
    map['statusCode'] = statusCode;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    return map;
  }
}

class NotificationPayload {
  NotificationPayload({
    this.data,
    this.pagination,
    this.stats,
  });

  NotificationPayload.fromJson(dynamic json) {
    if (json['data'] is List) {
      data = (json['data'] as List)
          .map((item) => NotificationItem.fromJson(item))
          .toList();
    } else {
      data = <NotificationItem>[];
    }
    pagination = json['pagination'] != null
        ? NotificationPagination.fromJson(json['pagination'])
        : null;
    stats = json['stats'] != null
        ? NotificationStats.fromJson(json['stats'])
        : null;
  }

  List<NotificationItem>? data;
  NotificationPagination? pagination;
  NotificationStats? stats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((item) => item.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (stats != null) {
      map['stats'] = stats?.toJson();
    }
    return map;
  }
}

class NotificationStats {
  NotificationStats({
    this.total,
    this.unread,
    this.read,
  });

  NotificationStats.fromJson(dynamic json) {
    total = json['total'] is num ? (json['total'] as num).toInt() : null;
    unread = json['unread'] is num ? (json['unread'] as num).toInt() : null;
    read = json['read'] is num ? (json['read'] as num).toInt() : null;
  }

  int? total;
  int? unread;
  int? read;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['unread'] = unread;
    map['read'] = read;
    return map;
  }
}

class NotificationPagination {
  NotificationPagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  NotificationPagination.fromJson(dynamic json) {
    page = json['page'] is num ? (json['page'] as num).toInt() : null;
    limit = json['limit'] is num ? (json['limit'] as num).toInt() : null;
    total = json['total'] is num ? (json['total'] as num).toInt() : null;
    totalPages =
        json['totalPages'] is num ? (json['totalPages'] as num).toInt() : null;
  }

  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    map['total'] = total;
    map['totalPages'] = totalPages;
    return map;
  }
}

class NotificationItem {
  NotificationItem({
    this.id,
    this.type,
    this.title,
    this.message,
    this.image,
    this.redirectUrl,
    this.content,
    this.isRead,
    this.status,
    this.readAt,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  NotificationItem.fromJson(dynamic json) {
    id = json['id']?.toString();
    type = json['type']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    image = json['image'];
    redirectUrl = json['redirectURL']?.toString();
    content = json['content'];
    isRead = json['isRead'] == true;
    status = json['status']?.toString();
    readAt = json['readAt'];
    sentAt = json['sentAt'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    sender = json['sender'] != null
        ? NotificationSender.fromJson(json['sender'])
        : null;
  }

  String? id;
  String? type;
  String? title;
  String? message;
  dynamic image;
  String? redirectUrl;
  dynamic content;
  bool? isRead;
  String? status;
  dynamic readAt;
  dynamic sentAt;
  String? createdAt;
  String? updatedAt;
  NotificationSender? sender;

  DateTime? get createdAtDateTime => DateTime.tryParse(createdAt ?? '');

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['title'] = title;
    map['message'] = message;
    map['image'] = image;
    map['redirectURL'] = redirectUrl;
    map['content'] = content;
    map['isRead'] = isRead;
    map['status'] = status;
    map['readAt'] = readAt;
    map['sentAt'] = sentAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (sender != null) {
      map['sender'] = sender?.toJson();
    }
    return map;
  }
}

class NotificationSender {
  NotificationSender({
    this.id,
    this.displayName,
    this.userReference,
    this.profilePhoto,
    this.isOnline,
  });

  NotificationSender.fromJson(dynamic json) {
    id = json['id']?.toString();
    displayName = json['displayName']?.toString();
    userReference = json['userReference']?.toString();
    profilePhoto = json['profilePhoto'] != null
        ? NotificationProfilePhoto.fromJson(json['profilePhoto'])
        : null;
    isOnline = json['isOnline'] == true;
  }

  String? id;
  String? displayName;
  String? userReference;
  NotificationProfilePhoto? profilePhoto;
  bool? isOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['displayName'] = displayName;
    map['userReference'] = userReference;
    map['isOnline'] = isOnline;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
    return map;
  }
}

class NotificationProfilePhoto {
  NotificationProfilePhoto({
    this.url,
    this.visibilityStatus,
    this.isVerified,
  });

  NotificationProfilePhoto.fromJson(dynamic json) {
    url = json['url']?.toString();
    visibilityStatus = json['visibilityStatus']?.toString();
    isVerified = json['isVerified'] == true;
  }

  String? url;
  String? visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['visibilityStatus'] = visibilityStatus;
    map['isVerified'] = isVerified;
    return map;
  }
}
