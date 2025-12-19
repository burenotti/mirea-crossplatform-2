#import "./template/template.typ": *

#show: project.with(
  title: "Отчёт по практической работе №9",
  theme: "",
  department: "Математического обеспечения и стандартизации информационных технологий",
  course: "Разработка кроссплатформенных мобильных приложений",
  authors: (
    "Буренин А.А.",
  ),
  lecturer: "Шешуков Л.С.",
  lecturer_grade: "Старший преподаватель кафедры МОСИТ",
  group: "ИКБО-07-22",
  date: datetime.today(),
  add_toc: false,
)

#let img(path) = "./imgs/" + path + ".png"
#let r(inner, supplement: "рисунке") = ref(inner, supplement: supplement)

= Цели практической работы

- Ознакомиться с задачами хранения состояния;
- Произвести знакомство с Bloc;
- Произвести знакомство с Riverpod;
- Произвести знакомство с MobX;
- Выполнение практической работы №9.

= Задача хранения состояния

Управление состоянием мобильных приложений -- это фундаментальная концепция всех мобильных фреймворков для разработки приложений, и Flutter не является исключением. Управление состоянием -- это то, как приложение может управлять данными, которые оно использует, и обновлять их. Во Flutter существует несколько техник и инструментов, которые можно использовать для управления состоянием, и выбор наиболее подходящего из них часто зависит от сложности и требований приложения, которое создается.

Хранение состояний экрана играет ключевую роль в разработке, но сопряжено с рядом проблем. Среди проблем масштабирования можно выделить ограниченную переиспользуемость компонентов, возникающую из-за зависимости виджетов от конкретного состояния экрана, а также нарушение принципа разделения ответственности, когда экран одновременно управляет отображением и состоянием.

Проблемы производительности включают неэффективное использование памяти, поскольку состояние хранится в каждом экземпляре экрана, и неоптимальные обновления UI, когда изменения состояния в одном месте требуют синхронизации с другими частями приложения.

К проблемам архитектуры относятся сложность тестирования, так как состояние тесно связано с UI-логикой, и сложность отладки, поскольку состояние может изменяться в разных местах кода, что затрудняет отслеживание всех возможных путей изменений.

#pagebreak()
= Произвести знакомство с Bloc

BLoC -- это акроним от "Business Logic Component" (компонент бизнес-логики). Как следует из названия, это класс, отделяющий бизнес-логику приложения от пользовательского интерфейса. Такой компонент содержит код, который можно повторно использовать где угодно: в другом модуле, на другой платформе, в другом приложении. Вся работа строится на основании состояний двух каналов данных: Event и State stream.

Существуют два вида Bloc: Stream Bloc, где для изменения состояния необходимо отправить специальный event и по его итогу получить некий State, и Cubit Bloc, где events отсутствует, и мы напрямую обращаемся в Cubit, который в свою очередь генерирует новый State. В Cubit нет Event Stream, его логику берут на себя чистые функции контейнера.

Основные части хранилища BLoC включают:

- Event Stream -- поток событий, который позволяет UI-компонентам отправлять команды в BLoC;
- State Stream -- выходной поток, который передает изменения состояния из BLoC в UI;
- BLoC container -- компонент, который обеспечивает доступ к BLoC для UI-компонентов;
- BlocObserver -- механизм для отслеживания изменений состояния и событий в BLoC;
- emit -- механизм для обновления состояния в BLoC.

== Подключение пакетов

Для реализации работы с Bloc в проект требуется в файл pubspec.yaml добавить пакеты bloc и flutter_bloc. В #r(<lst-bloc-packages>) показано добавление необходимых пакетов.

#listing(
  caption: [Добавление пакетов для работы с Bloc],
  body: raw(lang: "yaml", "
  dependencies:
    bloc: ^9.1.0
    flutter_bloc: ^9.1.1
  "),
) <lst-bloc-packages>

== Реализация общего слушателя

Первое, что будет рассмотрено, это как создать объект BlocObserver, который позволяет наблюдать за всеми изменениями состояния в приложении. В #r(<lst-counter-observer>, supplement: "листинге") показана реализация класса CounterObserver.

