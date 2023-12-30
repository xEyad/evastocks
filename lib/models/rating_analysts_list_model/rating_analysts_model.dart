class RatingAnalystsListModel {
  String code;
  String msg;
  List<DataItem> data;
  Meta? meta;

  RatingAnalystsListModel(
      {required this.code,
      required this.msg,
      required this.data,
      required this.meta});

  factory RatingAnalystsListModel.fromJson(Map<String, dynamic> json) {
    return RatingAnalystsListModel(
      code: json['code'] ?? "",
      msg: json['msg'] ?? '',
      data: (json['data'] as List).map((i) => DataItem.fromJson(i)).toList(),
      meta: Meta.fromJson(json['meta']??{}),
    );
  }
}

class DataItem {
  num? id;
  String avatar;
  String name;
  String aboutMe;
  num? ratingsCount;
  num? isFavorite;
  bool? isSubscribed;
  String planId;
  num? planPrice;
  bool? isMine;
  num? marketId;
  String analystName;
  double cashPercentage;
  String type;
  String bio;
  String currency;

  DataItem({
    required this.id,
    required this.avatar,
    required this.name,
    required this.aboutMe,
    required this.ratingsCount,
    required this.isFavorite,
    required this.isSubscribed,
    required this.planId,
    required this.planPrice,
    required this.isMine,
    required this.marketId,
    required this.analystName,
    required this.cashPercentage,
    required this.type,
    required this.bio,
    required this.currency,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      id: json['id'],
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      aboutMe: json['about_me'] ?? '',
      ratingsCount: json['ratings_count'],
      isFavorite: json['is_favorite'],
      isSubscribed: json['is_subscribed'],
      planId: json['plan_id'] ?? "",
      planPrice: json['plan_price'],
      isMine: json['is_mine'],
      marketId: json['market_id'],
      analystName: json['analyst_name'] ?? "",
      cashPercentage: json['cash_percentage'].toDouble(),
      type: json['type'] ?? "",
      bio: json['bio'] ?? "",
      currency: json['currency'] ?? "",
    );
  }
}

class Meta {
  num? id;
  String avatar;
  String name;
  String aboutMe;
  num? ratingsCount;
  bool? isFavorite;
  bool? isSubscribed;
  String planId;
  num? planPrice;
  bool? isMine;
  num? marketId;
  String analystName;
  double cashPercentage;
  String type;
  String bio;
  String currency;

  Meta({
    required this.id,
    required this.avatar,
    required this.name,
    required this.aboutMe,
    required this.ratingsCount,
    required this.isFavorite,
    required this.isSubscribed,
    required this.planId,
    required this.planPrice,
    required this.isMine,
    required this.marketId,
    required this.analystName,
    required this.cashPercentage,
    required this.type,
    required this.bio,
    required this.currency,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'],
      avatar: json['avatar'] ?? "",
      name: json['name'] ?? "",
      aboutMe: json['about_me'] ?? "",
      ratingsCount: json['ratings_count'],
      isFavorite: json['is_favorite'],
      isSubscribed: json['is_subscribed'],
      planId: json['plan_id'] ?? "",
      planPrice: json['plan_price'],
      isMine: json['is_mine'],
      marketId: json['market_id'],
      analystName: json['analyst_name'] ?? "",
      cashPercentage: json['cash_percentage']?.toDouble() ??0,
      type: json['type'] ?? '',
      bio: json['bio'] ?? "",
      currency: json['currency'] ?? "",
    );
  }
}
