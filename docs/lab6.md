# Лабораторная работа 6 — Modeling Users

Основа: локальный web5. Сохраняем Rails 8.1.4 и Ruby 3.4.11 исходного приложения; миграции адаптированы к Rails 8.1. Все действия локальные. Результаты упражнений добавляются по этапам.

## 6.1.1–6.1.2. Модель и миграция

`CreateUsers` создаёт name, email и timestamps. `db/schema.rb` описывает результат миграций, включая версию схемы, автоматический id и поля created_at/updated_at. В Rails 8.1 SQLite хранится в storage/, а не db/.

Проверка: `bash script/lab6_migrations.sh` (на этапе создания модели). Скрипт применяет миграцию, откатывает её, проверяет отсутствие users и повторно применяет; сравнивает схему до и после. Исходная документация: https://guides.rubyonrails.org/active_record_migrations.html.

Для воспроизведения ранних упражнений используйте соответствующий коммит в отдельной копии репозитория с отдельной БД: поздние валидации намеренно меняют результаты.

## 6.1.3–6.1.5 и 6.2.1. Операции с объектами

Упражнения выполнены script/lab6_basics.rb в транзакции с откатом (эквивалент sandbox). Вывод: [6.1-objects.txt](6.1-objects.txt).

User наследует ApplicationRecord, тот — ActiveRecord::Base. Имя и email — String; timestamps — ActiveSupport::TimeWithZone. User.all — User::ActiveRecord_Relation, поддерживает length. Проверены find, find_by, find_by_name, first, create, destroy, присваивание с save, update, reload и изменение created_at на 1.year.ago. До введения валидаций и пустой новый пользователь, и сохранённый пользователь валидны. Унаследованные тесты web5: 7 tests, 27 assertions, 0 failures, 0 errors.

## 6.2.2. Наличие значений

Тесты сначала RED, затем GREEN. У пустого u ошибки Name can't be blank и Email can't be blank. u.errors.messages — Hash; ошибки email доступны через u.errors.messages[:email] или u.errors[:email]. Фактический вывод: 6.2.2-errors.txt.

## 6.2.3. Длина

51 символ имени и 256 символов email невалидны; пределы 50/255 валидны. Сообщения: Name is too long (maximum is 50 characters), Email is too long (maximum is 255 characters). Вывод: 6.2.3-errors.txt; RED/GREEN сохранены отдельно.

## 6.2.4. Формат email и Rubular

Проверены все адреса листингов 6.18–6.19. Добавление foo@bar..com даёт RED; выражение 6.23 — GREEN. Результаты: 6.2.4-*.txt.

В Rubular исходный шаблон ошибочно выделяет foo@bar..com; исправленный выделяет только пять допустимых адресов. Для списка строк вместо \A и \z использованы ^ и $, чтобы проверять целые строки, а не подстроки; в модели оставлены \A и \z. Флаг i сохранён.

![Rubular: пять корректных адресов](rubular.png)


## 6.2.5. Уникальность и нормализация

Проверены дубликаты с другим регистром и уникальный индекс БД. Fixtures пустые: стандартные записи MyString нарушили бы индекс. Принудительное сохранение дубликата без валидаций вызывает RecordNotUnique.

Тест нормализации с reload падает без callback и проходит с self.email = email.downcase, затем с email.downcase!. Финальный вариант — downcase!. Сохранена регистронезависимая валидация: возврат к uniqueness: true из листинга 6.32 пропускает mixed-case дубликат на этапе valid?, поскольку before_save вызывается позже. Это осознанное исправление примера, позволяющее получить ошибку модели до записи. Результаты: 6.2.5-*.txt.

## 6.3.1–6.3.2. Хеш пароля

Добавлены bcrypt, password_digest и has_secure_password. Пароль и подтверждение виртуальные, в БД только digest. При валидных name/email пользователь без пароля невалиден: Password can't be blank. Тестовые объекты дополнены password/password_confirmation. API: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html.

## 6.3.3. Требования к паролю

Пробелы и пароль длиной 5 невалидны; 6 символов валидны. У короткого пароля ошибка Password is too short (minimum is 6 characters). Дополнительно проверены несовпадающее подтверждение и встроенный предел bcrypt 72 байта. Вывод: 6.3.3-errors.txt.

## 6.3.4. Создание и аутентификация

В обычной Rails console создан Michael Hartl (michael@example.com, учебный пароль foobar). Вторая отдельная сессия console нашла сохранённую запись. Неверные пароли возвращают false, верный — объект user; !! преобразует его в true. Вывод сессий: 6.3.4-create.txt и 6.3.4-authenticate.txt.

После загрузки из БД виртуальный password пуст. Явная валидация presence/length из главы блокирует save даже при изменении только имени. update_attribute(:name, "Никита Сотников") пропускает валидации и сохраняет имя, как требуется в упражнении. Это намеренное поведение главы 6, проверенное отдельным тестом. БД находится в storage/development.sqlite3 и исключена из Git; для восстановления учебной записи выполните два скрипта через Rails console.
