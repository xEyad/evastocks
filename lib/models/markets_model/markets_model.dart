class MarketsModel {
  String? code;
  String? msg;
  List<Data>? data;
  dynamic meta;

  MarketsModel({this.code, this.msg, this.data, this.meta});

  MarketsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
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
  String? nameEn;
  String? nameAr;
  String? currencyEn;
  String? currencyAr;
  String? workingDays;
  String? timezone;

  Data(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.currencyEn,
      this.currencyAr,
      this.workingDays,
      this.timezone});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    currencyEn = json['currency_en'];
    currencyAr = json['currency_ar'];
    workingDays = json['working_days'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.nameEn;
    data['name_ar'] = this.nameAr;
    data['currency_en'] = this.currencyEn;
    data['currency_ar'] = this.currencyAr;
    data['working_days'] = this.workingDays;
    data['timezone'] = this.timezone;
    return data;
  }
}
