class AnalystsModel {
  String? code;
  String? msg;
  List<Data>? data;
  dynamic meta;

  AnalystsModel({this.code, this.msg, this.data, this.meta});

  AnalystsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString();
    msg = json['msg'].toString();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['meta'] = this.meta;
    return data;
  }
}

class Data {
  int? id;
  String? avatar;
  String? name;
  String? aboutMe;
  int? opinionsCount;
  int? isFavorite;
  bool? isSubscribed;
  String? planId;
  int? planPrice;
  bool? isMine;
  int? marketId;
  String? analystName;
  String? type;
  String? opinionType;
  int? successCount;
  int? failedCount;
  int? pendingCount;
  num? successPercentage;
  int? buyCount;
  int? sellCount;
  String? bio;

  Data(
      {this.id,
      this.avatar,
      this.name,
      this.aboutMe,
      this.opinionsCount,
      this.isFavorite,
      this.isSubscribed,
      this.planId,
      this.planPrice,
      this.isMine,
      this.marketId,
      this.analystName,
      this.type,
      this.opinionType,
      this.successCount,
      this.failedCount,
      this.pendingCount,
      this.successPercentage,
      this.buyCount,
      this.sellCount,
      this.bio});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'].toString();
    name = json['name'].toString();
    aboutMe = json['about_me'].toString();
    opinionsCount = json['opinions_count'];
    isFavorite = json['is_favorite'];
    isSubscribed = json['is_subscribed'];
    planId = json['plan_id'].toString();
    planPrice = json['plan_price'];
    isMine = json['is_mine'];
    marketId = json['market_id'];
    analystName = json['analyst_name'].toString();
    type = json['type'].toString();
    opinionType = json['opinionType'].toString();
    successCount = json['successCount'];
    failedCount = json['failedCount'];
    pendingCount = json['pendingCount'];
    successPercentage = json['successPercentage'];
    buyCount = json['buyCount'];
    sellCount = json['sellCount'];
    bio = json['bio'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['about_me'] = this.aboutMe;
    data['opinions_count'] = this.opinionsCount;
    data['is_favorite'] = this.isFavorite;
    data['is_subscribed'] = this.isSubscribed;
    data['plan_id'] = this.planId;
    data['plan_price'] = this.planPrice;
    data['is_mine'] = this.isMine;
    data['market_id'] = this.marketId;
    data['analyst_name'] = this.analystName;
    data['type'] = this.type;
    data['opinionType'] = this.opinionType;
    data['successCount'] = this.successCount;
    data['failedCount'] = this.failedCount;
    data['pendingCount'] = this.pendingCount;
    data['successPercentage'] = this.successPercentage;
    data['buyCount'] = this.buyCount;
    data['sellCount'] = this.sellCount;
    data['bio'] = this.bio;
    return data;
  }
}
