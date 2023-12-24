class RatingFavoritesAnalystsListModel {
  String code;
  String msg;
  List<Data> data;
  dynamic meta;

  RatingFavoritesAnalystsListModel(
      {required this.code, required this.msg, required this.data, this.meta});

  factory RatingFavoritesAnalystsListModel.fromJson(Map<String, dynamic> json) {
    return RatingFavoritesAnalystsListModel(
        code: json['code'],
        msg: json['msg'],
        data: (json['data'] as List).map((i) => Data.fromJson(i)).toList(),
        meta: json['meta']);
  }
}

class Data {
  int id;
  String avatar;
  String name;
  String aboutMe;
  int ratingsCount;
  int isFavorite;
  bool isSubscribed;
  String planId;
  int planPrice;
  bool isMine;
  int marketId;
  String analystName;
  int cashPercentage;
  String type;
  String bio;
  String currency;

  Data(
      {required this.id,
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
      required this.currency});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        avatar: json['avatar'],
        name: json['name'],
        aboutMe: json['about_me'],
        ratingsCount: json['ratings_count'],
        isFavorite: json['is_favorite'],
        isSubscribed: json['is_subscribed'],
        planId: json['plan_id'],
        planPrice: json['plan_price'],
        isMine: json['is_mine'],
        marketId: json['market_id'],
        analystName: json['analyst_name'],
        cashPercentage: json['cash_percentage'],
        type: json['type'],
        bio: json['bio'],
        currency: json['currency']);
  }
}
