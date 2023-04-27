local LibTools = {}

--similarity = 0.69
similarity = 0.65
toastOn = true

-- расширенный поиск через exists
function LibTools:findPic(picName, timeout, notVisibleCallback, waitTimeout)
    if timeout == nil then
      timeout = 1
    end
    if waitTimeout == nil then
        waitTimeout = 3 -- default exists timeout
    end
    LibTools:toast("Ищем " .. tostring(picName))
    btn = exists(Pattern(picName):similar(similarity), waitTimeout)

    if btn ~= nil then
        showVisible(btn)
        return btn
    end
    LibTools:toast("Не найдено " .. picName)
    if (notVisibleCallback ~= nil) then
        notVisibleCallback(picName)
    end
    return nil
end

function LibTools:toast(toastText)
    LibTools:ifToast(toastText, toastOn)
end

function LibTools:ifToast(toastText, condition)
    if condition == nil then
        condition = toastOn
    end
    if condition then
        toast(toastText)
    end
end

function LibTools:exists(picName, timeout, notVisibleCallback, waitTimeout)
    return LibTools:findPic(picName, timeout, notVisibleCallback, waitTimeout)
end

-- кликает на картинку, перед этим подсвечивает на timeout
function LibTools:clickOnPicture(picName, timeout, notVisibleCallback, waitTimeout)
    if notVisibleCallback == nil then
      notVisibleCallback = printNotVisible
    end
    found = LibTools:exists(picName, timeout, notVisibleCallback, waitTimeout)
    if found ~= nil then
        click(found)
    end
    return found
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
    --LibTools:toast("найдено " .. tostring(match))
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
    fieldMatch = LibTools:findPic(field, 0.5, printNotVisible)
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
    LibTools:findFirstOf(listToTable(pic1, pic2, pic3, pic4, pic5))
end
-- ищем первое совпадение по списку изображений. Найденное возвращаем
function LibTools:findFirstOf(picTable)
    for i, m in pairs(picTable) do
        found = LibTools:exists(m)
        if (found ~= nil) then
            hiText = getMatchHiText(m, found)
            found:highlight(hiText, 2)
            print(getMatchPrintText(m, found))
            return found
        end
    end
    LibTools:toast("Не найдено ничего из " .. tableSize(picTable) .. " изображений")
end

function tableSize(t)
    size = 0
    for a,b in pairs(t) do
        --print("" .. a .. "-" .. tostring(b))
        size = size + 1
    end
    return size
end

--==== MASS HIGHLIGHT

function LibTools:highlightPics(table)
    founds = {}
    --usePreviousSnap(true)
    for i, m in pairs(table) do
        found = LibTools:exists(m)
        if (found ~= nil) then
            hiText = getMatchHiText(m, found)
            found:highlight(hiText, 2)
            print(getMatchPrintText(m, found))
            founds[i] = found
        end
    end
    --usePreviousSnap(false)
    --wait(3)
    --for i, m in pairs(founds) do
    --    m:highlightOff()
    --end
end

function getMatchHiText(pic, match)
    return "" .. match:getScore()
end

function getMatchPrintText(pic, match)
    return pic .. ": score=" .. match:getScore()
end


--################ НА ТЕСТ


-- ищем и показываем все совпадения по одной картинке
function LibTools:showAll(pic)
    allMatches = findAllNoFindException(pic)
    LibTools:toast("Всего видно " .. tableSize(allMatches) .. " штук")
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

-- ищет N-ное изображение из найденных
function LibTools:findByIndex(pic, index)
    LibTools:toast("getFindFailedResponse()=" .. getFindFailedResponse())
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
  usePreviousSnap(true)
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

-- deprecated
function LibTools:waitForPicture(picWait, timeout)
  if timeout == nil then
    timeout = 1
  end
  wait(picWait, timeout)
end


-- тестовый метод
function LibTools:hello(name)
  print("Hello, " .. name)
end

return LibTools
