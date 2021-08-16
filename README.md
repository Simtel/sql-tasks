### Ключевые моменты SQL (Mysql)

## Содержание

[Отличия MyISAM и InnoDB](#Отличия-MyISAM-и-InnoDB)

[Объединение таблиц и выборок](#Объединение-таблиц-и-выборок)

[Индексы](#Индексы)

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
использующего все столбцы индекса.Для каждой строки подсистема хранения вычис­
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