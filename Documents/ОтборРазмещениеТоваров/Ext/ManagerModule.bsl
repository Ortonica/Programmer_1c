﻿#Если НЕ МобильныйАвтономныйСервер Тогда
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

&ИзменениеИКонтроль("ПечатьЗадания")
Функция РСК_ПечатьЗадания(МассивОбъектов, ОбъектыПечати)
	
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	УстановитьПривилегированныйРежим(Истина);
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов();
	ИмяКолонкиКодов = КолонкаКодов.ИмяКолонки;
	ПредставлениеКолонкиКодов = КолонкаКодов.ПредставлениеКолонки;
	ВыводитьКоды = ЗначениеЗаполнено(ИмяКолонкиКодов);

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОтборРазмещениеТоваров_ЗаданиеНаОтборРазмещениеТоваров";

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтборРазмещениеТоваров.Ссылка КАК Ссылка,
	|	ОтборРазмещениеТоваров.Дата КАК Дата,
	|	ОтборРазмещениеТоваров.Номер КАК Номер,
	|	ОтборРазмещениеТоваров.ВидОперации КАК ВидОперации,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.ЗонаОтгрузки) КАК ЗонаОтгрузкиПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.ЗонаПриемки) КАК ЗонаПриемкиПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.РабочийУчасток) КАК РабочийУчастокПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.Склад) КАК СкладПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.Помещение) КАК ПомещениеПредставление,
	|	ОтборРазмещениеТоваров.Исполнитель.ФизическоеЛицо КАК Исполнитель,
	|	ОтборРазмещениеТоваров.Распоряжение КАК Распоряжение,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.Распоряжение) КАК РаспоряжениеПредставление,
	|	ОтборРазмещениеТоваров.Распоряжение.Дата КАК РаспоряжениеДата,
	|	ОтборРазмещениеТоваров.Распоряжение.Номер КАК РаспоряжениеНомер,
	|	ЕСТЬNULL(ОтборРазмещениеТоваров.Распоряжение.ОтгрузкаПоЗаданиюНаПеревозку, ЛОЖЬ) КАК ОтгрузкаПоЗаданиюНаПеревозку,
	|	ОтборРазмещениеТоваров.Распоряжение.ПорядокДоставки КАК ПорядокДоставки,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваров.Распоряжение.ЗаданиеНаПеревозку) КАК ЗаданиеНаПеревозкуПредставление,
	|	ОтборРазмещениеТоваров.Распоряжение.ЗаданиеНаПеревозку.Номер КАК ЗаданиеНаПеревозкуНомер,
	|	ОтборРазмещениеТоваров.Распоряжение.ЗаданиеНаПеревозку.Дата КАК ЗаданиеНаПеревозкуДата
	|ИЗ
	|	Документ.ОтборРазмещениеТоваров КАК ОтборРазмещениеТоваров
	|ГДЕ
	|	ОтборРазмещениеТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтборРазмещениеТоваровТоварыОтбор.НомерСтроки КАК НомерСтроки,
	|	0 КАК Метка,
	|	ОтборРазмещениеТоваровТоварыОтбор.КоличествоУпаковок КАК КоличествоПлан,
	|	ОтборРазмещениеТоваровТоварыОтбор.КоличествоУпаковокОтобрано КАК КоличествоФакт,
	#Удаление
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура.Наименование КАК НоменклатураПредставление,
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура КАК Номенклатура,
	|	ОтборРазмещениеТоваровТоварыОтбор.Характеристика КАК Характеристика,
	|	ОтборРазмещениеТоваровТоварыОтбор.Серия КАК Серия,
	|	ОтборРазмещениеТоваровТоварыОтбор.Упаковка КАК Упаковка,
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|	ОтборРазмещениеТоваровТоварыОтбор.Характеристика.НаименованиеПолное КАК ХарактеристикаПредставление,
	|	ОтборРазмещениеТоваровТоварыОтбор.Серия.Наименование КАК СерияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваровТоварыОтбор.Ячейка) КАК ЯчейкаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваровТоварыОтбор.Упаковка) КАК УпаковкаПредставление,
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура.Код КАК Код,
	|	ОтборРазмещениеТоваровТоварыОтбор.Номенклатура.Артикул КАК Артикул,
	|	ОтборРазмещениеТоваровТоварыОтбор.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтборРазмещениеТоваров.ТоварыОтбор КАК ОтборРазмещениеТоваровТоварыОтбор
	|ГДЕ
	|	ОтборРазмещениеТоваровТоварыОтбор.Ссылка В(&МассивОбъектов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтборРазмещениеТоваровТоварыРазмещение.НомерСтроки,
	|	1,
	|	ОтборРазмещениеТоваровТоварыРазмещение.КоличествоУпаковок,
	|	ОтборРазмещениеТоваровТоварыРазмещение.КоличествоУпаковокРазмещено,
	#Удаление
	|	ОтборРазмещениеТоваровТоварыРазмещение.Номенклатура.НаименованиеПолное,
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|	ОтборРазмещениеТоваровТоварыРазмещение.Номенклатура.Наименование,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Номенклатура,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Характеристика,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Серия,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Упаковка КАК Упаковка,
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|	ОтборРазмещениеТоваровТоварыРазмещение.Характеристика.НаименованиеПолное,
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваровТоварыРазмещение.Серия),
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваровТоварыРазмещение.Ячейка),
	|	ПРЕДСТАВЛЕНИЕ(ОтборРазмещениеТоваровТоварыРазмещение.Упаковка),
	|	ОтборРазмещениеТоваровТоварыРазмещение.Номенклатура.Код,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Номенклатура.Артикул,
	|	ОтборРазмещениеТоваровТоварыРазмещение.Ссылка
	|ИЗ
	|	Документ.ОтборРазмещениеТоваров.ТоварыРазмещение КАК ОтборРазмещениеТоваровТоварыРазмещение
	|ГДЕ
	|	ОтборРазмещениеТоваровТоварыРазмещение.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Метка,
	|	НомерСтроки
	#Удаление
	|ИТОГИ ПО
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|ИТОГИ
	|	СУММА(КоличествоПлан),
	|	СУММА(КоличествоФакт)
	|ПО
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтборРазмещениеТоваров.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение) КАК ОснованиеПредставление,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Номер КАК ОснованиеНомер,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Дата КАК ОснованиеДата,
	|	МИНИМУМ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтборРазмещениеТоваров КАК ОтборРазмещениеТоваров
	|		ПО РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка = ОтборРазмещениеТоваров.Распоряжение
	|ГДЕ
	|	ОтборРазмещениеТоваров.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтборРазмещениеТоваров.Ссылка,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Номер,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Дата,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение)
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтборРазмещениеТоваров.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(РеализацияТоваровУслуг.Ссылка, ПеремещениеТоваров.Ссылка)) КАК ОснованиеПредставление,
	|	ЕСТЬNULL(РеализацияТоваровУслуг.Номер, ПеремещениеТоваров.Номер) КАК ОснованиеНомер,
	|	ЕСТЬNULL(РеализацияТоваровУслуг.Дата, ПеремещениеТоваров.Дата) КАК ОснованиеДата,
	|	МИНИМУМ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтборРазмещениеТоваров КАК ОтборРазмещениеТоваров
	|		ПО РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка = ОтборРазмещениеТоваров.Распоряжение
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ПО ВЫБОР 
	|		КОГДА РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение ССЫЛКА Документ.РеализацияТоваровУслуг ТОГДА
	|	    РеализацияТоваровУслуг.Ссылка
	|		КОГДА РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение ССЫЛКА Документ.ЗаказКлиента ТОГДА
	|	    РеализацияТоваровУслуг.ЗаказКлиента ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ = РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение
	|		И НАЧАЛОПЕРИОДА(РеализацияТоваровУслуг.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.ДатаОтгрузки, ДЕНЬ)
	|		И РеализацияТоваровУслуг.Проведен
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|		ПО ВЫБОР 
	|		КОГДА РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение ССЫЛКА Документ.ПеремещениеТоваров ТОГДА
	|	    ПеремещениеТоваров.Ссылка
	|		КОГДА РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение ССЫЛКА Документ.ЗаказНаПеремещение ТОГДА
	|	    ПеремещениеТоваров.ЗаказНаПеремещение ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ = РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение
	|		И НАЧАЛОПЕРИОДА(ПеремещениеТоваров.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.ДатаОтгрузки, ДЕНЬ)
	|		И ПеремещениеТоваров.Проведен
	|ГДЕ
	|	ОтборРазмещениеТоваров.Ссылка В(&МассивОбъектов)
	|  И НЕ ЕСТЬNULL(РеализацияТоваровУслуг.Ссылка, ПеремещениеТоваров.Ссылка) ЕСТЬ NULL
	|СГРУППИРОВАТЬ ПО
	|	ОтборРазмещениеТоваров.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(РеализацияТоваровУслуг.Ссылка, ПеремещениеТоваров.Ссылка)),
	|	ЕСТЬNULL(РеализацияТоваровУслуг.Номер, ПеремещениеТоваров.Номер),
	|	ЕСТЬNULL(РеализацияТоваровУслуг.Дата, ПеремещениеТоваров.Дата)
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	// Нужно напечатать номер и дату накладной, но к накладным может не быть доступа
	УстановитьПривилегированныйРежим(Истина);

	Результаты = Запрос.ВыполнитьПакет();

	УстановитьПривилегированныйРежим(Ложь);

	ВыборкаПоДокументам      = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоРаспоряжениям   = Результаты[2].Выбрать();

	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс, Представление");
	
	#Удаление
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтборРазмещениеТоваров.ПФ_MXL_ЗаданиеНаОтборРазмещениеТоваров");
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтборРазмещениеТоваров.РС_ПФ_MXL_ЗаданиеНаОтборРазмещениеТоваров");
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	ОбластьЗаголовок 		  = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСкладИсполнитель   = Макет.ПолучитьОбласть("СкладИсполнитель");
	ОбластьОснование	 	  = Макет.ПолучитьОбласть("Основание");
	ОбластьРаспоряжение 	  = Макет.ПолучитьОбласть("Распоряжение");
	ОбластьЗаданиеНаПеревозку = Макет.ПолучитьОбласть("ЗаданиеНаПеревозку");
	ОбластьПодзаголовок 	  = Макет.ПолучитьОбласть("Подзаголовок");
	#Вставка
	//++ РС Консалт: Трофимов Евгений 20.01.2023 Задача 23154
	//e1cib/data/Документ.Задание?ref=bcb44edb8528e94044a02d443a51d096
	ОбластьОсобыеОтметки   	  = Макет.ПолучитьОбласть("ОсобыеОтметки");
	//-- КонецЗадачи 23154	
	//++ РС Консалт: Минаков А.С. Задача 20226
	ОбластьИтогиПодвал 	  	  = Макет.ПолучитьОбласть("ИтогиПодвал");
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
	ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
	ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");

	ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
	ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");

	ОбластьШапкаТаблицыКолонкаКодов.Параметры.ИмяКолонкиКодов = ПредставлениеКолонкиКодов; 

	Если НЕ ВыводитьКоды Тогда
		ОбластьКолонкаТоваров = Макет.Область("КолонкаТоваров");

		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки  + Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;	

	ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаТоваров");
	ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаТоваров");
	ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаТоваров");

	ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
	ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
	ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");

	ПервыйДокумент = Истина;

	Пока ВыборкаПоДокументам.Следующий() Цикл

		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;

		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ВыводитьОснование = Ложь;

		Если ВыборкаПоДокументам.ВидОперации = Перечисления.ВидыОперацийОтбораРазмещенияТоваров.Отбор Тогда

			ТекстЗаголовка		 = НСтр("ru = 'Задание на отбор товара';
			|en = 'Picking task'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстЗоны			 = НСтр("ru = 'Зона отгрузки:';
			|en = 'Outbound area:'", ОбщегоНазначения.КодОсновногоЯзыка());
			ЗонаПредставление	 = ВыборкаПоДокументам.ЗонаОтгрузкиПредставление;
			РабочийУчасток		 = ВыборкаПоДокументам.РабочийУчастокПредставление;
			ВыводитьРаспоряжение = Истина;
			ВыводитьОснование    = ТипЗнч(ВыборкаПоДокументам.Распоряжение) = Тип("ДокументСсылка.РасходныйОрдерНаТовары");
			ВыводитьПодзаголовок = Ложь;

		ИначеЕсли ВыборкаПоДокументам.ВидОперации = Перечисления.ВидыОперацийОтбораРазмещенияТоваров.Размещение Тогда

			ТекстЗаголовка = НСтр("ru = 'Задание на размещение товара';
			|en = 'Put-away task'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстЗоны = НСтр("ru = 'Зона приемки:';
			|en = 'Inbound area:'", ОбщегоНазначения.КодОсновногоЯзыка());
			ЗонаПредставление = ВыборкаПоДокументам.ЗонаПриемкиПредставление;
			РабочийУчасток		= ВыборкаПоДокументам.РабочийУчастокПредставление;
			ВыводитьРаспоряжение = Ложь;
			ВыводитьПодзаголовок = Ложь;

		ИначеЕсли ВыборкаПоДокументам.ВидОперации = Перечисления.ВидыОперацийОтбораРазмещенияТоваров.Перемещение Тогда

			ТекстЗаголовка = НСтр("ru = 'Задание на перемещение товара';
			|en = 'Intra-warehouse transfer task'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстЗоны = "";
			ЗонаПредставление = "";
			РабочийУчасток	= "";
			ВыводитьРаспоряжение = Ложь;
			ВыводитьПодзаголовок = Истина;

		КонецЕсли;

		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);

		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, ТекстЗаголовка);

		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок, ВыборкаПоДокументам.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);

		ОбластьСкладИсполнитель.Параметры.ИсполнительПредставление	= ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Исполнитель, ВыборкаПоДокументам.Дата);
		ОбластьСкладИсполнитель.Параметры.СкладПредставление		= СкладыСервер.ПолучитьПредставлениеСклада(ВыборкаПоДокументам.СкладПредставление,ВыборкаПоДокументам.ПомещениеПредставление);
		ОбластьСкладИсполнитель.Параметры.ТекстЗоны 				= ТекстЗоны;
		ОбластьСкладИсполнитель.Параметры.ЗонаПредставление 		= ЗонаПредставление;

		Если ЗначениеЗаполнено(РабочийУчасток) Тогда
			ОбластьСкладИсполнитель.Параметры.ТекстРабочегоУчастка = НСтр("ru = 'Рабочий участок:';
			|en = 'Warehouse area:'", ОбщегоНазначения.КодОсновногоЯзыка());
			ОбластьСкладИсполнитель.Параметры.РабочийУчастокПредставление = РабочийУчасток;			
		Иначе
			ОбластьСкладИсполнитель.Параметры.ТекстРабочегоУчастка = "";
			ОбластьСкладИсполнитель.Параметры.РабочийУчастокПредставление = "";			
		КонецЕсли;
		#Вставка
		//++ РС Консалт: Трофимов Евгений 18.01.2023 Задача 23087
		//e1cib/data/Документ.Задание?ref=a70cc94fd7f4d8874de8888e78f9c280
		ОбластьСкладИсполнитель.Параметры.ДатаОтгрузки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ВыборкаПоДокументам.Ссылка, 
			"Распоряжение.ДатаОтгрузки"
		);
		ДанныеРаспоряжения = ПолучитьДанныеРаспоряжения(ВыборкаПоДокументам.Ссылка);
		ОбластьСкладИсполнитель.Параметры.Заполнить(ДанныеРаспоряжения);
		//-- КонецЗадачи 23087
		#КонецВставки

		ТабличныйДокумент.Вывести(ОбластьСкладИсполнитель);

		Если ВыводитьОснование Тогда

			Счетчик = 0;
			ПредставлениеОснований = "";
			ПервоеРаспоряжение = Истина;
			РеквизитыДокумента = Новый Структура("Дата, Номер, Префикс, Представление");

			Пока ВыборкаПоРаспоряжениям.НайтиСледующий(Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка)) Цикл

				РеквизитыДокумента.Дата          = ВыборкаПоРаспоряжениям.ОснованиеДата;
				РеквизитыДокумента.Номер         = ВыборкаПоРаспоряжениям.ОснованиеНомер;
				РеквизитыДокумента.Префикс       = "";
				РеквизитыДокумента.Представление = ВыборкаПоРаспоряжениям.ОснованиеПредставление;

				ПредставлениеОснования = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента);

				Если Не ПервоеРаспоряжение Тогда
					#Удаление
					ПредставлениеОснований = ПредставлениеОснований + ", ";		
					#КонецУдаления
					#Вставка
					//++ РС Консалт: Трофимов Евгений 20.01.2023 Задача 23154
					//e1cib/data/Документ.Задание?ref=bcb44edb8528e94044a02d443a51d096
					ПредставлениеОснований = ПредставлениеОснований + Символы.ПС;
					//-- КонецЗадачи 23154					
					#КонецВставки
				КонецЕсли;

				ПервоеРаспоряжение = Ложь;

				ПредставлениеОснований = ПредставлениеОснований + ПредставлениеОснования;

				Счетчик = Счетчик + 1;

			КонецЦикла;

			ОснованияЗаголовок = "";
			Если Счетчик > 1 Тогда 
				ОснованияЗаголовок = НСтр("ru = 'Основания:';
				|en = 'Base documents:'", ОбщегоНазначения.КодОсновногоЯзыка());
			Иначе
				ОснованияЗаголовок = НСтр("ru = 'Основание:';
				|en = 'Base document:'", ОбщегоНазначения.КодОсновногоЯзыка());
			КонецЕсли;

			ОбластьОснование.Параметры.ОснованияПредставление = ПредставлениеОснований;
			ОбластьОснование.Параметры.ОснованияЗаголовок = ОснованияЗаголовок;

			ТабличныйДокумент.Вывести(ОбластьОснование);

		КонецЕсли;

		Если ВыводитьРаспоряжение Тогда
			РеквизитыДокумента.Дата          = ВыборкаПоДокументам.РаспоряжениеДата;
			РеквизитыДокумента.Номер         = ВыборкаПоДокументам.РаспоряжениеНомер;
			РеквизитыДокумента.Префикс       = "";
			РеквизитыДокумента.Представление = ВыборкаПоДокументам.РаспоряжениеПредставление;

			ОбластьРаспоряжение.Параметры.РаспоряжениеПредставление	= ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента);
			ТабличныйДокумент.Вывести(ОбластьРаспоряжение);
		КонецЕсли;

		Если ВыборкаПоДокументам.ОтгрузкаПоЗаданиюНаПеревозку Тогда
			РеквизитыДокумента.Дата          = ВыборкаПоДокументам.ЗаданиеНаПеревозкуДата;
			РеквизитыДокумента.Номер         = ВыборкаПоДокументам.ЗаданиеНаПеревозкуНомер;
			РеквизитыДокумента.Префикс       = "";
			РеквизитыДокумента.Представление = ВыборкаПоДокументам.ЗаданиеНаПеревозкуПредставление;

			ОбластьЗаданиеНаПеревозку.Параметры.ЗаданиеНаПеревозкуПредставление	= ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента);
			#Вставка
			//++ РС Консалт: Трофимов Евгений 20.01.2023 Задача 23087
			//e1cib/data/Документ.Задание?ref=a70cc94fd7f4d8874de8888e78f9c280
			Если ПустаяСтрока(РеквизитыДокумента.Номер) Тогда
				ОбластьЗаданиеНаПеревозку.Параметры.ЗаданиеНаПеревозкуПредставление = "Задание на перевозку №________________   от _______________";
			КонецЕсли;
			//-- КонецЗадачи 23087			
			#КонецВставки
			ОбластьЗаданиеНаПеревозку.Параметры.ПорядокДоставки = ВыборкаПоДокументам.ПорядокДоставки;
			ТабличныйДокумент.Вывести(ОбластьЗаданиеНаПеревозку);
		КонецЕсли;

		Метка = Неопределено;

		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл

			Если Метка <> ВыборкаПоСтрокамТЧ.Метка Тогда
				Если ВыводитьПодзаголовок Тогда

					Если ВыборкаПоСтрокамТЧ.Метка = 0 Тогда
						ТекстПозаголовка = НСтр("ru = 'Товары к отбору';
						|en = 'Pick list'", ОбщегоНазначения.КодОсновногоЯзыка());
					Иначе
						ТекстПозаголовка = НСтр("ru = 'Товары к размещению';
						|en = 'Put-away list'", ОбщегоНазначения.КодОсновногоЯзыка());
					КонецЕсли;

					Если Метка <> Неопределено Тогда
						ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
						Если ВыводитьКоды Тогда
							ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
						КонецЕсли;
						ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
						ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
					КонецЕсли;

					ОбластьПодзаголовок.Параметры.ТекстПозаголовка = ТекстПозаголовка;
					ТабличныйДокумент.Вывести(ОбластьПодзаголовок);
				КонецЕсли;

				ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
				Если ВыводитьКоды Тогда
					ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
				КонецЕсли;
				ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
				ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
			КонецЕсли;

			ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			#Вставка
			//++ РС Консалт: Минаков А.С. Задача 20226
			ОбластьСтрокаТаблицыНачало.Параметры.Штрихкод = РСК_ВызовСервера.НайтиШтрихкоды(
			ВыборкаПоСтрокамТЧ.Номенклатура,
			ВыборкаПоСтрокамТЧ.Характеристика,
			ВыборкаПоСтрокамТЧ.Серия,
			ВыборкаПоСтрокамТЧ.Упаковка);
			//++ РС Консалт: Минаков А.С. Задача 20226
			#КонецВставки
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);

			Если ВыводитьКоды Тогда
				ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ[ИмяКолонкиКодов];
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
			КонецЕсли;

			ДопПараметрыПредставлениеНоменклатуры = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
			ДопПараметрыПредставлениеНоменклатуры.КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();

			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			ВыборкаПоСтрокамТЧ.НоменклатураПредставление,
			ВыборкаПоСтрокамТЧ.ХарактеристикаПредставление,
			, // Упаковка
			ВыборкаПоСтрокамТЧ.СерияПредставление,
			ДопПараметрыПредставлениеНоменклатуры);

			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);

			ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	

			Метка = ВыборкаПоСтрокамТЧ.Метка;

		КонецЦикла;

		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		#Вставка
		//++ РС Консалт: Минаков А.С. Задача 20226
		ОбластьПодвалТаблицыКонец.Параметры.КоличествоПлан = ВыборкаПоТабличнымЧастям.КоличествоПлан;
		ОбластьПодвалТаблицыКонец.Параметры.КоличествоФакт = ВыборкаПоТабличнымЧастям.КоличествоФакт;	
		//++ РС Консалт: Минаков А.С. Задача 20226
		//++ РС Консалт: Трофимов Евгений 19.01.2023 Задача 23087
		//e1cib/data/Документ.Задание?ref=a70cc94fd7f4d8874de8888e78f9c280
		ОбластьПодвалТаблицыКонец.Параметры.ДатаПечати = Формат(ТекущаяДатаСеанса(),"ДФ='dd.MM.yyyy ЧЧ:мм'");	
		//-- КонецЗадачи 23087
		#КонецВставки
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		#Вставка  
		//++ РС Консалт: Минаков А.С. Задача 20226
		
		//++ РС Консалт: Трофимов Евгений 19.01.2023 Задача 23087
		//e1cib/data/Документ.Задание?ref=a70cc94fd7f4d8874de8888e78f9c280
		//удалено. Швыряева Инна: должно быть пустое поле.  дату отбора будет проставлять сам наборщик рукой
		//ОбластьИтогиПодвал.Параметры.ДатаПечати = ТекущаяДата();
		СтруктураИсполнителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыборкаПоДокументам.Ссылка, "Исполнитель.Наименование,Исполнитель.ФизическоеЛицо");
		Должность = "";
		ФамилияИнициалы = "";
		Если ЗначениеЗаполнено(СтруктураИсполнителя.ИсполнительФизическоеЛицо) Тогда
			ЗапросДолжности = Новый Запрос;
			ЗапросДолжности.Текст =
				"ВЫБРАТЬ
				|	КадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность
				|ИЗ
				|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаСведений, ФизическоеЛицо = &ФизЛицо) КАК КадроваяИсторияСотрудниковСрезПоследних
				|";
			ЗапросДолжности.УстановитьПараметр("ДатаСведений", ВыборкаПоДокументам.Дата);
			ЗапросДолжности.УстановитьПараметр("ФизЛицо", СтруктураИсполнителя.ИсполнительФизическоеЛицо);
			Выборка = ЗапросДолжности.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Должность = Выборка.Должность;
			КонецЕсли;
			ФизическиеЛицаЛокализация.ДополнитьФамилияИнициалыФизЛица(
				СтруктураИсполнителя.ИсполнительФизическоеЛицо, 
				ФамилияИнициалы, 
				ВыборкаПоДокументам.Дата
			);
		ИначеЕсли ЗначениеЗаполнено(СтруктураИсполнителя.ИсполнительНаименование) Тогда 
			ФамилияИнициалы = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СтруктураИсполнителя.ИсполнительНаименование);
		КонецЕсли;
		
		Если ПустаяСтрока(Должность) Тогда
			ОбластьИтогиПодвал.Параметры.Должность = "";
		Иначе
			ОбластьИтогиПодвал.Параметры.Должность = ", " + СокрЛП(Должность);
		КонецЕсли;
		
		//удалено (почему-то этот механизм не возвращает должность)
		//Исполнитель = ВыборкаПоДокументам.Ссылка.Исполнитель;
		//ФЛ = Исполнитель.ФизическоеЛицо;
		//ФамилияИнициалы = Неопределено;
		//Если ЗначениеЗаполнено(ФЛ) И ТипЗнч(ФЛ) = Тип("СправочникСсылка.ФизическиеЛица") Тогда			
		//	СписокСотрудников = КадровыйУчет.СотрудникиФизическихЛиц(ФЛ).ВыгрузитьКолонку("Сотрудник");
		//	Если СписокСотрудников.Количество() Тогда
		//		КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, СписокСотрудников, "ТекущаяДолжность", ВыборкаПоДокументам.Ссылка.Дата);
		//		Если КадровыеДанныеСотрудников.Количество() Тогда
		//			ОбластьИтогиПодвал.Параметры.Должность = КадровыеДанныеСотрудников[0].ТекущаяДолжность;
		//		КонецЕсли
		//	КонецЕсли;	
		//	ФИО = ФЛ.ФИО;
		//	ФизическиеЛицаЛокализация.ДополнитьФамилияИнициалыФизЛица(ФЛ, ФамилияИнициалы, ВыборкаПоДокументам.Ссылка.Дата); 	
		//Иначе
		//	ФИО = Исполнитель.Наименование;
		//	ФамилияИнициалы = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФИО)
		//КонецЕсли;
		//ОбластьИтогиПодвал.Параметры.ФИО = ФИО;
		//-- КонецЗадачи 23087		
		ОбластьИтогиПодвал.Параметры.Инициалы = ФамилияИнициалы;
		
		ТабличныйДокумент.Вывести(ОбластьИтогиПодвал);
		//++ РС Консалт: Минаков А.С. Задача 20226

		//++ РС Консалт: Трофимов Евгений 20.01.2023 Задача 23154
		//e1cib/data/Документ.Задание?ref=bcb44edb8528e94044a02d443a51d096
		Если НЕ ПустаяСтрока(ДанныеРаспоряжения.ОсобыеОтметки) Тогда
			ОбластьОсобыеОтметки.Параметры.ОсобыеОтметки = ДанныеРаспоряжения.ОсобыеОтметки;
			ТабличныйДокумент.Вывести(ОбластьОсобыеОтметки);
		КонецЕсли;
		//-- КонецЗадачи 23154		
		#КонецВставки

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	Возврат ТабличныйДокумент;	
КонецФункции