#listing(
  caption: [Класс CounterObserver],
  body: raw(
    lang: "dart",
    "
import 'package:bloc/bloc.dart';

class CounterObserver extends BlocObserver {
  const CounterObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
  ",
  ),
) <lst-counter-observer>

== Подготовка Widget-а приложения

Далее требуется доработать содержимое функции main. В #r(<lst-bloc-main>, supplement: "листинге") показана реализация функции main с использованием BlocObserver.

#listing(
  caption: [Функция main с BlocObserver],
  body: raw(
    lang: "dart",
    "
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/counter_app.dart';
import 'package:counter_app/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(CounterApp());
}
  ",
  ),
) <lst-bloc-main>

Widget приложение CounterApp также требуется изменить. В качестве итогового результата требуется получить Widget с указанием основной страницы, как показано в #r(<lst-counter-app>, supplement: "листинге").

#listing(
  caption: [Widget CounterApp],
  body: raw(
    lang: "dart",
    "
import 'package:flutter/material.dart';
import 'counter_page.dart';

class CounterApp extends MaterialApp {
  const CounterApp({super.key})
    : super(home: const CounterPage());
}
  ",
  ),
) <lst-counter-app>

== Реализация страницы счётчика

После того, как Widget приложения готов к работе, необходимо создать страницу со счетчиком. В #r(<lst-counter-page>, supplement: "листинге") показана реализация класса CounterPage.

#listing(
  caption: [Класс CounterPage],
  body: raw(
    lang: "dart",
    "
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'counter_cubit.dart';
import 'counter_view.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView()
    );
  }
}
  ",
  ),
) <lst-counter-page>

== Реализация Cubit класса

После того, как страница создана и к ней подвязаны все необходимые классы, нужно создать класс-делегат -- Cubit, показанный в #r(<lst-counter-cubit>, supplement: "листинге").

#listing(
  caption: [Класс CounterCubit],
  body: raw(
    lang: "dart",
    "
import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(): super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}
  ",
  ),
) <lst-counter-cubit>

Класс CounterCubit выступает в приложении как класс-делегат. В его задачи закладывается хранение данных для отображения на экране и предоставление методов для изменения этих данных.

Для хранения данных родительскому классу Cubit в значение дженерик класса указан тип хранимых данных -- int, а в конструкторе класса CounterCubit в родительском конструкторе задается стартовое значение, равное 0. В качестве методов изменения данных класс CounterCubit предоставит два метода:

- increment -- добавляет 1 к текущему состоянию
- decrement -- вычитает 1 из текущего состояния

== Реализация представления данных Bloc

Когда сам экран и класс-делегат созданы, можно приступать к реализации класса представления данных. В #r(<lst-counter-view>, supplement: "листинге") показана реализация класса CounterView. Класс CounterView отвечает за рендеринг текущего счетчика и рендеринг двух FloatingActionButtons для увеличения/уменьшения счетчика.

#listing(
  caption: [Класс CounterView],
  body: raw(
    lang: "dart",
    "
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'counter_cubit.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text(
              '$state',
              style: textTheme.displayMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
  ",
  ),
) <lst-counter-view>

В данной реализации BlocBuilder используется для обновления Text Widget-а при каждом изменении состояния в CounterCubit. Для связки CounterView с CounterCubit в BlocBuilder в качестве первого дженерик типа устанавливается интересуемый класс-делегат, а в качестве второго типа указывается тип данных, который будет приходить в качестве аргумента state метода builder. Для изменения данных в классе-делегате используется context.read(). Эта команда используется для поиска ближайшего CounterCubit экземпляра и получению к нему доступа.

= Riverpod

По своей сути Riverpod -- это библиотека управления состоянием для Flutter, которая призвана улучшить другую имеющуюся библиотеку -- Provider. Riverpod обеспечивает более безопасный, тестируемый и гибкий способ управления состоянием и его совместного использования в приложении, чем его более старая версия -- Provider.

Provider -- это пакет для управления состоянием в Flutter, который упрощает передачу данных между виджетами. Он построен на основе InheritedWidget и предоставляет удобный интерфейс для работы с состоянием приложения. Принцип работы ничем не отличается от работы с Inherited Widget. Отличными чертами являются методы вызова provider: метод read отвечает за разовое прочтение данных, метод watch отвечает за обновление экранной формы при изменении данных.

