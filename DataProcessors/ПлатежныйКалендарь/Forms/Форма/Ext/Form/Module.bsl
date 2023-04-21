﻿
&НаСервере
&Вместо("СформироватьСписанияДСНаСервере")
Функция РСК_СформироватьСписанияДСНаСервере()
	
	СКД = Элементы[ИмяТекущегоСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	СКД.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос =
		СтрЗаменить(СКД.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос,
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ", //@query-part
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ"); //@query-part
	
	Настройки = Элементы[ИмяТекущегоСписка].ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	Настройки.Структура.Очистить();
	
	ВыбранныеПоля = Новый Массив;
	ВыбранныеПоля.Добавить("ОбъектОплаты");
	ВыбранныеПоля.Добавить("БанковскийСчетКасса");
	ВыбранныеПоля.Добавить("ДатаПлатежа");
	ВыбранныеПоля.Добавить("ПлательщикПолучатель");
	ВыбранныеПоля.Добавить("Организация");
	ВыбранныеПоля.Добавить("ПоступлениеСписание");
	ВыбранныеПоля.Добавить("Валюта");
	
	ДетальныеЗаписи = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных")); // ГруппировкаКомпоновкиДанных
	Для Каждого ВыбранноеПоле Из ВыбранныеПоля Цикл
		ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных(ВыбранноеПоле);
	КонецЦикла;
	
	СтатусыКОплате = Новый Массив;
	СтатусыКОплате.Добавить(Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате);
	СтатусыКОплате.Добавить(Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате);
	//РСК+    
	СтатусыКОплате.Добавить(Перечисления.СтатусыЗаявокСотрудников.КОплате);
	//РСК-
	ФинансоваяОтчетностьСервер.УстановитьОтбор(
		Настройки.Отбор,
		"СтатусЗаявки",
		СтатусыКОплате,
		ВидСравненияКомпоновкиДанных.ВСписке);
		
	ФинансоваяОтчетностьСервер.УстановитьОтбор(
		Настройки.Отбор,
		"ФормаОплаты",
		Перечисления.ФормыОплаты.Наличная,
		ВидСравненияКомпоновкиДанных.НеРавно);
		
	ТаблицаЗаявок = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Настройки);
	
	Если ТаблицаЗаявок.Количество() Тогда
		Возврат ДенежныеСредстваСервер.ОплатитьСтрокиГрафика(ТаблицаЗаявок, "СписаниеБезналичныхДенежныхСредств");
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В списке нет заявок к оплате для формирования документов списания.';
																|en = 'There are no requests for payment for cash outflow document generation in the list.'"));
		Возврат Неопределено;
	КонецЕсли;
	

КонецФункции

&НаСервере
&ИзменениеИКонтроль("РаспределитьКОплатеНаСервере")
Функция РСК_РаспределитьКОплатеНаСервере(ЗаявкиКРаспределению)

	СписокЗаявок = Новый Массив;
	Для каждого ЗаявкаКРаспределению Из ЗаявкиКРаспределению Цикл
		Если ТипЗнч(ЗаявкаКРаспределению) = Тип("РегистрСведенийКлючЗаписи.ГрафикПлатежей")
			И ТипЗнч(ЗаявкаКРаспределению.ОбъектОплаты) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
			СписокЗаявок.Добавить(ЗаявкаКРаспределению.ОбъектОплаты);
			#Вставка
			//РСК+ Кикинева А.Г. задача 255873 проставление Статуса к Оплате Заявок на командировку
		ИначеЕсли
			ТипЗнч(ЗаявкаКРаспределению) = Тип("РегистрСведенийКлючЗаписи.ГрафикПлатежей")
			И ТипЗнч(ЗаявкаКРаспределению.ОбъектОплаты) = Тип("ДокументСсылка.ЗаявкаНаКомандировку") Тогда 
			ЗаявкаОбъект = ЗаявкаКРаспределению.ОбъектОплаты.ПолучитьОбъект();
			ЗаявкаОбъект.Статус=Перечисления.СтатусыЗаявокСотрудников.КОплате;
			ЗаявкаОбъект.Записать();  
			//РСК+ Кикинева А.Г. задача 255873 проставление Статуса к Оплате Заявок на командировку
			#КонецВставки
		КонецЕсли;
	КонецЦикла;

	СКД = Элементы[ИмяТекущегоСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	СКД.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос =
	СтрЗаменить(СКД.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос,
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ", //@query-part
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ"); //@query-part
	Настройки = Элементы.ЗаявкиКОплате.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	Настройки.Структура.Очистить();
	ДетальныеЗаписи = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ФинансоваяОтчетностьСервер.УстановитьОтбор(Настройки.Отбор, "Ссылка", СписокЗаявок, ВидСравненияКомпоновкиДанных.ВСписке);
	РезультатСКД = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Настройки);
	СписокЗаявокСортированный = РезультатСКД.ВыгрузитьКолонку("Ссылка");

	ДанныеРаспределения = Новый Соответствие;
	Обработки.ПлатежныйКалендарь.ПодготовитьДанныеРаспределенияЗаявок(ДанныеРаспределения, ЗаявкиКРаспределению, СписокЗаявокСортированный,
	РеквизитФормыВЗначение("Объект.ДеревоПлатежей").Скопировать(), Объект.ПланироватьСДаты, ДнейПланирования);

	НаименованиеЗадания = НСтр("ru = 'Распределение заявок на расходование денежных средств';
	|en = 'Allocation of payment requests'");
	ВыполняемыйМетод = "Обработки.ПлатежныйКалендарь.ПеренестиЗаявки";

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеПереноса", ДанныеРаспределения);
	СтруктураПараметров.Вставить("ПланироватьСДаты", Объект.ПланироватьСДаты);

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	Если ДанныеРаспределения.Количество() = 1 Тогда
		ПараметрыВыполнения.ЗапуститьНеВФоне = Истина;
	КонецЕсли;

	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);

КонецФункции


