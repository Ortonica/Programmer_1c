﻿
&НаКлиенте
Процедура РСК_ПриОткрытииПосле(Отказ)
	//++ РС Консалт: Трофимов Евгений 22.12.2022
	//Просто надоело это окно                  
	Если РСК_Клиент.ЭтоКопия() Тогда
		БольшеНеПоказывать(Неопределено);
	КонецЕсли;
	//-- КонецЗадачи 22653	
КонецПроцедуры
