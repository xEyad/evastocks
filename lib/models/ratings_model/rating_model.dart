/*class RatingModel {
  late String code;
  late String msg;
  List<Opinion>? data;
  Meta? meta;

  RatingModel(
      {required this.code,
      required this.msg,
      required this.data,
      required this.meta});

  RatingModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    msg = json['msg'] ?? '';
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Opinion.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class Opinion {
  num? opinionId;
  num? listingId;
  String? stockName;
  String? stockSymbol;
  String? stockBio;
  String? opinionImage;
  String? opinionExtraInfo;
  String? opinionDate;
  String? opinionTypeText;
  String? opinionType;
  String? opinionOrderTypeText;
  String? opinionOrderType;
  String? opinionEntryPrice;
  String? opinionTargetPrice;
  String? changePercentage;
  String? opinionBuyPercentage;
  String? stockTodayPrice;
  String? opinionDuration;
  String? opinionStopLossValidity;
  String? opinionCategoryText;
  String? opinionCategory;
  num? opinionStopLoss;
  String? marketCap;
  num? shariaCompliance;
  num? favouritesCount;
  bool? isFavorite;
  num? commentsCount;
  String? opinionStatusText;
  String? opinionStatus;
  bool? isMine;
  String? isSubscribed;

  Opinion.fromJson(Map<String, dynamic> json) {
    opinionId = json['opinionId'];
    listingId = json['listingId'];
    stockName = json['stockName'];
    stockSymbol = json['stockSymbol'];
    stockBio = json['stockBio'];
    opinionImage = json['opinionImage'];
    opinionExtraInfo = json['opinionExtraInfo'];
    opinionDate = json['opinionDate'];
    opinionTypeText = json['opinionTypeText'];
    opinionType = json['opinionType'];
    opinionOrderTypeText = json['opinionOrderTypeText'];
    opinionOrderType = json['opinionOrderType'];
    opinionEntryPrice = json['opinionEntryPrice'];
    opinionTargetPrice = json['opinionTargetPrice'];
    changePercentage = json['changePercentage'];
    opinionBuyPercentage = json['opinionBuyPercentage'];
    stockTodayPrice = json['stockTodayPrice'];
    opinionDuration = json['opinionDuration'];
    opinionStopLossValidity = json['opinionStopLossValidity'];
    opinionCategoryText = json['opinionCategoryText'];
    opinionCategory = json['opinionCategory'];
    opinionStopLoss = json['opinionStopLoss'];
    marketCap = json['marketCap'];
    shariaCompliance = json['shariaCompliance'];
    favouritesCount = json['favouritesCount'];
    isFavorite = json['isFavorite'];
    commentsCount = json['commentsCount'];
    opinionStatusText = json['opinionStatusText'];
    opinionStatus = json['opinionStatus'];
    isMine = json['isMine'];
    isSubscribed = json['is_subscribed'];
  }
}

class Meta {
  num? total;
  num? perPage;
  dynamic prevPage;
  num? currentPage;
  num? nextPage;
  num? lastPage;
  String? nextPageUrl;
  dynamic prevPageUrl;

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    prevPage = json['prev_page'];
    currentPage = json['current_page'];
    nextPage = json['next_page'];
    lastPage = json['last_page'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }
} */
/////////////////////////
class RatingModel {
  String? code;
  String? msg;
  List<Data>? data;
  Meta? meta;

  RatingModel({this.code, this.msg, this.data, this.meta});

  RatingModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  num? id;
  num? ratingListId;
  String? createdAt;
  String? opinionDuration;
  String? opinionDate;
  num? stockId;
  String? image;
  List<String>? images;
  String? stockName;
  String? stockSymbol;
  num? entryPrice;
  num? todayPrice;
  num? priceChange;
  String? marketCap;
  String? extraInfo;
  num? buyPercent;
  String? shariahCompliance;
  String? isFavorite;
  String? isSubscribed;

  Data(
      {this.id,
      this.ratingListId,
      this.createdAt,
      this.stockId,
      this.image,
      this.images,
      this.stockName,
      this.stockSymbol,
      this.entryPrice,
      this.todayPrice,
      this.priceChange,
      this.marketCap,
      this.extraInfo,
      this.buyPercent,
      this.shariahCompliance,
      this.isFavorite,
      this.isSubscribed});

  Data.fromJson(Map<String, dynamic> json) {
    print(image);
    id = json['id'];
    ratingListId = json['rating_list_id'];
    createdAt = json['created_at'];
    opinionDuration = json['opinionDuration'];
    opinionDate = json['opinionDate'];
    stockId = json['stock_id'];
    image = json['stock_image'];
    images = json['images'].cast<String>();
    stockName = json['stock_name'];
    stockSymbol = json['stock_symbol'];
    entryPrice = json['entry_price'];
    todayPrice = json['today_price'];
    priceChange = json['price_change'];
    marketCap = json['market_cap'];
    extraInfo = json['extra_info'];
    buyPercent = json['buy_percent'];
    shariahCompliance = json['shariah_compliance'];
    isFavorite = json['is_favorite'];
    isSubscribed = json['is_subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating_list_id'] = this.ratingListId;
    data['created_at'] = this.createdAt;
    data['stock_id'] = this.stockId;
    data['stock_image'] = this.image;
    data['images'] = this.images;
    data['stock_name'] = this.stockName;
    data['stock_symbol'] = this.stockSymbol;
    data['entry_price'] = this.entryPrice;
    data['today_price'] = this.todayPrice;
    data['price_change'] = this.priceChange;
    data['market_cap'] = this.marketCap;
    data['extra_info'] = this.extraInfo;
    data['buy_percent'] = this.buyPercent;
    data['shariah_compliance'] = this.shariahCompliance;
    data['is_favorite'] = this.isFavorite;
    data['is_subscribed'] = this.isSubscribed;
    return data;
  }
}

class Meta {
  num? total;
  num? perPage;
  dynamic? prevPage;
  num? currentPage;
  num? nextPage;
  num? lastPage;
  String? nextPageUrl;
  dynamic? prevPageUrl;

  Meta(
      {this.total,
      this.perPage,
      this.prevPage,
      this.currentPage,
      this.nextPage,
      this.lastPage,
      this.nextPageUrl,
      this.prevPageUrl});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    prevPage = json['prev_page'];
    currentPage = json['current_page'];
    nextPage = json['next_page'];
    lastPage = json['last_page'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['prev_page'] = this.prevPage;
    data['current_page'] = this.currentPage;
    data['next_page'] = this.nextPage;
    data['last_page'] = this.lastPage;
    data['next_page_url'] = this.nextPageUrl;
    data['prev_page_url'] = this.prevPageUrl;
    return data;
  }
}
