﻿
&После("ДобавитьКомандыСозданияНаОсновании")
Процедура РСК_ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры)

	//++ РС Консалт: Минаков А.С. Задача 20226	
	Документы.ПриходныйОрдерНаТовары.РСК_ДобавитьКомандуСоздатьНаОснованииРасходныйОрдерНаТовары(КомандыСозданияНаОсновании)	
	//++ РС Консалт: Минаков А.С. Задача 20226
	
КонецПроцедуры

&ИзменениеИКонтроль("ОтразитьРаспределениеЗапасовДвижения")
Процедура РСК_ОтразитьРаспределениеЗапасовДвижения(Запрос, ТекстыЗапроса, Регистры)

	ТекстЗапросаТабЧасть =
	"ВЫБРАТЬ
	|	ТабЧасть.Ссылка          КАК Ссылка,
	|	ТабЧасть.Ссылка.Дата     КАК Период,
	|	ТабЧасть.Номенклатура    КАК Номенклатура,
	|	ТабЧасть.Характеристика  КАК Характеристика,
	|	
	|	ВЫБОР КОГДА ТабЧасть.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|			ТабЧасть.Подразделение
	|		ИНАЧЕ
	|			ТабЧасть.Склад
	|		КОНЕЦ КАК Склад,
	|	
	|	ТабЧасть.Назначение      КАК Назначение,
	|	ТабЧасть.Количество      КАК Количество,
	|	
	|	ВЫБОР КОГДА ТабЧасть.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|					И ТабЧасть.ДатаПоступления >= ТабЧасть.Склад.ДатаНачалаОрдернойСхемыПриПоступлении
	|					И ТабЧасть.Ссылка.ВариантПриемкиТоваров В(
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоНакладным)) ТОГДА
	|						
	|				ТабЧасть.Ссылка.Соглашение
	|				
	|	КОГДА ТабЧасть.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|					И ТабЧасть.ДатаПоступления >= ТабЧасть.Склад.ДатаНачалаОрдернойСхемыПриПоступлении
	|					И ТабЧасть.Ссылка.ВариантПриемкиТоваров В(
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.ПоДоговорамБезЗаказовИНакладных),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.ПоДоговорамПослеЗаказовИлиНакладных),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.ПоДоговорамПослеНакладных)) ТОГДА
	|						
	|				ТабЧасть.Ссылка.Договор
	|			ИНАЧЕ
	|				ТабЧасть.Ссылка
	|		КОНЕЦ КАК Заказ,
	|	
	|	ТабЧасть.ДатаПоступления КАК ДатаПоступления,
	|	
	|	ТабЧасть.Ссылка.Статус В(
	|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.Подтвержден),
	|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.Закрыт)
	|		) КАК ДоступенДляРасхода,
	|	
	|	ЛОЖЬ                     КАК ПоГрафику,
	|	НЕОПРЕДЕЛЕНО             КАК РаспоряжениеВГрафике,
	|	0                        КАК КоличествоВГрафике
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ТабЧасть
	|ГДЕ
	|	ТабЧасть.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.НеСогласован)
	#Вставка
	//++РС Консалт: Минаков А.С.
	|	И ТабЧасть.Статус В (ЗНАЧЕНИЕ(Перечисление.РСК_СтатусыПартийПоставки.ВПроизводстве), ЗНАЧЕНИЕ(Перечисление.РСК_СтатусыПартийПоставки.ВПути), ЗНАЧЕНИЕ(Перечисление.РСК_СтатусыПартийПоставки.Получен), ЗНАЧЕНИЕ(Перечисление.РСК_СтатусыПартийПоставки.ПустаяСсылка))
	//++РС Консалт: Минаков А.С.
	#КонецВставки
	|	И НЕ ТабЧасть.СписатьНаРасходы
	|		И НЕ ТабЧасть.Отменено";

	РаспределениеЗапасовДвижения.ЗапланироватьПриходЗапаса(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаТабЧасть);

