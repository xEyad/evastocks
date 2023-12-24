/*class RatingLogsModel {
  late String code;
  late String msg;
  List<Opinion>? data;
  Meta? meta;

  RatingLogsModel(
      {required this.code,
      required this.msg,
      required this.data,
      required this.meta});

  RatingLogsModel.fromJson(Map<String, dynamic> json) {
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
}


 */
class RatingLogsModel {
  final String code;
  final String msg;
  final List<StockData> data;
  final dynamic meta; // dynamic because it's null in the provided data

  RatingLogsModel({
    required this.code,
    required this.msg,
    required this.data,
    this.meta,
  });

  factory RatingLogsModel.fromJson(Map<String, dynamic> json) {
    return RatingLogsModel(
      code: json['code'].toString(),
      msg: json['msg'],
      data: (json['data'] as List)
          .map((item) => StockData.fromJson(item))
          .toList(),
      meta: json['meta'],
    );
  }
}

class StockData {
  final int id;
  final String type;
  final String stockName;
  final String stockSymbol;
  final String entryPrice;
  final int listingId;
  final int ratingId;
  final DataDetails data;
  final String createdAt;
  final String createdTime;

  StockData({
    required this.id,
    required this.type,
    required this.stockName,
    required this.stockSymbol,
    required this.entryPrice,
    required this.listingId,
    required this.ratingId,
    required this.data,
    required this.createdAt,
    required this.createdTime,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      id: json['id'],
      type: json['type'],
      stockName: json['stockName'],
      stockSymbol: json['stockSymbol'],
      entryPrice: json['entryPrice'],
      listingId: json['listingId'],
      ratingId: json['ratingId'],
      data: DataDetails.fromJson(json['data']),
      createdAt: json['created_at'],
      createdTime: json['created_time'],
    );
  }
}

class DataDetails {
  final String? image;
  final String? extraInfo;
  final String? buyPercent;
  final dynamic? sellReason;
  final dynamic price;
  final String? entryPrice;
  final double? exitPrice;

  DataDetails({
    this.sellReason,
    this.exitPrice,
    this.image,
    this.extraInfo,
    this.price,
    this.buyPercent,
    this.entryPrice,
  });

  factory DataDetails.fromJson(Map<String, dynamic> json) {
    return DataDetails(
      sellReason: json['sell_reason'],
      price: json['price'],
      exitPrice: double.tryParse(json['exit_price'].toString()),
      image: json['image'],
      extraInfo: json['extra_info'],
      buyPercent: (double.tryParse(json['buy_percent'].toString()) ?? 0 ).toString() ,
      entryPrice: (double.tryParse(json['entry_price'].toString()) ?? 0).toString(),
    );
  }
}

