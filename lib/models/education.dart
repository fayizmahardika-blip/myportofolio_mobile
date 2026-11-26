import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

const educationLevels = {
  'junior-high': 'SMP',
  'senior-high': 'SMA',
  'undergraduate': 'Sarjana (S1)',
};

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.level,
    this.fieldOfStudy = '',
    required this.startYear,
    this.endYear,
    this.grade = '',
    this.activities = '',
    this.achievements = '',
    this.description = '',
    this.schoolImage,
    this.schoolUrl,
  });

  @JsonKey(includeToJson: false)
  final int? id;
  final String institution;
  final String level;
  final String fieldOfStudy;
  final int startYear;
  final int? endYear;
  final String grade;
  final String activities;
  final String achievements;
  final String description;
  final String? schoolImage;
  final String? schoolUrl;

  String get levelLabel => educationLevels[level] ?? level;
  String get period => '$startYear – ${endYear ?? 'sekarang'}';

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
