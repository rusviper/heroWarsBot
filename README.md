Автоматизация HeroWars
----------------------
Бот для игры под android [Hero Wars: Alliance](https://play.google.com/store/apps/details?id=com.nexters.herowars&pcampaignid=web_share).

Быстрый старт
-------------
1. Устанавливаем [AnkuLua Lite](https://ankulua.boards.net/thread/1395/free-ankulua-trial-apk-download).
2. Качаем содержимое данного репозитория себе на телефон в произвольную папку.
3. Запускаем AnkuLua. (Попросит разрешение записи с экрана, нужно чтобы парсить картинку игры).
4. В приложении AnkuLua нажимаем `Select script`. Выбираем основной скрипт приложения: `<путь_до_проекта>/bot/heroWarsBot.lua`
5. Нажимаем `Start service` - появится кнопка запуска скрипта.
6. Запускаем нашу игру Hero Wars: Alliance.
7. Во время игры нажимаем запуск скрипта и выбираем необходимое действие.

Описание работы
---------------
Скрипты автоматизации достаточно глупые: ожидаем, что находимся на определённом экране, ищем по картинке определённую
область и нажимаем на неё (Иногда по координатам).
Реализованы следующие функции:
- TODO Перечень


Описание функций
----------------
TODO Описание функции: стартовый экран, известные проблемы, задачи

Список использованных решений
-----------------------------
- Поставщик решения автоматизации под android: [AnkuLua](https://ankulua.boards.net/thread/181/api-quick-reference).
- Автоматизация поиска и интеракции с приложениями: AnkuLua базируется на [Sikuli](https://sikulix-2014.readthedocs.io/en/latest/index.html)
- Язык: Используют lua-сприпты. См.: https://www.lua.org/pil/