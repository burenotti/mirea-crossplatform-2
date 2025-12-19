import 'package:practice2/features/entities/faq_item.dart';

abstract class FaqState {}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqLoaded extends FaqState {
  final List<FaqItem> items;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  FaqLoaded({
    required this.items,
    required this.categories,
    this.selectedCategory,
    this.searchQuery = '',
  });

  FaqLoaded copyWith({
    List<FaqItem>? items,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return FaqLoaded(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class FaqError extends FaqState {
  final String message;

  FaqError(this.message);
}
