#Область ТрофимовЕВ_05_07_2022_ВыдачаТСР
//Добавляет возможность редактировать макеты внешних печатных форм в пользовательском режиме
//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 18246
//e1cib/data/Документ.Задание?ref=8d179e4a99812cbd4be919dded1b36c7

&НаКлиенте
Процедура ВнешняяПечатнаяФормаПриИзменении(Элемент)
	Если НЕ БылиИзменения(Объект.Ссылка) Тогда
		УстановитьНовыйМакет();
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеВопросаОПерезаписиМакета", ЭтаФорма), 
			"Предыдущие изменения в макете будут потеряны. Продолжить?",
			РежимДиалогаВопрос.ДаНет
		);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОПерезаписиМакета(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьНовыйМакет();

КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйМакет()

	оВариантМакета = РеквизитФормыВЗначение("Объект");
	Если ЗначениеЗаполнено(Объект.ВнешняяПечатнаяФорма) Тогда
		ДвоичныеДанные = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВнешняяПечатнаяФорма,"ХранилищеОбработки").Получить();
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		ИмяОбр = ВнешниеОбработки.Подключить(АдресВоВременномХранилище,, Ложь);
		Об	= ВнешниеОбработки.Создать(ИмяОбр);
		Попытка
			оВариантМакета.Макет = Новый ХранилищеЗначения(Об.ПолучитьМакет("Макет"));
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				"Во внешней обработке должен быть макет с именем «Макет». Внесите изменение в обработку и повторите попытку."
			);
			Объект.ВнешняяПечатнаяФорма = Неопределено;
			Возврат;
		КонецПопытки;
	Иначе
		оВариантМакета.Макет = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	оВариантМакета.Записать();
	ЗначениеВРеквизитФормы(оВариантМакета, "Объект");
	Модифицированность = Ложь;

КонецПроцедуры // УстановитьНовыйМакет()

&НаСервереБезКонтекста
Функция БылиИзменения(ВариантМакета)

	Если НЕ ЗначениеЗаполнено(ВариантМакета) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	оВариантМакета = ВариантМакета.ПолучитьОбъект();
	ТабДок = оВариантМакета.Макет.Получить();
	Если ТабДок = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;

КонецФункции // БылиИзменения()

//-- КонецЗадачи 18246
#КонецОбласти
