#import "./template/template.typ": *

#show: project.with(
  title: "Отчёт по практической работе №7",
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

= Страничная навигация в приложении

В Flutter есть два основных способа навигации в приложении: страничная и маршрутизированная навигация. Страничная навигация работает на Navigator и Route. Navigator – это виджет, который управляет набором дочерних виджетов с помощью структуры Stack. Экраны в Flutter называются Route.

Многие приложения имеют Navigator в верхней части иерархии виджетов, чтобы отображать их логическую историю с помощью наложения с последними посещенными страницами, визуально поверх старых страниц. Использование этого шаблона позволяет навигатору визуально переходить с одной страницы на другую, перемещая виджеты в наложении. Аналогично, навигатор можно использовать для отображения диалога, разместив виджет диалога над текущей страницей.

В Flutter существует два основных подхода к организации навигации между экранами: Navigation 1.0 и Navigation 2.0. Navigation 1.0 представляет собой императивный способ управления навигацией, при котором разработчик вручную вызывает методы Navigator.push() и Navigator.pop() для перехода между маршрутами. Этот подход прост в освоении и подходит для небольших мобильных приложений, однако он не обеспечивает синхронизации состояния навигации с URL, что делает его неудобным для веб-платформ и ограничивает возможности по работе с deep links и восстановлением состояния.

Navigation 2.0, представленный в Flutter 2.0, реализует декларативный подход к навигации и основан на использовании компонентов Router, RouterDelegate и RouteInformationParser. Он позволяет полностью синхронизировать текущее состояние приложения с адресной строкой браузера, что особенно важно для веб-приложений, а также обеспечивает поддержку глубоких ссылок, корректную работу кнопок «назад» и «вперёд» в браузере и возможность восстановления состояния после перезагрузки. Хотя реализация Navigation 2.0 вручную требует значительных усилий, на практике разработчики чаще используют такие пакеты, как go_router или auto_route, которые упрощают работу с декларативной навигацией, сохраняя при этом все её преимущества.

= Основные методы страничной навигации

Для исполнения основных действий навигации Navigator предоставляет ряд методов для работы. Рассмотрим основные из них:

== Метод push

В навигации часто требуется переходить между страницами с возможностью к ним в последующем вернуться. Данный способ навигации называется – вертикальной навигацией. Смысл вертикальной навигации заключается в сохранении состояний экранов, с которой был выполнен навигационный переход. По сути, навигационная структура реализуется на основе структуры Stack и вертикальная навигация – это добавление новой страницы в него. Для реализации добавления новой страницы в навигационный стек или реализации вертикального навигационного перехода класс Navigator предоставляет метод push.

Сигнатура метода:

#listing(
  body: raw(
    "
@optionalTypeArgs
static Future<T?> push<T extends Object?>(
  BuildContext context,
  Route<T> route
) {
  return Navigator.of(context).push(route);
}
  ",
  ),
  caption: [Сигнатура метода push],
) <lst-push-signature>

Описание параметров:

- *BuildContext context* — контекст, через который извлекается Navigator.

- *Route\<T\> route* — маршрут, который будет добавлен в стек навигации.

- *Возвращаемое значение*: Future\<T?\> — завершится, когда добавленный маршрут будет удалён из стека, с возможным возвращаемым значением типа T.

== Метод pop

В вертикальной навигации помимо самого перехода так же есть и обратное действие – вертикальный навигационный возврат. Когда мы добавляем страницу в навигационный Stack у пользователя должна быть возможность вернуться на страницу назад для просмотра предыдущей страницы. Для реализации возврата на предыдущую страницу в навигационном стеке или реализации вертикального навигационного возврата класс Navigator предоставляет метод pop.

Сигнатура метода:

#listing(
  body: raw(
    "
@optionalTypeArgs
static void pop<T extends Object?>(
  BuildContext context,
  [T? result]
) {
  Navigator.of(context).pop<T>(result);
}
  ",
  ),
  caption: [Сигнатура метода pop],
) <lst-pop-signature>

Описание параметров:

