﻿//++ РС Консалт: Трофимов Евгений 16.09.2022 Тикет 20359
//e1cib/data/Документ.Задание?ref=94e137c71231048947b8209affeeaed4
&НаСервере
&После("ПоказатьКомандыРаздела")
Процедура РСК_ПоказатьКомандыРаздела(Знач Раздел)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		Элементы.КомандаСопоставитьВсё.Имя, 
		"Видимость", 
		Раздел = "Ознакомиться"
	);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 16.09.2022 Тикет 20359
//e1cib/data/Документ.Задание?ref=94e137c71231048947b8209affeeaed4
&НаКлиенте
Процедура РСК_СопоставитьВсёПосле(Команда)
	ОткрытьФорму("Обработка.РСК_СопоставлениеОбъектовЭДО.Форма.АвтоматическоеСопоставление");
КонецПроцедуры

&НаСервере
&После("ПриСозданииНаСервере")
Процедура РСК_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДобавитьПоляЗаказКлиентаСделкаДоговорВСписок();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПоляЗаказКлиентаСделкаДоговорВСписок()
	
	//++РС Консалт Назаров М.Ю. 15 ноября 2022 г. 8:50:09  
	// Добавлены поля ЗаказКлиента, Сделка, Договор
	ВходящиеЭД.ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ         
	|	Максимум(ДоговорыКонтрагентов.Ссылка) КАК Договор,
	|	Максимум(ОбъектыУчетаДокументооборотаЭДО.ОбъектУчета.РСК_Сделка) КАК Сделка,
	|	Максимум(ЗаказКлиента.Ссылка) КАК ЗаказКлиента,
	|	ЭлектронныеДокументыПереопределяемый.Ссылка КАК ЭлектронныйДокумент,
	|	ЭлектронныеДокументыПереопределяемый.ДатаДокумента КАК Дата,
	|	ЭлектронныеДокументыПереопределяемый.НомерДокумента КАК Номер,
	|	ЭлектронныеДокументыПереопределяемый.Организация КАК Организация,
	|	ЭлектронныеДокументыПереопределяемый.Контрагент КАК Контрагент,
	|	ЭлектронныеДокументыПереопределяемый.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЭлектронныеДокументыПереопределяемый.СуммаДокумента КАК СуммаДокумента,
	|	ЭлектронныеДокументыПереопределяемый.Ответственный КАК Ответственный,
	|	СостоянияЭДОПереопределяемый.Состояние КАК СостояниеЭДО,
	|	ВЫРАЗИТЬ(СостоянияЭДОПереопределяемый.Комментарий КАК СТРОКА(100)) КАК ДополнительнаяИнформация,
	|	ЭлектронныеДокументыПереопределяемый.ВидДокумента КАК ВидДокумента,
	|	ЭлектронныеДокументыПереопределяемый.ВидДокумента.ТипДокумента КАК ТипДокумента,
	|	""КартинкаМК"" КАК КартинкаМК,
	|	ВЫРАЗИТЬ(ЭлектронныеДокументыПереопределяемый.Комментарий КАК СТРОКА(255)) КАК Описание,
	|	&РежимОтображения КАК РежимОтображения,
	|	&СписокПользователей КАК СписокПользователей,
	|	ВЫБОР
	|		КОГДА КонтрольОтраженияПереопределяемый.ЭлектронныйДокумент ЕСТЬ NULL
	|			ТОГДА 3
	|		КОГДА КонтрольОтраженияПереопределяемый.СоздатьУчетныйДокумент
	|		И КонтрольОтраженияПереопределяемый.СопоставитьНоменклатуру
	|			ТОГДА 0
	|		КОГДА КонтрольОтраженияПереопределяемый.СоздатьУчетныйДокумент
	|			ТОГДА 1
	|		КОГДА КонтрольОтраженияПереопределяемый.ПровестиУчетныйДокумент
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК КонтрольОтраженияВУчете,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(300)) КАК ОтражениеВУчете,
	|	СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета КАК ИдентификаторПакета,
	|	ВЫРАЗИТЬ(""22"" КАК СТРОКА(20)) КАК ПредставлениеДокументовВнеОтбора,
	|	Ложь КАК ПервыйДокументПакета,
	|	ДанныеКоличестваДокументовВПакетеПереопределяемый.КоличествоДокументов КАК КоличествоДокументовВПакете,
	|	ВЫБОР
	|		КОГДА ПакетыДокументовЭДОПереопределяемый.Дата ЕСТЬ NULL
	|			ТОГДА ЭлектронныеДокументыПереопределяемый.ДатаДокумента
	|		ИНАЧЕ ПакетыДокументовЭДОПереопределяемый.Дата
	|	КОНЕЦ КАК ДатаПакета,
	|	ЭлектронныеДокументыПереопределяемый.Номер КАК НомерСлужебный,
	|	-1 КАК ИндексКартинкиПакета,
	|	ПакетыДокументовЭДОПереопределяемый.КлючСортировки КАК КлючСортировкиПакета,
	|	ЭлектронныеДокументыПереопределяемый.ВидДокумента.ПорядокСортировкиВПакете КАК ПорядокСортировкиВПакете,
	|	Ложь КАК Четность,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(36)) КАК КлючДокумента,
	|	ВЫРАЗИТЬ(""22"" КАК СТРОКА(36)) КАК КлючПакета,
	|	ВЫБОР
	|		КОГДА ЭлектронныеДокументыПереопределяемый.Дата < &ДатаПереходаНаВерсиюСПрочтенностью И СведенияОПрочтенииПереопределяемый.Прочтен ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		КОГДА СведенияОПрочтенииПереопределяемый.Прочтен ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ СведенияОПрочтенииПереопределяемый.Прочтен
	|	КОНЕЦ КАК Прочтен,
	|	ЕСТЬNULL(ПроверкиЭлектронныхПодписейЭДОПереопределяемый.ЕстьНевалидныеПодписиПоМЧД, ЛОЖЬ) КАК ЕстьНевалидныеПодписиПоМЧД
	|{ВЫБРАТЬ
	|	КонтрольОтраженияВУчете}
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящийЭДО КАК ЭлектронныеДокументыПереопределяемый
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовЭДО КАК СостоянияЭДОПереопределяемый
	|		ПО СостоянияЭДОПереопределяемый.ЭлектронныйДокумент = ЭлектронныеДокументыПереопределяемый.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставПакетовДокументовЭДО КАК СоставПакетовДокументовЭДОПереопределяемый
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета,
	|				КОЛИЧЕСТВО(СоставПакетовДокументовЭДОПереопределяемый.ЭлектронныйДокумент) КАК КоличествоДокументов
	|			ИЗ
	|				РегистрСведений.СоставПакетовДокументовЭДО КАК СоставПакетовДокументовЭДОПереопределяемый
	|			СГРУППИРОВАТЬ ПО
	|				СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета) КАК ДанныеКоличестваДокументовВПакетеПереопределяемый
	|			ПО СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета = ДанныеКоличестваДокументовВПакетеПереопределяемый.ИдентификаторПакета
	|		ПО СоставПакетовДокументовЭДОПереопределяемый.ЭлектронныйДокумент = ЭлектронныеДокументыПереопределяемый.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыДокументовЭДО КАК ПакетыДокументовЭДОПереопределяемый
	|		ПО СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета = ПакетыДокументовЭДОПереопределяемый.ИдентификаторПакета
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрольОтраженияВУчетеЭДО КАК КонтрольОтраженияПереопределяемый
	|		ПО ЭлектронныеДокументыПереопределяемый.Ссылка = КонтрольОтраженияПереопределяемый.ЭлектронныйДокумент}
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПрочтенииДокументовЭДО КАК СведенияОПрочтенииПереопределяемый
	|		ПО ЭлектронныеДокументыПереопределяемый.Ссылка = СведенияОПрочтенииПереопределяемый.Объект
	|			И (СведенияОПрочтенииПереопределяемый.Пользователь = &Пользователь)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкиЭлектронныхПодписейЭДО КАК ПроверкиЭлектронныхПодписейЭДОПереопределяемый
	|		ПО ЭлектронныеДокументыПереопределяемый.Ссылка = ПроверкиЭлектронныхПодписейЭДОПереопределяемый.ЭлектронныйДокумент
	//++РС Консалт Назаров М.Ю. 16 ноября 2022 г. 12:55:24                  
	// Было добавлено
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыУчетаДокументовЭДО КАК ОбъектыУчетаДокументооборотаЭДО
	|		ПО (ОбъектыУчетаДокументооборотаЭДО.ЭлектронныйДокумент = ЭлектронныеДокументыПереопределяемый.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО (ДоговорыКонтрагентов.ГосударственныйКонтракт = ОбъектыУчетаДокументооборотаЭДО.ОбъектУчета)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК заказклиента
	|		ПО (ЗаказКлиента.Договор = ДоговорыКонтрагентов.Ссылка)
	|			И (ЗаказКлиента.ПометкаУдаления = ЛОЖЬ)
	|			И (ОбъектыУчетаДокументооборотаЭДО.ОбъектУчета.РСК_Сделка = ЗаказКлиента.Сделка)
	//--РС Консалт Назаров М.Ю. 16 ноября 2022 г. 12:55:24
	|ГДЕ
	|	НЕ ЭлектронныеДокументыПереопределяемый.ПометкаУдаления 
	
	
	|{ГДЕ
	|	СостоянияЭДОПереопределяемый.Состояние КАК СостояниеЭДО,
	|	(1 В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			1
	|		ИЗ
	|			РегистрСведений.ОбъектыУчетаДокументовЭДО КАК ОбъектыУчетаДокументооборотаЭДО
	|		ГДЕ
	|			ОбъектыУчетаДокументооборотаЭДО.ЭлектронныйДокумент = ЭлектронныеДокументыПереопределяемый.Ссылка)) КАК ЕстьОснование,
	|	(1 В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			1
	|		ИЗ
	|			РегистрСведений.КонтрольОтраженияВУчетеЭДО КАК КонтрольПереопределяемый
	|		ГДЕ
	|			ЭлектронныеДокументыПереопределяемый.Ссылка = КонтрольПереопределяемый.ЭлектронныйДокумент)) КАК ЕстьКонтрольОтражения}
	|СГРУППИРОВАТЬ ПО
	|ЭлектронныеДокументыПереопределяемый.Ссылка,
	|ЭлектронныеДокументыПереопределяемый.ДатаДокумента,
	|ЭлектронныеДокументыПереопределяемый.НомерДокумента,
	|ЭлектронныеДокументыПереопределяемый.Организация,
	|ЭлектронныеДокументыПереопределяемый.Контрагент,
	|ЭлектронныеДокументыПереопределяемый.ДоговорКонтрагента,
	|ЭлектронныеДокументыПереопределяемый.СуммаДокумента,
	|ЭлектронныеДокументыПереопределяемый.Ответственный,
	|СостоянияЭДОПереопределяемый.Состояние,
	|ЭлектронныеДокументыПереопределяемый.ВидДокумента,
	|ЭлектронныеДокументыПереопределяемый.ВидДокумента.ТипДокумента,
	|СоставПакетовДокументовЭДОПереопределяемый.ИдентификаторПакета,
	|ДанныеКоличестваДокументовВПакетеПереопределяемый.КоличествоДокументов,
	|ЭлектронныеДокументыПереопределяемый.Номер,
	|ПакетыДокументовЭДОПереопределяемый.КлючСортировки,
	|ЭлектронныеДокументыПереопределяемый.ВидДокумента.ПорядокСортировкиВПакете,
	|ВЫРАЗИТЬ(СостоянияЭДОПереопределяемый.Комментарий КАК СТРОКА(100)),
	|ВЫРАЗИТЬ(ЭлектронныеДокументыПереопределяемый.Комментарий КАК СТРОКА(255)),
	|ВЫБОР
	|	КОГДА КонтрольОтраженияПереопределяемый.ЭлектронныйДокумент ЕСТЬ NULL
	|		ТОГДА 3
	|	КОГДА КонтрольОтраженияПереопределяемый.СоздатьУчетныйДокумент
	|			И КонтрольОтраженияПереопределяемый.СопоставитьНоменклатуру
	|		ТОГДА 0
	|	КОГДА КонтрольОтраженияПереопределяемый.СоздатьУчетныйДокумент
	|		ТОГДА 1
	|	КОГДА КонтрольОтраженияПереопределяемый.ПровестиУчетныйДокумент
	|		ТОГДА 2
	|	ИНАЧЕ 3
	|КОНЕЦ,
	|ВЫБОР
	|	КОГДА ПакетыДокументовЭДОПереопределяемый.Дата ЕСТЬ NULL
	|		ТОГДА ЭлектронныеДокументыПереопределяемый.ДатаДокумента
	|	ИНАЧЕ ПакетыДокументовЭДОПереопределяемый.Дата
	|КОНЕЦ,
	|ВЫБОР
	|	КОГДА ЭлектронныеДокументыПереопределяемый.Дата < &ДатаПереходаНаВерсиюСПрочтенностью
	|			И СведенияОПрочтенииПереопределяемый.Прочтен ЕСТЬ NULL
	|		ТОГДА ИСТИНА
	|	КОГДА СведенияОПрочтенииПереопределяемый.Прочтен ЕСТЬ NULL
	|		ТОГДА ЛОЖЬ
	|	ИНАЧЕ СведенияОПрочтенииПереопределяемый.Прочтен
	|КОНЕЦ,
	|ЕСТЬNULL(ПроверкиЭлектронныхПодписейЭДОПереопределяемый.ЕстьНевалидныеПодписиПоМЧД, ЛОЖЬ)";	
	//--РС Консалт Назаров М.Ю. 15 ноября 2022 г. 8:50:09  
	
	//ВходящиеЭД.ТекстЗапроса = СтрЗаменить(ВходящиеЭД.ТекстЗапроса, "&ДатаНачалаОтсчета", РСК_ВызовСервера.ДатаНачалоОтсчетаПоискаЗаказовКлиентаЭДО());

