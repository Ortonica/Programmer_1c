﻿
&ИзменениеИКонтроль("УПД2019_ИнформацияПродавца_АвтозаполнениеАдресов")
Процедура РСК_УПД2019_ИнформацияПродавца_АвтозаполнениеАдресов(Данные)

	ДатаСведений = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаВДереве(Данные, "ДатаДокумента", Ложь);

	Участники = Новый Структура;
	Участники.Вставить("СведенияОПродавце");
	Участники.Вставить("СведенияОПокупателе");
	Участники.Вставить("СведенияОГрузоотправителе", "Грузоотправитель");
	Участники.Вставить("СведенияОГрузополучателе");
	Участники.Вставить("СведенияОКомиссионере");
	Участники.Вставить("СведенияОКомитенте");
	Участники.Вставить("СведенияОПеревозчике");

	Для каждого КлючЗначение Из Участники Цикл

		Путь = КлючЗначение.Ключ;
		Колонка = КлючЗначение.Значение;

		СтрокаДерева = Данные.Строки.Найти(Путь, "ПолныйПуть");

		Если СтрокаДерева.Признак = "Таблица" Тогда

			Для каждого СтрокаТаблицы Из СтрокаДерева.Строки Цикл

				УчастникМассивом = Новый Массив;
				УчастникМассивом.Добавить(Путь + ".НомерСтроки" + ?(ЗначениеЗаполнено(Колонка), "." + Колонка, ""));
				#Вставка     
				//++РС Консалт Назаров М.Ю. 5 октября 2022 г. 23:13:55        
				НайтиИДобавитьРеализациюВДерево(Данные, Путь, СтрокаТаблицы);
				//--РС Консалт Назаров М.Ю. 5 октября 2022 г. 23:13:55
				#КонецВставки
				ЗаполнитьАдресаУчастниковСделкиУПД2019(УчастникМассивом, СтрокаТаблицы, ДатаСведений);

			КонецЦикла;

		ИначеЕсли СтрокаДерева.Признак = "Группа" Тогда

			УчастникМассивом = Новый Массив;
			УчастникМассивом.Добавить(Путь);
			ЗаполнитьАдресаУчастниковСделкиУПД2019(УчастникМассивом, Данные, ДатаСведений);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры
  
