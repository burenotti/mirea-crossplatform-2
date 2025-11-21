#import "./template/template.typ": *

#show: project.with(
  title: "Отчёт по практической работе №8",
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

- Изучить проблему зависимостей в проектах
- Произвести работу с Inherited Widget
- Произвести подключение и работу с DI контейнером GetIt
- Выполнение практической работы №8

= Проблема зависимостей в проекте

Ранее в практических работах мы уже сталкивались с необходимостью передавать один или более параметр в конструктор при создании объекта того или иного класса. Бывают ситуации, когда аргументов немного или же все их значения заранее известны, либо вычисляются в данном месте. В таких ситуациях создать объект такого класса не составляет никакого труда.

#listing(
  caption: [Класс с простым конструктором],
  body: raw(
    lang: "dart",
    "class MyClass {
  const MyClass({required String arg1});
}

void main(List<String> args) {
  const obj = MyClass(arg1: 'arg');
}",
  ),
) <simple-constructor>

В #r(<simple-constructor>) показан пример класса с простым конструктором, который легко использовать.

Однако бывают ситуации, когда перечень аргументов становится многочисленным, а также значения аргументов конструктора уже невозможно рассчитать на месте и их приходится брать из других мест. В таких ситуациях приходится делать место, в котором будет создаваться объект такого сложного класса, зависимым от тех данных, которые необходимы в конструкторе. При достижении определенного уровня такой вложенности становится все тяжелее взаимодействовать с программным кодом и требуется решать такого рода проблемы.

#listing(
  caption: [Конструктор с большим перечнем полей],
  body: raw(
    lang: "dart",
    "class MyClass {
  const MyClass({
    required String arg1,
    required String arg2,
    required String arg3,
    required String arg4,
    required String arg5,
    required String arg6,
    required String arg7,
    required String arg8,
    required String arg9,
    required String arg10,
  });
}

void main(List<String> args) {
  const obj = MyClass(
    arg1: 'arg',
    arg2: 'arg2',
    arg3: 'arg3',
    arg4: 'arg4',
    arg5: 'arg5',
    arg6: 'arg6',
    arg7: 'arg7',
    arg8: 'arg8',
    arg9: 'arg9',
    arg10: 'arg10',
  );
}",
  ),
) <complex-constructor>

Как видно из #r(<complex-constructor>), при увеличении количества аргументов создание объекта становится более сложным.

Самым простым способом решения проблемы поочередной зависимости классов от какого-либо набора данных является вынос этих данных во внешнее пространство, к которому у этих классов будет доступ. Это позволяет не передавать зависимость из класса в класс, а получать ее напрямую из хранилища. Такой принцип называется внедрение зависимостей или, как в дальнейшем будет называться, DI (Dependency Injection). В фреймворке Flutter есть разные способы реализации DI, однако рассмотрены будут 2 из них: Inherited Widget и DI контейнер GetIt.

= Inherited Widget

Inherited Widget является одним из основных типов Widget-ов в фреймворке Flutter. Он в основном выступает в качестве внешнего хранилища данных, располагаемых в дереве виджетов, как любой другой Widget. В отличие от Stateless и Stateful Widget, Inherited Widget не имеет и не предполагает какого-либо отображения на экране, поэтому имеет отличные как внутреннее устройство, так и принцип взаимодействия.

Все Widget-ы, зависящие от данных в Inherited Widget, подписываются на его состояние и получают данные по структуре Widget-ов. Если Widget имеет собственный State, то его жизненный цикл подразумевает автоматическое обновление при обновлении данных в Inherited Widget при помощи метода didChangeDependencies. Однако получить данные без автоматической актуализации данных может любой виджет, у которого есть собственный context. По нему Widget ищет объект класса наследника Inherited Widget выше по дереву и возвращает объект этого класса, если такой был найден.

== Статический метод of

