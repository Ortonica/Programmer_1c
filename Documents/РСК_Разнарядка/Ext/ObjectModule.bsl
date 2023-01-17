﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Неопределено;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Акты.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю("Акты не созданы!",,,,Отказ);
	КонецЕсли;
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеПоРегиструСостоянияЗаказовПоВыдачеТСР(Отказ);
КонецПроцедуры

//++ РС Консалт: Трофимов Евгений 05.07.2022 Задача 17529
//e1cib/data/Документ.Задание?ref=8f35358bc28283324a41cc06ef2294d4
Процедура ПроведениеПоРегиструСостоянияЗаказовПоВыдачеТСР(Отказ)

	//Движения.РСК_СостояниеЗаказовКлиентовПоВыдаче.Очистить();
	//Движения.РСК_СостояниеЗаказовКлиентовПоВыдаче.Записывать = Истина;
	//
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ПоручениеЭкспедитору.РСК_ТСР КАК ТСР,
	//	|	ПоручениеЭкспедитору.РСК_Номенклатура КАК Номенклатура,
	//	|	ПоручениеЭкспедитору.РСК_Характеристика КАК Характеристика,
	//	|	ПоручениеЭкспедитору.РСК_Серия КАК Серия,
	//	|	ПоручениеЭкспедитору.РСК_Количество КАК Количество,
	//	|	ПоручениеЭкспедитору.РСК_Цена КАК Цена
	//	|ИЗ
	//	|	Документ.РСК_Разнарядка.Акты КАК РСК_РазнарядкаАкты
	//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоручениеЭкспедитору КАК ПоручениеЭкспедитору
	//	|		ПО РСК_РазнарядкаАкты.Акт = ПоручениеЭкспедитору.Ссылка
	//	|ГДЕ
	//	|	РСК_РазнарядкаАкты.Ссылка = &Ссылка";
	//
	//Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	Движение = Движения.РСК_СостояниеЗаказовКлиентовПоВыдаче.ДобавитьРасход();
	//	Движение.Период = Дата;
	//	Движение.Заказ = Контракт;
	//	Движение.ТСР = Выборка.ТСР;
	//	Движение.Номенклатура = Выборка.Номенклатура;
	//	Движение.Характеристика = Выборка.Характеристика;
	//	Движение.Серия = Выборка.Серия;
	//	Движение.КСозданию = Выборка.Количество;
	//	Движение.Цена = Выборка.Цена;
	//	
	//	Движение = Движения.РСК_СостояниеЗаказовКлиентовПоВыдаче.ДобавитьПриход();
	//	Движение.Период = Дата;
	//	Движение.Заказ = Контракт;
	//	Движение.ТСР = Выборка.ТСР;
	//	Движение.Номенклатура = Выборка.Номенклатура;
	//	Движение.Характеристика = Выборка.Характеристика;
	//	Движение.Серия = Выборка.Серия;
	//	Движение.КОтгрузке = Выборка.Количество;
	//	Движение.Цена = Выборка.Цена;
	//КонецЦикла;

КонецПроцедуры

#КонецЕсли