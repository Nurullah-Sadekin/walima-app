class SignUpRequestBody {
  SignUpRequestBody({
    this.profileManagedBy,
    this.gender,
    this.firstName,
    this.lastName,
    this.displayName,
    this.motherTongue,
    this.dateOfBirth,
    this.religionName,
    this.community,
    this.livingIn,
    this.cityName,
    this.locationType,
    this.countryCode,
    this.liveWithFamily,
    this.residencyStatus,
    this.maritalStatus,
    this.height,
    this.diet,
    this.highestLevelOfEducation,
    this.incomeRange,
    this.incomeRangeFrequency,
    this.workWith,
    this.workingAs,
    this.currentCompany,
    this.bio,
    this.termsAndConditionsAccepted,
    this.verificationType,
    this.email,
    this.phoneNumber,
    this.otpCode,
    this.purpose,
  });
  String? profileManagedBy;
  String? gender;
  String? firstName;
  String? lastName;
  String? displayName;
  String? motherTongue;
  String? dateOfBirth;
  String? religionName;
  String? community;
  String? livingIn;
  String? cityName;
  String? locationType;
  String? countryCode;
  bool? liveWithFamily;
  String? residencyStatus;
  String? maritalStatus;
  num? height;
  String? diet;
  String? highestLevelOfEducation;
  String? incomeRange;
  String? incomeRangeFrequency;
  String? workWith;
  String? workingAs;
  String? currentCompany;
  String? bio;
  bool? termsAndConditionsAccepted;
  String? verificationType;
  String? email;
  String? phoneNumber;
  String? otpCode;
  String? purpose;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileManagedBy'] = profileManagedBy;
    map['gender'] = gender;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['displayName'] = displayName;
    map['motherTongue'] = motherTongue;
    map['dateOfBirth'] = dateOfBirth;
    map['religionName'] = religionName;
    map['community'] = community;
    map['livingIn'] = livingIn;
    map['cityName'] = cityName;
    map['locationType'] = locationType;
    map['countryCode'] = countryCode;
    map['liveWithFamily'] = liveWithFamily;
    map['residencyStatus'] = residencyStatus;
    map['maritalStatus'] = maritalStatus;
    map['height'] = height;
    map['diet'] = diet;
    map['highestLevelOfEducation'] = highestLevelOfEducation;
    map['incomeRange'] = incomeRange;
    map['incomeRangeFrequency'] = incomeRangeFrequency;
    map['workWith'] = workWith;
    map['workingAs'] = workingAs;
    map['currentCompany'] = currentCompany;
    map['bio'] = bio;
    map['termsAndConditionsAccepted'] = termsAndConditionsAccepted;
    map['verificationType'] = verificationType;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    if (otpCode != null) {
      map['otpCode'] = otpCode;
    }
    map['purpose'] = purpose;
    return map;
  }
}
