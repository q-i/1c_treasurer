﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УчастиеВМероприятии") Тогда
		// Заполнение шапки
		Мероприятие = ДанныеЗаполнения.Мероприятие;
		Сумма = ДанныеЗаполнения.Мероприятие.СтоимостьУчастия * ДанныеЗаполнения.Участники.Количество();
		ОплатыВТабличнойЧасти = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ЗадолженностьКазначея Расход
	Движения.ЗадолженностьКазначея.Записывать = Истина;   
	
	Если ОплатыВТабличнойЧасти Тогда
		Для Каждого СтрокаТЧ Из Оплаты Цикл
			Движение = Движения.ЗадолженностьКазначея.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Мероприятие = СтрокаТЧ.Мероприятие;
			Движение.Сумма = СтрокаТЧ.Сумма;
		КонецЦикла;
	Иначе 
		Движение = Движения.ЗадолженностьКазначея.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Мероприятие = Мероприятие;
		Движение.Сумма = Сумма;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОплатыВТабличнойЧасти Тогда
		МассивМероприятий = ОбщегоНазначения.ПолучитьМассивУникальныхЗначенийКолонки(Оплаты, "Мероприятие");
		Мероприятие = ?(МассивМероприятий.Количество() = 1, МассивМероприятий[0], Справочники.Мероприятия.ПустаяСсылка());
		Сумма = Оплаты.Итог("Сумма");
	Иначе
		Оплаты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ОплатыВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Добавить("Оплаты.Мероприятие");
	Иначе
		ПроверяемыеРеквизиты.Добавить("Мероприятие");
	КонецЕсли;

КонецПроцедуры




