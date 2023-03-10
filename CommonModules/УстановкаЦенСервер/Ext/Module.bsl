
&ИзменениеИКонтроль("ЗагрузитьСправочникВидовЦенПоставщика")
Функция РСК_ЗагрузитьСправочникВидовЦенПоставщика(Форма)

	КэшДанных = ИнициализироватьСтруктуруКэшаДанных();

	ЗапросРазрешенныеВидыЦен = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка
	|ИЗ
	|	Справочник.ВидыЦенПоставщиков КАК ВидыЦен");

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыЦен.Ссылка КАК Ссылка,
	|	ВидыЦен.Наименование КАК Наименование,
	|	ВидыЦен.ПометкаУдаления КАК ПометкаУдаления,
	|	ВидыЦен.Валюта КАК Валюта,
	|	ВидыЦен.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ВЫБОР
	|		КОГДА НЕ ВидыЦен.Ссылка В (&РазрешенныеВидыЦен)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗапрещенныйВидЦены
	|ИЗ
	|	Справочник.ВидыЦенПоставщиков КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыЦен.РеквизитДопУпорядочивания");
	#Вставка
	//++ РС Консалт: Трофимов Евгений 15.02.2023 Задача 23088
	//e1cib/data/Документ.Задание?ref=abf6db76aafd7de84ef44e63a771c2e5
	//Доработка нужна чтобы в документе РегистрацияЦенНоменклатурыПоставщика можно было указывать Виды цен физ. лиц
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Партнер") Тогда
		Партнер = Форма.Объект.Партнер;
	Иначе
		Партнер = Форма.Партнер;
	КонецЕсли;
	Если ТипЗнч(Партнер) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ЗапросРазрешенныеВидыЦен.Текст = СтрЗаменить(ЗапросРазрешенныеВидыЦен.Текст, "Справочник.ВидыЦенПоставщиков", "Справочник.РСК_ВидыЦенФизЛиц");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.ВидыЦенПоставщиков", "Справочник.РСК_ВидыЦенФизЛиц");
	КонецЕсли;
	//-- КонецЗадачи 23088	
	#КонецВставки

	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Партнер") Тогда
		Запрос.Параметры.Вставить("Владелец", Форма.Объект.Партнер);
	Иначе
		Запрос.Параметры.Вставить("Владелец", Форма.Партнер);
	КонецЕсли;

	Запрос.Параметры.Вставить("РазрешенныеВидыЦен", ЗапросРазрешенныеВидыЦен.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

	УстановитьПривилегированныйРежим(Истина);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить(); // см. ЗагрузитьСправочникВидовЦенПоставщика

	ТаблицаВидовЦен.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка"));
	// Индексирование
	ТаблицаВидовЦен.Индексы.Добавить("Ссылка");

	Для Каждого СтрокаВидаЦен Из ТаблицаВидовЦен Цикл
		СтрокаВидаЦен.ИмяКолонки = ИмяКолонкиПоВидуЦены(СтрокаВидаЦен.Ссылка, КэшДанных);
	КонецЦикла;

	Возврат ТаблицаВидовЦен;

КонецФункции
