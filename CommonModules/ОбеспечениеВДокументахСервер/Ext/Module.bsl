﻿//++ РС Консалт: Тарасов Михаил 22.02.2023 Задача 23959
//e1cib/data/Документ.Задание?ref=b9f22338004dbaef43605cf6e10c83d6

&После("ДоступныеОстаткиПерезаполнить")
Процедура РСК_ДоступныеОстаткиПерезаполнить(Форма, ПараметрыЗаполнения)
	
	Попытка
		А = Форма.Объект.Товары[0].РСК_ДоступноАналогов;
	Исключение 
		Возврат;
	КонецПопытки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЧ.Номенклатура КАК Номенклатура,
		|	ТЧ.Характеристика КАК Характеристика,
		|	ТЧ.Склад КАК Склад
		|ПОМЕСТИТЬ ТЧ
		|ИЗ
		|	&ТЧ КАК ТЧ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РСК_АналогиИЗамены.ПриемникНоменклатура КАК Номенклатура,
		|	РСК_АналогиИЗамены.ПриемникХарактеристика КАК Характеристика,
		|	РСК_АналогиИЗамены.ИсточникНоменклатура КАК АналогНоменклатура,
		|	РСК_АналогиИЗамены.ИсточникХарактеристика КАК АналогХарактеристика
		|ПОМЕСТИТЬ АналогиДоРазличных
		|ИЗ
		|	РегистрСведений.РСК_АналогиИЗамены КАК РСК_АналогиИЗамены
		|ГДЕ
		|	РСК_АналогиИЗамены.ВидСвязи = ЗНАЧЕНИЕ(Перечисление.РСК_АналогиИЗаменыВидыСвязи.Аналог)
		|	И (РСК_АналогиИЗамены.ПриемникНоменклатура, РСК_АналогиИЗамены.ПриемникХарактеристика) В
		|			(ВЫБРАТЬ
		|				ТЧ.Номенклатура,
		|				ТЧ.Характеристика
		|			ИЗ
		|				ТЧ КАК ТЧ)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РСК_АналогиИЗамены.ИсточникНоменклатура,
		|	РСК_АналогиИЗамены.ИсточникХарактеристика,
		|	РСК_АналогиИЗамены.ПриемникНоменклатура,
		|	РСК_АналогиИЗамены.ПриемникХарактеристика
		|ИЗ
		|	РегистрСведений.РСК_АналогиИЗамены КАК РСК_АналогиИЗамены
		|ГДЕ
		|	РСК_АналогиИЗамены.ВидСвязи = ЗНАЧЕНИЕ(Перечисление.РСК_АналогиИЗаменыВидыСвязи.Аналог)
		|	И (РСК_АналогиИЗамены.ИсточникНоменклатура, РСК_АналогиИЗамены.ИсточникХарактеристика) В
		|			(ВЫБРАТЬ
		|				ТЧ.Номенклатура,
		|				ТЧ.Характеристика
		|			ИЗ
		|				ТЧ КАК ТЧ)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РСК_АналогиИЗамены.ИсточникНоменклатура,
		|	РСК_АналогиИЗамены.ИсточникХарактеристика,
		|	РСК_АналогиИЗамены1.ИсточникНоменклатура,
		|	РСК_АналогиИЗамены1.ИсточникХарактеристика
		|ИЗ
		|	РегистрСведений.РСК_АналогиИЗамены КАК РСК_АналогиИЗамены
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РСК_АналогиИЗамены КАК РСК_АналогиИЗамены1
		|		ПО РСК_АналогиИЗамены.ПриемникНоменклатура = РСК_АналогиИЗамены1.ПриемникНоменклатура
		|			И РСК_АналогиИЗамены.ПриемникХарактеристика = РСК_АналогиИЗамены1.ПриемникХарактеристика
		|			И РСК_АналогиИЗамены.ПриемникСерия = РСК_АналогиИЗамены1.ПриемникСерия
		|			И РСК_АналогиИЗамены.ВидСвязи = РСК_АналогиИЗамены1.ВидСвязи
		|ГДЕ
		|	РСК_АналогиИЗамены.ВидСвязи = ЗНАЧЕНИЕ(Перечисление.РСК_АналогиИЗаменыВидыСвязи.Аналог)
		|	И (РСК_АналогиИЗамены.ИсточникНоменклатура, РСК_АналогиИЗамены.ИсточникХарактеристика) В
		|			(ВЫБРАТЬ
		|				ТЧ.Номенклатура,
		|				ТЧ.Характеристика
		|			ИЗ
		|				ТЧ КАК ТЧ)
		|	И НЕ (РСК_АналогиИЗамены1.ИсточникНоменклатура, РСК_АналогиИЗамены1.ИсточникХарактеристика) В
		|				(ВЫБРАТЬ
		|					ТЧ.Номенклатура,
		|					ТЧ.Характеристика
		|				ИЗ
		|					ТЧ КАК ТЧ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	АналогиДоРазличных.Номенклатура КАК Номенклатура,
		|	АналогиДоРазличных.Характеристика КАК Характеристика,
		|	АналогиДоРазличных.АналогНоменклатура КАК АналогНоменклатура,
		|	АналогиДоРазличных.АналогХарактеристика КАК АналогХарактеристика
		|ПОМЕСТИТЬ Аналоги
		|ИЗ
		|	АналогиДоРазличных КАК АналогиДоРазличных
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТЧ.Номенклатура КАК Номенклатура,
		|	ТЧ.Характеристика КАК Характеристика,
		|	ТЧ.Склад КАК Склад,
		|	Аналоги.АналогНоменклатура КАК АналогНоменклатура,
		|	Аналоги.АналогХарактеристика КАК АналогХарактеристика
		|ПОМЕСТИТЬ АналогиТЧ
		|ИЗ
		|	ТЧ КАК ТЧ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Аналоги КАК Аналоги
		|		ПО ТЧ.Номенклатура = Аналоги.Номенклатура
		|			И ТЧ.Характеристика = Аналоги.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АналогиТЧ.Номенклатура КАК Номенклатура,
		|	АналогиТЧ.Характеристика КАК Характеристика,
		|	АналогиТЧ.Склад КАК Склад,
		|	СУММА(РаспределениеЗапасов.Свободно) КАК РСК_ДоступноАналогов
		|ИЗ
		|	АналогиТЧ КАК АналогиТЧ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаспределениеЗапасов КАК РаспределениеЗапасов
		|		ПО (РаспределениеЗапасов.Состояние = ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОстатокНаСкладе))
		|			И (РаспределениеЗапасов.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))
		|			И (РаспределениеЗапасов.Склад = АналогиТЧ.Склад)
		|			И (РаспределениеЗапасов.Номенклатура = АналогиТЧ.АналогНоменклатура)
		|			И (РаспределениеЗапасов.Характеристика = АналогиТЧ.АналогХарактеристика)
		|
		|СГРУППИРОВАТЬ ПО
		|	АналогиТЧ.Номенклатура,
		|	АналогиТЧ.Характеристика,
		|	АналогиТЧ.Склад"; 
	Запрос.УстановитьПараметр("ТЧ", Форма.Объект.Товары.Выгрузить(, "Номенклатура, Характеристика, Склад"));
	
	ВДЗ = Запрос.Выполнить().Выбрать();
	СтруктураПоиска = Новый Структура;
	
	Для Каждого Строка ИЗ Форма.Объект.Товары Цикл       
		
		ВДЗ.Сбросить();  
		
		СтруктураПоиска.Вставить("Номенклатура", Строка.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика", Строка.Характеристика);
		СтруктураПоиска.Вставить("Склад", Строка.Склад);
		
		Строка.РСК_ДоступноАналогов = ?(ВДЗ.НайтиСледующий(СтруктураПоиска), ВДЗ.РСК_ДоступноАналогов, 0);
		
	КонецЦикла;
			
КонецПроцедуры     

//-- КонецЗадачи 23959