- *BuildContext context* — контекст, используемый для получения Navigator.

- *[T? result]* (необязательный) — значение, которое будет возвращено маршруту, ожидающему результата вызова push или pushReplacement.

- *Возвращаемое значение*: void — метод ничего не возвращает, но завершает текущий маршрут.

== Метод pushReplacement

Часто, в ходе работы приложения только вертикальной навигации бывает недостаточно. Иногда в приложениях реализуется логика, когда пользователь должен перейти на страницу и при этом ему не нужна предыдущая страница в истории навигации. Такая логика часто реализуется в нижних и боковых меню, когда переход на самих реализован с сохранением навигационной истории, то есть вертикальной навигацией, а вот переходы между самими позициями в меню реализуются без сохранения предыдущего выбранного элемента меню. Данный способ навигации называется – горизонтальная навигация. Ее отличительным признаком является не наложение новой страницы на навигационный Stack системы, а снятием верхней страницы из него и заменой ее на новую, которую предоставляет пользователь горизонтальным переходом. Для реализации горизонтального навигационного перехода класс Navigator предоставляет метод pushReplacement.

Сигнатура метода:

#listing(
  body: raw(
    "
@optionalTypeArgs
static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
  BuildContext context,
  Route<T> newRoute,
  {TO? result}
) {
  return Navigator.of(context).pushReplacement<T, TO>(newRoute, result: result);
}
  ",
  ),
  caption: [Сигнатура метода pushReplacement],
) <lst-pushreplacement-signature>

Описание параметров:

- *BuildContext context* — контекст, используемый для поиска экземпляра Navigator, через который выполняется переход.

- *Route\<T\> newRoute* — маршрут, который будет добавлен вместо текущего.

- *{TO? result}* (необязательный) — результат, который будет передан предыдущему маршруту, если текущий удаляется.

- *Возвращаемое значение*: Future\<T?\> — завершится, когда новый маршрут будет удалён из стека, с возможным возвращаемым значением типа T.

= Выполнение практической работы

В рамках выполнения практической работы была реализована система страничной навигации в приложении для трекинга привычек с использованием Navigation 1.0.

== Реализация страничной навигации в проекте

*Вертикальная страничная навигация*

Вертикальная навигация в разработанном приложении реализована при переходе от экрана списка привычек к экрану статистики выбранной привычки при помощи метода Navigator.push(). На экране списка привычек пользователь видит список привычек с возможностью просмотра детальной информации. При нажатии на карточку привычки открывается экран статистики.

Реализация вертикальной страничной навигации в файле habbit_item.dart показана в #r(<lst-push-impl>). Демонстрация навигации — на #r(<img-list-before>) и #r(<img-stats-after>).

#listing(
  body: raw(
    lang: "dart",
    "
onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) =>
        HabbitStatsScreen(habbitId: habbit.id, controller: controller),
  ),
),
    "
  ),
  caption: [Реализация вертикального страничного перехода на экран статистики с помощью метода push],
) <lst-push-impl>

#picture(
  path: img("habbit_list_initial"),
  caption: [Экран списка привычек до выполнения вертикальной навигации на экран статистики],
  width: 30%,
) <img-list-before>

#picture(
  path: img("habbit_stats_screen"),
  caption: [Экран статистики привычки после выполнения вертикальной навигации],
  width: 30%,
) <img-stats-after>

Пользователь может вернуться, нажав на стрелку «Назад» в AppBar. Вертикальная навигация назад реализована при переходе от экрана редактирования привычки обратно к списку привычек при помощи метода Navigator.pop(). На экране редактирования привычки c помощью кнопки в виде иконки стрелки влево, расположенной в левом верхнем углу. Реализация возврата в файле habbit_form_screen.dart показана в #r(<lst-pop-impl>). Демонстрация навигации — на #r(<img-stats>) и #r(<img-list-after-pop>).

#listing(
  body: raw(
    lang: "dart",
    "
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => Navigator.pop(context),
),
    "
  ),
  caption: [Реализация метода pop() для возврата на предыдущий экран],
) <lst-pop-impl>

