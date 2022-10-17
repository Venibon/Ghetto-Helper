script_name("Ghetto Helper by VRush")
script_version("1.7")
script_author('VRush')

--==--libs--==--
require 'moonloader'
local imgui = require 'imgui'
local imadd = require 'imgui_addons'
imgui.ToggleButton = require('imgui_addons').ToggleButton
local imadd = require("imgui_addons")
local inicfg = require "inicfg"
local sampev = require 'lib.samp.events'
local rkeys = require 'rkeys'
local dlstatus = require('moonloader').download_status
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local fa = require 'faIcons'
local fonts = renderCreateFont("Arial", 9, 5)

local cfg = inicfg.load({
   config = {
      SbivBind = false,
      DrugTimer = false,
      Bell = false,
      mainwin = true,
      Styles = 2,
      Kill = false,
      CmdMb = false,
      Invite = false,
      InvRank = 1,
      UnInvite = false,
      UvalText = u8'Âûñåëåí.',
      SpawnCar = false,
      NaborBang = 0,
      Nabor = false,
      Stats = false,
      CPX = 13,
      CPY = 992,
      HPHud = false,
      Sklad = false,
      CmdMb = true,
      CmdM4 = true,
      CmdDe = true,
      CheckOnline = false,
      OPX = 13,
      OPY = 992,
      fb_pal1 = 255,
      fb_pal2 = 255,
      fb_pal3 = 255,
      colorfb = 0xFFFFFF,
      ColorFb = false,
      AutoUpdate = 1,
      WPX = 500,
      WPC = 500,
      DPX = 500,
      DPY = 500,
      CommandAct = 'gh',
      SizeFont = 9,
      FlagFont = 5,
      DrugKolvo = 3,
      DrugTimerTime = 7,
      OnlineGrove = true,
      OnlineBallas = true,
      OnlineVagos = true,
      OnlineAztec = true,
      OnlineRifa = true,
      OnlineNightWolfs = true,
      SbivKey = 0x5A,
      TextSbiv = ' ',
      formuval = false,
   }
}, "Ghetto Helper/Ghetto Helper.ini")
local font = renderCreateFont("Arial", cfg.config.SizeFont, cfg.config.FlagFont)


--==--Imgui--==--
local window = imgui.ImBool(false)
local window_v = imgui.ImBool(false)
local checksbiv = imgui.ImBool(cfg.config.SbivBind)
local checkdtimer = imgui.ImBool(cfg.config.DrugTimer)
local checkbell = imgui.ImBool(cfg.config.Bell)
local checkkill = imgui.ImBool(cfg.config.Kill)
local nepocaz = imgui.ImBool(cfg.config.mainwin)
local ComboStyle = imgui.ImInt(cfg.config.Styles)
local ComboNabor = imgui.ImInt(cfg.config.NaborBang)
local checkinvite = imgui.ImBool(cfg.config.Invite)
local invrank = imgui.ImInt(cfg.config.InvRank)
local checkuninvite = imgui.ImBool(cfg.config.UnInvite)
local uvaltext = imgui.ImBuffer(cfg.config.UvalText,256)
local checkspawncar = imgui.ImBool(cfg.config.SpawnCar)
local checknabor = imgui.ImBool(cfg.config.Nabor)
local checkstats = imgui.ImBool(cfg.config.Stats)
local checkhphud = imgui.ImBool(cfg.config.HPHud)
local checksklad = imgui.ImBool(cfg.config.Sklad)
local checkonline = imgui.ImBool(cfg.config.CheckOnline)
local radioautoupdate = imgui.ImInt(cfg.config.AutoUpdate)
local commandact = imgui.ImBuffer(cfg.config.CommandAct,256)
local sizefont = imgui.ImInt(cfg.config.SizeFont)
local flagfont = imgui.ImInt(cfg.config.FlagFont)
local enbgrove = imgui.ImBool(cfg.config.OnlineGrove)
local enbballas = imgui.ImBool(cfg.config.OnlineBallas)
local enbvagos = imgui.ImBool(cfg.config.OnlineVagos)
local enbaztec = imgui.ImBool(cfg.config.OnlineAztec)
local enbrifa = imgui.ImBool(cfg.config.OnlineRifa)
local enbnightwolfs = imgui.ImBool(cfg.config.OnlineNightWolfs)
local cmdmb = imgui.ImBool(cfg.config.CmdMb)
local cmdde = imgui.ImBool(cfg.config.CmdDe)
local cmdm4 = imgui.ImBool(cfg.config.CmdM4)
local formuval = imgui.ImBool(cfg.config.formuval)
local textsbiv = imgui.ImBuffer(cfg.config.TextSbiv,256)

--==--Local--==--
local Timer = {state = false, start = 0}
local TimerTime = 7
local menu = 1
local menun = 'Ãëàâíàÿ'
local styles = {
    u8'Çåëåíàÿ òåìà',
    u8'Êðàñíàÿ òåìà',
    u8'Ôèîëåòîâàÿ òåìà',
    u8'Âèøíåâàÿ òåìà',
}
local bands = {
    u8'Íå óêàçàíî.',
    u8'Grove',
    u8'Ballas',
    u8'Aztec',
    u8'Rifa',
    u8'Vagos',
    u8'Night Wolfs',
}
local killss = 0
local pagesize = 15
local changestatspos = false
local firstspawn = false
local current = 0
local total = 0
local kills = 0
local deaths = 0
local ratio = 0
local clistgrove = 0x99009327
local clistballas = 0x99CC00CC
local clistrifa = 0x996666FF
local clistvagos = 0x99D1DB1C
local clistaztec = 0x9900FFE2
local clistnightwolfs = 0x807F6464
ogrove = 0
oballas = 0 
orifa = 0
ovagos = 0 
oaztec = 0
onightwolfs = 0
local fa_font = nil
local fontsize = nil
local menuk = {
	fa.ICON_INFO..u8' Èíôîðìàöèÿ',
	fa.ICON_BARS..u8' Ôóíêöèè',
	fa.ICON_ID_CARD..u8' Äëÿ 9+ ðàíãîâ',
	fa.ICON_TERMINAL..u8' Êîìàíäû',
	fa.ICON_COGS..u8' Íàñòðîéêè',
}
local dead_players = {}
local tLastKeys = {}
HotkeySbiv = {
    v = {0x5A}
}

