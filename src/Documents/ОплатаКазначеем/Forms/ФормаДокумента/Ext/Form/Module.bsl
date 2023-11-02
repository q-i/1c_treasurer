﻿&НаКлиенте
Процедура ОплатыВТабличнойЧастиПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры


//
&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.ГруппаШапка.Видимость = (НЕ Объект.ОплатыВТабличнойЧасти);
	Элементы.ГруппаТабЧасть.Видимость = Объект.ОплатыВТабличнойЧасти;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсеДолгиКазначеяНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиЗК.Мероприятие КАК Мероприятие,
	|	ОстаткиЗК.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ЗадолженностьКазначея.Остатки(, ) КАК ОстаткиЗК
	|ГДЕ
	|	ОстаткиЗК.СуммаОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Мероприятие
	|АВТОУПОРЯДОЧИВАНИЕ";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Оплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗаполнитьВсеДолгиКазначея(Команда)

	ТекущиеДанные = Элементы.Оплаты.ТекущиеДанные;
	Если Объект.Оплаты.Количество() > 0 Тогда
		Ответ = Ждать ВопросАсинх("Табличная часть будет перезаполнена! Продолжить?", РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Отмена);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьВсеДолгиКазначеяНаСервере();

КонецПроцедуры