#picture(
  path: img("habbit_stats_screen"),
  caption: [Экран статистики до нажатия кнопки назад],
  width: 30%,
) <img-stats>

#picture(
  path: img("habbit_list_after_add"),
  caption: [Экран списка привычек после выполнения нажатия на кнопку возврата],
  width: 30%,
) <img-list-after-pop>

*Горизонтальная страничная навигация*

Горизонтальная страничная навигация реализована при помощи Navigator.pushReplacement() на экране редактирования/добавления привычки. После нажатия кнопки «Готово» (иконка галочки) выполняется навигационный переход с полной заменой текущего экрана на экран списка привычек. Благодаря этому список сразу отображает изменённую или добавленную привычку без сохранения экрана редактирования в стеке.

Реализация показана в #r(<lst-pushreplacement-impl>). Демонстрация — на #r(<img-form-filled>) и #r(<img-list-after-save>). Ключевая особенность перехода — отсутствие возможности вернуться на предыдущий экран (экран редактирования) по системной кнопке «Назад», так как он заменён.

#listing(
  body: raw(
    lang: "dart",
    "
void _submitForm() {
  if (_isFormValid) {
    if (_editingHabbit == null) {
      widget.habbits.addHabbit(
        name: _nameController.text,
        iconUrl: _iconUrlController.text,
        targetDays: int.parse(_targetDaysController.text),
      );
    } else {
      widget.habbits.editHabbit(
        habbitId: _editingHabbit!.id,
        name: _nameController.text,
        iconUrl: _iconUrlController.text,
        targetDays: int.parse(_targetDaysController.text),
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HabbitsListScreen(controller: widget.habbits),
      ),
    );
  }
}
    "
  ),
  caption: [Реализация горизонтальной страничной навигации с помощью метода pushReplacement],
) <lst-pushreplacement-impl>

#picture(
  path: img("navigation_push_replacement_demo_before"),
  caption: [Экран редактирования привычки до нажатия кнопки «Готово»],
  width: 30%,
) <img-form-filled>

#picture(
  path: img("navigation_push_replacement_demo_after"),
  caption: [Экран списка привычек после выполнения горизонтальной страничной навигации с заменой экрана в стеке],
  width: 30%,
) <img-list-after-save>

В результате проведённой работы была успешно реализована и протестирована система страничной навигации. Все виды навигационных переходов были тщательно протестированы в различных условиях и продемонстрировали стабильную работу. Результаты тестирования подтвердили, что разработанная система навигации обеспечивает высокую производительность, отзывчивость и соответствие ожиданиям пользователей.

== Реализация маршрутизированной навигации в проекте

Для реализации маршрутизированной навигации в проекте был использован пакет go_router версии 14.6.2 — актуальная стабильная версия на момент разработки, предоставляющая удобный и современный API для декларативного описания маршрутов. Выбор данной библиотеки обусловлен её надёжностью, совместимостью с последними обновлениями Flutter, а также активной поддержкой сообщества разработчиков.

*Маршрутная карта*

В данном приложении маршруты всех экранов определены в файле router_config.dart, который содержит основную карту навигации. В этом файле задаются пути ко всем основным разделам приложения и их взаимосвязи. Структура маршрутной карты показана в #r(<lst-router-map>).

#listing(
  body: raw(
    lang: "dart",
    "
final class Routes {
  static const habbitsList = 'habbitsList';
  static const habbitAdd = 'habbitAdd';
  static const habbitStats = 'habbitStats';
  static const habbitEdit = 'habbitEdit';
}

GoRouter buildRouter(HabbitsController controller) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/habbits',
      ),
      GoRoute(
        path: '/habbits',
        name: Routes.habbitsList,
        builder: (context, state) => HabbitsListScreen(controller: controller),
        routes: [
          GoRoute(
            path: 'add',
            name: Routes.habbitAdd,
            builder: (context, state) =>
                HabbitFormScreen(habbits: controller, editingHabbitId: null),
          ),
          GoRoute(
            path: ':id/stats',
            name: Routes.habbitStats,
            builder: (context, state) => HabbitStatsScreen(
              controller: controller,
              habbitId: int.parse(state.pathParameters[\"id\"]!),
            ),
          ),
          GoRoute(
            path: ':id/edit',
            name: Routes.habbitEdit,
            builder: (context, state) => HabbitFormScreen(
              habbits: controller,
              editingHabbitId: int.parse(state.pathParameters[\"id\"]!),
            ),
          ),
        ],
      ),
    ],
  );
}
    "
  ),
  caption: [Маршрутная карта приложения в файле router_config.dart],
) <lst-router-map>

