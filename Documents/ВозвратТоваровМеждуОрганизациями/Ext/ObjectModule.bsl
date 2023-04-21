﻿
&ИзменениеИКонтроль("ЗаполнитьВидыЗапасов")
Процедура РСК_ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтрокиПоТоварамКОформлению = Товары.НайтиСтроки(Новый Структура("ПоТоварамКОформлению", Истина));
	ЕстьПоТоварамКОформлению = СтрокиПоТоварамКОформлению.Количество() > 0;
	ЕстьПоРезервам           = СтрокиПоТоварамКОформлению.Количество() <> Товары.Количество();
	ВидыЗапасовПерезаполнены = Ложь;
	
	Если ЕстьПоРезервам Тогда
		
		МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента(Ложь);
		ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
			
			ПроверитьКорректностьВозвращаемыхТоваров(Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
			ВидыЗапасовПерезаполнены = Истина;
			
			Если ЕстьПоТоварамКОформлению Тогда
				ВидыЗапасовПоКОформлению = ВидыЗапасов.Выгрузить(Новый Структура("ПоТоварамКОформлению", Истина));
				
				ВидыЗапасов.Очистить();
			КонецЕсли;
			
			ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов("Организация", Ложь);
			ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь; 
			#Удаление
			ПараметрыЗаполнения.ИмяТаблицыОстатков = "ПереданныеМеждуОрганизациямиТовары";
			#КонецУдаления
			#Вставка
			//++РС Консалт: Минаков А.С. Задача 24557
			МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхБезДокументаПередачи(Ложь);
			ТЗТовары = Товары.Выгрузить();
			ТЗТовары.Колонки.Добавить("ВидЗапасов");
			
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, ТЗТовары);
			
			ПараметрыЗаполнения.ПриПодбореПоИнтеркампаниИсключатьОрганизации = ОрганизацияПолучатель;
			ПараметрыЗаполнения.НалогообложениеНДС = НалогообложениеНДС;
			ПараметрыЗаполнения.КорВидыЗапасов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТЗТовары.ВыгрузитьКолонку("ВидЗапасов"));
			//++РС Консалт: Минаков А.С. Задача 24557
			#КонецВставки
			
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																	МенеджерВременныхТаблиц,
																	Отказ,
																	ПараметрыЗаполнения);
			
			ЗаполнитьДопКолонкиВидовЗапасов(Ложь);
			
			Для Каждого Строка Из ВидыЗапасов Цикл
				Если ЗначениеЗаполнено(Строка.ВидЗапасовОтгрузки) Тогда
					Строка.ВидЗапасовПолучателя	= Строка.ВидЗапасовОтгрузки;
					Строка.ВидЗапасовОтгрузки	= Справочники.ВидыЗапасов.ПустаяСсылка();
				КонецЕсли;
			КонецЦикла;
			
			Если ЕстьПоТоварамКОформлению Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПоКОформлению);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьПоТоварамКОформлению Тогда
		
		МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента(Истина);
		ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
			
			ВидыЗапасовПерезаполнены = Истина;
			
			ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
			ПараметрыЗаполнения.ДоступныеВидыЗапасовУжеСформированы = Истина;
			ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь;
			ПараметрыЗаполнения.ИмяТаблицыОстатков = "ТоварыОрганизацийКВозврату";
			
			ВтДоступныеВидыЗапасовПоТоварамКПередаче(МенеджерВременныхТаблиц);
			
			Если ЕстьПоРезервам Тогда
				ВидыЗапасовНеПоКОформлению = ВидыЗапасов.Выгрузить(Новый Структура("ПоТоварамКОформлению", Ложь));
				
				ВидыЗапасов.Очистить();
			КонецЕсли;
			
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект,
																	МенеджерВременныхТаблиц,
																	Отказ,
																	ПараметрыЗаполнения);
			
			Для Каждого СтрТабл Из ВидыЗапасов Цикл
				СтрТабл.ПоТоварамКОформлению = Истина;
			КонецЦикла;
			
			ЗаполнитьДопКолонкиВидовЗапасов(Истина);
			
			Если ЕстьПоРезервам Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовНеПоКОформлению);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ВидыЗапасовПерезаполнены
		И ВидыЗапасов.Найти(Справочники.ВидыЗапасов.ПустаяСсылка(), "ВидЗапасовПолучателя") <> Неопределено Тогда
		
		ТекстИсключения = "ru = 'Не заполнены дополнительные колонки в табличной части ""Виды запасов"".'";
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанныхБезДокументаПередачи(ПоТоварамКОформлению)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	// ТаблицаДанныхДокумента - Реквизиты объекта
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперацияВозврата,
	|	&ХозяйственнаяОперацияПередачи КАК ХозяйственнаяОперацияПередачи,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	&ОрганизацияПолучатель КАК ОрганизацияПолучатель,
	|	&РасчетыЧерезОтдельногоКонтрагента КАК РасчетыЧерезОтдельногоКонтрагента,
	|	&Партнер КАК Партнер,
	|	&ДокументПередачи КАК ДокументПередачи,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&Контрагент КАК Контрагент,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|/////////////////////////////////////////////////////
	// ВтВидыЗапасов - Табчасть ВидыЗапасов
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	ТаблицаВидыЗапасов.ДокументПередачи КАК ДокументПередачи,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|//////////////////////////////////////////////////////
	// ТаблицаВидыЗапасов - Табчасть ВидыЗапасов
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументПередачи КАК ДокументПередачи,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|/////////////////////////////////////////////////////
	// ТаблицаТоваров - Табчасть Товары
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаТоваров.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД,
	//++РС Консалт: Минаков А.С. Задача 24557
	//|	ТаблицаТоваров.ДокументПередачи КАК ДокументПередачи,
	//++РС Консалт: Минаков А.С. Задача 24557
	|	ТаблицаТоваров.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ПоТоварамКОформлению = &ПоТоварамКОформлению
	|;
	|////////////////////////////////////////////////////////////////////////////////
	//++РС Консалт: Минаков А.С. Задача 24557
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка) КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	РеквизитыВидаЗапасов.Организация КАК Организация,
	|	РеквизитыВидаЗапасов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА СправочникНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
	|		ИНАЧЕ РеквизитыВидаЗапасов.ТипЗапасов
	|	КОНЕЦ КАК ТипЗапасов,
	|	РеквизитыВидаЗапасов.ВладелецТовара КАК ВладелецТовара,
	|	РеквизитыВидаЗапасов.Соглашение КАК Соглашение,
	|	РеквизитыВидаЗапасов.Контрагент КАК Контрагент,
	|	РеквизитыВидаЗапасов.Договор КАК Договор,
	|	РеквизитыВидаЗапасов.Валюта КАК Валюта,
	|	РеквизитыВидаЗапасов.НалогообложениеНДС КАК НалогообложениеНДС,
	|	РеквизитыВидаЗапасов.НалогообложениеОрганизации КАК НалогообложениеОрганизации,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТоваров.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			&ОрганизацияПолучатель КАК Организация,
	|			&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|			ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|			НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|			ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|			НЕОПРЕДЕЛЕНО КАК Контрагент,
	|			НЕОПРЕДЕЛЕНО КАК Договор,
	|			ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|			&ПередачаПодДеятельность КАК НалогообложениеНДС,
	|			&НалогообложениеОрганизации КАК НалогообложениеОрганизации
	|		ГДЕ
	|			&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями)
	|			И НЕ &ПоТоварамКОформлению
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			&ОрганизацияПолучатель,
	|			&ХозяйственнаяОперация,
	|			ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар),
	|			&Организация,
	|			ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка),
	|			&Организация,
	|			&Договор,
	|			&ВалютаВзаиморасчетов,
	|			&НалогообложениеНДС,
	|			&НалогообложениеОрганизации
	|		ГДЕ
	|			&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями)
	|			И НЕ &ПоТоварамКОформлению) КАК РеквизитыВидаЗапасов
	|		ПО (ИСТИНА)
	|ГДЕ
	|	(НЕ &ПоТоварамКОформлению
	|			ИЛИ &ПерезаполнитьВидыЗапасов)"; 
	//++РС Консалт: Минаков А.С. Задача 24557
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);				
						
	//++РС Консалт: Минаков А.С. Задача 24557					
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);

	рВалютаВзаиморасчетов = Договор.ВалютаВзаиморасчетов;
	Если Не ЗначениеЗаполнено(рВалютаВзаиморасчетов) Тогда
		рВалютаВзаиморасчетов = Валюта;
	КонецЕсли;
	
	рПередачаПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка();
	ПараметрыЗаполнения = Документы.ПередачаТоваровМеждуОрганизациями.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(рПередачаПодДеятельность, ПараметрыЗаполнения);
	
	Запрос.УстановитьПараметр("Договор",					Договор);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации",	ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов",		рВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("ПередачаПодДеятельность",	рПередачаПодДеятельность);
	
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	//++РС Консалт: Минаков А.С. Задача 24557			
										
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("РасчетыЧерезОтдельногоКонтрагента", РасчетыЧерезОтдельногоКонтрагента);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями Тогда
		Запрос.УстановитьПараметр("ХозяйственнаяОперацияПередачи", Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию);
	Иначе
		Запрос.УстановитьПараметр("ХозяйственнаяОперацияПередачи", Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию);
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов.Выгрузить(Новый Структура("ПоТоварамКОформлению", ПоТоварамКОформлению)));
	Запрос.УстановитьПараметр("ДокументПередачи", ДокументПередачи);
	Запрос.УстановитьПараметр("ПоТоварамКОформлению", ПоТоварамКОформлению);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

