abstract class FaqEvent {}

class LoadFaq extends FaqEvent {}

class SearchFaq extends FaqEvent {
  final String query;

  SearchFaq(this.query);
}

class FilterByCategory extends FaqEvent {
  final String? category;

  FilterByCategory(this.category);
}