local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

function neakBtn(...)
    local result = false
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.03, 0.03, 0.03, 0.03))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.03, 0.03, 0.03, 0.03))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.03, 0.03, 0.03, 0.03))
    if imgui.Button(...) then
        result = true
    end
    imgui.PopStyleColor(3)
    return result
end

function imgui.OnDrawFrame()
    if window.v then
        imgui.SetNextWindowPos(imgui.ImVec2(350,300), imgui.Cond.FirstUseEver)
        imgui.Begin('Ghetto Helper by VRush', window, imgui.WindowFlags.NoTitleBar, imgui.WindowFlags.AlwaysAutoResize)
        imgui.BeginChild('##left', imgui.ImVec2(150, 300), true)
        for k, v in ipairs(menuk) do
            if menu ~= k then  
                if neakBtn(v, imgui.ImVec2(-1, 55)) then
                    menu = k
                    menun = u8:decode(menuk[k])
                end
            else 
                if imgui.Button(v, imgui.ImVec2(-1, 55)) then
                    menu = k
                    menun = u8:decode(menuk[k])
                end
            end
		end
        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginChild('##right', imgui.ImVec2(500, 300), true)
        if menu == 1 then
            imgui.Text(u8'Ñêðèïò ñîçäàí äëÿ óïðîùåíèÿ èãðû â ãåòòî èëè íà êàïòàõ')
            imgui.Text(u8'Àâòîð ýòîãî ñêðèïòà VRush')
            imgui.Link("https://www.blast.hk/threads/138165/",u8'Òåìà íà Blast.hk')
            imgui.Link("https://send.monobank.ua/jar/6t7Whh3esB",u8'Ïîääåðæàòü àâòîðà')
            imgui.TextColoredRGB('Ñïàñèáî çà ïîëüçîâàíèå {525497}Ghetto Helper{FFFFFF})')
            imgui.Text(u8'Òåêóùàÿ âåðñèÿ: '..thisScript().version..u8' Ïîñëåäíÿÿ âåðñèÿ äëÿ îáíîâëåíèÿ '..updateversion)
            if updateversion ~= thisScript().version then 
                imgui.Text(u8'Òðåáóåòñÿ îáíîâëåíèå!')
                imgui.SameLine()
                if imgui.Button(u8'Îáíîâèòü äî âåðñèè '..updateversion) then 
                    autoupdate("https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
                end
            else 
                imgui.Text(u8'Îáíîâëåíèå íå òðåáóåòñÿ')
            end
        end
        if menu == 2 then
            if imgui.Checkbox('##Sbiv', checksbiv) then
                cfg.config.SbivBind = checksbiv.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Ñáèâ íà Z ')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS) then imgui.OpenPopup(u8'Ñáèâ íà Z') end
            if imgui.BeginPopup(u8'Ñáèâ íà Z') then
                imgui.Text(u8'Ïðè íàæàòèè íà íëàâèøó â ÷àò áóäåò îòïðàâëÿòüñÿ ñîîáùåíèå, ñáèâàÿ àíèìàöèþ')
                imgui.Text(u8'Âûáðàòü êëàâèøó: ')
                imgui.SameLine()
                if imadd.HotKey("##1", HotkeySbiv, tLastKeys, 100) then
                    cfg.config.SbivKey = table.concat(HotkeySbiv.v)
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.PushItemWidth(90)
                imgui.Text(u8'Ñîîáùåíèå äëÿ ñáèâà: ')
                imgui.SameLine()
                if imgui.InputText(u8'', textsbiv) then
                    cfg.config.TextSbiv = textsbiv.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.EndPopup()
            end

            if imgui.Checkbox('##DrugTimer', checkdtimer) then
                cfg.config.DrugTimer = checkdtimer.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'DrugTimer ')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##2') then imgui.OpenPopup(u8'DrugTimer') end
            if imgui.BeginPopup(u8'DrugTimer') then
                imgui.Text(u8'Ïðè íàæàòèè íà Õ áóäåò èñïîëüçîâàòñÿ íàðêî è çàïóñêàòüñÿ òàéìåð íà ýêðàíå.')
                imgui.EndPopup()
            end

            if imgui.Checkbox('##bell', checkbell) then
                cfg.config.Bell = checkbell.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Êîëîêîëü÷èê ')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##3') then imgui.OpenPopup(u8'bell') end
            if imgui.BeginPopup(u8'bell') then
                imgui.Text(u8'Ïðè íàíåñåíèè óðîíà, áóäåò ïðîèãðûâàòñÿ çâóê.')
                imgui.EndPopup()
            end

            if imgui.Checkbox('##kill', checkkill) then
                cfg.config.Kill = checkkill.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'KillState')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##4') then imgui.OpenPopup(u8'kill') end
            if imgui.BeginPopup(u8'kill') then
                imgui.Text(u8'Íàäïèñü +kill ïðè óáèéñòâå')
                imgui.EndPopup()
            end

            if imgui.Checkbox('##stats', checkstats) then
                cfg.config.Stats = checkstats.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'CaptStats')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##5') then imgui.OpenPopup(u8'CaptStats') end
            if imgui.BeginPopup(u8'CaptStats') then
                imgui.Text(u8'Âàøà ñòàòèñòèêà êàïò â ñëåâà ïîä ðàäàðîì')
                if imgui.Button(u8'Èçìåíèòü ïîçèöèþ##s') then 
                    changestatspos = true             
                    msg('Íàæìèòå ËÊÌ ÷òîáû ñîõðàíèòü ïîçèöèþ.') 
                    window.v = false
                end
                if imgui.Button(u8'Îáíóëèòü') then
                    total,deaths,kills = 0, 0, 0
                end
                imgui.Text(u8'Ðàçìåð øðèôòà')
                imgui.SameLine()
                imgui.Ques('Ïîñëå ñìåíû ðàçìåðà ïåðåçàãðóçèòå ñêðèïò')
                imgui.SameLine()
                if imgui.InputInt('##size', sizefont) then
                    local font = renderCreateFont("Arial", cfg.config.SizeFont, cfg.config.FlagFont)
                    cfg.config.SizeFont = sizefont.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.Text(u8'Ôëàã øðèôòà')
                imgui.SameLine()
                imgui.Ques('Ïîñëå ñìåíû ôëàãà ïåðåçàãðóçèòå ñêðèïò')
                imgui.SameLine()
                if imgui.InputInt('##flag', flagfont) then
                    local font = renderCreateFont("Arial", cfg.config.SizeFont, cfg.config.FlagFont)
                    cfg.config.FlagFont = flagfont.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.EndPopup()
            end

            if imgui.Checkbox('##checkonline', checkonline) then
                cfg.config.CheckOnline = checkonline.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'CheckOnline')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##6') then imgui.OpenPopup(u8'checkonline') end
            if imgui.BeginPopup(u8'checkonline') then
                imgui.Text(u8'Êîë-âî ó÷àñòíèêîâ áàíä ó âàñ íà ýêðàíå\nÒàêæå ïî êîìàíäå /cho')
                if imgui.Button(u8'Èçìåíèòü ïoçèöèþ##sa') then 
                    changecheckonlinepos = true             
                    msg('Íàæìèòå ËÊÌ ÷òîáû ñîõðàíèòü ïîçèöèþ.') 
                    window.v = false
                end
                imgui.Text(u8'Èçìåíèòü îòîáðàæåíèå áàíä:')
                imgui.Text(u8'Grove')
                imgui.SameLine()
                if imgui.Checkbox('##Grove', enbgrove) then cfg.config.OnlineGrove = enbgrove.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.Text(u8'Ballas')
                imgui.SameLine()
                if imgui.Checkbox('##Ballas', enbballas) then cfg.config.OnlineBallas = enbballas.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.Text(u8'Los Santos Vagos')
                imgui.SameLine()
                if imgui.Checkbox('##Vagos', enbvagos) then cfg.config.OnlineVagos = enbvagos.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.Text(u8'Varrios Los Aztecaz')
                imgui.SameLine()
                if imgui.Checkbox('##Aztec', enbaztec) then cfg.config.OnlineAztec = enbaztec.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.Text(u8'Rifa')
                imgui.SameLine()
                if imgui.Checkbox('##Rifa', enbrifa) then cfg.config.OnlineRifa = enbrifa.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.Text(u8'Night Wolfs')
                imgui.SameLine()
                if imgui.Checkbox('##Night Wolfs', enbnightwolfs) then cfg.config.OnlineNightWolfs = enbnightwolfs.v inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini') end
                imgui.EndPopup()
            end
            if imgui.Checkbox('##hphud', checkhphud) then
                cfg.config.HPHud = checkhphud.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'HPHud')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##7') then imgui.OpenPopup(u8'HpHud') end
            if imgui.BeginPopup(u8'HpHud') then
                imgui.Text(u8'Ïîêàçûâàåò êîë-âî ÕÏ íà õïáàðå')
                imgui.EndPopup()
            end
        end
        if menu == 3 then
            if imgui.Checkbox(u8'##inv', checkinvite) then
                cfg.config.Invite = checkinvite.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.PushItemWidth(82.5)
            imgui.Text(u8'Áûñòðûé èíâàéò')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS) then imgui.OpenPopup(u8'inv') end
            if imgui.BeginPopup(u8'inv') then
                imgui.Text(u8'Àâòîìàòè÷åñêè áóäåò îòïðàâëÿòü èíâàéò ñ ÐÏ îòûãðîâêîé. Àêòèâàöèÿ: ÏÊÌ + 1')
                if imgui.InputInt(u8'Ðàíã ïðè èíâàéòå', invrank) then
                    cfg.config.InvRank = invrank.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                if invrank.v <= 0 or invrank.v >= 9 then
                    invrank.v = 1
                end
                imgui.EndPopup()
            end
            if imgui.Checkbox(u8'##uval', checkuninvite) then
                cfg.config.UnInvite = checkuninvite.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.PushItemWidth(120)
            imgui.Text(u8'Áûñòðîå óâîëüíåíèå')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##7') then imgui.OpenPopup(u8'uval') end
            if imgui.BeginPopup(u8'uval') then
                imgui.Text(u8'Áûñòðîå óâîëüíåíèå ÷ëåíà áàíäû. Àêòèâàöèÿ: /fu [ID]')
                if imgui.InputText(u8'Ïðè÷èíà óâîëüíåíèÿ', uvaltext) then
                    cfg.config.UnInviteText = uvaltext.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.EndPopup()
            end
            if imgui.Checkbox(u8'##formuval', formuval) then
                cfg.config.formuval = formuval.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Ôîðìà íà óâîëüíåíèå')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##10') then imgui.OpenPopup(u8'forluval') end
            if imgui.BeginPopup(u8'forluval') then
                imgui.Text(u8'Ïðè ñîîáùåíèÿõ ïî òèïó "ïñæ" "óâàë" áóäåò âûâîäèòñÿ ôîðìà äëÿ óâîëüíåíèÿ.')
                if imgui.InputText(u8'Ïðè÷èíà óâîëüíåíèÿ#11', uvaltext) then
                    cfg.config.UnInviteText = uvaltext.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.EndPopup()
            end

            if imgui.Checkbox(u8'##scar', checkspawncar) then
                cfg.config.SpawnCar = checkspawncar.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Áûñòðûé ñïàâí êàðîâ')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##8') then imgui.OpenPopup(u8'scar') end
            if imgui.BeginPopup(u8'scar') then
                imgui.Text(u8'Áûñòðûé ñïàâí êàðîâ ôðàêöèè /scar')
                imgui.EndPopup()
            end
            
            if imgui.Checkbox(u8'##sklad', checksklad) then
                cfg.config.Sklad = checksklad.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Áûñòðîå îòêðûòèå ñêëàäà')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##9') then imgui.OpenPopup(u8'sklad') end
            if imgui.BeginPopup(u8'sklad') then
                imgui.Text(u8'Áûñòðîå îòêðûòèå ñêëàäàâ ôðàêöèè /sk')
                imgui.EndPopup()
            end
            if imgui.Checkbox(u8'##nabor', checknabor) then
                cfg.config.Nabor = checknabor.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'Îáúÿâëåíèÿ î íàáîðå')
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS..'##10') then imgui.OpenPopup(u8'nabor') end
            if imgui.BeginPopup(u8'nabor') then
                imgui.Text(u8'Áûñòðàÿ ðàññûëêà î íàáîðå âî ôðàêöèþ ïðè ââîäå êîìàíäû /na')
                imgui.PushItemWidth(130)
                if imgui.Combo('', ComboNabor, bands) then
                    cfg.config.NaborBang = ComboNabor.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.EndPopup()
            end
        end
        if menu == 4 then
            if imgui.Checkbox('##mb', cmdmb) then
                cfg.config.CmdMb = cmdmb.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'/mb') 
            imgui.SameLine()
            if imgui.Button(fa.ICON_COGS) then imgui.OpenPopup(u8'mb') end
            if imgui.BeginPopup(u8'mb') then
                imgui.Text(u8'Áûñòðîå îòêðûòèå /members')
                imgui.EndPopup()
            end
            if imgui.Checkbox('##de', cmdde) then
                cfg.config.CmdDe = cmdde.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'/de') 
            imgui.SameLine()
            imgui.Ques(u8'Áûñòðîå ñîçäàíèå äèãëà /de [Êîë-âë]')
            if imgui.Checkbox('##m4', cmdm4) then
                cfg.config.CmdM4 = cmdm4.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            imgui.Text(u8'/m4') 
            imgui.SameLine()
            imgui.Ques(u8'Áûñòðîå ñîçäàíèå ýìêè /m4 [Êîë-âë]')
        end
        if menu == 5 then
            imgui.Text(u8'Ñìåíà òåìû ñêðèïòà')
            imgui.SameLine()
            imgui.PushItemWidth(130)
            if imgui.Combo('', ComboStyle, styles) then
               -- apply_style(ComboStyle.v)
                local i = ComboStyle.v + 1
                msg('Òåìà áûëà èçìåíåíà íà '..u8:decode(styles[i]))
                cfg.config.Styles = ComboStyle.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Àâòîîáíîâëåíèå')
            if imgui.RadioButton(u8'Âêëþ÷èòü', radioautoupdate, 1) then
                cfg.config.AutoUpdate = 1
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if imgui.RadioButton(u8'Âûêëþ÷èòü', radioautoupdate, 2) then
                cfg.config.AutoUpdate = 2
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Êîìàíäà àêòèâàöèè')
            imgui.SameLine()
            if imgui.InputText('', commandact) then
                cfg.config.CommandAct = commandact.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
        end
        imgui.EndChild()
        imgui.BeginChild("left_info", imgui.ImVec2(150, 70), false)
        imgui.NewLine()
        imgui.SameLine(15)
        imgui.SetCursorPosY(imgui.GetCursorPosY()+13)
        imgui.Text(u8("ÀÂÒÎÐ"))
        imgui.SameLine(95)
        imgui.SetCursorPosY(imgui.GetCursorPosY()-3)
        imgui.Button("VRush", imgui.ImVec2(50, 25))
        imgui.NewLine()
        imgui.SameLine(15)
        imgui.SetCursorPosY(imgui.GetCursorPosY()+3.5)
        imgui.Text(u8("ÂÅÐÑÈß"))
        imgui.SameLine(95)
        imgui.SetCursorPosY(imgui.GetCursorPosY()-3.5)
        imgui.Button(tostring(thisScript().version), imgui.ImVec2(50, 25))
        imgui.EndChild()
        imgui.SameLine() 
        imgui.BeginChild("right_info", imgui.ImVec2(500, 70), false)
        imgui.SetCursorPosY(imgui.GetCursorPosY()+10)
        if imgui.Button(u8'Ïåðåçàãðóçèòü ñêðèïò', imgui.ImVec2(-1, 25)) then lua_thread.create(function() reload = true window.v = false imgui.ShowCursor = false msg('Ñêðèïò áûë ïðèíóäèòåëüíî ïåðåçàãðóæåí') wait(50) thisScript():reload() end) end
        if imgui.Button(u8'Ñáðîñèòü íàñòðîéêè', imgui.ImVec2(-1, 25)) then 
            msg('Íàñòðîéêè áûëè ñáîðîøåíû äî ñîñòîÿíèå "Ïî óìîë÷àíèþ"')
            os.remove(getWorkingDirectory()..'/config/Ghetto Helper/Ghetto Helper.ini')
            msg('Ñêðèïò áûë ïðèíóäèòåëüíî ïåðåçàãðóæåí') 
            window.v = true
            thisScript():reload()
        end
        imgui.EndChild()
        imgui.End()
    end
    if window_v.v then
        imgui.SetNextWindowPos(imgui.ImVec2(350.0, 250.0), imgui.Cond.FirstUseEver)
        imgui.Begin('Window Title', window_v,imgui.WindowFlags.AlwaysAutoResize)
        imgui.BeginChild('##left', imgui.ImVec2(550, 130), true)
        imgui.TextColoredRGB('Ñïàñèáî çà ïîëüçîâàíèå {525497}Ghetto Helper')
        imgui.Text(u8'Àâòîð ýòîãî ñêðèïòà VRush')
        imgui.Link("https://www.blast.hk/members/415848/",u8'Ìîé áëàñòõàê')
        imgui.Link("https://www.blast.hk/threads/138165/",u8'Òåìà íà Blast.hk')
        imgui.TextColoredRGB('{FF0000}Â ÑÊÐÈÏÒÅ ÏÐÈÑÓÒÑÒÂÓÞÒ ÔÓÍÊÖÈÈ ÇÀ ÊÎÒÎÐÛÅ ÂÛ ÌÎÆÅÒÅ ÏÎËÓ×ÈÒÜ ÍÀÊÀÇÀÍÈÅ')
        imgui.TextColoredRGB('{FF0000}ÈÑÏÎËÜÇÓÉÒÅ ÍÀ ÑÂÎÉ ÑÒÐÀÕ È ÐÈÑÊ')
        imgui.EndChild()
        if imgui.Button(u8'Çàêðûòü', imgui.ImVec2(-1, 30)) then window_v.v = false window.v = true end
        imgui.TextDisabled(u8'Ïîêàçûâàòü ýòî îêíî ïðè çàïóñêå')
        imgui.SameLine()
        if imgui.Checkbox(u8'##ne', nepocaz) then cfg.config.mainwin = nepocaz.v inicfg.save(cfg, 'Ghetto Helper/Ghetto Helper.ini') end
        imgui.End()
    end
