local LibTools = {}

similarity = 0.69
-- кликает на картинку, перед этим подсвечивает на timeout
function LibTools:clickOnPicture(picName, timeout, notVisibleCallback, waitTimeout)
    found = LibTools:exists(picName, timeout, notVisibleCallback, waitTimeout)
    if found ~= nil then
        click(found)
    end
end

function printNotVisible(pic)
    print("Изображение не найдено на экране: " .. pic)
end

function LibTools:clickWithOffset(clickPic, offset)
    target = Pattern(clickPic):targetOffset(offset)
    LibTools:clickOnPicture(target)
end

function LibTools:ifPicClickOnPic(picCheck, picClick)
  if exists(picCheck) then
    LibTools:clickOnPicture(picClick)
  end
end


function LibTools:clickIfVisible(pic, notVisibleCallback)
    LibTools:clickOnPicture(pic, 1, nil)
end


function LibTools:waitForPicture(picWait, timeout)
  if timeout == nil then
    timeout = 1
  end
  wait(picWait, timeout)
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

function LibTools:clickPicOnPic(field, object)
    fieldMatch = find(field)
    -- подсветим поле
    fieldMatch:highlight(0.5)
    objectMatch = fieldMatch:find(object)
    -- подсветим объект
    objectMatch:highlight(0.5)
end

function LibTools:findByIndex(pic, index)
    toast("getFindFailedResponse()=" .. getFindFailedResponse())
    --FindFailed.setFindFailedHandler("LibTools:hello")
    FindFailed.setFindFailedResponse("PROMPT")
    allMatches = findAllNoFindException(PS)
    -- сохраняем в лист для повторного использования
    mm = list(getLastMatches())
    toast(table.getn(allMatches) .. " штуки найдено")
    for i, m in ipairs(allMatches) do
        m:highlight(2)
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
    allMatches = findAllNoFindException(PS)
    return allMatches.next()
end

function LibTools:exists(picName, timeout, notVisibleCallback, waitTimeout)
    if timeout == nil then
      timeout = 1
    end
    if (notVisibleCallback == nil) then
      notVisibleCallback = printNotVisible
    end
    if waitTimeout == nil then
        waitTimeout = 3 -- default exists timeout
    end
    toast("Ищем " .. tostring(picName))
    btn = exists(Pattern(picName):similar(similarity), waitTimeout)
    toast("найдено " .. tostring(btn))
    if btn ~= nil then
        text = "" .. btn:getScore()
        btn:highlight(text, timeout)
        return btn
    end
    if (notVisibleCallback ~= nil) then
        notVisibleCallback(picName)
    end
    return nil
end

-- тестовый метод
function LibTools:hello(name)
  print("Hello, " .. name)
end

return LibTools
