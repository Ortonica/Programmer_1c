﻿// Возвращает Иванов И.И. из строки Иванов Иван Иванович 
//
// Параметры:
//  ПолностьюФИО - Строка - Полное фамилия имя отчество
// 
// РС Консалт: Трофимов Евгений 05.07.2022
Функция ФамилияИИницыалы(ПолностьюФИО) Экспорт

	КолонкаФИО = СтрЗаменить(ПолностьюФИО, " ", Символы.ПС);
	ЧислоСтрок = СтрЧислоСтрок(КолонкаФИО);
	Результат = "";
	Если ЧислоСтрок > 0 Тогда
		Результат = СтрПолучитьСтроку(КолонкаФИО, 1);
	КонецЕсли;
	Если ЧислоСтрок > 1 Тогда
		Результат = Результат + " " + Лев(СтрПолучитьСтроку(КолонкаФИО, 2),1) + ".";
	КонецЕсли;
	Если ЧислоСтрок > 2 Тогда
		Результат = Результат + Лев(СтрПолучитьСтроку(КолонкаФИО, 3),1) + ".";
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ФамилияИИницыалы()

// Разность дат. Возвращает структуру с ключами Лет, Месяцев, Дней.
//
// Параметры:
//  Дата1	 - Дата - Дата конца
//  Дата2	 - Дата - Дата начала
// 
// РС Консалт: Трофимов Евгений 05.07.2022
Функция РазобратьРазностьДат(Знач Дата1, Знач Дата2) Экспорт 

	Лет        = 0;
    Месяцев    = 0;
    Дней    = 0;

    Если Дата1 > Дата2 Тогда        
        ВременнаяДата = Дата1;
        Если День(ВременнаяДата) < День(Дата2) Тогда
            Дней = (ВременнаяДата - ДобавитьМесяц(ВременнаяДата,-1))/86400;
            ВременнаяДата = ДобавитьМесяц(ВременнаяДата,-1);
        КонецЕсли;

        Если Месяц(ВременнаяДата) < Месяц(Дата2) Тогда
            ВременнаяДата = ДобавитьМесяц(ВременнаяДата,-12);
            Месяцев = 12;
		КонецЕсли;
		
        Лет        = Макс(             Год(ВременнаяДата)        - Год(Дата2),    0);
        Месяцев    = Макс(Месяцев    + Месяц(ВременнаяДата)    - Месяц(Дата2),    0);
        Дней    = Макс(Дней        + День(ВременнаяДата)    - День(Дата2),    0);

        // скорректируем отображаемое значение, если "вмешалось" разное количество дней в месяцах
        Если Дата2 <> (ДобавитьМесяц(Дата1,-Лет*12-Месяцев)-Дней*86400) Тогда
            Дней = Дней + (День(КонецМесяца(Дата2)) - День(НачалоМесяца(Дата2))) - (День(КонецМесяца(ДобавитьМесяц(Дата1,-1))) - День(НачалоМесяца(ДобавитьМесяц(Дата1,-1))));
        КонецЕсли;
    КонецЕсли;
	
   СтруктураДаты = Новый Структура;
   СтруктураДаты.Вставить("Лет",Лет);
   СтруктураДаты.Вставить("Месяцев",Месяцев);
   СтруктураДаты.Вставить("Дней",Дней);
   
   Возврат СтруктураДаты
КонецФункции  

// Возвращает Истина, если свойство XDTO объекта существует.
// РС Консалт: Трофимов Евгений 25.07.2022
//
// Параметры:
//  ОбъектXDTO	 - ОбъектXDTO - XDTO объект 
//  ИмяСвойства	 - Строка - Имя свойства
// 
Функция СвойствоXDTO_Установлено(ОбъектXDTO, ИмяСвойства) Экспорт

	Если ОбъектXDTO.Свойства().Получить(ИмяСвойства) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбъектXDTO.Установлено(ИмяСвойства);

КонецФункции // СвойствоXDTO_Установлено()