//++ РС Консалт: Трофимов Евгений 06.02.2023 Задача 23685
//e1cib/data/Документ.Задание?ref=8fbed5d9b11e789b49572ee1506ac469
Функция ПолучитьДанныеРаспоряжения(ДокументОтбор)
	
	Результат = Новый Структура("ТранспортнаяКомпания,АдресДоставки,Получатель,ОсобыеОтметки","","","","");
	
	Распоряжение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОтбор, "Распоряжение");
	Если ТипЗнч(Распоряжение) <> Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение КАК Распоряжение
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
		|ГДЕ
		|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Распоряжение);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Если НЕ ЗначениеЗаполнено(Выборка.Распоряжение)
		ИЛИ (ТипЗнч(Выборка.Распоряжение) <> Тип("ДокументСсылка.ЗаказКлиента")
		   И ТипЗнч(Выборка.Распоряжение) <> Тип("ДокументСсылка.ЗаказНаПеремещение")) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СтруктураДоставки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.Распоряжение,"СпособДоставки,ПеревозчикПартнер,АдресДоставки");
	Результат.Вставить("АдресДоставки", СтруктураДоставки.АдресДоставки);
	
	МассивСпособовДоставки = Новый Массив;
	МассивСпособовДоставки.Добавить(Перечисления.СпособыДоставки.СиламиПеревозчика);
	МассивСпособовДоставки.Добавить(Перечисления.СпособыДоставки.СиламиПеревозчикаПоАдресу);
	МассивСпособовДоставки.Добавить(Перечисления.СпособыДоставки.РСК_ПеревозчикДоКлиента);
	МассивСпособовДоставки.Добавить(Перечисления.СпособыДоставки.РСК_ПеревозчикДоПВЗ);
	
	Если МассивСпособовДоставки.Найти(СтруктураДоставки.СпособДоставки) = Неопределено 
		ИЛИ НЕ ЗначениеЗаполнено(СтруктураДоставки.ПеревозчикПартнер) Тогда
		
		Результат.Вставить("ТранспортнаяКомпания", СтруктураДоставки.СпособДоставки);
		
	Иначе
		
		Результат.Вставить("ТранспортнаяКомпания", СтруктураДоставки.ПеревозчикПартнер);
		
	КонецЕсли;

	Если ТипЗнч(Выборка.Распоряжение) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		Результат.Вставить("Получатель", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Распоряжение, "Контрагент"));
		СтруктураОсобыхПеревозок = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Выборка.Распоряжение, 
			"ОсобыеУсловияПеревозки,ОсобыеУсловияПеревозкиОписание"
		);
		Если СтруктураОсобыхПеревозок.ОсобыеУсловияПеревозки Тогда
			Результат.Вставить("ОсобыеОтметки", СтруктураОсобыхПеревозок.ОсобыеУсловияПеревозкиОписание);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Выборка.Распоряжение) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		Результат.Вставить("Получатель", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Распоряжение, "СкладПолучатель"));
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ПолучитьДанныеРаспоряжения()

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	//принять решение о необходимости скрытия из отчетов по версиям реквизитов и табличных частей, 
	//имеющих техническое назначение. Для скрытия реквизитов и табличных частей необходимо в 
	//процедуре ПриОпределенииНастроекВерсионированияОбъектов модуля менеджера объекта добавить следующий код:
	
	//Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
