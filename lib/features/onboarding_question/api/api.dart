import 'package:test/configs/configs.dart';
import 'package:test/core/models/models.dart';
import 'package:test/core/services/networkClient/network.dart';

class ExperiencesApi {
  final DioClient dioClient;
  ExperiencesApi(this.dioClient);

  Future<List<Experience>> fetchExperiences({bool active = true}) async {
    final resp = await dioClient.client.get(
      AppConfigs.apiKey,
      queryParameters: {'active': active},
    );
    final data = resp.data?['data']?['experiences'] as List<dynamic>? ?? [];
    return data
        .map((e) => Experience.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