// Возвращает число из строки наименования технической характеристики.
// Предназначена для преобразования строковых значений в числовые из значений 
// регистра сведений «САВ_ХарактеристикиНоменклатуры»
//++ РС Консалт: Трофимов Евгений 18.08.2022 Задача 19406
//e1cib/data/Документ.Задание?ref=8801aed8a4c061714c61a3f05ae02271
//
// Параметры:
//  СтрокаДанных - Строка - Строка формата "1. 14.85"
// 
Функция ПолучитьЧислоИзСтрокиХарактеристики(Знач СтрокаДанных = "") Экспорт

	Если ПустаяСтрока(СтрокаДанных) Тогда
		Возврат 0;
	КонецЕсли;
	
	СтрокаДанных = СтрЗаменить(СокрЛП(СтрокаДанных),",", ".");
	ДлинаСтроки = СтрДлина(СтрокаДанных);
	ЧисловаяСтрока = "";
	РазрешённыеСимволы = "1234567890.";
	РазделительДробнойЧастиУжеБыл = Ложь;
	Для Позиция = 1 По ДлинаСтроки Цикл
		Сим = Сред(СтрокаДанных, ДлинаСтроки - Позиция + 1, 1);
		Если СтрНайти(РазрешённыеСимволы, Сим) > 0 Тогда
			Если Сим = "." Тогда
				Если РазделительДробнойЧастиУжеБыл Тогда
					Прервать;
				Иначе
					РазделительДробнойЧастиУжеБыл = Истина;
				КонецЕсли;
			КонецЕсли;
			ЧисловаяСтрока = Сим + ЧисловаяСтрока;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(ЧисловаяСтрока) Тогда
		Возврат 0;
	КонецЕсли;
	Возврат Число(ЧисловаяСтрока);
	
КонецФункции // ПолучитьЧислоИзСтрокиХарактеристики()

// Получает соответствие вариантов отсчета даты платежа на английсом языке
//++ РС Консалт: Трофимов Евгений 24.08.2022 Задача 19406
//e1cib/data/Документ.Задание?ref=8801aed8a4c061714c61a3f05ae02271
// 
// Возвращаемое значение:
//   - Соответствие
//
Функция ПолучитьСоответствиеВариантыОтсчетаДатыПлатежаENG() Экспорт

	ВариантыОтсчетаДатыПлатежаENG = Новый Соответствие;
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ОтДатыЗаказа"), "from the date of the order");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ОтДатыСогласования"), "from the date of approval");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ДоДатыОтгрузки"), "to the date of shipment");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ОтДатыОтгрузки"), "from the date of shipment");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ОтДатыПереходаПраваСобственности"), "from the date of transfer of ownership");
	
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ДоДатыРазмещения"), "to the date of placement in production");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ДоДатыОкончанияПроизводства"), "to the date of order readiness");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ОтДатыОкончанияПроизводства"), "from the date of order readiness");
	ВариантыОтсчетаДатыПлатежаENG.Вставить(ПредопределенноеЗначение("Перечисление.ВариантыОтсчетаДатыПлатежа.ДоДатыПрибытияВПорт"), "to the date of telex release");
	Возврат ВариантыОтсчетаДатыПлатежаENG;

КонецФункции // ПолучитьСоответствиеВариантыОтсчетаДатыПлатежаENG()

// Сумма прописью для китайской валюты
//++ РС Консалт: Трофимов Евгений 28.10.2022 Тикет 21361
//e1cib/data/Документ.Задание?ref=b2990c1b998376d64376d5ea03098753
//
// Параметры:
//  Сумма	 - Число - Сумма
//  Язык	 - Строка - Принимает заначения "RUS" или "ENG"
// 
// Возвращаемое значение:
//   - Строка 
//
Функция СуммаКитайскойВалютыПрописью(Сумма, Язык = "RUS") Экспорт

	КоличествоЮаней=Цел(Сумма);
	КоличествоЦзяо=Цел((Сумма-КоличествоЮаней)*10);
	КоличествоФеней=Цел((Сумма-КоличествоЮаней-КоличествоЦзяо/10)*100);
	Если Язык = "ENG" Тогда
		СтрокаЮаней = ЧислоПрописью(КоличествоЮаней, "Л=en_US; ДП=Ложь", "yuan,yuan,,,1");
		СтрокаЦзяо  = ЧислоПрописью(КоличествоЦзяо, "Л=en_US; ДП=Ложь", "jiao,jiao,,,1");
		СтрокаФеней = ЧислоПрописью(КоличествоФеней, "Л=en_US; ДП=Ложь", "fen,fen,,,1");
	ИначеЕсли Язык = "RUS" Тогда
		СтрокаЮаней = ЧислоПрописью(КоличествоЮаней, "Л=ru_RU; ДП=Ложь", "юань,юаня,юаней,м,1");     //  "рубль, рубля, рублей, м
		СтрокаЦзяо  = ЧислоПрописью(КоличествоЦзяо, "Л=ru_RU; ДП=Ложь", "дзяо,дзяо,дзяо,м,1");
		СтрокаФеней = ЧислоПрописью(КоличествоФеней, "Л=ru_RU; ДП=Ложь", "фэнь,фэнь,фэнь,м,1");
	КонецЕсли;
	СуммаСтрокой=Лев(СтрокаЮаней,СтрНайти(СтрокаЮаней,"0")-1)+""+Лев(СтрокаЦзяо,СтрНайти(СтрокаЦзяо,"0")-1)+""+Лев(СтрокаФеней,СтрНайти(СтрокаФеней,"0")-1);
	Результат = "";
	Если КоличествоЦзяо = 0 И КоличествоФеней = 0 Тогда 
		Результат = Результат + Лев(СтрокаЮаней,СтрНайти(СтрокаЮаней,"0")-1) + ?(Язык = "ENG","ONLY","ровно");
	Иначе
		Результат = Результат + СуммаСтрокой;
	КонецЕсли;
	
	Возврат вРег(Результат);

