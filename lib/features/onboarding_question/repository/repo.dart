// lib/features/onboarding/data/experiences_repository.dart
import 'package:test/core/models/models.dart';
import 'package:test/features/onboarding_question/api/api.dart';

class ExperiencesRepository {
  final ExperiencesApi api;
  ExperiencesRepository(this.api);

  Future<List<Experience>> getExperiences() => api.fetchExperiences();
}
