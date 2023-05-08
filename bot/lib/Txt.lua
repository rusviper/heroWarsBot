local Txt = {}

-- стиль текста при подсветке

function Txt:setTargetTextStyle()
	setHighlightTextStyle(0xa5555555, 0xf8eeeeee, 8)
end

function Txt:setStatusTextStyle()
	setHighlightTextStyle(0xcc222222, 0xfffcf560, 12)
end


-- пишем в статус регион
--statusRegion = Region(1700, 950, 600, 150)	-- справа снизу
--statusRegion = Region(20, 1000, 2300, 100)	-- снизу узко
statusRegion = Region(20, 0, 2300, 100)		-- сверху узко

function Txt:status(text, timeout)
    if timeout == nil then
        timeout = 1
    end
    Txt:setStatusTextStyle()
    statusRegion:highlight(text, timeout)
    Txt:setTargetTextStyle()
end

function Txt:toast(toastText)
    Txt:status(toastText)
end

-- пишем в попап
function Txt:toast2(toastText)
    Txt:ifToast(toastText, toastOn)
end


function Txt:ifToast(toastText, condition)
    if condition == nil then
        condition = toastOn
    end
    if condition then
        toast(toastText)
    end
end


return Txt