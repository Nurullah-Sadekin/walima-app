import 'dart:convert';
GetMeResponseBody getMeResponseBodyFromJson(String str) => GetMeResponseBody.fromJson(json.decode(str));
String getMeResponseBodyToJson(GetMeResponseBody data) => json.encode(data.toJson());
class GetMeResponseBody {
  GetMeResponseBody({
    this.code,
    this.message,
    this.response,
    this.traceId,});

  GetMeResponseBody.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  Response? response;
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

Response responseFromJson(String str) => Response.fromJson(json.decode(str));
String responseToJson(Response data) => json.encode(data.toJson());
class Response {
  Response({
    this.user,});

  Response.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
    this.id,
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
    this.identityVerificationStatus,
    this.hasPassword,
    this.verificationType,
    this.userType,
    this.roles,
    this.messageSettings,
    this.permissions,
    this.createdAt,
    this.premium,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    profilePicture = json['profilePicture'] != null ? ProfilePicture.fromJson(json['profilePicture']) : null;
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userReference = json['userReference'];
    status = json['status'];
    isVerified = json['isVerified'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    identityVerificationStatus = json['identityVerificationStatus'];
    hasPassword = json['hasPassword'];
    verificationType = json['verificationType'];
    userType = json['userType'];
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles?.add(Roles.fromJson(v));
      });
    }
    messageSettings = json['messageSettings'] != null ? MessageSettings.fromJson(json['messageSettings']) : null;
    // if (json['permissions'] != null) {
    //   permissions = [];
    //   json['permissions'].forEach((v) {
    //     permissions?.add(Dynamic.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    premium = json['premium'] != null ? Premium.fromJson(json['premium']) : null;
  }
  String? id;
  String? firstName;
  String? lastName;
  String? gender;
  ProfilePicture? profilePicture;
  String? email;
  dynamic phoneNumber;
  String? userReference;
  String? status;
  bool? isVerified;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? identityVerificationStatus;
  bool? hasPassword;
  String? verificationType;
  String? userType;
  List<Roles>? roles;
  MessageSettings? messageSettings;
  List<dynamic>? permissions;
  String? createdAt;
  Premium? premium;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    if (profilePicture != null) {
      map['profilePicture'] = profilePicture?.toJson();
    }
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['userReference'] = userReference;
    map['status'] = status;
    map['isVerified'] = isVerified;
    map['isEmailVerified'] = isEmailVerified;
    map['isPhoneVerified'] = isPhoneVerified;
    map['identityVerificationStatus'] = identityVerificationStatus;
    map['hasPassword'] = hasPassword;
    map['verificationType'] = verificationType;
    map['userType'] = userType;
    if (roles != null) {
      map['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    if (messageSettings != null) {
      map['messageSettings'] = messageSettings?.toJson();
    }
    if (permissions != null) {
      map['permissions'] = permissions?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    if (premium != null) {
      map['premium'] = premium?.toJson();
    }
    return map;
  }

}

Premium premiumFromJson(String str) => Premium.fromJson(json.decode(str));
String premiumToJson(Premium data) => json.encode(data.toJson());
class Premium {
  Premium({
    this.plan,
    this.market,
    this.subscription,
    this.features,});

  Premium.fromJson(dynamic json) {
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    market = json['market'] != null ? Market.fromJson(json['market']) : null;
    subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
  }
  Plan? plan;
  Market? market;
  Subscription? subscription;
  List<Features>? features;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (plan != null) {
      map['plan'] = plan?.toJson();
    }
    if (market != null) {
      map['market'] = market?.toJson();
    }
    if (subscription != null) {
      map['subscription'] = subscription?.toJson();
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
    this.key,
    this.name,
    this.displayOrder,
    this.valueType,
    this.used,
    this.limit,
    this.remaining,
    this.isUnlimited,
    this.resetDate,
    this.resetPeriod,
    this.tierValue,});

  Features.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    displayOrder = json['displayOrder'] != null ? int.tryParse(json['displayOrder'].toString()) : null;
    valueType = json['valueType'];
    used = json['used'] != null ? int.tryParse(json['used'].toString()) : null;
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
  dynamic limit;
  dynamic remaining;
  bool? isUnlimited;
  String? resetDate;
  String? resetPeriod;
  dynamic tierValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['displayOrder'] = displayOrder;
    map['valueType'] = valueType;
    map['used'] = used;
    map['limit'] = limit;
    map['remaining'] = remaining;
    map['isUnlimited'] = isUnlimited;
    map['resetDate'] = resetDate;
    map['resetPeriod'] = resetPeriod;
    map['tierValue'] = tierValue;
    return map;
  }

}

