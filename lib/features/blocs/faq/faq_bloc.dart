import 'package:bloc/bloc.dart';
import 'package:practice2/features/blocs/faq/faq_event.dart';
import 'package:practice2/features/blocs/faq/faq_state.dart';
import 'package:practice2/features/stores/faq_store.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final FaqStore faqStore;
  String _currentQuery = '';
  String? _currentCategory;

  FaqBloc({required this.faqStore}) : super(FaqInitial()) {
    on<LoadFaq>(_onLoadFaq);
    on<SearchFaq>(_onSearchFaq);
    on<FilterByCategory>(_onFilterByCategory);
  }

  void _onLoadFaq(LoadFaq event, Emitter<FaqState> emit) {
    emit(FaqLoading());

    try {
      final items = faqStore.getAllFaq();
      final categories = faqStore.getCategories();

      emit(FaqLoaded(
        items: items,
        categories: categories,
        selectedCategory: _currentCategory,
        searchQuery: _currentQuery,
      ));
    } catch (e) {
      emit(FaqError('Не удалось загрузить FAQ'));
    }
  }

  void _onSearchFaq(SearchFaq event, Emitter<FaqState> emit) {
    _currentQuery = event.query;

    try {
      var items = faqStore.searchFaq(_currentQuery);

      if (_currentCategory != null && _currentCategory != 'Все') {
        items = items.where((item) => item.category == _currentCategory).toList();
      }

      final categories = faqStore.getCategories();

      emit(FaqLoaded(
        items: items,
        categories: categories,
        selectedCategory: _currentCategory,
        searchQuery: _currentQuery,
      ));
    } catch (e) {
      emit(FaqError('Ошибка поиска'));
    }
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<FaqState> emit) {
    _currentCategory = event.category;

    try {
      var items = faqStore.filterByCategory(_currentCategory);

      if (_currentQuery.isNotEmpty) {
        items = items.where((item) {
          final lowercaseQuery = _currentQuery.toLowerCase();
          return item.question.toLowerCase().contains(lowercaseQuery) ||
              item.answer.toLowerCase().contains(lowercaseQuery);
        }).toList();
      }

      final categories = faqStore.getCategories();

      emit(FaqLoaded(
        items: items,
        categories: categories,
        selectedCategory: _currentCategory,
        searchQuery: _currentQuery,
      ));
    } catch (e) {
      emit(FaqError('Ошибка фильтрации'));
    }
  }
}
