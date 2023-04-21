﻿ 
//++ РС Консалт: Минаков А.С.: Неисправность из-за режима совместимости  
&ИзменениеИКонтроль("ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий")
Функция РСК_ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий()

	ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий = Новый Массив;

	ОписанияИспользованияРеквизитовСерии = Справочники.ВидыНоменклатуры.ОписанияИспользованияРеквизитовСерии();

	Для Каждого Описания из ОписанияИспользованияРеквизитовСерии Цикл

		Если Не ПустаяСтрока(Описания.ОсобенностиУчета) Тогда

			ИменаОсобенностей = СтрРазделить(Описания.ОсобенностиУчета, ",");

			Для Каждого ИмяОсобенности из ИменаОсобенностей Цикл
				
				#Вставка
				//++ РС Консалт: Минаков А.С.: Неисправность из-за режима совместимости 
				Если ИмяОсобенности = "ПродукцияМаркируемаяДляГИСМ" Тогда
					ЗначениеПеречисления = Неопределено
				Иначе
					//++ РС Консалт: Минаков А.С.: Неисправность из-за режима совместимости 
					#КонецВставки
					ЗначениеПеречисления = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры." + ИмяОсобенности);
					#Вставка
					//++ РС Консалт: Минаков А.С.: Неисправность из-за режима совместимости 
				КонецЕсли;
				//++ РС Консалт: Минаков А.С.: Неисправность из-за режима совместимости 
				#КонецВставки

				Если ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий.Найти(ЗначениеПеречисления) = Неопределено Тогда
					ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий.Добавить(ЗначениеПеречисления);
				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

	Возврат ОсобенностиУчетаОтКоторыхЗависятРеквизитыСерий;

КонецФункции

//++ Конарев И.И.: Новые правила формирования артикула номенклатуры в документе 
&ИзменениеИКонтроль("ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВСтруктуре")
Процедура РСК_ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВСтруктуре(СтруктураДанных, СтруктураДействий)
	
	#Вставка 
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакАртикул") Тогда 
		СтруктураДействий.Удалить("ЗаполнитьПризнакАртикул");
		ЗаполнитьАртикулСтрокиПоПравилу(СтруктураДанных);
	КонецЕсли;
	#КонецВставки
	ОбработкаТабличнойЧастиСервер.НормализоватьДействия(СтруктураДействий);

	СтруктураДопДанных = ОбработкаТабличнойЧастиСервер.ОписаниеДополнительнойИнформации(СтруктураДействий);

	ТаблицаВыгрузки = Новый ТаблицаЗначений;
	ТаблицаВыгрузки.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	Для Каждого Источник Из СтруктураДопДанных.СтруктураИсточников Цикл
		ТаблицаВыгрузки.Колонки.Добавить(Источник.Ключ, ОбщегоНазначенияУТ.ОписаниеТиповПоТипу(ТипЗнч(СтруктураДанных[Источник.Ключ])));
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(ТаблицаВыгрузки.Добавить(), СтруктураДанных);

	Запрос = Новый Запрос(ОбработкаТабличнойЧастиСервер.ПолучитьТекстЗапросаПоСлужебнымРеквизитамТЧ(СтруктураДействий, СтруктураДопДанных));
	Запрос.УстановитьПараметр("КоллекцияДанных", ТаблицаВыгрузки);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка, СтруктураДопДанных.РеквизитыЗаполнения);
	КонецЕсли;

КонецПроцедуры 

