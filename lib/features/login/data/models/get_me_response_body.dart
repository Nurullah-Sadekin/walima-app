class GetMeResponseBody {

  GetMeResponseBody({this.code, this.message, this.response, this.traceId});

  GetMeResponseBody.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  Response? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    data['traceId'] = traceId;
    return data;
  }
}

class Response {

  Response({this.user});

  Response.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  User? user;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.gender,
        this.profilePicture,
        this.email,
        this.phoneNumber,
        this.userReference,
        this.status,
        this.isVerified,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.hasPassword,
        this.verificationType,
        this.userType,
        this.roles,
        this.messageSettings,
        this.permissions,
        this.createdAt,
        this.premium});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Changed from Null? to String? and safely convert to string
    firstName = json['firstName']?.toString();
    // Changed from Null? to String? and safely convert to string
    lastName = json['lastName']?.toString();
    gender = json['gender'];
    profilePicture = json['profilePicture'];
    email = json['email'];
    // Changed from Null? to String? and safely convert to string
    phoneNumber = json['phoneNumber']?.toString();
    userReference = json['userReference'];
    status = json['status'];
    isVerified = json['isVerified'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    hasPassword = json['hasPassword'];
    verificationType = json['verificationType'];
    userType = json['userType'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    // Changed from Null? to String? and safely convert to string
    messageSettings = json['messageSettings']?.toString();
    if (json['permissions'] != null) {
      permissions = <String>[]; // Changed from <Null> to <String>
      // Iterate and convert each item to String
      json['permissions'].forEach((v) {
        permissions!.add(v.toString());
      });
    }
    createdAt = json['createdAt'];
    premium =
    json['premium'] != null ? Premium.fromJson(json['premium']) : null;
  }
  String? id;
  String? firstName; // Changed from Null? to String?
  String? lastName; // Changed from Null? to String?
  String? gender;
  String? profilePicture;
  String? email;
  String? phoneNumber; // Changed from Null? to String?
  String? userReference;
  String? status;
  bool? isVerified;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? hasPassword;
  String? verificationType;
  String? userType;
  List<Roles>? roles;
  String? messageSettings; // Changed from Null? to String?
  List<String>? permissions; // Changed from List<Null>? to List<String>?
  String? createdAt;
  Premium? premium;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['profilePicture'] = profilePicture;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['userReference'] = userReference;
    data['status'] = status;
    data['isVerified'] = isVerified;
    data['isEmailVerified'] = isEmailVerified;
    data['isPhoneVerified'] = isPhoneVerified;
    data['hasPassword'] = hasPassword;
    data['verificationType'] = verificationType;
    data['userType'] = userType;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['messageSettings'] = messageSettings;
    if (permissions != null) {
      // If permissions is List<String>, we just need to add the list directly
      data['permissions'] = permissions!.toList(); // Changed from map((v) => v.toJson())
    }
    data['createdAt'] = createdAt;
    if (premium != null) {
      data['premium'] = premium!.toJson();
    }
    return data;
  }
}

class Roles {

  Roles({this.id, this.name, this.description});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }
  String? id;
  String? name;
  String? description;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Premium {

  Premium({this.plan, this.market, this.subscription, this.features});

  Premium.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    market =
    json['market'] != null ? Market.fromJson(json['market']) : null;
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }
  Plan? plan;
  Market? market;
  Subscription? subscription;
  List<Features>? features;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    if (market != null) {
      data['market'] = market!.toJson();
    }
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plan {

  Plan({this.tier, this.name, this.isPremium, this.isExpired, this.autoRenew});

  Plan.fromJson(Map<String, dynamic> json) {
    tier = json['tier'];
    name = json['name'];
    isPremium = json['isPremium'];
    isExpired = json['isExpired'];
    autoRenew = json['autoRenew'];
  }
  String? tier;
  String? name;
  bool? isPremium;
  bool? isExpired;
  bool? autoRenew;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tier'] = tier;
    data['name'] = name;
    data['isPremium'] = isPremium;
    data['isExpired'] = isExpired;
    data['autoRenew'] = autoRenew;
    return data;
  }
}

class Market {

  Market({this.topDiscount});

  Market.fromJson(Map<String, dynamic> json) {
    topDiscount = json['topDiscount'] != null
        ? TopDiscount.fromJson(json['topDiscount'])
        : null;
  }
  TopDiscount? topDiscount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topDiscount != null) {
      data['topDiscount'] = topDiscount!.toJson();
    }
    return data;
  }
}

class TopDiscount {

  TopDiscount(
      {this.planId,
        this.planName,
        this.planSlug,
        this.pricingId,
        this.currency,
        this.billingCycle,
        this.originalPrice,
        this.actualPrice,
        this.perMonthPrice,
        this.discountAmount,
        this.discountPercentage});

  TopDiscount.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    planName = json['planName'];
    planSlug = json['planSlug'];
    pricingId = json['pricingId'];
    currency = json['currency'];
    billingCycle = json['billingCycle'];
    originalPrice = json['originalPrice'];
    actualPrice = json['actualPrice'];
    perMonthPrice = json['perMonthPrice'];
    discountAmount = json['discountAmount'];
    discountPercentage = json['discountPercentage'];
  }
  String? planId;
  String? planName;
  String? planSlug;
  String? pricingId;
  String? currency;
  String? billingCycle;
  int? originalPrice;
  int? actualPrice;
  int? perMonthPrice;
  int? discountAmount;
  int? discountPercentage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planId'] = planId;
    data['planName'] = planName;
    data['planSlug'] = planSlug;
    data['pricingId'] = pricingId;
    data['currency'] = currency;
    data['billingCycle'] = billingCycle;
    data['originalPrice'] = originalPrice;
    data['actualPrice'] = actualPrice;
    data['perMonthPrice'] = perMonthPrice;
    data['discountAmount'] = discountAmount;
    data['discountPercentage'] = discountPercentage;
    return data;
  }
}

class Subscription {

  Subscription({this.id, this.purchaseDate, this.expiryDate, this.status});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purchaseDate = json['purchaseDate'];
    expiryDate = json['expiryDate'];
    status = json['status'];
  }
  String? id;
  String? purchaseDate;
  String? expiryDate;
  String? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['purchaseDate'] = purchaseDate;
    data['expiryDate'] = expiryDate;
    data['status'] = status;
    return data;
  }
}

class Features {

  Features(
      {this.key,
        this.name,
        this.displayOrder,
        this.valueType,
        this.used,
        this.limit,
        this.remaining,
        this.isUnlimited,
        this.resetDate,
        this.resetPeriod,
        this.tierValue});

  Features.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    displayOrder = json['displayOrder'];
    valueType = json['valueType'];
    used = json['used'];
    limit = json['limit'];
    remaining = json['remaining'];
    isUnlimited = json['isUnlimited'];
    resetDate = json['resetDate'];
    resetPeriod = json['resetPeriod'];
    tierValue = json['tierValue'];
  }
  String? key;
  String? name;
  int? displayOrder;
  String? valueType;
  int? used;
  int? limit;
  int? remaining;
  bool? isUnlimited;
  String? resetDate;
  String? resetPeriod;
  String? tierValue;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    data['displayOrder'] = displayOrder;
    data['valueType'] = valueType;
    data['used'] = used;
    data['limit'] = limit;
    data['remaining'] = remaining;
    data['isUnlimited'] = isUnlimited;
    data['resetDate'] = resetDate;
    data['resetPeriod'] = resetPeriod;
    data['tierValue'] = tierValue;
    return data;
  }
}