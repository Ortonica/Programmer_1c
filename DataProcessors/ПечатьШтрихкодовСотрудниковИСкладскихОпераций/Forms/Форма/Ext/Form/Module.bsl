﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСписокСотрудниковСклада();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСотрудниковСклада()

	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИдентификационныеДанныеПользователей.Пользователь КАК Пользователь,
		|	ИдентификационныеДанныеПользователей.Штрихкод КАК Штрихкод
		|ИЗ
		|	РегистрСведений.ИдентификационныеДанныеПользователей КАК ИдентификационныеДанныеПользователей
		|
		|УПОРЯДОЧИТЬ ПО
		|	Пользователь
		|АВТОУПОРЯДОЧИВАНИЕ";
	СписокСотрудников.Загрузить(Запрос.Выполнить().Выгрузить());	

КонецПроцедуры // ОбновитьСписокСотрудниковСклада()

&НаКлиенте
Процедура НапечататьШтрихкоды(Команда)
	Табдок = ПечатьШтрихкодов();
	//Типовая часть вывода в стандартное окно++
	ИдентификаторПечатнойФормы = "ПФ_MXL_ПечатьШтрихкодовСотрудниковИСкладскихОпераций";
	НазваниеПечатнойФормы = НСтр("ru = 'Печать штрихкодов сотрудников и складских операций'");
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		ТабДок.Показать(НазваниеПечатнойФормы);
		ДокументыПечатались = Истина;
		Возврат;
	КонецЕсли;     
	МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");     
	КоллекцияПечатныхФорм = МодульУправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = МодульУправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент = ТабДок;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	ОбластиОбъектов = Новый СписокЗначений;
	МодульУправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
	
	ДокументыПечатались = Истина;
	
	//Табдок.Показать();// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Функция ПечатьШтрихкодов()
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб = Истина;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьШтрихкодовСотрудниковИСкладскихОпераций.Макет");
	
	ОбластьШтрихкода = Макет.ПолучитьОбласть("ОбластьШтрихкода|ОбластьШтрихкодаКолонки"); 
	ТаблицаШтрихкодов = ПолучитьТаблицуШтрихкодов();
	
	Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",          Окр(ОбластьШтрихкода.Рисунки.КартинкаШтрихкода1.Ширина / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("Высота",          Окр(ОбластьШтрихкода.Рисунки.КартинкаШтрихкода1.Высота / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("ТипКода",         4); // Code128
	ПараметрыШтрихкода.Вставить("ОтображатьТекст", Ложь);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",    6);
	
	Индекс = 1;
	Для Каждого Штрихкод ИЗ ТаблицаШтрихкодов Цикл
		ПараметрыШтрихкода.Вставить("Штрихкод",Штрихкод.Штрихкод);
		
		ОбластьШтрихкода.Рисунки.КартинкаШтрихкода1.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
		ОбластьШтрихкода.Параметры.НаименованиеШтр1 = Штрихкод.Представление;
		Если Индекс = 1 Тогда
			ТабДок.Вывести(ОбластьШтрихкода);
		Иначе
			ТабДок.Присоединить(ОбластьШтрихкода);
		КонецЕсли;
		Индекс = ?(Индекс = 1,2,1);
	КонецЦикла;
	Возврат Табдок;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуШтрихкодов()
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаШтрихкодов = Новый ТаблицаЗначений;
	ТаблицаШтрихкодов.Колонки.Добавить("Штрихкод");
	ТаблицаШтрихкодов.Колонки.Добавить("Представление");
	ТЗОбъектыШтрихкодов.Сортировать("ВладелецШтрихкода");	
	Для Каждого Строка ИЗ ТЗОбъектыШтрихкодов Цикл
		Если ТипЗнч(Строка.ВладелецШтрихкода) = Тип("СправочникСсылка.РСК_СкладскиеОперации") Тогда
			Продолжить
		Иначе
			НоваяСтрокаШтрихкод = ТаблицаШтрихкодов.Добавить();
			НоваяСтрокаШтрихкод.Штрихкод      = РегистрыСведений.ИдентификационныеДанныеПользователей.ШтрихкодПоПользователю(Строка.ВладелецШтрихкода);
			НоваяСтрокаШтрихкод.Представление = Строка.ВладелецШтрихкода.Наименование;
		КонецЕсли;				
	КонецЦикла;
	
	Для Каждого Строка ИЗ ТЗОбъектыШтрихкодов Цикл
		Если ТипЗнч(Строка.ВладелецШтрихкода) = Тип("СправочникСсылка.РСК_СкладскиеОперации") Тогда
			НоваяСтрокаШтрихкод = ТаблицаШтрихкодов.Добавить();
			НоваяСтрокаШтрихкод.Штрихкод      = Строка.ВладелецШтрихкода.Код;
			НоваяСтрокаШтрихкод.Представление = Строка.ВладелецШтрихкода.Наименование;
		Иначе
			Продолжить
		КонецЕсли;		
	КонецЦикла;
	Возврат ТаблицаШтрихкодов;
