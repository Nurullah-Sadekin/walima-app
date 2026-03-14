part of 'get_complete_profile_response.dart';

class ProfilePictures {
  ProfilePictures({
    this.id,
    this.profileId,
    this.url,
    this.name,
    this.alt,
    this.caption,
    this.description,
    this.status,
    this.rejectReason,
    this.rejectedBy,
    this.mediaId,
    this.category,
    this.isPrimary,
    this.photoOrder,
    this.visibility,
    this.approvalStatus,
    this.photoSizes,
    this.createdAt,
    this.updatedAt,
  });

  ProfilePictures.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    url = json['url'];
    name = json['name'];
    alt = json['alt'];
    caption = json['caption'];
    description = json['description'];
    status = json['status'];
    rejectReason = json['rejectReason'];
    rejectedBy = json['rejectedBy'];
    mediaId = json['mediaId'];
    category = json['category'];
    isPrimary = json['isPrimary'];
    photoOrder = json['photoOrder'];
    visibility = json['visibility'];
    approvalStatus = json['approvalStatus'];
    photoSizes = json['photoSizes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? url;
  String? name;
  dynamic alt;
  dynamic caption;
  dynamic description;
  String? status;
  dynamic rejectReason;
  dynamic rejectedBy;
  String? mediaId;
  String? category;
  bool? isPrimary;
  int? photoOrder;
  String? visibility;
  String? approvalStatus;
  dynamic photoSizes;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['url'] = url;
    map['name'] = name;
    map['alt'] = alt;
    map['caption'] = caption;
    map['description'] = description;
    map['status'] = status;
    map['rejectReason'] = rejectReason;
    map['rejectedBy'] = rejectedBy;
    map['mediaId'] = mediaId;
    map['category'] = category;
    map['isPrimary'] = isPrimary;
    map['photoOrder'] = photoOrder;
    map['visibility'] = visibility;
    map['approvalStatus'] = approvalStatus;
    map['photoSizes'] = photoSizes;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