Основные части хранилища Provider:

- Provider container представляет собой обёртку вокруг InheritedWidget, которая позволяет передавать любой объект вниз по дереву виджетов;
- ChangeNotifier Provider является специализированной версией базового Provider;
- Listenable Provider работает по похожему принципу с ChangeNotifier Provider, но он более универсален;
- Stream Provider предназначен для работы с потоками данных (Stream);
- Multi Provider -- это инструмент для организации нескольких провайдеров в одном месте.

Riverpod использует неизменяемые объекты-провайдеры и концепцию ScopedProviders. Это как система с отдельными зонами видимости, где каждый провайдер существует независимо от дерева виджетов. В Provider работа происходит напрямую с BuildContext и используются различные провайдеры (ChangeNotifierProvider, ValueNotifierProvider). Это похоже на прямую дорогу от виджета к данным.

Основные части хранилища Riverpod:

- StateNotifier Provider -- основной компонент для управления состоянием, он объединяет концепцию StateNotifier и Provider, обеспечивая автоматическое обновление UI при изменении состояния;
- Provider Scope -- корневой виджет, который оборачивает всё приложение и управляет всеми провайдерами, он является точкой входа для всей системы управления состоянием;
- Scoped Providers позволяют ограничивать область видимости провайдеров определённой частью дерева виджетов, это особенно полезно для больших приложений с сложной структурой.

== Подключение пакетов

Для реализации работы с Riverpod в проект требуется в файл pubspec.yaml добавить пакеты flutter_riverpod, riverpod_annotation, riverpod_generator, riverpod_lint. Кроме того, были подключены пакеты build_runner и custom_lint. В #r(<lst-riverpod-packages>, supplement: "листинге") показано добавление необходимых пакетов.

#listing(
  caption: [Подключение пакетов для работы с Riverpod],
  body: raw(
    lang: "yaml",
    "
dependencies:
  flutter_riverpod: ^3.0.3
  riverpod_annotation: ^3.0.3

dev_dependencies:
  build_runner: ^2.7.1
  custom_lint: ^0.8.0
  riverpod_generator: ^3.0.3
  riverpod_lint: ^3.0.3
  ",
  ),
) <lst-riverpod-packages>

== Подготовка Widget-а приложения

Далее требуется доработать содержимое lib/main.dart. В #r(<lst-riverpod-main>, supplement: "листинге") показана реализация функции main. В нем Widget приложения оборачивается в Widget ProviderScope, который направлен на хранение всех классов-делегатов в рамках этой области видимости.

#listing(
  caption: [Файл main.dart с ProviderScope],
  body: raw(
    lang: "dart",
    "
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_app.dart';

void main() {
  runApp(
    ProviderScope(child: CounterApp())
  );
}
  ",
  ),
) <lst-riverpod-main>

Виджет приложения изменять нет необходимости. Он останется таким же, как в стартовом проекте, как показано в #r(<lst-riverpod-app>, supplement: "листинге").

#listing(
  caption: [Widget приложения CounterApp],
  body: raw(
    lang: "dart",
    "
class CounterApp extends MaterialApp {
  const CounterApp({super.key})
    : super(home: const CounterPage());
}
  ",
  ),
) <lst-riverpod-app>

== Реализация страницы счётчика

Виджет страницы представлен в #r(<lst-riverpod-page>, supplement: "листинге").

#listing(
  caption: [Виджет страницы CounterPage],
  body: raw(
    lang: "dart",
    "
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const CounterView());
  }
}
  ",
  ),
) <lst-riverpod-page>

После того, как виджет страницы готов к работе, необходимо создать представление со счетчиком. В #r(<lst-riverpod-view>, supplement: "листинге") показана реализация класса CounterView.

#listing(
  caption: [Виджет представления CounterView],
  body: raw(
    lang: "dart",
    "
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter.dart';

class CounterView extends ConsumerWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter example'),
      ),
      body: Center(
        child: Text('\${ref.watch(counterProvider)}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
  ",
  ),
) <lst-riverpod-view>