// Реквизиты - Массив - список имен реквизитов объекта.
Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
	//Реквизиты.Добавить("ИмяРеквизита"); // реквизит объекта
	//Реквизиты.Добавить("ИмяТабличнойЧасти.*"); // табличная часть объекта
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецЕсли
#КонецЕсли
&ИзменениеИКонтроль("ДобавитьКомандыПечати")
Процедура РСК_ДобавитьКомандыПечати(КомандыПечати)

	// Задание складскому работнику
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СкладскоеЗадание";
	КомандаПечати.Представление = НСтр("ru = 'Задание складскому работнику';
	|en = 'Intra-warehouse transfer task'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

	// Этикетки
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьЭтикетокИЦенников";
	КомандаПечати.МенеджерПечати = "Документ.ОтборРазмещениеТоваров";
	КомандаПечати.Идентификатор = "Этикетки";
	КомандаПечати.Представление = НСтр("ru = 'Этикетки';
	|en = 'Labels'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 
	
	#Вставка 
	//++ Конарев И.И. Печать сертфиикатов номенклатуры
	Если ПравоДоступа("Чтение", Метаданные.Справочники.СертификатыНоменклатуры)
		И ПолучитьФункциональнуюОпцию("ИспользоватьСертификатыНоменклатуры") Тогда 
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "СертификатыНоменклатурыИзображенияИзДокументов";
		КомандаПечати.Представление = НСтр("ru = 'Сертификаты номенклатуры';
											|en = 'Certificates (by each document item)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	//--
	#КонецВставки


КонецПроцедуры

&ИзменениеИКонтроль("Печать")
Процедура РСК_Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СкладскоеЗадание") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"СкладскоеЗадание",
		НСтр("ru = 'Складское задание';
		|en = 'Warehouse task'"),
		ПечатьЗадания(МассивОбъектов, ОбъектыПечати));
	#Вставка
	//++ Конарев И.И. Печать сертфиикатов номенклатуры
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СертификатыНоменклатурыИзображенияИзДокументов") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СертификатыНоменклатурыИзображенияИзДокументов",
			НСтр("ru = 'Сертификаты (по каждой позиции документа)';
				|en = 'Certificates (by each document item)'"),
			Справочники.СертификатыНоменклатуры.СформироватьСформироватьПечатнуюФормуИзображенияСертификатовИзДокументовОтборРазмещение(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.СертификатыНоменклатуры.ПФ_MXL_ИзображенияСертификатов");
	#КонецВставки
	КонецЕсли;
КонецПроцедуры
