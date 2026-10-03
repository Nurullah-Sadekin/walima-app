import 'dart:convert';

UpgradeQuoteResponse upgradeQuoteResponseFromJson(String str) =>
    UpgradeQuoteResponse.fromJson(json.decode(str));
String upgradeQuoteResponseToJson(UpgradeQuoteResponse data) =>
    json.encode(data.toJson());

class UpgradeQuoteResponse {
  UpgradeQuoteResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  UpgradeQuoteResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? UpgradeQuoteResponseContainer.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  UpgradeQuoteResponseContainer? response;
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

class UpgradeQuoteResponseContainer {
  UpgradeQuoteResponseContainer({
    this.data,
  });

  UpgradeQuoteResponseContainer.fromJson(dynamic json) {
    data =
        json['data'] != null ? UpgradeQuoteData.fromJson(json['data']) : null;
  }

  UpgradeQuoteData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class UpgradeQuoteData {
  UpgradeQuoteData({
    this.canMove,
    this.reason,
    this.movementType,
    this.currentPlan,
    this.targetPlan,
    this.billingCycle,
    this.currency,
    this.baseTargetAmount,
    this.currentPlanAmount,
    this.usedDays,
    this.totalDays,
    this.usedCostAmount,
    this.creditAmount,
    this.payableAmount,
  });

  UpgradeQuoteData.fromJson(dynamic json) {
    canMove = json['canMove'];
    reason = json['reason'];
    movementType = json['movementType'];
    currentPlan = json['currentPlan'] != null
        ? UpgradeQuotePlanInfo.fromJson(json['currentPlan'])
        : null;
    targetPlan = json['targetPlan'] != null
        ? UpgradeQuotePlanInfo.fromJson(json['targetPlan'])
        : null;
    billingCycle = json['billingCycle'];
    currency = json['currency'];
    baseTargetAmount = json['baseTargetAmount'];
    currentPlanAmount = json['currentPlanAmount'];
    usedDays = json['usedDays'];
    totalDays = json['totalDays'];
    usedCostAmount = json['usedCostAmount'];
    creditAmount = json['creditAmount'];
    payableAmount = json['payableAmount'];
  }

  bool? canMove;
  String? reason;
  String? movementType;
  UpgradeQuotePlanInfo? currentPlan;
  UpgradeQuotePlanInfo? targetPlan;
  String? billingCycle;
  String? currency;
  int? baseTargetAmount;
  int? currentPlanAmount;
  int? usedDays;
  int? totalDays;
  int? usedCostAmount;
  int? creditAmount;
  int? payableAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['canMove'] = canMove;
    map['reason'] = reason;
    map['movementType'] = movementType;
    if (currentPlan != null) {
      map['currentPlan'] = currentPlan?.toJson();
    }
    if (targetPlan != null) {
      map['targetPlan'] = targetPlan?.toJson();
    }
    map['billingCycle'] = billingCycle;
    map['currency'] = currency;
    map['baseTargetAmount'] = baseTargetAmount;
    map['currentPlanAmount'] = currentPlanAmount;
    map['usedDays'] = usedDays;
    map['totalDays'] = totalDays;
    map['usedCostAmount'] = usedCostAmount;
    map['creditAmount'] = creditAmount;
    map['payableAmount'] = payableAmount;
    return map;
  }
}

class UpgradeQuotePlanInfo {
  UpgradeQuotePlanInfo({
    this.id,
    this.slug,
    this.ranking,
  });

  UpgradeQuotePlanInfo.fromJson(dynamic json) {
    id = json['id'];
    slug = json['slug'];
    ranking = json['ranking'];
  }

  String? id;
  String? slug;
  int? ranking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['slug'] = slug;
    map['ranking'] = ranking;
    return map;
  }
}