КонецФункции // СуммаКитайскойВалюты()

#Область РегулярныеВыражения

// Получить массив телефонов
//++ РС Консалт: Трофимов Евгений 05.11.2022 Задача 21666
//e1cib/data/Документ.Задание?ref=9c32d5284cfd59a04da1fbac6171ed0a
//
// Параметры:
//  СтрокаСТелефонами	 - Строка - Строка телефонов через запятую
// 
// Возвращаемое значение:
//   - Массив
//
Функция ПолучитьМассивТелефонов(СтрокаСТелефонами) Экспорт

	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = Истина; //Игнорировать регистр 
	RegExp.Global = Истина; //Поиск всех вхождений шаблона 
	RegExp.MultiLine = Истина; //Многострочный режим 
	RegExp.Pattern = "[^0-9]"; // отбор только чисел
	
	МассивСтрок = СтрРазделить(СтрокаСТелефонами, ",", Ложь);
	МассивТелефонов = Новый Массив;
	
	Для Каждого НомерТелефона Из МассивСтрок Цикл
		НомерТелефона = RegExp.Replace(НомерТелефона, "");
		Если ПустаяСтрока(НомерТелефона) Тогда
			Продолжить;
		КонецЕсли;
		Если СтрДлина(НомерТелефона) > 11 Тогда
			НомерТелефона = Прав(НомерТелефона, 11);
		КонецЕсли;
		Если СтрДлина(НомерТелефона) = 11 И Лев(НомерТелефона, 1) = "8" Тогда
			НомерТелефона = "7"+Сред(НомерТелефона,2);
		КонецЕсли;
		Если СтрДлина(НомерТелефона) = 10 Тогда
			НомерТелефона = "7"+НомерТелефона;
		КонецЕсли;
		Если МассивТелефонов.Найти(НомерТелефона) = Неопределено Тогда
			МассивТелефонов.Добавить(НомерТелефона);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивТелефонов;

КонецФункции // ПолучитьМассивТелефонов()

// Получить только цифры
//
// Параметры:
//  СтрокаССимволами - Строка - Любая строка с набором символов
// 
// Возвращаемое значение:
//   - Строка - Строка, чодержащая только цифры
//
Функция ПолучитьТолькоЦифры(СтрокаССимволами) Экспорт

	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = Истина; //Игнорировать регистр 
	RegExp.Global = Истина; //Поиск всех вхождений шаблона 
	RegExp.MultiLine = Истина; //Многострочный режим 
	RegExp.Pattern = "[^0-9]"; // отбор только чисел
	Возврат RegExp.Replace(СтрокаССимволами, "");	

КонецФункции // ПолучитьТолькоЦифры()

// Заменить по регулярному выражению
//
// Параметры:
//  ГдеИщем				 - Строка - Исходная строка в кторой осуществляется поиск
//  РегулярноеВыражение	 - Строка - Регулярное выражение
//  НаЧтоЗаменяем		 - Строка - На что заменяются остальные символы
//  МногострочныйРежим	 - Булево - Ложь - однострочный объект, Истина - многострочный. По умолчанию - Истина.
//  ПоискВсехВхождений	 - Булево - Ложь - проверять до первого соответствия, Истина - проверять по всему тексту. По умолчанию - Истина.
//  ИгнорироватьРегистр	 - Булево - Ложь - учитывать регистр символов, Истина - игнорировать регистр символов. По умолчанию - Истина.
// 
// Возвращаемое значение:
//   - Строка - результат замены
//
Функция Заменить(ГдеИщем, РегулярноеВыражение = "[^0-9]", НаЧтоЗаменяем = "", 
	МногострочныйРежим = Истина, ПоискВсехВхождений = Истина, ИгнорироватьРегистр = Истина) Экспорт
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = ИгнорироватьРегистр; 
	RegExp.Global = ПоискВсехВхождений;
	RegExp.MultiLine = МногострочныйРежим;
	RegExp.Pattern = ПаттернСУчетомКирилицы(РегулярноеВыражение);
	Возврат RegExp.Replace(ГдеИщем, НаЧтоЗаменяем);	