&ИзменениеИКонтроль("ЗаполнитьАдресаУчастниковСделкиУПД2019")
Процедура РСК_ЗаполнитьАдресаУчастниковСделкиУПД2019(Участники, ДеревоДанных, ДатаАдреса)

	ПутьККорнюАдреса = ".Адрес";
	ПутьКСтруктурированномуАдресу = ".Адрес.АдресРФ";
	ПутьКПроизвольномуАдресу      = ".Адрес.АдресИнформация";
	ПутьКИностранномуАдресу       = ".Адрес.АдресИнформация";
	ПолеКодРегиона = ".КодРегиона";
	ПолеНаселПункт = ".НаселенныйПункт";
	ПолеКвартира   = ".Квартира";

	Для Каждого Участник Из Участники Цикл

		ОбъектКонтактнойИнформации = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаВДереве(
		ДеревоДанных, Участник + ".Адрес.АвтоматическиЗаполняемый.ОбъектКонтактнойИнформации");

		ВидКонтактнойИнформации    = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаВДереве(
		ДеревоДанных, Участник + ".Адрес.АвтоматическиЗаполняемый.ВидКонтактнойИнформации");

		Если Не ЗначениеЗаполнено(ОбъектКонтактнойИнформации) Тогда
			Продолжить;
		КонецЕсли;

		ПараметрыОбработкиОшибок = ЭлектронноеВзаимодействиеКлиентСервер.НовыеПараметрыОбработкиОшибки();

		// Корневой элемент группы "АвтоматическиЗаполняемый" может содержать в себе
		// параметры обработки ошибки, которые могут быть добавлены в переопределяемой части.
		СтрокаДерева = ЭлектронноеВзаимодействие.СтрокаДерева(
		ДеревоДанных, Участник + ".Адрес.АвтоматическиЗаполняемый", Истина);
		ЗаполнитьЗначенияСвойств(ПараметрыОбработкиОшибок, СтрокаДерева);

		Если ТипЗнч(ВидКонтактнойИнформации) <> Тип("Массив") Тогда
			ВидыКонтактнойИнформации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидКонтактнойИнформации);
		Иначе
			ВидыКонтактнойИнформации = ВидКонтактнойИнформации;
		КонецЕсли;

		Для Каждого ПроверяемыйВид Из ВидыКонтактнойИнформации Цикл 
			КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ОбъектКонтактнойИнформации, ПроверяемыйВид, ДатаАдреса, Ложь);

			Если КонтактнаяИнформация.Количество() Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;	
		#Вставка
		//++РС Консалт Назаров М.Ю. 21 октября 2022 г. 7:42:22                  
		Если Не ЗначениеЗаполнено(КонтактнаяИнформация) Тогда
			ДобавитьВТаблицуАдресРеализации(ДеревоДанных, КонтактнаяИнформация);
		КонецЕсли;
		//--РС Консалт Назаров М.Ю. 21 октября 2022 г. 7:42:22
		#КонецВставки

		Если ЗначениеЗаполнено(КонтактнаяИнформация) Тогда

			АдресЗначение = КонтактнаяИнформация[0].Значение;
			#Вставка   
			//++РС Консалт Назаров М.Ю. 5 октября 2022 г. 23:50:06 
			АдресЗначение = ПереопределитьАдресНаАдресРеализации(ДеревоДанных, АдресЗначение);
			//--РС Консалт Назаров М.Ю. 5 октября 2022 г. 23:50:06
			#КонецВставки
			Адрес = РаботаСАдресами.СведенияОбАдресе(АдресЗначение, Новый Структура("КодыАдреса", Ложь));

			Если Адрес.КодСтраны = "643" Тогда // Россия

				АдресСоответствуетСтруктурированномуФорматуФНС = АдресСоответствуетСтруктурированномуФорматуФНС(Адрес);

				Если АдресСоответствуетСтруктурированномуФорматуФНС Тогда

					// Заполняем структурированный адрес.

					ПутьКАдресу = Участник + ПутьКСтруктурированномуАдресу;

					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Индекс", Адрес.Индекс, ПараметрыОбработкиОшибок);

					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ПолеКодРегиона, Адрес.КодРегиона,
					ПараметрыОшибкиЗаполненияКодаРегиона(ПараметрыОбработкиОшибок, ОбъектКонтактнойИнформации));

					ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(Адрес.Район, Адрес.РайонСокращение);
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Район", ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(Адрес.Город, Адрес.ГородСокращение);
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Город", ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(
					Адрес.НаселенныйПункт, Адрес.НаселенныйПунктСокращение);
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ПолеНаселПункт, ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(Адрес.Улица, Адрес.УлицаСокращение);
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Улица", ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(
					НРег(Адрес.Здание.ТипЗдания), "№", Адрес.Здание.Номер);
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Дом", ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					Если Адрес.Корпуса.Количество() Тогда
						ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Корпуса[0].ТипКорпуса), Адрес.Корпуса[0].Номер);
					Иначе
						ПредставлениеЭлемента = "";
					КонецЕсли;
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".Корпус", ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

					Если Адрес.Помещения.Количество() Тогда
						ПредставлениеЭлемента = ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Помещения[0].ТипПомещения), Адрес.Помещения[0].Номер);
					Иначе
						ПредставлениеЭлемента = "";
					КонецЕсли;
					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ПолеКвартира, ПредставлениеЭлемента, ПараметрыОбработкиОшибок);

				Иначе

					// Заполняем адрес в произвольной форме.

					ПутьКАдресу = Участник + ПутьКПроизвольномуАдресу;

					ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
					ДеревоДанных, ПутьКАдресу + ".КодСтраны", Адрес.КодСтраны, ПараметрыОбработкиОшибок);

					Если Адрес.ТипАдреса = "Муниципальный" Тогда

						ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
						ДеревоДанных, ПутьКАдресу + ".АдресТекст", Адрес.МуниципальноеПредставление,
						ПараметрыОбработкиОшибок);
					Иначе
						ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
						ДеревоДанных, ПутьКАдресу + ".АдресТекст", Адрес.Представление,
						ПараметрыОбработкиОшибок);

					КонецЕсли;

				КонецЕсли;

			Иначе

				ПутьКАдресу = Участник + ПутьКИностранномуАдресу;

				ПолеКодСтраны  = ".КодСтраны";
				ПолеАдресТекст = ".АдресТекст";

				Если ЭлектронноеВзаимодействие.СуществуетРеквизитВДереве(ДеревоДанных, ПутьКАдресу + ".КодСтр") Тогда
					ПолеКодСтраны  = ".КодСтр";
					ПолеАдресТекст = ".АдрТекст";
				КонецЕсли;

				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
				ДеревоДанных, ПутьКАдресу + ПолеКодСтраны, Адрес.КодСтраны, ПараметрыОбработкиОшибок);

				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(
				ДеревоДанных, ПутьКАдресу + ПолеАдресТекст, Адрес.Представление, ПараметрыОбработкиОшибок);

			КонецЕсли;

		Иначе

			// Не заполнена контактная информация.
			// Очищаем значение адреса, чтобы проверка заполненности не считала реквизит заполненным.

			ПутьКАдресу = Участник + ПутьККорнюАдреса;
			ДеревоЭлектронногоДокументаБЭД.ОчиститьЗначениеВСтрокеДерева(ДеревоДанных, ПутьКАдресу, ПараметрыОбработкиОшибок);			

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

