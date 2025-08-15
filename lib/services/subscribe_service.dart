import 'package:go_nqk_entry_fe/services/api_client.dart';

class SubscribeResponse {
  final String message;

  SubscribeResponse({required this.message});
}

abstract class SubscribeService {
  Future<ApiResponse<SubscribeResponse>> sendSubcription({
    required String email,
  });

  Future<ApiResponse<SubscribeResponse>> sendUnsubscription({
    required String email,
  });
}

class SubscribeServiceImpl implements SubscribeService {
  final ApiClient apiClient;

  SubscribeServiceImpl(this.apiClient);

  @override
  Future<ApiResponse<SubscribeResponse>> sendSubcription({
    required String email,
  }) {
    final endpoint = '/subscription/subscribe';
    return apiClient.post(
      endpoint: endpoint,
      data: {'email': email},
      fromJson: (data) => SubscribeResponse(message: data['message']),
    );
  }

  @override
  Future<ApiResponse<SubscribeResponse>> sendUnsubscription({
    required String email,
  }) {
    final endpoint = '/subscription/deleteSubscriber';
    return apiClient.post(
      endpoint: endpoint,
      data: {'email': email},
      fromJson: (data) => SubscribeResponse(message: data['message']),
    );
  }
}