//++РС Консалт: Минаков А.С. Контроль нужен для изменения процедуры ВременныеТаблицыДанныхБезДокументаПередачи
&ИзменениеИКонтроль("ВременныеТаблицыДанныхДокумента")
Функция РСК_ВременныеТаблицыДанныхДокумента(ПоТоварамКОформлению)

	Запрос = Новый Запрос;
	Запрос.Текст =
	// ТаблицаДанныхДокумента - Реквизиты объекта
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперацияВозврата,
	|	&ХозяйственнаяОперацияПередачи КАК ХозяйственнаяОперацияПередачи,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	&ОрганизацияПолучатель КАК ОрганизацияПолучатель,
	|	&РасчетыЧерезОтдельногоКонтрагента КАК РасчетыЧерезОтдельногоКонтрагента,
	|	&Партнер КАК Партнер,
	|	&ДокументПередачи КАК ДокументПередачи,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&Контрагент КАК Контрагент,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|/////////////////////////////////////////////////////
	// ВтВидыЗапасов - Табчасть ВидыЗапасов
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	ТаблицаВидыЗапасов.ДокументПередачи КАК ДокументПередачи,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|//////////////////////////////////////////////////////
	// ТаблицаВидыЗапасов - Табчасть ВидыЗапасов
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОтгрузки КАК АналитикаУчетаНоменклатурыОтгрузки,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументПередачи КАК ДокументПередачи,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|/////////////////////////////////////////////////////
	// ТаблицаТоваров - Табчасть Товары
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаТоваров.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	ТаблицаТоваров.ДокументПередачи КАК ДокументПередачи,
	|	ТаблицаТоваров.СпособОпределенияСебестоимости КАК СпособОпределенияСебестоимости
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ПоТоварамКОформлению = &ПоТоварамКОформлению
	|;
	|/////////////////////////////////////////////////////
	|";

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
	И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
	И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
	ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
	Товары);

	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("РасчетыЧерезОтдельногоКонтрагента", РасчетыЧерезОтдельногоКонтрагента);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями Тогда
		Запрос.УстановитьПараметр("ХозяйственнаяОперацияПередачи", Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию);
	Иначе
		Запрос.УстановитьПараметр("ХозяйственнаяОперацияПередачи", Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию);
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов.Выгрузить(Новый Структура("ПоТоварамКОформлению", ПоТоварамКОформлению)));
	Запрос.УстановитьПараметр("ДокументПередачи", ДокументПередачи);
	Запрос.УстановитьПараметр("ПоТоварамКОформлению", ПоТоварамКОформлению);

	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);

	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);

	Запрос.Выполнить();

	Возврат МенеджерВременныхТаблиц;