Основным требованием к хранилищу зависимостей является доступ к нему из разных мест приложения. Данное требование в Inherited Widget и его наследниках реализуется посредством реализации статического метода of. Данный метод позволяет найти объект класса Inherited Widget или его наследника в дереве виджетов выше Widget-а, в котором необходима зависимость. В связи с тем, что объект класса Inherited Widget или его наследника будет искаться в структуре Widget-ов, то для его корректной логики требуется context Widget-а, в котором необходима зависимость.

#listing(
  caption: [Сигнатура статического метода of],
  body: raw(lang: "dart", "static MyLogic of(BuildContext context)"),
) <of-method-signature>

Пример сигнатуры статического метода of показан в #r(<of-method-signature>).

== Метод dependOnInheritedWidgetOfExactType

Для поиска объекта класса Inherited Widget или его наследников фреймворк предоставляет специальный метод dependOnInheritedWidgetOfExactType, который возвращает объект класса, указанный в качестве дженерик типа в случае, если объект был найден выше по дереву, или пустоту, если объекта данного класса обнаружено не было. Важно заметить, что этот метод используется для поиска объекта по дереву, а значит его нужно вызывать у context, объекта класса BuildContext. Именно для этого метод of обязательно должен иметь в качестве аргумента context Widget-а, в котором нужна зависимость.

#listing(
  caption: [Использование метода dependOnInheritedWidgetOfExactType в статическом методе of],
  body: raw(
    lang: "dart",
    "static MyLogic of(BuildContext context) =>
  context.dependOnInheritedWidgetOfExactType<MyLogic>()!;",
  ),
) <depend-on-inherited>

В #r(<depend-on-inherited>) показано, как метод dependOnInheritedWidgetOfExactType используется для поиска объекта Inherited Widget в дереве.

Важно заметить, что метод dependOnInheritedWidgetOfExactType вернет первый найденный объект класса, указанный в качестве дженерик класса. То есть если в дереве Widget-ов находятся два Widget-а одного Inherited Widget-а или его наследника, то метод dependOnInheritedWidgetOfExactType вернет именно ближайший Widget, расположенный вверх по дереву от зависимого от данных Widget-а.

== Метод updateShouldNotify

Так как Inherited Widget и его наследники используются для передачи набора данных в Widget-ы, где эти данные требуются, то они также должны иметь реализацию автоматического оповещения этих виджетов при обновлении хранимых данных. Этот механизм реализован при помощи метода updateShouldNotify, возвращающего логическое значение, которое описывает необходимость слушателям этих данных обновить свои состояния, так как данные обновились. Разработчик вправе сам регулировать, когда и при каких условиях слушатели обновят свои состояния, именно регулируя логику возвращения данного логического значения, сравнивая экземпляр класса до изменения и после изменения. Фреймворк самостоятельно сохраняет состояние объекта до изменения и предоставляет его в данный метод через аргумент oldWidget.

#listing(
  caption: [Реализация метода updateShouldNotify на основе внутреннего поля number],
  body: raw(
    lang: "dart",
    "@override
bool updateShouldNotify(covariant MyLogic oldWidget) =>
  oldWidget.number != number;",
  ),
) <update-should-notify>

В #r(<update-should-notify>) показан пример реализации метода updateShouldNotify, который сравнивает значение поля number до и после изменения.

= DI контейнер GetIt

GetIt – это DI контейнер, который распространяется в одноименном пакете. Это простой DI контейнер для проектов Dart и Flutter с некоторыми дополнительными преимуществами. Его можно использовать вместо InheritedWidget для доступа к объектам, например, из вашего пользовательского интерфейса. Главное отличие GetIt от Inherited Widget заключается в том, что для доступа к данным не требуется context Widget-а, от которого происходит обращение. Очень часто в ходе разработки требуется получить данные в месте, где нет доступа к context и в таких моментах Inherited Widget становится очень неудобен. GetIt отлично закрывает эту проблему, так как он не является частью фреймворка Flutter и не зависит от его внутренней реализации. GetIt строится на объектном паттерне Singleton, который позволяет получить доступ к единому экземпляру класса в любой точке приложения без необходимости как-то добавлять его в дерево Widget-ов.

