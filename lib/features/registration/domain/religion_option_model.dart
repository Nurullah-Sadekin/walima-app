class ReligionOptionModel {
  ReligionOptionModel({
    required this.name,
    required this.value,
    required this.community,
  });

  factory ReligionOptionModel.fromJson(Map<String, dynamic> json) {
    return ReligionOptionModel(
      name: (json['name'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
      community: ReligionCommunityNode.fromDynamic(json['community']),
    );
  }

  final String name;
  final String value;
  final ReligionCommunityNode community;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'community': community.toDynamic(),
    };
  }
}

class ReligionCommunityNode {
  const ReligionCommunityNode._({
    this.children = const <String, ReligionCommunityNode>{},
    this.items = const <String>[],
  });

  factory ReligionCommunityNode.fromDynamic(dynamic data) {
    if (data is Map<String, dynamic>) {
      final mapped = <String, ReligionCommunityNode>{};
      data.forEach((key, value) {
        mapped[key] = ReligionCommunityNode.fromDynamic(value);
      });
      return ReligionCommunityNode._(children: mapped);
    }

    if (data is Map) {
      final mapped = <String, ReligionCommunityNode>{};
      data.forEach((key, value) {
        mapped[key.toString()] = ReligionCommunityNode.fromDynamic(value);
      });
      return ReligionCommunityNode._(children: mapped);
    }

    if (data is List) {
      return ReligionCommunityNode._(
        items: data.map((item) => item.toString()).toList(growable: false),
      );
    }

    return const ReligionCommunityNode._();
  }

  final Map<String, ReligionCommunityNode> children;
  final List<String> items;

  bool get isEmpty => children.isEmpty && items.isEmpty;

  List<String> topLevelLabels() {
    if (children.isNotEmpty) {
      return children.keys.toList(growable: false);
    }
    return List<String>.from(items);
  }

  List<String> flattenCommunityLabels({bool includeCategoryKeys = false}) {
    final result = <String>[];
    final seen = <String>{};

    void addUnique(String value) {
      final cleaned = value.trim();
      if (cleaned.isEmpty) return;

      final marker = cleaned.toLowerCase();
      if (seen.add(marker)) {
        result.add(cleaned);
      }
    }

    void walk(ReligionCommunityNode node, {String? currentKey}) {
      if (currentKey != null) {
        if (node.isEmpty || includeCategoryKeys) {
          addUnique(currentKey);
        }
      }

      for (final item in node.items) {
        addUnique(item);
      }

      node.children.forEach((key, value) {
        walk(value, currentKey: key);
      });
    }

    walk(this);
    return result;
  }

  dynamic toDynamic() {
    if (children.isNotEmpty) {
      final mapped = <String, dynamic>{};
      children.forEach((key, value) {
        mapped[key] = value.toDynamic();
      });
      return mapped;
    }

    if (items.isNotEmpty) {
      return items;
    }

    return <String, dynamic>{};
  }
}
