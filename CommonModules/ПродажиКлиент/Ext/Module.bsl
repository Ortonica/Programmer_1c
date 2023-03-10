
&ИзменениеИКонтроль("СформироватьКомплектДокументовВызов")
Процедура РСК_СформироватьКомплектДокументовВызов(Результат, ДополнительныеПараметры)

	МассивСсылок = Новый Массив();

	Если Не ДополнительныеПараметры.Свойство("МассивСсылок", МассивСсылок) Тогда
		ВызватьИсключение НСтр("ru = 'Не выбрано ни одного документа, который можно было бы оформить.';
		|en = 'No document which could be registered is selected.'");
	КонецЕсли;

	Если Не ДополнительныеПараметры.Свойство("КлючОбъекта") Тогда
		ДополнительныеПараметры.Вставить("КлючОбъекта", "Обработка.ЖурналДокументовПродажи.Форма.КОформлениюНакладных/ТекущиеДанные");
	КонецЕсли;

	ДополнительныеПараметры.Вставить("СоответствиеРаспоряжений", ИнициализироватьРаспоряжения(МассивСсылок));

	ДополнительныеПараметры.Вставить("ПараметрыФормирования", ПараметрыФормированияДокументов(ДополнительныеПараметры));
	#Вставка
	//++ РС Консалт: Минаков А.С. Задача 20226
	Если ДополнительныеПараметры.Свойство("ВключитьВЗадание") Тогда
		ДополнительныеПараметры.ПараметрыФормирования.Вставить("ВключитьВЗадание", ДополнительныеПараметры.ВключитьВЗадание)	
	КонецЕсли;	
	//++ РС Консалт: Минаков А.С. Задача 20226
	#КонецВставки

	Если Не ДополнительныеПараметры.ПараметрыФормирования.СохраненыНастройкиОформления Тогда
		Оповещение = Новый ОписаниеОповещения("СформироватьКомплектДокументовЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФормуНастройкиПараметров(Оповещение, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;

	СформироватьКомплектДокументов(ДополнительныеПараметры.Форма, 
	ДополнительныеПараметры.СоответствиеРаспоряжений, 
	ДополнительныеПараметры.ПараметрыФормирования);

КонецПроцедуры

&ИзменениеИКонтроль("СформироватьКомплектДокументов")
Процедура РСК_СформироватьКомплектДокументов(Форма, СоответствиеРаспоряжений, ПараметрыФормирования)
	
	#Удаление
	ОчиститьСообщения();
	#КонецУдаления

	// Выбор варианта действия и возврат результата в виде имени формы, которую необходимо открыть и ее входящих параметров.
	ПараметрыСозданныхДокументов = ПродажиВызовСервера.ОформитьНакладнуюНаСервере(СоответствиеРаспоряжений, ПараметрыФормирования);

	ПараметрыФормирования.Вставить("СоответствиеРаспоряжений", СоответствиеРаспоряжений);

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПараметрыФормирования", ПараметрыФормирования);
	ДополнительныеПараметры.Вставить("ПараметрыСозданныхДокументов", ПараметрыСозданныхДокументов);
	ДополнительныеПараметры.Вставить("ТаблицаОборудования", Форма.ТаблицаОборудования);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Форма.ОтменитьПакетноеФормирование = Ложь;

	Если ПараметрыСозданныхДокументов.Свойство("ОформитьРядНакладных") И ПараметрыСозданныхДокументов.ОформитьРядНакладных Тогда

		Если ПараметрыФормирования.ФискализацияДоступна И ПараметрыФормирования.ТребуетсяФискализация Тогда
			// в том случае, если требуется фискализация, то будем формировать и фискализировать каждый пакет по отдельности

			ОписаниеОповещения = Новый ОписаниеОповещения("ОформитьПродажуНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);

			СписокДлительныхОпераций = Новый СписокЗначений;

			ПараметрыФормыДлительныхОпераций = Новый Структура;
			ПараметрыФормыДлительныхОпераций.Вставить("СписокДействий", СписокДлительныхОпераций);
			ПараметрыФормыДлительныхОпераций.Вставить("КоличествоДействий", ПараметрыСозданныхДокументов.КоличествоПакетов);
			ПараметрыФормыДлительныхОпераций.Вставить("ТекущийНомерДействия", 1);

			ОткрытьФорму("Обработка.ЖурналДокументовПродажи.Форма.ДлительнаяОперация",ПараметрыФормыДлительныхОпераций,
			Форма,,,,ОписаниеОповещения);

			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;

			ДополнительныеПараметры.Вставить("СписокДлительныхОпераций", СписокДлительныхОпераций);
			ДополнительныеПараметры.Вставить("ПараметрыОжидания", ПараметрыОжидания);
			ДополнительныеПараметры.Вставить("ПараметрыФормыДлительныхОпераций", ПараметрыФормыДлительныхОпераций);

			ДлительнаяОперация = ПродажиВызовСервера.ОформитьРядНакладныхПоТаблицамВызов(ПараметрыСозданныхДокументов, 
			ПараметрыФормирования, ПараметрыФормыДлительныхОпераций.ТекущийНомерДействия);
			СписокДлительныхОпераций.Добавить(ДлительнаяОперация);

			ОписаниеОповещенияСледующийДокумент = Новый ОписаниеОповещения("НачатьОформлениеСледующегоДокумента", ЭтотОбъект, ДополнительныеПараметры);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещенияСледующийДокумент, ПараметрыОжидания);

			Оповестить("ДобавленоНовоеДействие", ПараметрыФормыДлительныхОпераций);

		Иначе
			// если фискализация не нужна, то документы сформируем сразу одним блоком
			ДлительнаяОперация = ПродажиВызовСервера.ОформитьРядНакладныхПоТаблицамВызов(ПараметрыСозданныхДокументов, ПараметрыФормирования);
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
			ОписаниеОповещения = Новый ОписаниеОповещения("ОформитьПродажуНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
		КонецЕсли;
	Иначе // если одно распоряжение
		ОформитьПродажуНаКлиентеЗавершение(Неопределено, ДополнительныеПараметры);
		Если ПараметрыФормирования.ФискализацияДоступна И ПараметрыФормирования.ТребуетсяФискализация И НЕ ПараметрыФормирования.ПоОрдерам Тогда
			ФискализироватьДокументы(Неопределено, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("НачалоВыбораСоглашенияСКлиентомФрагмент")
Процедура РСК_НачалоВыбораСоглашенияСКлиентомФрагмент(СтруктураПараметров)

	Если Не ЗначениеЗаполнено(СтруктураПараметров.Партнер) Тогда
		Возврат;
	Иначе
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаДокумента", СтруктураПараметров.ДатаДокумента);
		ПараметрыФормы.Вставить("Партнер", СтруктураПараметров.Партнер);
		ПараметрыФормы.Вставить("ТолькоТиповые",СтруктураПараметров.ТолькоТиповые);
		ПараметрыФормы.Вставить("ТолькоИспользуемыеВРаботеТП",СтруктураПараметров.ТолькоИспользуемыеВРаботеТП);
		ПараметрыФормы.Вставить("ТекущаяСтрока",СтруктураПараметров.Документ);
		ПараметрыФормы.Вставить("ХозяйственнаяОперация",СтруктураПараметров.ХозяйственнаяОперация);
		ПараметрыФормы.Вставить("ИспользуютсяДоговорыКонтрагентов",СтруктураПараметров.ИспользуютсяДоговорыКонтрагентов);
		ПараметрыФормы.Вставить("КомиссионныеПродажи25",СтруктураПараметров.КомиссионныеПродажи25);
		ПараметрыФормы.Вставить("ТолькоОперацииПередачи",СтруктураПараметров.ТолькоОперацииПередачи);
        #Вставка
		//Конарев отбор соглашений по подразделению
		Если СтруктураПараметров.Свойство("Подразделение") Тогда
			ПараметрыФормы.Вставить("Подразделение",СтруктураПараметров.Подразделение);		
		КонецЕсли;
		#КонецВставки
		
		ДополнительныйОтбор = Новый Структура;

		Для Каждого ПараметрВыбора Из СтруктураПараметров.Элемент.ПараметрыВыбора Цикл
			ДополнительныйОтбор.Вставить(СтрЗаменить(ПараметрВыбора.Имя, "Отбор.", ""), ПараметрВыбора.Значение);
		КонецЦикла;

		ПараметрыФормы.Вставить("Отбор", ДополнительныйОтбор);

		ОткрытьФорму("Справочник.СоглашенияСКлиентами.ФормаВыбора",
		ПараметрыФормы,
		СтруктураПараметров.Элемент);
	КонецЕсли;

КонецПроцедуры
