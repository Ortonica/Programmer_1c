﻿
&ИзменениеИКонтроль("УстановитьВидимостьПоляВыбораЭтаповГосконтракта")
Процедура РСК_УстановитьВидимостьПоляВыбораЭтаповГосконтракта(Форма, Договор)

	ДанныеГосконтракта = ЭлектронноеАктированиеЕИС.ДанныеГосконтрактаПоВладельцу(Договор);
	ТаблицаЭтапов = ДанныеГосконтракта.ТаблицаЭтапов;      
	#Удаление
	Если ЗначениеЗаполнено(ТаблицаЭтапов) И ТаблицаЭтапов.Количество() > 1 Тогда
		#КонецУдаления
		#Вставка
		//++РС Консалт Назаров М.Ю. 8 сентября 2022 г. 9:31:18                  
		Если ЗначениеЗаполнено(ТаблицаЭтапов) И ТаблицаЭтапов.Количество() > 0 Тогда			
		//--РС Консалт Назаров М.Ю. 8 сентября 2022 г. 9:31:18
		#КонецВставки
		Форма.Элементы.ЭтапГосконтрактаЕИС.Видимость = Истина;
		Если ЗначениеЗаполнено(Форма.Объект.ЭтапГосконтрактаЕИС) Тогда
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Идентификатор", Форма.Объект.ЭтапГосконтрактаЕИС);
			НайденныйЭтап = ТаблицаЭтапов.НайтиСтроки(ПараметрыОтбора);
			Если ЗначениеЗаполнено(НайденныйЭтап) Тогда
				Форма.ПредставлениеЭтапаГосконтрактаЕИС = СформироватьПредставлениеЭтапаГосконтракта(НайденныйЭтап[0]);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Форма.Элементы.ЭтапГосконтрактаЕИС.Видимость = Ложь;
	КонецЕсли; 

КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьМестаПоставкиПриложенияЕИСПоДаннымУчастника")
Процедура РСК_ЗаполнитьМестаПоставкиПриложенияЕИСПоДаннымУчастника(СведенияОбУчастнике, СтрокаУчастника, ВидУчастника, ДанныеПриложенияЕИС, ДатаСведений)
	
	Если ВРег(ВидУчастника) = ВРег("СведенияОПокупателе") Тогда
		ИдентификаторУчастника = ЭлектронноеАктированиеЕИС.НачальныйИндексИнформацииУчастникаПокупателя();
	ИначеЕсли ВРег(ВидУчастника) = ВРег("СведенияОГрузополучателе") Тогда
		ИдентификаторУчастника = ЭлектронноеАктированиеЕИС.НачальныйИндексИнформацииУчастникаГрузополучателя();
	КонецЕсли;
	
	СтрокаУчастника.ИнформацияДляУчастника = ИдентификаторУчастника;

	АдресУчастника = Новый Структура();
	СведенияОбУчастнике.Вставить("ДатаКИ", ДатаСведений);
	#Вставка
	//++РС Консалт Назаров М.Ю. 28 сентября 2022 г. 12:34:22 Необходимо чтобы переназначать адрес из документа в функции ПолучитьАдресСтруктурой()
	Если ДанныеПриложенияЕИС.Свойство("ДокументОснование") Тогда 
		СведенияОбУчастнике.Вставить("ДокументОснование", ДанныеПриложенияЕИС.ДокументОснование);
	КонецЕсли;
	//--РС Консалт Назаров М.Ю. 28 сентября 2022 г. 12:34:22
	#КонецВставки
	ОбменСКонтрагентамиУТ.ПолучитьАдресСтруктурой(АдресУчастника, СведенияОбУчастнике, "Ссылка", "Факт");
	
	Если ЗначениеЗаполнено(АдресУчастника) Тогда
		МестоПоставки = ЭлектронноеАктированиеЕИС.НовыеСведенияОМестеПоставкиТовара();
		МестоПоставки.Место = АдресУчастника.АдресТекст;
		МестоПоставки.Наименование = АдресУчастника.АдресТекст;
		МестоПоставки.Классификатор = ЭлектронноеАктированиеЕИС.МестоПоставкиПоКЛАДР();
		МестоПоставки.РайонИлиГород = "-";
		МестоПоставки.НаселенныйПункт = "-";
		Если АдресУчастника.Свойство("КодРегиона")
			И ЗначениеЗаполнено(АдресУчастника.КодРегиона) Тогда
			МестоПоставки.Код = ЭлектронноеАктированиеЕИС.КодКЛАДРПроизвольногоАдреса(
				АдресУчастника.КодРегиона);
		Иначе
			Шаблон = НСтр("ru = 'Не удалось определить код региона адреса: %1';
							|en = 'Cannot define the address region code: %1'");
			ТекстОшибки = СтрШаблон(Шаблон, АдресУчастника.АдресТекст);
			ЭлектронноеАктированиеЕИС.ДобавитьОшибкуЗаполненияПриложения(ДанныеПриложенияЕИС, ТекстОшибки);
			Возврат;
		КонецЕсли;
		Если СведенияОбУчастнике.Свойство("ИдентификаторМестаПоставкиЕИС") Тогда
			ИдентификаторМеста = СведенияОбУчастнике.ИдентификаторМестаПоставкиЕИС;
			ДанныеПриложенияЕИС.МестаПоставки.Очистить();
		Иначе
			ИдентификаторМеста = Строка(Новый УникальныйИдентификатор);
			ИдентификаторМеста = СтрЗаменить(ИдентификаторМеста, "-", "");
		КонецЕсли;
		МестоПоставки.Идентификатор = ИдентификаторМеста;
		МестоПоставки.ИдентификаторУчастника = ИдентификаторУчастника;
		ДанныеПриложенияЕИС.МестаПоставки.Добавить(МестоПоставки);
	КонецЕсли;
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьДанныеПоСтрокеТоваровУПД_2019")
Процедура РСК_ЗаполнитьДанныеПоСтрокеТоваровУПД_2019(НоваяСтрокаЭД, СтрокаВыборки, СтруктураДанных, ДанныеПриложенияЕИС)

	ДанныеЭлектронногоАктированияЕИС = СтруктураДанных.ДанныеЭлектронногоАктирования;
	
	ДанныеПоДетализации = ДанныеЭлектронногоАктированияЕИС.ДанныеПоДетализации;
	СтрокиДокумента = ДанныеЭлектронногоАктированияЕИС.ДанныеСтрокАктированияЕИС;
	
	ИдентификаторСтроки = СтрокаВыборки.НоменклатураПартнера;
	СтрокаДокумента = СтрокиДокумента.Найти(ИдентификаторСтроки, "НоменклатураПартнера");
	#Вставка
	//++ РС КОНСАЛТ Назаров М.Ю. 30.09.2022
	//Поиск стандартно ищет по ссылке "Номенклатуры партнера" и если в гос контракте повторяется ссылка, 
	// может неверно выбрать номенклатуру, 
	// поэтому сначала ищем в таблице НоменклатураОбъектовЗакупки (по НоменклатураПартнера, Номенклатура, Характеристика)
	// берем идентификатор, и по нему ищем строку в Объектах закупки
	НоменклатураОбъектовЗакупки = ДанныеПриложенияЕИС.ГосударственныйКонтракт.НоменклатураОбъектовЗакупки;
	ПоискСтрокиДокументаПоНоменклатуреХарактеристикеИНоменклатуреПартнера(СтрокаДокумента, СтрокаВыборки, НоменклатураОбъектовЗакупки, СтрокиДокумента);
	//-- РС КОНСАЛТ Назаров М.Ю. 30.09.2022
	#КонецВставки
	Если НЕ ЗначениеЗаполнено(СтрокаДокумента) Тогда
		Шаблон = НСтр("ru = 'Не найдена строка госконтракта по идентификатору %1.';
						|en = 'The state contract line by the %1 ID is not found.'");
		ТекстОшибки = СтрШаблон(Шаблон, ИдентификаторСтроки);
		ЭлектронноеАктированиеЕИС.ДобавитьОшибкуЗаполненияПриложения(
			ДанныеПриложенияЕИС, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// Замена кода и наименования товара в УПД на данные из контракта.
	НоваяСтрокаЭД.ТоварКод = СтрокаДокумента.КодТовараДляЕИС;
	НоваяСтрокаЭД.ТоварНаименование = СтрокаДокумента.Наименование;
	// Цена за единицу указывается с точностью до 11 цифр.
	НоваяСтрокаЭД.ЦенаЗаЕдиницуИзмерения = СтрокаДокумента.ЦенаЗаЕдиницуИзмерения;
	
	ИдентификаторДляАктированияЕИС = СтрокаДокумента.ИдентификаторДляАктированияЕИС;
	СтрокаДетализации = ДанныеПоДетализации[ИдентификаторДляАктированияЕИС];
	ЕстьДетализация = СтрокаДетализации.КоличествоСтрок > 1;
	ВерсияФорматаВерсииСхем12 = "1.11";
	Если НЕ ЭлектронноеАктированиеЕИС.ВерсияФормата() = ВерсияФорматаВерсииСхем12 Тогда
		// С 13 версии схем детализация не используется.
		ЕстьДетализация = Ложь;
	КонецЕсли;
	
	// Определяем вид ТРУ.
	ВидТРУ = ЭлектронноеАктированиеЕИС.ОпределитьВидТРУДляУПД(СтрокаДокумента.Тип);
	ЭтоРаботаИлиУслуга = СтрокаДокумента.ЭтоРаботаИлиУслуга;
	// Устанавливаем признак в строке УПД.
	НоваяСтрокаЭД.Признак = Строка(ВидТРУ);
	
	Если ЕстьДетализация Тогда
		Если НЕ ЗначениеЗаполнено(СтрокаДетализации.ДанныеРодителя) Тогда
			// создаем родителя
			ДанныеРодителя = ЭлектронноеАктированиеЕИС.НовыеДетализированныеСведенияОТРУ();
			СведенияОРодительскойПозиции = ДанныеРодителя.СведенияОРодительскойПозиции;
			
			СведенияОРодительскойПозиции.Идентификатор =
				ИдентификаторДляАктированияЕИС;
			СведенияОРодительскойПозиции.ТехническийИдентификатор =
				СтрокаДокумента.ВнутреннийИдентификаторЕИС;
			СведенияОРодительскойПозиции.ВнешнийТехническийИдентификатор =
				СтрокаДокумента.ВнешнийИдентификатор;
			СведенияОРодительскойПозиции.Код = СтрокаДокумента.КодТовараДляЕИС;
			
			СведенияОРодительскойПозиции.Наименование = СтрокаДокумента.Наименование;
			СведенияОРодительскойПозиции.Вид = ВидТРУ;
			СведенияОРодительскойПозиции.КодЕдиницыИзмерения = НоваяСтрокаЭД.ЕдиницаИзмеренияКод;
			СведенияОРодительскойПозиции.ЦенаЗаЕдиницу = НоваяСтрокаЭД.ЦенаЗаЕдиницуИзмерения;
			СведенияОРодительскойПозиции.Количество = НоваяСтрокаЭД.Количество;
			СведенияОРодительскойПозиции.СтоимостьБезНалогов = НоваяСтрокаЭД.СтоимостьТоваровБезНалога;
			СтавкаНДСДляПриложенияЕИС(СтрокаВыборки.СтавкаНДС, СведенияОРодительскойПозиции.НалоговаяСтавка);
			СведенияОРодительскойПозиции.СтоимостьСНалогами = НоваяСтрокаЭД.СтоимостьТоваровСНалогом;
			СведенияОРодительскойПозиции.СуммаНалога = НоваяСтрокаЭД.СуммаНалога;
			СведенияОРодительскойПозиции.СуммаАкциза = НоваяСтрокаЭД.СуммаАкциза;
			
			Если НЕ ЭтоРаботаИлиУслуга Тогда
				// Страна происхождения не указывается для услуг.
				Если ЗначениеЗаполнено(СтрокаВыборки.СтранаПроисхождения) Тогда
					СведенияОРодительскойПозиции.КодСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Код;
					СведенияОРодительскойПозиции.НаименованиеСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Наименование;
				КонецЕсли;
			КонецЕсли;
			
			СтрокаДетализации.ДанныеРодителя = ДанныеРодителя;
			
			// Добавляем строку родителя, остальные строки добавляются как дочерние позиции.
			ДанныеПриложенияЕИС.СведенияОТоварах.ТоварыРаботыУслуги.Добавить(ДанныеРодителя);
			
		Иначе
			
			ДанныеРодителя = СтрокаДетализации.ДанныеРодителя;
			СведенияОРодительскойПозиции = ДанныеРодителя.СведенияОРодительскойПозиции;
			СведенияОРодительскойПозиции.Количество = СведенияОРодительскойПозиции.Количество + НоваяСтрокаЭД.Количество;
			СведенияОРодительскойПозиции.СтоимостьСНалогами = СведенияОРодительскойПозиции.СтоимостьСНалогами + НоваяСтрокаЭД.СтоимостьТоваровСНалогом;
			СведенияОРодительскойПозиции.СтоимостьБезНалогов = СведенияОРодительскойПозиции.СтоимостьБезНалогов + НоваяСтрокаЭД.СтоимостьТоваровБезНалога;
			СведенияОРодительскойПозиции.СуммаНалога = СведенияОРодительскойПозиции.СуммаНалога + НоваяСтрокаЭД.СуммаНалога;
			СведенияОРодительскойПозиции.СуммаАкциза = СведенияОРодительскойПозиции.СуммаАкциза + НоваяСтрокаЭД.СуммаАкциза;
			
		КонецЕсли;
		
		СведенияОДочернейПозиции = ЭлектронноеАктированиеЕИС.НовыеСведенияОДочернейПозицииТРУ();
		ИдентификаторНоменклатуры = СтрокаВыборки.Номенклатура.УникальныйИдентификатор();
		СведенияОДочернейПозиции.Идентификатор = СтрЗаменить(ИдентификаторНоменклатуры, "-", "");
		#Вставка
		//++ РС КОНСАЛТ Петров А.В. 12.10.2022
		//В таблице товаров контракта номенклатура в виде дерева
		//Из-за этого, если в 1 ветвь попадают одинаковые номенклатуры, даже с разными харакатеристиками
		//Каждой номенклатуре назначается идентификатор предыдущей, из-за чего возникает ошибка интеграционного контроля
		//Добавляем к идентификатору номер строки
		ИдентификаторНоменклатуры = Лев(ИдентификаторНоменклатуры, 31);
		ИдентификаторНоменклатуры = Строка(ИдентификаторНоменклатуры) + СтрокаВыборки.НомерСтроки;
		ИдентификаторНоменклатуры = СтрЗаменить(ИдентификаторНоменклатуры, "-", "");
		Пока СтрДлина(ИдентификаторНоменклатуры) <> 32 Цикл
			ИдентификаторНоменклатуры = ИдентификаторНоменклатуры + СтрокаВыборки.НомерСтроки;	
		КонецЦикла;
		//-- РС КОНСАЛТ Петров А.В. 12.10.2022
		СведенияОДочернейПозиции.Идентификатор = ИдентификаторНоменклатуры;
		#КонецВставки
			
		СведенияОДочернейПозиции.НомерСтрокиТаблицы = СтрокаВыборки.НомерСтроки;
		
		Если НоваяСтрокаЭД.Количество > 0 Тогда
			СведенияОДочернейПозиции.ЦенаЗаЕдиницуСНДС = НоваяСтрокаЭД.СтоимостьТоваровСНалогом / НоваяСтрокаЭД.Количество;
		Иначе
			СведенияОДочернейПозиции.ЦенаЗаЕдиницуСНДС = НоваяСтрокаЭД.СтоимостьТоваровСНалогом;
		КонецЕсли;
		
		Если НЕ ЭтоРаботаИлиУслуга Тогда

			Если ЗначениеЗаполнено(СтрокаВыборки.СтранаПроисхождения) Тогда
				СведенияОДочернейПозиции.КодСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Код;
				СведенияОДочернейПозиции.НаименованиеСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Наименование;
			КонецЕсли;
			
			МестоПоставки = ЭлектронноеАктированиеЕИС.НовыеСведенияОМестеПоставкиТоварнойПозиции();
			МестоПоставки.Идентификатор = НоваяСтрокаЭД.ИдентификаторМестаПоставкиЕИС;
			МестоПоставки.ПоставляемоеКоличество = НоваяСтрокаЭД.Количество; 
			СведенияОДочернейПозиции.СведенияОМестахПоставкиТовара.Добавить(МестоПоставки);
			
		КонецЕсли;
		СведенияОДочернейПозиции.ПризнакПоставкиОбъектаЗакупкиСУлучшеннымиХарактеристиками = 1;
		
		ДанныеРодителя.СведенияОДочернихПозициях.Добавить(СведенияОДочернейПозиции);
		
	Иначе
		
		// Без детализации.
		СтрокаПриложения = ЭлектронноеАктированиеЕИС.НовыеНедетализированныеСведенияОТРУ();
		СтрокаПриложения.Идентификатор = ИдентификаторДляАктированияЕИС;
		СтрокаПриложения.НомерСтрокиТаблицы = НоваяСтрокаЭД.НомерСтроки;
		Если ЭтоРаботаИлиУслуга Тогда
			Если ЗначениеЗаполнено(СтрокаДокумента.ОбъемРаботыУслуги) Тогда
				// Количество указывается в текстовом выражении.
				СтрокаПриложения.ОбъемВТекстовомВыражении = СтрокаДокумента.ОбъемРаботыУслуги;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаПриложения.ЦенаИзКонтрактаСНДС = СтрокаДокумента.Цена;
		СтрокаПриложения.ИсходноеНаименование = СтрокаДокумента.Наименование;
		
		СтрокаПриложения.ТехническийИдентификатор = СтрокаДокумента.ВнутреннийИдентификаторЕИС;
		СтрокаПриложения.ВнешнийТехническийИдентификатор = СтрокаДокумента.ВнешнийИдентификатор;
		
		Если НЕ ЭтоРаботаИлиУслуга Тогда
			Если ЗначениеЗаполнено(СтрокаВыборки.СтранаПроисхождения) Тогда
				СтрокаПриложения.КодСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Код;
				СтрокаПриложения.НаименованиеСтраныПроисхождения = СтрокаВыборки.СтранаПроисхождения.Наименование;
			Иначе
				Если НЕ СтрокаДокумента.СтранаПроисхожденияКонтракт.Пустая() Тогда
					СтрокаПриложения.КодСтраныПроисхождения = СтрокаДокумента.СтранаПроисхожденияКонтракт.Код;
					СтрокаПриложения.НаименованиеСтраныПроисхождения = СтрокаДокумента.СтранаПроисхожденияКонтракт.Наименование;
				КонецЕсли;
			КонецЕсли;
			Если НЕ СтрокаДокумента.СтранаПроизводителяКонтракт.Пустая() Тогда
				СтрокаПриложения.КодСтраныПроизводителя = СтрокаДокумента.СтранаПроизводителяКонтракт.Код;
				СтрокаПриложения.НаименованиеСтраныПроизводителя = СтрокаДокумента.СтранаПроизводителяКонтракт.Наименование;
			КонецЕсли;
		КонецЕсли;
		
		// Признак поставки объекта закупки с улучшенными характеристиками:
		// - 1 - не установлен;
		// - 2 - установлен из информации о контракте;
		// - 3 - установлен пользователем.
		// Игнорируется для авансовых СЧФ.
		// Игнорируется при приеме исправления к документу, который был подписан до версии 11.2.
		// В других случаях контролируется обязательное заполнение.
		// Если для позиции ТРУ в сведениях о контракте установлен одноименный признак, то контролируется, что в составе данного атрибута указано значение "2 - установлен из информации о контракте".
		// Если для позиции ТРУ в сведениях о контракте НЕ установлен одноименный признак, то контролируется, что в составе данного атрибута указано значение, отличное от "2 - установлен из информации о контракте".
		// В исправлении редактирование данного признака допускается только в том случае, если:
		// - статус документа, к которому формируется исправление - «Отказано при рассмотрении»
		// - в сведениях о контракте для данной позиции не установлен признак поставки объекта закупки с улучшенными характеристиками.
		СтрокаПриложения.ПризнакПоставкиОбъектаЗакупкиСУлучшеннымиХарактеристиками = 1;
		
		Если НЕ ЭтоРаботаИлиУслуга Тогда
			МестоПоставки = ЭлектронноеАктированиеЕИС.НовыеСведенияОМестеПоставкиТоварнойПозиции();
			МестоПоставки.Идентификатор = НоваяСтрокаЭД.ИдентификаторМестаПоставкиЕИС;
			МестоПоставки.ПоставляемоеКоличество = НоваяСтрокаЭД.Количество; 
			СтрокаПриложения.СведенияОМестахПоставкиТовара.Добавить(МестоПоставки);
		КонецЕсли;
		
		ДанныеПриложенияЕИС.СведенияОТоварах.ТоварыРаботыУслуги.Добавить(СтрокаПриложения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоискСтрокиДокументаПоНоменклатуреХарактеристикеИНоменклатуреПартнера(СтрокаДокумента, Знач Выборка, Знач ТаблицаПоиска, Знач СтрокиДокумента)
	
	ПоискСтроки = Новый Структура("НоменклатураПартнера, Номенклатура, Характеристика");
	ПоискСтроки.НоменклатураПартнера = Выборка.НоменклатураПартнера;
	ПоискСтроки.Номенклатура = Выборка.Номенклатура;
	ПоискСтроки.Характеристика = Выборка.Характеристика;
	
	НайденныеСтроки = ТаблицаПоиска.НайтиСтроки(ПоискСтроки);
	Если НайденныеСтроки.Количество() > 0 Тогда 
		Идентификатор = НайденныеСтроки[0].Идентификатор;
		СтрокаДокумента = СтрокиДокумента.Найти(Идентификатор, "Идентификатор");
	КонецЕсли;
	
КонецПроцедуры

&ИзменениеИКонтроль("ПередЗаписьюДокумента")
Процедура РСК_ПередЗаписьюДокумента(Договор, ТаблицаТоваров)

	ОчищатьНоменклатуруПартнера = Ложь;

	Если ЗначениеЗаполнено(Договор) Тогда 	
		ГосконтрактДоговора = ЭлектронноеАктированиеЕИС.ГосударственныйКонтрактДоговора(Договор);
		Если ЗначениеЗаполнено(ГосконтрактДоговора) И ЗначениеЗаполнено(ГосконтрактДоговора.ВнутреннийИдентификаторЕИС) Тогда
			ОчищатьНоменклатуруПартнера = Ложь;
		Иначе
			ОчищатьНоменклатуруПартнера = Истина;
		КонецЕсли;
	Иначе  
		#Удаление
		ОчищатьНоменклатуруПартнера = Истина;
		#КонецУдаления 
		#Вставка
		ОчищатьНоменклатуруПартнера = Ложь;
		#КонецВставки
	КонецЕсли;

	Если ОчищатьНоменклатуруПартнера Тогда
		Для Каждого СтрокаТовары Из ТаблицаТоваров Цикл
			СтрокаТовары.НоменклатураПартнера = Справочники.НоменклатураКонтрагентов.ПустаяСсылка();
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("УстановкаВидимостиГруппыГосконтракта")
Процедура РСК_УстановкаВидимостиГруппыГосконтракта(Форма, ЭтоЗаказКлиента)

	ВидимостьНоменклатурыПартнера = Ложь;
	ИспользоватьЕИС = Истина;
	#Вставка
	//++РС Консалт: Минаков А.С.
	ВидимостьНоменклатурыПартнера = Истина;
	//++РС Консалт: Минаков А.С.
	#КонецВставки
	
	Если Не ЭлектронноеАктированиеЕИС.ИспользоватьЭлектронноеАктированиеВЕИС() Тогда
		ИспользоватьЕИС = Ложь;
	КонецЕсли;
	
	Договор = Форма.Объект.Договор;
	Если ЗначениеЗаполнено(Договор.ГосударственныйКонтракт) И ИспользоватьЕИС Тогда
		Форма.Элементы.ГруппаГосКонтракт.Видимость = Истина;
		Форма.ГосКонтракт = Договор.ГосударственныйКонтракт;
		УстановитьВидимостьПоляВыбораЭтаповГосконтракта(Форма, Договор);
		Если ЗначениеЗаполнено(Договор.ГосударственныйКонтракт.ВнутреннийИдентификаторЕИС) Тогда
			Форма.ЭтоГосконтрактЕИС = Истина;
			ВидимостьНоменклатурыПартнера = Истина;
			Форма.Элементы.ГруппаФайлыЕИС.Видимость = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.ГруппаГосКонтракт.Видимость = Ложь;
	КонецЕсли;
	#Вставка
	//+РС Консалт Назаров М.Ю. 02.12.2022 8:53:28 
	// Отображение кнопки в зависимости от договора и документа   
	ИмяКнопки = "ФормаРС_ПрикрепитьПриложенияЕИС";
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") 
		И Форма.Элементы.Найти(ИмяКнопки) <> Неопределено Тогда 
		
		Форма.Элементы[ИмяКнопки].Видимость = ЗначениеЗаполнено(Договор.ГосударственныйКонтракт) И ИспользоватьЕИС;
	КонецЕсли;
	//-РС Консалт Назаров М.Ю. 02.12.2022 8:53:28
	#КонецВставки

	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
		НаименованиеПоляНоменклатурыПартнера = "УслугиНоменклатураПартнера";
	Иначе
		НаименованиеПоляНоменклатурыПартнера = "ТоварыНоменклатураПартнера";
	КонецЕсли;	
	Если Не ЭтоЗаказКлиента Тогда
		Форма.Элементы[НаименованиеПоляНоменклатурыПартнера].Видимость = ВидимостьНоменклатурыПартнера;
	КонецЕсли;
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		Форма.Элементы.РасхожденияНоменклатураПартнера.Видимость = ВидимостьНоменклатурыПартнера;
	КонецЕсли;	
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьМестаПоставкиПриложенияЕИСПоАдресуДоставки")
Процедура РСК_ЗаполнитьМестаПоставкиПриложенияЕИСПоАдресуДоставки(АдресДоставки, ИдентификаторМестаПоставкиЕИС, ДанныеПриложенияЕИС)
	
	АдресДоставкиСтруктура = РаботаСАдресами.СведенияОбАдресе(АдресДоставки);
	Если ЗначениеЗаполнено(АдресДоставкиСтруктура) Тогда
		ДанныеПриложенияЕИС.МестаПоставки.Очистить();
		
		МестоПоставки = ЭлектронноеАктированиеЕИС.НовыеСведенияОМестеПоставкиТовара();
		МестоПоставки.Место = АдресДоставкиСтруктура.Представление;
		МестоПоставки.Наименование = АдресДоставкиСтруктура.Представление;
		МестоПоставки.Классификатор = ЭлектронноеАктированиеЕИС.МестоПоставкиПоКЛАДР();
		МестоПоставки.РайонИлиГород = ?(ЗначениеЗаполнено(АдресДоставкиСтруктура.Район), АдресДоставкиСтруктура.Район, АдресДоставкиСтруктура.Город);
		МестоПоставки.НаселенныйПункт = АдресДоставкиСтруктура.НаселенныйПункт;
		Если АдресДоставкиСтруктура.Свойство("КодРегиона")
			И ЗначениеЗаполнено(АдресДоставкиСтруктура.КодРегиона) Тогда
			МестоПоставки.Код = ЭлектронноеАктированиеЕИС.КодКЛАДРПроизвольногоАдреса(
				АдресДоставкиСтруктура.КодРегиона);
		Иначе
			Шаблон = НСтр("ru = 'Не удалось определить код региона адреса: %1';
							|en = 'Cannot define the address region code: %1'");
			ТекстОшибки = СтрШаблон(Шаблон, АдресДоставки);
			ЭлектронноеАктированиеЕИС.ДобавитьОшибкуЗаполненияПриложения(ДанныеПриложенияЕИС, ТекстОшибки);
			Возврат;
		КонецЕсли;
		МестоПоставки.Идентификатор = ИдентификаторМестаПоставкиЕИС;
		МестоПоставки.ИдентификаторУчастника = ЭлектронноеАктированиеЕИС.НачальныйИндексИнформацииУчастникаПокупателя();
		#Вставка
		//++РС Консалт Назаров М.Ю. 16 ноября 2022 г. 12:42:00                  
		//МестоПоставки.ИдентификаторУчастника = ЭлектронноеАктированиеЕИС.НачальныйИндексИнформацииУчастникаГрузополучателя();
		//--РС Консалт Назаров М.Ю. 16 ноября 2022 г. 12:42:00
		#КонецВставки
		
		ДанныеПриложенияЕИС.МестаПоставки.Добавить(МестоПоставки);
	КонецЕсли;
	
КонецПроцедуры



