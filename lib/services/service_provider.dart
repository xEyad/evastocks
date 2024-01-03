import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nosooh/services/api_service.dart';

import '../models/analyst_profile/analyst_profile_model.dart';
import '../models/analysts_model/analysts_model.dart';
import '../models/chart_data_model/chart_data_model.dart';
import '../models/markets_model/markets_model.dart';
import '../models/rating_analysts_list_model/rating_analysts_model.dart';
import '../models/rating_favorite_analysts_list_model/rating_favorite_analysts_list_model.dart';
import '../models/ratings_logs_model/rating_logs_model.dart';
import '../models/ratings_model/rating_model.dart';
import '../models/trading_model/trading_model.dart';
import '../screens/walkthrough/walkthrough.dart';

class ServiceProvider extends APIService {
  Future<Map> getAnalystList(
      {int cursor = 1, String? appliedFilter, String? searchQuery}) async {
    String analystListAPI =
        'recommendation/companies?cursor=${cursor.toString()}';

    //Filters
    if (appliedFilter != null) {
      analystListAPI += '&sort=$appliedFilter&';
    }

    if (searchQuery != null) {
      analystListAPI += '&search=$searchQuery';
    }

    final res = await postRequest(
            url: webBaseUrl + analystListAPI, body: {}, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    notifyListeners();
    return res;
  }

  Future<void> unAuthorizedLogOut({required context}) async {
    const secureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ));
    await secureStorage.deleteAll();
  }

  RatingAnalystsListModel? ratingAnalystsListModel;
  Future<void> getRatingAnalystList({
    String? searchQuery,
    String?appliedFilter,
    int? marketId,
  }) async {
    String analystListAPI = 'https://evastocks.com/api/rating-lists';
    if (searchQuery!.isNotEmpty) {
      analystListAPI += '?search=$searchQuery';
    }

    if (marketId != null && searchQuery.isNotEmpty) {
      analystListAPI += '&market_id=$marketId';
    }

    if (marketId != null && searchQuery.isEmpty) {
      analystListAPI += '?market_id=$marketId';
    }

    //Filters
    if (appliedFilter != null) {
      if(analystListAPI.contains('?')){
        analystListAPI += '&sort_by=$appliedFilter';
      }else{
        analystListAPI += '?sort_by=$appliedFilter';
      }
    }

    print('get rating list endpoint $analystListAPI');
    final res = await getRequest(url: analystListAPI, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        ratingAnalystsListModel = RatingAnalystsListModel.fromJson(value.data);
        notifyListeners();
        print('get rating analysts list data successfully');
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      throw error;
      print('get rating analysts list data error ${error.toString()}');
      notifyListeners();
    });
    notifyListeners();
  }

  RatingFavoritesAnalystsListModel? ratingFavoriteAnalystsListModel;
  Future<void> getRatingFavoriteAnalystList({String? searchQuery}) async {
    String analystListAPI = 'https://evastocks.com/api/favorite/rating-lists';
    if (searchQuery!.isNotEmpty) {
      analystListAPI += '?search=$searchQuery';
    }
    print('get rating Favorite list endpoint $analystListAPI');
    final res = await getRequest(url: analystListAPI, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        ratingFavoriteAnalystsListModel =
            RatingFavoritesAnalystsListModel.fromJson(value.data);
        notifyListeners();
        print('get rating favorite analysts list data successfully');
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      print('get rating favorite analysts list data error ${error.toString()}');
      notifyListeners();
    });
    notifyListeners();
  }

  Future<Map> getRecommendationList({
    int cursor = 1,
    String? searchQuery,
    String? appliedFilter,
    String? recommendationType,
    String? recommendationStrategy,
    String? favourite,
    String? isMine,
    String? status,
  }) async {
    String endPoint =
        'recommendation/list?cursor=${cursor.toString()}&myRecommendation=1';

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      endPoint += '&search=$searchQuery';
    }

    if (appliedFilter == '1') {
      endPoint += '&profitPercentage=ASC';
    }
    if (appliedFilter == '2') {
      endPoint += '&profitPercentage=DESC';
    }
    if (appliedFilter == '3') {
      endPoint += '&recommendationDate=DESC';
    }
    if (appliedFilter == '4') {
      endPoint += '&recommendationDate=ASC';
    }

    if (recommendationType != null) {
      endPoint += '&recommendationType=$recommendationType';
    }

    if (recommendationStrategy != null) {
      endPoint += '&recommendationStrategy=$recommendationStrategy';
    }

    if (favourite != null) {
      endPoint += '&favourite=$favourite';
    }

    if (isMine != null) {
      endPoint += '&myRecommendations=$isMine';
    }

    if (status != null) {
      endPoint += '&status=$status';
    }

    print(endPoint);

    notifyListeners();
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  TradingModel? tradingModel;

  Future<void> getTradingRecommendationList({
    int cursor = 1,
    String? searchQuery,
    // String? appliedFilter,
    // String? recommendationType,
    // String? recommendationStrategy,
    // String? favourite,
    // String? isMine,
    // String? status,
    String? sortBy,
    int? orderType,
    int? status,
    int? favorite,
    int? type
  }) async {
    String endPoint = 'my-opinions?listType=2';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      if(endPoint.contains('?')){
        endPoint += '&search=$searchQuery';
      }else{
        endPoint += '?search=$searchQuery';
      }
    }
    endPoint += '&page=$cursor';
    if (sortBy != null) {
      endPoint += '&sortBy=$sortBy';
    }

    if (orderType != null) {
      endPoint += '&orderType=$orderType';
    }

    if (status != null) {
      endPoint += '&status=$status';
    }

    if (favorite != null) {
      endPoint += '&favorite=$favorite';
    }

    if (type != null) {
      endPoint += '&type=$type';
    }

    print("trading end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: webBaseUrl + endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          tradingModel = TradingModel.fromJson(value.data);
          notifyListeners();
        } catch (error) {
          print('error when modeling trading data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      notifyListeners();
    });
  }

  MarketsModel? markets;
  Future<void> getAllMarkets() async {
    String endPoint = 'https://evastocks.com/api/markets';

    print("markets end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          markets = MarketsModel.fromJson(value.data);
          notifyListeners();
        } catch (error) {
          if (kDebugMode) {
            print('error when modeling markets data $error');
          }
          notifyListeners();
        }
      } else {
        print('error when modeling markets data ');

        notifyListeners();
      }
    }).catchError((error) {
      print('error when modeling markets data $error');

      notifyListeners();
    });
  }

 // TradingModel? tradingFavoriteModel;

/*  Future<void> getTradingFavoriteList({
    String? searchQuery,
  }) async {
    String endPoint =
        'https://evastocks.com/api/favorite/opinionsV2?listType=2';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
       endPoint += '&search=$searchQuery';
     }

    print("trading favorite end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          tradingFavoriteModel = TradingModel.fromJson(value.data);
          print('get trading favorite data successfully');
          notifyListeners();
        } catch (error) {
          print('error when modeling trading favorite data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      print('error trading favorite data $error');
      notifyListeners();
    });
  }*/

/*  TradingModel? investmentFavoriteModel;

  Future<void> getInvestmentFavoriteList({
    String? searchQuery,
  }) async {
    String endPoint =
        'https://evastocks.com/api/favorite/opinionsV2?listType=3';
     if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      endPoint += '&search=$searchQuery';
     }

    print("investment favorite end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          investmentFavoriteModel = TradingModel.fromJson(value.data);
          print('get investment favorite data successfully');
          notifyListeners();
        } catch (error) {
          print('error when modeling investment favorite data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      print('error trading favorite data $error');
      notifyListeners();
    });
  }*/

  TradingModel? analystProfileOpinions;

  Future<void> getAnalystProfileOpinions({
    int cursor = 1,
    String? searchQuery,
    // String? appliedFilter,
    // String? recommendationType,
    // String? recommendationStrategy,
    // String? favourite,
    // String? isMine,
    // String? status,
    //String? sortBy,
    required String id,
    int? orderType,
    int? status,
    int? type,
    int? category,
    String? sort,
  }) async {
    String endPoint = 'https://evastocks.com/api/opinions?rating_list_id=$id';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      endPoint += '&search=$searchQuery';
    }
    endPoint += '&page=$cursor';
    // if (sortBy != null) {
    //   endPoint += '&sortBy=$sortBy';
    // }

    if (orderType != null) {
      endPoint += '&orderType=$orderType';
    }

    if (status != null) {
      endPoint += '&status=$status';
    }
    if (type != null) {
      endPoint += '&type=$type';
    }
    //1 investment  3 trading
    if (category != null) {
      endPoint += '&category=$category';
    }

    if (sort != null) {
      endPoint += '&sortBy=$sort';
    }

    print("get analyst profile opinions end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          analystProfileOpinions = TradingModel.fromJson(value.data);
          notifyListeners();
          print('get analystProfileOpinions data successfully');
        } catch (error) {
          print('error when modeling analystProfileOpinions data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      print('error when modeling analystProfileOpinions data $error');
      notifyListeners();
    });
  }

  TradingModel? investmentModel;

  Future<void> getInvestmentRecommendationList({
    int cursor = 1,
    String? searchQuery,
    // String? appliedFilter,
    // String? recommendationType,
    // String? recommendationStrategy,
    // String? favourite,
    // String? isMine,
    // String? status,
    String? sortBy,
    int? orderType,
    int? status,
    int? type,
    int? favorite,
  }) async {
    String endPoint = 'my-opinions?listType=3';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        endPoint += '&search=$searchQuery';
    }
    endPoint += '&page=$cursor';
    if (sortBy != null) {
      endPoint += '&sortBy=$sortBy';
    }

    if (orderType != null) {
      endPoint += '&orderType=$orderType';
    }

    if (status != null) {
      endPoint += '&status=$status';
    }

    if (type != null) {
      endPoint += '&type=$type';
    }

    if (favorite != null) {
      endPoint += '&favorite=$favorite';
    }

    print("investment end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: webBaseUrl + endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          investmentModel = TradingModel.fromJson(value.data);
          notifyListeners();
        } catch (error) {
          print('error when modeling investment data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      notifyListeners();
    });
  }

  Future<void> getAnalystProfile({
    int cursor = 1,
    String? searchQuery,
    String? sortBy,
    int? orderType,
    int? id,
    int? status,
  }) async {
    String endPoint = 'api/opinion-lists-single?rating_list_id=${id.toString}';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      endPoint += '&search=$searchQuery';
    }
    endPoint += '&page=$cursor';
    // if (sortBy != null) {
    //   endPoint += '&sortBy=$sortBy';
    // }

    if (orderType != null) {
      endPoint += '&orderType=$orderType';
    }

    if (status != null) {
      endPoint += '&status=$status';
    }

    // if (favorite != null) {
    //   endPoint += '&favorite=$favorite';
    // }

    print("trading end point $endPoint");

    notifyListeners();
    final res = await getRequest(
      url: webBaseUrl + endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        try {
          tradingModel = TradingModel.fromJson(value.data);
          notifyListeners();
        } catch (error) {
          print('error when modeling trading data $error');
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    }).catchError((error) {
      notifyListeners();
    });
  }

  AnalystsModel? analystsModel;
  Future<void> getTradingAnalystList({
    String? appliedFilter,
    int? marketId,
    String? searchQuery,
  }) async {
    String analystListAPI = 'https://evastocks.com/api/opinion-lists?type=2';

    //Filters
    if (appliedFilter != null) {
      analystListAPI += '&sortBy=$appliedFilter';
    }
    if (marketId != null) {
      analystListAPI += '&market_id=$marketId';
    }

    if(searchQuery!= null && searchQuery.isNotEmpty){
      analystListAPI += '&search=$searchQuery';
    }


    int sortBy = int.parse(appliedFilter!);
    print(sortBy);
    print(analystListAPI);
    final res = await getRequest(url: analystListAPI, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        analystsModel = AnalystsModel.fromJson(value.data);
        print(' get trading analysis list successfully');
        print(analystsModel!.code!);

        notifyListeners();
      } else {
        print('error when get trading analysis list ');
        notifyListeners();
      }
    }).catchError((error) {
      print('error when get trading analysis list $error');

      notifyListeners();
    });
    notifyListeners();
  }

  AnalystsModel? analystsInvestmentModel;
  Future<void> getInvestmentAnalystList({
    String? appliedFilter,
    int? marketId,
    String? searchQuery,
  }) async {
    String analystListAPI = 'https://evastocks.com/api/opinion-lists?type=3';
    int sortBy = int.parse(appliedFilter!);
    print(sortBy);
    //Filters
    if (appliedFilter != null) {
      analystListAPI += '&sortBy=$sortBy';
    }
    if (marketId != null) {
      analystListAPI += '&market_id=$marketId';
    }

    if(searchQuery != null && searchQuery.isNotEmpty){
      analystListAPI += '&search=$searchQuery';
    }


    final res = await getRequest(
            url:
            analystListAPI,
            hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
      print(value.realUri);
        analystsInvestmentModel = AnalystsModel.fromJson(value.data);
        print(' get investment analysis list successfully');

        notifyListeners();
      } else {
        print('error when get investment analysis list ');
        notifyListeners();
      }
    }).catchError((error) {
      print('error when get investment analysis list $error');

      notifyListeners();
    });
    notifyListeners();
  }

