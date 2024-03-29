﻿  
 &После("ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров")
Процедура РСК_ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента)
	
	//++РС Консалт: Минаков А.С. Задача 17205
	Если (ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ЗаказПоставщику")
		Или ТипЗнч(Распоряжение) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг"))
		И ЗначениеЗаполнено(Распоряжение) Тогда
		
		АналитикаНакладной = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Распоряжение, "Склад")
	Иначе
		АналитикаНакладной = Склад
	КонецЕсли;
	
    Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ПоступлениеТоваровНаСклад.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	ОсновнаяХозОперация = ЗакупкиСервер.ОсновнаяХозяйственнаяОперацияРаздельнойЗакупки(ХозяйственнаяОперация);
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ОсновнаяХозОперация,
																		АналитикаНакладной,
																		Подразделение,
																		Партнер,
																		Договор);
		
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.СтатусУказанияСерий = "СтатусУказанияСерийТоварыУПартнеров";
	ИменаПолей.АналитикаУчетаНоменклатуры = "АналитикаУчетаНоменклатурыНакладной";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей)
	//++РС Консалт: Минаков А.С. Задача 17205
	
КонецПроцедуры
 
&ИзменениеИКонтроль("ЗаполнитьВидыЗапасов")
Процедура РСК_ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблицТоварыСобственные		= ВременныеТаблицыДанныхДокумента(Ложь);
	ПерезаполнитьВидыЗапасов	= ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблицТоварыСобственные, Товары);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента(Истина);
	
	ВидыЗапасовПерезаполнены = Ложь;
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблицТоварыСобственные)
		Или ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
		
		// разрешаем списывать остатки по пустым номерам ГТД.
		ДополнительныеСвойства.Вставить("КонтролироватьНомераГТД", Ложь);
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, СтавкаНДС, НомерГТД",
							"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
		
		ВидыЗапасовПерезаполнены = Истина;
		
	КонецЕсли;
	
	Если ВидыЗапасовПерезаполнены Тогда
		ЗаполнитьНоменклатуруТоварыУПартнеров();
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСПоступлениеИзТоваровВПути
			Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуПоступлениеИзТоваровВПути
			Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаПоступлениеИзТоваровВПути Тогда
			ЗаполнитьНомераГТД();
		КонецЕсли;
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыТоварыУПартнеров,
		#Вставка
		//++РС Консалт: Минаков А.С. Задача 17205
		|АналитикаУчетаНоменклатурыНакладной, НомерГТДНакладной,
		//++РС Консалт: Минаков А.С. Задача 17205
		#КонецВставки
		|АналитикаУчетаПартий, ВидЗапасов, НомерГТД, СтавкаНДС, ВидЗапасовНаСкладе",
		"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
		
	КонецЕсли;
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьНоменклатуруТоварыУПартнеров")
Процедура РСК_ЗаполнитьНоменклатуруТоварыУПартнеров()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");

	Для Каждого СтрокаТоваров Из Товары Цикл

		КоличествоТоваров	= СтрокаТоваров.Количество;
		СуммаСНДС			= СтрокаТоваров.СуммаСНДС;
		СуммаНДС			= СтрокаТоваров.СуммаНДС;

		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		СтруктураПоиска.АналитикаУчетаНоменклатуры = СтрокаТоваров.АналитикаУчетаНоменклатурыТоварыУПартнеров;

		НайденныеСтроки = ВидыЗапасов.НайтиСтроки(СтруктураПоиска);

		Для Каждого СтрокаЗапасов Из НайденныеСтроки Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;

			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);

			НоваяСтрока.АналитикаУчетаНоменклатурыТоварыУПартнеров = СтрокаТоваров.АналитикаУчетаНоменклатурыТоварыУПартнеров;
			НоваяСтрока.АналитикаУчетаНоменклатуры = СтрокаТоваров.АналитикаУчетаНоменклатуры;
			#Вставка
			//++РС Консалт: Минаков А.С. Задача 17205
			НоваяСтрока.АналитикаУчетаНоменклатурыНакладной = СтрокаТоваров.АналитикаУчетаНоменклатурыНакладной;
			//++РС Консалт: Минаков А.С. Задача 17205
			#КонецВставки

			НоваяСтрока.ВидЗапасовНаСкладе	= СтрокаТоваров.ВидЗапасов;
			НоваяСтрока.Количество			= Количество;
			НоваяСтрока.КоличествоПоРНПТ	= Количество * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;

			Если КоличествоТоваров <> 0 Тогда
				НоваяСтрока.СуммаСНДС	= Количество * СуммаСНДС / КоличествоТоваров;
				НоваяСтрока.СуммаНДС	= Количество * СуммаНДС / КоличествоТоваров;
			КонецЕсли;

			СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
			СтрокаЗапасов.СуммаСНДС			= СтрокаЗапасов.СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СтрокаЗапасов.СуммаНДС			= СтрокаЗапасов.СуммаНДС - НоваяСтрока.СуммаНДС;

			КоличествоТоваров	= КоличествоТоваров - НоваяСтрока.Количество;
			СуммаСНДС			= СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СуммаНДС			= СуммаНДС - НоваяСтрока.СуммаНДС;

			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	ПараметрыПоиска = Новый Структура("Количество", 0);
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(ПараметрыПоиска);

	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

