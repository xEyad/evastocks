class TradingModel {
  String? code;
  String? msg;
  List<TradingData>? data;
  Meta? meta;

  TradingModel({this.code, this.msg, this.data, this.meta});

  TradingModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TradingData>[];
      json['data'].forEach((v) {
        data!.add(new TradingData.fromJson(v));
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

class TradingData {
  num? opinionId;
  num? listingId;
  String? analystName;
  String? stockName;
  String? stockSymbol;
  dynamic stockBio;
  String? opinionImage;
  List<dynamic>? opinionImages;
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
  String? opinionStopLossValidityText;
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
  String? listName;

  TradingData(
      {this.opinionId,
      this.listingId,
      this.analystName,
      this.stockName,
      this.stockSymbol,
      this.stockBio,
      this.opinionImages,
      this.opinionImage,
      this.opinionExtraInfo,
      this.opinionDate,
      this.opinionTypeText,
      this.opinionType,
      this.opinionOrderTypeText,
      this.opinionOrderType,
      this.opinionEntryPrice,
      this.opinionTargetPrice,
      this.changePercentage,
      this.opinionBuyPercentage,
      this.stockTodayPrice,
      this.opinionDuration,
      this.opinionStopLossValidity,
      this.opinionStopLossValidityText,
      this.opinionCategoryText,
      this.opinionCategory,
      this.opinionStopLoss,
      this.marketCap,
      this.shariaCompliance,
      this.favouritesCount,
      this.isFavorite,
      this.commentsCount,
      this.opinionStatusText,
      this.opinionStatus,
      this.isMine,
      this.isSubscribed,this.listName});

  TradingData.fromJson(Map<String, dynamic> json) {
    opinionId = json['opinionId'];
    listingId = json['listingId'];
    analystName = json['analystName'];
    stockName = json['stockName'];
    stockSymbol = json['stockSymbol'];
    stockBio = json['stockBio'];
    opinionImage = json['stockImage'];
    opinionImages = json['opinionImages'];
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
    opinionStopLossValidityText = json['opinionStopLossValidityText'];
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
    listName = json['listName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['opinionId'] = this.opinionId;
    data['listingId'] = this.listingId;
    data['analystName'] = this.analystName;
    data['stockName'] = this.stockName;
    data['stockSymbol'] = this.stockSymbol;
    data['stockBio'] = this.stockBio;
    data['stockImage'] = this.opinionImage;
    data['opinionExtraInfo'] = this.opinionExtraInfo;
    data['opinionDate'] = this.opinionDate;
    data['opinionTypeText'] = this.opinionTypeText;
    data['opinionType'] = this.opinionType;
    data['opinionOrderTypeText'] = this.opinionOrderTypeText;
    data['opinionOrderType'] = this.opinionOrderType;
    data['opinionEntryPrice'] = this.opinionEntryPrice;
    data['opinionTargetPrice'] = this.opinionTargetPrice;
    data['changePercentage'] = this.changePercentage;
    data['opinionBuyPercentage'] = this.opinionBuyPercentage;
    data['stockTodayPrice'] = this.stockTodayPrice;
    data['opinionDuration'] = this.opinionDuration;
    data['opinionStopLossValidity'] = this.opinionStopLossValidity;
    data['opinionStopLossValidityText'] = this.opinionStopLossValidityText;
    data['opinionCategoryText'] = this.opinionCategoryText;
    data['opinionCategory'] = this.opinionCategory;
    data['opinionStopLoss'] = this.opinionStopLoss;
    data['marketCap'] = this.marketCap;
    data['shariaCompliance'] = this.shariaCompliance;
    data['favouritesCount'] = this.favouritesCount;
    data['isFavorite'] = this.isFavorite;
    data['commentsCount'] = this.commentsCount;
    data['opinionStatusText'] = this.opinionStatusText;
    data['opinionStatus'] = this.opinionStatus;
    data['isMine'] = this.isMine;
    data['is_subscribed'] = this.isSubscribed;
    data['listName']= this.listName;
    return data;
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
