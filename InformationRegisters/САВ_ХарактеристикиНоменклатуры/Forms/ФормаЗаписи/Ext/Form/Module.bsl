﻿                

&НаКлиенте
Процедура ЗначениеПоУмолчаниюНачалоВыбора1(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;	
	
	ЗначениеОтбора = Новый Структура("Владелец",ТекСпр(Запись.СвойствоПараметра));
	ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора, Истина);
	ПараметрыВыбора.Вставить("РежимВыбора",Истина);
	
	ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.Форма.ФормаСписка",ПараметрыВыбора,Элемент);
КонецПроцедуры

&НаСервере
Функция ТекСпр(НаименованиеОбъекта)
	Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(НаименованиеОбъекта.Наименование);
КонецФункции
