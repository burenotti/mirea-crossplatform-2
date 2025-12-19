import 'package:practice2/features/entities/faq_item.dart';

abstract class FaqStore {
  List<FaqItem> getAllFaq();
  List<FaqItem> searchFaq(String query);
  List<FaqItem> filterByCategory(String? category);
  List<String> getCategories();
}
