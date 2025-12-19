class FaqItem {
  final int id;
  final String question;
  final String answer;
  final String category;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  FaqItem copyWith({
    int? id,
    String? question,
    String? answer,
    String? category,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
    );
  }
}
