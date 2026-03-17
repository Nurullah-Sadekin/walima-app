import 'dart:convert';
GetPlansResponse getPlansResponseFromJson(String str) => GetPlansResponse.fromJson(json.decode(str));
String getPlansResponseToJson(GetPlansResponse data) => json.encode(data.toJson());
class GetPlansResponse {
  GetPlansResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  GetPlansResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    if (json['response'] != null) {
      response = [];
      json['response'].forEach((v) {
        response?.add(Response.fromJson(v));
      });
    }
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  List<Response>? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.map((v) => v.toJson()).toList();
    }
    map['traceId'] = traceId;
    return map;
  }

}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));
String responseToJson(Response data) => json.encode(data.toJson());
class Response {
  Response({
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
      this.pricings, 
      this.countryPlans, 
      this.features,});

  Response.fromJson(dynamic json) {
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
    if (json['pricings'] != null) {
      pricings = [];
      json['pricings'].forEach((v) {
        pricings?.add(Pricings.fromJson(v));
      });
    }
    if (json['countryPlans'] != null) {
      countryPlans = [];
      // json['countryPlans'].forEach((v) {
      //   countryPlans?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
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
  List<Pricings>? pricings;
  List<dynamic>? countryPlans;
  List<Features>? features;

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
    if (pricings != null) {
      map['pricings'] = pricings?.map((v) => v.toJson()).toList();
    }
    if (countryPlans != null) {
      map['countryPlans'] = countryPlans?.map((v) => v.toJson()).toList();
    }
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Features featuresFromJson(String str) => Features.fromJson(json.decode(str));
String featuresToJson(Features data) => json.encode(data.toJson());
class Features {
  Features({
      this.id, 
      this.name, 
      this.key, 
      this.description, 
      this.icon, 
      this.displayOrder, 
      this.included, 
      this.limit, 
      this.isUnlimited, 
      this.valueType, 
      this.resetPeriod, 
      this.tierValue,});

  Features.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
    description = json['description'];
    icon = json['icon'];
    displayOrder = json['displayOrder'];
    included = json['included'];
    limit = json['limit'];
    isUnlimited = json['isUnlimited'];
    valueType = json['valueType'];
    resetPeriod = json['resetPeriod'];
    tierValue = json['tierValue'];
  }
  String? id;
  String? name;
  String? key;
  String? description;
  String? icon;
  int? displayOrder;
  bool? included;
  String? limit;
  bool? isUnlimited;
  String? valueType;
  String? resetPeriod;
  dynamic tierValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    map['description'] = description;
    map['icon'] = icon;
    map['displayOrder'] = displayOrder;
    map['included'] = included;
    map['limit'] = limit;
    map['isUnlimited'] = isUnlimited;
    map['valueType'] = valueType;
    map['resetPeriod'] = resetPeriod;
    map['tierValue'] = tierValue;
    return map;
  }

}

Pricings pricingsFromJson(String str) => Pricings.fromJson(json.decode(str));
String pricingsToJson(Pricings data) => json.encode(data.toJson());
class Pricings {
  Pricings({
      this.id, 
      this.currency, 
      this.price, 
      this.actualPrice, 
      this.originalPerMonthPrice, 
      this.actualPerMonthPrice, 
      this.effectiveDiscountAmount, 
      this.effectiveDiscountPercentage, 
      this.billingCycle,});

  Pricings.fromJson(dynamic json) {
    id = json['id'];
    currency = json['currency'];
    price = json['price'];
    actualPrice = json['actualPrice'];
    originalPerMonthPrice = json['originalPerMonthPrice'];
    actualPerMonthPrice = json['actualPerMonthPrice'];
    effectiveDiscountAmount = json['effectiveDiscountAmount'];
    effectiveDiscountPercentage = json['effectiveDiscountPercentage'];
    billingCycle = json['billingCycle'];
  }
  String? id;
  String? currency;
  int? price;
  int? actualPrice;
  int? originalPerMonthPrice;
  int? actualPerMonthPrice;
  int? effectiveDiscountAmount;
  dynamic effectiveDiscountPercentage;
  String? billingCycle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['currency'] = currency;
    map['price'] = price;
    map['actualPrice'] = actualPrice;
    map['originalPerMonthPrice'] = originalPerMonthPrice;
    map['actualPerMonthPrice'] = actualPerMonthPrice;
    map['effectiveDiscountAmount'] = effectiveDiscountAmount;
    map['effectiveDiscountPercentage'] = effectiveDiscountPercentage;
    map['billingCycle'] = billingCycle;
    return map;
  }

}