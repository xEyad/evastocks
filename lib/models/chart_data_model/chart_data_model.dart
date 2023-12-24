/*class ChartDataModel {
  late String code;
  late String msg;
  Data? data;

  ChartDataModel({required this.code, required this.msg, required this.data});

  ChartDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? "";
    msg = json['msg'] ?? '';
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  late String listName;
  late String indexName;
  num? performanceSinceInception;
  late String startDate;
  late String endDate;
  num? indexPerformanceSinceInception;
  late String indexStartDate;
  late String indexEndDate;
  Chart? chart;

  Data({
    required this.listName,
    required this.indexName,
    required this.performanceSinceInception,
    required this.startDate,
    required this.endDate,
    required this.indexPerformanceSinceInception,
    required this.indexStartDate,
    required this.indexEndDate,
    required this.chart,
  });

  Data.fromJson(Map<String, dynamic> json) {
    listName = json['list_name'] ?? '';
    indexName = json['index_name'] ?? '';
    performanceSinceInception = json['performance_since_inception'];
    startDate = json['start_date'] ?? '';
    endDate = json['end_date'] ?? '';
    indexPerformanceSinceInception = json['index_performance_since_inception'];
    indexStartDate = json['index_start_date'] ?? '';
    indexEndDate = json['index_end_date'] ?? '';
    chart = json['chart'] != null ? Chart.fromJson(json['chart']) : null;
  }
}

class Chart {
  List<Performance>? dailyPerformance = [];
  List<Performance>? indexPerformance = [];

  Chart({required this.dailyPerformance, required this.indexPerformance});

  Chart.fromJson(Map<String, dynamic> json) {
    if (json['daily_performance'] != null) {
      json['daily_performance'].forEach((v) {
        dailyPerformance?.add(Performance.fromJson(v));
      });
    }
    if (json['index_performance'] != null) {
      json['index_performance'].forEach((v) {
        indexPerformance?.add(Performance.fromJson(v));
      });
    }
  }
}

class Performance {
  late String date;
  num? value;

  Performance({required this.date, required this.value});

  Performance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'];
  }
}
*/
////////////////////////////////////////////

class ChartDataModel {
  late String code;
  late String msg;
  Data? data;

  ChartDataModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  ChartDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    msg = json['msg'] ?? '';
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  late String listName;
  late String indexName;
  num? performanceSinceInception;
  late String startDate;
  late String endDate;
  num? indexPerformanceSinceInception;
  late String indexStartDate;
  late String indexEndDate;
  Chart? chart;

  Data(
      {required this.listName,
      required this.indexName,
      required this.performanceSinceInception,
      required this.startDate,
      required this.endDate,
      required this.indexPerformanceSinceInception,
      required this.indexStartDate,
      required this.indexEndDate,
      required this.chart});

  Data.fromJson(Map<String, dynamic> json) {
    listName = json['list_name'] ?? '';
    indexName = json['index_name'] ?? '';
    performanceSinceInception = json['performance_since_inception'];
    startDate = json['start_date'] ?? '';
    endDate = json['end_date'] ?? '';
    indexPerformanceSinceInception = json['index_performance_since_inception'];
    indexStartDate = json['index_start_date'] ?? '';
    indexEndDate = json['index_end_date'] ?? '';
    chart = json['chart'] != null ? Chart.fromJson(json['chart']) : null;
  }
}

class Chart {
  List<DailyPerformance>? dailyPerformance;
  List<IndexPerformance>? indexPerformance;

  Chart({this.dailyPerformance, this.indexPerformance});

  Chart.fromJson(Map<String, dynamic> json) {
    if (json['daily_performance'] != null) {
      dailyPerformance = <DailyPerformance>[];
      json['daily_performance'].forEach((v) {
        dailyPerformance!.add(new DailyPerformance.fromJson(v));
      });
    }
    if (json['index_performance'] != null) {
      indexPerformance = <IndexPerformance>[];
      json['index_performance'].forEach((v) {
        indexPerformance!.add(new IndexPerformance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dailyPerformance != null) {
      data['daily_performance'] =
          this.dailyPerformance!.map((v) => v.toJson()).toList();
    }
    if (this.indexPerformance != null) {
      data['index_performance'] =
          this.indexPerformance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyPerformance {
  String? date;
  num? value;

  DailyPerformance({this.date, this.value});

  DailyPerformance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['value'] = this.value;
    return data;
  }
}

class IndexPerformance {
  String? date;
  num? value;

  IndexPerformance({this.date, this.value});

  IndexPerformance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['value'] = this.value;
    return data;
  }
}
