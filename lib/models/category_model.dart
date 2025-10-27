import 'package:flutter/material.dart';
import 'package:news_application/constants/app_images.dart';
import 'package:news_application/l10n/app_localizations.dart';

class CategoryModel {
  final String id;
  final String categoryName;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.imageUrl,
  });

  static List<CategoryModel> getCategories(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;

    return [
      CategoryModel(
        id: "general",
        categoryName: AppLocalizations.of(context)!.general,
        imageUrl: isDarkMode
            ? AppImages.generalDarkCategoryBG
            : AppImages.generalLightCategoryBG,
      ),
      CategoryModel(
        id: "business",
        categoryName: AppLocalizations.of(context)!.business,
        imageUrl: isDarkMode
            ? AppImages.businessDarkCategoryBG
            : AppImages.businessLightCategoryBG,
      ),
      CategoryModel(
        id: "sports",
        categoryName: AppLocalizations.of(context)!.sports,
        imageUrl: isDarkMode
            ? AppImages.sportsDarkCategoryBG
            : AppImages.sportsLightCategoryBG,
      ),
      CategoryModel(
        id: "health",
        categoryName: AppLocalizations.of(context)!.health,
        imageUrl: isDarkMode
            ? AppImages.healthDarkCategoryBG
            : AppImages.healthLightCategoryBG,
      ),
      CategoryModel(
        id: "entertainment",
        categoryName: AppLocalizations.of(context)!.entertainment,
        imageUrl: isDarkMode
            ? AppImages.entertainmentDarkCategoryBG
            : AppImages.entertainmentLightCategoryBG,
      ),
      CategoryModel(
        id: "technology",
        categoryName: AppLocalizations.of(context)!.technology,
        imageUrl: isDarkMode
            ? AppImages.technologyDarkCategoryBG
            : AppImages.technologyLightCategoryBG,
      ),
      CategoryModel(
        id: "science",
        categoryName: AppLocalizations.of(context)!.science,
        imageUrl: isDarkMode
            ? AppImages.scienceDarkCategoryBG
            : AppImages.scienceLightCategoryBG,
      ),
    ];
  }
}
