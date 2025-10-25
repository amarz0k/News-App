import 'package:flutter/material.dart';
import 'package:news_application/constants/app_images.dart';

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
        categoryName: "General",
        imageUrl: isDarkMode
            ? AppImages.generalDarkCategoryBG
            : AppImages.generalLightCategoryBG,
      ),
      CategoryModel(
        id: "business",
        categoryName: "Business",
        imageUrl: isDarkMode
            ? AppImages.businessDarkCategoryBG
            : AppImages.businessLightCategoryBG,
      ),
      CategoryModel(
        id: "sports",
        categoryName: "Sports",
        imageUrl: isDarkMode
            ? AppImages.sportsDarkCategoryBG
            : AppImages.sportsLightCategoryBG,
      ),
      CategoryModel(
        id: "health",
        categoryName: "Health",
        imageUrl: isDarkMode
            ? AppImages.healthDarkCategoryBG
            : AppImages.healthLightCategoryBG,
      ),
      CategoryModel(
        id: "entertainment",
        categoryName: "Entertainment",
        imageUrl: isDarkMode
            ? AppImages.entertainmentDarkCategoryBG
            : AppImages.entertainmentLightCategoryBG,
      ),
      CategoryModel(
        id: "technology",
        categoryName: "Technology",
        imageUrl: isDarkMode
            ? AppImages.technologyDarkCategoryBG
            : AppImages.technologyLightCategoryBG,
      ),
      CategoryModel(
        id: "science",
        categoryName: "Science",
        imageUrl: isDarkMode
            ? AppImages.scienceDarkCategoryBG
            : AppImages.scienceLightCategoryBG,
      ),
    ];
  }
}