В реализации представления в рамках использования пакета Riverpod наблюдатель данных наследуется не от Stateless или Stateful Widget, а от ConsumerWidget класса. Это наследование меняет сигнатуру стандартного метода build, добавляя ему в качестве дополнительного аргумента еще WidgetRef объект. WidgetRef объект используется для настройки получения и прослушивания данных в классе делегате. Для простого получения данных из делегата необходимо использовать метод read, а для наблюдения за данными и автоматическом обновлении экрана при их изменении, нужно использовать метод watch.

== Реализация класса-делегата

После того, как представления создано, нужно создать класс делегат в файле lib/counter.dart как показано в #r(<lst-riverpod-counter>, supplement: "листинге").

#listing(
  caption: [Класс-делегат Counter],
  body: raw(
    lang: "dart",
    "
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter.g.dart';

@riverpod
class Counter extends _\$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}
  ",
  ),
) <lst-riverpod-counter>

Для указания, что класс Counter является классом-делегатом, требуется установить на него обязательную аннотацию - \@riverpod. При указании данной аннотации класс должен иметь метод build, который должен возвращать наблюдаемые данные в классе-делегате. В качестве методов изменения данных класс Counter предоставляет метод -- increment, который добавляет 1 к текущему состоянию. Класс наследуется от \_\$Counter, определённого в сгенерированном файле counter.g.dart.

Чтобы сгенерировать файл counter.g.dart, необходимо ввести команду flutter pub run build_runner build --delete-conflicting-outputs.

= MobX

MobX -- это библиотека управления состоянием, в которой применяется концепция реактивного программирования. Она разделяет состояние и пользовательский интерфейс приложения и автоматически обновляет интерфейс при изменении состояния.

В реактивном подходе MobX ключевыми элементами являются: Observable -- данные, за изменениями которых следит система; Actions -- операции, изменяющие состояние данных; Computed -- значения, автоматически обновляющиеся при изменении зависимостей.

Основные части хранилища MobX:

- Observable выступает в роли системы мониторинга состояния, когда мы помечаем данные как наблюдаемые, MobX автоматически создает граф зависимостей между ними;
- Readonly является аналогом Observable, однако запрещает изменение состояния значения извне хранилища;
- Computed представляет собой механизм для создания производных значений, которые автоматически пересчитываются при изменении исходных данных;
- Action -- это специальные функции, предназначенные для модификации состояния, они играют роль защитного слоя, гарантирующего, что все изменения будут произведены корректно и атомарно;
- Reaction -- это механизм, который позволяет выполнять определенные действия при изменении состояния, он работает как система триггеров, автоматически реагирующая на изменения данных и выполняющая заданные операции.

== Подключение пакетов

Для реализации работы с MobX в проект требуется в файл pubspec.yaml добавить пакеты mobx, flutter_mobx, build_runner и mobx_codegen. В #r(<lst-mobx-packages>, supplement: "листинге") показано добавление необходимых пакетов.

#listing(
  caption: [Подключение пакетов для работы с MobX],
  body: raw(
    lang: "yaml",
    "
dependencies:
  mobx: ^2.5.0
  flutter_mobx: ^2.3.0

dev_dependencies:
  build_runner: ^2.7.1
  mobx_codegen: ^2.7.4
  ",
  ),
) <lst-mobx-packages>

== Реализация Store

Первое, что будет рассмотрено, это класс-делегат в MobX -- Store. Store в MobX -- это способ собрать связанное наблюдаемое состояние в одном классе. Store позволяет нам использовать аннотации и сохраняет код простым. В #r(<lst-mobx-store>, supplement: "листинге") показана реализация Store.

#listing(
  caption: [Класс Store в файле counter.dart],
  body: raw(
    lang: "dart",
    "
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = _Counter with _\$Counter;

abstract class _Counter with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
  ",
  ),
) <lst-mobx-store>

Абстрактный класс \_Counter, включающий в себя примесь Store необходим нам для реализации всего кода класса-делегата. В то время как класс Counter, создаваемый выше используется для объединения класса делегата с генерируемым кодом MobX Store при помощи build_runner. Сгенерированный код будет находиться внутри файла counter.g.dart, который мы включаем в файл counter.dart при помощи ключевого слова part. Важно заметить, что при отсутствии подключения сгенерационного файла в файл с классом-делегатом, генерация миксина \_\$Counter не пройдет успешно.

