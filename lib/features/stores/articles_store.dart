import 'package:practice2/features/entities/article.dart';

abstract class ArticlesStore {
  List<Article> getArticles();
  Article? getArticleById(int id);
}
