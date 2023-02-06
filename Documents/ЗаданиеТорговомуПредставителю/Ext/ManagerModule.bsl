﻿
&ИзменениеИКонтроль("ДобавитьКомандыСозданияНаОсновании")
Процедура РСК_ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры)

	Документы.ЗаказКлиента.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	#Вставка 
	РСК_Сервер.ДобавитьКомандуСоздатьНаОснованииПриобретениеУслугПрочихАктивов(КомандыСозданияНаОсновании);
	#КонецВставки
	
КонецПроцедуры 

//Формирует таблицу движений для документа ЗаданиеТорговомуПредставителю
//
Функция СформироватьТаблицуДвиженийЗаданияТорговомуПредставителю(Документ) Экспорт
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Ссылка",Документ);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗаданиеТорговомуПредставителюСАВ_Услуги.Номенклатура) КАК Содержание,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество КАК Количество,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка.Дата КАК Период,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка.Сделка КАК Сделка,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.НомерСтроки КАК КодСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Цена КАК Цена,
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Сумма КАК Сумма
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю.САВ_Услуги КАК ЗаданиеТорговомуПредставителюСАВ_Услуги
	|ГДЕ
	|	ЗаданиеТорговомуПредставителюСАВ_Услуги.Ссылка = &Ссылка
	|	И ЗаданиеТорговомуПредставителюСАВ_Услуги.Количество <> 0";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции 