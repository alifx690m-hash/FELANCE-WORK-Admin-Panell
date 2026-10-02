import 'package:cloud_functions/cloud_functions.dart';

class AdminService {
  final _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> calculatePrice({
    required double providerPrice,
    double fixedMarkup = 0,
    double percentageMarkup = 0,
  }) async {
    final callable = _functions.httpsCallable('calculateMarketplacePrice');
    final result = await callable.call({
      'providerPrice': providerPrice,
      'fixedMarkup': fixedMarkup,
      'percentageMarkup': percentageMarkup,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> analyzeService(String serviceId) async {
    final callable = _functions.httpsCallable('analyzeService');
    final result = await callable.call({'serviceId': serviceId});
    return Map<String, dynamic>.from(result.data as Map);
  }
}