Для указания данных, которые будут передаваться на отображения в слой представления, используется аннотация \@observable. Если какое-либо поле помечено данной аннотацией, то помеченный объект становится наблюдаемый. Для обновления наблюдаемых данных используются методы, помеченные специальной аннотацией -- \@action. В данном примере она необходима для обозначения метода increment() как метода обновляющего данные класса-делегата.

Для генерации необходимых данных для MobX Store требуется прописать команду "flutter pub run build_runner build" в консоли или терминале.

== Подключение Store к Observer

Когда реализация класса-делегата завершена, можно настроить наблюдателя на экране приложения. Для этого требуется произвести изменения в стартовом файле main.dart. В #r(<lst-mobx-main>, supplement: "листинге") показана реализация с использованием Observer.

#listing(
  caption: [Файл main.dart с Observer],
  body: raw(
    lang: "dart",
    "
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'counter.dart';

void main() {
  runApp(CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  final counter = Counter();

  CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobX Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Observer(
              builder: (_) => Text(
                '\${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
  ",
  ),
) <lst-mobx-main>

В качестве основных изменений необходимо создать объект класса-делегата MobX Store, а также обернуть Text Widget с информацией о количестве нажатий в Widget наблюдателя -- Observer. Конструктор виджета содержит: super.key -- (опциональный) параметр ключа, builder -- функция которая возвращает виджет, определяет, что именно Observer будет наблюдать и отображать, name -- (опционально) имя наблюдателя, может использоваться для отладки или идентификации, warnWhenNoObservables -- (опционально) флаг, указывающий, следует ли выдавать предупреждение, если в наблюдении нет наблюдаемых объектов.

Далее остается только подставить значение, хранимое в классе-делегате, в Text Widget и поменять метод обработки нажатия на FloatingActionButton с внутренней логики Stateful Widget-а на метод в классе-делегате. Так как более внутренняя логика, а соответственно и State у Stateful Widget-а более не нужны, то можно Stateful Widget переделать в Stateless Widget, для уменьшения занимаемой памяти.

= Выполнение практической работы

В рамках практической работы было реализовано приложение для трекинга привычек с использованием паттерна BLoC (Business Logic Component). Приложение позволяет создавать привычки, отмечать их выполнение, отслеживать серии (streaks) и просматривать статистику.

== Общая структура приложения

Приложение построено на основе clean architecture с разделением на слои:

- Entities -- доменные модели (Habbit, HabbitAck, Streak)
- Store -- абстракция для управления данными через Stream API
- BLoC/Cubit -- управление состоянием и бизнес-логикой
- Screens -- экраны приложения
- Widgets -- переиспользуемые UI-компоненты

Архитектура приложения основана на однонаправленном потоке данных: пользовательские действия преобразуются в события (Events), которые обрабатываются в BLoC, изменяют состояние (State), и UI автоматически обновляется через BlocBuilder.

== Подключение зависимостей

Для реализации работы с BLoC в проект были добавлены следующие пакеты в файл pubspec.yaml. В #r(<lst-practice-packages>, supplement: "листинге") показано добавление необходимых пакетов.

#listing(
  caption: [Подключение пакетов для практической работы],
  body: raw(
    lang: "yaml",
    "
dependencies:
  bloc: ^9.1.0
  flutter_bloc: ^9.1.1
  go_router: ^17.0.0
  get_it: ^9.1.0
  ",
  ),
) <lst-practice-packages>

Пакет bloc предоставляет базовые классы для реализации BLoC паттерна, flutter_bloc содержит виджеты для интеграции с Flutter (BlocProvider, BlocBuilder), go_router используется для декларативной маршрутизации, а get_it -- для dependency injection.

== Настройка точки входа и dependency injection

В функции main выполняется регистрация всех зависимостей приложения через GetIt. В #r(<lst-practice-main>, supplement: "листинге") показана реализация точки входа приложения.

#listing(
  file: "../lib/main.dart",
  caption: [Функция main с настройкой dependency injection],
  from: 1,
  to: 24,
) <lst-practice-main>

В данной реализации регистрируются три ключевых зависимости:

- HabbitIdGenerator -- функция для генерации уникальных идентификаторов привычек, использует замыкание для хранения счетчика
- CurrentDateTimeProvider -- функция для получения текущего времени, что упрощает тестирование
- HabbitsStore -- основное хранилище данных приложения, регистрируется как lazy singleton

Использование GetIt позволяет централизованно управлять зависимостями и легко подменять их при тестировании.

== Реализация хранилища данных

Хранилище данных реализовано через интерфейс HabbitsStore и его имплементацию HabbitsStoreImpl. В #r(<lst-practice-store>, supplement: "листинге") показана реализация хранилища.

#listing(
  file: "../lib/features/stores/habbits_store.dart",
  caption: [Класс HabbitsStoreImpl для управления данными],
  from: 1,
  to: 97,
) <lst-practice-store>