КонецФункции

//&НаКлиенте
//Процедура СписокСотрудниковПередУдалением(Элемент, Отказ)
//	Отказ = Истина;
//	ПоказатьПредупреждение(,"Удалять штрихкоды пользователей можно только в регистре сведений «Идентификационные данные пользователей»");
//КонецПроцедуры

&НаКлиенте
Процедура СписокОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = Элементы.СписокОпераций.ТекущиеДанные;
	НС = ТЗОбъектыШтрихкодов.Добавить();
	НС.ВладелецШтрихкода = ДанныеСтроки.Ссылка;
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = Элементы.СписокСотрудников.ТекущиеДанные;
	НС = ТЗОбъектыШтрихкодов.Добавить();
	НС.ВладелецШтрихкода = ДанныеСтроки.Пользователь;
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковОбновить(Команда)
	ОбновитьСписокСотрудниковСклада();
	Элементы.СписокСотрудников.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьШтрихкодСотрудника(Команда)
	
	НастройкиКомпоновки = Новый НастройкиКомпоновкиДанных;
	ЭлементОтбора = НастройкиКомпоновки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = ПолучитьСписокПользователейБезШК();
	
	Парам = Новый Структура;
	Парам.Вставить("ФиксированныеНастройки", НастройкиКомпоновки);
	Парам.Вставить("РежимВыбора", Истина);
	Парам.Вставить("МножественныйВыбор", Ложь);
	Парам.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОбработкаВыбора = Новый ОписаниеОповещения("ПослеВыбораПользователя", ЭтаФорма);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Парам, ЭтаФорма,,,,ОбработкаВыбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокПользователейБезШК()
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификационныеДанныеПользователей КАК ИдентификационныеДанныеПользователей
		|		ПО Пользователи.Ссылка = ИдентификационныеДанныеПользователей.Пользователь
		|ГДЕ
		|	ИдентификационныеДанныеПользователей.Пользователь ЕСТЬ NULL
		|	И НЕ Пользователи.ПометкаУдаления";
	
	СписокПользователей = Новый СписокЗначений;
	СписокПользователей.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	Возврат СписокПользователей;

КонецФункции // ПолучитьСписокПользователейБезШК()

&НаКлиенте
Процедура ПослеВыбораПользователя(Значение, ДопПарам) Экспорт

	Если Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьШтрихкодНовогоСотрудникаНаСервере(Значение);
	
	СписокСотрудниковОбновить(Неопределено);

КонецПроцедуры // ПослеВыбораПользователя()

&НаСервереБезКонтекста
Процедура ДобавитьШтрихкодНовогоСотрудникаНаСервере(Пользователь)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификационныеДанныеПользователей.Штрихкод КАК Штрихкод
		|ИЗ
		|	РегистрСведений.ИдентификационныеДанныеПользователей КАК ИдентификационныеДанныеПользователей";
	
	СуществующиеШтрихкоды = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Штрихкод");
	Для ё = 1 По 99999999999 Цикл
		Штрихкод = "20" + Формат(ё, "ЧЦ=11; ЧВН=; ЧГ=0");
		Если СуществующиеШтрихкоды.Найти(Штрихкод) = Неопределено Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Запись = РегистрыСведений.ИдентификационныеДанныеПользователей.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Штрихкод = Штрихкод;
	Запись.Записать();

КонецПроцедуры // ДобавитьШтрихкодНовогоСотрудникаНаСервере()


