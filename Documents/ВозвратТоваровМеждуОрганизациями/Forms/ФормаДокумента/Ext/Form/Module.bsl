﻿ 
&НаСервере
Процедура РСК_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)  
	 
	Если Параметры.Свойство("РС_ПересчитатьТоварыПоПередачам") И Параметры.РС_ПересчитатьТоварыПоПередачам Тогда
		
		РС_ПересчитатьТоварыПоПередачам = Истина;	
		
	КонецЕсли;
		
КонецПроцедуры
 
&НаКлиенте
Процедура РСК_ПриОткрытииПеред(Отказ)
	
	Если РС_ПересчитатьТоварыПоПередачам Тогда	
		ОбработкаПараметраРС_ПересчитатьТоварыПоПередачам();	
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПерезаполнениеПередачИГТД()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика, 
	|	Товары.Серия КАК Серия, 
	|	Товары.ВидЦены КАК ВидЦены,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	КлючиАналитикиУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	КлючиАналитикиУчетаНоменклатуры.Серия КАК Серия,
	|	КлючиАналитикиУчетаНоменклатуры.Назначение КАК Назначение,
	|	СУММА(ТоварыОрганизацийОстатки.КоличествоОстаток) КАК Количество,
	|	ТоварыОрганизацийОстатки.НомерГТД КАК НомерГТД
	|ПОМЕСТИТЬ ОстаткиСерий
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|			&Дата,
	|			Организация = &Организация
	|				И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|				И (АналитикаУчетаНоменклатуры.Номенклатура, АналитикаУчетаНоменклатуры.Характеристика, АналитикаУчетаНоменклатуры.Серия) В
	|					(ВЫБРАТЬ
	|						Товары.Номенклатура КАК Номенклатура,
	|						Товары.Характеристика КАК Характеристика,
	|						Товары.Серия КАК Серия
	|					ИЗ
	|						Товары КАК Товары)) КАК ТоварыОрганизацийОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	|		ПО ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры = КлючиАналитикиУчетаНоменклатуры.Ссылка
	|ГДЕ
	|	ТоварыОрганизацийОстатки.КоличествоОстаток > 0
 	|
	|СГРУППИРОВАТЬ ПО
	|	КлючиАналитикиУчетаНоменклатуры.Назначение,
	|	КлючиАналитикиУчетаНоменклатуры.Серия,
	|	КлючиАналитикиУчетаНоменклатуры.Характеристика,
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура,
	|	ТоварыОрганизацийОстатки.НомерГТД
	|;
 	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество КАК КоличествоВсегоТребуется,
	|	Товары.Серия КАК Серия,  
	|	Товары.ВидЦены КАК ВидЦены,
	|	ОстаткиСерий.Назначение КАК Назначение,
	|	ЕСТЬNULL(ОстаткиСерий.Количество, 0) КАК Количество,
	|	ОстаткиСерий.НомерГТД КАК НомерГТД
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСерий КАК ОстаткиСерий
	|		ПО Товары.Номенклатура = ОстаткиСерий.Номенклатура
	|			И Товары.Характеристика = ОстаткиСерий.Характеристика
	|			И Товары.Серия = ОстаткиСерий.Серия
	|ИТОГИ
	|	МАКСИМУМ(КоличествоВсегоТребуется),
	|	СУММА(Количество),
	|	МАКСИМУМ(ВидЦены)
	|ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия
	|");
	Запрос.УстановитьПараметр("Дата", Новый Граница(КонецДня(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Товары", Объект.Товары.Выгрузить(, "Номенклатура, Характеристика, Серия, ВидЦены, Количество"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗапросОстатки = Новый Запрос(
	"ВЫБРАТЬ
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
	
	ЗапросОстатки.УстановитьПараметр("Организация", Объект.ОрганизацияПолучатель);
	ЗапросОстатки.УстановитьПараметр("ОрганизацияПолучатель", Объект.Организация);
	ЗапросОстатки.УстановитьПараметр("Дата", КонецДня(Объект.Дата));
	ЗапросОстатки.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ЗапросОстатки.УстановитьПараметр("Товары", Объект.Товары.Выгрузить(, "Номенклатура, Характеристика, Серия"));
	
	ТаблицаОстатков = ЗапросОстатки.Выполнить().Выгрузить();
	СтруктураПоиска = Новый Структура;
	Объект.Товары.Очистить();
	
	ВыборкаТовары = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаТовары.Следующий() Цикл 
		
		ВыборкаХарки = ВыборкаТовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарки.Следующий() Цикл  
			
			ВыборкаСерии = ВыборкаХарки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаСерии.Следующий() Цикл			
				
				ВыборкаДетальныеЗаписи = ВыборкаСерии.Выбрать();				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					
					Остаток = ВыборкаСерии.КоличествоВсегоТребуется;
					СтруктураПоиска.Вставить("Номенклатура", ВыборкаСерии.Номенклатура); 
					СтруктураПоиска.Вставить("Характеристика", ВыборкаСерии.Характеристика);
					СтруктураПоиска.Вставить("Серия", ВыборкаСерии.Серия);
					СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураПоиска);
					
					Пока Остаток > 0 И СтрокиОстатков.Количество() Цикл
						
						НоваяСтрока = Объект.Товары.Добавить();
						НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
						НоваяСтрока.Характеристика = ВыборкаДетальныеЗаписи.Характеристика; 
						НоваяСтрока.Назначение = ВыборкаДетальныеЗаписи.Назначение;
						НоваяСтрока.НомерГТД = ВыборкаДетальныеЗаписи.НомерГТД;
						НоваяСтрока.Серия = ВыборкаДетальныеЗаписи.Серия;
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
						НоваяСтрока = Объект.Товары.Добавить();
						НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
						НоваяСтрока.Характеристика = ВыборкаДетальныеЗаписи.Характеристика; 
						НоваяСтрока.Назначение = ВыборкаДетальныеЗаписи.Назначение;
						НоваяСтрока.НомерГТД = ВыборкаДетальныеЗаписи.НомерГТД;
						НоваяСтрока.Серия = ВыборкаДетальныеЗаписи.Серия;
						НоваяСтрока.Количество = Остаток;
						НоваяСтрока.КоличествоУпаковок = Остаток;
						НоваяСтрока.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента;
						НоваяСтрока.ВидЦены = ВыборкаДетальныеЗаписи.ВидЦены;
					КонецЕсли;	
					
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;  
	
	Для Каждого Строка ИЗ Объект.Товары Цикл
		
		Если ЗначениеЗаполнено(Строка.ДокументПередачи) И ЗначениеЗаполнено(Строка.ДокументПередачи.Договор) Тогда
			
			Объект.Договор = Строка.ДокументПередачи.Договор;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте  
Процедура ОбработкаПараметраРС_ПересчитатьТоварыПоПередачам() 
	
	РС_ПересчитатьТоварыПоПередачам = Ложь;
	ПриИзмененииСкладаСервер();
	
	//++РС Консалт: Минаков А.С. Задача 24557
	//ПерезаполнениеПередачИГТД();
	//++РС Консалт: Минаков А.С. Задача 24557
	
	ОбработатьСтрокиПослеПерезаполненияТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура РСК_ЗаполнитьСОтборомПоВидуВместо(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборВидаЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Документ.ВозвратТоваровМеждуОрганизациями.Форма.РСК_ВыборВидаНоменклатуры"
	,,ЭтаФорма, УникальныйИдентификатор,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры   

&НаКлиенте
Процедура ОбработатьСтрокиПослеПерезаполненияТоваров() 
	
	Для Каждого ТекущаяСтрока Из Объект.Товары Цикл
		
		ДействияЦены = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияЦеныВСтрокеТЧ(Объект);
		ДействияПересчетНДС = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
		Действия = Новый Структура;
		
		ДействиеЗаполнитьСтавкуНДС = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект);
		
		Действия.Вставить("ПроверитьХарактеристикуПоВладельцу",ТекущаяСтрока.Характеристика);
		Действия.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу",ТекущаяСтрока.Упаковка);
		Действия.Вставить("ЗаполнитьСтавкуНДС", ДействиеЗаполнитьСтавкуНДС);
		Действия.Вставить("ПересчитатьКоличествоЕдиниц");
		Действия.Вставить("ЗаполнитьЦенуПродажи",ДействияЦены);
		Действия.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		Действия.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		Действия.Вставить("ПересчитатьСумму");
		Действия.Вставить("ПересчитатьСуммуНДС",ДействияПересчетНДС);
		Действия.Вставить("ПересчитатьСуммуСНДС",ДействияПересчетНДС);
		Действия.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
		Действия.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД", Новый Структура("Номенклатура", "ВедетсяУчетПоГТД"));
		Действия.Вставить("ЗаполнитьСтрануПроисхожденияНоменклатуры",
		ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтраныПроисхождения());
		
		Действия.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
		
		УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекПересчетаРеквизитовТабличнойЧасти(
		Объект,
		Действия);
		УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(Действия);
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, Действия, КэшированныеЗначения);
		
		Если НЕ ТекущаяСтрока.ВедетсяУчетПоГТД Тогда
			ТекущаяСтрока.НомерГТД = Неопределено;
			ТекущаяСтрока.СтранаПроисхождения = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьИнформациюПоПередачам();		
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаЗавершение(Значение, ДопПараметры = Неопределено) Экспорт
	
	РСК_ЗаполнитьСОтборомПоВидуВместоНаСервере(Значение);
	
	ОбработатьСтрокиПослеПерезаполненияТоваров();
	
КонецПроцедуры	
	
&НаСервере
Процедура РСК_ЗаполнитьСОтборомПоВидуВместоНаСервере(ВидНоменклатуры)
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	СУММА(ТоварыОрганизацийОстатки.КоличествоОстаток) КАК Количество,
	|	ТоварыОрганизацийОстатки.НомерГТД КАК НомерГТД
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|			&Дата,
	|			Организация = &Организация
	|				И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|				И НЕ АналитикаУчетаНоменклатуры.Номенклатура.ВидНоменклатуры В ИЕРАРХИИ (&ВидНоменклатуры)) КАК ТоварыОрганизацийОстатки
	|ГДЕ
	|	ТоварыОрганизацийОстатки.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Назначение,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТоварыОрганизацийОстатки.НомерГТД
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия");
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	Запрос.УстановитьПараметр("Дата", Новый Граница(КонецДня(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗапросОстатки = Новый Запрос(
	"ВЫБРАТЬ
	|	ПТМ.Ссылка КАК Ссылка,
	|	ПТМ.Цена КАК Цена,
	|	ПТМ.Количество - ЕСТЬNULL(ВТМ.Количество, 0) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПередачаТоваровМеждуОрганизациямиТовары.Ссылка КАК Ссылка,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Цена КАК Цена,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура КАК Номенклатура,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Характеристика КАК Характеристика,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Серия КАК Серия,
	|		СУММА(ПередачаТоваровМеждуОрганизациямиТовары.Количество) КАК Количество
	|	ИЗ
	|		Документ.ПередачаТоваровМеждуОрганизациями.Товары КАК ПередачаТоваровМеждуОрганизациямиТовары
	|	ГДЕ
	|		ПередачаТоваровМеждуОрганизациямиТовары.Ссылка.Проведен
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура = &Номенклатура
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Характеристика = &Характеристика
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Серия = &Серия
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Ссылка.Организация = &Организация
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Ссылка.ОрганизацияПолучатель = &ОрганизацияПолучатель
	|		И ПередачаТоваровМеждуОрганизациямиТовары.Ссылка.Дата <= &Дата
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПередачаТоваровМеждуОрганизациямиТовары.Ссылка,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Цена,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Номенклатура,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Характеристика,
	|		ПередачаТоваровМеждуОрганизациямиТовары.Серия) КАК ПТМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТМ.ДокументПередачи КАК ДокументПередачи,
	|			ВТМ.Номенклатура КАК Номенклатура,
	|			ВТМ.Цена КАК Цена,
	|			ВТМ.Характеристика КАК Характеристика,
	|			ВТМ.Серия КАК Серия,
	|			СУММА(ВТМ.Количество) КАК Количество
	|		ИЗ
	|			Документ.ВозвратТоваровМеждуОрганизациями.Товары КАК ВТМ
	|		ГДЕ
	|			НЕ ВТМ.Ссылка = &Ссылка
	|			И ВТМ.Ссылка.Проведен
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВТМ.Номенклатура,
	|			ВТМ.Характеристика,
	|			ВТМ.Серия,
	|			ВТМ.Цена,
	|			ВТМ.ДокументПередачи) КАК ВТМ
	|		ПО (ВТМ.ДокументПередачи = ПТМ.Ссылка)
	|			И (ВТМ.Номенклатура = ПТМ.Номенклатура)
	|			И (ВТМ.Характеристика = ПТМ.Характеристика)
	|			И (ВТМ.Серия = ПТМ.Серия)
	|			И (ВТМ.Цена = ПТМ.Цена)
	|ГДЕ
	|	ПТМ.Количество - ЕСТЬNULL(ВТМ.Количество, 0) > 0");
		
	ЗапросОстатки.УстановитьПараметр("Организация", Объект.ОрганизацияПолучатель);
	ЗапросОстатки.УстановитьПараметр("ОрганизацияПолучатель", Объект.Организация);
	ЗапросОстатки.УстановитьПараметр("Дата", КонецДня(Объект.Дата));
	ЗапросОстатки.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаТовары = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаТовары.Следующий() Цикл
		ВыборкаХарки = ВыборкаТовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарки.Следующий() Цикл
			ВыборкаСерии = ВыборкаХарки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаСерии.Следующий() Цикл
				
				ЗапросОстатки.УстановитьПараметр("Номенклатура", ВыборкаТовары.Номенклатура);
				ЗапросОстатки.УстановитьПараметр("Серия", ВыборкаСерии.Серия);
				ЗапросОстатки.УстановитьПараметр("Характеристика", ВыборкаХарки.Характеристика);
				
				ТаблицаОстатков = ЗапросОстатки.Выполнить().Выгрузить();
				
				ВыборкаДетальныеЗаписи = ВыборкаСерии.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					
					Остаток = ВыборкаСерии.Количество;
					
					Пока Остаток > 0 И ТаблицаОстатков.Количество() Цикл
						
						НоваяСтрока = Объект.Товары.Добавить();
						НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
						НоваяСтрока.Характеристика = ВыборкаДетальныеЗаписи.Характеристика; 
						НоваяСтрока.Назначение = ВыборкаДетальныеЗаписи.Назначение;
						НоваяСтрока.НомерГТД = ВыборкаДетальныеЗаписи.НомерГТД;
						НоваяСтрока.Серия = ВыборкаДетальныеЗаписи.Серия;
						НоваяСтрока.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПередачи;
						
						СтрокаТЧ = ТаблицаОстатков[0];
						
						Списать = Мин(Остаток, СтрокаТЧ.Количество); 
						
						НоваяСтрока.Количество = Списать;
						НоваяСтрока.КоличествоУпаковок = Списать;						
						НоваяСтрока.ДокументПередачи = СтрокаТЧ.Ссылка;
						НоваяСтрока.Цена = СтрокаТЧ.Цена;
						
						СтрокаТЧ.Количество = СтрокаТЧ.Количество - НоваяСтрока.Количество;
						Остаток = Остаток - НоваяСтрока.Количество;
						
						Если СтрокаТЧ.Количество <= 0 Тогда
							ТаблицаОстатков.Удалить(СтрокаТЧ)
						КонецЕсли
						
					КонецЦикла;
					
					Если Остаток > 0 Тогда
						НоваяСтрока = Объект.Товары.Добавить();
						НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
						НоваяСтрока.Характеристика = ВыборкаДетальныеЗаписи.Характеристика; 
						НоваяСтрока.Назначение = ВыборкаДетальныеЗаписи.Назначение;
						НоваяСтрока.НомерГТД = ВыборкаДетальныеЗаписи.НомерГТД;
						НоваяСтрока.Серия = ВыборкаДетальныеЗаписи.Серия;
						НоваяСтрока.Количество = Остаток;
						НоваяСтрока.КоличествоУпаковок = Остаток;
						НоваяСтрока.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента;
					КонецЕсли	
					
				КонецЦикла
			КонецЦикла
		КонецЦикла
	КонецЦикла
	
КонецПроцедуры