Процедура ИзвлечьДетальныеПоляИзАналитикиССерией(ТаблицаДанных)
	
	//++РС Консалт: Минаков А.С. Задача 17205
	ОсновнаяАналитика = "Номенклатура, Характеристика, Серия, Назначение";
	
	АналитикиНоменклатуры = ТаблицаДанных.ВыгрузитьКолонку("АналитикаУчетаНоменклатурыНакладной");
	ДетальнаяАналитика = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(АналитикиНоменклатуры, ОсновнаяАналитика);
	
	ТаблицаДанных.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанных.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаДанных.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТаблицаДанных.Колонки.Добавить("Назначение", Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	
	Для Каждого Строка Из ТаблицаДанных Цикл
		КлючЗначение = ДетальнаяАналитика[Строка.АналитикаУчетаНоменклатурыНакладной];
		ЗаполнитьЗначенияСвойств(Строка, КлючЗначение)
	КонецЦикла
	//++РС Консалт: Минаков А.С. Задача 17205
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьНомераГТД")
Процедура РСК_ЗаполнитьНомераГТД()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ИсходнаяТаблица.АналитикаУчетаНоменклатуры КАК Справочник.КлючиАналитикиУчетаНоменклатуры) КАК
	|		АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ИсходнаяТаблица КАК ИсходнаяТаблица
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ИсходнаяТаблица.АналитикаУчетаНоменклатуры КАК Справочник.КлючиАналитикиУчетаНоменклатуры) КАК
	|		АналитикаУчетаНоменклатуры,
	|	ИсходнаяТаблица.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ИсходнаяТаблица.СтатусУказанияСерийТоварыУПартнеров КАК СтатусУказанияСерийТоварыУПартнеров
	|ПОМЕСТИТЬ ВтТаблицаСтатусыУказанияСерий
	|ИЗ
	|	&ДополнительнаяТаблица КАК ИсходнаяТаблица
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	СтатусУказанияСерий,
	|	СтатусУказанияСерийТоварыУПартнеров
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсходнаяТаблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ИсходнаяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаСтатусыУказанияСерий КАК ТаблицаСерий
	|		ПО ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура = ТаблицаСерий.АналитикаУчетаНоменклатуры.Номенклатура
	|ГДЕ
	|	ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|	И ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура.ВестиУчетПоГТД
	|	И ТаблицаСерий.СтатусУказанияСерий = 14
	|	И ТаблицаСерий.СтатусУказанияСерийТоварыУПартнеров = 0
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КлючАналитики.Ссылка КАК АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ВТОтборТоварыОрганизацийУПартнеров
	|ИЗ
	|	ТаблицаВидыЗапасов КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючАналитики
	|		ПО КлючАналитики.Номенклатура = ТаблицаТовары.АналитикаУчетаНоменклатуры.Номенклатура
	|			И КлючАналитики.Характеристика = ТаблицаТовары.АналитикаУчетаНоменклатуры.Характеристика
	|			И КлючАналитики.Назначение = ТаблицаТовары.АналитикаУчетаНоменклатуры.Назначение
	|			И КлючАналитики.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И КлючАналитики.МестоХранения = ТаблицаТовары.АналитикаУчетаНоменклатуры.МестоХранения
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	ДанныеРегистра.НомерГТД КАК НомерГТД,
	|	СУММА(ДанныеРегистра.Количество) КАК Количество,
	|	СУММА(ДанныеРегистра.КоличествоПоРНПТ) КАК КоличествоПоРНПТ
	|ПОМЕСТИТЬ ВтРезультат
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.НомерГТД КАК НомерГТД,
	|		ТоварыОрганизаций.КоличествоОстаток КАК Количество,
	|		ТоварыОрганизаций.КоличествоПоРНПТОстаток КАК КоличествоПоРНПТ
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(, (АналитикаУчетаНоменклатуры) В
	|			(ВЫБРАТЬ
	|				ТаблицаОтбор.АналитикаУчетаНоменклатуры
	|			ИЗ
	|				ВТОтборТоварыОрганизацийУПартнеров КАК ТаблицаОтбор)
	|			И НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)) КАК ТоварыОрганизаций
	|	ГДЕ
	|		(ТоварыОрганизаций.КоличествоОстаток > 0
	|			ИЛИ ТоварыОрганизаций.КоличествоПоРНПТОстаток > 0)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.НомерГТД КАК НомерГТД,
	|		ТоварыОрганизаций.Количество КАК Количество,
	|		ТоварыОрганизаций.КоличествоПоРНПТ КАК КоличествоПоРНПТ
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтборТоварыОрганизацийУПартнеров КАК ТаблицаТовары
	|			ПО ТоварыОрганизаций.АналитикаУчетаНоменклатуры = ТаблицаТовары.АналитикаУчетаНоменклатуры
	|				И ТоварыОрганизаций.Регистратор = &Регистратор
	|				И ТоварыОрганизаций.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				И ТоварыОрганизаций.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|) КАК ДанныеРегистра
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Характеристика,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Назначение,
	|	ДанныеРегистра.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДанныеРегистра.Количество) <> 0
	|	ИЛИ СУММА(ДанныеРегистра.КоличествоПоРНПТ) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	НомерГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Назначение КАК Назначение
	|ИЗ
	|	ВтРезультат КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД,
	|	ТаблицаТовары.Количество КАК КоличествоУчитываяГТД,
	|	ТаблицаТовары.Количество КАК КоличествоУчитываяГТДВторойПроход,
	|	ТаблицаТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТУчитываяГТД
	|ИЗ
	|	ВтРезультат КАК ТаблицаТовары
	|";

	ВидыЗапасовКЗаполнению = ВидыЗапасов.Выгрузить();
	ТоварыССериями = Товары.Выгрузить();

	Запрос = Новый Запрос();

	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ВидыЗапасовКЗаполнению);
	Запрос.УстановитьПараметр("ДополнительнаяТаблица", ТоварыССериями);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);

	Пакет = Запрос.ВыполнитьПакет();
	ВыборкаАналитики = Пакет[5].Выбрать();
	АналитикаСГТДКРаспределению = Пакет[6].Выгрузить();

	ИзвлечьДетальныеПоляИзАналитики(ВидыЗапасовКЗаполнению);

	Пока ВыборкаАналитики.Следующий() Цикл

		Отбор = Новый Структура();
		Отбор.Вставить("Номенклатура", ВыборкаАналитики.Номенклатура);
		Отбор.Вставить("Характеристика", ВыборкаАналитики.Характеристика);
		Отбор.Вставить("Назначение", ВыборкаАналитики.Назначение);

		НайденныеСтроки = АналитикаСГТДКРаспределению.НайтиСтроки(Отбор);
		АналитикиСГТД = АналитикаСГТДКРаспределению.Скопировать(НайденныеСтроки);

		НайденныеСтрокиВидыЗапасов = ВидыЗапасовКЗаполнению.НайтиСтроки(Отбор);
		ВидыЗапасовПоАналитике = ВидыЗапасовКЗаполнению.Скопировать(НайденныеСтрокиВидыЗапасов);
		ВидыЗапасовПоАналитике.ЗаполнитьЗначения(Неопределено, "НомерГТД");

		Ключ = "Номенклатура, Характеристика, Назначение";

		// Распределение количества и заполнение номера ГТД.
		Условие = "ПО [Количество]";
		НакладныеСервер.РаспределитьКоличествоИЗаполнить(АналитикиСГТД, ВидыЗапасовПоАналитике, "КоличествоУчитываяГТД", Ключ, Условие, Ложь, "НомерГТД");

		// Распределение количества по РНПТ.
		Для Каждого СтрокаСГТД Из АналитикиСГТД Цикл
			Отбор = Новый Структура();
			Отбор.Вставить("Номенклатура", СтрокаСГТД.Номенклатура);
			Отбор.Вставить("Характеристика", СтрокаСГТД.Характеристика);
			Отбор.Вставить("Назначение", СтрокаСГТД.Назначение);
			Отбор.Вставить("НомерГТД", СтрокаСГТД.НомерГТД);

			НайденныеСтроки = ВидыЗапасовПоАналитике.НайтиСтроки(Отбор);
			КРаспределению = СтрокаСГТД.КоличествоПоРНПТУчитываяГТД;
			Для Каждого Строка Из НайденныеСтроки Цикл
				Строка.КоличествоПоРНПТ = Окр(КРаспределению * (Строка.КоличествоУчитываяГТД / СтрокаСГТД.КоличествоУчитываяГТДВторойПроход), 5);
			КонецЦикла;
		КонецЦикла;

		Для Каждого Строка Из НайденныеСтрокиВидыЗапасов Цикл
			ВидыЗапасовКЗаполнению.Удалить(Строка);
		КонецЦикла;

		Для Каждого Строка Из ВидыЗапасовПоАналитике Цикл
			Если Строка.КоличествоУчитываяГТД > 0 Тогда
				Строка.Количество = Строка.КоличествоУчитываяГТД;
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ВидыЗапасовПоАналитике, ВидыЗапасовКЗаполнению);

	КонецЦикла;

	ВидыЗапасов.Загрузить(ВидыЗапасовКЗаполнению);
	#Вставка
	//++РС Консалт: Минаков А.С. Задача 17205
	
	Если Склад = Распоряжение.Склад Тогда
		Для Каждого Строка Из ВидыЗапасов Цикл
			Строка.АналитикаУчетаНоменклатурыНакладной = Строка.АналитикаУчетаНоменклатуры;
			Строка.НомерГТДНакладной = Строка.НомерГТД
		КонецЦикла;
		Возврат
	КонецЕсли;	
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ИсходнаяТаблица.АналитикаУчетаНоменклатурыНакладной КАК Справочник.КлючиАналитикиУчетаНоменклатуры) КАК АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ИсходнаяТаблица КАК ИсходнаяТаблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(ИсходнаяТаблица.АналитикаУчетаНоменклатурыНакладной КАК Справочник.КлючиАналитикиУчетаНоменклатуры) КАК АналитикаУчетаНоменклатуры,
	|	ИсходнаяТаблица.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ИсходнаяТаблица.СтатусУказанияСерийТоварыУПартнеров КАК СтатусУказанияСерийТоварыУПартнеров
	|ПОМЕСТИТЬ ВтТаблицаСтатусыУказанияСерий
	|ИЗ
	|	&ДополнительнаяТаблица КАК ИсходнаяТаблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	СтатусУказанияСерий,
	|	СтатусУказанияСерийТоварыУПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсходнаяТаблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ИсходнаяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаСтатусыУказанияСерий КАК ТаблицаСерий
	|		ПО ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура = ТаблицаСерий.АналитикаУчетаНоменклатуры.Номенклатура
	|ГДЕ
	|	ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|	И ИсходнаяТаблица.АналитикаУчетаНоменклатуры.Номенклатура.ВестиУчетПоГТД
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КлючАналитики.Ссылка КАК АналитикаУчетаНоменклатуры
	|ПОМЕСТИТЬ ВТОтборТоварыОрганизацийУПартнеров
	|ИЗ
	|	ТаблицаВидыЗапасов КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючАналитики
	|		ПО (КлючАналитики.Номенклатура = ТаблицаТовары.АналитикаУчетаНоменклатуры.Номенклатура)
	|			И (КлючАналитики.Характеристика = ТаблицаТовары.АналитикаУчетаНоменклатуры.Характеристика)
	|			И (КлючАналитики.Назначение = ТаблицаТовары.АналитикаУчетаНоменклатуры.Назначение)
	|			И (КлючАналитики.Серия = ТаблицаТовары.АналитикаУчетаНоменклатуры.Серия)
	|			И (КлючАналитики.МестоХранения = ТаблицаТовары.АналитикаУчетаНоменклатуры.МестоХранения)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	ДанныеРегистра.НомерГТД КАК НомерГТД,
	|	СУММА(ДанныеРегистра.Количество) КАК Количество,
	|	СУММА(ДанныеРегистра.КоличествоПоРНПТ) КАК КоличествоПоРНПТ
	|ПОМЕСТИТЬ ВтРезультат
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.НомерГТД КАК НомерГТД,
	|		ТоварыОрганизаций.КоличествоОстаток КАК Количество,
	|		ТоварыОрганизаций.КоличествоПоРНПТОстаток КАК КоличествоПоРНПТ
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(
	|				,
	|				АналитикаУчетаНоменклатуры В
	|						(ВЫБРАТЬ
	|							ТаблицаОтбор.АналитикаУчетаНоменклатуры
	|						ИЗ
	|							ВТОтборТоварыОрганизацийУПартнеров КАК ТаблицаОтбор)
	|					И НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)) КАК ТоварыОрганизаций
	|	ГДЕ
	|		(ТоварыОрганизаций.КоличествоОстаток > 0
	|				ИЛИ ТоварыОрганизаций.КоличествоПоРНПТОстаток > 0)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.НомерГТД,
	|		ТоварыОрганизаций.Количество,
	|		ТоварыОрганизаций.КоличествоПоРНПТ
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтборТоварыОрганизацийУПартнеров КАК ТаблицаТовары
	|			ПО ТоварыОрганизаций.АналитикаУчетаНоменклатуры = ТаблицаТовары.АналитикаУчетаНоменклатуры
	|				И (ТоварыОрганизаций.Регистратор = &Регистратор)
	|				И (ТоварыОрганизаций.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход))
	|				И (ТоварыОрганизаций.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка))) КАК ДанныеРегистра
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Характеристика,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Назначение,
	|	ДанныеРегистра.АналитикаУчетаНоменклатуры.Серия,
	|	ДанныеРегистра.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДанныеРегистра.Количество) <> 0
	|		ИЛИ СУММА(ДанныеРегистра.КоличествоПоРНПТ) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Назначение,
	|	НомерГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.Назначение КАК Назначение
	|ИЗ
	|	ВтРезультат КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.НомерГТД КАК НомерГТДНакладной,
	|	ТаблицаТовары.Количество КАК КоличествоУчитываяГТД,
	|	ТаблицаТовары.Количество КАК КоличествоУчитываяГТДВторойПроход,
	|	ТаблицаТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТУчитываяГТД
	|ИЗ
	|	ВтРезультат КАК ТаблицаТовары";
		
	ВидыЗапасовКЗаполнению = ВидыЗапасов.Выгрузить();
	ТоварыССериями = Товары.Выгрузить();
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ВидыЗапасовКЗаполнению);
	Запрос.УстановитьПараметр("ДополнительнаяТаблица", ТоварыССериями);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);

	Пакет = Запрос.ВыполнитьПакет();
	ВыборкаАналитики = Пакет[5].Выбрать();
	АналитикаСГТДКРаспределению = Пакет[6].Выгрузить();
	
	ИзвлечьДетальныеПоляИзАналитикиССерией(ВидыЗапасовКЗаполнению);

	Пока ВыборкаАналитики.Следующий() Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("Номенклатура", ВыборкаАналитики.Номенклатура);
		Отбор.Вставить("Характеристика", ВыборкаАналитики.Характеристика); 
		Отбор.Вставить("Серия", ВыборкаАналитики.Серия);
		Отбор.Вставить("Назначение", ВыборкаАналитики.Назначение);
		
		НайденныеСтроки = АналитикаСГТДКРаспределению.НайтиСтроки(Отбор);
		АналитикиСГТД = АналитикаСГТДКРаспределению.Скопировать(НайденныеСтроки);

		НайденныеСтрокиВидыЗапасов = ВидыЗапасовКЗаполнению.НайтиСтроки(Отбор);
		ВидыЗапасовПоАналитике = ВидыЗапасовКЗаполнению.Скопировать(НайденныеСтрокиВидыЗапасов);
		ВидыЗапасовПоАналитике.ЗаполнитьЗначения(Неопределено, "НомерГТДНакладной");

		Ключ = "Номенклатура, Характеристика, Серия, Назначение";
		
		// Распределение количества и заполнение номера ГТД.
		Условие = "ПО [Количество]";
		НакладныеСервер.РаспределитьКоличествоИЗаполнить(АналитикиСГТД, ВидыЗапасовПоАналитике, "КоличествоУчитываяГТД", Ключ, Условие, Ложь, "НомерГТДНакладной");
		
		// Распределение количества по РНПТ.
		Для Каждого СтрокаСГТД Из АналитикиСГТД Цикл
			Отбор = Новый Структура();
			Отбор.Вставить("Номенклатура", СтрокаСГТД.Номенклатура);
			Отбор.Вставить("Характеристика", СтрокаСГТД.Характеристика);
			Отбор.Вставить("Серия", СтрокаСГТД.Серия);
			Отбор.Вставить("Назначение", СтрокаСГТД.Назначение);
			Отбор.Вставить("НомерГТДНакладной", СтрокаСГТД.НомерГТДНакладной);
			
			НайденныеСтроки = ВидыЗапасовПоАналитике.НайтиСтроки(Отбор);
			КРаспределению = СтрокаСГТД.КоличествоПоРНПТУчитываяГТД;
			Для Каждого Строка Из НайденныеСтроки Цикл
				Строка.КоличествоПоРНПТ = Окр(КРаспределению * (Строка.КоличествоУчитываяГТД / СтрокаСГТД.КоличествоУчитываяГТДВторойПроход), 5);
			КонецЦикла;
		КонецЦикла;
		
		Для Каждого Строка Из НайденныеСтрокиВидыЗапасов Цикл
			ВидыЗапасовКЗаполнению.Удалить(Строка);
		КонецЦикла;
		
		Для Каждого Строка Из ВидыЗапасовПоАналитике Цикл
			Если Строка.КоличествоУчитываяГТД > 0 Тогда
				Строка.Количество = Строка.КоличествоУчитываяГТД;
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ВидыЗапасовПоАналитике, ВидыЗапасовКЗаполнению);
		
	КонецЦикла;
	
	ВидыЗапасов.Загрузить(ВидыЗапасовКЗаполнению)
	//++РС Консалт: Минаков А.С. Задача 17205
	#КонецВставки
КонецПроцедуры




