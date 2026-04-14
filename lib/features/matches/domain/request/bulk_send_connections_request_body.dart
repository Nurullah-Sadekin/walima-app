class BulkSendConnectionsRequestBody {
  const BulkSendConnectionsRequestBody({
    required this.matchUserIds,
    this.requestType = 'connection',
    this.message,
    this.isPriority = false,
  });

  final List<String> matchUserIds;
  final String requestType;
  final String? message;
  final bool isPriority;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'matchUserIds': matchUserIds,
      'requestType': requestType,
      'message': message,
      'isPriority': isPriority,
    };
  }
}