Ключевые особенности реализации:

- Использование StreamController.broadcast() для оповещения подписчиков об изменениях данных
- Метод watchHabbits() возвращает Stream, который автоматически отправляет обновления при любых изменениях списка привычек
- Все методы модификации (addHabbit, ackHabbit, breakHabbit, editHabbit) используют внутренний метод \_emit для обновления состояния и оповещения подписчиков
- Данные хранятся в памяти в виде списка List<Habbit>, что упрощает демонстрацию работы паттерна

Такой подход обеспечивает реактивность данных и позволяет BLoC автоматически получать обновления через Stream API.

== Реализация Events

События (Events) в BLoC паттерне представляют собой действия пользователя или системы, которые инициируют изменения состояния. В #r(<lst-practice-events>, supplement: "листинге") показана реализация событий для управления привычками.

#listing(
  file: "../lib/features/bloc/habbits_list/habbits_event.dart",
  caption: [Классы событий для HabbitsBloc],
  from: 1,
  to: 44,
) <lst-practice-events>

В приложении используется sealed class для базового класса HabbitEvent, что обеспечивает exhaustive checking при обработке событий. Определены следующие события:

- SubscriptionRequested -- запрос на подписку к Stream обновлений привычек, отправляется автоматически при создании BLoC
- NewHabbitAdded -- событие добавления новой привычки с параметрами name, iconUrl и targetDays
- HabbitInfoEdited -- событие редактирования существующей привычки
- HabbitAcked -- событие подтверждения выполнения привычки (отметка галочкой)
- HabbitBreaked -- событие прерывания серии привычки

Использование sealed class позволяет компилятору проверять, что все возможные типы событий обработаны в switch-выражениях.

== Реализация States

Состояние (State) в BLoC содержит данные для отображения в UI и информацию о статусе загрузки. В #r(<lst-practice-states>, supplement: "листинге") показана реализация состояний.

#listing(
  file: "../lib/features/bloc/habbits_list/habbits_state.dart",
  caption: [Класс состояния HabbitsState],
  from: 1,
  to: 49,
) <lst-practice-states>

Класс HabbitsState содержит:

- \_habbits -- приватный список привычек, доступный через геттер для обеспечения иммутабельности
- loadingState -- enum со значениями loading, success, error для отображения состояния загрузки
- errorMessage -- опциональное сообщение об ошибке

Реализованы вспомогательные методы:

- \_copyWith -- приватный метод для создания копии состояния с изменёнными полями
- loading() -- возвращает состояние с флагом загрузки
- success() -- возвращает успешное состояние с новым списком привычек
- error() -- возвращает состояние ошибки с сообщением

Использование иммутабельных состояний с методом copyWith обеспечивает предсказуемость изменений и упрощает отладку.

== Реализация BLoC

Класс HabbitsBloc является центральным компонентом управления состоянием списка привычек. В #r(<lst-practice-bloc>, supplement: "листинге") показана реализация BLoC.

#listing(
  file: "../lib/features/bloc/habbits_list/habbits_bloc.dart",
  caption: [Класс HabbitsBloc для управления состоянием],
  from: 1,
  to: 43,
) <lst-practice-bloc>

Ключевые особенности реализации:

- В конструкторе регистрируются обработчики событий через метод on<EventType>()
- Метод \_onSubscriptionRequested использует emit.forEach для подписки на Stream из хранилища, что обеспечивает автоматическое обновление состояния при изменении данных
- Методы _ackHabbit и _breakHabbit делегируют операции в Store и устанавливают состояние загрузки
- Автоматическая отправка события SubscriptionRequested в конструкторе инициализирует подписку на данные

Использование emit.forEach особенно важно -- этот метод автоматически подписывается на Stream и преобразует каждое новое значение в состояние через колбэк onData. Это избавляет от необходимости вручную управлять подписками и отписками.

== Реализация Cubit для формы

Для управления состоянием формы добавления и редактирования привычки используется Cubit -- упрощенная версия BLoC без событий. В #r(<lst-practice-cubit>, supplement: "листинге") показана реализация Cubit.

#listing(
  file: "../lib/features/bloc/habbits_form_cubit.dart",
  caption: [Класс HabbitEditorCubit для управления формой],
  from: 1,
  to: 74,
) <lst-practice-cubit>

Отличия Cubit от BLoC:

- Отсутствуют события -- методы вызываются напрямую (nameChanged, iconChanged, targetChanged)
- Упрощенная структура -- методы сразу вызывают emit с новым состоянием
- Подходит для простых сценариев, где не нужна сложная обработка событий

Класс HabitEditorState содержит все поля формы (name, iconUrl, targetDays), флаг submitting для отображения процесса отправки и опциональное поле error для отображения ошибок. Метод submit() делегирует создание или редактирование привычки в Store в зависимости от наличия habitId.

== Экран списка привычек

Экран списка привычек интегрирует BLoC через BlocProvider. В #r(<lst-practice-screen>, supplement: "листинге") показана реализация экрана.

#listing(
  file: "../lib/features/screens/habbits_list_screen.dart",
  caption: [Класс HabbitsListScreen с интеграцией BLoC],
  from: 1,
  to: 34,
) <lst-practice-screen>

Ключевые моменты:

- BlocProvider создает и предоставляет экземпляр HabbitsBloc для всего поддерева виджетов
- HabbitsStore получается из GetIt контейнера и передается в конструктор BLoC
- FloatingActionButton использует GoRouter для навигации на экран добавления привычки
- Виджет HabbitsList вложен внутрь и автоматически получает доступ к BLoC

== Виджет списка с BlocBuilder

Виджет HabbitsList использует BlocBuilder для реактивного отображения данных. В #r(<lst-practice-list>, supplement: "листинге") показана реализация.

#listing(
  file: "../lib/features/widgets/habbits_list.dart",
  caption: [Виджет HabbitsList с BlocBuilder],
  from: 1,
  to: 23,
) <lst-practice-list>

BlocBuilder автоматически подписывается на изменения состояния HabbitsBloc и перестраивает UI при каждом обновлении. Builder-функция получает текущее состояние и возвращает ListView с элементами привычек. Использование ValueKey обеспечивает корректное обновление элементов списка при изменении данных.

== Экран формы добавления и редактирования

Экран формы использует BlocBuilder для отслеживания состояния валидации и отправки. В #r(<lst-practice-form>, supplement: "листинге") показана ключевая часть реализации.

#listing(
  file: "../lib/features/screens/habbit_form_screen.dart",
  caption: [Класс HabbitFormScreen с формой редактирования],
  from: 46,
  to: 77,
) <lst-practice-form>

Особенности реализации:

- BlocProvider создает HabbitEditorCubit с опциональным начальным состоянием для редактирования
- BlocBuilder отслеживает изменения состояния и обновляет UI
- Кнопка отправки в AppBar активна только если форма валидна (\_isFormValid)
- При отправке отображается CircularProgressIndicator
- Ошибки валидации отображаются в верхней части формы

= Демонстрация работы приложения

В данном разделе представлена последовательность экранов приложения, демонстрирующая основные возможности трекера привычек на основе BLoC паттерна.

При запуске приложения пользователь попадает на главный экран со списком привычек. На #r(<pic-initial>) показан начальный экран приложения с пустым списком привычек. В центре экрана отображается сообщение о том, что привычки отсутствуют, а в правом нижнем углу расположена кнопка для добавления новой привычки.

