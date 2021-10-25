### Ключевые моменты SQL (Mysql)

## Содержание

[Отличия MyISAM и InnoDB](#Отличия-MyISAM-и-InnoDB)

[Объединение таблиц и выборок](#Объединение-таблиц-и-выборок)

[Индексы](#Индексы)

[Триггеры](#Триггеры)

[Ключи](#Ключи)

[Представления](#Представления)

[Транзакции](#Транзакции)


### **Отличия MyISAM и InnoDB**

| Описание      | MyISAM        | InnoDB       |
| ------------- | ------------- | -------------
| Транзакции  | Нет  | Да |
| Внешние ключи  | Нет | Да |
| Блокировки | Блокирует всю таблицу | Блокирует только строку |
| Одновременные запросы к разным участкам таблицы (tests/different_areas.sql) | Медленее | Быстрее |
| При смешанной нагрузке в таблице (SELECT/UPDATE/DELETE/INSERT) | Медленее | Быстрее |
| Операция INSERT | Быстрее | Медленее |
| Если преобладают операции чтения | Быстрее | Медленее |
| Deadlock
| Deadlock — ситуация в многозадачной среде или СУБД, при которой несколько процессов находятся в состоянии бесконечного ожидания ресурсов, захваченных самими этими процессами.| Нет | Да |
| Запрос Count(*) (tests/count.sql) | Быстрее | Медленее |
|Размер занимаемого места на диске|Меньше|Больше (примерно в 1,5 раза)|
|Поведение в случае сбоя|Ломается вся таблица|Можно восстановить по логам транзакций|
|Способ хранения| Каждая таблица имеет два файла (данные и индекс)| В одном или нескольких больших файлах |
|Кластерные индексы|Нет|Да|
|Кеши данных|Нет|Да|
|MVCC ( управление параллельным доступом посредством многоверсионности)|Нет|Да|
|Пределы хранилища|256Tb| 64Tb|

### **Объединение таблиц и выборок**

*UNION* - оператор объединения наборов строк, возвращаемых SQL-запросами. Не имеет ограничения на количество запросов.

*JOIN* - оператор операции соединения таблиц.

#### Union

|Union| Union ALL|
| ------------- | ------------- | 
| Одинаковые строки выводится не будут. | Покажет все строки включая дубликаты |

Требования для запросов в UNION:

* одинаковый набор колонок для выборки
* одинаковое количество выражений
* одинаковые типы данных колонок и
* одинаковый порядок колонок

#### Варианты JOIN:

**INNER JOIN** — возвращает записи, имеющиеся в обеих таблицах

**LEFT JOIN** — возвращает записи из левой таблицы, даже если такие записи отсутствуют в правой таблице

**RIGHT JOIN** — возвращает записи из правой таблицы, даже если такие записи отсутствуют в левой таблице

**FULL (OUTER) JOIN** — возвращает все записи объединяемых таблиц

**CROSS JOIN** — возвращает все возможные комбинации строк обеих таблиц

**SELF JOIN** — используется для объединения таблицы с самой собой

### **Индексы**

Индексы — это специальные поисковые таблицы (lookup tables), которые используются движком БД в целях более быстрого
извлечения данных. Проще говоря, индекс — это указатель или ссылка на данные в таблице.

Индексы ускоряют работу инструкции SELECT и предложения WHERE, но замедляют работу инструкций UPDATE и INSERT. Индексы
могут создаваться и удаляться, не оказывая никакого влияния на данные.

Индексы реализуются на уровне подсистем хранения, а не на уровне сервера.

Преимущества:
1. Индексы уменьшают объем данных, которые сервер должен просмотреть для на-
хождения искомого значения.
2. Индексы помогают серверу избежать сортировки и временных таблиц.
3. Индексы превращают произвольный ввод/вывод в последовательный.

Ограничения индексов:
1. Индексы занимают местов памяти
2. Замедляют скорость написания запросов, таких как INSERT, UPDATE и DELETE.

#### Типы индексов (не все):

#### B-Tree
Индексы, упорядоченные на основе В-дерева. Общая идея В-дерева заключается в том, что значения хранятся по порядку и все
листья-страницы находятся на одинаковом расстоянии от корня.Индекс, упорядоченный на основе В-дерева, ускоряет доступ к данным, посколь­
ку подсистеме хранения не нужно сканировать всю таблицу для поиска искомых
данных. Вместо этого она начинает с корневого узла. В корневом узле имеется массив указателей на дочерние узлы, и подсистема хра­
нения переходит по этим указателям. Для нахождения подходящего указателя
она просматривает значения в узловых страницах, которые определяют верхнюю
и нижнюю границы значений в дочерних узлах. В итоге подсистема хранения либо
определяет, что искомого значения не существует, либо благополучно достигает
нужного листа. Листья-страницы представляют собой особый случай, поскольку в них находятся
указатели на индексированные данные, а не на другие страницы.

Индексы В-дерева хорошо работают при поиске по полному значению ключа, диапазону ключей или префиксу ключа. Они полезны тол ько тогда, 
когда используется крайний левый префикс ключа.

Обратите внимание на то, что в индексе значения упорядочены в том же порядке,
в котором столбцы указаны в команде СRЕАТЕ TABLE.

Ограничения:
* Они бесполезны, если в критерии поиска не указан крайний левый из индексиро-
  ванных столбцов.
* Нельзя пропускать столбцы индекса.
* Подсистема хранения не может оптимизировать поиск по столбцам, находящимся правее первого столбца, по которому осуществляется поиск в заданном диапазоне.

#### Хеш-индексы
Хеш-индекс строится на основе хеш-таблицы и полезен только для точного поиска,
использующего все столбцы индекса.Для каждой строки подсистема хранения вычис
ляет хеш-код индексированных столбцов - сравнительно короткое значение, которое,
скорее всего, будет различным для строк с разными значениями ключей. В индексе
хранятся хеш-коды и указатели на соответствующие строки в хеш-таблице.

Ограничения:
* Поскольку индекс содержит только хеш-коды и указатели на строки, а не сами значения, MySQL не может использовать данные в индексе, чтобы избежать чтения строк.
* MySQL не может использовать хеш-индексы для сортировки, поскольку строки в этой системе не отсортированы.
* Хеш-индексы не поддерживают поиск по частичному ключу, поскольку хеш-коды вычисляются для всего индексируемого значения.
* Хеш-индексы поддерживают лишь сравнения на равенство, то есть использование операторов =, IN() и<=>.
* Доступ к данным в хеш-индексе можно получить очень быстро, если нет большого
  количества коллизий (нескольких значений с одним и тем же хеш-кодом). При
  их наличии подсистема хранения вынуждена проходить по каждому указателю на строку, хранящемуся в связанном списке, и сравнивать значение в этой строке
  с искомым.
* Некоторые операции обслуживания индекса могут оказаться медленными, если
  количество коллизий велико.

#### R-tree
MylSAM поддерживает пространственные индексы, которые можно использовать
с частичными типами, такими как GEOMETRY. В отличие от индексов, упорядочен
ных на основе В-дерева, при работе с пространственными индексами не требуется,
чтобы в разделе WHERE указывался крайний левый из индексированных столбцов.
Они одновременно индексируют данные по всем столбцам. В результате при по
иске может эффективно использоваться любая комбинация столбцов.

#### Полнотекстовые индексы
Полнотекстовый (FULL ТЕХТ) индекс представляет собой специальный тип индекса,
который ищет ключевые слова в тексте вместо того, чтобы прямо сравнивать ис
комое значение со значениями в индексе. Полнотекстовый поиск кардинально
отличается от других типов поиска. Он позволяет использовать стоп-слова, мор
фологический поиск, учет множественного числа, а также булев поиск. Он гораздо
больше напоминает работу поисковых систем, чем простое сравнение с критерием
в разделе WHERE.
Наличие полнотекстового индекса по столбцу не делает индекс, упорядоченный на
основе В-дерева по этому столбцу, менее полезным. Полнотекстовые индексы пред
назначены для операций МАТСН AGAINST, а не для обычных операций с фразой WHERE.

### **Триггеры**
Триггер в MySQL — это определяемая пользователем SQL-команда, которая автоматически вызывается во время операций INSERT, DELETE или UPDATE. Код триггера связан с таблицей и уничтожается после удаления таблицы.
Вы можете определить время действия триггера и указать, когда его нужно активировать – до или после определенного события базы данных.

Виды триггеров:
1. INSERT (BEFORE | AFTER)
2. UPDATE (BEFORE | AFTER)
3. DELETE (BEFORE | AFTER)

Области применения:
1. обеспечение ссылочной целостности при сохранении записи
2. регистрация действий пользователя для аудита таблиц
3. оперативное копирование данных в разных схемах баз данных для обеспечения избыточности и предотвращения единой точки отказа
4. генерации значения производного столбца во время выполнения INSERT

Преимущества:
1. Код выполняется на уровне БД 
2. Иногда они помогают сохранить короткие и простые коды SQL
3. Они помогают поддерживать ограничения целостности в таблицах базы данных, особенно когда не определены ограничения первичного ключа и внешнего ключа.

Недостатки:
1. Трудно поддерживать, т.к. код хранится в БД.
2. Трудно отлаживать 
3. Использование триггеров может замедлить производительность приложения
4. Стоимость создания триггеров может быть больше для таблиц, в которых высока частота операций DML (вставка, удаление и обновление), таких как массовая вставка.
5. Триггер может быть привязан только к одной таблице. 

Примеры кода триггеров в файлах в папке triggers. 


### **Ключи**
Ключи - это поля в реляционной таблице, которые создают отношения между другими таблицами, поддерживают целостность, уникальность и т. Д. 

Первичный ключ - это колонка (column) или колонки, не имеющие в строках дублирующих значений.
Может быть несколько потенциальных первичных ключей. 

Внешний ключ - колонка в которой содержится первичный ключ другой таблицы.

Связи через внешние ключи показано в файле keys/foreign_keys.sql

Помимо проверки корректности значения внешнего ключа при добавлении и изменении строк дочерней таблицы, 
необходимо также предотвратить нару-
шение ссылочной целостности при удалении и изменении строк родительской таблицы. Для
этого существует несколько способов.
1. Запрет (RESTRICT): если на строку родительской таблицы ссылается хотя бы одна
строка дочерней таблицы, то удаление родительской строки и изменение значения первич-
ного ключа в такой строке запрещаются. 
 
2. Каскадное удаление/обновление (CASCADE): при удалении строки из родительской
таблицы автоматически удаляются все ссылающиеся на нее строки дочерней таблицы; при
изменении значения первичного ключа в строке родительской таблицы автоматически обно-
вляется значение внешнего ключа в ссылающихся на нее строках дочерней таблицы.

3. Обнуление (SET NULL): при удалении строки и при изменении значения первичного
ключа в строке значение внешнего ключа во всех строках, ссылающихся на данную, автома-
тически становится неопределенным (NULL).


### **Представления**
Представление (VIEW) — объект базы данных, являющийся результатом выполнения запроса к базе данных, определенного с помощью оператора SELECT, в момент обращения к представлению.
Представление доступно для пользователя как таблица, но само оно не содержит данных, а извлекает их из таблиц в момент обращения к нему.

 - Кеширование результатов выборки не работает
 - query cache работает на уровне пользователя
 - Могу тбыть основаны как на таблицах так и на других представлениях (32 уровня вложенности)

Преимущества
1. Гибкая настройка прав доступа
2. Разделение логики хранения и по.
3. Удобство в использовании за счет автоматического выполнения таких действий как доступ к определенной части строк и/или столбцов, получение данных из нескольких таблиц и их преобразование с помощью различных функций.

Ограничения:
1. нельзя повесить триггер на представление,
2. нельзя сделать представление на основе временных таблиц; нельзя сделать временное представление;
3. в определении представления нельзя использовать подзапрос в части FROM,
4. в определении представления нельзя использовать системные и пользовательские переменные; внутри хранимых процедур нельзя в определении представления использовать локальные переменные или параметры процедуры,
5. в определении представления нельзя использовать параметры подготовленных выражений (PREPARE),
6. таблицы и представления, присутствующие в определении представления должны существовать.
7. только представления, удовлетворяющие ряду требований, допускают запросы типа UPDATE, DELETE и INSERT.

Примеры в views/example.sql

Представление называется обновляемым, если к нему могут быть применимы операторы UPDATE и DELETE для изменения данных в таблицах, на которых основано представление. Для того, чтобы представление было обновляемым должно быть выполнено 2 условия:
Соответствие 1 к 1 между строками представления и таблиц, на которых основано представление, т.е. каждой строке представления должно соответствовать по одной строке в таблицах-источниках.
Поля представления должны быть простым перечислением полей таблиц, а не выражениеями col1/col2 или col1+2.

### **Транзакции**

Транзакция представляет собой группу запросов SQL, обрабатываемых атомарно, то есть как единое целое.

Нужно понимать и знать следующее:

1) ACID - критерии для транзакций (Атомарность, Согласованость, Изолированость, Долговечность)

Атомарность. Транзакция должна функционировать как единая неделимая ра­бочая единица таким образом, чтобы вся она была либо выполнена, либо отменена. Для атомарных транзакций не существует такого понятия, как частичное выполнение: все или ничего.

Согласованность. База данных всегда должна переходить из одного согласован­ного состояния в другое. Если транзакция не будет подтверждена, ни одно из изменений не отразится в базе данных.

Изолированность. Результаты транзакции обычно невидимы другим транзак­циям, пока она не подтверждена. 

Долговечность. После подтверждения внесенные в ходе транзакции изменения становятся постоянными. Это значит, что они должны быть записаны так, чтобы данные не потерялись при сбое системы. 


2) Уровни изоляции

READ UNCOMMITTED. На этом уровне изолированности транзакции могут видеть результаты незавершенных транзакций. Вы можете столкнуться с множеством проблем, если не знаете абсолютно точно, что делаете. Используйте этот уровень, только если у вас есть на то веские причины. На практике этот уровень применя­ется редко, поскольку в этом случае производительность лишь немного выше, чем на других уровнях, имеющих множество преимуществ. Чтение незавершенных данных называют еще черновым, или «грязным» чтением (dirty read).

READ COMMITTED. Это уровень изолированности, который устанавливается по умолча­нию в большинстве СУБД (но не в MySQL!). Он соответствует приведенному ранее простому определению изолированности: транзакция увидит только те изменения, которые к моменту ее начала подтверждены другими транзакциями, а произведен­ные ею изменения останутся невидимыми для других транзакций, пока текущая не будет подтверждена. На этом уровне возможно так называемое неповторяющееся чтение (nonrepeatable read). Это означает, что вы можете выполнить одну и ту же команду дважды и получить разный результат.

REPEATABLE READ. Этот уровень изолированности позволяет решить проблемы, ко­торые возникают на уровне READ UNCOMMITTED. Он гарантирует, что любые строки, которые считываются транзакцией, будут выглядеть одинаково при последовательных операциях чтения в пределах одной транзакции, однако теоретически на этом уровне возможна другая проблема, которая называется фантомным чтением (phantom reads). Проще говоря, фантомное чтение может произойти в случае, если вы выбираете некоторый диапазон строк, затем другая транзакция вставляет в него новую строку, после чего вы снова выбираете тот же диапазон. В результате вы увидите новую, фантомную строку. InnoDB и XtraDB решают проблему фантомного чтения с помощью многоверсионного управления конку­рентным доступом (multiversion concurrency control). Уровень изолированности REPEATABLE READ устанавливается в MySQL по умол­чанию.

SERIALIZABLE. Самый высокий уровень изолированности, который решает про­блему фантомного чтения, заставляя транзакции выполняться в таком порядке, чтобы исключить возможность конфликта. Если коротко, уровень SERIALIZABLE блокирует каждую читаемую строку. На этом уровне может возникать множество задержек и конфликтов блокировок. Нам редко встречались люди, использующие этот уровень, но потребности вашего приложения могут заставить применять его, смирившись с меньшей степенью конкурентного доступа, но обеспечивая стабильность данных.


Для понимания транзакций лучше ознакомится со статье https://oracle-patches.com/db/mysql/tranzaktsii-v-baze-dannyh-mysql