КонецПроцедуры

&ИзменениеИКонтроль("ТекстЗапросаРеквизитыДоставки")
Функция РСК_ТекстЗапросаРеквизитыДоставки()

	ТекстЗапросаРаспоряжения =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Ссылка.Договор КАК Договор,
	|	ДанныеДокумента.Склад КАК Склад
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&Ссылки)
	|	И ДанныеДокумента.Ссылка.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.Подтвержден),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.Закрыт))
	|	И НЕ ДанныеДокумента.Отменено
	|	И ДанныеДокумента.Номенклатура.ТипНоменклатуры В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И &ЭтоРаспоряжение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Ссылка.Договор,
	|	ДанныеДокумента.Склад";

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИсточникДанныхДоставки.Номер             КАК Номер,
	|	ИсточникДанныхДоставки.Проведен          КАК Проведен,
	|	ИсточникДанныхДоставки.Ссылка            КАК Ссылка,
	|	ИсточникДанныхДоставки.Дата              КАК Дата,
	|	ИсточникДанныхДоставки.Партнер           КАК ПолучательОтправитель,
	|	ИсточникДанныхДоставки.ПеревозчикПартнер КАК Перевозчик,
	|	ИсточникДанныхДоставки.СпособДоставки    КАК СпособДоставки,
	|	ИсточникДанныхДоставки.ЗонаДоставки      КАК Зона,
	|
	|	ВЫБОР КОГДА ИсточникДанныхДоставки.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи)
	|		ТОГДА ИсточникДанныхДоставки.АдресДоставкиПеревозчика
	|		ИНАЧЕ ИсточникДанныхДоставки.АдресДоставки
	|		КОНЕЦ               КАК Адрес,
	|
	|	ВЫБОР КОГДА ИсточникДанныхДоставки.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи)
	|		ТОГДА ИсточникДанныхДоставки.АдресДоставкиПеревозчикаЗначенияПолей
	|		ИНАЧЕ ИсточникДанныхДоставки.АдресДоставкиЗначенияПолей
	|		КОНЕЦ               КАК АдресЗначенияПолей,
	|
	|	ИсточникДанныхДоставки.ВремяДоставкиС    КАК ВремяС,
	|	ИсточникДанныхДоставки.ВремяДоставкиПо   КАК ВремяПо,
	|	ИсточникДанныхДоставки.ДополнительнаяИнформацияПоДоставке
	|	                        КАК ДополнительнаяИнформация,
	|	Распоряжения.Склад                       КАК Склад,
	|	ИСТИНА КАК ДоставитьПолностью,
	|	ИсточникДанныхДоставки.ОсобыеУсловияПеревозки КАК ОсобыеУсловияПеревозки,
	|	ИсточникДанныхДоставки.ОсобыеУсловияПеревозкиОписание КАК ОсобыеУсловияПеревозкиОписание,
	|	ЛОЖЬ КАК РазбиватьРасходныеОрдераПоРаспоряжениям
	|ИЗ
	|	&ВтРаспоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику КАК ИсточникДанныхДоставки
	|		ПО ИсточникДанныхДоставки.Ссылка = Распоряжения.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорКонтрагента
	|		ПО ДоговорКонтрагента.Ссылка = Распоряжения.Договор
	|
	|ГДЕ
	|	ДоговорКонтрагента.Ссылка ЕСТЬ NULL
	|	ИЛИ НЕ ДоговорКонтрагента.СпособДоставки В (&ИспользуемыеСпособыДоставки)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.Ссылка В (&ДоговораРаспоряженияНаПоступление)
	|			ТОГДА ИсточникДанныхДоставки.Номер
	|		ИНАЧЕ
	|			Распоряжения.Ссылка.Номер
	|	КОНЕЦ                                       КАК Номер,
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.Ссылка В (&ДоговораРаспоряженияНаПоступление)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ
	|			Распоряжения.Ссылка.Проведен
	|	КОНЕЦ                                       КАК Проведен,
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.Ссылка В (&ДоговораРаспоряженияНаПоступление)
	|			ТОГДА ИсточникДанныхДоставки.Ссылка
	|		ИНАЧЕ
	|			Распоряжения.Ссылка
	|	КОНЕЦ                                       КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.Ссылка В (&ДоговораРаспоряженияНаПоступление)
	|			ТОГДА ИсточникДанныхДоставки.Дата
	|		ИНАЧЕ
	|			Распоряжения.Ссылка.Дата
	|	КОНЕЦ                                       КАК Дата,
	|	ИсточникДанныхДоставки.Партнер				КАК ПолучательОтправитель,
	|	ИсточникДанныхДоставки.ПеревозчикПартнер	КАК Перевозчик,
	|	ВЫБОР
	#Удаление
	|		КОГДА ИсточникДанныхДоставки.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчика)
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 22756
	|		КОГДА ИсточникДанныхДоставки.СпособДоставки В (ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчика),ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.РСК_ПеревозчикДоКлиента),ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.РСК_ПеревозчикДоПВЗ))
	#КонецВставки
	|				И НЕ &ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.Самовывоз)
	|		ИНАЧЕ ИсточникДанныхДоставки.СпособДоставки
	|	КОНЕЦ										КАК СпособДоставки,
	|	ИсточникДанныхДоставки.ЗонаДоставки			КАК Зона,
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|			ТОГДА ИсточникДанныхДоставки.АдресДоставкиПеревозчика
	|		ИНАЧЕ ИсточникДанныхДоставки.АдресДоставки
	|	КОНЕЦ										КАК Адрес,
	|	ВЫБОР
	|		КОГДА ИсточникДанныхДоставки.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|			ТОГДА ИсточникДанныхДоставки.АдресДоставкиПеревозчикаЗначенияПолей
	|		ИНАЧЕ ИсточникДанныхДоставки.АдресДоставкиЗначенияПолей
	|	КОНЕЦ										КАК АдресЗначенияПолей,
	|	ИсточникДанныхДоставки.ВремяДоставкиС		КАК ВремяС,
	|	ИсточникДанныхДоставки.ВремяДоставкиПо		КАК ВремяПо,
	|	ИсточникДанныхДоставки.ДополнительнаяИнформацияПоДоставке	КАК ДополнительнаяИнформация,
	|	Распоряжения.Склад							КАК Склад,
	|	ЛОЖЬ										КАК ДоставитьПолностью,
	|	ЛОЖЬ										КАК ОсобыеУсловияПеревозки,
	|	""""										КАК ОсобыеУсловияПеревозкиОписание,
	|	ЛОЖЬ										КАК РазбиватьРасходныеОрдераПоРаспоряжениям
	|ИЗ
	|	&ВтРаспоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ИсточникДанныхДоставки
	|		ПО ИсточникДанныхДоставки.Ссылка = Распоряжения.Договор
	|ГДЕ
	|	ИсточникДанныхДоставки.СпособДоставки В (&ИспользуемыеСпособыДоставки)";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВтРаспоряжения", "(" + ТекстЗапросаРаспоряжения + ")");

	Возврат ТекстЗапроса;

КонецФункции

&ИзменениеИКонтроль("СуммыПоЗаказам")
Функция РСК_СуммыПоЗаказам(СсылкаОбъект)

	Запрос = Новый Запрос;

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	&Ссылка                    КАК Ссылка,
	|	&Дата                      КАК Дата,
	|	&ДатаСогласования          КАК ДатаСогласования,
	|	Товары.СуммаСНДС           КАК Сумма,
	|	Товары.Номенклатура        КАК Номенклатура,
	|	Товары.ДатаОтгрузки        КАК ДатаОтгрузки,
	|	Товары.Отменено            КАК Отменено,
	|	&ВернутьМногооборотнуюТару КАК ВернутьМногооборотнуюТару,
	#Вставка
	//++ РС Консалт: Трофимов Евгений 14.03.2023 Задача 23985
	//e1cib/data/Документ.Задание?ref=b37a5a78714d889647e1e0192b7e7134
	|	Товары.ДатаОтгрузки        КАК ДатаОкончанияПроизводства,
	|	Товары.ДатаЕТА             КАК ДатаПрибытияВПорт,
	//-- КонецЗадачи 23985	
	#КонецВставки
	|	&ТребуетсяЗалогЗаТару      КАК ТребуетсяЗалогЗаТару
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ &Таблица КАК Товары
	|ГДЕ &УсловиеСсылка
	|;
	|ВЫБРАТЬ 
	|	Товары.Ссылка                                    КАК Заказ,
	|	Товары.Дата                                      КАК Дата,
	|	Товары.ДатаСогласования                          КАК ДатаСогласования,
	|	Товары.ДатаОтгрузки                              КАК ДатаОтгрузки,
	#Вставка
	//++ РС Консалт: Трофимов Евгений 14.03.2023 Задача 23985
	//e1cib/data/Документ.Задание?ref=b37a5a78714d889647e1e0192b7e7134
	|	Товары.ДатаОкончанияПроизводства        		 КАК ДатаОкончанияПроизводства,
	|	Товары.ДатаПрибытияВПорт            			 КАК ДатаПрибытияВПорт,
	//-- КонецЗадачи 23985	
	#КонецВставки
	|	СУММА(ВЫБОР
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|					ИЛИ НЕ Товары.ВернутьМногооборотнуюТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ)              КАК СуммаПлатежа,
	|	0                                                КАК СуммаВзаиморасчетов,
	|	СУММА(ВЫБОР 
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				И Товары.ТребуетсяЗалогЗаТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ)         КАК СуммаЗалогаЗаТару,
	|	0                                                КАК СуммаВзаиморасчетовПоТаре
	|ИЗ
	|	ВТТовары КАК Товары
	|ГДЕ
	|	НЕ Товары.Отменено
	|СГРУППИРОВАТЬ ПО
	|	Товары.ДатаОтгрузки,
	#Вставка
	//++ РС Консалт: Трофимов Евгений 14.03.2023 Задача 23985
	//e1cib/data/Документ.Задание?ref=b37a5a78714d889647e1e0192b7e7134
	|	Товары.ДатаОкончанияПроизводства,
	|	Товары.ДатаПрибытияВПорт,
	//-- КонецЗадачи 23985	
	#КонецВставки
	|	Товары.Ссылка,
	|	Товары.Дата,
	|	Товары.ДатаСогласования
	|;";

	Если ТипЗнч(СсылкаОбъект) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", "Документ.ЗаказПоставщику.Товары");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВернутьМногооборотнуюТару", "Товары.Ссылка.ВернутьМногооборотнуюТару");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТребуетсяЗалогЗаТару", "Товары.Ссылка.ТребуетсяЗалогЗаТару");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Дата", "Товары.Ссылка.Дата");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДатаСогласования", "Товары.Ссылка.ДатаСогласования");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСсылка", "Товары.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка",СсылкаОбъект);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСсылка", "ИСТИНА");
		Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", СсылкаОбъект.ВернутьМногооборотнуюТару);
		Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару", СсылкаОбъект.ТребуетсяЗалогЗаТару);
		Запрос.УстановитьПараметр("Дата", СсылкаОбъект.Дата);
		Запрос.УстановитьПараметр("ДатаСогласования", СсылкаОбъект.ДатаСогласования);
		Запрос.УстановитьПараметр("Таблица", СсылкаОбъект.Товары);
		Запрос.УстановитьПараметр("Ссылка",СсылкаОбъект.Ссылка);
	КонецЕсли;

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции
