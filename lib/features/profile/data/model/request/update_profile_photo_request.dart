class UpdateProfilePhotoRequest {
  UpdateProfilePhotoRequest({
    this.id,
    required this.mediaId,
    this.category = 'profile',
    this.isPrimary = true,
    this.photoOrder,
    this.visibility,
    this.photoSizes,
    this.shouldDelete,
  });

  final String? id;
  final String mediaId;
  final String category;
  final bool? isPrimary;
  final int? photoOrder;
  final String? visibility;
  final Map<String, String?>? photoSizes;
  final bool? shouldDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null && id!.isNotEmpty) {
      map['id'] = id;
    }
    map['mediaId'] = mediaId;
    map['category'] = category;
    if (isPrimary != null) {
      map['isPrimary'] = isPrimary;
    }
    if (photoOrder != null) {
      map['photoOrder'] = photoOrder;
    }
    if (visibility != null) {
      map['visibility'] = visibility;
    }
    if (photoSizes != null) {
      map['photoSizes'] = photoSizes;
    }
    if (shouldDelete != null) {
      map['shouldDelete'] = shouldDelete;
    }
    return map;
  }
}