Subscription subscriptionFromJson(String str) => Subscription.fromJson(json.decode(str));
String subscriptionToJson(Subscription data) => json.encode(data.toJson());
class Subscription {
  Subscription({
    this.id,
    this.purchaseDate,
    this.expiryDate,
    this.status,});

  Subscription.fromJson(dynamic json) {
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
    final map = <String, dynamic>{};
    map['id'] = id;
    map['purchaseDate'] = purchaseDate;
    map['expiryDate'] = expiryDate;
    map['status'] = status;
    return map;
  }

}

Market marketFromJson(String str) => Market.fromJson(json.decode(str));
String marketToJson(Market data) => json.encode(data.toJson());
class Market {
  Market({
    this.topDiscount,});

  Market.fromJson(dynamic json) {
    topDiscount = json['topDiscount'] != null ? TopDiscount.fromJson(json['topDiscount']) : null;
  }
  TopDiscount? topDiscount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (topDiscount != null) {
      map['topDiscount'] = topDiscount?.toJson();
    }
    return map;
  }

}

TopDiscount topDiscountFromJson(String str) => TopDiscount.fromJson(json.decode(str));
String topDiscountToJson(TopDiscount data) => json.encode(data.toJson());
class TopDiscount {
  TopDiscount({
    this.planId,
    this.planName,
    this.planSlug,
    this.pricingId,
    this.currency,
    this.billingCycle,
    this.originalPrice,
    this.actualPrice,
    this.perMonthPrice,
    this.discountAmount,
    this.discountPercentage,});

  TopDiscount.fromJson(dynamic json) {
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
  num? originalPrice;
  num? actualPrice;
  num? perMonthPrice;
  num? discountAmount;
  num? discountPercentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planId'] = planId;
    map['planName'] = planName;
    map['planSlug'] = planSlug;
    map['pricingId'] = pricingId;
    map['currency'] = currency;
    map['billingCycle'] = billingCycle;
    map['originalPrice'] = originalPrice;
    map['actualPrice'] = actualPrice;
    map['perMonthPrice'] = perMonthPrice;
    map['discountAmount'] = discountAmount;
    map['discountPercentage'] = discountPercentage;
    return map;
  }

}

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));
String planToJson(Plan data) => json.encode(data.toJson());
class Plan {
  Plan({
    this.tier,
    this.name,
    this.isPremium,
    this.isExpired,
    this.autoRenew,
    this.isUpgradeable,});

  Plan.fromJson(dynamic json) {
    tier = json['tier'];
    name = json['name'];
    isPremium = json['isPremium'];
    isExpired = json['isExpired'];
    autoRenew = json['autoRenew'];
    isUpgradeable = json['isUpgradeable'];
  }
  String? tier;
  String? name;
  bool? isPremium;
  bool? isExpired;
  bool? autoRenew;
  bool? isUpgradeable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tier'] = tier;
    map['name'] = name;
    map['isPremium'] = isPremium;
    map['isExpired'] = isExpired;
    map['autoRenew'] = autoRenew;
    map['isUpgradeable'] = isUpgradeable;
    return map;
  }

}

MessageSettings messageSettingsFromJson(String str) => MessageSettings.fromJson(json.decode(str));
String messageSettingsToJson(MessageSettings data) => json.encode(data.toJson());
class MessageSettings {
  MessageSettings({
    this.id,
    this.userId,
    this.autoMessageOnConnect,
    this.messageOnAccept,
    this.messageOnRemind,
    this.messageOnConnect,
    this.createdAt,
    this.updatedAt,});

