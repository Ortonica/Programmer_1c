﻿
&Вместо("ОтправитьПолучитьТранспортныеКонтейнеры")
Функция РСК_ОтправитьПолучитьТранспортныеКонтейнеры(Параметры)
	Результат = ПродолжитьВызов(Параметры);
	
	//++ РС Консалт: Трофимов Евгений 21.09.2022 Тикет 20359
	//e1cib/data/Документ.Задание?ref=94e137c71231048947b8209affeeaed4
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Сопоставление объектов ЭДО'");
	ПараметрыВыполнения.ЗапуститьНеВФоне = Ложь;
	
	ДлительныеОперации.ВыполнитьВФоне(
		"Обработка.РСК_СопоставлениеОбъектовЭДО.МодульОбъекта.АвтоСопоставление",
		Новый Структура, 
		ПараметрыВыполнения
	);
	//-- КонецТикета 20359	
	
	Возврат Результат;
КонецФункции
