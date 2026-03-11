class UploadMediaResponse {
  UploadMediaResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  UploadMediaResponse.fromJson(dynamic json) {
    code = json['code']?.toString();
    message = json['message']?.toString();
    response = json['response'] != null
        ? UploadMediaResponseBody.fromJson(json['response'])
        : null;
    traceId = json['traceId']?.toString();
  }

  String? code;
  String? message;
  UploadMediaResponseBody? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['traceId'] = traceId;
    return map;
  }
}

class UploadMediaResponseBody {
  UploadMediaResponseBody({
    this.data,
  });

  UploadMediaResponseBody.fromJson(dynamic json) {
    data = json['data'] != null ? UploadMediaData.fromJson(json['data']) : null;
  }

  UploadMediaData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class UploadMediaData {
  UploadMediaData({
    this.id,
    this.resource,
    this.userId,
    this.name,
    this.alt,
    this.caption,
    this.description,
    this.url,
    this.mediaKey,
    this.mimeType,
    this.size,
    this.status,
    this.rejectReason,
    this.rejectedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  UploadMediaData.fromJson(dynamic json) {
    id = json['id']?.toString();
    resource = json['resource']?.toString();
    userId = json['userId']?.toString();
    name = json['name']?.toString();
    alt = json['alt']?.toString();
    caption = json['caption']?.toString();
    description = json['description']?.toString();
    url = json['url']?.toString();
    mediaKey = json['mediaKey']?.toString();
    mimeType = json['mimeType']?.toString();
    size = json['size'] is int
        ? json['size'] as int
        : int.tryParse(json['size']?.toString() ?? '');
    status = json['status']?.toString();
    rejectReason = json['rejectReason']?.toString();
    rejectedBy = json['rejectedBy']?.toString();
    deletedAt = json['deletedAt']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  String? id;
  String? resource;
  String? userId;
  String? name;
  String? alt;
  String? caption;
  String? description;
  String? url;
  String? mediaKey;
  String? mimeType;
  int? size;
  String? status;
  String? rejectReason;
  String? rejectedBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['resource'] = resource;
    map['userId'] = userId;
    map['name'] = name;
    map['alt'] = alt;
    map['caption'] = caption;
    map['description'] = description;
    map['url'] = url;
    map['mediaKey'] = mediaKey;
    map['mimeType'] = mimeType;
    map['size'] = size;
    map['status'] = status;
    map['rejectReason'] = rejectReason;
    map['rejectedBy'] = rejectedBy;
    map['deletedAt'] = deletedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