Процедура ЗаполнитьАртикулСтрокиПоПравилу(СтруктураДанных)
	
	АртикулНоменклатуры   = "";
	АртикулХарактеристики = "";
	АртикулСерии		  = "";  
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(СтруктураДанных.Номенклатура);
	Если СтруктураДанных.Свойство("Серия") И ЗначениеЗаполнено(СтруктураДанных.Серия) Тогда
		МассивОбъектов.Добавить(СтруктураДанных.Серия); 
	КонецЕсли; 
	Если СтруктураДанных.Свойство("Характеристика") И ЗначениеЗаполнено(СтруктураДанных.Характеристика)
		И  (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураДанных.Характеристика,"Владелец") = СтруктураДанных.Номенклатура
		ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураДанных.Характеристика,"Владелец") = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураДанных.Номенклатура,"ВладелецХарактеристик")) Тогда
		МассивОбъектов.Добавить(СтруктураДанных.Характеристика); 
	КонецЕсли;
	
	ЗначенияАртикула = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивОбъектов, "Артикул", Истина);  
	
	АртикулНоменклатуры   = ЗначенияАртикула.Получить(СтруктураДанных.Номенклатура);  
	Если СтруктураДанных.Свойство("Характеристика") Тогда
		АртикулХарактеристики = ?(ЗначениеЗаполнено(АртикулНоменклатуры) И ЗначениеЗаполнено(ЗначенияАртикула.Получить(СтруктураДанных.Характеристика)),
								СтрШаблон("-%1",ЗначенияАртикула.Получить(СтруктураДанных.Характеристика)),
								Строка(ЗначенияАртикула.Получить(СтруктураДанных.Характеристика))); 
	КонецЕсли;
	Если СтруктураДанных.Свойство("Серия") Тогда							
    	АртикулСерии          = ?(ЗначениеЗаполнено(ЗначенияАртикула.Получить(СтруктураДанных.Серия)) И (ЗначениеЗаполнено(АртикулНоменклатуры) ИЛИ ЗначениеЗаполнено(АртикулХарактеристики)),
								СтрШаблон("-%1",ЗначенияАртикула.Получить(СтруктураДанных.Серия)),
								Строка(ЗначенияАртикула.Получить(СтруктураДанных.Серия)));
	КонецЕсли;
	//Структура артикула: артикул номенклатуры - артикул характеристки - артикул серии
	Артикул = СтрШаблон("%1%2%3",АртикулНоменклатуры, АртикулХарактеристики, АртикулСерии);  
	Если СтруктураДанных.Свойство("Артикул") Тогда
		СтруктураДанных.Артикул = Артикул;
	КонецЕсли;
	
КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции")
Процедура РСК_ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(КоллекцияДанных, СтруктураДействий, СтрокиЗаполнения)
	
	#Вставка 
	НеобходимоЗаполнитьАртикул = СтруктураДействий.Свойство("ЗаполнитьПризнакАртикул");
	Если НеобходимоЗаполнитьАртикул Тогда
		СтруктураДействий.Удалить("ЗаполнитьПризнакАртикул");		
	КонецЕсли;
	#КонецВставки
	ОбработкаТабличнойЧастиСервер.НормализоватьДействия(СтруктураДействий);

	СтруктураДопДанных = ОбработкаТабличнойЧастиСервер.ОписаниеДополнительнойИнформации(СтруктураДействий);
	Колонки = "НомерСтроки" + СтруктураДопДанных.РеквизитыВыгрузки;

	Если СтрокиЗаполнения = Неопределено Тогда

		Если ТипЗнч(КоллекцияДанных) = Тип("ТаблицаЗначений") Тогда
			ПараметрКоллекция = КоллекцияДанных;
		Иначе
			ПараметрКоллекция = КоллекцияДанных.Выгрузить(, Колонки);
		КонецЕсли;

	ИначеЕсли СтрокиЗаполнения.Количество() > 0 Тогда

		Если ТипЗнч(КоллекцияДанных) = Тип("ТаблицаЗначений") Тогда
			ПараметрКоллекция = КоллекцияДанных.Скопировать(СтрокиЗаполнения, Колонки);
		Иначе
			ПараметрКоллекция = КоллекцияДанных.Выгрузить(СтрокиЗаполнения, Колонки);
		КонецЕсли;

	Иначе
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос(ОбработкаТабличнойЧастиСервер.ПолучитьТекстЗапросаПоСлужебнымРеквизитамТЧ(СтруктураДействий, СтруктураДопДанных));
	Запрос.УстановитьПараметр("КоллекцияДанных", ПараметрКоллекция);

	Если СтрокиЗаполнения <> Неопределено Тогда

		ТЗРезультат = Запрос.Выполнить().Выгрузить(); // ТабличнаяЧасть
		Для Каждого Стр Из ТЗРезультат Цикл
			ЗаполнитьЗначенияСвойств(КоллекцияДанных[Стр.НомерСтроки - 1], Стр, СтруктураДопДанных.РеквизитыЗаполнения); 
			#Вставка
			Если НеобходимоЗаполнитьАртикул Тогда
				ЗаполнитьАртикулСтрокиПоПравилу(КоллекцияДанных[Стр.НомерСтроки - 1]);	
			КонецЕсли;
			#КонецВставки
		КонецЦикла;

	Иначе

		Выборка = Запрос.Выполнить().Выбрать();
		Для Номер = 0 По КоллекцияДанных.Количество()-1 Цикл
			Выборка.Следующий(); // Количество строк в выборке по запросу всегда равно количеству строк в коллекции
			ЗаполнитьЗначенияСвойств(КоллекцияДанных[Номер], Выборка, СтруктураДопДанных.РеквизитыЗаполнения);
			#Вставка
			Если НеобходимоЗаполнитьАртикул Тогда
				ЗаполнитьАртикулСтрокиПоПравилу(КоллекцияДанных[Номер]);	
			КонецЕсли;
			#КонецВставки
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("ПроверитьОкруглениеКоличестваВнутренний")
Функция РСК_ПроверитьОкруглениеКоличестваВнутренний(Объект, ПараметрыПроверки, ДопустимыйПроцентОтклонения)

	ИмяТЧ = ПараметрыПроверки.ИмяТЧ;
	ИменаПолейССуффиксом = ПараметрыПроверки.ИменаПолейССуффиксом;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТЧ.НомерСтроки КАК НомерСтроки,
	|	ТЧ.Номенклатура КАК Номенклатура,
	#Удаление
	|	ВЫРАЗИТЬ(ТЧ.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения.ТипИзмеряемойВеличины КАК ТипИзмеряемойВеличины,
	#КонецУдаления
	|	ТЧ.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТЧ.Количество КАК КоличествоВДокументе,
	|	ВЫРАЗИТЬ(ТЧ.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения) КАК Упаковка,
	#Удаление
	|	ВЫРАЗИТЬ(ТЧ.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения).ТипУпаковки КАК ТипУпаковки,
	|	&ТекстЗапросаКоэффициентУпаковки КАК КоэффициентУпаковки,
	#КонецУдаления
	|	&ИмяПоляКоличествоУпаковокСуффикс КАК КоличествоУпаковокСуффикс,
	#Удаление
	|	&ИмяПоляКоличествоСуффикс КАК КоличествоВДокументеСуффикс,
	|	&ДополнительныеПоля
	|ПОМЕСТИТЬ ВТДляЗапроса
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Трофимов Евгений 02.04.2023 Тикет 24845
	//e1cib/data/Документ.Задание?ref=8bce2d229394a92d4a0490a0e5eff6de
	|	&ИмяПоляКоличествоСуффикс КАК КоличествоВДокументеСуффикс,
	|	&ДополнительныеПоля
	|ПОМЕСТИТЬ ВТДляЗапроса_Было
	//-- КонецТикета 24845	
	#КонецВставки
	|ИЗ
	|	&ТЧ КАК ТЧ
	|ГДЕ
	|	ТЧ.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	И &УсловиеОтбораСтрокДляОкругления
	|
	#Удаление
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипИзмеряемойВеличины
	#КонецУдаления
	|;
	#Вставка
	//++ РС Консалт: Трофимов Евгений 02.04.2023 Тикет 24845
	//e1cib/data/Документ.Задание?ref=8bce2d229394a92d4a0490a0e5eff6de
	//Такой подход исправляет ошибку:
	//{(4, 55)}: Поле не найдено "ЕдиницаИзмерения.ТипИзмеряемойВеличины"
	//ВЫРАЗИТЬ(ТЧ.Номенклатура КАК Справочник.Номенклатура)<<?>>.ЕдиницаИзмерения.ТипИзмеряемойВеличины КАК ТипИзмеряемойВеличины,
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДляЗапроса_Было.НомерСтроки КАК НомерСтроки,
	|	ВТДляЗапроса_Было.Номенклатура КАК Номенклатура,
	|	ВТДляЗапроса_Было.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВТДляЗапроса_Было.КоличествоВДокументе КАК КоличествоВДокументе,
	|	ВТДляЗапроса_Было.Упаковка КАК Упаковка,
	|	ВТДляЗапроса_Было.КоличествоУпаковокСуффикс КАК КоличествоУпаковокСуффикс,
	|	ВТДляЗапроса_Было.КоличествоВДокументеСуффикс КАК КоличествоВДокументеСуффикс,
	|	&ТекстЗапросаКоэффициентУпаковки КАК КоэффициентУпаковки,
	|	спрНоменклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины КАК ТипИзмеряемойВеличины,
	|	УпаковкиЕдиницыИзмерения.ТипУпаковки КАК ТипУпаковки,
	|	&РСК_ПоляДоп
	|ПОМЕСТИТЬ ВТДляЗапроса
	|ИЗ
	|	ВТДляЗапроса_Было КАК ВТДляЗапроса_Было
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО ВТДляЗапроса_Было.Номенклатура = спрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|		ПО ВТДляЗапроса_Было.Упаковка = УпаковкиЕдиницыИзмерения.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипИзмеряемойВеличины
	|;
	//-- КонецТикета 24845	
	#КонецВставки
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДляЗапроса.НомерСтроки,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения).ТипИзмеряемойВеличины В (&МерныеТипы) КАК МожноОкруглять,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
	|	ВТДляЗапроса.Номенклатура,
	|	ВТДляЗапроса.Упаковка,
	|	ВТДляЗапроса.КоэффициентУпаковки КАК КоэффициентУпаковки,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.КоличествоУпаковок * ВТДляЗапроса.КоэффициентУпаковки КАК ЧИСЛО(15, 3)) КАК Количество,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.КоличествоУпаковок * ВТДляЗапроса.КоэффициентУпаковки КАК ЧИСЛО(15, 0)) КАК КоличествоОкругленное,
	|	ВТДляЗапроса.КоличествоВДокументе КАК КоличествоВДокументе,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.КоличествоУпаковокСуффикс * ВТДляЗапроса.КоэффициентУпаковки КАК ЧИСЛО(15, 3)) КАК КоличествоСуффикс,
	|	ВЫРАЗИТЬ(ВТДляЗапроса.КоличествоУпаковокСуффикс * ВТДляЗапроса.КоэффициентУпаковки КАК ЧИСЛО(15, 0)) КАК КоличествоСуффиксОкругленное,
	|	ВТДляЗапроса.КоличествоВДокументеСуффикс КАК КоличествоВДокументеСуффикс
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	ВТДляЗапроса КАК ВТДляЗапроса
	|ГДЕ
	|	ВТДляЗапроса.ТипИзмеряемойВеличины = &ШтучныйТип
	|	И ВТДляЗапроса.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|	И &УсловиеОтбораСтрокПоДополнительнымПолям
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧ.НомерСтроки КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ТЧ.БазоваяЕдиницаИзмерения) КАК БазоваяЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(ТЧ.Упаковка) КАК Упаковка,
	|	ТЧ.КоличествоОкругленное КАК КоличествоОкругленное,
	|	ТЧ.КоличествоСуффиксОкругленное КАК КоличествоСуффиксОкругленное,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &ПроверитьВозможностьОкругления
	|					И ТЧ.МожноОкруглять
	|				ТОГДА ВЫБОР
	|						КОГДА ТЧ.Количество - ТЧ.КоличествоОкругленное > 0
	|							ТОГДА ТЧ.Количество - ТЧ.КоличествоОкругленное
	|						ИНАЧЕ ТЧ.КоличествоОкругленное - ТЧ.Количество
	|					КОНЕЦ
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ТЧ.КоличествоВДокументе - ТЧ.Количество > 0
	|						ТОГДА ТЧ.КоличествоВДокументе - ТЧ.Количество
	|					ИНАЧЕ ТЧ.Количество - ТЧ.КоличествоВДокументе
	|				КОНЕЦ
	|		КОНЕЦ / ТЧ.КоэффициентУпаковки КАК ЧИСЛО(15, 3)) КАК КоличествоОтклонение,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &ПроверитьВозможностьОкругления
	|					И ТЧ.МожноОкруглять
	|				ТОГДА &ДопустимыйПроцентОтклонения * ТЧ.КоличествоОкругленное / ТЧ.КоэффициентУпаковки / 100
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЧИСЛО(15, 3)) КАК КоличествоМаксимальнаяПогрешность,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &ПроверитьВозможностьОкругления
	|				ТОГДА ВЫБОР
	|						КОГДА ТЧ.КоличествоСуффикс - ТЧ.КоличествоСуффиксОкругленное > 0
	|							ТОГДА ТЧ.КоличествоСуффикс - ТЧ.КоличествоСуффиксОкругленное
	|						ИНАЧЕ ТЧ.КоличествоСуффиксОкругленное - ТЧ.КоличествоСуффикс
	|					КОНЕЦ
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ТЧ.КоличествоВДокументеСуффикс - ТЧ.КоличествоСуффикс > 0
	|						ТОГДА ТЧ.КоличествоВДокументеСуффикс - ТЧ.КоличествоСуффикс
	|					ИНАЧЕ ТЧ.КоличествоСуффикс - ТЧ.КоличествоВДокументеСуффикс
	|				КОНЕЦ
	|		КОНЕЦ / ТЧ.КоэффициентУпаковки КАК ЧИСЛО(15, 3)) КАК КоличествоСуффиксОтклонение,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА &ПроверитьВозможностьОкругления
	|					И ТЧ.МожноОкруглять
	|				ТОГДА &ДопустимыйПроцентОтклонения * ТЧ.КоличествоСуффиксОкругленное / ТЧ.КоэффициентУпаковки / 100
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЧИСЛО(15, 3)) КАК КоличествоСуффиксМаксимальнаяПогрешность
	|ИЗ
	|	ВТ КАК ТЧ
	|ГДЕ
	|	((ВЫРАЗИТЬ(ВЫБОР
	|					КОГДА &ПроверитьВозможностьОкругления
	|							И ТЧ.МожноОкруглять
	|						ТОГДА ВЫБОР
	|								КОГДА ТЧ.Количество - ТЧ.КоличествоОкругленное > 0
	|									ТОГДА ТЧ.Количество - ТЧ.КоличествоОкругленное
	|								ИНАЧЕ ТЧ.КоличествоОкругленное - ТЧ.Количество
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ТЧ.КоличествоВДокументе - ТЧ.Количество > 0
	|								ТОГДА ТЧ.КоличествоВДокументе - ТЧ.Количество
	|							ИНАЧЕ ТЧ.Количество - ТЧ.КоличествоВДокументе
	|						КОНЕЦ
	|				КОНЕЦ / ТЧ.КоэффициентУпаковки КАК ЧИСЛО(15, 3))) > (ВЫРАЗИТЬ(ВЫБОР
	|					КОГДА &ПроверитьВозможностьОкругления
	|							И ТЧ.МожноОкруглять
	|						ТОГДА &ДопустимыйПроцентОтклонения * ТЧ.КоличествоОкругленное / ТЧ.КоэффициентУпаковки / 100
	|					ИНАЧЕ 0
	|				КОНЕЦ КАК ЧИСЛО(15, 3)))
	|			ИЛИ (ВЫРАЗИТЬ(ВЫБОР
	|					КОГДА &ПроверитьВозможностьОкругления
	|							И ТЧ.МожноОкруглять
	|						ТОГДА ВЫБОР
	|								КОГДА ТЧ.КоличествоСуффикс - ТЧ.КоличествоСуффиксОкругленное > 0
	|									ТОГДА ТЧ.КоличествоСуффикс - ТЧ.КоличествоСуффиксОкругленное
	|								ИНАЧЕ ТЧ.КоличествоСуффиксОкругленное - ТЧ.КоличествоСуффикс
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ТЧ.КоличествоВДокументеСуффикс - ТЧ.КоличествоСуффикс > 0
	|								ТОГДА ТЧ.КоличествоВДокументеСуффикс - ТЧ.КоличествоСуффикс
	|							ИНАЧЕ ТЧ.КоличествоСуффикс - ТЧ.КоличествоВДокументеСуффикс
	|						КОНЕЦ
	|				КОНЕЦ / ТЧ.КоэффициентУпаковки КАК ЧИСЛО(15, 3))) > (ВЫРАЗИТЬ(ВЫБОР
	|					КОГДА &ПроверитьВозможностьОкругления
	|							И ТЧ.МожноОкруглять
	|						ТОГДА &ДопустимыйПроцентОтклонения * ТЧ.КоличествоСуффиксОкругленное / ТЧ.КоэффициентУпаковки / 100
	|					ИНАЧЕ 0
	|				КОНЕЦ КАК ЧИСЛО(15, 3))))
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Если ИменаПолейССуффиксом.Свойство("Количество") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПоляКоличествоСуффикс", "ТЧ." + ИменаПолейССуффиксом.Количество);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПоляКоличествоУпаковокСуффикс", "ТЧ." + ИменаПолейССуффиксом.КоличествоУпаковок);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПоляКоличествоСуффикс", "0");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПоляКоличествоУпаковокСуффикс", "0");
	КонецЕсли;

	#Удаление
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"&ТекстЗапросаКоэффициентУпаковки",
	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
	"ВЫРАЗИТЬ(ТЧ.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)",
	"ВЫРАЗИТЬ(ТЧ.Номенклатура КАК Справочник.Номенклатура)"));
	#КонецУдаления
	#Вставка
	//++ РС Консалт: Трофимов Евгений 02.04.2023 Тикет 24845
	//e1cib/data/Документ.Задание?ref=8bce2d229394a92d4a0490a0e5eff6de
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"УпаковкиЕдиницыИзмерения",
			"спрНоменклатура"
		)
	);
	//-- КонецТикета 24845	
	#КонецВставки

	Если ПараметрыПроверки.УсловиеОтбораСтрокДляОкругления <> "" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&УсловиеОтбораСтрокДляОкругления",
		СтрЗаменить(ПараметрыПроверки.УсловиеОтбораСтрокДляОкругления, ИмяТЧ + ".", "ТЧ."));
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораСтрокДляОкругления", "ИСТИНА");
	КонецЕсли;

	Если ЗначениеЗаполнено(ПараметрыПроверки.ДополнительныеПоля) Тогда
		Шаблон = "%1 КАК %2,
		|%3";
		ТекстПолей = Шаблон;
		#Вставка
		ТекстДопПолей = Шаблон; 
		#КонецВставки

		Для Каждого Поле Из ПараметрыПроверки.ДополнительныеПоля Цикл
			ТекстПолей = СтрШаблон(ТекстПолей, СтрЗаменить(Поле.Значение, ИмяТЧ + ".", "ТЧ."), Поле.Ключ, Шаблон);
			#Вставка
			ТекстДопПолей = СтрШаблон(ТекстДопПолей, СтрЗаменить(Поле.Значение, ИмяТЧ + ".", "ВТДляЗапроса_Было."), Поле.Ключ, Шаблон);
			#КонецВставки
		КонецЦикла;

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ДополнительныеПоля",
		Сред(ТекстПолей, 1, СтрНайти(ТекстПолей, ",", НаправлениеПоиска.СКонца,, 2) - 1));
		#Вставка
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&РСК_ПоляДоп",
		Сред(ТекстДопПолей, 1, СтрНайти(ТекстДопПолей, ",", НаправлениеПоиска.СКонца,, 2) - 1));
		#КонецВставки
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДополнительныеПоля", "ИСТИНА");
		#Вставка
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РСК_ПоляДоп", "ИСТИНА");	
		#КонецВставки
	КонецЕсли;

	Если ЗначениеЗаполнено(ПараметрыПроверки.УсловиеОтбораСтрокПоДополнительнымПолям) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&УсловиеОтбораСтрокПоДополнительнымПолям",
		СтрЗаменить(ПараметрыПроверки.УсловиеОтбораСтрокПоДополнительнымПолям,
		ИмяТЧ + ".",
		"ВТДляЗапроса."));
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораСтрокПоДополнительнымПолям", "ИСТИНА");	
	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапроса);

	Если ПараметрыПроверки.ПроверяемаяТаблица <> Неопределено Тогда

		Запрос.УстановитьПараметр("ТЧ", ПараметрыПроверки.ПроверяемаяТаблица);

	ИначеЕсли ИмяТЧ = "Объект" Тогда

		Таблица = Новый ТаблицаЗначений;
		Таблица.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5,0,ДопустимыйЗнак.Неотрицательный)));
		Таблица.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		Таблица.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
		Таблица.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3,ДопустимыйЗнак.Неотрицательный)));
		Таблица.Колонки.Добавить("КоличествоУпаковок", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3,ДопустимыйЗнак.Неотрицательный)));

		СтрокаТаблицы = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Объект);

		Запрос.УстановитьПараметр("ТЧ", Таблица);

	Иначе
		Запрос.УстановитьПараметр("ТЧ", Объект[ИмяТЧ].Выгрузить());
	КонецЕсли;

	Запрос.УстановитьПараметр("ДопустимыйПроцентОтклонения", ДопустимыйПроцентОтклонения);
	Запрос.УстановитьПараметр("ПроверитьВозможностьОкругления", ПараметрыПроверки.ПроверитьВозможностьОкругления);

	Для Каждого ПараметрЗапроса Из ПараметрыПроверки.ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ПараметрЗапроса.Ключ, ПараметрЗапроса.Значение);
	КонецЦикла;

	МерныеТипы = Новый Массив;
	МерныеТипы.Добавить(Перечисления.ТипыИзмеряемыхВеличин.Вес);
	МерныеТипы.Добавить(Перечисления.ТипыИзмеряемыхВеличин.Объем);
	МерныеТипы.Добавить(Перечисления.ТипыИзмеряемыхВеличин.Площадь);
	МерныеТипы.Добавить(Перечисления.ТипыИзмеряемыхВеличин.Длина);

	Запрос.УстановитьПараметр("МерныеТипы", МерныеТипы);
	Запрос.УстановитьПараметр("ШтучныйТип", Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук);

	Возврат Запрос;

КонецФункции


