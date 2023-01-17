﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Основание") Тогда
		ДокументОснование = Параметры.Основание;
		Соисполнитель 	  = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование,"ТорговыйПредставитель"); 
		ЗаполнитьСписокДокументов();		
	КонецЕсли;  
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьСписокДокументов()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ОтборНеУстановлен",НЕ ЗначениеЗаполнено(Соисполнитель));
	Запрос.УстановитьПараметр("ТорговыйПредставитель",Соисполнитель);
	Запрос.УстановитьПараметр("Основание",ДокументОснование);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество КАК Количество,
	|	СУММА(РСК_ОтраженныеУслугиСоисполнителей.Количество) КАК Количество1,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_ОстаткиПоДокументам
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю.САВ_Услуги КАК ЗаданиеТорговомуПредставителюСАВ_Услуги
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РСК_ОтраженныеУслугиСоисполнителей КАК РСК_ОтраженныеУслугиСоисполнителей
	|		ПО ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка = РСК_ОтраженныеУслугиСоисполнителей.ЗаданиеТорговомуПредставителю
	|			И ЗаданиеТорговомуПредставителюСАВ_Услуги.Номенклатура = РСК_ОтраженныеУслугиСоисполнителей.Услуга
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка
	|
	|ИМЕЮЩИЕ
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество - СУММА(ЕСТЬNULL(РСК_ОтраженныеУслугиСоисполнителей.Количество, 0)) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаданиеТорговомуПредставителю.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ЗаданиеТорговомуПредставителю.Ссылка В (&Основание)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю КАК ЗаданиеТорговомуПредставителю
	|ГДЕ
	|	(&ОтборНеУстановлен
	|			ИЛИ ЗаданиеТорговомуПредставителю.ТорговыйПредставитель = &ТорговыйПредставитель)
	|	И ЗаданиеТорговомуПредставителю.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТ_ОстаткиПоДокументам.Ссылка КАК Ссылка
	|			ИЗ
	|				ВТ_ОстаткиПоДокументам КАК ВТ_ОстаткиПоДокументам)";  
	
	Результат = Запрос.Выполнить().Выгрузить();
	СписокДокументов.Загрузить(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда) 
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодборСтрок;
	ДалееНаСервере(); 
	
КонецПроцедуры

&НаСервере
Процедура ДалееНаСервере()
	ЗаполнитьСписокСтрок();
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСписокСтрок() 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокДокументов",СписокДокументов.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокДокументов.Ссылка КАК Ссылка,
	|	СписокДокументов.Пометка КАК Пометка
	|ПОМЕСТИТЬ ВТ_ДокументыДляФормирования
	|ИЗ
	|	&СписокДокументов КАК СписокДокументов
	|ГДЕ
	|	СписокДокументов.Пометка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Номенклатура КАК Услуга,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество - СУММА(ЕСТЬNULL(РСК_ОтраженныеУслугиСоисполнителей.Количество, 0)) КАК КоличествоДоступно,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Цена КАК Цена,
	|	0 КАК Сумма,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Содержание КАК Содержание,
	|	ВТ_ДокументыДляФормирования.Ссылка КАК Документ
	|ИЗ
	|	ВТ_ДокументыДляФормирования КАК ВТ_ДокументыДляФормирования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаданиеТорговомуПредставителю.САВ_Услуги КАК ЗаданиеТорговомуПредставителюСАВ_Услуги
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РСК_ОтраженныеУслугиСоисполнителей КАК РСК_ОтраженныеУслугиСоисполнителей
	|			ПО ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка = РСК_ОтраженныеУслугиСоисполнителей.ЗаданиеТорговомуПредставителю
	|				И ЗаданиеТорговомуПредставителюСАВ_Услуги.Номенклатура = РСК_ОтраженныеУслугиСоисполнителей.Услуга
	|				И (РСК_ОтраженныеУслугиСоисполнителей.Активно)
	|		ПО ВТ_ДокументыДляФормирования.Ссылка = ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Номенклатура,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Цена,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Содержание,
	|	ВТ_ДокументыДляФормирования.Ссылка,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество
	|
	|ИМЕЮЩИЕ
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество - СУММА(ЕСТЬNULL(РСК_ОтраженныеУслугиСоисполнителей.Количество, 0)) > 0"; 
	
	Результат = Запрос.Выполнить().Выгрузить();
	СписокСтрок.Загрузить(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаПодборДокументов;
КонецПроцедуры

&НаКлиенте
Процедура СоисполнительПриИзменении(Элемент)
	ЗаполнитьСписокДокументов();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	СтруктураПараметров = СтрокиДляПереносаВДокумент();
	ПараметрыОснования  = Новый Структура("ДокументОснование,АдресСтрокВоВременномХранилище",
							ДокументОснование,СтруктураПараметров.АдресСтрокВоВременномХранилище);
	ПараметрыФормы      = Новый Структура("Основание,СтрокиКОтражению",ПараметрыОснования,СтруктураПараметров.АдресСтрокВоВременномХранилище);
	ОткрытьФорму("Документ.ПриобретениеУслугПрочихАктивов.ФормаОбъекта", ПараметрыФормы);  
	Закрыть();

КонецПроцедуры

&НаСервере
Функция СтрокиДляПереносаВДокумент() 
		
 	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеОтбора",СписокСтрок.Выгрузить());
	Запрос.УстановитьПараметр("Статья",ПланыВидовХарактеристик.СтатьиРасходов.НайтиПоКоду("121008")); 
	Запрос.УстановитьПараметр("АналитикаРасходов",ПартнерСоисполнительДокументаОснования(ДокументОснование));
	Запрос.УстановитьПараметр("СтавкаНДС",Справочники.СтавкиНДС.БезНДС);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеОтбора.Содержание КАК Содержание,
	|	ДанныеОтбора.Количество КАК Количество,
	|	ДанныеОтбора.Цена КАК Цена,
	|	ДанныеОтбора.Сумма КАК Сумма,
	|	ДанныеОтбора.Документ КАК Документ,
	|	ДанныеОтбора.Услуга КАК Услуга
	|ПОМЕСТИТЬ ВТ_ДанныеОтбора
	|ИЗ
	|	&ДанныеОтбора КАК ДанныеОтбора
	|ГДЕ
	|	ДанныеОтбора.Пометка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеОтбора.Содержание КАК Содержание,
	|	ВТ_ДанныеОтбора.Количество КАК Количество,
	|	ВТ_ДанныеОтбора.Цена КАК Цена,
	|	ВТ_ДанныеОтбора.Сумма КАК Сумма,
	|	&Статья КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|	&СтавкаНДС КАК СтавкаНДС,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(36)) КАК РСК_ИдентификаторСтрокиЗадания,
	|	ВТ_ДанныеОтбора.Услуга КАК Услуга,
	|	ВТ_ДанныеОтбора.Документ КАК ЗаданиеТорговомуПредставителю,
	|	ЛОЖЬ КАК Активно,
	|	ВТ_ДанныеОтбора.Сумма КАК СуммаСНДС
	|ИЗ
	|	ВТ_ДанныеОтбора КАК ВТ_ДанныеОтбора"; 
	
	Результат = Запрос.Выполнить().Выгрузить(); 
	Для Каждого Стр Из Результат Цикл
		Стр.РСК_ИдентификаторСтрокиЗадания = Строка(Новый УникальныйИдентификатор);	
	КонецЦикла;
	
    АдресВременногоХранилищаКОтражению = ПоместитьВоВременноеХранилище(Результат,Новый УникальныйИдентификатор);
	
	Возврат Новый Структура("АдресСтрокВоВременномХранилище",АдресВременногоХранилищаКОтражению);
	
КонецФункции  

&НаСервереБезКонтекста
Функция ПартнерСоисполнительДокументаОснования(ДокументОснование) 
	
	Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование,"Склад"); 
	Если ЗначениеЗаполнено(Склад) Тогда
		Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад,"Поклажедержатель");
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент,"Партнер");	
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено; 
	
КонецФункции   

&НаКлиенте
Процедура СписокСтрокКоличествоВДокументПриИзменении(Элемент) 
	
	ТекущиеДанные = Элементы.СписокСтрок.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ТекущиеДанные.Количество > ТекущиеДанные.КоличествоДоступно Тогда
			ТекущиеДанные.Количество = ТекущиеДанные.КоличествоДоступно;	
		КонецЕсли;
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;	
	КонецЕсли;  
	
КонецПроцедуры