end

function autoupdate(json_url, prefix, url)
    lua_thread.create(function()
        local dlstatus = require('moonloader').download_status
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile(json_url, json,
        function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                local info = decodeJson(f:read('*a'))
                updatelink = info.updateurl
                updateversion = info.latest
                f:close()
                os.remove(json)
                if updateversion ~= thisScript().version then
                    lua_thread.create(function(prefix)
                    local dlstatus = require('moonloader').download_status
                    local color = -1
                    msg('Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion)
                    wait(250)
                    downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                            print(string.format('Çàãðóæåíî %d èç %d.', p13, p23))
                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
                            msg('Îáíîâëåíèå çàâåðøåíî!')
                            goupdatestatus = true
                            lua_thread.create(function() wait(500) thisScript():reload() end)
                        end
                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                            if goupdatestatus == nil then
                            msg('Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ.')
                            update = false
                            end
                        end
                        end
                    )
                    end, prefix
                    )
                else
                    update = false
                    msg('Îáíîâëåíèå íå òðåáóåòñÿ.')
                end
                end
            else
                msg('Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..url)
                update = false
            end
            end
        end
        )
        while update ~= false do wait(100) end
    end)
end
                                                                                                                                                                                                                                                                                                                                                                                                                           function LoadScript() if thisScript().filename ~= 'Ghetto Helper by VRush.lua' then msg('Íàçâàíèå ñêðèïòà áûëî èçìåíåíî, ñêðèïò îòêëþ÷¸í') msg('Èçìåíèòå íàçâàíèå ñêðèïòà íà "Ghetto Helper by VRush.lua"') thisScript():unload() end end

function main()
    while not isSampAvailable() do wait(200) end
   -- while not sampIsLocalPlayerSpawned() do wait(200) end
    if not doesDirectoryExist('moonloader/config/Ghetto Helper') then createDirectory('moonloader/config/Ghetto Helper') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/Ghetto Helper.ini') then inicfg.save(cfg, 'Ghetto Helper/Ghetto Helper.ini') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/bell.wav') then
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/bell.wav', getWorkingDirectory()..'/config/Ghetto Helper/bell.wav')
    end
    if not doesFileExist(getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt') then 
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/fontawesome-webfont.ttf', getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt')
    end
        imgui.Process = false
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile('https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json', json,
          function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
              if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                  local info = decodeJson(f:read('*a'))
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                end
              end
            end
        end)
        msg('Çàãðóæåí! Àâòîð VRush. Îòêðûòü ìåíþ: /'..cfg.config.CommandAct)         
        if cfg.config.AutoUpdate == 1 then
            autoupdate("https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
        elseif cfg.config.AutoUpdate == 2 then
            msg('Àâòîîáíîâëåíèå áûëî âûêëþ÷åíî, ïðîâåðüòå îáíîâëåíèå â Ãëàâíîì ìåíþ')
        end
        
        sampRegisterChatCommand('gh', function()
            if cfg.config.mainwin then
                window_v.v = true
            else
                window.v = not window.v
            end
        end)

        sampRegisterChatCommand(cfg.config.CommandAct, function()
            if cfg.config.mainwin then
                window_v.v = true
            else
                window.v = not window.v
            end
        end)

        sampRegisterChatCommand("fu", function(arg)
            if cfg.config.UnInvite then
                if not arg:match('%d+') then
                    sampAddChatMessage(tag..'Ïðàâèëüíûé ââîä: /fu [ID]', -1)
                else
                    id = tonumber(arg)
                    sampSendChat('/uninvite '..arg..' '..u8:decode(cfg.config.UvalText))
                end
            else 
                sampSendChat('/1')
            end
        end)
        
        sampRegisterChatCommand("mb", function(arg)
            if cfg.config.CmdMb then
                sampSendChat('/members')
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("scar", function(arg)
            if cfg.config.SpawnCar then
                sampSendChat('/lmenu')
                scar = true
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("sk", function(arg)
            if cfg.config.Sklad then
                sampSendChat('/lmenu')
                sampSendDialogResponse(1214, 1, 3, -1)
                return false
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("na", function(arg)
            if cfg.config.Nabor then
                lua_thread.create(function()
                    local g = ComboNabor.v + 1
                    msg('Ïðîõîäèò íàáîð â '..bands[g]..  ' Âñåõ æäåì íà ðåñïå!')
                    printStringNow('Nabor', 6000)
                    sampSendChat('/fam Ïðîõîäèò íàáîð â '..bands[g]..  ' Âñåõ æäåì íà ðåñïå!')
                    wait(2500)
                    sampSendChat('/al Ïðîõîäèò íàáîð â '..bands[g]..  ' Âñåõ æäåì íà ðåñïå!')
                    wait(2500)
                    sampProcessChatInput('/vra Ïðîõîäèò íàáîð â '..bands[g]..  ' Âñåõ æäåì íà ðåñïå!')
                end)
            else 
                sampSendChat('/1')
            end
        end)
        sampRegisterChatCommand("cde", function(arg)
            if cfg.config.CmdDe then
                lua_thread.create(function()
                    if arg == '' or arg == nil or arg == 0 then
                        msg('Ââåäèòå êîë-âî ïàòðîí')
                    else
                        ptde = arg
                        sampSendChat('/creategun')
                        wait(100)
                        sampSendDialogResponse(7546, 1, 0, _)
                        wait(100)
                        sampSetCurrentDialogEditboxText(ptde)
                        wait(100)
                        sampCloseCurrentDialogWithButton(1)
                    end
                end)
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("cm4", function(arg)
            if cfg.config.CmdM4 then
                lua_thread.create(function()
                    if arg == '' or arg == nil or arg == 0 then
                        msg('Ââåäèòå êîë-âî ïàòðîí')
                    else
                        ptm4 = arg
                        sampSendChat('/creategun')
                        wait(100)
                        sampSendDialogResponse(7546, 1, 3, _)
                        wait(100)
                        sampSetCurrentDialogEditboxText(ptm4)
                        wait(100)
                        sampCloseCurrentDialogWithButton(1)
                    end
                end)
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("cho", function()
            ogrove,oballas,orifa,ovagos,oaztec,onightwolfs = 0,0,0,0,0,0
            for l = 0, 1004 do
                if sampIsPlayerConnected(l) then
                    if sampGetPlayerColor(l) == clistgrove then 
                        ogrove = ogrove + 1 
                    elseif sampGetPlayerColor(l) == clistballas then 
                        oballas = oballas + 1 
                    elseif sampGetPlayerColor(l) == clistrifa then 
                        orifa = orifa + 1 
                    elseif sampGetPlayerColor(l) == clistvagos then 
                        ovagos = ovagos + 1 
                    elseif sampGetPlayerColor(l) == clistaztec then 
                        oaztec = oaztec + 1 
                    elseif sampGetPlayerColor(l) == clistnightwolfs then 
                        onightwolfs = onightwolfs + 1 
                    end
                end
            end 
            msg('') 
           if cfg.config.OnlineGrove then msg("{009327}Grove Str: {ef3226}"..ogrove) end
           if cfg.config.OnlineBallas then msg("{CC00CC}Ballas: {ef3226}"..oballas) end
           if cfg.config.OnlineVagos then msg("{D1DB1C}Los Santos Vagos: {ef3226}"..ovagos) end
           if cfg.config.OnlineAztec then msg("{00FFE2}Varrios Los Aztecaz: {ef3226}"..oaztec) end
           if cfg.config.OnlineRifa then msg("{6666FF}Rifa: {ef3226}"..orifa) end
           if cfg.config.OnlineNightWolfs then msg("{7F6464}Night Wolfs: {ef3226}"..onightwolfs) end
           msg('') 
        end)
        bool, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        lua_thread.create(statsupdate)
        lua_thread.create(onlineupdate)
        lua_thread.create(drugtimer)
        lua_thread.create(hphud)
        apply_style(cfg.config.Styles)
        local rX, rY = getScreenResolution()
    while true do
        wait(0)
        imgui.Process = window.v or window_v.v
        if cfg.config.SbivBind then
            if isKeyJustPressed(cfg.config.SbivKey) and not sampIsCursorActive() then
                sampSendChat(u8:decode(cfg.config.TextSbiv))
            end
        end
        if cfg.config.DrugTimer then
            if wasKeyPressed(VK_X) and not sampIsCursorActive() then
                hp = getCharHealth(PLAYER_PED)
                if hp < 120 then
                    sampSendChat('/usedrugs 3')
                elseif hp >= 120 and hp < 140 then
                    sampSendChat('/usedrugs 2')
                elseif hp >= 140 then
                    sampSendChat('/usedrugs 1')
                end
                Timer.start, Timer.state = os.clock(), true
            end
        end
        if cfg.config.Invite then
            local result, target = getCharPlayerIsTargeting(playerHandle)
            if result then result, playerid = sampGetPlayerIdByCharHandle(target) end 
            if result and isKeyDown(VK_1) then 
                name = sampGetPlayerNickname(playerid) 
                sampSendChat('/me ïåðåäàë áàíäàíó')
                wait(1000)
                sampSendChat('/invite '..playerid)
                invite = true
                msg('Âû ïðèíÿëè èãðîêà ñ íèêîì: '..name..'  Ðàíã: '..invrank.v)
            end
        end
        if changestatspos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.config.CPX = CPX
            cfg.config.CPY = CPY
            inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
        end
        if isKeyJustPressed(VK_LBUTTON) and changecheckonlinepos then
            changecheckonlinepos = false
            sampToggleCursor(false)
            msg('Ïîçèöèÿ ñîõðàíåíà.')
            window.v = true
        end
        if changecheckonlinepos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.config.OPX = CPX
            cfg.config.OPY = CPY
            inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
        end
        if isKeyJustPressed(VK_LBUTTON) and changestatspos then
            changestatspos = false
            sampToggleCursor(false)
            msg('Ïîçèöèÿ ñîõðàíåíà.')
            window.v = true
        end
    end
end

function saveini(section,value)
    cfg.config[section] = value
    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
end

local msguval = {
    'ïñæ',
    'psj',
    'óâàë',
    'óâàë ïñæ',
    'óâîëüòå',
}

function sampev.onServerMessage(color, text)
    if cfg.config.formuval then
        if text:find('%[F%] .+ (.+)%[(.+)%]: (.+)') then
            local nick, id, textmsg = text:match('%[F%] .+ (.+)%[(.+)%]: (.+)')
            for k, v in ipairs(msguval) do
                if textmsg:lower():find(v) then
                    msg(nick..' Õî÷åò óéòè ïî ñîáñòâåííîìó æåëàíèþ. Íàæìèòå + äëÿ îäîáðåíèÿ èëè - äëÿ îòêàçà.')
                    lasttime = os.time()
                    lasttimes = 0
                    time_out = 5
                    lua_thread.create(function()
                        while lasttimes < time_out do
                            lasttimes = os.time() - lasttime
                            wait(0)
                            printStyledString("PSJ  "..nick..' ' .. time_out - lasttimes .. " WAIT", 1000, 4)
                            if isKeyJustPressed(0xBB) then
                                printStyledString("Accept Form", 1000, 4)
                                sampSendChat('/uninvite '..id..' ÏÑÆ')
                                msg(nick..' Áûë óâîëåí ÏÑÆ.',-1)
                                break
                            end
                            if isKeyJustPressed(0xBD) then
                                printStyledString("Skipped Form", 1000, 4)
                                break
                            end
                        end
                    end)
                end
            end
        end
    end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if invite and id == 25640 then
        sampSendDialogResponse(id, 1 , invrank.v - 1, 0)
        msg('Âû ïðèíÿëè èãðîêà ñ íèêîì: '..name..'  Ðàíã: '..invrank.v)
        invite = false
        return false
    end
    if scar and id == 1214 then
        sampSendDialogResponse(1214, 1, 4, -1)
        scar = false
        return false
    end
end

function sampev.onSendGiveDamage(playerId,damage)
	if cfg.config.Bell then
		local audio = loadAudioStream('moonloader/config/Ghetto Helper/bell.wav')
		setAudioStreamState(audio, 1)
	end
    if cfg.config.Stats then
        dmg = tonumber(damage)
        dmg = math.floor(dmg)
        total = total + dmg -- Total Damage
        current = current + dmg -- Current Damage
        local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        result, handle2 = sampGetCharHandleBySampPlayerId(playerId)
        health = sampGetPlayerHealth(playerId)
        if health < damage or health == 0 then
            kills = kills + 1
        end
    end
    if cfg.config.Kill then
        health = sampGetPlayerHealth(playerId)
        if health < damage or health == 0 then
            printStyledString('+KILL', 5000, 7)
        end
    end
end


function sampev.onSendSpawn()
    lua_thread.create(function()
        killss = 0
        if cfg.config.Stats then
            if firstspawn == false then wait(30) firstspawn = true end
            if firstspawn == true then
                deaths = deaths + 1
            end
        end
        local TimeLeft = math.floor(Timer.start + TimerTime - os.clock())
    end)
end

math.round = function(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end
  
function statsupdate()
    while true do wait(0)
        if cfg.config.Stats then
            renderFontDrawText(font,"{ffffff}Kills: {ef3226}"..kills.."\n{ffffff}Deaths: {ef3226}"..deaths.."\n{ffffff}Damage: {ef3226}"..total, cfg.config.CPX, cfg.config.CPY,0xffffffff)
        end
    end
end

function hphud()
    while true do wait(0)
        if cfg.config.HPHud then
            if not sampTextdrawIsExists(500) and sampIsLocalPlayerSpawned() then
                sampTextdrawCreate(500, "_", 569, 66.9)
            end
            sampTextdrawSetLetterSizeAndColor(500, 0.29, 0.9, 4294967295.0)
            sampTextdrawSetPos(500, 569.2, 66.9)
            sampTextdrawSetStyle(500, 3)
            sampTextdrawSetAlign(500, 569)
            sampTextdrawSetOutlineColor(500, 1, 4278190080.0)
            sampTextdrawSetString(500, "" .. getCharHealth(PLAYER_PED))
        elseif not cfg.config.HPHud then
            sampTextdrawDelete(500)
        end
    end
end

function drugtimer()
    while true do wait(0)
        if cfg.config.DrugTimer then
            if Timer.state then
                local TimeLeft = math.floor(Timer.start + TimerTime - os.clock())
                local rX, rY = getScreenResolution()
                renderFontDrawText(fonts,TimeLeft..'s', rX/1.05, rY/6.65, 0xFFFFFFFF, 0x90000000)              
                if TimeLeft < 1 then
                    Timer.state = false               
                end
            else
                local rX, rY = getScreenResolution()
                renderFontDrawText(fonts,'Use', rX/1.05, rY/6.65, 0xFFFFFFFF, 0x90000000) 
            end
        end
    end
end

function onlineupdate()
    while true do wait(0)
        if cfg.config.CheckOnline then
        renderFontDrawText(font, (cfg.config.OnlineGrove and "{009327}Grove Str: {ef3226}"..ogrove or '')..(cfg.config.OnlineBallas and "\n{CC00CC}Ballas: {ef3226}"..oballas or '')..(cfg.config.OnlineVagos and "\n{D1DB1C}Los Santos Vagos: {ef3226}"..ovagos or '')..(cfg.config.OnlineAztec and "\n{00FFE2}Varrios Los Aztecaz: {ef3226}"..oaztec or '')..(cfg.config.OnlineRifa and "\n{6666FF}Rifa: {ef3226}"..orifa or '')..(cfg.config.OnlineNightWolfs and "\n{7F6464}Night Wolfs: {ef3226}"..onightwolfs or ''), cfg.config.OPX, cfg.config.OPY,0xffffffff)        
            ogrove,oballas,orifa,ovagos,oaztec,onightwolfs = 0,0,0,0,0,0
            for l = 0, 1004 do
                if sampIsPlayerConnected(l) then
                    if sampGetPlayerColor(l) == clistgrove then 
                        ogrove = ogrove + 1 
                    elseif sampGetPlayerColor(l) == clistballas then 
                        oballas = oballas + 1 
                    elseif sampGetPlayerColor(l) == clistrifa then 
                        orifa = orifa + 1 
                    elseif sampGetPlayerColor(l) == clistvagos then 
                        ovagos = ovagos + 1 
                    elseif sampGetPlayerColor(l) == clistaztec then 
                        oaztec = oaztec + 1 
                    elseif sampGetPlayerColor(l) == clistnightwolfs then 
                        onightwolfs = onightwolfs + 1 
                    end
                end
            end
        end
    end
end

function msg(arg)
    sampAddChatMessage('{FFFFFF}[{5d2d89}Ghetto Helper{FFFFFF}]{5d2d89}: {FFFFFF}'..arg, -1)
end

function imgui.Ques(text)
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.TextUnformatted(u8(text))
        imgui.EndTooltip()
    end
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end
        end
    end

    render_text(text)
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), name)
    end
    return resultBtn
end

function apply_style(id)
    if id == 0 then -- çåëåíàÿ
        imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		style.WindowRounding = 10
		style.ChildWindowRounding = 10
		style.FrameRounding = 6.0

		style.ItemSpacing = imgui.ImVec2(3.0, 3.0)
		style.ItemInnerSpacing = imgui.ImVec2(3.0, 3.0)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 17.0
		style.GrabRounding = 16.0

		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
		colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.TextDisabled]           = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
		colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
		colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
		colors[clr.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
		colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
		colors[clr.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
		colors[clr.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
		colors[clr.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
		colors[clr.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
		colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
		colors[clr.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
		colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
		colors[clr.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
		colors[clr.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
		colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
		colors[clr.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
		colors[clr.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
		colors[clr.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
		colors[clr.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
		colors[clr.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
		colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
		colors[clr.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[clr.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
		colors[clr.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
		colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
		colors[clr.CloseButton]            = ImVec4(0.00, 0.82, 0.39, 1.00)
		colors[clr.CloseButtonHovered]     = ImVec4(0.00, 0.88, 0.42, 1.00)
		colors[clr.CloseButtonActive]      = ImVec4(0.00, 1.00, 0.48, 1.00)
		colors[clr.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
		colors[clr.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
		colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
		colors[clr.ModalWindowDarkening]   = ImVec4(0.17, 0.17, 0.17, 0.48)
    elseif id == 1 then -- êðàñíàÿ
        imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		style.WindowRounding = 10
		style.ChildWindowRounding = 10
		style.FrameRounding = 6.0

		style.ItemSpacing = imgui.ImVec2(3.0, 3.0)
		style.ItemInnerSpacing = imgui.ImVec2(3.0, 3.0)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 17.0
		style.GrabRounding = 16.0

		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
		colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00)
		colors[clr.TextDisabled]           = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00)
		colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
		colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.00)
		colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00)
		colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00)
		colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00)
		colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81)
		colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00)
		colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39)
		colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00)
		colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00)
		colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00)
		colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00)
		colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00)
		colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00)
		colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00)
		colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00)
		colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16)
		colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39)
		colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00)
		colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
		colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
		colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00)
		colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00)
		colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00)
		colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60)
    elseif id == 2 then -- ôèîëåòîâàÿ
        imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		style.WindowRounding = 10
		style.ChildWindowRounding = 10
		style.FrameRounding = 6.0

		style.ItemSpacing = imgui.ImVec2(3.0, 3.0)
		style.ItemInnerSpacing = imgui.ImVec2(3.0, 3.0)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 17.0
		style.GrabRounding = 16.0

		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
		colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00)
		colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00)
		colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90)
		colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30)
		colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00)
		colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68)
		colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45)
		colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35)
		colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57)
		colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00)
		colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31)
		colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00)
		colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00)
		colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24)
		colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44)
		colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86)
		colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00)
		colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76)
		colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86)
		colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20)
		colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75)
		colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59)
		colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00)
		colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63)
		colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43)
		colors[clr.TextDisabled]          = ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35)
    elseif id == 3 then -- âèøíåâàÿ
        imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		style.WindowRounding = 10
		style.ChildWindowRounding = 10
		style.FrameRounding = 6.0

		style.ItemSpacing = imgui.ImVec2(3.0, 3.0)
		style.ItemInnerSpacing = imgui.ImVec2(3.0, 3.0)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 17.0
		style.GrabRounding = 16.0

		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
		colors[clr.Text]                  = ImVec4(0.86, 0.93, 0.89, 0.78)
		colors[clr.TextDisabled]          = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.WindowBg]              = ImVec4(0.13, 0.14, 0.17, 1.00)
		colors[clr.ChildWindowBg]         = ImVec4(0.20, 0.22, 0.27, 0.58)
		colors[clr.PopupBg]               = ImVec4(0.20, 0.22, 0.27, 0.90)
		colors[clr.Border]                = ImVec4(0.31, 0.31, 1.00, 0.00)
		colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]               = ImVec4(0.20, 0.22, 0.27, 1.00)
		colors[clr.FrameBgHovered]        = ImVec4(0.46, 0.20, 0.30, 0.78)
		colors[clr.FrameBgActive]         = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.TitleBg]               = ImVec4(0.23, 0.20, 0.27, 1.00)
		colors[clr.TitleBgActive]         = ImVec4(0.50, 0.08, 0.26, 1.00)
		colors[clr.TitleBgCollapsed]      = ImVec4(0.20, 0.20, 0.27, 0.75)
		colors[clr.MenuBarBg]             = ImVec4(0.20, 0.22, 0.27, 0.47)
		colors[clr.ScrollbarBg]           = ImVec4(0.20, 0.22, 0.27, 1.00)
		colors[clr.ScrollbarGrab]         = ImVec4(0.09, 0.15, 0.10, 1.00)
		colors[clr.ScrollbarGrabHovered]  = ImVec4(0.46, 0.20, 0.30, 0.78)
		colors[clr.ScrollbarGrabActive]   = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.CheckMark]             = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.SliderGrab]            = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.SliderGrabActive]      = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.Button]                = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.ButtonHovered]         = ImVec4(0.46, 0.20, 0.30, 0.86)
		colors[clr.ButtonActive]          = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.Header]                = ImVec4(0.46, 0.20, 0.30, 0.76)
		colors[clr.HeaderHovered]         = ImVec4(0.46, 0.20, 0.30, 0.86)
		colors[clr.HeaderActive]          = ImVec4(0.50, 0.08, 0.26, 1.00)
		colors[clr.ResizeGrip]            = ImVec4(0.47, 0.77, 0.83, 0.04)
		colors[clr.ResizeGripHovered]     = ImVec4(0.46, 0.20, 0.30, 0.78)
		colors[clr.ResizeGripActive]      = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.PlotLines]             = ImVec4(0.86, 0.93, 0.89, 0.63)
		colors[clr.PlotLinesHovered]      = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.PlotHistogram]         = ImVec4(0.86, 0.93, 0.89, 0.63)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.46, 0.20, 0.30, 1.00)
		colors[clr.TextSelectedBg]        = ImVec4(0.46, 0.20, 0.30, 0.43)
		colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.22, 0.27, 0.73)
		colors[clr.CloseButton]           = ImVec4(0.20, 0.22, 0.27, 1.00)
		colors[clr.CloseButtonHovered]    = ImVec4(0.46, 0.20, 0.30, 0.78)
		colors[clr.CloseButtonActive]     = ImVec4(0.46, 0.20, 0.30, 1.00)
    end
end

function onScriptTerminate(Script) 
    if not reload then
        if Script == thisScript() then
            lua_thread.create(function()
                msg('Ñêðèïò êðàøíóëñÿ/âûëåòåë, ñîîáùèòå î ïðîáëåìå ñîçäàòåëþ ñêðèïòà')
                msg('Åãî ÂÊ - https://vk.com/veni_rush')
            end)
        end
    end
end


function isKeysDown(key, state)
    if state == nil then
        state = false
    end
    
    if key[1] == nil then
        return false
    end
    
    local result = false
    slot4 = #key < 2 and tonumber(key[1]) or tonumber(key[2])
    
    if #key < 2 then
    if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
        if wasKeyPressed(slot4) and not state then
            result = true
        elseif isKeyDown(slot4) and state then
            result = true
        end
    end
    elseif isKeyDown(tonumber(key[1])) and not wasKeyReleased(tonumber(key[1])) then
    if wasKeyPressed(slot4) and not state then
        result = true
    elseif isKeyDown(slot4) and state then
        result = true
        end
    end
    
    if nextLockKey == key then
        if state and not wasKeyReleased(slot4) then
            result = false
        else
            result = false
            nextLockKey = ""
        end
    end
    
    return result
end
