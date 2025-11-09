// lib/features/onboarding/models/experience.dart
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Experience {
  final int id;
  final String name;
  final String tagline;
  final String description;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'icon_url')
  final String iconUrl;

  Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
