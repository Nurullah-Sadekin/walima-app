
class RefreshRequestBody {
  RefreshRequestBody({this.refreshToken,});
  String? refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refreshToken'] = refreshToken;
    return map;
  }

}