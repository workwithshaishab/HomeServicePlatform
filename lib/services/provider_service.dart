import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/provider_profile.dart';
import 'api_config.dart';

class ProviderServiceException implements Exception {
  final String message;
  ProviderServiceException(this.message);

  @override
  String toString() => message;
}

class ProviderService {
  static const String _baseUrl = '$apiBaseUrl/api/providers';

  /// Predefined service categories shown in the provider signup dropdown.
  /// Falls back to a local list if the server call fails, so signup still
  /// works even if this one endpoint is briefly unreachable.
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // fall through to local fallback
    }
    return const [
      'Plumbing',
      'Electrical',
      'Cleaning',
      'Carpentry',
      'Painting',
      'Appliance Repair',
      'Pest Control',
      'Gardening',
      'Moving & Packing',
    ];
  }

  static Future<List<ProviderProfile>> listProviders({
    String? serviceCategory,
    bool availableOnly = false,
    bool verifiedOnly = false,
    int limit = 50,
  }) async {
    final queryParams = <String, String>{
      if (serviceCategory != null && serviceCategory.isNotEmpty) 'service_category': serviceCategory,
      if (availableOnly) 'available_only': 'true',
      if (verifiedOnly) 'verified_only': 'true',
      'limit': limit.toString(),
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ProviderServiceException('Request timed out. Please check your connection.');
    } catch (_) {
      throw ProviderServiceException('Unable to reach the server. Please check your connection.');
    }

    if (response.statusCode != 200) {
      throw ProviderServiceException('Failed to load service providers.');
    }

    try {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => ProviderProfile.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw ProviderServiceException('Unexpected response from server.');
    }
  }

  /// Fetches the logged-in provider's own profile via GET /api/profile/me.
  /// Requires the bearer token returned from login/signup.
  static Future<ProviderProfile> getMyProfile(String accessToken) async {
    final uri = Uri.parse('$apiBaseUrl/api/profile/me');

    http.Response response;
    try {
      response = await http
          .get(uri, headers: {'Authorization': 'Bearer $accessToken'})
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ProviderServiceException('Request timed out. Please check your connection.');
    } catch (_) {
      throw ProviderServiceException('Unable to reach the server. Please check your connection.');
    }

    if (response.statusCode == 401) {
      throw ProviderServiceException('Your session has expired. Please log in again.');
    }
    if (response.statusCode != 200) {
      throw ProviderServiceException('Failed to load your profile.');
    }

    try {
      return ProviderProfile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      throw ProviderServiceException('Unexpected response from server.');
    }
  }
}