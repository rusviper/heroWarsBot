local MainTools = require('MainTools')

local Txt = {}

-- стиль текста при подсветке
colorLightGray = 0xa5555555
colorDark = 0xcc222222
colorLightWhite = 0xf8eeeeee
colorYellow = 0xfffcf560
function Txt:setTargetTextStyle()
	setHighlightTextStyle(colorLightGray, colorLightWhite, 8)
end

function Txt:setStatusTextStyle()
	setHighlightTextStyle(colorDark, colorLightWhite, 10)
end


-- пишем в статус регион
--statusRegion = Region(1700, 950, 600, 150)	-- справа снизу
statusRegionDown = Region(20, 1000, 2300, 100)	-- снизу узко
--statusRegion = Region(20, 0, 2300, 100)		-- сверху узко
statusRegion = Region(20, 0, 2000, 90)		-- сверху часть

function Txt:status(text, timeout)
    if timeout == nil then
        timeout = 1
    end
    addLogMessage(text)

    Txt:setStatusTextStyle()
    statusRegion:highlight(getLogToPrint(), timeout)
    Txt:setTargetTextStyle()
end

function Txt:updateStatus(text)
    addLogMessage(text)

    Txt:setStatusTextStyle() -- не работает?
    statusRegion:highlightUpdate(getLogToPrint())
    Txt:setTargetTextStyle()
end



function Txt:syncToast(toastText)
    Txt:status(toastText)
end

function Txt:toast(toastText)
    Txt:updateStatus(toastText)
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

-- исследование корутин
-- в фукцию корутины не передаётся значение, похоже не реализовано
function Txt:asyncToast(str, timeout)
	co = coroutine.create(function (region)
	print(tostring(region))
		print(typeOf(region))
	wait(6)
		    region:highlightOff()
           return 6
         end)
    print(tostring(co))   --> thread: 0x8071d98
    print(coroutine.status(co))
    print(coroutine.resume(co, statusRegionDown))
    print(coroutine.status(co))

    statusRegionDown:highlightUpdate("jhgjhgj")
    wait(5)
        statusRegionDown:highlightUpdate("74754657657647")

    wait(10)
end


--------СТРОКИ--------

-- имитируем лог сообщений
logCollection = { }
maxPrintMessages = 2

-- общая строка
function getLogToPrint()
    resultString = ""
    size = MainTools:tableSize(logCollection)
    firstPrintIndex = size - maxPrintMessages + 1
    if firstPrintIndex < 1 then
    	firstPrintIndex = 1
    end
    index = 1

    for a,b in pairs(logCollection) do
    	if (index >= firstPrintIndex) then
    		resultString = resultString .. "\n" .. b
    	end
        index = index + 1
    end
    return resultString
end


-- общая строка
function getLogToPrintAll()
    resultString = ""
    for a,b in pairs(logCollection) do
        resultString = resultString .. "\n" .. b
    end
    return resultString
end

-- добавляем, ротируем
function addLogMessage(msg)
    -- пока только добавляем
    count = MainTools:tableSize(logCollection)
    logCollection[count+1] = getLogString(msg)
end

-- добавляем время
function getLogString(text)
    time = os.date("%H:%M:%S")
    return time .. ">   " .. text
end

----------------------





return Txt