*Делегат навигации*

После того как маршрутная карта создана, её необходимо подключить в приложение. Для этого используется специализированный конструктор виджета приложения — MaterialApp.router. В нем задаётся конфигурация навигации через параметр routerConfig, как показано в #r(<lst-material-app-router>).

#listing(
  body: raw(
    lang: "dart",
    "
class MyApp extends StatelessWidget {
  final HabbitsController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: buildRouter(controller),
    );
  }
}
    "
  ),
  caption: [Конфигурирование маршрутизированной навигации в приложении],
) <lst-material-app-router>

После того, как навигационная конфигурация в приложении добавлена, можно получить доступ к навигационному делегату в любом месте приложения, где есть доступ к контексту. При обращении к навигационному делегату можно использовать ранее рассмотренные методы push, pop и pushReplacement, однако теперь они в качестве аргументов будут принимать не страницу навигации, а маршрут до требуемой страницы.

*Вертикальная маршрутизированная навигация*

Вертикальная маршрутизированная навигация реализована с использованием декларативных маршрутов GoRouter. Такой подход обеспечивает сохранение стека экранов и позволяет пользователю возвращаться на предыдущие страницы при помощи метода context.pop().

Реализация вертикального маршрутизированного перехода от списка привычек к экрану добавления привычки при помощи метода context.pushNamed() показана в #r(<lst-router-push>). Демонстрация навигации — на #r(<img-router-list-1>) и #r(<img-router-form-1>).

#listing(
  body: raw(
    lang: "dart",
    "
floatingActionButton: FloatingActionButton(
  onPressed: () => context.pushNamed(Routes.habbitAdd),
  tooltip: 'Add Habbit',
  child: const Icon(Icons.add),
),
    "
  ),
  caption: [Реализация вертикального маршрутизированного перехода на экран добавления привычки],
) <lst-router-push>

#picture(
  path: img("habbit_list_initial"),
  caption: [Экран списка привычек до выполнения вертикальной маршрутизированной навигации],
  width: 30%,
) <img-router-list-1>

#picture(
  path: img("navigation_push_replacement_demo_before"),
  caption: [Экран добавления привычки после выполнения вертикальной маршрутизированной навигации],
  width: 30%,
) <img-router-form-1>

Реализация вертикального маршрутизированного перехода к экрану статистики привычки с передачей параметра ID показана в #r(<lst-router-push-params>). Демонстрация навигации — на #r(<img-router-list-2>) и #r(<img-router-stats>).

#listing(
  body: raw(
    lang: "dart",
    "
onTap: () => context.pushNamed(
  Routes.habbitStats,
  pathParameters: {'id': habbit.id.toString()},
),
    "
  ),
  caption: [Реализация вертикального маршрутизированного перехода с передачей параметров],
) <lst-router-push-params>

#picture(
  path: img("habbit_list_initial"),
  caption: [Экран списка привычек до выполнения вертикальной маршрутизированной навигации на экран статистики],
  width: 30%,
) <img-router-list-2>

#picture(
  path: img("habbit_stats_screen"),
  caption: [Экран статистики привычки после выполнения вертикальной маршрутизированной навигации],
  width: 30%,
) <img-router-stats>

Реализация вертикального маршрутизированного перехода назад осуществляется с помощью метода context.pop(), показанного в #r(<lst-router-pop>). Демонстрация навигации — на #r(<img-router-stats-before-pop>) и #r(<img-router-list-after-pop>).