== Подключение в проект

Для подключения пакета get_it в проект требуется в файл pubspec.yaml добавить пакет в dependencies. Альтернативным вариантом является введение команды «flutter pub add get_it» в терминале, смотрящим в директорию проекта.

#listing(
  caption: [Добавление get_it в pubspec.yaml],
  body: raw(lang: "yaml", "dependencies:
  get_it: ^7.7.0"),
) <getit-dependency>

В #r(<getit-dependency>) показано, как добавить пакет get_it в зависимости проекта.

== Доступ к DI контейнеру

Для того, чтобы получить доступ к DI контейнеру GetIt, необходимо обратиться к его статичному полю instance или полю I. Данное поле хранит в себе единый объект DI контейнера, используемого в приложении. Получив доступ к объекту GetIt, разработчику открывается полный доступ к контейнеру и лежащих в нем образах.

#listing(
  caption: [Пример обращения к контейнеру GetIt],
  body: raw(
    lang: "dart",
    "GetIt getIt = GetIt.instance;

// Альтернативный вариант (короткая форма):
GetIt getIt = GetIt.I;",
  ),
) <getit-access>

Способ обращения к контейнеру можно увидеть в #r(<getit-access>).

== Регистрация объектов

Для того, чтобы некий образ класса появился в контейнере, его необходимо сначала там зарегистрировать. В контейнере можно зарегистрировать образ как уже готовый объект или как алгоритм его создания. Для регистрации объектов в контейнере GetIt есть специализированный метод registerSingleton<T>. Указывая в качестве значения его аргумента объект дженерик класса, он регистрируется в контейнере и будет возвращаться каждый раз, когда из контейнера будут запрашивать образ данного класса.

#listing(
  caption: [Регистрация объектов в контейнер GetIt],
  body: raw(
    lang: "dart",
    "// Обычная регистрация:
GetIt.instance.registerSingleton<AppModel>(AppModelImplementation());
GetIt.I.registerLazySingleton<RESTAPI>(() => RestAPIImplementation());",
  ),
) <getit-register>

Примеры регистрации показаны в #r(<getit-register>).

Иногда требуется хранить более одного объекта одного и того же класса в контейнере, тогда при регистрации объекта помимо самого объекта передают его идентификационное название, по которому в дальнейшем можно будет получить именно этот образ запрашиваемого класса.

#listing(
  caption: [Указание идентификационного имени объекта в контейнере GetIt],
  body: raw(
    lang: "dart",
    "void main(List<String> args) {
  GetIt.I.registerSingleton(MyClass(), instanceName: 'my_class');
}",
  ),
) <getit-instance-name>

В #r(<getit-instance-name>) показано, как задать идентификационное имя при регистрации.

При стандартной настройке контейнера если попытаться зарегистрировать объект уже имеющегося в контейнере класса, то будет получена runtime ошибка. Для решения этой проблемы можно либо задать каждому экземпляру собственное идентификационное название или включить настройку переписи объектов внутри контейнера. Она позволяет заменять в контейнере объект одного класса без ручной очистки образа класса.

#listing(
  caption: [Включение настройки переписи объектов в контейнере GetIt],
  body: raw(lang: "dart", "void main(List<String> args) {
  GetIt.I.allowReassignment = true;
}"),
) <getit-reassignment>

В #r(<getit-reassignment>) показано, как включить настройку переписи объектов.

Так как регистрация объектов в контейнере – это очень затратный процесс по памяти, GetIt имеет возможность произвести «отложенную» регистрацию. Для этого необходимо вызвать метод registerLazySingleton<T>, в аргументы которого передается функция, возвращающая требуемый объект дженерик класса. Это позволяет заложить в контейнер не сам объект, а функцию его получения, что уменьшает потребляемую память и позволяет заложить в контейнер объект на момент первого обращения к образу класса.

== Регистрация фабрик создания образов

Не во всех случаях требуется хранить объект класса в контейнере. Существуют подходы, что классы описывают логику работы алгоритмов, однако не хранят в своих объектах никаких данных. Так как хранение объектов в контейнере очень затратный процесс по памяти, то хранить такого рода классы нет никакой необходимости. Вместо этого, контейнер позволяет сохранять в качестве образа не сам объект, а логику получения образа класса. Такие функции с логикой создания объектов требуемых классов называются фабриками. Для регистрации фабрики в качестве образа класса в контейнере используется метод registerFactory<T>. При обращении в контейнер за образом класса будет каждый раз получен новый объект данного класса, построенный по логике, заложенной в фабрике.

#listing(
  caption: [Регистрация фабрики в контейнер GetIt],
  body: raw(
    lang: "dart",
    "void main(List<String> args) {
  GetIt.I.registerFactory(() => MyClass(), instanceName: 'my_class');
}",
  ),
) <getit-factory>

В #r(<getit-factory>) показано, как зарегистрировать фабрику в контейнере.

Так же при регистрации фабрики ей можно задать идентификационное название, чтобы отличать различные фабрики, возвращающие образ одного и того же класса.

== Получение образа из контейнера

В ситуации, когда требуется получить образ из контейнера, требуется использовать специализированный метод get<T>, который вернет образ запрашиваемого дженерик класса. Если образ не был ранее зарегистрирован в контейнере, то данный метод вернет runtime ошибку, что такого образа в контейнере нет.

#listing(
  caption: [Получение образа из контейнера GetIt],
  body: raw(
    lang: "dart",
    "// Как синглтон:
var myAppModel = GetIt.instance<AppModel>();
var myAppModel = GetIt.I<AppModel>();",
  ),
) <getit-get>

В #r(<getit-get>) показаны способы получения образа из контейнера.

== Проверка на наличие образа в контейнере

Для того, чтобы быть уверенным в получении образа искомого класса из контейнера, GetIt позволяет проверять, зарегистрирован ли образ класса до того, как его получать. Для проверки регистрации образа используется метод isRegistered<T>. Данный метод возвращает логическое значение, обозначающее регистрацию образа дженерик класса в контейнере. Так же, как и в методах регистрации, при помощи дополнительного аргумента можно указать идентификационное название для проверки регистрации конкретного образа дженерик класса.

#listing(
  caption: [Проверка регистрации образа в контейнере GetIt],
  body: raw(
    lang: "dart",
    "void main(List<String> args) {
  GetIt.I.isRegistered<MyClass>(instanceName: 'my_class');
}",
  ),
) <getit-is-registered>

В #r(<getit-is-registered>) показано, как проверить наличие образа в контейнере.

= Выполнение практической работы №8

В рамках выполнения практической работы №8 было переработано существующее приложение для учета привычек. Основная цель — реализация передачи параметров (в частности, доступа к контейнеру с привычками) по всему приложению с использованием изученного способа: Inherited Widget.

== Интерфейс контроллера

Для обеспечения гибкости и тестируемости был создан интерфейс HabbitsController, который определяет все операции с привычками:

#listing(
  caption: [Интерфейс HabbitsController],
  body: raw(
    lang: "dart",
    "import 'package:flutter/widgets.dart';
import 'package:practice2/features/entities/habbit.dart';

abstract interface class HabbitsController implements ChangeNotifier {
  void ackHabbit({required int habbitId});
  void breakHabbit({required int habbitId});
  void removeHabbit({required int habbitId});
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  });
  List<Habbit> get habbits;
  void editHabbit({
    required int habbitId,
    required String name,
    required String iconUrl,
    required int targetDays,
  });
  Habbit getHabbit({required int habbitId});
}",
  ),
) <habbits-controller>

Как показано в #r(<habbits-controller>), интерфейс HabbitsController наследуется от ChangeNotifier, что позволяет уведомлять слушателей об изменениях состояния.

== Реализация с Inherited Widget

Inherited Widget — это встроенный механизм Flutter для передачи данных вниз по дереву виджетов без необходимости ручной передачи через конструкторы. В данном случае был создан класс HabbitsProvider, который наследуется от InheritedWidget и предоставляет доступ к контроллеру привычек.

=== Создание HabbitsProvider

#listing(
  caption: [Класс HabbitsProvider],
  body: raw(
    lang: "dart",
    "import 'package:flutter/material.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsProvider extends InheritedWidget {
  final HabbitsController habbitsController;

  const HabbitsProvider({
    super.key,
    required this.habbitsController,
    required super.child,
  });

  static HabbitsProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<HabbitsProvider>();
    assert(provider != null, \"HabbitsProvider is not found in build context\");
    return provider!;
  }

  @override
  bool updateShouldNotify(HabbitsProvider oldWidget) => true;

  static Widget wrap({
    required HabbitsController controller,
    required Widget child,
  }) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return HabbitsProvider(habbitsController: controller, child: child!);
      },
      child: child,
    );
  }
}

extension HabbitsProviderX on BuildContext {
  HabbitsController get habbitsController =>
      HabbitsProvider.of(this).habbitsController;
}",
  ),
) <habbits-provider>

В #r(<habbits-provider>) показана полная реализация HabbitsProvider. Ключевые моменты:

- Статический метод `of(context)` использует `dependOnInheritedWidgetOfExactType` для поиска ближайшего экземпляра HabbitsProvider в дереве виджетов
- Метод `updateShouldNotify` возвращает `true`, что означает, что все зависимые виджеты будут обновляться при каждом изменении
- Статический метод `wrap` создает ListenableBuilder, который слушает изменения контроллера и автоматически перестраивает HabbitsProvider при каждом вызове notifyListeners()
- Расширение `HabbitsProviderX` позволяет получить доступ к контроллеру просто написав `context.habbitsController`

=== Реализация HabbitsContainer

Класс HabbitsContainer реализует интерфейс HabbitsController и управляет состоянием привычек:

#listing(
  caption: [Класс HabbitsContainer],
  body: raw(
    lang: "dart",
    "import 'package:flutter/foundation.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsContainer extends ChangeNotifier implements HabbitsController {
  List<Habbit> _habbits = [];
  final DateTime Function() currentDateTime;
  final int Function() nextHabbitId;

  HabbitsContainer({required this.currentDateTime, required this.nextHabbitId});

  @override
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    _habbits.add(
      Habbit(
        id: nextHabbitId(),
        name: name,
        createdAt: currentDateTime(),
        iconUrl: iconUrl,
        targetDays: targetDays,
      ),
    );
    notifyListeners();
  }

  @override
  void ackHabbit({required int habbitId}) {
    _exchange(
      habbitId: habbitId,
      mutation: (h) => h.withAck(currentDateTime()),
    );
  }

  @override
  void breakHabbit({required int habbitId}) {
    _exchange(
      habbitId: habbitId,
      mutation: (h) => h.withBreak(currentDateTime()),
    );
  }

  @override
  void removeHabbit({required int habbitId}) {
    _habbits = _habbits.where((h) => h.id != habbitId).toList();
    notifyListeners();
  }

  void _exchange({
    required int habbitId,
    required Habbit Function(Habbit) mutation,
  }) {
    var index = _habbits.indexWhere((h) => h.id == habbitId);
    _habbits[index] = mutation(_habbits[index]);
    notifyListeners();
  }

  @override
  List<Habbit> get habbits => List.unmodifiable(_habbits);
}",
  ),
) <habbits-container>

В #r(<habbits-container>) показано, как HabbitsContainer:

- Хранит список привычек в приватном поле `_habbits`
- Принимает через конструктор функции для получения текущего времени и генерации ID
- Вызывает `notifyListeners()` после каждого изменения состояния
- Все методы изменения состояния используют приватный метод `_exchange`, который обеспечивает неизменяемость данных и уведомляет слушателей об изменениях