  MessageSettings.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    autoMessageOnConnect = json['autoMessageOnConnect'];
    messageOnAccept = json['messageOnAccept'];
    messageOnRemind = json['messageOnRemind'];
    messageOnConnect = json['messageOnConnect'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  bool? autoMessageOnConnect;
  dynamic messageOnAccept;
  dynamic messageOnRemind;
  String? messageOnConnect;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['autoMessageOnConnect'] = autoMessageOnConnect;
    map['messageOnAccept'] = messageOnAccept;
    map['messageOnRemind'] = messageOnRemind;
    map['messageOnConnect'] = messageOnConnect;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

Roles rolesFromJson(String str) => Roles.fromJson(json.decode(str));
String rolesToJson(Roles data) => json.encode(data.toJson());
class Roles {
  Roles({
    this.id,
    this.name,
    this.description,});

  Roles.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }
  String? id;
  String? name;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    return map;
  }

}

ProfilePicture profilePictureFromJson(String str) => ProfilePicture.fromJson(json.decode(str));
String profilePictureToJson(ProfilePicture data) => json.encode(data.toJson());
class ProfilePicture {
  ProfilePicture({
    this.url,
    this.visibilityStatus,
    this.visibilitySetting,
    this.isVerified,});

  ProfilePicture.fromJson(dynamic json) {
    url = json['url'];
    visibilityStatus = json['visibilityStatus'];
    visibilitySetting = json['visibilitySetting'];
    isVerified = json['isVerified'];
  }
  String? url;
  String? visibilityStatus;
  String? visibilitySetting;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['visibilityStatus'] = visibilityStatus;
    map['visibilitySetting'] = visibilitySetting;
    map['isVerified'] = isVerified;
    return map;
  }

}