КонецПроцедуры

&НаКлиенте
&ИзменениеИКонтроль("ВходящиеЭДВыбор")
Процедура РСК_ВходящиеЭДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);

	ЭтоКаталогТоваров = (ДанныеСтроки.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.КаталогТоваров"));

	Если Поле.Имя = "ВходящиеЭДОтражениеВУчете" И Не ЭтоКаталогТоваров Тогда
		СтандартнаяОбработка = Ложь;

		Если ДанныеСтроки.КонтрольОтраженияВУчете = 0 Тогда

			ПоказатьСопоставлениеНоменклатуры();

		ИначеЕсли ДанныеСтроки.КонтрольОтраженияВУчете = 1 Тогда

			ПоказатьРасширенныйПодборДокументовУчета();

		Иначе

			ПоказатьУчетныйДокумент();

		КонецЕсли; 
		#Вставка
		//++РС Консалт Назаров М.Ю. 15 ноября 2022 г. 13:51:42                  
	ИначеЕсли Поле.Имя = "ВходящиеЭДСделка" И ЗначениеЗаполнено(ДанныеСтроки.Сделка) Тогда 
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ДанныеСтроки.Сделка);		
	ИначеЕсли Поле.Имя = "ВходящиеЭДЗаказКлиента" И ЗначениеЗаполнено(ДанныеСтроки.ЗаказКлиента) Тогда 
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ДанныеСтроки.ЗаказКлиента);		
	ИначеЕсли Поле.Имя = "ВходящиеЭДДоговор" И ЗначениеЗаполнено(ДанныеСтроки.Договор) Тогда 
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ДанныеСтроки.Договор);		
		//--РС Консалт Назаров М.Ю. 15 ноября 2022 г. 13:51:42
		#КонецВставки
		
	Иначе
		СтандартнаяОбработка = Ложь;
		ОткрытьЭлектронныйДокументДляПросмотра(ДанныеСтроки);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