КонецФункции // ПолучитьТолькоЦифры()

// Получает массив вхождений, отобранных по регулярному выражению
//
// Параметры:
//  ГдеИщем				 - Строка - Исходная строка в кторой осуществляется поиск
//  РегулярноеВыражение	 - Строка - Регулярное выражение
//  МногострочныйРежим	 - Булево - Ложь - однострочный объект, Истина - многострочный. По умолчанию - Истина.
//  ПоискВсехВхождений	 - Булево - Ложь - проверять до первого соответствия, Истина - проверять по всему тексту. По умолчанию - Истина.
//  ИгнорироватьРегистр	 - Булево - Ложь - учитывать регистр символов, Истина - игнорировать регистр символов. По умолчанию - Истина.
// 
// Возвращаемое значение:
//   - Массив - Перечень строк с совпадениями 
//
Функция Совпадение(ГдеИщем, РегулярноеВыражение, 
	МногострочныйРежим = Истина, ПоискВсехВхождений = Истина, ИгнорироватьРегистр = Истина) Экспорт

	Результат = Новый Массив;
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = ИгнорироватьРегистр; 
	RegExp.Global = ПоискВсехВхождений;
	RegExp.MultiLine = МногострочныйРежим;
	RegExp.Pattern = ПаттернСУчетомКирилицы(РегулярноеВыражение);
	МассивОбъектов = RegExp.Execute(ГдеИщем);
	Для ё = 0 По МассивОбъектов.Count - 1 Цикл
		Результат.Добавить(МассивОбъектов.item(ё).Value);
	КонецЦикла;
	Возврат Результат;

КонецФункции // НайтиСовпадения()

// Проверка соответствия шаблону
//
// Параметры:
//  ПроверяемаяСтрока	 - Строка - Строка, которую нужно проверить
//  РегулярноеВыражение	 - Строка - Регулярное выражение
//  МногострочныйРежим	 - Булево - Ложь - однострочный объект, Истина - многострочный. По умолчанию - Истина.
//  ПоискВсехВхождений	 - Булево - Ложь - проверять до первого соответствия, Истина - проверять по всему тексту. По умолчанию - Истина.
//  ИгнорироватьРегистр	 - Булево - Ложь - учитывать регистр символов, Истина - игнорировать регистр символов. По умолчанию - Истина.
// 
// Возвращаемое значение:
//   - Булево - 
//
Функция УдовлетворяетШаблону(ПроверяемаяСтрока, РегулярноеВыражение, 
	МногострочныйРежим = Истина, ПоискВсехВхождений = Истина, ИгнорироватьРегистр = Истина) Экспорт

	Результат = Новый Массив;
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = ИгнорироватьРегистр; 
	RegExp.Global = ПоискВсехВхождений;
	RegExp.MultiLine = МногострочныйРежим;
	RegExp.Pattern = ПаттернСУчетомКирилицы(РегулярноеВыражение);
	Возврат RegExp.Test(ПроверяемаяСтрока);

КонецФункции // НайтиСовпадения()

// Преобразует символы кирилицы в Unicode 
//
// Параметры:
//  РегулярноеВыражение	 - Строка - Регулярное выражение
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПаттернСУчетомКирилицы(РегулярноеВыражение)

	Паттерн = "";
	Для ПозицияСимвола = 1 По СтрДлина(РегулярноеВыражение) Цикл
		Код = КодСимвола(РегулярноеВыражение, ПозицияСимвола);
		ОдинСимвол = Сред(РегулярноеВыражение, ПозицияСимвола, 1);
		Если (Код >= 1040 И Код <= 1103) ИЛИ ОдинСимвол = "ё" ИЛИ ОдинСимвол = "Ё" Тогда
			Паттерн = Паттерн + "\u" + to16(Код);
		Иначе
			Паттерн = Паттерн + ОдинСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Паттерн;