// class GetMeResponseBody {
//
//   GetMeResponseBody({this.code, this.message, this.response, this.traceId});
//
//   GetMeResponseBody.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     message = json['message'];
//     response = json['response'] != null
//         ? Response.fromJson(json['response'])
//         : null;
//     traceId = json['traceId'];
//   }
//   String? code;
//   String? message;
//   Response? response;
//   String? traceId;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     data['message'] = message;
//     if (response != null) {
//       data['response'] = response!.toJson();
//     }
//     data['traceId'] = traceId;
//     return data;
//   }
// }
//
// class Response {
//
//   Response({this.user});
//
//   Response.fromJson(Map<String, dynamic> json) {
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//   User? user;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//
//   User(
//       {this.id,
//         this.firstName,
//         this.lastName,
//         this.gender,
//         this.profilePicture,
//         this.email,
//         this.phoneNumber,
//         this.userReference,
//         this.status,
//         this.isVerified,
//         this.isEmailVerified,
//         this.isPhoneVerified,
//         this.hasPassword,
//         this.verificationType,
//         this.userType,
//         this.roles,
//         this.messageSettings,
//         this.permissions,
//         this.createdAt,
//         this.premium});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     // Changed from Null? to String? and safely convert to string
//     firstName = json['firstName']?.toString();
//     // Changed from Null? to String? and safely convert to string
//     lastName = json['lastName']?.toString();
//     gender = json['gender'];
//     profilePicture = json['profilePicture'];
//     email = json['email'];
//     // Changed from Null? to String? and safely convert to string
//     phoneNumber = json['phoneNumber']?.toString();
//     userReference = json['userReference'];
//     status = json['status'];
//     isVerified = json['isVerified'];
//     isEmailVerified = json['isEmailVerified'];
//     isPhoneVerified = json['isPhoneVerified'];
//     hasPassword = json['hasPassword'];
//     verificationType = json['verificationType'];
//     userType = json['userType'];
//     if (json['roles'] != null) {
//       roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(Roles.fromJson(v));
//       });
//     }
//     // Changed from Null? to String? and safely convert to string
//     messageSettings = json['messageSettings']?.toString();
//     if (json['permissions'] != null) {
//       permissions = <String>[]; // Changed from <Null> to <String>
//       // Iterate and convert each item to String
//       json['permissions'].forEach((v) {
//         permissions!.add(v.toString());
//       });
//     }
//     createdAt = json['createdAt'];
//     premium =
//     json['premium'] != null ? Premium.fromJson(json['premium']) : null;
//   }
//   String? id;
//   String? firstName; // Changed from Null? to String?
//   String? lastName; // Changed from Null? to String?
//   String? gender;
//   String? profilePicture;
//   String? email;
//   String? phoneNumber; // Changed from Null? to String?
//   String? userReference;
//   String? status;
//   bool? isVerified;
//   bool? isEmailVerified;
//   bool? isPhoneVerified;
//   bool? hasPassword;
//   String? verificationType;
//   String? userType;
//   List<Roles>? roles;
//   String? messageSettings; // Changed from Null? to String?
//   List<String>? permissions; // Changed from List<Null>? to List<String>?
//   String? createdAt;
//   Premium? premium;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['gender'] = gender;
//     data['profilePicture'] = profilePicture;
//     data['email'] = email;
//     data['phoneNumber'] = phoneNumber;
//     data['userReference'] = userReference;
//     data['status'] = status;
//     data['isVerified'] = isVerified;
//     data['isEmailVerified'] = isEmailVerified;
//     data['isPhoneVerified'] = isPhoneVerified;
//     data['hasPassword'] = hasPassword;
//     data['verificationType'] = verificationType;
//     data['userType'] = userType;
//     if (roles != null) {
//       data['roles'] = roles!.map((v) => v.toJson()).toList();
//     }
//     data['messageSettings'] = messageSettings;
//     if (permissions != null) {
//       // If permissions is List<String>, we just need to add the list directly
//       data['permissions'] = permissions!.toList(); // Changed from map((v) => v.toJson())
//     }
//     data['createdAt'] = createdAt;
//     if (premium != null) {
//       data['premium'] = premium!.toJson();
//     }
//     return data;
//   }
// }
//
// class Roles {
//
//   Roles({this.id, this.name, this.description});
//
//   Roles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//   }
//   String? id;
//   String? name;
//   String? description;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['description'] = description;
//     return data;
//   }
// }
//
// class Premium {
//
//   Premium({this.plan, this.market, this.subscription, this.features});
//
//   Premium.fromJson(Map<String, dynamic> json) {
//     plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
//     market =
//     json['market'] != null ? Market.fromJson(json['market']) : null;
//     subscription = json['subscription'] != null
//         ? Subscription.fromJson(json['subscription'])
//         : null;
//     if (json['features'] != null) {
//       features = <Features>[];
//       json['features'].forEach((v) {
//         features!.add(Features.fromJson(v));
//       });
//     }
//   }
//   Plan? plan;
//   Market? market;
//   Subscription? subscription;
//   List<Features>? features;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (plan != null) {
//       data['plan'] = plan!.toJson();
//     }
//     if (market != null) {
//       data['market'] = market!.toJson();
//     }
//     if (subscription != null) {
//       data['subscription'] = subscription!.toJson();
//     }
//     if (features != null) {
//       data['features'] = features!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Plan {
//
//   Plan({this.tier, this.name, this.isPremium, this.isExpired, this.autoRenew});
//
//   Plan.fromJson(Map<String, dynamic> json) {
//     tier = json['tier'];
//     name = json['name'];
//     isPremium = json['isPremium'];
//     isExpired = json['isExpired'];
//     autoRenew = json['autoRenew'];
//   }
//   String? tier;
//   String? name;
//   bool? isPremium;
//   bool? isExpired;
//   bool? autoRenew;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['tier'] = tier;
//     data['name'] = name;
//     data['isPremium'] = isPremium;
//     data['isExpired'] = isExpired;
//     data['autoRenew'] = autoRenew;
//     return data;
//   }
// }
//
// class Market {
//
//   Market({this.topDiscount});
//
//   Market.fromJson(Map<String, dynamic> json) {
//     topDiscount = json['topDiscount'] != null
//         ? TopDiscount.fromJson(json['topDiscount'])
//         : null;
//   }
//   TopDiscount? topDiscount;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (topDiscount != null) {
//       data['topDiscount'] = topDiscount!.toJson();
//     }
//     return data;
//   }
// }
//
// class TopDiscount {
//
//   TopDiscount(
//       {this.planId,
//         this.planName,
//         this.planSlug,
//         this.pricingId,
//         this.currency,
//         this.billingCycle,
//         this.originalPrice,
//         this.actualPrice,
//         this.perMonthPrice,
//         this.discountAmount,
//         this.discountPercentage});
//
//   TopDiscount.fromJson(Map<String, dynamic> json) {
//     planId = json['planId'];
//     planName = json['planName'];
//     planSlug = json['planSlug'];
//     pricingId = json['pricingId'];
//     currency = json['currency'];
//     billingCycle = json['billingCycle'];
//     originalPrice = json['originalPrice'];
//     actualPrice = json['actualPrice'];
//     perMonthPrice = json['perMonthPrice'];
//     discountAmount = json['discountAmount'];
//     discountPercentage = json['discountPercentage'];
//   }
//   String? planId;
//   String? planName;
//   String? planSlug;
//   String? pricingId;
//   String? currency;
//   String? billingCycle;
//   int? originalPrice;
//   int? actualPrice;
//   int? perMonthPrice;
//   int? discountAmount;
//   int? discountPercentage;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['planId'] = planId;
//     data['planName'] = planName;
//     data['planSlug'] = planSlug;
//     data['pricingId'] = pricingId;
//     data['currency'] = currency;
//     data['billingCycle'] = billingCycle;
//     data['originalPrice'] = originalPrice;
//     data['actualPrice'] = actualPrice;
//     data['perMonthPrice'] = perMonthPrice;
//     data['discountAmount'] = discountAmount;
//     data['discountPercentage'] = discountPercentage;
//     return data;
//   }
// }
//
// class Subscription {
//
//   Subscription({this.id, this.purchaseDate, this.expiryDate, this.status});
//
//   Subscription.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     purchaseDate = json['purchaseDate'];
//     expiryDate = json['expiryDate'];
//     status = json['status'];
//   }
//   String? id;
//   String? purchaseDate;
//   String? expiryDate;
//   String? status;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['purchaseDate'] = purchaseDate;
//     data['expiryDate'] = expiryDate;
//     data['status'] = status;
//     return data;
//   }
// }
//
// class Features {
//
//   Features(
//       {this.key,
//         this.name,
//         this.displayOrder,
//         this.valueType,
//         this.used,
//         this.limit,
//         this.remaining,
//         this.isUnlimited,
//         this.resetDate,
//         this.resetPeriod,
//         this.tierValue});
//
//   Features.fromJson(Map<String, dynamic> json) {
//     key = json['key'];
//     name = json['name'];
//     displayOrder = json['displayOrder'];
//     valueType = json['valueType'];
//     used = json['used'];
//     limit = json['limit'];
//     remaining = json['remaining'];
//     isUnlimited = json['isUnlimited'];
//     resetDate = json['resetDate'];
//     resetPeriod = json['resetPeriod'];
//     tierValue = json['tierValue'];
//   }
//   String? key;
//   String? name;
//   int? displayOrder;
//   String? valueType;
//   int? used;
//   int? limit;
//   int? remaining;
//   bool? isUnlimited;
//   String? resetDate;
//   String? resetPeriod;
//   String? tierValue;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['key'] = key;
//     data['name'] = name;
//     data['displayOrder'] = displayOrder;
//     data['valueType'] = valueType;
//     data['used'] = used;
//     data['limit'] = limit;
//     data['remaining'] = remaining;
//     data['isUnlimited'] = isUnlimited;
//     data['resetDate'] = resetDate;
//     data['resetPeriod'] = resetPeriod;
//     data['tierValue'] = tierValue;
//     return data;
//   }
// }