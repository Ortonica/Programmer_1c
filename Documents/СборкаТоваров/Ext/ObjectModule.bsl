﻿
&ИзменениеИКонтроль("ОбработкаПроверкиЗаполнения")
Процедура РСК_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	ИспользоватьХарактеристики = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ХозяйственныеОперации = Перечисления.ХозяйственныеОперации;
	
	// Проверка количества в шапке.
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "Объект";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);

	// Проверка количества в т.ч. товары.
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);

	// Если сборка - доля стоимости не нужна.
	Если ХозяйственнаяОперация = ХозяйственныеОперации.СборкаТоваров Или Товары.Количество() < 2 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДоляСтоимости");
	КонецЕсли;

	// Если накладная по заказу - то код строки должен быть заполнен.
	Если Не ЗначениеЗаполнено(ЗаказНаСборку) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КодСтроки");
	КонецЕсли;

	// Проверка характеристки в шапке.
	Если Не ИспользоватьХарактеристики Или Не Справочники.Номенклатура.ХарактеристикиИспользуются(Номенклатура) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	КонецЕсли;
		
	ЗапретитьПоступлениеТоваровБезНомеровГТД = ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД");
	ВестиУчетПоГТД = ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(Номенклатура, "ВестиУчетПоГТД").ВестиУчетПоГТД;
	КонтролироватьНомераГТД = ЗапретитьПоступлениеТоваровБезНомеровГТД
		И ((ХозяйственнаяОперация = ХозяйственныеОперации.СборкаТоваров И ВестиУчетПоГТД)
		ИЛИ ХозяйственнаяОперация = ХозяйственныеОперации.РазборкаТоваров И НЕ ВестиУчетПоГТД);
	ПрослеживаемыйКомплект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ПрослеживаемыйТовар");
	Если (ХозяйственнаяОперация = ХозяйственныеОперации.СборкаТоваров) И ЗначениеЗаполнено(НоменклатураОсновногоКомпонента)
		И Не ПрослеживаемыйКомплект Тогда
		ПредставлениеОсновногоКомпонента =
			НоменклатураКлиентСервер.ПредставлениеНоменклатуры(НоменклатураОсновногоКомпонента, ХарактеристикаОсновногоКомпонента);
			
		ОтборТоваров =
			Новый Структура("Номенклатура, Характеристика", НоменклатураОсновногоКомпонента, ХарактеристикаОсновногоКомпонента);
		Если Товары.НайтиСтроки(ОтборТоваров).Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Основной компонент `%НазваниеТовара%` в товарах не найден.
				|Укажите основной компонент из перечня товаров';
				|en = 'Main component ""%НазваниеТовара%"" is not found in the list of goods.
				|Choose a main component from the list of goods'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НазваниеТовара%", ПредставлениеОсновногоКомпонента);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ);
		КонецЕсли;
		
		Если КонтролироватьНомераГТД Тогда
			КомпонентВестиУчетПоГТД =
				ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(НоменклатураОсновногоКомпонента,"ВестиУчетПоГТД").ВестиУчетПоГТД;
			Если Не КомпонентВестиУчетПоГТД Тогда
				ТекстСообщения = НСтр("ru = 'По основному компоненту `%НазваниеТовара%` учет по ГТД не ведется.
					|Укажите основной компонент, по которому ведется учет по ГТД.';
					|en = 'CCD records are kept for main component `%НазваниеТовара%`.
					|Specify a main component that has CCD records.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НазваниеТовара%", ПредставлениеОсновногоКомпонента);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		ПроверятьХарактеристикуКомпонента = 
			ИспользоватьХарактеристики И Не ЗначениеЗаполнено(ХарактеристикаОсновногоКомпонента)
			И Справочники.Номенклатура.ХарактеристикиИспользуются(НоменклатураОсновногоКомпонента);
		Если ПроверятьХарактеристикуКомпонента Тогда
			ПроверяемыеРеквизиты.Добавить("ХарактеристикаОсновногоКомпонента");
		КонецЕсли;
		
	ИначеЕсли (ХозяйственнаяОперация = ХозяйственныеОперации.СборкаТоваров) И КонтролироватьНомераГТД
		И Не ПрослеживаемыйКомплект Тогда
		ТекстСообщения = НСтр("ru = 'Требуется определять страну происхождения и номера ГТД комплекта.
			|Укажите основной компонент, по которому ведется учет по ГТД.';
			|en = 'Country of origin and CCD numbers are required. 
			|Specify a main component that has CCD records.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ);
	
	ИначеЕсли (ХозяйственнаяОперация = ХозяйственныеОперации.РазборкаТоваров) И КонтролироватьНомераГТД Тогда
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	Компоненты.НомерСтроки КАК НомерСтроки,
			|	Компоненты.Номенклатура
			|ПОМЕСТИТЬ Компоненты
			|ИЗ &Компоненты КАК Компоненты;
			|
			|ВЫБРАТЬ
			|	Компоненты.НомерСтроки,
			|	ИСТИНА КАК ВестиУчетПоГТД
			|ИЗ Компоненты КАК Компоненты
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Описания
			|		ПО Описания.Ссылка = Компоненты.Номенклатура
			|ГДЕ Описания.ВестиУчетПоГТД
			|");
		Запрос.УстановитьПараметр("Компоненты", Товары.Выгрузить( , "НомерСтроки, Номенклатура"));
		Выборка = Запрос.Выполнить().Выбрать();
		ТекстСообщения = НСтр("ru = 'Для комплектующей в строке %НомерСтроки% списка ""Товары"" ведется учет по ГТД.
			|Такие позиции недопустимы, если для разбираемого комплекта не ведется учет по ГТД.';
			|en = 'CCD records are kept for the component in line %НомерСтроки% of ""Goods"" list.
			|These items are invalid if the disassembled set has no CCD records.'");
		Пока Выборка.Следующий() Цикл
			ИтоговоеСообщение = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Выборка.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "НомерГТД");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИтоговоеСообщение, , Поле, "Объект", Отказ);
		КонецЦикла;
	КонецЕсли;

	// Проверка характеристик в т.ч. товары.
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	#Вставка
	//++ РС Консалт: Трофимов Евгений 10.01.2023 Задача 22868
	//e1cib/data/Документ.Задание?ref=93940f35db53f78f4911379c78147394
	//РазрешитьСборкуСамуВСебя = РегистрыСведений.реа_ПредопределенныеЗначения.Значение("Разрешить сборку саму в себя", Истина);
	//Если НЕ РазрешитьСборкуСамуВСебя Тогда
	ДатаПереходаНаПроизводствоБезЗаказа = РегистрыСведений.реа_ПредопределенныеЗначения.Значение("Дата перехода на производство без заказа",'2023.03.02');
	Если Дата >= ДатаПереходаНаПроизводствоБезЗаказа Тогда
	//-- КонецЗадачи 22868	
	#КонецВставки
	ОтборТоваров = Новый Структура("Номенклатура, Характеристика", Номенклатура, Характеристика);
	ПредставлениеКомплекта = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(Номенклатура, Характеристика);
	Для Каждого СтрокаТЧ Из Товары.НайтиСтроки(ОтборТоваров) Цикл
		ТекстСообщения = НСтр("ru = 'В строке %НомерСтроки% указан товар ""%НазваниеТовара%"".
			|Один и тот же товар не может являться и комплектом, и комплектующей одновременно.';
			|en = 'You have specified ""%НазваниеТовара%"" in line %НомерСтроки%.
			|The same product cannot be both a set and a component.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НазваниеТовара%", ПредставлениеКомплекта);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаТЧ.НомерСтроки);
	
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "Номенклатура");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "Объект", Отказ);
	КонецЦикла;
	#Вставка
	//++ РС Консалт: Трофимов Евгений 10.01.2023 Задача 22868
	//e1cib/data/Документ.Задание?ref=93940f35db53f78f4911379c78147394
	КонецЕсли;
	//-- КонецЗадачи 22868	
	#КонецВставки
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СборкаТоваров);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ТЧ, Отказ, МассивНепроверяемыхРеквизитов);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.Шапка, Отказ, МассивНепроверяемыхРеквизитов);
		
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СборкаТоваровЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ПараметрыПроверки = УчетНДСУП.ПараметрыПроверкиЗаполненияДокументаПоВидуДеятельностиНДС();
	ПараметрыПроверки.ИмяТабличнойЧасти = "Товары";
	УчетНДСУП.ПроверитьЗаполнениеДокументаПоВидуДеятельностиНДС(ЭтотОбъект, СборкаПодДеятельность, ПараметрыПроверки, Отказ);

КонецПроцедуры
