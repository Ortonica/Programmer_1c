﻿

&После("ОбработкаЗаполнения")
Процедура РСК_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	попытка
		Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
			ЭтотОбъект.Менеджер = ДанныеЗаполнения.ДокументОснование.ЗаказКлиента.Менеджер;
			ЭтотОбъект.Подразделение=ДанныеЗаполнения.ДокументОснование.ЗаказКлиента.Менеджер.Подразделение;
КонецЕсли;// Вставить содержимое метода.  
Исключение
КонецПопытки;

КонецПроцедуры