// Меняем адрес контрагента на адрес из реализации
Функция ПереопределитьАдресНаАдресРеализации(Знач ДеревоДанных, АдресЗначение)
	
	Попытка
		Реализация = ЭлектронноеВзаимодействие.СтрокаДерева(ДеревоДанных, "Реализация", Истина).Значение;  
		Если ЗначениеЗаполнено(Реализация.АдресДоставкиЗначение) Тогда 
			Возврат Реализация.АдресДоставкиЗначение;               
		КонецЕсли;
	Исключение 
		ЗаписьЖурналаРегистрации("ЕИС_ПереопределениеАдреса", УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;  
	
	Возврат АдресЗначение;

КонецФункции

// При незаполненной КонтактнойИнформации, добавляем адрес реализации
Процедура ДобавитьВТаблицуАдресРеализации(Знач ДеревоДанных, КонтактнаяИнформация)
	
	Попытка
		Реализация = ЭлектронноеВзаимодействие.СтрокаДерева(ДеревоДанных, "Реализация", Истина).Значение;
		Если ЗначениеЗаполнено(Реализация.АдресДоставкиЗначение) Тогда 
			АдресЗначение = Реализация.АдресДоставкиЗначение;               
			НоваяСТрока = КонтактнаяИнформация.Добавить();
			НоваяСТрока.Значение = АдресЗначение;
		КонецЕсли;
	Исключение 
		ЗаписьЖурналаРегистрации("ЕИС_ПереопределениеАдреса", УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Необходимо чтобы в будущем из реализации взять адрес доставки
Процедура НайтиИДобавитьРеализациюВДерево(Данные, Знач Путь, СтрокаТаблицы)
	
	Попытка                               
		
		ПутиВКоторыхНеобходимоЗаменитьАдрес = Новый Массив;
		ПутиВКоторыхНеобходимоЗаменитьАдрес.Добавить("СведенияОГрузополучателе");
		ПутиВКоторыхНеобходимоЗаменитьАдрес.Добавить("СведенияОПокупателе");
		
		Если ПутиВКоторыхНеобходимоЗаменитьАдрес.Найти(Путь) <> Неопределено Тогда 
			СчетФактура = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаВДереве(Данные, "СсылкаСчетаФактуры");
			Реализация = СчетФактура.ДокументОснование; 
			
			НоваяСтрока = СтрокаТаблицы.Строки.Добавить();
			НоваяСтрока.Значение = Реализация; 
			НоваяСтрока.ПолныйПуть = "Реализация";
			
		КонецЕсли;                
	Исключение  
		ЗаписьЖурналаРегистрации("ЕИС_ПереопределениеАдреса", УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры
