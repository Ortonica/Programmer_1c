﻿               
//++РС Консалт Назаров М.Ю. 12 сентября 2022 г. 9:26:23       
// Заполнение номенклатуры в связанных документах по контракту
Функция ЗаполнитьНоменклатуруПартнераВДокументахСДоговорами(Параметры) Экспорт
	
	Ссылка = Параметры.Ссылка;  
	ИспользоватьХарактеристикуПриСопоставлении = Параметры.ИспользоватьХарактеристикуПриСопоставлении;  
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда 
		Возврат ПараметрыСообщения("Необходимо записать объект перед выполнением данный функции");
	КонецЕсли;  
	
	ДлительныеОперации.СообщитьПрогресс(1, "Поиск договора");
	
	НоменклатураОбъектовЗакупки = Ссылка.НоменклатураОбъектовЗакупки.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Закупка.Номенклатура КАК Номенклатура,
	               |	Закупка.Характеристика КАК Характеристика,
	               |	Закупка.НоменклатураПартнера КАК НоменклатураПартнера
	               |ПОМЕСТИТЬ Закупка
	               |ИЗ
	               |	&Закупки КАК Закупка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Закупка.Номенклатура КАК Номенклатура,
	               |	Закупка.Характеристика КАК Характеристика,
	               |	Закупка.НоменклатураПартнера КАК НоменклатураПартнера
	               |ИЗ
	               |	Закупка КАК Закупка
	               |ГДЕ
	               |	Закупка.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	               |	И Закупка.НоменклатураПартнера <> ЗНАЧЕНИЕ(Справочник.НоменклатураКонтрагентов.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Закупки", НоменклатураОбъектовЗакупки);
	
	НоменклатураЗакупки = Запрос.Выполнить().Выгрузить();
	Если НоменклатураЗакупки.Количество() = 0 Тогда 
		Возврат ПараметрыСообщения("Таблица объектов закупки не содержит сопоставления номенклатуры");
	КонецЕсли;
	
	ВладельцыКонтракта = ЭлектронноеАктированиеЕИСУТ.ПолучитьВсеДоговораГосконтракта(Ссылка);
	Если ВладельцыКонтракта.Количество() = 0 Тогда                 
		Возврат ПараметрыСообщения("Не найдено договоров для правки");
	КонецЕсли;  
	
	ДлительныеОперации.СообщитьПрогресс(5, "Поиск документов");
	
	ДокументыНаЗапись = Новый Массив;
	
	ВыборкаДетальныеЗаписи = ВыбратьДокументыДоговоров(ВладельцыКонтракта);
	
	КоличествоДокументов = ВыборкаДетальныеЗаписи.Количество();  
	Счетчик = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		
		Счетчик = Счетчик + 1;
		ДлительныеОперации.СообщитьПрогресс(Окр(Счетчик * 100 / КоличествоДокументов, 0), СтрШаблон("Заполнение документов %1/%2", Счетчик, КоличествоДокументов));
		
		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		//Заполняем колонку "Номенклатура партнера"
		БылиИзмененияВДокументе = ЗаполнитьНоменклатуруПартнераВДокументе(ДокументОбъект, НоменклатураЗакупки, ИспользоватьХарактеристикуПриСопоставлении);
		
		Если БылиИзмененияВДокументе Тогда 
			
			Если ДокументОбъект.Проведен Тогда 
				РежимЗаписи = РежимЗаписиДокумента.Проведение;
			Иначе 
				РежимЗаписи = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			ПараметрыОбъекта = ПараметрыЗаписи(ДокументОбъект, РежимЗаписи);
			ДокументыНаЗапись.Добавить(ПараметрыОбъекта);
		КонецЕсли;
		
	КонецЦикла;   
	
	СообщенияРезультата = ЗаписатьОбъекты(ДокументыНаЗапись);
	
	Возврат СообщенияРезультата;
	
КонецФункции
 
Функция ЗаполнитьНоменклатуруПартнераВДокументе(Знач ДокументОбъект, Знач НоменклатураЗакупки, ИспользоватьХарактеристикуПриСопоставлении = Истина)
	
	БылиИзмененияВДокументе = Ложь;
	
	Для Каждого Закупка Из НоменклатураЗакупки Цикл 
		
		НоменклатураПоиска = Закупка.Номенклатура;
		ХарактеристикаПоиска = Закупка.Характеристика;
		НоменклатураПартнера = Закупка.НоменклатураПартнера; 
		
		Поиск = Новый Структура;
		Поиск.Вставить("Номенклатура", НоменклатураПоиска); 
		
		Если ИспользоватьХарактеристикуПриСопоставлении Тогда 
			Поиск.Вставить("Характеристика", ХарактеристикаПоиска);
		КонецЕсли;
		
		НайденныеСтроки = ДокументОбъект.Товары.НайтиСтроки(Поиск);
		Если НайденныеСтроки.Количество() = 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			
			Если Строка.НоменклатураПартнера = НоменклатураПартнера Тогда 
				Продолжить;
			КонецЕсли;                           
			
			Строка.НоменклатураПартнера = НоменклатураПартнера;
			БылиИзмененияВДокументе = Истина;
			
		КонецЦикла;  
		
	КонецЦикла;  
	
	Возврат БылиИзмененияВДокументе;

КонецФункции

Функция ВыбратьДокументыДоговоров(Договоры)
	
	Перем ВыборкаДетальныеЗаписи, Запрос, РезультатЗапроса;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Договор В (&Договоры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Договор В (&Договоры)";
	
	Запрос.УстановитьПараметр("Договоры", Договоры);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;

КонецФункции

//	в госконтракте может быть указано несколько "номенклатур" для одной "номенклатуры партнера" и наоборот
//	поэтому непонятно как их сопоставить, если связь должна быть 1:1
Процедура СопоставитьНоменклатуруПартнеров(Объект)
	
	НоменклатураЗапись = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураЗакупки.НоменклатураПартнера КАК НоменклатураПартнера,
	               |	НоменклатураЗакупки.Номенклатура КАК Номенклатура
	               |ПОМЕСТИТЬ НоменклатураЗакупки
	               |ИЗ
	               |	&НоменклатураЗакупки КАК НоменклатураЗакупки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВтТаблица.Номенклатура КАК НоменклатураКонтракта,
	               |	ВтТаблица.НоменклатураПартнера КАК НоменклатураПартнера,
	               |	НоменклатураКонтрагентов.Номенклатура КАК УказаннаяНоменклатура
	               |ИЗ
	               |	НоменклатураЗакупки КАК ВтТаблица
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
	               |		ПО ВтТаблица.НоменклатураПартнера = НоменклатураКонтрагентов.Ссылка";
	
	Запрос.УстановитьПараметр("НоменклатураЗакупки", Объект.НоменклатураОбъектовЗакупки.Выгрузить());
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		НоменклатураПартнера = Выборка.НоменклатураПартнера;
		НоменклатураКонтракта = Выборка.НоменклатураКонтракта;
		СопоставленнаяНоменклатура = Выборка.УказаннаяНоменклатура;
		
		НоменклатураЗаполнена = ЗначениеЗаполнено(НоменклатураКонтракта);
		НоменклатураПартнераЗаполнена = ЗначениеЗаполнено(НоменклатураПартнера);
		СопоставлениеЗаполнено = ЗначениеЗаполнено(СопоставленнаяНоменклатура);
		
		Если Не НоменклатураЗаполнена Тогда 
			Продолжить;
		КонецЕсли;    
		
		Если Не НоменклатураПартнераЗаполнена Тогда 
			
			НоменклатураПартнераОбъект = Справочники.НоменклатураКонтрагентов.СоздатьЭлемент();
			НоменклатураПартнераОбъект.Заполнить(Неопределено);
			
			НоменклатураПартнераОбъект.Номенклатура = НоменклатураКонтракта;
			
			ПараметрыОбъекта = ПараметрыЗаписи(НоменклатураПартнераОбъект, Неопределено);
			НоменклатураЗапись.Добавить(ПараметрыОбъекта);
			
			Продолжить; 
			
		КонецЕсли;
		
		Если Не СопоставлениеЗаполнено Или (НоменклатураКонтракта <> СопоставленнаяНоменклатура) Тогда 
			// необходимо заполнить поле "Номенклатура" в номенклатуре партнера
			
			НоменклатураПартнераОбъект = НоменклатураПартнера.ПолучитьОбъект();
			НоменклатураПартнераОбъект.Номенклатура = НоменклатураКонтракта;
			
			ПараметрыОбъекта = ПараметрыЗаписи(НоменклатураПартнераОбъект, Неопределено);
			НоменклатураЗапись.Добавить(ПараметрыОбъекта);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаписатьОбъекты(НоменклатураЗапись);
	
КонецПроцедуры
         
Функция ПараметрыЗаписи(Знач ДокументОбъект, Знач РежимЗаписи)
	
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Объект", ДокументОбъект);
	ПараметрыОбъекта.Вставить("РежимЗаписи", РежимЗаписи);
	
	Возврат ПараметрыОбъекта;

КонецФункции

Функция ЗаписатьОбъекты(Знач ОбъектыНаЗапись)
	
	СообщенияВозврат = Новый Массив; 
	
	КоличествоОбъектов = ОбъектыНаЗапись.Количество();
	
	Если ОбъектыНаЗапись.Количество() = 0 Тогда 
		Возврат ПараметрыСообщения("Не найдено объектов для правки");		
	КонецЕсли;  
	
	Счетчик = 0; 
	
	Для Каждого ПараметрыОбъекта Из ОбъектыНаЗапись Цикл 
		
		Счетчик = Счетчик + 1;     
		Текст = ""; 
		Ключ = Неопределено;
		
		ОбъектЗапись = ПараметрыОбъекта.Объект;
		РежимЗаписи = ПараметрыОбъекта.РежимЗаписи;
		
		Описание = СтрШаблон("Запись объектов %1/%2", Счетчик, КоличествоОбъектов);
		ДлительныеОперации.СообщитьПрогресс(Окр(Счетчик * 100 / КоличествоОбъектов, 0), Описание);
		
		Попытка
			ОбъектЗапись.Заблокировать();
			
			Попытка             
				Если РежимЗаписи <> Неопределено Тогда 
					ОбъектЗапись.Записать(РежимЗаписи);
				Иначе 
					ОбъектЗапись.Записать();
				КонецЕсли;  
				
				Текст = "Записан объект: " + ОбъектЗапись.Ссылка;
				Ключ = ОбъектЗапись.Ссылка;
				
			Исключение
				Текст = "Не удалось записать объект:" + ОбъектЗапись + " по причине: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;    
			
		Исключение                                                                                                                                      
			Текст = "Не удалось заблокировать объект для записи:" + ОбъектЗапись + " по причине: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;   
		
		Сообщение = ПараметрыСообщения(Текст, Ключ);

		СообщенияВозврат.Добавить(Сообщение);               
		
	КонецЦикла;    
	
	Возврат СообщенияВозврат;
	
КонецФункции

Функция ПараметрыСообщения(Знач Текст = "", Знач Ключ = Неопределено)
	
	Перем Сообщение;
	
	Сообщение = Новый Структура("Текст, Ключ", Текст, Ключ);
	
	Возврат Сообщение;
	
КонецФункции

//--РС Консалт Назаров М.Ю. 12 сентября 2022 г. 9:26:23

//++РС Консалт Назаров М.Ю. 8 ноября 2022 г. 6:55:53
// Создание заказов по этапам контракта
Функция СозданиеЗаказовПоКонтракту(Параметры) Экспорт 
	
	ГосКонтракт = Параметры.ГосКонтракт;

	Заказы = ПоискЗаказаПоСделке(ГосКонтракт.РСК_Сделка, ГосКонтракт);
	Если Заказы.Количество() > 0 Тогда 
		Возврат ПараметрыСообщения(СтрШаблон("По контракту %1 уже создан заказ", ГосКонтракт.Ссылка));
	КонецЕсли;
	
	НовыеДокументы = СоздатьЗаказПоКонтракту(ГосКонтракт);
		
	СообщенияРезультата = ЗаписатьОбъекты(НовыеДокументы);
	
	Возврат СообщенияРезультата;
	
КонецФункции  

Функция СоздатьЗаказПоКонтракту(ГосКонтракт)
	
	НоменклатураТЗ = ГосКонтракт.НоменклатураОбъектовЗакупки; 
	ОбъектыЗакупки = ГосКонтракт.ОбъектыЗакупки;   
	Этапы = ГосКонтракт.ЭтапыИсполнения;
	
	НовыеДокументы = Новый Массив;  
	
	Идентификатор = Этапы[0].Идентификатор;
		
	НовыйЗК = Документы.ЗаказКлиента.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(НовыйЗК, ГосКонтракт, "Организация, Контрагент");
	
	
	//НовыйЗК.ЭтапГосконтрактаЕИС = Идентификатор;
	НовыйЗК.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	НовыйЗК.Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
	НовыйЗК.Автор = Пользователи.ТекущийПользователь();
	НовыйЗК.Менеджер = Пользователи.ТекущийПользователь();
	НовыйЗК.Партнер = ГосКонтракт.Контрагент.Партнер;
	НовыйЗК.Приоритет = Справочники.Приоритеты.НайтиПоНаименованию("Высокий");
	НовыйЗК.СпособДоставки = Перечисления.СпособыДоставки.Самовывоз;
	НовыйЗК.Сделка = ГосКонтракт.РСК_Сделка;
	НовыйЗК.Подразделение = Справочники.СтруктураПредприятия.НайтиПоНаименованию("Департамент продаж ГЗ");
	
	Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	ВладельцыКонтракта = ЭлектронноеАктированиеЕИСУТ.ПолучитьВсеДоговораГосконтракта(ГосКонтракт);
	Если ВладельцыКонтракта.Количество() > 0 Тогда                 
		Договор = ВладельцыКонтракта[0].Значение;	
	КонецЕсли;  
	НовыйЗК.Договор = Договор;
	
	ДатаДокумента = Договор.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда 
		ДатаДокумента = Договор.ДатаНачалаДействия;
		Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда 
			ДатаДокумента = ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	
	НовыйЗК.Дата = ДатаДокумента;
	
	Для Каждого Товар Из ОбъектыЗакупки Цикл 
		
		Отбор = Новый Структура;
		Отбор.Вставить("Идентификатор", Товар.Идентификатор);
		НайденныеСтроки = НоменклатураТЗ.НайтиСтроки(Отбор);
		Для Каждого Строка из НайденныеСтроки Цикл 
			
			НоваяСтрока = НовыйЗК.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.КоличествоУпаковок = Строка.Количество;
			НоваяСтрока.Цена = Товар.Цена; 
			НоваяСтрока.Сумма = НоваяСтрока.Цена * НоваяСтрока.КоличествоУпаковок;
			НоваяСтрока.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.КОбеспечению;
			
			// + Обработчик КоличествоПриИзменении
			СтруктураДействий = Новый Структура;
			
			СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(НовыйЗК);
			СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
			СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
			СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
			СтруктураДействий.Вставить("ПересчитатьСумму");    
			
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, Неопределено);
			// - Обработчик КоличествоПриИзменении
			
		КонецЦикла;
		
	КонецЦикла;
	
	НовыйЗК.Соглашение = СоглашениеДляЗаказов();		
	НовыйЗК.ЗаполнитьУсловияПродажПоСоглашению(Ложь);
	
	НовыйЗК.БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(НовыйЗК.Контрагент);
	ДенежныеСредстваСервер.ПроверитьЗаполнитьБанковскийСчетОрганизацииПоВладельцу(НовыйЗК.Организация, НовыйЗК.БанковскийСчет, , НовыйЗК.НаправлениеДеятельности);
	ДенежныеСредстваСервер.ПроверитьЗаполнитьКассуОрганизацииПоВладельцу(НовыйЗК.Организация, НовыйЗК.Касса, НовыйЗК.ФормаОплаты, НовыйЗК.НаправлениеДеятельности, НовыйЗК.Курьер);
	
	// + Обработчик НалогооблажениеПриИзменении
	КэшированныеЗначенияСлужебный = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС",
	ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(НовыйЗК, Ложь, НовыйЗК.ВернутьМногооборотнуюТару));
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(НовыйЗК.Товары, СтруктураДействий, КэшированныеЗначенияСлужебный);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(НовыйЗК);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначенияСлужебный.ОбработанныеСтроки, СтруктураДействий, Неопределено);
	// - Обработчик НалогооблажениеПриИзменении
	
	НовыйЗК.СуммаДокумента = НовыйЗК.ПолучитьСуммуЗаказанныхСтрок(); 
	
	// + Этапы оплаты
	// Заполнение графика этапов оплаты на основае этапов гос. контракта
	НовыйЗК.ЭтапыГрафикаОплаты.Очистить();
	
	Для Каждого Этап Из Этапы Цикл 
		НовыйЭтап = НовыйЗК.ЭтапыГрафикаОплаты.Добавить();
		НовыйЭтап.ВариантОплаты = Перечисления.ВариантыКонтроляОплатыКлиентом.КредитСдвиг;
		НовыйЭтап.ВариантОтсчета = Перечисления.ВариантыОтсчетаДатыПлатежа.ОтДатыОтгрузки;
		НовыйЭтап.ДатаПлатежа = Этап.ДатаОкончания;
		
		НовыйЭтап.СуммаПлатежа = Этап.Цена;
		Если НовыйЭтап.СуммаПлатежа = 0 
			И Этапы.Количество() = 1 Тогда 
			НовыйЭтап.СуммаПлатежа = НовыйЗК.СуммаДокумента;
		КонецЕсли;
		
	КонецЦикла; 
	
	ЭтапыОплатыСервер.ЗаполнитьПроцентыПоСуммам(НовыйЗК.ЭтапыГрафикаОплаты);
	// - Этапы оплаты
	
	ПараметрыОбъекта = ПараметрыЗаписи(НовыйЗК, РежимЗаписиДокумента.Запись);
	
	НовыеДокументы.Добавить(ПараметрыОбъекта);
	
	Возврат НовыеДокументы;
	
КонецФункции

Функция СоглашениеДляЗаказов()
	
	Возврат Справочники.СоглашенияСКлиентами.НайтиПоНаименованию("Государственные заказчики (30 КД)");

КонецФункции
      
Функция ПоискЗаказаПоСделке(Знач Сделка, Знач Контракт) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента 
	|Где 
	|ЗаказКлиента.Сделка = &Сделка 
	|И ЗаказКлиента.Договор.ГосударственныйКонтракт = &Контракт 
	|И ЗаказКлиента.Дата > &ДатаНачалаОтсчета
	|И ЗаказКлиента.ПометкаУдаления = Ложь";   
	
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("Контракт", Контракт);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДатаНачалаОтсчета", РСК_ВызовСервера.ДатаНачалоОтсчетаПоискаЗаказовКлиентаЭДО());
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();   
	
	Если Не ЗначениеЗаполнено(Сделка) Или Не ЗначениеЗаполнено(Контракт) Тогда 
		РезультатЗапроса.Очистить();
		Возврат РезультатЗапроса;
	КонецЕсли;
	
	Возврат РезультатЗапроса;
	
КонецФункции


//--РС Консалт Назаров М.Ю. 8 ноября 2022 г. 6:55:53