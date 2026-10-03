// import 'dart:convert';
// CreateUserProfileBody createUserProfileBodyFromJson(String str) => CreateUserProfileBody.fromJson(json.decode(str));
// String createUserProfileBodyToJson(CreateUserProfileBody data) => json.encode(data.toJson());
// class CreateUserProfileBody {
//   CreateUserProfileBody({
//       this.profileManagedBy, 
//       this.gender, 
//       this.firstName, 
//       this.lastName, 
//       this.displayName, 
//       this.motherTongue, 
//       this.dateOfBirth, 
//       this.religionName, 
//       this.community, 
//       this.livingIn, 
//       this.cityName, 
//       this.locationType, 
//       this.countryCode, 
//       this.liveWithFamily, 
//       this.residencyStatus, 
//       this.maritalStatus, 
//       this.height, 
//       this.diet, 
//       this.highestLevelOfEducation, 
//       this.incomeRange, 
//       this.incomeRangeFrequency, 
//       this.workWith, 
//       this.workingAs, 
//       this.currentCompany, 
//       this.bio, 
//       this.termsAndConditionsAccepted,});
//
//   CreateUserProfileBody.fromJson(dynamic json) {
//     profileManagedBy = json['profileManagedBy'];
//     gender = json['gender'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     displayName = json['displayName'];
//     motherTongue = json['motherTongue'];
//     dateOfBirth = json['dateOfBirth'];
//     religionName = json['religionName'];
//     community = json['community'];
//     livingIn = json['livingIn'];
//     cityName = json['cityName'];
//     locationType = json['locationType'];
//     countryCode = json['countryCode'];
//     liveWithFamily = json['liveWithFamily'];
//     residencyStatus = json['residencyStatus'];
//     maritalStatus = json['maritalStatus'];
//     height = json['height'];
//     diet = json['diet'];
//     highestLevelOfEducation = json['highestLevelOfEducation'];
//     incomeRange = json['incomeRange'];
//     incomeRangeFrequency = json['incomeRangeFrequency'];
//     workWith = json['workWith'];
//     workingAs = json['workingAs'];
//     currentCompany = json['currentCompany'];
//     bio = json['bio'];
//     termsAndConditionsAccepted = json['termsAndConditionsAccepted'];
//   }
//   String? profileManagedBy;
//   String? gender;
//   String? firstName;
//   String? lastName;
//   String? displayName;
//   String? motherTongue;
//   String? dateOfBirth;
//   String? religionName;
//   String? community;
//   String? livingIn;
//   String? cityName;
//   String? locationType;
//   String? countryCode;
//   bool? liveWithFamily;
//   String? residencyStatus;
//   String? maritalStatus;
//   num? height;
//   String? diet;
//   String? highestLevelOfEducation;
//   String? incomeRange;
//   String? incomeRangeFrequency;
//   String? workWith;
//   String? workingAs;
//   String? currentCompany;
//   String? bio;
//   bool? termsAndConditionsAccepted;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['profileManagedBy'] = profileManagedBy;
//     map['gender'] = gender;
//     map['firstName'] = firstName;
//     map['lastName'] = lastName;
//     map['displayName'] = displayName;
//     map['motherTongue'] = motherTongue;
//     map['dateOfBirth'] = dateOfBirth;
//     map['religionName'] = religionName;
//     map['community'] = community;
//     map['livingIn'] = livingIn;
//     map['cityName'] = cityName;
//     map['locationType'] = locationType;
//     map['countryCode'] = countryCode;
//     map['liveWithFamily'] = liveWithFamily;
//     map['residencyStatus'] = residencyStatus;
//     map['maritalStatus'] = maritalStatus;
//     map['height'] = height;
//     map['diet'] = diet;
//     map['highestLevelOfEducation'] = highestLevelOfEducation;
//     map['incomeRange'] = incomeRange;
//     map['incomeRangeFrequency'] = incomeRangeFrequency;
//     map['workWith'] = workWith;
//     map['workingAs'] = workingAs;
//     map['currentCompany'] = currentCompany;
//     map['bio'] = bio;
//     map['termsAndConditionsAccepted'] = termsAndConditionsAccepted;
//     return map;
//   }
//
// }