/*
  Future<Map> getAnalystRecommendationList() async {
    const String endPoint = 'recommendation/mylist';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getMyRecommendationList({
    int cursor = 1,
    String? searchQuery,
    String? appliedFilter,
    String? recommendationType,
    String? recommendationStrategy,
    String? favourite,
    String? isMine,
  }) async {
    String endPoint =
        'recommendation/myRecommendations?cursor=${cursor.toString()}';

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      endPoint += '&search=$searchQuery';
    }

    if (appliedFilter == '1') {
      endPoint += '&profitPercentage=ASC';
    }
    if (appliedFilter == '2') {
      endPoint += '&profitPercentage=DESC';
    }
    if (appliedFilter == '3') {
      endPoint += '&recommendationDate=DESC';
    }
    if (appliedFilter == '4') {
      endPoint += '&recommendationDate=ASC';
    }

    if (recommendationType != null) {
      endPoint += '&recommendationType=$recommendationType';
    }

    if (recommendationStrategy != null) {
      endPoint += '&recommendationStrategy=$recommendationStrategy';
    }

    if (favourite != null) {
      endPoint += '&favourite=$favourite';
    }

    if (isMine != null) {
      endPoint += '&myRecommendations=$isMine';
    }

    print(endPoint);

    notifyListeners();

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }
*/
  Future<Map> likeRecommendation(int recommendationId) async {
    const String endPoint = 'recommendation/like';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'recommendationId': recommendationId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<void> favoriteRecommendation(int opinionId) async {
    const String endPoint = 'api/opinion/favorite';
    print(opinionId.toString());
    Map<String, dynamic> body = {
      'opinionId': opinionId,
    };
    final res = await postRequestFormData(
            url: 'https://evastocks.com/api/opinion/favorite',
            hasToken: true,
            body: body)
        .then((value) async {
      print('response');
      print(value.toString());
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        print('add to favorites successfully');
      } else {
        print('add to favorites error ');
      }
    }).catchError((error) {
      print('add to favorites error $error');
    });
  }

  Future<void> commentOpinion(int opinionId, String comment) async {
    Map<String, dynamic> body = {
      'message': comment,
      'recordId': opinionId,
      'recordType': 'OPINION',
    };
    final res = await postRequestFormData(
            url: 'https://evastocks.com/api/comment/create',
            hasToken: true,
            body: body)
        .then((value) async {
      print('response');
      print(value.toString());
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        print('add comment successfully');
      } else {
        print('add comment error ');
      }
    }).catchError((error) {
      print('add comment error $error');
    });
  }

  Future<Map> disLikeRecommendation(int recommendationId) async {
    const String endPoint = 'recommendation/dislike';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'recommendationId': recommendationId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> recommendationNotify(int recommendationId) async {
    const String endPoint = 'recommendation/notify';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'recommendationId': recommendationId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> recommendationDeNotify(int recommendationId) async {
    const String endPoint = 'recommendation/denotify';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'recommendationId': recommendationId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> favAnalyst({required String companyId}) async {
    const String endPoint = 'recommendation/favourite';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'companyId': companyId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> recommendationFavouriteMultiple(List analysts) async {
    const String endPoint = 'recommendation/favourite-multiple';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'analysts': analysts,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> unFavAnalyst({required String companyId}) async {
    const String endPoint = 'recommendation/unfavourite';

    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {
      'companyId': companyId,
    }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> createRecommendation({
    required String stockId,
    required String recommendationDate,
    required String recommendationType,
    required String recommendationStrategy,
    required String targetPrice,
    required String stopLoss,
    required String recommendationTextAr,
    String? image1,
    String? image2,
  }) async {
    const String endPoint = 'recommendation/create';
    final res = await postRequestFormData(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {
          'stock_id': stockId,
          'recommendation_date': recommendationDate,
          'recommendation_type': recommendationType,
          'recommendation_strategy': recommendationStrategy,
          'target_price': targetPrice,
          'stop_loss': stopLoss,
          'recommendation_text_ar': recommendationTextAr,
          if (image1 != null)
            'image1': await MultipartFile.fromFile(image1, filename: 'image1'),
          if (image2 != null)
            'image2': await MultipartFile.fromFile(image2, filename: 'image2'),

          /*  'image1' : image1,
      'image2' : image2,*/
        }).then((value) async {
      print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': value.data['message']};
      }
    }).catchError((error) {
      return {'status': false, 'data': 'Issue'};
    });
    return res;
  }

  Future<Map> updateRecommendation({
    required String recommendationId,
    required String recommendationDate,
    required String recommendationType,
    required String recommendationStrategy,
    required String targetPrice,
    required String stopLoss,
    required String recommendationTextAr,
    required String image1,
    required String image2,
  }) async {
    const String endPoint = 'recommendation/update';
    final res = await postRequestFormData(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {
          'recommendation_id': recommendationId,
          'target_price': targetPrice,
          'stop_loss': stopLoss,
          'recommendation_text_ar': recommendationTextAr,
          'image1': image1,
          'image2': image2,
        }).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> addKYC({
    required String socialStatus,
    required String familyMembers,
    required String annualIncome,
    required String totalWealth,
    required String bankType,
  }) async {
    const String endPoint = 'addKyc';
    final res = await postRequestFormData(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {
          "socialStatus": socialStatus,
          "familyMembers": familyMembers,
          "annualIncome": annualIncome,
          "totalWealth": totalWealth,
          "employmentType": 1,
          "bankType": bankType,
          //  "additionalInformation" : "This is testing additionalInformation",
          //  "educationalLevel" : "This is testing educationalLevel"
        }).then((value) async {
          print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': value.data['message']};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> addKYC2({
    required String name,
    required String nationality,
    required passportImage,
  }) async {
    const String endPoint = 'addKyc2';
    final res = await postRequestFormData(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {
          "name": name,
          "nationality": nationality,
          if (passportImage != null)
            'passport_image': await MultipartFile.fromFile(passportImage, filename: 'passport_image'),
        }).then((value) async {
      print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': value.data['message']};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationUserStats() async {
    const String endPoint = 'recommendation/user_stats';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationHistory() async {
    const String endPoint = 'recommendation/history';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationSpecific(String recommendationId) async {
    String endPoint =
        'recommendation/specific?recommendationId=$recommendationId';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationCompanies() async {
    String endPoint = 'recommendation/companies';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationStock() async {
    String endPoint = 'recommendation/stock';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getRecommendationByCompanyId(String companyId) async {
    String endPoint = 'recommendation/company';
    final res = await postRequest(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {'cursor': 1, 'companyId': companyId}).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        print('dataaaaaa');

        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {'status': false, 'data': 'Not Subscribed'};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  AnalystProfileModel? analystProfileModel;
  Future<void> getAnalystProfileById(String id) async {
    String endPoint =
        'https://evastocks.com/api/opinion-lists-single?rating_list_id=${id.toString()}';
    if (kDebugMode) {
      print('get analyst profile by id endpoint $endPoint');
    }
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        analystProfileModel = AnalystProfileModel.fromJson(value.data);
        print('get analyst profile successfully');
        notifyListeners();
      } else {
        print('get analyst profile error');
        notifyListeners();
      }
    }).catchError((error) {
      throw error;
      print('get analyst profile error $error');
      notifyListeners();
    });
  }

  AnalystProfileModel? ratingAnalystProfileModel;
  Future<void> getRatingAnalystProfileById(String id) async {
    String endPoint =
        'https://evastocks.com/api/rating-lists-single?rating_list_id=${id.toString()}';
    if (kDebugMode) {
      print('get getRatingAnalystProfileById endpoint $endPoint');
    }
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        ratingAnalystProfileModel = AnalystProfileModel.fromJson(value.data);
        print('get getRatingAnalystProfileById successfully');
        notifyListeners();
      } else {
        print('get getRatingAnalystProfileById error');
        notifyListeners();
      }
    }).catchError((error) {
      print('get getRatingAnalystProfileById error $error');
      notifyListeners();
    });
  }

  ChartDataModel? chartData;
  Future<void> getChartDataById(String id) async {
    String endPoint =
        'https://evastocks.com/api/rating-list-performance?rating_list_id=${id.toString()}';
    if (kDebugMode) {
      print('get Chart Data by id endpoint $endPoint');
    }
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        chartData = ChartDataModel.fromJson(value.data);
        print('get Chart Data  successfully');
        notifyListeners();
      } else {
        print('get Chart Data error');
        notifyListeners();
      }
    }).catchError((error) {
      print('get get Chart Data error $error');
      notifyListeners();
    });
  }

  RatingModel? ratingModel;
  Future<void> getRatingDataById({
    required String id,
    int? sortBy,
    int? page,
  }) async {
    String endPoint =
        'https://evastocks.com/api/ratings?rating_list_id=${id.toString()}';
    if (sortBy != null) {
      endPoint += '&sort_by=$sortBy';
    }
    if (page != null) {
      endPoint += '&page=$page';
    }
    if (kDebugMode) {
      print('get getRatingDataById endpoint $endPoint');
    }
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        ratingModel = RatingModel.fromJson(value.data);
        print('get getRatingDataById successfully');
        notifyListeners();
      } else {
        print('get getRatingDataById  error');
        notifyListeners();
      }
    }).catchError((error) {
      print('get getRatingDataById error $error');
      notifyListeners();
    });
  }

  RatingLogsModel? ratingLogsModel;
  Future<void> getRatingLogsDataById({required String id, String? type}) async {
   // ratingLogsModel!.data.clear();
    notifyListeners();
    String endPoint =
        'https://evastocks.com/api/rating/logs?listingId=${id.toString()}';
    if (type != null) {
      endPoint += '&type=$type';
    }
    if (kDebugMode) {
      print('get getRatingLogsDataById endpoint $endPoint');
    }
    final res = await getRequest(
      url: endPoint,
      hasToken: true,
    ).then((value) async {
      print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        ratingLogsModel = RatingLogsModel.fromJson(value.data);
        print('get getRatingLogsDataById successfully');
        notifyListeners();
      } else {
        print('get getRatingLogsDataById  error');
        notifyListeners();
      }
    }).catchError((error) {
      print('get getRatingLogsDataById error $error');
      notifyListeners();
    });
  }

  Future<void> markRatingListFavorite(String id) async {
    String endPoint = 'https://evastocks.com/api/rating-lists/favorite';
    if (kDebugMode) {
      print('get markRatingListFavorite endpoint $endPoint');
    }
    final res = await postRequest(
      url: endPoint,
      hasToken: true,
      body: {"rating_list_id": id.toString()},
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        print('get markRatingListFavorite successfully');
        print(value.data.toString());
      } else {
        print('get markRatingListFavorite  error');
      }
    }).catchError((error) {
      print('get markRatingListFavorite error $error');
    });
  }

  Future<Map> getMySubscriptions() async {
    String endPoint = 'subscriptions';
    final res =
        await getRequest(url: webBaseUrl + endPoint, hasToken: true, )
            .then((value) async {
              print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getPlans({required String planId}) async {

    print("plan Id");
    print(planId);
    String endPoint = 'plans/:$planId';
    final res = await getRequest(
      url: webBaseUrl + endPoint,
      hasToken: true,
    ).then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {
          'status': false,
          'data': value.data,
        };
      }
    }).catchError((error) {
      print(error.toString());

      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> subscribe({
    required String planId,
    required String cardType,
    required String? coupon
  }) async {
    String endPoint = 'subscribe';
    final res = await postRequestFormData(
        url: webBaseUrl + endPoint,
        hasToken: true,
        body: {"planId": planId, "cardType": cardType,
          if(coupon != null &&coupon.isNotEmpty)'coupon': coupon}).then((value) async {
          print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {'status': false, 'data': value.data};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> updateYakeenAPI(
      {required String dob, required String identityNo}) async {
    String endPoint = 'call_ap_api';
    print({"dob": dob.toString(), "identity_number": identityNo});
    final res = await postRequest(
            url: webBaseUrl + endPoint,
            hasToken: true,
            body: {"dob": dob.toString(), "identity_number": identityNo})
        .then((value) async {
          print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {'status': false, 'message': value.data[
          'msg'
        ]};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getProfile() async {
    String endPoint = 'get-profile';
    final res =
        await postRequest(url: webBaseUrl + endPoint, hasToken: true, body: {})
            .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getProfile2({required context}) async {
    String endPoint = 'api/profile';
    final res = await getRequest(
      url: 'https://evastocks.com/api/profile',
      hasToken: true,
    ).then((value) async {
      if (value.data['code'].toString() == '1010') {
        unAuthorizedLogOut(context: context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Walkthrough(),
            ),
            (route) => false);
        return {
          'status': false,
        };
      }
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        print('get profile success');
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        print('get profile error1');

        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      print('get profile error2 ${error.toString()}');

      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getStocks() async {
    const String stocksListAPI = 'stocks/list';

    final res =
        await getRequest(url: webBaseUrl + stocksListAPI, hasToken: true)
            .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getContent({required String key}) async {
    const String infoContent = 'infoContent';

    final res = await postRequest(
            url: webBaseUrl + infoContent, body: {'key': key}, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getContent2({required String key}) async {
    final res = await getRequest(
            url: 'https://evastocks.com/api/contents/$key', hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getIntro() async {
    final res = await getRequest(
            url: 'https://evastocks.com/api/contents/intro_video',
            hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getFAQ() async {
    const String faqAPI = 'faq';

    final res =
        await getRequest(url: 'https://evastocks.com/api/faq', hasToken: true)
            .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getNotifications() async {
    const String notificationList = 'notificationList';

    final res = await postRequest(
            url: webBaseUrl + notificationList,
            body: {'type': 'ideas', 'notification_type': 'all'},
            hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> getNotifications2() async {
    final res = await getRequest(
            url: 'https://evastocks.com/api/notifications?cursor',
            hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        print('get notifications success');
        print(value.data);
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  checkCoupon({required String coupon, required String planId}) async {
    const String checkCouponValid = 'coupon/valid';

    final res = await postRequest(
            url: webBaseUrl + checkCouponValid,
            body: {"coupon": coupon, "planId": planId},
            hasToken: true)
        .then((value) async {
      print(value.data);
      if (value.statusCode! >= 200 && value.statusCode! <= 299 && value.data['code'] == '0' && value.data['meta']['is_valid'] == 1) {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {'status': false, 'message': value.data['msg'],'data':value.data};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  Future<Map> gerPersonalInfo() async {
    const String analystListAPI = 'get-personal-info';

    final res = await postRequest(
            url: webBaseUrl + analystListAPI, body: {}, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> getFinanceData() async {
    const String banksAPI = 'kycValues';

    final res = await getRequest(url: webBaseUrl + banksAPI, hasToken: true)
        .then((value) async {
      if (value.statusCode! >= 200 && value.statusCode! <= 299) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': []};
      }
    }).catchError((error) {
      return {'status': false, 'data': []};
    });
    return res;
  }

  bool updatedInformation = false;
  Future<dynamic> updateProfileData({
    required String fullName,
    String countryCode = '+966',
    required String personalNumber,
    required String briefYourself,
    required String birthDate,
    required String martialStatus,
    required String familyMembers,
    String? educationalLevel,
    required String annualIncome,
    required String netSavings,
    String? bankType,
    String? image
  }) async {
    updatedInformation = false;
    String endPoint = 'https://evastocks.com/api/profile/update-personal-info';
    if (kDebugMode) {
      print('update profile data endpoint $endPoint');
    }
    try{

    
    final value = await postRequestFormData(
      url: endPoint,
      hasToken: true,
      body: {
        'fullName': fullName,
        'countryCode': countryCode,
        'personalNumber': personalNumber,
        'briefYourself': briefYourself,
        'birthDate': birthDate,
        'martialStatus': martialStatus,
        'familyMembers': familyMembers,
        'educationalLevel': educationalLevel,
        'annualIncome': annualIncome,
        'netSavings': netSavings,
        //'bankType': bankType,
        if(image != null && image.isNotEmpty)
          'userImage' : await MultipartFile.fromFile(image)
      },
    );
     print('update profile response ${value.data}');

      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        updatedInformation = true;

        print('update profile data successfully');
      } else {
        updatedInformation = false;
        print('update profile data  error');
        return value.data;
      }
    }catch(error)
    {
      updatedInformation = false;
      print('update profile data  error $error');
    }
      
  }

  Future<bool> sendTestNotifications()async{
    return await postRequest(url: 'https://evastocks.com/api/send-test-notification',body: {}).then((value) {
      print(value.data);
      if(value.data['code'].toString() == '1'){
        return false;
      }else{
        return true;
      }
    });
  }
}
