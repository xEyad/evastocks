class AnalystProfileModel {
  final String code;
  final String msg;
  final Data data;
  final Meta meta;

  AnalystProfileModel(
      {required this.code,
      required this.msg,
      required this.data,
      required this.meta});

  factory AnalystProfileModel.fromJson(Map<String, dynamic> json) {
    return AnalystProfileModel(
      code: json['code'],
      msg: json['msg'],
      data: Data.fromJson(json['data']),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Data {
  final num? id;
  final String avatar;
  final String name;
  final String aboutMe;
  final num? opinionsCount;
  final dynamic? isFavorite;
  final bool? isSubscribed;
  final String planId;
  final num? planPrice;
  final bool? isMine;
  final num? marketId;
  final String analystName;
  final String type;
  final String opinionType;
  final num? successCount;
  final num? failedCount;
  final num? pendingCount;
  final num? successPercentage;
  final num? buyCount;
  final num? sellCount;
  final String bio;

  Data({
    required this.id,
    required this.avatar,
    required this.name,
    required this.aboutMe,
    required this.opinionsCount,
    required this.isFavorite,
    required this.isSubscribed,
    required this.planId,
    required this.planPrice,
    required this.isMine,
    required this.marketId,
    required this.analystName,
    required this.type,
    required this.opinionType,
    required this.successCount,
    required this.failedCount,
    required this.pendingCount,
    required this.successPercentage,
    required this.buyCount,
    required this.sellCount,
    required this.bio,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      avatar: json['avatar'] ?? "",
      name: json['name'] ?? "",
      aboutMe: json['about_me'] ?? "",
      opinionsCount: json['opinions_count'],
      isFavorite: json['is_favorite'],
      isSubscribed: json['is_subscribed'],
      planId: json['plan_id'].toString() ?? '',
      planPrice: json['plan_price'],
      isMine: json['is_mine'],
      marketId: json['market_id'],
      analystName: json['analyst_name'] ?? "",
      type: json['type'] ?? '',
      opinionType: json['opinionType'] ?? '',
      successCount: json['successCount'],
      failedCount: json['failedCount'],
      pendingCount: json['pendingCount'],
      successPercentage: json['successPercentage'],
      buyCount: json['buyCount'],
      sellCount: json['sellCount'],
      bio: json['bio'] ?? '',
    );
  }
}

class Meta {
  final List<SuggestedListItem> suggestedList;

  Meta({required this.suggestedList});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      suggestedList: (json['suggested_list'] as List)
          .map((i) => SuggestedListItem.fromJson(i))
          .toList(),
    );
  }
}

class SuggestedListItem extends Data {
  SuggestedListItem({
    num? id,
    required String avatar,
    required String name,
    required String aboutMe,
    required num? opinionsCount,
    required dynamic isFavorite,
    required bool? isSubscribed,
    required String planId,
    required num? planPrice,
    required bool? isMine,
    required num? marketId,
    required String analystName,
    required String type,
    required String opinionType,
    required num? successCount,
    required num? failedCount,
    required num? pendingCount,
    required num? successPercentage,
    required num? buyCount,
    required num? sellCount,
    required String bio,
  }) : super(
          id: id,
          avatar: avatar,
          name: name,
          aboutMe: aboutMe,
          opinionsCount: opinionsCount,
          isFavorite: isFavorite,
          isSubscribed: isSubscribed,
          planId: planId,
          planPrice: planPrice,
          isMine: isMine,
          marketId: marketId,
          analystName: analystName,
          type: type,
          opinionType: opinionType,
          successCount: successCount,
          failedCount: failedCount,
          pendingCount: pendingCount,
          successPercentage: successPercentage,
          buyCount: buyCount,
          sellCount: sellCount,
          bio: bio,
        );

  factory SuggestedListItem.fromJson(Map<String, dynamic> json) {
    return SuggestedListItem(
      id: json['id'],
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      aboutMe: json['about_me'] ?? "",
      opinionsCount: json['opinions_count'],
      isFavorite: json['is_favorite'],
      isSubscribed: json['is_subscribed'],
      planId: json['plan_id'].toString() ?? '',
      planPrice: json['plan_price'],
      isMine: json['is_mine'],
      marketId: json['market_id'],
      analystName: json['analyst_name'] ?? '',
      type: json['type'] ?? '',
      opinionType: json['opinionType'] ?? '',
      successCount: json['successCount'],
      failedCount: json['failedCount'],
      pendingCount: json['pendingCount'],
      successPercentage: json['successPercentage'],
      buyCount: json['buyCount'],
      sellCount: json['sellCount'],
      bio: json['bio'] ?? '',
    );
  }
}
