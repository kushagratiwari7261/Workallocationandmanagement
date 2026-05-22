import 'dart:convert';
import 'package:http/http.dart' as http;
import 'supabase.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isRecovering;

  ApiResponse({this.data, this.error, this.isRecovering = false});
}

class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );

  static Future<Map<String, String>> _getHeaders() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
    };

    final session = SupabaseService.currentSession;
    if (session?.accessToken != null) {
      headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }
    return headers;
  }

  static Future<ApiResponse<T>> request<T>(
    String path, {
    required String method,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final headers = await _getHeaders();
      http.Response response;

      final client = http.Client();
      final future = () async {
        switch (method.toUpperCase()) {
          case 'POST':
            return await client.post(uri, headers: headers, body: jsonEncode(body));
          case 'PATCH':
            return await client.patch(uri, headers: headers, body: jsonEncode(body));
          case 'DELETE':
            return await client.delete(uri, headers: headers);
          case 'GET':
          default:
            return await client.get(uri, headers: headers);
        }
      }();

      // Implement 15-second timeout as in React Native code
      response = await future.timeout(const Duration(seconds: 15));

      if (response.statusCode == 204) {
        return ApiResponse(data: null, error: null);
      }

      final contentType = response.headers['content-type'] ?? '';
      dynamic decodedBody;
      if (contentType.contains('application/json')) {
        decodedBody = jsonDecode(response.body);
      } else {
        return ApiResponse(
          data: null,
          error: 'Server Error (${response.statusCode}): Non-JSON response',
        );
      }

      if (response.statusCode >= 400) {
        final errorMsg = decodedBody is Map ? decodedBody['error'] ?? 'HTTP Error ${response.statusCode}' : 'HTTP Error ${response.statusCode}';
        final isCircuitOpen = response.statusCode == 503 || errorMsg == 'SERVICE_TEMPORARILY_UNAVAILABLE';
        return ApiResponse(
          data: null,
          error: errorMsg,
          isRecovering: isCircuitOpen,
        );
      }

      final dynamic responseData = decodedBody is Map && decodedBody.containsKey('data') 
          ? decodedBody['data'] 
          : decodedBody;

      return ApiResponse(data: responseData as T, error: null);
    } catch (err) {
      return ApiResponse(
        data: null,
        error: err.toString(),
      );
    }
  }

  static Future<ApiResponse<T>> get<T>(String path) => request<T>(path, method: 'GET');
  static Future<ApiResponse<T>> post<T>(String path, dynamic body) => request<T>(path, method: 'POST', body: body);
  static Future<ApiResponse<T>> patch<T>(String path, dynamic body) => request<T>(path, method: 'PATCH', body: body);
  static Future<ApiResponse<T>> delete<T>(String path) => request<T>(path, method: 'DELETE');
}
