&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СобратьДанныеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СобратьДанные(Команда)
	СобратьДанныеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСНулевымКоличеством(Команда)
	Элементы.тзОбъектыЗакупкиПоказыватьСНулевымКоличеством.Пометка = НЕ Элементы.тзОбъектыЗакупкиПоказыватьСНулевымКоличеством.Пометка;
	СобратьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура СобратьДанныеНаСервере()

	МодульОбъекта = РеквизитФормыВЗначение("Объект");

	Запрос = Новый Запрос(МодульОбъекта.ТекстЗапросаЗаполненияСписков());
	Запрос.УстановитьПараметр("ПоказватьСНулевымКоличеством", Элементы.тзОбъектыЗакупкиПоказыватьСНулевымКоличеством.Пометка);
	Результаты = Запрос.ВыполнитьПакет();
	
	тзГосконтракты.Загрузить(Результаты[2].Выгрузить());
	тзОбъектыЗакупки.Загрузить(Результаты[1].Выгрузить());
	тзПодходящаяНоменклатура.Загрузить(Результаты[3].Выгрузить());

КонецПроцедуры // СобратьДанныеНаСервере()

&НаКлиенте
Процедура тзГосконтрактыПриАктивизацииСтроки(Элемент)
	ТД = Элементы.тзГосконтракты.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФиксОтбор = Новый ФиксированнаяСтруктура("ГосударственныйКонтракт", ТД.ГосударственныйКонтракт);
	Элементы.тзОбъектыЗакупки.ОтборСтрок = ФиксОтбор;
	Элементы.тзПодходящаяНоменклатура.ОтборСтрок = ФиксОтбор;
КонецПроцедуры

&НаКлиенте
Процедура Распределить(Команда)
	СтрокаОтправитель = Элементы.тзПодходящаяНоменклатура.ТекущиеДанные;
	Если СтрокаОтправитель = Неопределено Тогда
		ПоказатьПредупреждение(,"Не выбрана строка в источнике");
		Возврат;
	КонецЕсли;
	СтрокаПолучатель = Элементы.тзОбъектыЗакупки.ТекущиеДанные;
	Если СтрокаПолучатель = Неопределено Тогда
		ПоказатьПредупреждение(,"Не выбрана строка в получателе");
		Возврат;
	КонецЕсли;
	Если СтрокаПолучатель.Количество = 0 Тогда
		ПоказатьПредупреждение(,"Нельзя сопоставлять строки с нулевым количеством");
		Возврат;
	КонецЕсли;
	Если СтрокаОтправитель.Цена <> СтрокаПолучатель.Цена Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаОРазныхЦенах", ЭтаФорма), "Цена разная! Продолжить?",РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ВыполнитьРаспределение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОРазныхЦенах(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьРаспределение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРаспределение()
	СтрокаОтправитель = Элементы.тзПодходящаяНоменклатура.ТекущиеДанные;
	СтрокаПолучатель = Элементы.тзОбъектыЗакупки.ТекущиеДанные;

	СтрокиОтправителя = тзПодходящаяНоменклатура.НайтиСтроки(
		Новый Структура(
			"ПредставлениеГосКонтракта,Цена", 
			СтрокаОтправитель.ПредставлениеГосКонтракта,
			СтрокаОтправитель.Цена
		)
	);
	Для Каждого СтрОтпр Из СтрокиОтправителя Цикл
		МожноРаспределить = Мин(СтрОтпр.Количество, СтрокаПолучатель.Количество);
		Если МожноРаспределить <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НС = тзОбъектыЗакупки.Добавить();
		ЗаполнитьЗначенияСвойств(НС, СтрокаПолучатель);
		НС.НоменклатураПартнера = СтрОтпр.НоменклатураПартнера;
		НС.Номенклатура = СтрОтпр.Номенклатура;
		НС.Характеристика = СтрОтпр.Характеристика;
		НС.Упаковка = СтрОтпр.Упаковка;
		НС.Цена = СтрОтпр.Цена;
		НС.Количество = МожноРаспределить;
		
		СтрокаПолучатель.Количество = СтрокаПолучатель.Количество - МожноРаспределить;
		СтрОтпр.Количество = СтрОтпр.Количество - МожноРаспределить;
	КонецЦикла;
	
	Если СтрокаПолучатель.Количество = 0 Тогда
		УдаляемаяСтрока = тзОбъектыЗакупки.НайтиПоИдентификатору(СтрокаПолучатель.ПолучитьИдентификатор());
		тзОбъектыЗакупки.Удалить(УдаляемаяСтрока);
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьРаспределение()