#picture(
  path: img("habbit_list_initial"),
  caption: [Начальный экран приложения с пустым списком привычек],
  width: 30%,
) <pic-initial>

При нажатии на кнопку добавления привычки осуществляется переход на экран формы. На #r(<pic-form>) показан экран формы добавления новой привычки с заполненными полями. Пользователь может указать название привычки, выбрать иконку и установить целевое количество дней для отслеживания серии. Кнопка "Сохранить" в верхней части экрана становится активной только при корректном заполнении всех обязательных полей.

#picture(
  path: img("habbits_form_screen_filled"),
  caption: [Форма добавления привычки с заполненными полями],
  width: 25%,
) <pic-form>

После добавления нескольких привычек главный экран приложения изменяется. На #r(<pic-list>) показан экран со списком добавленных привычек. Каждая привычка представлена в виде карточки с названием, иконкой и информацией о текущей серии выполнения. В правом углу каждой карточки расположена кнопка для отметки выполнения привычки.

#picture(
  path: img("habbits_list_filled"),
  caption: [Список добавленных привычек в приложении],
  width: 25%,
) <pic-list>

При взаимодействии с привычками и отметке их выполнения приложение отображает прогресс. На #r(<pic-progress>) показан экран со списком привычек и отображением текущего прогресса выполнения. Счётчик серии (streak counter) показывает количество последовательных дней выполнения привычки. При достижении целевого значения счётчик может изменить цвет или отобразить специальный индикатор успеха.

#picture(
  path: img("habbits_list_screen_with_progress"),
  caption: [Список привычек с отображением прогресса выполнения],
  width: 30%,
) <pic-progress>

Для детального просмотра статистики выполнения конкретной привычки предусмотрен отдельный экран. На #r(<pic-stats>) показан экран детальной статистики привычки. На этом экране отображается график выполнения привычки за выбранный период, информация о текущей и максимальной серии, общее количество выполнений, а также календарь с отметками дней выполнения. Данный экран позволяет пользователю детально анализировать свой прогресс и выявлять закономерности в выполнении привычек.

#picture(
  path: img("habbits_stats_screen"),
  caption: [Экран детальной статистики привычки с графиками и информацией о сериях],
  width: 30%,
) <pic-stats>

Для демонстрации работы навигации в приложении используется GoRouter. На #r(<pic-nav-before>) показано состояние экрана перед использованием функции push replacement. Данная функция позволяет заменить текущий экран в стеке навигации на новый, что полезно в сценариях, когда возврат на предыдущий экран не имеет смысла.

#picture(
  path: img("navigation_push_replacement_demo_before"),
  caption: [Экран перед использованием push replacement навигации],
  width: 25%,
) <pic-nav-before>

После выполнения операции push replacement состояние навигационного стека изменяется. На #r(<pic-nav-after>) показан экран после применения push replacement. Текущий экран заменяется новым, и при нажатии кнопки "Назад" пользователь не вернется на предыдущий экран, а выйдет из приложения или перейдет на более ранний экран в стеке навигации.

#picture(
  path: img("navigation_push_replacement_demo_after"),
  caption: [Экран после применения push replacement навигации],
  width: 25%,
) <pic-nav-after>

Механизм pop позволяет закрыть текущий экран и вернуться к предыдущему в стеке навигации. На #r(<pic-pop>) показана демонстрация работы функции pop. При нажатии кнопки "Назад" или программном вызове pop текущий экран удаляется из стека, и пользователь возвращается к предыдущему экрану. Это стандартное поведение навигации в мобильных приложениях.

#picture(
  path: img("habbits_pop_demo"),
  caption: [Демонстрация работы pop-навигации при возврате на предыдущий экран],
  width: 30%,
) <pic-pop>


= Вывод

Реализованное приложение демонстрирует ключевые преимущества BLoC паттерна: четкое разделение бизнес-логики и UI, реактивное обновление интерфейса через Stream API, тестируемость благодаря отделению логики от виджетов, использование двух подходов (BLoC с событиями для сложной логики и Cubit для простых форм).

Код приложения доступен по ссылке https://github.com/burenotti/mirea-crossplatform-2/tree/burenin/practice-9