КонецФункции // ПаттернСУчетомUnicode()

// Преобразование числа в шестнадцатиричное значение
//
// Параметры:
//  чсл	 - Число - Любое положительное число
// 
// Возвращаемое значение:
//   - Строка - 
//
Функция to16(чсл) Экспорт
    
Если 0 = чсл Тогда 
       Возврат "0000"; 
КонецЕсли; 

результат = ""; 

    Пока 0 < чсл Цикл 
       остаток = чсл % 16; 
       Если 10 <= остаток Тогда 
         результат = Символ(КодСимвола("A") + остаток - 10) + результат; 
       Иначе                                       
         результат = строка(остаток) + результат; 
       КонецЕсли; 
       чсл = цел(чсл / 16);     
    КонецЦикла;

    Пока СтрДлина(результат) < 4 Цикл
        Результат = "0"+Результат;
    КонецЦикла;

Возврат результат; 
    
КонецФункции

// Создаёт имя переменной из произвольной строки.
// Исходная строка: 123. Проформа инвойс (улучшенная) №2
// Результат: _Проформа_инвойс_улучшенная_2_123
// Можно использовать при формировании идентификаторов печатных форм или имени файла
//
// Параметры:
//  ПроизвольнаяСтрока	 - Строка - 
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПреобразоватьВИмяПеременной(ПроизвольнаяСтрока) Экспорт
	
    НоваяСтрока = СтрЗаменить(ПроизвольнаяСтрока," ","_");
	ДопустимыеСимволы = Совпадение(НоваяСтрока, "[a-zA-ZА-яЁё_0-9]");
	НоваяСтрока = "";
	Для Каждого ДопустимыйСимвол Из ДопустимыеСимволы Цикл
		НоваяСтрока = НоваяСтрока + ДопустимыйСимвол;
	КонецЦикла;
	
	//Если вначале есть цифры, то перенесём их в конец
	Если СтрНайти("0123456789", Лев(НоваяСтрока, 1)) Тогда
		МассивСовпадений = Совпадение(НоваяСтрока, "^\d+");
		НоваяСтрока = Прав(НоваяСтрока, СтрДлина(НоваяСтрока)-СтрДлина(МассивСовпадений[0])) + "_" + МассивСовпадений[0];
	КонецЕсли;
	Возврат НоваяСтрока;

КонецФункции // ПреобразоватьВИмяПеременной()

#КонецОбласти

// Преобразует строку типа 01.02.2003 в дату
//
// Параметры:
//  ДатаСтр	 - Строка - Формат  01.02.2003 или 01.02.99
// 
// Возвращаемое значение:
//   - Дата
//
Функция СтрокуВДату(ДатаСтр) Экспорт
	Если СтрДлина(ДатаСтр) = СтрДлина("01.01.19") Тогда
		Возврат Дата("20"+Сред(ДатаСтр,7,2),Сред(ДатаСтр,4,2),Сред(ДатаСтр,1,2));
	Иначе
		Возврат Дата(Сред(ДатаСтр,7,4),Сред(ДатаСтр,4,2),Сред(ДатаСтр,1,2));
	КонецЕсли;
КонецФункции

// Возвращает текст, который находится между стрНачало и стрКонец
//
// Параметры:
//  ИсходнаяСтрока	 - Строка - Строка, в которой выполняется поиск
//  стрНачало		 - Строка - Набор символов, обозначающих начало искомого текста
//  стрКонец		 - Строка - Набор символов, обозначающих конец искомого текста
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьМеждуТекст(Знач ИсходнаяСтрока, стрНачало="", стрКонец="") Экспорт
	ПозН=0;
	ПозК=0;
	
	Если стрНачало<>"" Тогда
		ПозН = Найти(ИсходнаяСтрока, стрНачало);
	КонецЕсли;
	Если ПозН>0 Тогда
		ИсходнаяСтрока = Прав(ИсходнаяСтрока,СтрДлина(ИсходнаяСтрока)-(ПозН+СтрДлина(стрНачало)-1));
	КонецЕсли;
	Если стрКонец <> "" Тогда
		ПозК = Найти(ИсходнаяСтрока, стрКонец);
	КонецЕсли;
	Если ПозК>0 Тогда
		ИсходнаяСтрока = Лев(ИсходнаяСтрока, ПозК-1);
	КонецЕсли;
	Возврат ИсходнаяСтрока;
КонецФункции // ПолучитьМеждуТекст()

