import 'package:practice2/features/entities/faq_item.dart';
import 'package:practice2/features/stores/faq_store.dart';

class FaqStoreImpl implements FaqStore {
  final List<FaqItem> _faqItems = [
    // Категория: Привычки
    FaqItem(
      id: 1,
      question: 'Как создать новую привычку?',
      answer: 'Нажмите на кнопку "+" на главном экране, введите название привычки, выберите иконку и установите целевое количество дней для формирования привычки.',
      category: 'Привычки',
    ),
    FaqItem(
      id: 2,
      question: 'Как отметить выполнение привычки?',
      answer: 'На карточке привычки нажмите кнопку "Отметить" или галочку. Ваша текущая серия автоматически обновится.',
      category: 'Привычки',
    ),
    FaqItem(
      id: 3,
      question: 'Что такое серия (streak)?',
      answer: 'Серия — это количество дней подряд, в течение которых вы выполняли привычку. Максимальная серия показывает ваш лучший результат.',
      category: 'Привычки',
    ),
    FaqItem(
      id: 4,
      question: 'Можно ли редактировать привычку?',
      answer: 'Да, откройте карточку привычки и нажмите на кнопку редактирования. Вы можете изменить название, иконку и целевое количество дней.',
      category: 'Привычки',
    ),
    FaqItem(
      id: 5,
      question: 'Как удалить привычку?',
      answer: 'Откройте карточку привычки, нажмите на меню (три точки) и выберите "Удалить". Внимание: история выполнения будет потеряна.',
      category: 'Привычки',
    ),

    // Категория: Оплата
    FaqItem(
      id: 6,
      question: 'Приложение платное?',
      answer: 'Базовая версия приложения полностью бесплатна. Премиум-подписка открывает дополнительные функции: неограниченное количество привычек, детальную статистику и синхронизацию между устройствами.',
      category: 'Оплата',
    ),
    FaqItem(
      id: 7,
      question: 'Какие способы оплаты доступны?',
      answer: 'Мы принимаем оплату через Apple Pay, Google Pay, банковские карты (Visa, MasterCard, МИР) и другие популярные платежные системы.',
      category: 'Оплата',
    ),
    FaqItem(
      id: 8,
      question: 'Можно ли отменить подписку?',
      answer: 'Да, вы можете отменить подписку в любой момент через настройки вашего аккаунта в App Store или Google Play. Доступ к премиум-функциям сохранится до окончания оплаченного периода.',
      category: 'Оплата',
    ),
    FaqItem(
      id: 9,
      question: 'Есть ли пробный период?',
      answer: 'Да, новые пользователи получают 7 дней бесплатного доступа ко всем премиум-функциям. Отмена в любой момент без списания средств.',
      category: 'Оплата',
    ),

    // Категория: Данные
    FaqItem(
      id: 10,
      question: 'Где хранятся мои данные?',
      answer: 'Все ваши данные хранятся локально на вашем устройстве. С премиум-подпиской вы можете включить облачную синхронизацию для резервного копирования.',
      category: 'Данные',
    ),
    FaqItem(
      id: 11,
      question: 'Безопасны ли мои данные?',
      answer: 'Да, мы используем современные методы шифрования. Ваши персональные данные не передаются третьим лицам и используются исключительно для работы приложения.',
      category: 'Данные',
    ),
    FaqItem(
      id: 12,
      question: 'Как экспортировать данные?',
      answer: 'В настройках профиля выберите "Экспорт данных". Вы можете скачать все свои привычки и статистику в формате CSV или JSON.',
      category: 'Данные',
    ),
    FaqItem(
      id: 13,
      question: 'Синхронизируются ли данные между устройствами?',
      answer: 'Синхронизация доступна пользователям с премиум-подпиской. После активации ваши данные автоматически синхронизируются через iCloud или Google Drive.',
      category: 'Данные',
    ),
    FaqItem(
      id: 14,
      question: 'Что будет с данными при удалении приложения?',
      answer: 'При удалении приложения все локальные данные будут удалены. Если у вас включена облачная синхронизация, данные можно восстановить при повторной установке.',
      category: 'Данные',
    ),
  ];

  @override
  List<FaqItem> getAllFaq() {
    return List.unmodifiable(_faqItems);
  }

  @override
  List<FaqItem> searchFaq(String query) {
    if (query.isEmpty) {
      return getAllFaq();
    }

    final lowercaseQuery = query.toLowerCase();
    return _faqItems.where((item) {
      return item.question.toLowerCase().contains(lowercaseQuery) ||
          item.answer.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  List<FaqItem> filterByCategory(String? category) {
    if (category == null || category.isEmpty || category == 'Все') {
      return getAllFaq();
    }

    return _faqItems.where((item) => item.category == category).toList();
  }

  @override
  List<String> getCategories() {
    final categories = _faqItems.map((item) => item.category).toSet().toList();
    categories.sort();
    return ['Все', ...categories];
  }
}
