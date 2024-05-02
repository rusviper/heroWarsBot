local MainTools = require('MainTools')
local Txt = require('Txt')

local LibTools = {}

similarity = 0.69
--similarity = 0.5
toastOn = true

-- расширенный поиск через exists
-- waitTimeout - таймаут ожидания объекта
-- showTimeout - таймаут подсветки найденного объекта
-- notVisibleCallback обработчик действия "не найден"
-- если найден - возвращается
function LibTools:exists(picName, waitTimeout, notVisibleCallback, showTimeout)

    if showTimeout == nil then
      showTimeout = 0.5
    end
    if waitTimeout == nil then
        waitTimeout = 7 -- default exists timeout
    end
    Txt:toast("Ищем " .. tostring(picName))
    btn = exists(Pattern(picName):similar(similarity), waitTimeout)

    if btn ~= nil then
        showVisible(btn, showTimeout)
        return btn
    end
    Txt:toast("Не найдено " .. picName)
    if (notVisibleCallback ~= nil) then
        notVisibleCallback(picName)
    end
    return nil
end

function LibTools:findPicOnRegion(region, picName, timeout, notVisibleCallback, waitTimeout)
    if timeout == nil then
      timeout = 1
    end
    if waitTimeout == nil then
        waitTimeout = 3 -- default exists timeout
    end
    if (region == nil) then
    	region = getGameArea()
    end

    -- для крестика регион статуса может закрывать
    Txt:syncToast("Ищем " .. tostring(picName))

    btn = region:exists(Pattern(picName):similar(similarity), waitTimeout)

    if btn ~= nil then
        showVisible(btn)
        return btn
    end
    Txt:toast("Не найдено " .. picName)
    if (notVisibleCallback ~= nil) then
        notVisibleCallback(picName)
    end
    return nil
end

-- кликает на картинку, перед этим подсвечивает на timeout
function LibTools:clickOnPicture(picName, waitTimeout, notVisibleCallback, showTimeout)
    if notVisibleCallback == nil then
      notVisibleCallback = printNotVisible
    end
    found = LibTools:exists(picName, waitTimeout, notVisibleCallback, showTimeout)
    if found ~= nil then
        click(found)
        return found
    end
    return nil
end

-- не пишет сообщение, если не найдено
function LibTools:clickIfVisible(pic)
    return LibTools:clickOnPicture(pic, 1, nil)
end

-- пишет в окошко, что не найдено
function printNotVisible(pic)
    print("Изображение не найдено на экране: " .. pic)
end

-- пишет в попап, что найдено и подсвечивает регион, показывает score
function showVisible(match, timeout)
    if timeout == nil then
      timeout = 1
    end
    --Txt:toast("найдено " .. tostring(match))
    text = "" .. match:getScore()
    match:highlight(text, timeout)
end

-- рисуем квадрат, в центр которого был клик
function LibTools:highlightPoint(location, timeout, radius)
    if (timeout == nil) then
        timeout = 3
    end
    if (radius == nil) then
        radius = 50
    end
    Region(location.x - radius, location.y - radius, radius * 2, radius * 2):highlight(timeout)
end


--#########################
-- клик по изображению в рамках другого изображения
function LibTools:clickPicOnPic(field, object)
    objectMatch = LibTools:findPicOnPic(field, object)
    if (objectMatch ~= nil) then
    click(objectMatch)
    end
end
-- ищет изображение в рамках другого изображения
function LibTools:findPicOnPic(field, object)
    -- подсветим поле
    fieldMatch = LibTools:exists(field, nil, printNotVisible)
    if (fieldMatch == nil) then
        return nil
    end

    objectMatch = fieldMatch:find(object)
    if (objectMatch == nil) then
        printNotVisible(object)
        return nil
    end
    -- подсветим объект
    showVisible(objectMatch)
    return objectMatch
end

--==== FIND FIRST

-- параметры пакует в таблицу
function listToTable(a1, a2, a3, a4, a5)
    rval = {}
    if a1 ~= nil then rval[1] = a1 else return rval end
    if a2 ~= nil then rval[2] = a2 else return rval end
    if a3 ~= nil then rval[3] = a3 else return rval end
    if a4 ~= nil then rval[4] = a4 else return rval end
    if a5 ~= nil then rval[5] = a5 else return rval end
    return rval
end
-- ищем первое совпадение по списку изображений. Найденное возвращаем
function LibTools:findFirstOfList(pic1, pic2, pic3, pic4, pic5)
    return LibTools:findFirstOf(listToTable(pic1, pic2, pic3, pic4, pic5))
end
-- ищем первое совпадение по списку изображений. Найденное возвращаем
function LibTools:findFirstOf(picTable)
    snapshot()
    for i, m in pairs(picTable) do
        found = LibTools:exists(m, 1, nil, 2)
        if (found ~= nil) then
            hiText = getMatchHiText(m, found)
            print(getMatchPrintText(m, found))
            usePreviousSnap(false)
            return found
        end
    end
    usePreviousSnap(false)
    Txt:toast("Не найдено ничего из " .. MainTools:tableSize(picTable) .. " изображений")
    return nil
end



--==== MASS HIGHLIGHT

function LibTools:highlightPics(table)
    founds = {}
    snapshot()
    for i, m in pairs(table) do
        found = LibTools:exists(m)
        if (found ~= nil) then
            hiText = getMatchHiText(m, found)
            found:highlight(hiText, 2)
            print(getMatchPrintText(m, found))
            founds[i] = found
        end
    end
    usePreviousSnap(false)
end

function getMatchHiText(pic, match)
    return "" .. match:getScore()
end

function getMatchPrintText(pic, match)
    return pic .. ": score=" .. match:getScore()
end


-- ищем и показываем все совпадения по одной картинке
function LibTools:showAll(pic)
    allMatches = findAllNoFindException(pic)
    Txt:toast("Всего видно " .. MainTools:tableSize(allMatches) .. " штук")
    for i, m in pairs(allMatches) do
    	hiText = getMatchHiText(i, m)
        m:highlight()
        print(getMatchPrintText(i, m))
    end

    wait(3)
    -- а так работает? Работает!
    iterateTable(allMatches, function(i, m)
            toast("Работает! " .. i)
            --m:highlightOff()
        end
    )
end

function iterateTable(table, action)
    for i, m in pairs(allMatches) do
        action(i, m)
    end
end

--################ НА ТЕСТ

-- ищет N-ное изображение из найденных
function LibTools:findByIndex(pic, index)
    Txt:toast("getFindFailedResponse()=" .. getFindFailedResponse())
    FindFailed.setFindFailedResponse("PROMPT")
    allMatches = findAllNoFindException(PS)
    -- сохраняем в лист для повторного использования
    --mm = list(getLastMatches())
    toast(tableSize(allMatches) .. " штуки найдено")
    for i, m in ipairs(allMatches) do
        if (i == index) then
            m:highlight(2)
            return m
        end
    end
    for a in mm do
        toast(a.getScore() .. " -- " .. a.getTarget())
    end
    return mm[index]
end

function LibTools:findByIndex2(pic, index)
    toast("getFindFailedResponse()")
    list = findAllByColumn(pic)

    toast("len(list)" .. tableSize(list))
    return list.get(index)
end

function LibTools:findNoException(pic)
    allMatches = findAllNoFindException(pic)
    return allMatches.next()
end

-- выполняет действие с использованием одного снимка
function LibTools:doWithOneSnap(action, p1, p2)
  snapshot()
  val = action(p1, p2)
  usePreviousSnap(false)
  return val
end

-- deprecated
function LibTools:clickWithOffset(clickPic, offset)
    target = Pattern(clickPic):targetOffset(offset)
    LibTools:clickOnPicture(target)
end

-- deprecated
function LibTools:ifPicClickOnPic(picCheck, picClick)
  if exists(picCheck) then
    LibTools:clickOnPicture(picClick)
  end
end

return LibTools