КонецФункции

&Перед("ОбработкаЗаполнения")
Процедура РСК_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	//++РС Консалт: Минаков А.С. Задача 24557
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ПоляШапки") Тогда
		ПоляШапки = ДанныеЗаполнения.ПоляШапки; 
		
		Дата                  = ПоляШапки.Период;
		Организация           = ПоляШапки.Отправитель;
		ОрганизацияПолучатель = ПоляШапки.Получатель;
		Склад                 = ПоляШапки.МестоХранения;
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями;
		ВидЦены               = ПоляШапки.ВидЦены;
		Договор               = Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка();
		Валюта                = ПоляШапки.Валюта;
		НалогообложениеНДС    = ПоляШапки.НалогообложениеНДС;
		// Контрагент - не берем из полей шапки, т.к. контрагент нужен только для посредника
		
		Если ДанныеЗаполнения.Свойство("ЗаполнятьПоРезервамТоваровОрганизаций") Тогда
			Запрос = Новый Запрос;
			
			Для Каждого КлючЗначение из ПоляШапки Цикл
				Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
			КонецЦикла;
			
			Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПоляШапки.Период));
			Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПоляШапки.Период));
			Запрос.УстановитьПараметр("ОформлятьПередачи", Истина);
			
			Запрос.Текст = ЗапасыСервер.ТекстЗапросаОформленияПоРезервамТоваровОрганизаций(Запрос,"ВыборкаЗаполненияДокумента");
			ТаблицаРезультата = Запрос.Выполнить().Выгрузить();

			ЗапросОстатки = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Товары.Номенклатура КАК Номенклатура,
			|	Товары.Характеристика КАК Характеристика,
			|	Товары.Серия КАК Серия
			|ПОМЕСТИТЬ Товары
			|ИЗ
			|	&Товары КАК Товары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПередачаТоваровМеждуОрганизациямиТовары.Ссылка КАК Ссылка,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Цена КАК Цена,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура КАК Номенклатура,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Характеристика КАК Характеристика,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Серия КАК Серия,
			|	СУММА(ПередачаТоваровМеждуОрганизациямиТовары.Количество) КАК Количество,
			|	ПередачаТоваровМеждуОрганизациями.Дата КАК Дата
			|ПОМЕСТИТЬ ПТМ
			|ИЗ
			|	Документ.ПередачаТоваровМеждуОрганизациями.Товары КАК ПередачаТоваровМеждуОрганизациямиТовары
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаТоваровМеждуОрганизациями КАК ПередачаТоваровМеждуОрганизациями
			|		ПО ПередачаТоваровМеждуОрганизациямиТовары.Ссылка = ПередачаТоваровМеждуОрганизациями.Ссылка
			|ГДЕ
			|	ПередачаТоваровМеждуОрганизациями.Организация = &Организация
			|	И ПередачаТоваровМеждуОрганизациями.ОрганизацияПолучатель = &ОрганизацияПолучатель
			|	И ПередачаТоваровМеждуОрганизациями.Дата <= &Дата
			|	И ПередачаТоваровМеждуОрганизациями.Проведен
			|	И (ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура, ПередачаТоваровМеждуОрганизациямиТовары.Характеристика, ПередачаТоваровМеждуОрганизациямиТовары.Серия) В
			|			(ВЫБРАТЬ
			|				Товары.Номенклатура,
			|				Товары.Характеристика,
			|				Товары.Серия
			|			ИЗ
			|				Товары КАК Товары)
			|
			|СГРУППИРОВАТЬ ПО
			|	ПередачаТоваровМеждуОрганизациямиТовары.Ссылка,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Цена,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Характеристика,
			|	ПередачаТоваровМеждуОрганизациямиТовары.Серия,
			|	ПередачаТоваровМеждуОрганизациями.Дата
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПТМ.Ссылка КАК Ссылка,
			|	ПТМ.Цена КАК Цена,
			|	ПТМ.Номенклатура КАК Номенклатура,
			|	ПТМ.Характеристика КАК Характеристика,
			|	ПТМ.Серия КАК Серия,
			|	ПТМ.Количество КАК Количество,
			|	СУММА(ЕСТЬNULL(ВТМ.Количество, 0)) КАК КоличествоВозврат,
			|	ПТМ.Дата КАК Дата
			|ПОМЕСТИТЬ ВТ
			|ИЗ
			|	ПТМ КАК ПТМ
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровМеждуОрганизациями.Товары КАК ВТМ
			|		ПО (ВТМ.ДокументПередачи = ПТМ.Ссылка)
			|			И (ВТМ.Номенклатура = ПТМ.Номенклатура)
			|			И (ВТМ.Характеристика = ПТМ.Характеристика)
			|			И (ВТМ.Серия = ПТМ.Серия)
			|			И (ВТМ.Цена = ПТМ.Цена)
			|			И (ВТМ.Ссылка <> &Ссылка)
			|			И (ВТМ.Ссылка.Проведен)
			|
			|СГРУППИРОВАТЬ ПО
			|	ПТМ.Ссылка,
			|	ПТМ.Цена,
			|	ПТМ.Номенклатура,
			|	ПТМ.Характеристика,
			|	ПТМ.Серия,
			|	ПТМ.Количество,
			|	ПТМ.Дата
			|
			|ИМЕЮЩИЕ
			|	ПТМ.Количество - СУММА(ЕСТЬNULL(ВТМ.Количество, 0)) > 0
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ.Ссылка КАК Ссылка,
			|	ВТ.Цена КАК Цена,
			|	ВТ.Номенклатура КАК Номенклатура,
			|	ВТ.Характеристика КАК Характеристика,
			|	ВТ.Серия КАК Серия,
			|	ВТ.Количество - ВТ.КоличествоВозврат КАК Количество
			|ИЗ
			|	ВТ КАК ВТ
			|
			|УПОРЯДОЧИТЬ ПО
			|	ВТ.Дата УБЫВ");
			
			ЗапросОстатки.УстановитьПараметр("Организация", ОрганизацияПолучатель);
			ЗапросОстатки.УстановитьПараметр("ОрганизацияПолучатель", Организация);
			ЗапросОстатки.УстановитьПараметр("Дата", КонецДня(Дата));
			ЗапросОстатки.УстановитьПараметр("Ссылка", Ссылка);
			ЗапросОстатки.УстановитьПараметр("Товары", ТаблицаРезультата);
			
			ТаблицаОстатков = ЗапросОстатки.Выполнить().Выгрузить();
			СтруктураПоиска = Новый Структура;
			
			Для Каждого Строка Из ТаблицаРезультата Цикл
				
				Остаток = Строка.Количество;
				
				СтруктураПоиска.Вставить("Номенклатура", Строка.Номенклатура); 
				СтруктураПоиска.Вставить("Характеристика", Строка.Характеристика);
				СтруктураПоиска.Вставить("Серия", Строка.Серия);
				
				СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураПоиска);
				
				Пока Остаток > 0 И СтрокиОстатков.Количество() Цикл
					
					НоваяСтрока = Товары.Добавить();
					
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);

					НоваяСтрока.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПередачи;
					
					СтрокаТЧ = СтрокиОстатков[0];
					
					Списать = Мин(Остаток, СтрокаТЧ.Количество); 
					
					НоваяСтрока.Количество = Списать;
					НоваяСтрока.КоличествоУпаковок = Списать;						
					НоваяСтрока.ДокументПередачи = СтрокаТЧ.Ссылка;
					НоваяСтрока.Цена = СтрокаТЧ.Цена;
					
					СтрокаТЧ.Количество = СтрокаТЧ.Количество - НоваяСтрока.Количество;
					Остаток = Остаток - НоваяСтрока.Количество;
					
					Если СтрокаТЧ.Количество <= 0 Тогда
						ТаблицаОстатков.Удалить(СтрокаТЧ);
						СтрокиОстатков.Удалить(0);
					КонецЕсли
					
				КонецЦикла;
				
				Если Остаток > 0 Тогда
					НоваяСтрока = Товары.Добавить();
					
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
					
					НоваяСтрока.Количество = Остаток;
					НоваяСтрока.КоличествоУпаковок = Остаток;
					НоваяСтрока.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента
				КонецЕсли;
				
			КонецЦикла;	
			
			Для Каждого Строка ИЗ Товары Цикл
				
				Если ЗначениеЗаполнено(Строка.ДокументПередачи) И ЗначениеЗаполнено(Строка.ДокументПередачи.Договор) Тогда
					
					Договор = Строка.ДокументПередачи.Договор;
					Прервать
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли	
	КонецЕсли
	//++РС Консалт: Минаков А.С. Задача 24557
	
КонецПроцедуры
