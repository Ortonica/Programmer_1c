﻿&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
&НаСервере
Процедура ЗаполнитьПартииПоставки()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСК_ПартияПоставкиТовары.Ссылка КАК ПартияПоставки,
		|	РСК_ПартияПоставки.Номер КАК НомерПартии,
		|	РСК_ПартияПоставки.Дата КАК ДатаПартии,
		|	РСК_ПартияПоставкиТовары.КодСтроки КАК КодСтроки,
		|	РСК_ПартияПоставкиТовары.НомерКонтейнера КАК НомерКонтейнера,
		|	ЕСТЬNULL(РСК_ПартияПоставкиКонтейнеры.СтатусКонтейнера, ЗНАЧЕНИЕ(Перечисление.РСК_СтатусыПартийПоставки.ПустаяСсылка)) КАК СтатусКонтейнера
		|ИЗ
		|	Документ.РСК_ПартияПоставки.Товары КАК РСК_ПартияПоставкиТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РСК_ПартияПоставки КАК РСК_ПартияПоставки
		|		ПО РСК_ПартияПоставкиТовары.Ссылка = РСК_ПартияПоставки.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РСК_ПартияПоставки.Контейнеры КАК РСК_ПартияПоставкиКонтейнеры
		|		ПО РСК_ПартияПоставкиТовары.Ссылка = РСК_ПартияПоставкиКонтейнеры.Ссылка
		|			И РСК_ПартияПоставкиТовары.НомерКонтейнера = РСК_ПартияПоставкиКонтейнеры.НомерКонтейнера
		|ГДЕ
		|	РСК_ПартияПоставкиТовары.ЗаказПоставщику = &Ссылка
		|	И НЕ РСК_ПартияПоставки.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураПустыхЗначений = Новый Структура(
		"ПартияПоставки,НомерПартии,ДатаПартии,НомерКонтейнера"
	);
	Для Каждого Стр Из Объект.Товары Цикл
		Выборка.Сбросить();
		
		Если Выборка.НайтиСледующий(Новый Структура("КодСтроки", Стр.КодСтроки)) Тогда
			ЗаполнитьЗначенияСвойств(Стр, Выборка);
			Если НЕ ПустаяСтрока(Выборка.НомерКонтейнера) Тогда
				Стр.Статус = Выборка.СтатусКонтейнера;
			КонецЕсли;
		Иначе
			ЗаполнитьЗначенияСвойств(Стр, СтруктураПустыхЗначений);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьПартииПоставки()

&НаСервере
Процедура РСК_ПриЧтенииНаСервереПосле(ТекущийОбъект)
	//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
	//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
	УстановитьВидимостьЭлементов();
	ЗаполнитьПартииПоставки();
	//-- КонецЗадачи 18725	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ПриОткрытииПосле(Отказ)
	//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
	//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
	ЗаполнитьПартииПоставки();
	//-- КонецЗадачи 18725	
КонецПроцедуры

