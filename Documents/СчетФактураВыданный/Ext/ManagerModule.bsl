﻿  
  &ИзменениеИКонтроль("ПолучитьДанныеДляПечатнойФормыСчетФактура")
Функция РСК_ПолучитьДанныеДляПечатнойФормыСчетФактура(ПараметрыПечати, МассивОбъектов)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаТаблицаОснований();
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатПакета = Запрос.ВыполнитьПакет();
	
	МассивШапокОснований = РезультатПакета[3].Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	МассивОснований = РезультатПакета[1].Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	
	Если МассивОснований.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;


	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	Контракт = Неопределено;
	ЕстьЭлектронноеАктирование = Ложь;
	Для Каждого Основание Из МассивОснований Цикл
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Основание, "Договор")
			И ТипЗнч(Основание.Договор) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание.Договор, "Организация");
			ПараметрыОтправкиВЕИС = ЭлектронноеАктированиеЕИСУТ.ПараметрыОтправкиВЕИС(
					Организация, Основание.Договор);
			ЕстьЭлектронноеАктирование = ПараметрыОтправкиВЕИС.ВозможнаОтправка
				И ЭлектронноеАктированиеЕИСУТ.ДокументОтправляетсяВЕИС(Основание);
			Контракт = ПараметрыОтправкиВЕИС.Контракт;
		КонецЕсли;
	КонецЦикла;
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС

	
	ПоместитьВременнуюТаблицуШапокОснований(МенеджерВременныхТаблиц, МассивШапокОснований);
	ПоместитьВременнуюТаблицуДанныхОснований(МенеджерВременныхТаблиц, МассивОснований);
	ПоместитьВременнуюТаблицуПокупатели(МенеджерВременныхТаблиц, МассивОбъектов);
	
	// Передается Ссылка вместо Организации, чтобы не брать ответственных по умолчанию из организации.
	// Такие ответственные будут взяты из торгового документа-основания.
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(
		МассивОбъектов, МенеджерВременныхТаблиц, "Ссылка", ,
		"ОтветственныеЛицаСФ");
	
	МассивАналитикУчетаПоПартнерам = Новый Массив;
	
	// В подчиненном узле нет всех данных для определения авансов, поэтому заполняем только если главный узел:
	ЗаполнятьПлатежноРасчетныеДокументы = ПланыОбмена.ГлавныйУзел() = Неопределено;
	
	Если ЗаполнятьПлатежноРасчетныеДокументы Тогда
		ПоместитьВременнуюТаблицуЗаполненияПлатежноРасчетныхДокументов(МенеджерВременныхТаблиц);
		МассивАналитикУчетаПоПартнерамПлатежноРасчетныхДокументов = 
			АналитикиУчетаПоПартнерамДляАктуализацииПлатежноРасчетныхДокументов(МенеджерВременныхТаблиц);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивАналитикУчетаПоПартнерам,
				МассивАналитикУчетаПоПартнерамПлатежноРасчетныхДокументов);
		ОкончаниеПериодаРасчета = КонецРасчетаДляАктуализацииПлатежноРасчетныхДокументов(МенеджерВременныхТаблиц);
	КонецЕсли;
	
	// Актуализировать расчеты для получения сумм по товарам документа-основания
	Если Не ПараметрыПечати.ПечатьВВалюте Тогда
		
		Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеДокументов.Ссылка КАК Ссылка
			|ИЗ
			|	ТаблицаШапокДокументов КАК ДанныеДокументов
			|ГДЕ
			|	ДанныеДокументов.Валюта <> ДанныеДокументов.Организация.ВалютаРегламентированногоУчета
			|	ИЛИ ДанныеДокументов.Валюта <> &ВалютаУправленческогоУчета";
			
			МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			РегистрыСведений.СуммыДокументовВВалютахУчета.РассчитатьСуммыДокументовВВалютахУчета(МассивДокументов);
			
		Иначе
			
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ТаблицаШапокДокументов КАК ДанныеДокументов
			|	ПО
			|		РасчетыСКлиентами.Регистратор = ДанныеДокументов.Ссылка
			|
			|ГДЕ
			|	ДанныеДокументов.Валюта <> ДанныеДокументов.Организация.ВалютаРегламентированногоУчета
			|	И РасчетыСКлиентами.Активность
			|";
			
			ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивАналитикУчетаПоПартнерам, 
				ТаблицаАналитик.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам"), Истина);
			
			ОкончаниеПериодаРасчета = КонецМесяца(ВзаиморасчетыСервер.ПолучитьМаксимальнуюДатуВКоллекцииДокументов(МенеджерВременныхТаблиц)) + 1;
			
		КонецЕсли;
	КонецЕсли;
	
	Если (ЗаполнятьПлатежноРасчетныеДокументы ИЛИ Не ПараметрыПечати.ПечатьВВалюте)
		И МассивАналитикУчетаПоПартнерам.Количество() > 0 Тогда
		Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
			АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
			АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикУчетаПоПартнерам;
			Попытка
				РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(ОкончаниеПериодаРасчета, АналитикиРасчета);
			Исключение
				ТекстСообщения = НСтр("ru = 'Печатная форма сформирована по неактуальным данным.
				|Необходимо актуализировать взаиморасчеты вручную и переформировать печатную форму.';
				|en = 'Print form is generated according to irrelevant data. 
				|Update mutual settlements manually, and then create the print form again.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		Иначе
			Если Константы.РаспределятьФактическиеРасчетыФоновымЗаданием.Получить() Тогда
				ТекстСообщения = НСтр("ru = 'Печатная форма сформирована по неактуальным данным.';
										|en = 'The print form is generated according to irrelevant data.'") + Символы.ПС;
				ТекстСообщения = ТекстСообщения + ВзаиморасчетыСервер.ТекстПредупрежденияЗагрузкаДокументовВзаиморасчетов();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаполнятьПлатежноРасчетныеДокументы Тогда
		ПлатежноРасчетныеДокументы = ПоместитьВременнуюТаблицуПлатежноРасчетныхДокументов(
			МенеджерВременныхТаблиц,
			МассивАналитикУчетаПоПартнерамПлатежноРасчетныхДокументов);
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	NULL КАК Ссылка,
		|	NULL КАК СтрокаПлатежноРасчетныеДокументы
		|ПОМЕСТИТЬ ТаблицаПлатежноРасчетныеДокументы";
		Запрос.Выполнить();
	КонецЕсли;
	
	ПараметрыПечати.Вставить("ВыводитьНаборы", Ложь);
	СформироватьВременнуюТаблицуТоваровДляПечати(МенеджерВременныхТаблиц, МассивОснований, ПараметрыПечати);
	
	ПечататьСчетаФактурыПолученные = ПараметрыПечати.Свойство("МассивСчетФактураПолученный");
	Если ПечататьСчетаФактурыПолученные Тогда
		Запрос.УстановитьПараметр("МассивСчетФактураПолученный", ПараметрыПечати.МассивСчетФактураПолученный);
	КонецЕсли;
	
	ЗаполнитьДанныеШтрихкодовДляУКДДо = Ложь;
	Если ПараметрыПечати.Свойство("ЗаполнитьДанныеШтрихкодовДляУКДДо") И ПараметрыПечати.ЗаполнитьДанныеШтрихкодовДляУКДДо Тогда
		ЗаполнитьДанныеШтрихкодовДляУКДДо = Истина;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru = 'счет-фактура';
																|en = 'tax invoice'"));
	Запрос.УстановитьПараметр("ПредставлениеСчетФактураПосредника", НСтр("ru = 'счет-фактура посредника';
																		|en = 'intermediary tax invoice'"));
	Запрос.УстановитьПараметр("ВыводитьБазовыеЕдиницыИзмерения", Константы.ВыводитьБазовыеЕдиницыИзмерения.Получить());
	
	МассивОперацийПередачаНаКомиссию = Новый Массив;
	МассивОперацийПередачаНаКомиссию.Добавить(Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту);
	МассивОперацийПередачаНаКомиссию.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
	МассивОперацийПередачаНаКомиссию.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию);
	Запрос.УстановитьПараметр("ХозяйственныеОперацииПередачаНаКомиссию", МассивОперацийПередачаНаКомиссию);
	
	Запрос.УстановитьПараметр("ВыводитьОсновнойУПД", 
		Не (ПараметрыПечати.Свойство("НеВыводитьОсновнойУПД") И ПараметрыПечати.НеВыводитьОсновнойУПД));
	Запрос.УстановитьПараметр("ДатаОтраженияВозвратовКорректировочнымиСФ", УчетНДСУП.НастройкиУчета().ДатаОтраженияВозвратовКорректировочнымиСФ);
	
	СформироватьВтСчетаФактурыПолученные(МенеджерВременныхТаблиц, ПараметрыПечати);
	СформироватьВТПорядковыеНомераТаблицыТоваровИПредставления5а(МенеджерВременныхТаблиц, ПараметрыПечати);
	СформироватьПредставлениеВыставленКомиссионеру(МенеджерВременныхТаблиц);
	
	Запрос.УстановитьПараметр("МассивОснований", МассивОснований);
	
	Запрос.Текст = ТекстЗапросаДанныхШапкиДляПечатиСчетаФактуры(ПараметрыПечати)
		+ ТекстЗапросаИсходныхДокументовДляПечатиСчетаФактуры()
		+ ТекстЗапросаДанныхТабличнойЧастиДляПечатиСчетаФактуры(ПараметрыПечати)
		+ ТекстЗапросаДанныхМаркировки(ЗаполнитьДанныеШтрихкодовДляУКДДо)
		+ ТекстЗапросаДанныхПоПеревыставленномуСчетуФактуре()
		+ ТекстЗапросаДанныхПрослеживаемость()
		+ ТекстЗапросаДанныхПрослеживаемыеКомплектующие();
	

	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	Если ЕстьЭлектронноеАктирование Тогда
		Запрос.Текст = Запрос.Текст + ЭлектронноеАктированиеЕИСУТ.ТекстЗапросаДанныеДляПечатиСчетовФактур("МассивОснований");
		Запрос.УстановитьПараметр("ГосударственныйКонтрактЕИС", Контракт);
		Если ТипЗнч(МассивОснований[0]) = Тип("ДокументСсылка.СчетФактураВыданный") 
				Или ТипЗнч(МассивОснований[0]) = Тип("ДокументСсылка.СчетФактураВыданныйАванс") Тогда
			Запрос.УстановитьПараметр("ЭтапИсполненияКонтрактаЕИС", МассивОснований[0].ДокументОснование.ЭтапГосконтрактаЕИС);
		Иначе
			Запрос.УстановитьПараметр("ЭтапИсполненияКонтрактаЕИС", МассивОснований[0].ЭтапГосконтрактаЕИС);			
		КонецЕсли;		
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС

	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	КоличествоРезультатов     = МассивРезультатов.Количество();


	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	Если ЕстьЭлектронноеАктирование Тогда	
		КоличествоРезультатов     = КоличествоРезультатов - 5;
		#Вставка
		//++РС Консалт Назаров М.Ю. 20 сентября 2022 г. 9:55:13  
		Если ЗаполнитьДанныеШтрихкодовДляУКДДо Тогда
			НомерРезультатаПоТабличнойЧасти = КоличествоРезультатов - 7;
		Иначе
			НомерРезультатаПоТабличнойЧасти = КоличествоРезультатов - 6;
		КонецЕсли;
		
		РС_СверткаТаблицыПриОтправкеВЕИС.ДобавитьСверткуПоТабличнойЧастиВРезультатЗапроса(МассивРезультатов, НомерРезультатаПоТабличнойЧасти);	
		//--РС Консалт Назаров М.Ю. 20 сентября 2022 г. 10:26:19
		#КонецВставки
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС

	
	Если ЗаполнитьДанныеШтрихкодовДляУКДДо Тогда
		РезультатПоКонтрагентам   = МассивРезультатов[КоличествоРезультатов - 10];
		РезультатПоШапке          = МассивРезультатов[КоличествоРезультатов - 9];
		РезультатПоИсходнымДанным = МассивРезультатов[КоличествоРезультатов - 8];
		РезультатПоТабличнойЧасти = МассивРезультатов[КоличествоРезультатов - 7];
		
		МаркировкаДо = МассивРезультатов[КоличествоРезультатов - 5].Выгрузить();
		МаркировкаДо = ЭлектронноеВзаимодействиеИСМП.ЧастичноеСодержимое(МаркировкаДо);
		Если МаркировкаДо.Количество() = 0 Тогда // Коды переданы через документ прямого обмена.
			Маркировка = МаркировкаДо.СкопироватьКолонки();
		Иначе
			Маркировка = МассивРезультатов[КоличествоРезультатов - 6].Выгрузить();
			Маркировка = ЭлектронноеВзаимодействиеИСМП.ЧастичноеСодержимое(Маркировка);
		КонецЕсли;
		
		РезультатПоПоставщикам    = МассивРезультатов[КоличествоРезультатов - 4];
		
		Прослеживаемость = МассивРезультатов[КоличествоРезультатов - 2];
		ПрослеживаемыеКомплектующие = УчетПрослеживаемыхТоваровЛокализация.ПрослеживаемыеКомплектующиеДляПечатиДанных(
										МассивРезультатов[КоличествоРезультатов - 1]);
		
		СтруктураДанныхДляПечати = Новый Структура;
		СтруктураДанныхДляПечати.Вставить("РезультатПоШапке"              , РезультатПоШапке);
		СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти"     , РезультатПоТабличнойЧасти);
		СтруктураДанныхДляПечати.Вставить("РезультатПоИсходнымДанным"     , РезультатПоИсходнымДанным);
		СтруктураДанныхДляПечати.Вставить("РезультатПоКонтрагентам"       , РезультатПоКонтрагентам);
		СтруктураДанныхДляПечати.Вставить("Маркировка"                    , Маркировка);
		СтруктураДанныхДляПечати.Вставить("МаркировкаДо"                  , МаркировкаДо);
		СтруктураДанныхДляПечати.Вставить("РезультатПоПоставщикам"        , РезультатПоПоставщикам);
		СтруктураДанныхДляПечати.Вставить("НомерСформированВСчетеФактуре" , Истина);
		СтруктураДанныхДляПечати.Вставить("Прослеживаемость"              , Прослеживаемость);
		СтруктураДанныхДляПечати.Вставить("ПрослеживаемыеКомплектующие"   , ПрослеживаемыеКомплектующие);
		
	Иначе
		РезультатПоКонтрагентам   = МассивРезультатов[КоличествоРезультатов - 9];
		РезультатПоШапке          = МассивРезультатов[КоличествоРезультатов - 8];
		РезультатПоИсходнымДанным = МассивРезультатов[КоличествоРезультатов - 7];
		РезультатПоТабличнойЧасти = МассивРезультатов[КоличествоРезультатов - 6];
		
		Маркировка                = МассивРезультатов[КоличествоРезультатов - 5].Выгрузить();
		Маркировка                = ЭлектронноеВзаимодействиеИСМП.ЧастичноеСодержимое(Маркировка);
		
		РезультатПоПоставщикам    = МассивРезультатов[КоличествоРезультатов - 4];
		
		Прослеживаемость = МассивРезультатов[КоличествоРезультатов - 2];
		ПрослеживаемыеКомплектующие = УчетПрослеживаемыхТоваровЛокализация.ПрослеживаемыеКомплектующиеДляПечатиДанных(
										МассивРезультатов[КоличествоРезультатов - 1]);
		
		СтруктураДанныхДляПечати = Новый Структура;
		СтруктураДанныхДляПечати.Вставить("РезультатПоШапке"              , РезультатПоШапке);
		СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти"     , РезультатПоТабличнойЧасти);
		СтруктураДанныхДляПечати.Вставить("РезультатПоИсходнымДанным"     , РезультатПоИсходнымДанным);
		СтруктураДанныхДляПечати.Вставить("РезультатПоКонтрагентам"       , РезультатПоКонтрагентам);
		СтруктураДанныхДляПечати.Вставить("Маркировка"                    , Маркировка);
		СтруктураДанныхДляПечати.Вставить("РезультатПоПоставщикам"        , РезультатПоПоставщикам);
		СтруктураДанныхДляПечати.Вставить("НомерСформированВСчетеФактуре" , Истина);
		СтруктураДанныхДляПечати.Вставить("Прослеживаемость"              , Прослеживаемость);
		СтруктураДанныхДляПечати.Вставить("ПрослеживаемыеКомплектующие"   , ПрослеживаемыеКомплектующие);
	
	КонецЕсли;
	
	Если ЗаполнятьПлатежноРасчетныеДокументы Тогда
		СтруктураДанныхДляПечати.Вставить("ПлатежноРасчетныеДокументы", ПлатежноРасчетныеДокументы);
	КонецЕсли;


	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	Если ЕстьЭлектронноеАктирование Тогда	
		ЭлектронноеАктированиеЕИСУТ.ПоместитьРезультатВыполненияЗапросаВДанныеДляПечати(
			МассивРезультатов, СтруктураДанныхДляПечати, КоличествоРезультатов);
		#Вставка
		//+РС Консалт Назаров М.Ю. 07.02.2023 10:37:33    
		СтруктураДанныхДляПечати.Вставить("СверткаПоТабличнойЧасти", МассивРезультатов[МассивРезультатов.Количество() - 1]);
		//-РС Консалт Назаров М.Ю. 07.02.2023 10:37:33
		#КонецВставки
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС

	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

&ИзменениеИКонтроль("ТекстЗапросаДанныхТабличнойЧастиДляПечатиСчетаФактуры")
Функция РСК_ТекстЗапросаДанныхТабличнойЧастиДляПечатиСчетаФактуры(ПараметрыПечати)
	
	ПечататьСчетаФактурыПолученные = ПараметрыПечати.Свойство("МассивСчетФактураПолученный");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СчетаФактурыОснования.Ссылка                                 КАК Ссылка,
	|	ВЫБОР КОГДА СчетаФактурыОснования.РеализацияЧерезКомиссионера
	|		ТОГДА СчетаФактурыОснования.ДокументОснование
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование,
	|	АналитикиТаблицыТоваровСНомерамиСтрок.НомерСтрокиСФ          КАК НомерСтроки,
	|	АналитикиТаблицыТоваровСНомерамиСтрок.НомерСтрокиИсходногоСФ КАК НомерСтрокиИсходногоСФ,
	
	|	ТаблицаДокумента.Номенклатура                                КАК Номенклатура,
	|	ТаблицаДокумента.НоменклатураНаименование                    КАК НоменклатураНаименование,
	|	ТаблицаДокумента.НоменклатураКод                             КАК НоменклатураКод,
	|	ТаблицаДокумента.КодТНВЭД                                    КАК КодТНВЭД,
	|	ТаблицаДокумента.ЕдиницаИзмерения                            КАК ЕдиницаИзмерения,
	|	ДанныеЕдиницыИзмерения.Представление                         КАК ЕдиницаИзмеренияНаименование,
	|	ДанныеЕдиницыИзмерения.Код                                   КАК ЕдиницаИзмеренияКод,
	|	ТаблицаДокумента.Упаковка                                    КАК Упаковка,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД          КАК ЕдиницаИзмеренияТНВЭД,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Представление КАК ЕдиницаИзмеренияТНВЭДНаименование,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Код      КАК ЕдиницаИзмеренияТНВЭДКод,
	|	ТаблицаДокумента.Характеристика                              КАК Характеристика,
	|	ТаблицаДокумента.НоменклатураПартнера          				 КАК НоменклатураПартнера,
	|	ЕСТЬNULL(ДанныеХарактеристики.НаименованиеПолное, """")      КАК ХарактеристикаНаименование,
	|	ТаблицаДокумента.Серия.Наименование                          КАК СерияНаименование,
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|	ТаблицаДокумента.Серия                          			 КАК Серия,
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|	ТаблицаДокумента.НомерГТД                                    КАК НомерГТДСсылка,
	|	ЕСТЬNULL(ТаблицаДокумента.НомерГТД.ТипНомераГТД, НЕОПРЕДЕЛЕНО) КАК ТипНомераГТД,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.НомерГТД.РегистрационныйНомер = """"
	|			ТОГДА ТаблицаДокумента.НомерГТД
	|		ИНАЧЕ ТаблицаДокумента.НомерГТД.РегистрационныйНомер
	|	КОНЕЦ                                                        КАК НомерГТД,
	|	ДанныеСтраныПросхождения.Ссылка                              КАК СтранаПроисхождения,
	|	ДанныеСтраныПросхождения.Код                                 КАК СтранаПроисхожденияКод,
	|	СУММА(ТаблицаДокумента.Количество)                           КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоПоРНПТ)                     КАК КоличествоПоРНПТ,
	|	ВЫБОР КОГДА СУММА(ТаблицаДокумента.Количество) = 0 И ТаблицаДокумента.Цена = 0
	|		ТОГДА ТаблицаДокумента.ЦенаДо
	|		ИНАЧЕ ТаблицаДокумента.Цена
	|	КОНЕЦ КАК Цена,
	|	СУММА(ТаблицаДокумента.СуммаБезНДС)                          КАК СуммаБезНДС,
	|	СУММА(ТаблицаДокумента.СуммаНДС)                             КАК СуммаНДС,
	|	СУММА(ТаблицаДокумента.СуммаБезНДС
	|		+ ТаблицаДокумента.СуммаНДС)                             КАК СуммаСНДС,
	|	ТаблицаДокумента.СтавкаНДС                                   КАК СтавкаНДС,
	|
	|	СУММА(ТаблицаДокумента.КоличествоДо)                         КАК КоличествоДо,
	|	СУММА(ТаблицаДокумента.КоличествоПоРНПТДо)                   КАК КоличествоПоРНПТДо,
	|	СУММА(ТаблицаДокумента.КоличествоПоРНПТУвеличение)           КАК КоличествоПрослежУвеличение,
	|	СУММА(ТаблицаДокумента.КоличествоПоРНПТУменьшение)           КАК КоличествоПрослежУменьшение,
	|	ТаблицаДокумента.ЦенаДо                                      КАК ЦенаДо,
	|	СУММА(ТаблицаДокумента.СуммаБезНДСДо)                        КАК СуммаБезНДСДо,
	|	СУММА(ТаблицаДокумента.РазницаБезНДСУвеличение)              КАК РазницаБезНДСУвеличение,
	|	СУММА(ТаблицаДокумента.РазницаБезНДСУменьшение)              КАК РазницаБезНДСУменьшение,
	|	СУММА(ТаблицаДокумента.СуммаНДСДо)                           КАК СуммаНДСДо,
	|	СУММА(ТаблицаДокумента.РазницаНДСУвеличение)                 КАК РазницаНДСУвеличение,
	|	СУММА(ТаблицаДокумента.РазницаНДСУменьшение)                 КАК РазницаНДСУменьшение,
	|	СУММА(ТаблицаДокумента.СуммаБезНДСДо
	|		+ ТаблицаДокумента.СуммаНДСДо)                           КАК СуммаСНДСДо,
	|	СУММА(ТаблицаДокумента.РазницаСНДСУвеличение)                КАК РазницаСНДСУвеличение,
	|	СУММА(ТаблицаДокумента.РазницаСНДСУменьшение)                КАК РазницаСНДСУменьшение,
	|
	|	//ДанныеНаборов
	|
	|	ЛОЖЬ                                                         КАК ЭтоВозвратнаяТара
	|
	|ИЗ
	|	ТаблицаТоваровДокументов КАК ТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СчетаФактурыОснования КАК СчетаФактурыОснования
	|		ПО (ВЫБОР
	|				КОГДА СчетаФактурыОснования.ДокументОснование ССЫЛКА Документ.ОтчетКомитентуОЗакупках
	|					ТОГДА СчетаФактурыОснования.Ссылка = ТаблицаДокумента.СсылкаСФ
	|				КОГДА СчетаФактурыОснования.ДокументОснование ССЫЛКА Документ.ОтчетКомиссионера
	|					ТОГДА СчетаФактурыОснования.ДокументОснование = ТаблицаДокумента.Ссылка
	|						И (ТаблицаДокумента.Покупатель, ТаблицаДокумента.НомерСчетаФактуры) В
	|							(ВЫБРАТЬ СчетаФактурыПокупатели.Покупатель,
	|									СчетаФактурыПокупатели.НомерСчетаФактуры
	|								ИЗ СчетаФактурыПокупатели КАК СчетаФактурыПокупатели
	|								ГДЕ
	|								СчетаФактурыПокупатели.Ссылка = СчетаФактурыОснования.Ссылка)
	|				ИНАЧЕ СчетаФактурыОснования.ДокументОснование = ТаблицаДокумента.Ссылка
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК ДанныеЕдиницыИзмерения
	|		ПО ТаблицаДокумента.ЕдиницаИзмерения = ДанныеЕдиницыИзмерения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ДанныеХарактеристики
	|		ПО ТаблицаДокумента.Характеристика = ДанныеХарактеристики.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК ДанныеСтраныПросхождения
	|		ПО ТаблицаДокумента.НомерГТД.СтранаПроисхождения = ДанныеСтраныПросхождения.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АналитикиТаблицыТоваровСНомерамиСтрок КАК АналитикиТаблицыТоваровСНомерамиСтрок
	|		ПО АналитикиТаблицыТоваровСНомерамиСтрок.СчетФактура = СчетаФактурыОснования.Ссылка
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.ДокументОснование = СчетаФактурыОснования.ДокументОснование
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.НомерСтрокиИсходногоСФ = ТаблицаДокумента.НомерСтрокиИсходногоСФ
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.Номенклатура = ТаблицаДокумента.Номенклатура
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.НоменклатураНаименование = ТаблицаДокумента.НоменклатураНаименование
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.КодТНВЭД = ТаблицаДокумента.КодТНВЭД
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.Характеристика = ТаблицаДокумента.Характеристика
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.Серия = ТаблицаДокумента.Серия
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.НомерГТД = ТаблицаДокумента.НомерГТД
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.Цена = ТаблицаДокумента.Цена
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.СтавкаНДС = ТаблицаДокумента.СтавкаНДС
	|		И АналитикиТаблицыТоваровСНомерамиСтрок.ЦенаДо = ТаблицаДокумента.ЦенаДо
	|		//СоединениеНаборов
	
	|ГДЕ
	|	НЕ ТаблицаДокумента.ЭтоВозвратнаяТара
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаФактурыОснования.Ссылка,
	|	ВЫБОР КОГДА СчетаФактурыОснования.РеализацияЧерезКомиссионера
	|		ТОГДА СчетаФактурыОснования.ДокументОснование
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	АналитикиТаблицыТоваровСНомерамиСтрок.НомерСтрокиСФ,
	|	АналитикиТаблицыТоваровСНомерамиСтрок.НомерСтрокиИсходногоСФ,
	|	ТаблицаДокумента.Номенклатура,
	|	ТаблицаДокумента.НоменклатураНаименование,
	|	ТаблицаДокумента.НоменклатураКод,
	|	ТаблицаДокумента.КодТНВЭД,
	|	ТаблицаДокумента.ЕдиницаИзмерения,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Представление,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмеренияТНВЭД.Код,
	|	ДанныеЕдиницыИзмерения.Представление,
	|	ДанныеЕдиницыИзмерения.Код,
	|	ТаблицаДокумента.Упаковка,
	|	ТаблицаДокумента.Характеристика,
	|	ТаблицаДокумента.НоменклатураПартнера,	
	|	ДанныеХарактеристики.НаименованиеПолное,
	|	ТаблицаДокумента.Серия.Наименование,
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	|	ТаблицаДокумента.Серия,
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки
	|	ТаблицаДокумента.НомерГТД,
	|	ЕСТЬNULL(ТаблицаДокумента.НомерГТД.ТипНомераГТД, НЕОПРЕДЕЛЕНО),
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.НомерГТД.РегистрационныйНомер = """"
	|			ТОГДА ТаблицаДокумента.НомерГТД
	|		ИНАЧЕ ТаблицаДокумента.НомерГТД.РегистрационныйНомер
	|	КОНЕЦ,
	|	ДанныеСтраныПросхождения.Ссылка,
	|	ТаблицаДокумента.Цена,
	|	ТаблицаДокумента.ЦенаДо,
	|	ТаблицаДокумента.НомерГТД,
	|	ЕСТЬNULL(ТаблицаДокумента.НомерГТД.ТипНомераГТД, НЕОПРЕДЕЛЕНО),
	|	//ГруппировкаНаборов
	|	ТаблицаДокумента.СтавкаНДС";
	
	Если ПараметрыПечати.ВыводитьНаборы Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДанныеНаборов",
		"МИНИМУМ(ТаблицаДокумента.НомерСтрокиНаборы)                     КАК НомерСтрокиНаборы,
		|	ТаблицаДокумента.ВариантПредставленияНабораВПечатныхФормах   КАК ВариантПредставленияНабораВПечатныхФормах,
		|	ТаблицаДокумента.ВариантРасчетаЦеныНабора                    КАК ВариантРасчетаЦеныНабора,
		|	ТаблицаДокумента.НоменклатураНабора                          КАК НоменклатураНабора,
		|	ТаблицаДокумента.ХарактеристикаНабора                        КАК ХарактеристикаНабора,
		|	ТаблицаДокумента.ЭтоКомплектующие                            КАК ЭтоКомплектующие,
		|	ТаблицаДокумента.ЭтоНабор                                    КАК ЭтоНабор,
		|	ТаблицаДокумента.ПолныйНабор                                 КАК ПолныйНабор,");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ГруппировкаНаборов",
		"ТаблицаДокумента.ВариантПредставленияНабораВПечатныхФормах,
		|	ТаблицаДокумента.ВариантРасчетаЦеныНабора,
		|	ТаблицаДокумента.НоменклатураНабора,
		|	ТаблицаДокумента.ХарактеристикаНабора,
		|	ТаблицаДокумента.ЭтоКомплектующие,
		|	ТаблицаДокумента.ЭтоНабор,
		|	ТаблицаДокумента.ПолныйНабор,");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СоединениеНаборов",
		"И АналитикиТаблицыТоваровСНомерамиСтрок.ВариантПредставленияНабораВПечатныхФормах = ТаблицаДокумента.ВариантПредставленияНабораВПечатныхФормах
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.ВариантРасчетаЦеныНабора = ТаблицаДокумента.ВариантРасчетаЦеныНабора
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.НоменклатураНабора = ТаблицаДокумента.НоменклатураНабора
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.ХарактеристикаНабора = ТаблицаДокумента.ХарактеристикаНабора
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.ЭтоКомплектующие = ТаблицаДокумента.ЭтоКомплектующие
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.ЭтоНабор = ТаблицаДокумента.ЭтоНабор
		|	И АналитикиТаблицыТоваровСНомерамиСтрок.ПолныйНабор = ТаблицаДокумента.ПолныйНабор");
		
	КонецЕсли;
	
	Если ПечататьСчетаФактурыПолученные Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|" +
		СтрЗаменить(ТекстЗапроса, "СчетаФактурыОснования", "СчетаФактурыПолученныеОснования");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СчетаФактурыПолученныеОснования.РеализацияЧерезКомиссионера", "ЛОЖЬ");
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ДокументОснование,
	|	//ПорядокНаборов
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка
	|;";
	
	Если ПараметрыПечати.ВыводитьНаборы Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ПорядокНаборов",
			"НомерСтрокиНаборы,
			|	НоменклатураНабора,
			|	ХарактеристикаНабора,
			|	ЭтоНабор УБЫВ,");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

&Вместо("ДобавитьКомандуСоздатьНаОсновании")
Функция РСК_ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании)

	//++ РС Консалт: Минаков А.С. Задача 245086
	Результат = ПродолжитьВызов(КомандыСозданияНаОсновании);
	
	Если Результат = Неопределено Тогда	
		Возврат Результат
	КонецЕсли;
	
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(Результат, "Партнер", Справочники.Партнеры.РозничныйПокупатель, ВидСравненияКомпоновкиДанных.НеРавно);
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(Результат, "Контрагент.ЮрФизЛицо", Перечисления.ЮрФизЛицо.ФизЛицо, ВидСравненияКомпоновкиДанных.НеРавно);
	
	Возврат Результат
	//++ РС Консалт: Минаков А.С. Задача 245086
	
КонецФункции


 