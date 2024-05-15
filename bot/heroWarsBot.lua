package.path = scriptPath() .. 'lib/?.lua;' .. package.path
local MainTools = require('MainTools')
local LibTools = require('LibTools')
local Txt = require('Txt')
local DevTools = require('DevTools')

local Ad = require('Ad')
local Hydra = require('Hydra')
local Navigation = require('Navigation')
local Outland = require('Outland')
local Titans = require('Titans')
local Tower = require('Tower')
local Port = require('Port')

local Rooms = require('Rooms')



adAction = "Реклама"
titanAction = "Титанит"
towerAction = "Башня"
hydraAction = "Гидра"
testAction = "test"
adWaitAction = "Подождать и закрыть AD"
coordsAction = "Coords"
closeAction = "Закрыть"
outlandAction = "запределье-боссы"
eventAction = "Событие"
portAction = "Порт"
aboutAction = "О программе"
testMenuAction = "Тестовые инструменты"

function actionMenu()
    spinnerSelectedValue = ""
    dialogInit()
    spinnerItems = { 
    	titanAction, towerAction, hydraAction, outlandAction, 
        adAction, adWaitAction,
        eventAction, portAction, testMenuAction, aboutAction}
    addTextView("Выберите действие: ")
    addSpinner("spinnerSelectedValue", spinnerItems, adAction)
    newRow()
    dialogShow()
    return spinnerSelectedValue
end

function selectFirstAction()
    action = actionMenu()
    if (action == titanAction) then
        Titans:titanCollect()
    elseif (action == towerAction) then
        Tower:towerCollect()
    elseif (action == hydraAction) then
        Hydra:hydraCollect()
    elseif (action == outlandAction) then
        Outland:outlandCollect()
    elseif (action == adAction) then
        Ad:adCollect()
    elseif (action == adWaitAction) then
        Ad:waitAdEnd(40)
    elseif (action == eventAction) then
        Titans:eventFights()
    elseif (action == portAction) then
        Port:collect()
    elseif (action == aboutAction) then
        showAboutDialog()
    elseif (action == testMenuAction) then
        selectTestAction()
    end
end

function testMenu()
    spinnerSelectedValue = ""
    dialogInit()
    spinnerItems = {
        testAction, coordsAction, closeAction }
    addTextView("Выберите тестовое действие: ")
    addSpinner("spinnerSelectedValue", spinnerItems, testAction)
    newRow()
    dialogShow()
    return spinnerSelectedValue
end

function selectTestAction()
    action = testMenu()
    if (action == testAction) then
        DevTools:testAction()
    elseif (action == closeAction) then
        Navigation:clickClose()
    elseif (action == coordsAction) then
        DevTools:showTouchCoords()
    end
end

function showAboutDialog()
    aboutText = "Written by rusviper. \nSee: https://github.com/rusviper/heroWarsBot \nmailTo:rusviper@gmail.com"
    dialogInit()
    addTextView(aboutText)
    newRow()
    dialogShow()
end

-- разработка с таким расширением
Settings:setScriptDimension(true, 2340)

-- экран со скрывающимися кнопками
setImmersiveMode(true)

-- положение кнопки запуска скрипта
setButtonPosition(0, 0)

-- стиль текста при подсветке
--Txt:setTargetTextStyle()


--toast("Прочитаем текст")
--testReadText("town/townCheck.png")

selectFirstAction()