&НаСервере
Процедура РСК_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
	//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
	ЗаполнитьПартииПоставки();
	//-- КонецЗадачи 18725	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ТоварыВыборПосле(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
	//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
	ОбработкаВыбораКолонокПартииПоставки(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	//-- КонецЗадачи 18725
	
	//++ РС Консалт: Трофимов Евгений 09.01.2023 Тикет 22629
	//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
	ОбработкаВыбораКолонокДатОтгрузкиПоступления(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);                  
	//-- КонецТикета 22629	
	
КонецПроцедуры

&НаКлиенте
//++ РС Консалт: Трофимов Евгений 11.07.2022 Задача 18725
//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
Процедура ОбработкаВыбораКолонокПартииПоставки(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	КолонкиПартии = Новый Массив;
	КолонкиПартии.Добавить("ТоварыНомерПартии");
	КолонкиПартии.Добавить("ТоварыДатаПартии");
	КолонкиПартии.Добавить("ТоварыПартияПоставки");
	
	Если КолонкиПартии.Найти(Поле.Имя) <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(ДанныеСтроки.ПартияПоставки) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ДанныеСтроки.ПартияПоставки);
			ФормаПартии = ПолучитьФорму("Документ.РСК_ПартияПоставки.ФормаОбъекта", ПараметрыОткрытия);
			ФормаПартии.Элементы.Страницы.ТекущаяСтраница = ФормаПартии.Элементы.ГруппаТовары;
			ФормаПартии.Открыть();
			Строки = ФормаПартии.Объект.Товары.НайтиСтроки(
				Новый Структура("ЗаказПоставщику,КодСтроки", Объект.Ссылка, ДанныеСтроки.КодСтроки)
			);
			Если Строки.Количество() > 0 Тогда
				ФормаПартии.Элементы.Товары.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
			КонецЕсли;
		Иначе
			//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
			//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
			ДопПарам = Новый Структура();
			ДопПарам.Вставить("КодСтроки", ДанныеСтроки.КодСтроки);
			ДопПарам.Вставить("Поставщик", Объект.Партнер);
			ДопПарам.Вставить("ЗаказПоставщику", Объект.Ссылка);
			ДопПарам.Вставить("ИдентификаторСтроки", ДанныеСтроки.ПолучитьИдентификатор());
			Если Модифицированность Тогда
				ТекстВопроса = СтрШаблон(
					"В документе имеются несохранённые данные. %1 заказ поставщику?",
					?(Объект.Проведен, "Провести", "Записать")
				);
				ПоказатьВопрос(
					Новый ОписаниеОповещения("ПослеВопросаОЗаписиЗаказаПоставщику", ЭтаФорма, ДопПарам), 
					ТекстВопроса, 
					РежимДиалогаВопрос.ДаНет
				);
			Иначе
				ПредложитьСоздатьНовуюПартиюИлиПривязатьСтрокуКСуществующейПартии(ДопПарам);
			КонецЕсли;
			//-- КонецЗадачи 21304			
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры // ОбработкаВыбораКолонокПартииПоставки()

&НаКлиенте
//Не даёт изменять даты в позициях, привязанных к контейнеру.
//++ РС Консалт: Трофимов Евгений 09.01.2023 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
Процедура ОбработкаВыбораКолонокДатОтгрузкиПоступления(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если НЕ ПустаяСтрока(ДанныеСтроки.НомерКонтейнера) Тогда
		Если Поле.Имя = "ТоварыДатаОтгрузки" Тогда
			СтандартнаяОбработка = Ложь;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				"Позиция уже привязана к контейнеру "+ДанныеСтроки.НомерКонтейнера
				+", поэтому дату отгрузки нужно указывать в документе «Партия поставки» в табличной части «Контейнеры» в колонке «Дата загрузки контейнера»"
			);
		ИначеЕсли Поле.Имя = "ТоварыДатаПоступления" Тогда
			СтандартнаяОбработка = Ложь;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				"Позиция уже привязана к контейнеру "+ДанныеСтроки.НомерКонтейнера
				+", поэтому дату поступления нужно указывать в документе «Партия поставки» в табличной части «Контейнеры» в колонке «Дата поступления на склад»"
			);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ОбработкаВыбораКолонокДатОтгрузкиПоступления()


