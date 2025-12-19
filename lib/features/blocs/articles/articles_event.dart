abstract class ArticlesEvent {}

class LoadArticles extends ArticlesEvent {}

class SelectArticle extends ArticlesEvent {
  final int articleId;

  SelectArticle(this.articleId);
}
