
&ИзменениеИКонтроль("ЗагрузитьСОбработкой")
Процедура РСК_ЗагрузитьСОбработкой(ТаблицаРеестрДокументов)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаРеестрДокументов.ТипСсылки КАК ТипСсылки,
	|	ТаблицаРеестрДокументов.Организация КАК Организация,
	|	ТаблицаРеестрДокументов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаблицаРеестрДокументов.Партнер КАК Партнер,
	|	ТаблицаРеестрДокументов.Контрагент КАК Контрагент,
	|	ТаблицаРеестрДокументов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаРеестрДокументов.ДополнительнаяЗапись КАК ДополнительнаяЗапись,
	|	ТаблицаРеестрДокументов.Подразделение КАК Подразделение,
	|	ТаблицаРеестрДокументов.МестоХранения КАК МестоХранения,
	|	ТаблицаРеестрДокументов.ДатаДокументаИБ КАК ДатаДокументаИБ,
	|	ТаблицаРеестрДокументов.Ссылка КАК Ссылка,
	|	ТаблицаРеестрДокументов.РазделительЗаписи КАК РазделительЗаписи,
	|	ТаблицаРеестрДокументов.НомерДокументаИБ КАК НомерДокументаИБ,
	|	ТаблицаРеестрДокументов.Статус КАК Статус,
	|	ТаблицаРеестрДокументов.Ответственный КАК Ответственный,
	|	ТаблицаРеестрДокументов.Автор КАК Автор,
	|	ТаблицаРеестрДокументов.Дополнительно КАК Дополнительно,
	|	ТаблицаРеестрДокументов.Комментарий КАК Комментарий,
	|	ТаблицаРеестрДокументов.Проведен КАК Проведен,
	|	ТаблицаРеестрДокументов.ПометкаУдаления КАК ПометкаУдаления,
	|	ТаблицаРеестрДокументов.ДатаПервичногоДокумента КАК ДатаПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НомерПервичногоДокумента КАК НомерПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НаименованиеПервичногоДокумента КАК НаименованиеПервичногоДокумента,
	|	ТаблицаРеестрДокументов.Сумма КАК Сумма,
	|	ТаблицаРеестрДокументов.Валюта КАК Валюта,
	|	ТаблицаРеестрДокументов.ДатаОтраженияВУчете КАК ДатаОтраженияВУчете,
	|	ТаблицаРеестрДокументов.Договор КАК Договор,
	|	ТаблицаРеестрДокументов.СторноИсправление КАК СторноИсправление,
	|	ТаблицаРеестрДокументов.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	ТаблицаРеестрДокументов.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ТаблицаРеестрДокументов.Приоритет
	|ПОМЕСТИТЬ ТаблицаРеестрДокументов
	|ИЗ
	|	&ТаблицаРеестрДокументов КАК ТаблицаРеестрДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеестрДокументов.ТипСсылки КАК ТипСсылки,
	|	ТаблицаРеестрДокументов.Организация КАК Организация,
	|	ТаблицаРеестрДокументов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаблицаРеестрДокументов.Партнер КАК Партнер,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.Контрагент) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ТаблицаРеестрДокументов.Контрагент
	|		ИНАЧЕ ЕСТЬNULL(КлючиРеестраДокументовКонтрагент.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка))
	|	КОНЕЦ КАК Контрагент,
	|	ТаблицаРеестрДокументов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаРеестрДокументов.ДополнительнаяЗапись КАК ДополнительнаяЗапись,
	|	ТаблицаРеестрДокументов.Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.МестоХранения) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ТаблицаРеестрДокументов.МестоХранения
	|		ИНАЧЕ ЕСТЬNULL(КлючиРеестраДокументовМестоХранения.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка))
	|	КОНЕЦ КАК МестоХранения,
	|	ТаблицаРеестрДокументов.ДатаДокументаИБ КАК ДатаДокументаИБ,
	|	ТаблицаРеестрДокументов.Ссылка КАК Ссылка,
	|	ТаблицаРеестрДокументов.РазделительЗаписи КАК РазделительЗаписи,
	|	ТаблицаРеестрДокументов.НомерДокументаИБ КАК НомерДокументаИБ,
	|	ТаблицаРеестрДокументов.Статус КАК Статус,
	|	ТаблицаРеестрДокументов.Ответственный КАК Ответственный,
	|	ТаблицаРеестрДокументов.Автор КАК Автор,
	|	ТаблицаРеестрДокументов.Дополнительно КАК Дополнительно,
	|	ТаблицаРеестрДокументов.Комментарий КАК Комментарий,
	|	ТаблицаРеестрДокументов.Проведен КАК Проведен,
	|	ТаблицаРеестрДокументов.ПометкаУдаления КАК ПометкаУдаления,
	|	ТаблицаРеестрДокументов.ДатаПервичногоДокумента КАК ДатаПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НомерПервичногоДокумента КАК НомерПервичногоДокумента,
	|	ТаблицаРеестрДокументов.НаименованиеПервичногоДокумента КАК НаименованиеПервичногоДокумента,
	|	ТаблицаРеестрДокументов.Сумма КАК Сумма,
	|	ТаблицаРеестрДокументов.Валюта КАК Валюта,
	|	ТаблицаРеестрДокументов.ДатаОтраженияВУчете КАК ДатаОтраженияВУчете,
	|	ТаблицаРеестрДокументов.Договор КАК Договор,
	|	ТаблицаРеестрДокументов.Приоритет КАК Приоритет,
	|	ТаблицаРеестрДокументов.СторноИсправление КАК СторноИсправление,
	|	ТаблицаРеестрДокументов.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	ТаблицаРеестрДокументов.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.Контрагент) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ЛОЖЬ
	|		КОГДА НЕ ТаблицаРеестрДокументов.Контрагент В(&ПустыеЗначенияКлючей)
	|				И КлючиРеестраДокументовКонтрагент.Ссылка ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОшибкаПустойКлючКонтрагент,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТаблицаРеестрДокументов.МестоХранения) = ТИП(Справочник.КлючиРеестраДокументов)
	|			ТОГДА ЛОЖЬ
	|		КОГДА НЕ ТаблицаРеестрДокументов.МестоХранения В(&ПустыеЗначенияКлючей)
	|				И КлючиРеестраДокументовМестоХранения.Ссылка ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОшибкаПустойКлючМестоХранения,
	|	ТаблицаРеестрДокументов.МестоХранения КАК МестоХраненияИзТаблицы,
	|	ТаблицаРеестрДокументов.Контрагент КАК КонтрагентИзТаблицы
	|ПОМЕСТИТЬ ТаблицаРеестрДокументовСКлючами
	|ИЗ
	|	ТаблицаРеестрДокументов КАК ТаблицаРеестрДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументовМестоХранения
	|		ПО ТаблицаРеестрДокументов.МестоХранения = КлючиРеестраДокументовМестоХранения.Ключ
	#Вставка
	|И НЕ КлючиРеестраДокументовМестоХранения.Ключ = НЕОПРЕДЕЛЕНО
	#КонецВставки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументовКонтрагент
	|		ПО ТаблицаРеестрДокументов.Контрагент = КлючиРеестраДокументовКонтрагент.Ключ
	#Вставка
	|И НЕ КлючиРеестраДокументовКонтрагент.Ключ = НЕОПРЕДЕЛЕНО
	#КонецВставки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеестрДокументовСКлючами.ЕстьОшибкаПустойКлючКонтрагент КАК ЕстьОшибкаПустойКлючКонтрагент,
	|	ТаблицаРеестрДокументовСКлючами.ЕстьОшибкаПустойКлючМестоХранения КАК ЕстьОшибкаПустойКлючМестоХранения,
	|	ТаблицаРеестрДокументовСКлючами.МестоХраненияИзТаблицы КАК МестоХраненияИзТаблицы,
	|	ТаблицаРеестрДокументовСКлючами.КонтрагентИзТаблицы КАК КонтрагентИзТаблицы
	|ИЗ
	|	ТаблицаРеестрДокументовСКлючами КАК ТаблицаРеестрДокументовСКлючами
	|ГДЕ
	|	(ТаблицаРеестрДокументовСКлючами.ЕстьОшибкаПустойКлючКонтрагент
	|			ИЛИ ТаблицаРеестрДокументовСКлючами.ЕстьОшибкаПустойКлючМестоХранения)";

	Для каждого Измерение Из Метаданные.РегистрыСведений.РеестрДокументов.Измерения Цикл

		Колонка = ТаблицаРеестрДокументов.Колонки.Найти(Измерение.Имя);

		Если Колонка <> Неопределено Тогда
			Если Колонка.ТипЗначения = Новый ОписаниеТипов("Неопределено")
				Или Колонка.ТипЗначения = Новый ОписаниеТипов("Null") Тогда
				ТаблицаРеестрДокументов.Колонки.Удалить(Колонка);
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		ТаблицаРеестрДокументов.Колонки.Добавить(Измерение.Имя, Измерение.Тип);

	КонецЦикла;

	Для каждого Ресурс Из Метаданные.РегистрыСведений.РеестрДокументов.Ресурсы Цикл

		Колонка = ТаблицаРеестрДокументов.Колонки.Найти(Ресурс.Имя);

		Если Колонка <> Неопределено Тогда
			Если Колонка.ТипЗначения = Новый ОписаниеТипов("Неопределено")
				Или Колонка.ТипЗначения = Новый ОписаниеТипов("Null") Тогда
				ТаблицаРеестрДокументов.Колонки.Удалить(Колонка);
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		ТаблицаРеестрДокументов.Колонки.Добавить(Ресурс.Имя, Ресурс.Тип);

	КонецЦикла;

	ПустыеЗначенияКлючей = Новый Массив;
	ПустыеЗначенияКлючей.Добавить(Неопределено);
	ПустыеЗначенияКлючей.Добавить(Null);

	Для Каждого ТипЗначенияКлюча из Метаданные.Справочники.КлючиРеестраДокументов.Реквизиты.Ключ.Тип.Типы() Цикл
		ПустыеЗначенияКлючей.Добавить(ПредопределенноеЗначение(Метаданные.НайтиПоТипу(ТипЗначенияКлюча).ПолноеИмя() + ".ПустаяСсылка"));
	КонецЦикла;

	Запрос.УстановитьПараметр("ПустыеЗначенияКлючей", ПустыеЗначенияКлючей);
	Запрос.УстановитьПараметр("ТаблицаРеестрДокументов", ТаблицаРеестрДокументов);

	РезультатыЗапроса = Запрос.ВыполнитьПакетСПромежуточнымиДанными();

	Ошибки = РезультатыЗапроса[2].Выбрать();	

	Пока Ошибки.Следующий() Цикл

		Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда

			ТекстСообщения = НСтр("ru = 'Для значения ""%Значение%"" не найден ключ реестра документов. Обратитесь к администратору.';
			|en = 'For the value ""%Значение%"" the document registry key was not found. Please contact the administrator.'");

			Если Ошибки.ЕстьОшибкаПустойКлючКонтрагент Тогда
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Значение%", Ошибки.КонтрагентИзТаблицы);
			КонецЕсли;

			Если Ошибки.ЕстьОшибкаПустойКлючМестоХранения Тогда
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Значение%", Ошибки.МестоХраненияИзТаблицы);
			КонецЕсли;

			ВызватьИсключение ТекстСообщения;
		Иначе

			Если Ошибки.ЕстьОшибкаПустойКлючКонтрагент Тогда
				Справочники.КлючиРеестраДокументов.СоздатьОбновитьКлючиРеестра(,Ошибки.КонтрагентИзТаблицы);
			КонецЕсли;

			Если Ошибки.ЕстьОшибкаПустойКлючМестоХранения Тогда
				Справочники.КлючиРеестраДокументов.СоздатьОбновитьКлючиРеестра(,Ошибки.МестоХраненияИзТаблицы);
			КонецЕсли;

		КонецЕсли;
	КонецЦикла;

	Если Ошибки.Количество() > 0 Тогда
		РезультатыЗапроса = Запрос.ВыполнитьПакетСПромежуточнымиДанными();
	КонецЕсли;

	ЭтотОбъект.Загрузить(РезультатыЗапроса[1].Выгрузить());

КонецПроцедуры
