class GetCurrentSubscriptionResponse {
  GetCurrentSubscriptionResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  GetCurrentSubscriptionResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? CurrentSubscriptionResponseContainer.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  CurrentSubscriptionResponseContainer? response;
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

class CurrentSubscriptionResponseContainer {
  CurrentSubscriptionResponseContainer({
    this.data,
  });

  CurrentSubscriptionResponseContainer.fromJson(dynamic json) {
    data = json['data'] != null
        ? CurrentSubscriptionData.fromJson(json['data'])
        : null;
  }

  CurrentSubscriptionData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class CurrentSubscriptionData {
  CurrentSubscriptionData({
    this.id,
    this.userId,
    this.planId,
    this.plan,
    this.status,
    this.paymentGatewayId,
    this.externalReference,
    this.startAt,
    this.endAt,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  CurrentSubscriptionData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    planId = json['planId'];
    plan = json['plan'] != null
        ? CurrentSubscriptionPlan.fromJson(json['plan'])
        : null;
    status = json['status'];
    paymentGatewayId = json['paymentGatewayId'];
    externalReference = json['externalReference'];
    startAt = json['startAt'];
    endAt = json['endAt'];
    cancelledAt = json['cancelledAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? userId;
  String? planId;
  CurrentSubscriptionPlan? plan;
  String? status;
  String? paymentGatewayId;
  dynamic externalReference;
  String? startAt;
  String? endAt;
  dynamic cancelledAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['planId'] = planId;
    if (plan != null) {
      map['plan'] = plan?.toJson();
    }
    map['status'] = status;
    map['paymentGatewayId'] = paymentGatewayId;
    map['externalReference'] = externalReference;
    map['startAt'] = startAt;
    map['endAt'] = endAt;
    map['cancelledAt'] = cancelledAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class CurrentSubscriptionPlan {
  CurrentSubscriptionPlan({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.status,
    this.tag,
    this.tagIcon,
    this.ranking,
    this.createdAt,
    this.updatedAt,
  });

  CurrentSubscriptionPlan.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    status = json['status'];
    tag = json['tag'];
    tagIcon = json['tagIcon'];
    ranking = json['ranking'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? name;
  String? slug;
  String? description;
  String? status;
  String? tag;
  String? tagIcon;
  int? ranking;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['description'] = description;
    map['status'] = status;
    map['tag'] = tag;
    map['tagIcon'] = tagIcon;
    map['ranking'] = ranking;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
