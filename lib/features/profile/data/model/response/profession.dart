part of 'get_complete_profile_response.dart';

class Profession {
  Profession({
    this.id,
    this.profileId,
    this.employmentType,
    this.profession,
    this.industry,
    this.employer,
    this.designation,
    this.workLocation,
    this.startDate,
    this.endDate,
    this.incomeRange,
    this.incomeFrequency,
    this.incomeCurrency,
    this.incomeHidden,
    this.yearsOfExperience,
    this.jobType,
    this.companySize,
    this.skills,
    this.createdAt,
    this.updatedAt,
  });

  Profession.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    employmentType = json['employmentType'];
    profession = json['profession'];
    industry = json['industry'];
    employer = json['employer'];
    designation = json['designation'];
    workLocation = json['workLocation'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    incomeRange = json['incomeRange'];
    incomeFrequency = json['incomeFrequency'];
    incomeCurrency = json['incomeCurrency'];
    incomeHidden = json['incomeHidden'];
    yearsOfExperience = json['yearsOfExperience'];
    jobType = json['jobType'];
    companySize = json['companySize'];
    skills = json['skills'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  dynamic employmentType;
  dynamic profession;
  dynamic industry;
  String? employer;
  String? designation;
  dynamic workLocation;
  dynamic startDate;
  dynamic endDate;
  String? incomeRange;
  String? incomeFrequency;
  String? incomeCurrency;
  bool? incomeHidden;
  dynamic yearsOfExperience;
  String? jobType;
  dynamic companySize;
  dynamic skills;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['employmentType'] = employmentType;
    map['profession'] = profession;
    map['industry'] = industry;
    map['employer'] = employer;
    map['designation'] = designation;
    map['workLocation'] = workLocation;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['incomeRange'] = incomeRange;
    map['incomeFrequency'] = incomeFrequency;
    map['incomeCurrency'] = incomeCurrency;
    map['incomeHidden'] = incomeHidden;
    map['yearsOfExperience'] = yearsOfExperience;
    map['jobType'] = jobType;
    map['companySize'] = companySize;
    map['skills'] = skills;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

