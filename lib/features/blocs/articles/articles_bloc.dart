import 'package:bloc/bloc.dart';
import 'package:practice2/features/blocs/articles/articles_event.dart';
import 'package:practice2/features/blocs/articles/articles_state.dart';
import 'package:practice2/features/stores/articles_store.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesStore articlesStore;

  ArticlesBloc({required this.articlesStore}) : super(ArticlesInitial()) {
    on<LoadArticles>(_onLoadArticles);
  }

  void _onLoadArticles(LoadArticles event, Emitter<ArticlesState> emit) {
    emit(ArticlesLoading());

    try {
      final articles = articlesStore.getArticles();
      emit(ArticlesLoaded(articles));
    } catch (e) {
      emit(ArticlesError('Не удалось загрузить статьи'));
    }
  }
}
