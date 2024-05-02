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

function actionMenu()
    spinnerSelectedValue = ""
    dialogInit()
    spinnerItems = { 
    	titanAction, towerAction, hydraAction, outlandAction, 
        testAction, adAction, adWaitAction, coordsAction,
        closeAction, eventAction, portAction}
    addTextView("Выберите действие: ")
    addSpinner("spinnerSelectedValue", spinnerItems, adAction)
    newRow()
    dialogShow()
    return spinnerSelectedValue
end


-- разработка с таким расширением
Settings:setScriptDimension(true, 2340)

-- экран со скрывающимися кнопками
setImmersiveMode(true)

-- стиль текста при подсветке
--Txt:setTargetTextStyle()


--toast("Прочитаем текст")
--testReadText("town/townCheck.png")

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
elseif (action == closeAction) then
    Navigation:clickClose()
elseif (action == coordsAction) then
    DevTools:showTouchCoords()
elseif (action == adWaitAction) then
    Ad:waitAdEnd(40)
elseif (action == testAction) then
    DevTools:testAction()
elseif (action == eventAction) then
    Titans:eventFights()
elseif (action == portAction) then
    Port:collect()
end