=== Интеграция в main.dart

В точке входа приложения создается экземпляр HabbitsContainer и оборачивается в HabbitsProvider:

#listing(
  caption: [Инициализация приложения с HabbitsProvider],
  body: raw(
    lang: "dart",
    "import 'package:flutter/material.dart';
import 'package:practice2/features/state/habbits_container.dart';
import 'package:practice2/features/widgets/habbits_provider.dart';
import 'package:practice2/router_config.dart';

void main() {
  var container = HabbitsContainer(
    currentDateTime: () => DateTime.now(),
    nextHabbitId: () {
      var current = 0;
      return () {
        current += 1;
        return current;
      };
    }(),
  );
  runApp(HabbitsProvider.wrap(controller: container, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: buildRouter(),
    );
  }
}",
  ),
) <main-integration>

В #r(<main-integration>) показано, как:

- Создается экземпляр HabbitsContainer с инъекцией зависимостей
- Используется замыкание для генерации уникальных ID
- Все приложение оборачивается в HabbitsProvider.wrap для доступа к состоянию из любого места

Этот подход обеспечивает:

- *Централизованное управление состоянием* – единый источник правды для всех привычек
- *Автоматическое обновление UI* – при изменении состояния все зависимые виджеты перестраиваются
- *Инъекцию зависимостей* – функции для получения времени и ID можно легко заменить для тестирования
- *Неизменяемость данных* – все изменения создают новые экземпляры объектов

=== Демонстрация работы приложения

После интеграции InheritedWidget в приложение необходимо убедиться, что все функции работают корректно. Рассмотрим типичный сценарий использования приложения для отслеживания привычек.

#picture(
  path: img("habbit_list_initial"),
  caption: [Начальный экран со списком привычек],
  width: 60%,
) <habbit-list-initial>

На #r(<habbit-list-initial>) показан пустой экран списка привычек при первом запуске приложения. Видна кнопка добавления новой привычки в нижнем правом углу.

#picture(
  path: img("habbits_form_screen_filled"),
  caption: [Заполненная форма создания привычки],
  width: 60%,
) <habbit-form-filled>

На #r(<habbit-form-filled>) представлена форма добавления новой привычки с заполненными полями: название привычки "Выпить воды", иконка (URL изображения) и целевое количество дней — 30. При нажатии кнопки "Add habit" данные передаются через HabbitsController в HabbitsContainer, который создает новый экземпляр Habbit и обновляет состояние.

#picture(
  path: img("habbits_list_filled"),
  caption: [Список с добавленной привычкой],
  width: 60%,
) <habbit-list-filled>

На #r(<habbit-list-filled>) видно, что привычка успешно добавлена в список. Отображается иконка, название, текущий прогресс (0/30) и кнопки для действий: "Ack" (подтвердить выполнение) и "Break" (пропустить день).

#picture(
  path: img("habbits_list_screen_with_progress"),
  caption: [Обновление прогресса после действий],
  width: 60%,
) <habbit-list-progress>

На #r(<habbit-list-progress>) показано, как изменяется прогресс после нажатия кнопок "Ack" и "Break". Благодаря использованию ListenableBuilder в HabbitsProvider.wrap(), интерфейс автоматически обновляется при изменении состояния в HabbitsContainer. Счетчик прогресса обновляется моментально, отражая текущие успехи пользователя.

#picture(
  path: img("habbits_stats_screen"),
  caption: [Экран статистики привычки],
  width: 60%,
) <habbit-stats>

На #r(<habbit-stats>) представлен экран с детальной статистикой выбранной привычки. Здесь пользователь может просмотреть историю выполнений (список всех "Ack" и "Break" событий с датами), текущую серию, максимальную серию и другие аналитические данные. Доступ к данным конкретной привычки осуществляется через метод getHabbit() контроллера.