#listing(
  body: raw(
    lang: "dart",
    "
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => context.pop(),
),
    "
  ),
  caption: [Реализация метода context.pop() для возврата на предыдущий экран],
) <lst-router-pop>

#picture(
  path: img("habbit_stats_screen"),
  caption: [Экран статистики до нажатия кнопки возврата],
  width: 30%,
) <img-router-stats-before-pop>

#picture(
  path: img("habbit_list_after_add"),
  caption: [Экран списка привычек после выполнения маршрутизированного возврата],
  width: 30%,
) <img-router-list-after-pop>

*Горизонтальная маршрутизированная навигация*

Горизонтальная маршрутизированная навигация реализована с использованием метода context.goNamed(). В приложении данный механизм применяется на экране редактирования/добавления привычки: после нажатия кнопки «Готово» выполняется переход с полной заменой навигационного стека на главный экран со списком привычек.

Реализация показана в #r(<lst-router-go>). Демонстрация — на #r(<img-router-form-filled>) и #r(<img-router-list-after-save>). Основная особенность такого перехода заключается в том, что после его выполнения пользователь не может вернуться на предыдущий экран, поскольку навигационный стек полностью обновляется.

#listing(
  body: raw(
    lang: "dart",
    "
void _submitForm() {
  if (_isFormValid) {
    if (_editingHabbit == null) {
      widget.habbits.addHabbit(
        name: _nameController.text,
        iconUrl: _iconUrlController.text,
        targetDays: int.parse(_targetDaysController.text),
      );
    } else {
      widget.habbits.editHabbit(
        habbitId: _editingHabbit!.id,
        name: _nameController.text,
        iconUrl: _iconUrlController.text,
        targetDays: int.parse(_targetDaysController.text),
      );
    }
    context.goNamed(Routes.habbitsList);
  }
}
    "
  ),
  caption: [Реализация горизонтальной маршрутизированной навигации с помощью метода goNamed],
) <lst-router-go>

#picture(
  path: img("navigation_push_replacement_demo_before"),
  caption: [Экран редактирования привычки до нажатия кнопки «Готово»],
  width: 30%,
) <img-router-form-filled>

#picture(
  path: img("navigation_push_replacement_demo_after"),
  caption: [Экран списка привычек после выполнения горизонтальной маршрутизированной навигации с заменой стека],
  width: 30%,
) <img-router-list-after-save>

В результате проведённой работы была успешно реализована и протестирована комплексная система навигации, включающая как страничную, так и маршрутизированную навигацию. Все виды навигационных переходов были тщательно протестированы в различных условиях и продемонстрировали стабильную работу. Использование GoRouter позволило значительно упростить навигационную структуру, сделать код более читаемым и поддерживаемым. Результаты тестирования подтвердили, что разработанная система навигации обеспечивает высокую производительность, отзывчивость и соответствие ожиданиям пользователей.

= Вывод

В ходе выполнения практической работы была разработана и внедрена комплексная система навигации для мобильного приложения трекинга привычек, включающая как страничную навигацию с использованием Navigation 1.0, так и маршрутизированную навигацию на основе пакета go_router.

В процессе работы были реализованы основные виды навигационных переходов — вертикальные (push/pop, context.pushNamed/context.pop) и горизонтальные (pushReplacement, context.goNamed). Проведено тестирование переходов между всеми экранами приложения: списком привычек, экраном добавления/редактирования привычки и экраном статистики.

Использование go_router позволило значительно упростить навигационную структуру, сделать код более читаемым и поддерживаемым, а также обеспечить корректную работу с URL-адресами и глубокими ссылками. Система навигации продемонстрировала высокую стабильность, отзывчивость и удобство для пользователя, что соответствует требованиям к современным мобильным приложениям.

Все изменения, выполненные в результате данной практической работы, были сохранены в удаленном репозитории GitHub:

https://github.com/burenotti/mirea-crossplatform-2/tree/burenin/practice-7