&ИзменениеИКонтроль("СоздатьОтборПоРазделу")
Процедура РСК_СоздатьОтборПоРазделу(Знач Раздел, Знач НастройкиОтображения, ГруппаОтбора)

		// Изменения в отборы вносить согласовано с текстами запросов количества элементов в разделе.
	// См. метод ТекстЗапросаКоличестваЭлементовПоРазделуБезОтбора.
	РежимОтображения = НастройкиОтображения.РежимОтображения;
	СписокПользователей = НастройкиОтображения.СписокПользователей;

	Если Раздел = "Входящие" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;
		
		ЗначенияСостояниеЭДО = Новый Массив;
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.Аннулирован"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОбменЗавершен"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытПринудительно"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытСОтклонением"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", ЗначенияСостояниеЭДО, ВидСравненияКомпоновкиДанных.НеВСписке, , Истина);
	
	
	ИначеЕсли Раздел = "Обработать" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значение = Истина;

		#Удаление
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "ЕстьКонтрольОтражения", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		#КонецУдаления

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяУточнение"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.Аннулирован"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеАннулирования"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяОтправкаАннулирования"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.НеСформирован"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытПринудительно"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытСОтклонением"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СостояниеЭДО", Значение, ВидСравненияКомпоновкиДанных.НеВСписке,, Истина);

	ИначеЕсли Раздел = "Утвердить" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значение = ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяУтверждение");

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значение, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли Раздел = "Подписать" Тогда

		Если РежимОтображения = "МоиДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значения = Новый Массив;
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписание"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значения, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "Исправить" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяУточнение"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "Аннулировать" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значение = ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодтверждениеАннулирования");

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значение, ВидСравненияКомпоновкиДанных.Равно, , Истина);

	ИначеЕсли Раздел = "НаКонтроле" Тогда

		Если РежимОтображения = "МоиДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "РежимОтображения", "КИсполнению", ВидСравненияКомпоновкиДанных.НеРавно, , Истина);

		ЗначенияСостояниеЭДО = Новый Массив;
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИсправление"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПередачаОператору"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждение"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяОтветНаПриглашение"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении"));
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", ЗначенияСостояниеЭДО, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "Исходящие" Тогда

		Если РежимОтображения = "МоиДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;		
		
		ЗначенияСостояниеЭДО = Новый Массив;
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.Аннулирован"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОбменЗавершен"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытПринудительно"));
		ЗначенияСостояниеЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ЗакрытСОтклонением"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", ЗначенияСостояниеЭДО, ВидСравненияКомпоновкиДанных.НеВСписке, , Истина);
	
	ИначеЕсли Раздел = "ПодписатьИсх" Тогда

		Если РежимОтображения = "МоиДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		ИначеЕсли РежимОтображения = "КИсполнению" Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "НаПодпись", Истина, 
				ВидСравненияКомпоновкиДанных.Равно, , Истина);

		КонецЕсли;

		Значения = Новый Массив;
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписание"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещенияПоОтклонению"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значения, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "ИсправитьИсх" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяУточнение"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "АннулироватьИсх" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;
		
		Значения = Новый Массив;
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеАннулирования"));
		Значения.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодтверждениеАннулирования"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", Значения, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "НаКонтролеИсх" Тогда

		Если РежимОтображения = "МоиДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "РежимОтображения", "КИсполнению", ВидСравненияКомпоновкиДанных.НеРавно, , Истина);

		ЗначенияСостоянийЭДО = Новый Массив;
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИсправление"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПередачаОператору"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждение"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяОтветНаПриглашение"));
		ЗначенияСостоянийЭДО.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СостояниеЭДО", ЗначенияСостоянийЭДО, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "Ознакомиться" Тогда

		Если РежимОтображения <> "ВсеДокументы" Тогда

			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ответственный", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

		КонецЕсли;

	ИначеЕсли Раздел = "Отправить" Тогда

		
	ИначеЕсли Раздел = "Распаковать" Тогда

		Значение = ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Входящий");

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Направление", Значение, ВидСравненияКомпоновкиДанных.Равно, , Истина);

		Значение = ТранспортныеКонтейнерыЭДО.СтатусыНеРаспакованныхТранспортныхСообщенийБЭД();

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Статус", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "ТребуетсяПригласить" Тогда

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПриглашений.ТребуетсяОтправить"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СтатусПодключения", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "ЖдемСогласия" Тогда

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПриглашений.ОжидаемСогласия"));
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПриглашений.НастройкаРоуминга"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СтатусПодключения", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "ТребуетсяСогласие" Тогда

		Значение = Новый Массив;
		Значение.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПриглашений.ТребуетсяСогласие"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "СтатусПодключения", Значение, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

	ИначеЕсли Раздел = "ПриглашенияОзнакомиться" Тогда

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Ознакомиться", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);

	КонецЕсли;

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("УстановитьПараметрыСписковРазделов")
Процедура РСК_УстановитьПараметрыСписковРазделов(Знач НастройкиОтображения)

	Форма = ЭтотОбъект;

	ТекущийПользователь = Пользователи.ТекущийПользователь();
	ДатаПереходаНаВерсиюСПрочтенностью = РаботаСПрочтениямиВызовСервера.ПолучитьДатуПереходаНаВерсиюСПрочтенностью();

	ОграничениеОтбора = Новый Массив;
	ОграничениеОтбора.Добавить("СписокПользователей");
	ОграничениеОтбора.Добавить("ПараметрыДанных");

	ИмяСписка = СписокРаздела("Входящие");
	Список = Форма[ИмяСписка];
	Список.Параметры.УстановитьЗначениеПараметра("РежимОтображения", НастройкиОтображения.РежимОтображения);
	Список.Параметры.УстановитьЗначениеПараметра("СписокПользователей", НастройкиОтображения.СписокПользователей);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаПереходаНаВерсиюСПрочтенностью", ДатаПереходаНаВерсиюСПрочтенностью);
	#Удаление
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеНаУдаление", НастройкиОтображения.ПоказыватьПомеченныеНаУдаление);
	#КонецУдаления
	Список.УстановитьОграниченияИспользованияВОтборе(ОграничениеОтбора);

	ИмяСписка = СписокРаздела("Исходящие");
	Список = Форма[ИмяСписка];
	Список.Параметры.УстановитьЗначениеПараметра("РежимОтображения", НастройкиОтображения.РежимОтображения);
	Список.Параметры.УстановитьЗначениеПараметра("СписокПользователей", НастройкиОтображения.СписокПользователей);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаПереходаНаВерсиюСПрочтенностью", ДатаПереходаНаВерсиюСПрочтенностью);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеНаУдаление", НастройкиОтображения.ПоказыватьПомеченныеНаУдаление);
	Список.УстановитьОграниченияИспользованияВОтборе(ОграничениеОтбора);

	ИмяСписка = СписокРаздела("Ознакомиться");
	Список = Форма[ИмяСписка];
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеНаУдаление", НастройкиОтображения.ПоказыватьПомеченныеНаУдаление);
	Список.УстановитьОграниченияИспользованияВОтборе(ОграничениеОтбора);

	ИмяСписка = СписокРаздела("Отправить");
	Список = Форма[ИмяСписка];
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеНаУдаление", НастройкиОтображения.ПоказыватьПомеченныеНаУдаление);
	Список.УстановитьОграниченияИспользованияВОтборе(ОграничениеОтбора);

	ИмяСписка = СписокРаздела("Ошибки");
	Список = Форма[ИмяСписка];
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеНаУдаление", НастройкиОтображения.ПоказыватьПомеченныеНаУдаление);
	Список.УстановитьОграниченияИспользованияВОтборе(ОграничениеОтбора);

КонецПроцедуры
