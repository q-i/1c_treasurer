﻿
&НаКлиенте
Асинх Процедура ЗаполнитьВсемиУчастниками(Команда)

	Если Объект.Участники.Количество() > 0 Тогда
		Ответ = Ждать ВопросАсинх("Перезаполнить табличную часть?", РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Отмена);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьВсемиУчастникамиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсемиУчастникамиНаСервере()

	Объект.Участники.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Участники.Ссылка КАК Участник
	|ИЗ
	|	Справочник.Участники КАК Участники
	|ГДЕ
	|	НЕ Участники.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Участники.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Участники.Добавить();
		НоваяСтрока.Участник = Выборка.Участник;
	КонецЦикла;
	
	ПересчитатьСтоимостьУчастияИтогоНаСервере();
	
КонецПроцедуры


&НаКлиенте
Асинх Процедура ЗаполнитьУчастникамиИзТекста(Команда)
	
	Стр = "";
	Стр = Ждать ВвестиСтрокуАсинх(Стр, "Введите перечень участников",, Истина);
	Если НЕ ЗначениеЗаполнено(Стр) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьУчастникамиИзТекстаНаСервере(Стр);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУчастникамиИзТекстаНаСервере(ПереченьУчастников)
	
	Объект.Участники.Очистить();
	Для Каждого ТекСтр Из СтрРазделить(ПереченьУчастников, Символы.ПС) Цикл
		ИмяУчастника = СокрЛП(ТекСтр);
		Если ПустаяСтрока(ИмяУчастника) Тогда
			Продолжить;
		КонецЕсли;
		НайденныйУчастник = Справочники.Участники.НайтиПоНаименованию(ИмяУчастника, Истина);
		Если ЗначениеЗаполнено(НайденныйУчастник) Тогда
			НоваяСтрока = Объект.Участники.Добавить();
			НоваяСтрока.Участник = НайденныйУчастник;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Не найден участник с именем '%1'", ИмяУчастника));
		КонецЕсли;
	КонецЦикла;
	
	ПересчитатьСтоимостьУчастияИтогоНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСтоимостьУчастияИтогоНаСервере()
	
	СтоимостьУчастияИтого = Объект.Мероприятие.СтоимостьУчастия * Объект.Участники.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПересчитатьСтоимостьУчастияИтогоНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МероприятиеПриИзменении(Элемент)
	
	ПересчитатьСтоимостьУчастияИтогоНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриИзменении(Элемент)
	
	ПересчитатьСтоимостьУчастияИтогоНаСервере();
	
КонецПроцедуры
