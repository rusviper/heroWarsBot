local LibTools = {}

similarity = 0.69

-- расширенный поиск через exists
function LibTools:findPic(picName, timeout, notVisibleCallback, waitTimeout)
    if timeout == nil then
      timeout = 1
    end
    if waitTimeout == nil then
        waitTimeout = 3 -- default exists timeout
    end
    toast("Ищем " .. tostring(picName))
    btn = exists(Pattern(picName):similar(similarity), waitTimeout)

    if btn ~= nil then
        showVisible(btn)
        return btn
    end
    toast("Не найдено " .. picName)
    if (notVisibleCallback ~= nil) then
        notVisibleCallback(picName)
    end
    return nil
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
end

-- не пишет сообщение, если не найдено
function LibTools:clickIfVisible(pic)
    LibTools:clickOnPicture(pic, 1, nil)
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
    toast("найдено " .. tostring(btn))
    text = "" .. btn:getScore()
    btn:highlight(text, timeout)
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


--################ НА ТЕСТ

function LibTools:highlightPics(table)
    for i, m in pairs(table) do
        found = LibTools:exists(m)
        txt = i .. " : " .. found.getScore()
        found:highlight(txt)
        print(txt)
    end
    wait(3)
    highlightOff()
end

-- ищем и показываем все совпадения
function LibTools:showAll(pic)
    allMatches = findAllNoFindException(pic)
    mm = list(getLastMatches())

    toast(table.getn(allMatches) .. " штуки найдено")
        for i, m in ipairs(allMatches) do
            m:highlight()
        end

    wait(3)
    highlightOff()
end

-- ищет N-ное изображение из найденных
function LibTools:findByIndex(pic, index)
    toast("getFindFailedResponse()=" .. getFindFailedResponse())
    --FindFailed.setFindFailedHandler("LibTools:hello")
    FindFailed.setFindFailedResponse("PROMPT")
    allMatches = findAllNoFindException(PS)
    -- сохраняем в лист для повторного использования
    mm = list(getLastMatches())
    toast(table.getn(allMatches) .. " штуки найдено")
    for i, m in ipairs(allMatches) do
        if (i == index)
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

    toast("len(list)" .. len(list))
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
