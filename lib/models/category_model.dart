import 'module_model.dart';

class CategoryModel {
  final String id;
  final String title;
  final String tagline;
  final String colorHex;
  final String iconName;
  final String folder;
  final String mcqPdf;
  final String mcqRelativePath;
  final int moduleCount;
  final List<ModuleModel> modules;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.tagline,
    required this.colorHex,
    required this.iconName,
    required this.folder,
    required this.mcqPdf,
    required this.mcqRelativePath,
    required this.moduleCount,
    required this.modules,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawModules = json['modules'] as List<dynamic>? ?? [];
    return CategoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      colorHex: json['color'] as String? ?? '#1565C0',
      iconName: json['icon'] as String? ?? 'book',
      folder: json['folder'] as String? ?? '',
      mcqPdf: json['mcq_pdf'] as String? ?? '',
      mcqRelativePath: json['mcq_relative_path'] as String? ?? '',
      moduleCount: (json['module_count'] as num?)?.toInt() ?? rawModules.length,
      modules: rawModules
          .map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tagline': tagline,
      'color': colorHex,
      'icon': iconName,
      'folder': folder,
      'mcq_pdf': mcqPdf,
      'mcq_relative_path': mcqRelativePath,
      'module_count': moduleCount,
      'modules': modules.map((m) => m.toJson()).toList(),
    };
  }
}
