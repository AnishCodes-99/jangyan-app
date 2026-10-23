class ModuleModel {
  final int moduleNumber;
  final String title;
  final String subtitle;
  final String fileName;
  final String relativePath;
  final String categoryId;
  final String categoryTitle;

  const ModuleModel({
    required this.moduleNumber,
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.relativePath,
    required this.categoryId,
    required this.categoryTitle,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      moduleNumber: (json['module_number'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? 'Module',
      subtitle: json['subtitle'] as String? ?? 'Learning Module',
      fileName: json['file_name'] as String? ?? '',
      relativePath: json['relative_path'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      categoryTitle: json['category_title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_number': moduleNumber,
      'title': title,
      'subtitle': subtitle,
      'file_name': fileName,
      'relative_path': relativePath,
      'category_id': categoryId,
      'category_title': categoryTitle,
    };
  }
}