&НаКлиенте
Процедура Записать(Команда)
	ТД = Элементы.тзГосконтракты.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	НезаполненныеСтрокиКонтракта = тзОбъектыЗакупки.НайтиСтроки(
		Новый Структура(
			"ГосударственныйКонтракт,Номенклатура",
			ТД.ГосударственныйКонтракт,
			ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка")
		)
	);
	Если НезаполненныеСтрокиКонтракта.Количество() > 0 Тогда
		ПоказатьПредупреждение(,"Нельзя записывать частично сопоставленные госконтракты");
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ЗаписатьНаСервере(ТД.ГосударственныйКонтракт, Отказ);
	Если НЕ Отказ Тогда
		ТД.Сопоставлен = Истина;
		ПоказатьОповещениеПользователя("Данные записаны!",ПолучитьНавигационнуюСсылку(ТД.ГосударственныйКонтракт),ТД.ГосударственныйКонтракт);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(ГосКонтракт, Отказ)
	
	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	МодульОбъекта.ЗаписатьГосКонтракт(ГосКонтракт, тзОбъектыЗакупки.Выгрузить(), Отказ);

КонецПроцедуры // ЗаписатьНаСервере()

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
    ИмяПоля = Сред(Поле.Имя, СтрДлина(Элемент.Имя)+1);
    ПоказатьЗначение(, ДанныеСтроки[ИмяПоля]);
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьДоговоры(Команда)
	ОткрытьФорму("Обработка.РСК_СопоставлениеОбъектовЭДО.Форма.СопоставлениеДоговоров",,,,,, Новый ОписаниеОповещения("ПослеСопоставленияДоговоров", ЭтаФорма), );
КонецПроцедуры

&НаКлиенте
Процедура ПослеСопоставленияДоговоров(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобратьДанныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подсказка(Команда)
	Элементы.тзПодходящаяНоменклатураПодсказка.Пометка = НЕ Элементы.тзПодходящаяНоменклатураПодсказка.Пометка;
	тзОбъектыЗакупкиПриАктивизацииСтроки(Неопределено);
	Если НЕ Элементы.тзПодходящаяНоменклатураПодсказка.Пометка Тогда
		Для Каждого Стр Из тзПодходящаяНоменклатура Цикл
			Стр.Подсказка = Ложь;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура тзОбъектыЗакупкиПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.тзПодходящаяНоменклатураПодсказка.Пометка Тогда
		Возврат;
	КонецЕсли;
	
	ТД = Элементы.тзГосконтракты.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ГосКонтракт = ТД.ГосударственныйКонтракт;
	ТД = Элементы.тзОбъектыЗакупки.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодсказкаНаСервере(ГосКонтракт, ТД.Цена, ТД.Наименование);
КонецПроцедуры

&НаСервере
Процедура ПодсказкаНаСервере(ГосКонтракт, Цена, НаименованиеВГосКонтракте)
	
	СтрокиУТ = тзПодходящаяНоменклатура.НайтиСтроки(
		Новый Структура(
			"ГосударственныйКонтракт",
			ГосКонтракт
		)
	);
	
	Для Каждого СтрУТ Из СтрокиУТ Цикл
		СтрУТ.Подсказка = Ложь;
	КонецЦикла;
	

	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	СтрокаУТ = МодульОбъекта.ПолучитьПодходящуюСтрокуУТ(
		тзПодходящаяНоменклатура.Выгрузить(Новый Структура("ГосударственныйКонтракт", ГосКонтракт)),
		Цена,
		НаименованиеВГосКонтракте
	);
	
	Если СтрокаУТ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиУТ = тзПодходящаяНоменклатура.НайтиСтроки(
		Новый Структура(
			"ГосударственныйКонтракт,ПредставлениеГосКонтракта,Цена",
			ГосКонтракт,
			СтрокаУТ.ПредставлениеГосКонтракта,
			СтрокаУТ.Цена
		)
	);
	
	Для Каждого СтрУТ Из СтрокиУТ Цикл
		СтрУТ.Подсказка = Истина;
	КонецЦикла;

КонецПроцедуры // ПодсказкаНаСервере()