//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
&НаКлиенте
Процедура ПослеВопросаОЗаписиЗаказаПоставщику(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Проведен Тогда
		ПараметрыЗаписи = Новый Структура(
			"РежимЗаписи,РежимПроведения",
			РежимЗаписиДокумента.Проведение,
			РежимПроведенияДокумента.Неоперативный
		);
	Иначе
		ПараметрыЗаписи = Новый Структура(
			"РежимЗаписи",
			РежимЗаписиДокумента.Запись
		);
	КонецЕсли;
	
	Записать(ПараметрыЗаписи);
	Модифицированность = Ложь;
	ПредложитьСоздатьНовуюПартиюИлиПривязатьСтрокуКСуществующейПартии(ДополнительныеПараметры);
	
КонецПроцедуры

// Предложить создать новую партию или привязать строку к существующей партии поставки.
//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
//
&НаКлиенте
Процедура ПредложитьСоздатьНовуюПартиюИлиПривязатьСтрокуКСуществующейПартии(ДополнительныеПараметры)
	
	ОткрытьФорму(
		"Документ.РСК_ПартияПоставки.Форма.ВыборПартииДляВключенияЗаказаВСостав",
		ДополнительныеПараметры,
		ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ПослеВключенияВПартию", ЭтаФорма, ДополнительныеПараметры), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
&НаКлиенте
Процедура ПослеВключенияВПартию(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ДанныеСтроки = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		ДанныеСтроки.ПартияПоставки = Результат.ПартияПоставки;
		ДанныеСтроки.НомерПартии = Результат.НомерПартии;
		ДанныеСтроки.ДатаПартии = Результат.ДатаПартии;
	КонецЕсли;

КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
&НаКлиенте
Процедура РСК_ОбработкаОповещенияПосле(ИмяСобытия, Параметр, Источник)
	//++ РС Консалт: Трофимов Евгений 24.10.2022 Задача 21304
	//e1cib/data/Документ.Задание?ref=95ba1fec1efd0de4442f386a0a00044a
	Если ИмяСобытия = "ПослеЗаписиПартииПоставки" Тогда
		ЗаполнитьПартииПоставки();
	КонецЕсли;
	//-- КонецЗадачи 21304			
КонецПроцедуры

#Область Проформы_ТрофимовЕВ_13_07_2022_ПартияПоставки18725

&НаКлиенте
Процедура РСК_РСК_ПроформыПриОкончанииРедактированияПосле(Элемент, НоваяСтрока, ОтменаРедактирования)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура РСК_РСК_ПроформыПослеУдаленияПосле(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()

	//Проформы
	ВыборПроформыВТабличнойЧасти = Объект.РСК_Проформы.Количество() > 1;
	Элементы.ТоварыНомерПроформы.Видимость = ВыборПроформыВТабличнойЧасти;
	Элементы.ТоварыДатаПроформы.Видимость = ВыборПроформыВТабличнойЧасти;
	Элементы.ТоварыЗаполнитьНомерИДатуПроформы.Видимость = ВыборПроформыВТабличнойЧасти;
	
	//Команды заполнения
	Элементы.ТоварыЗаполнитьДатуОтгрузки.Видимость = НЕ Объект.ПоступлениеОднойДатой;
	Элементы.ТоварыЗаполнитьДатуПоступления.Видимость = НЕ Объект.ПоступлениеОднойДатой И Объект.ДлительностьДоставки > 0;

КонецПроцедуры // УстановитьВидимостьПроформ()

&НаКлиенте
Процедура РСК_ЗаполнитьНомерИДатуПроформыПосле(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресХраненияПроформ", ПолучитьАдресХраненияПроформ());
	
	ОткрытьФорму(
		"Документ.ЗаказПоставщику.Форма.ВыборПроформы", 
		ПараметрыФормы, 
		ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ПослеВыбораПроформы", ЭтаФорма), 
	);
КонецПроцедуры

&НаКлиенте
Процедура РСК_ТоварыНомерПроформыНачалоВыбораПосле(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.Товары.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номер", ДанныеСтроки.НомерПроформы);
	ПараметрыФормы.Вставить("Дата", ДанныеСтроки.ДатаПроформы);
	ПараметрыФормы.Вставить("АдресХраненияПроформ", ПолучитьАдресХраненияПроформ());
	
	ОткрытьФорму(
		"Документ.ЗаказПоставщику.Форма.ВыборПроформы", 
		ПараметрыФормы, 
		ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ПослеВыбораПроформы", ЭтаФорма), 
	);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХраненияПроформ()

	Возврат ПоместитьВоВременноеХранилище(Объект.РСК_Проформы.Выгрузить(), УникальныйИдентификатор);	

КонецФункции // ПолучитьАдресХраненияПроформ()

//++ РС Консалт: Трофимов Евгений 12.07.2022 Задача 18725
//e1cib/data/Документ.Задание?ref=82a4670c1ac44f3949c1b038bf806fda
&НаКлиенте
Процедура ПослеВыбораПроформы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		ДанныеСтроки.НомерПроформы = Результат.Номер;
		ДанныеСтроки.ДатаПроформы = Результат.Дата;
		Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

//++ РС Консалт: Трофимов Евгений 29.10.2022 Задача 21486
//e1cib/data/Документ.Задание?ref=98069037b5c9860445d876207616cfcb
&НаКлиенте
Процедура РСК_ТоварыСтатусНачалоВыбораПосле(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТД = Элементы.Товары.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТД.НомерКонтейнера) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,"Товарная позиция заказа уже привязана к контейнеру "+ТД.НомерКонтейнера+".
		|Для смены статуса используйте документ «Партия поставки» вкладку «Контейнеры».");
	КонецЕсли;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 29.10.2022 Задача 21486
//e1cib/data/Документ.Задание?ref=98069037b5c9860445d876207616cfcb
&НаКлиенте
Процедура РСК_ЗаполнитьСтатусПосле(Команда)
	ТекущееЗначение = ПредопределенноеЗначение("Перечисление.РСК_СтатусыПартийПоставки.НаСогласовании");
	ТД = Элементы.Товары.ТекущиеДанные;
	Если ТД <> Неопределено И ЗначениеЗаполнено(ТД.Статус) Тогда
		ТекущееЗначение = ТД.Статус;
	КонецЕсли;
	ПоказатьВводЗначения(
		Новый ОписаниеОповещения("ПослеВыбораСтатуса", ЭтаФорма), 
		ТекущееЗначение,
		"Статус",
		Тип("ПеречислениеСсылка.РСК_СтатусыПартийПоставки")
	);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 29.10.2022 Задача 21486
//e1cib/data/Документ.Задание?ref=98069037b5c9860445d876207616cfcb
&НаКлиенте
Процедура ПослеВыбораСтатуса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		Если ПустаяСтрока(ДанныеСтроки.НомерКонтейнера) Тогда
			ДанныеСтроки.Статус = Результат;
			Модифицированность = Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					"Позиция [%1] пропущена так как уже прикреплена к контейнеру %2. Изменять статус нужно во вкладке «Контейнеры» документа «Партия поставки» в колонке «Статус контейнера».",
					ДанныеСтроки.НомерСтроки,
					ДанныеСтроки.НомерКонтейнера
				)
			);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 26.12.2022 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
&НаКлиенте
Процедура РСК_ЗаполнитьДатуОтгрузкиПосле(Команда)
	ТекущееЗначение = '0001.01.01';
	ТД = Элементы.Товары.ТекущиеДанные;
	Если ТД <> Неопределено И ЗначениеЗаполнено(ТД.ДатаОтгрузки) Тогда
		ТекущееЗначение = ТД.ДатаОтгрузки;
	КонецЕсли;
	ПоказатьВводДаты(Новый ОписаниеОповещения("ПослеВводаДатыОтгрузки", ЭтаФорма), ТекущееЗначение,"Дата отгрузки",ЧастиДаты.Дата);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 26.12.2022 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
&НаКлиенте
Процедура ПослеВводаДатыОтгрузки(Дата, ДополнительныеПараметры) Экспорт
	
	Если Дата = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		Если ПустаяСтрока(ДанныеСтроки.НомерКонтейнера) Тогда
			ДанныеСтроки.ДатаОтгрузки = Дата;
			Модифицированность = Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					"Позиция [%1] пропущена так как уже прикреплена к контейнеру %2. Изменять дату отгрузки нужно во вкладке «Контейнеры» документа «Партия поставки» в колонке «Дата загрузки контейнера».",
					ДанныеСтроки.НомерСтроки,
					ДанныеСтроки.НомерКонтейнера
				)
			);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 27.12.2022 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
&НаКлиенте
Процедура РСК_ПоступлениеОднойДатойПриИзмененииПосле(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 27.12.2022 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
&НаКлиенте
Процедура РСК_ЗаполнитьДатуПоступленияПосле(Команда)
	ТекущееЗначение = '0001.01.01';
	ТД = Элементы.Товары.ТекущиеДанные;
	Если ТД <> Неопределено И ЗначениеЗаполнено(ТД.ДатаПоступления) Тогда
		ТекущееЗначение = ТД.ДатаПоступления;
	КонецЕсли;
	ПоказатьВводДаты(Новый ОписаниеОповещения("ПослеВводаДатыПоступления", ЭтаФорма), ТекущееЗначение,"Дата поступления",ЧастиДаты.Дата);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 27.12.2022 Тикет 22629
//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
&НаКлиенте
Процедура ПослеВводаДатыПоступления(Дата, ДополнительныеПараметры) Экспорт
	
	Если Дата = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		Если ПустаяСтрока(ДанныеСтроки.НомерКонтейнера) Тогда
			ДанныеСтроки.ДатаПоступления = Дата;
			Модифицированность = Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					"Позиция [%1] пропущена так как уже прикреплена к контейнеру %2. Изменять дату поступления нужно во вкладке «Контейнеры» документа «Партия поставки» в колонке «Дата поступления на склад».",
					ДанныеСтроки.НомерСтроки,
					ДанныеСтроки.НомерКонтейнера
				)
			);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ДлительностьДоставкиПриИзмененииСервер")
Процедура РСК_ДлительностьДоставкиПриИзмененииСервер()
	Если НЕ Объект.ПоступлениеОднойДатой Тогда
		Для Каждого Стр Из Объект.Товары Цикл
			#Удаление
			Если ЗначениеЗаполнено(Стр.ДатаОтгрузки) Тогда
				Стр.ДатаПоступления = Стр.ДатаОтгрузки + Объект.ДлительностьДоставки * 86400;
			КонецЕсли;
			#КонецУдаления
			#Вставка
			//++ РС Консалт: Трофимов Евгений 27.12.2022 Тикет 22629
			//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
			//При изменении длительности доставки в заказе поставщику не менять даты в позициях, привязанных к контейнеру
			Если ЗначениеЗаполнено(Стр.ДатаОтгрузки) И ПустаяСтрока(Стр.НомерКонтейнера) Тогда
				Стр.ДатаПоступления = Стр.ДатаОтгрузки + Объект.ДлительностьДоставки * 86400;
			КонецЕсли;
			//-- КонецТикета 22629			
			#КонецВставки
		КонецЦикла;
	Иначе
		Если ЗначениеЗаполнено(Объект.ДатаОтгрузки) Тогда
			Объект.ДатаПоступления = Объект.ДатаОтгрузки + Объект.ДлительностьДоставки * 86400;
		КонецЕсли;
		ЗаполнитьДатыПоступленияСервер(Объект.ДатаПоступления);
	КонецЕсли;

	УстановитьВидимостьЭлементовФормыДатПоступления();
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ПоступлениеОднойДатойПриИзмененииСервер")
Процедура РСК_ПоступлениеОднойДатойПриИзмененииСервер()
	#Вставка
	//++ РС Консалт: Трофимов Евгений 27.12.2022 Тикет 22629
	//e1cib/data/Документ.Задание?ref=9e439c07dd47beac4ed73427e39f11fb
	//Не давать устанавливать флажок «Отгрузка одной датой», если даты стали разными после прикрепления позиций к контейнеру.
	Если Объект.ПоступлениеОднойДатой Тогда
		ЕстьКонтейнеры = Ложь;
		Для Каждого Стр Из Объект.Товары Цикл
			Если НЕ ПустаяСтрока(Стр.НомерКонтейнера) Тогда
				ЕстьКонтейнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьКонтейнеры Тогда
			МассивДатОтгрузки = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Товары, "ДатаОтгрузки", Истина);
			МассивДатПоступления = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Товары, "ДатаПоступления", Истина);
			Если МассивДатОтгрузки.Количество() > 1 ИЛИ МассивДатПоступления.Количество() > 1 Тогда
				Объект.ПоступлениеОднойДатой = Ложь;
				ОбщегоНазначения.СообщитьПользователю("Запрещено устанавливать отгрузку одной датой так как уже имеются позиции, привязанные к контейнеру и при этом даты отгрузки/поступления в строках табличной части «Товары» стали разными.");
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	//-- КонецТикета 22629	
	#КонецВставки

	Если Объект.ПоступлениеОднойДатой Тогда

		Объект.ДатаОтгрузки = МаксимальнаяДатаОтгрузки();
		Объект.ДатаПоступления = Объект.ДатаОтгрузки + 86400 * Объект.ДлительностьДоставки;
		ЗаполнитьДатыПоступленияСервер(Объект.ДатаПоступления);
		ЗаполнитьДатыОтгрузкиСервер(Объект.ДатаОтгрузки);
		ВзаиморасчетыСервер.ФормаПриИзмененииРеквизитов(ЭтаФорма, "Товары.ДатаОтгрузки");

	КонецЕсли;

	УстановитьВидимостьЭлементовФормыДатПоступления();

КонецПроцедуры


