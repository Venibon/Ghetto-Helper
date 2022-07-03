script_name("Ghetto Helper by VRush")
script_version("1.4")
script_author('VRush')

--==--libs--==--
require 'moonloader'
local imgui = require 'imgui'
local imadd = require 'imgui_addons'
imgui.ToggleButton = require('imgui_addons').ToggleButton
local inicfg = require "inicfg"
local sampev = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local font = renderCreateFont("Arial", 11, 9)
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local fa = require 'faIcons'


local cfg = inicfg.load({
   config = {
      SbivBind = false,
      DrugTimer = false,
      Bell = false,
      mainwin = true,
      Styles = 0,
      Kill = false,
      CmdMb = false,
      Invite = false,
      InvRank = 1,
      UnInvite = false,
      UvalText = u8'Выселен.',
      SpawnCar = false,
      NaborBang = 0,
      Nabor = false,
      Stats = false,
      CPX = 13,
      CPY = 992,
      HPHud = false,
      Sklad = false,
      CmdMb = false,
      CmdM4 = false,
      CmdDe = false,
      CheckOnline = false,
      OPX = 13,
      OPY = 992,
      fb_pal1 = 255,
      fb_pal2 = 255,
      fb_pal3 = 255,
      colorfb = 0xFFFFFF,
      ColorFb = false,
      NaborText = u8'',
      AutoUpdate = 1,
   }
}, "Ghetto Helper/Ghetto Helper.ini")



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
local checkchangecolorfb = imgui.ImBool(cfg.config.ColorFb)
local nabortext = imgui.ImBuffer(cfg.config.NaborText,225)
local radioautoupdate = imgui.ImInt(cfg.config.AutoUpdate)
local cmdmb = imgui.ImBool(cfg.config.CmdMb)
local cmdde = imgui.ImBool(cfg.config.CmdDe)
local cmdm4 = imgui.ImBool(cfg.config.CmdM4)

--==--Local--==--
local Timer = {state = false, start = 0, time = 8}
local menu = 1
local menun = 'Главная'
local styles = {
    u8'Синяя тема',
    u8'Зеленая тема',
    u8'Розовая тема',
    u8'Оранджевая тема'
}
local bands = {
    u8'Не указано.',
    u8'Grove',
    u8'Ballas',
    u8'Aztec',
    u8'Rifa',
    u8'Vagos',
    u8'Night Wolfs',
}
local kills = 0
local id = cfg.config.Styles
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
local ogrove = 0
local oballas = 0 
local orifa = 0
local ovagos = 0 
local oaztec = 0
local onightwolfs = 0
local fa_font = nil


function apply_style(id)
    if id == 0 then
        local style = imgui.GetStyle()
        local clrs = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        style.Alpha = 1
        style.ChildWindowRounding = 15
        style.WindowRounding = 15
        style.GrabRounding = 0
        style.GrabMinSize = 12
        style.FrameRounding = 15
        clrs[clr.Text] = ImVec4(1, 1, 1, 1)
        clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
        clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ChildWindowBg] = ImVec4(9.9998999303352e-07, 9.9999613212276e-07, 9.9999999747524e-07, 0)
        clrs[clr.PopupBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.Border] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.BorderShadow] = ImVec4(9.9999999747524e-07, 9.9998999303352e-07, 9.9998999303352e-07, 0)
        clrs[clr.FrameBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.FrameBgHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.FrameBgActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.TitleBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.TitleBgActive] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.TitleBgCollapsed] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.MenuBarBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.ScrollbarBg] = ImVec4(0.14883691072464, 0.14883720874786, 0.14883571863174, 1)
        clrs[clr.ScrollbarGrab] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.ScrollbarGrabHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.ScrollbarGrabActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.ComboBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
        clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
        clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
        clrs[clr.Button] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.ButtonHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.ButtonActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.Header] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.HeaderHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.HeaderActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.Separator] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.SeparatorHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.SeparatorActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.ResizeGrip] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
        clrs[clr.ResizeGripHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
        clrs[clr.ResizeGripActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
        clrs[clr.CloseButton] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 0.88235294818878)
        clrs[clr.CloseButtonHovered] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 1)
        clrs[clr.CloseButtonActive] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 0.60784316062927)
        clrs[clr.PlotLines] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
        clrs[clr.PlotLinesHovered] = ImVec4(1, 0.99999779462814, 0.99998998641968, 1)
        clrs[clr.PlotHistogram] = ImVec4(1, 0.99999779462814, 0.99998998641968, 1)
        clrs[clr.PlotHistogramHovered] = ImVec4(1, 0.9999960064888, 0.99998998641968, 1)
        clrs[clr.TextSelectedBg] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 0.34999999403954)
        clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
    elseif id == 1 then
        local style = imgui.GetStyle()
        local clrs = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        style.Alpha = 1
        style.ChildWindowRounding = 15
        style.WindowRounding = 15
        style.GrabRounding = 0
        style.GrabMinSize = 12
        style.FrameRounding = 15
        clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
        clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
        clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
        clrs[clr.PopupBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.Border] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.BorderShadow] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.FrameBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
        clrs[clr.FrameBgHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.58823531866074)
        clrs[clr.FrameBgActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.39215686917305)
        clrs[clr.TitleBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.82352942228317)
        clrs[clr.TitleBgActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.TitleBgCollapsed] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.66666668653488)
        clrs[clr.MenuBarBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ScrollbarGrab] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.ScrollbarGrabHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
        clrs[clr.ScrollbarGrabActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.58823531866074)
        clrs[clr.ComboBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
        clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
        clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
        clrs[clr.Button] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.ButtonHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
        clrs[clr.ButtonActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
        clrs[clr.Header] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.HeaderHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
        clrs[clr.HeaderActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
        clrs[clr.Separator] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.SeparatorHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.SeparatorActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.ResizeGrip] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.ResizeGripHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
        clrs[clr.ResizeGripActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
        clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
        clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
        clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
        clrs[clr.PlotLines] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.PlotLinesHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.PlotHistogram] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.PlotHistogramHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
        clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
        clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
    elseif id == 2 then
        local style = imgui.GetStyle()
        local clrs = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        style.Alpha = 1
        style.ChildWindowRounding = 15
        style.WindowRounding = 15
        style.GrabRounding = 0
        style.GrabMinSize = 12
        style.FrameRounding = 15
        clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
        clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
        clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
        clrs[clr.PopupBg] = ImVec4(0.70588237047195, 0.011764694936574, 0.37980872392654, 1)
        clrs[clr.Border] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.BorderShadow] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.FrameBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
        clrs[clr.FrameBgHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.58823531866074)
        clrs[clr.FrameBgActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.39215686917305)
        clrs[clr.TitleBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.82352942228317)
        clrs[clr.TitleBgActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.TitleBgCollapsed] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.66666668653488)
        clrs[clr.MenuBarBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ScrollbarGrab] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.ScrollbarGrabHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
        clrs[clr.ScrollbarGrabActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.58823531866074)
        clrs[clr.ComboBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
        clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
        clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
        clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
        clrs[clr.Button] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.ButtonHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
        clrs[clr.ButtonActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
        clrs[clr.Header] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.HeaderHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
        clrs[clr.HeaderActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
        clrs[clr.Separator] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.SeparatorHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.SeparatorActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.ResizeGrip] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.ResizeGripHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
        clrs[clr.ResizeGripActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
        clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
        clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
        clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
        clrs[clr.PlotLines] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.PlotLinesHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.PlotHistogram] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.PlotHistogramHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
        clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
        clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
    elseif id == 3 then
        local style = imgui.GetStyle()
        local clrs = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        style.Alpha = 1
        style.ChildWindowRounding = 15
        style.WindowRounding = 15
        style.GrabRounding = 0
        style.GrabMinSize = 12
        style.FrameRounding = 15
        clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
        clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
        clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
        clrs[clr.PopupBg] = ImVec4(0.85116279125214, 0.59383445978165, 0, 1)
        clrs[clr.Border] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.BorderShadow] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.FrameBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
        clrs[clr.FrameBgHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.58823531866074)
        clrs[clr.FrameBgActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.39215686917305)
        clrs[clr.TitleBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.82352942228317)
        clrs[clr.TitleBgActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.TitleBgCollapsed] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.66666668653488)
        clrs[clr.MenuBarBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
        clrs[clr.ScrollbarGrab] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.ScrollbarGrabHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
        clrs[clr.ScrollbarGrabActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.58823531866074)
        clrs[clr.ComboBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
        clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
        clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
        clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
        clrs[clr.Button] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.ButtonHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
        clrs[clr.ButtonActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
        clrs[clr.Header] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.HeaderHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
        clrs[clr.HeaderActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
        clrs[clr.Separator] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.SeparatorHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.SeparatorActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.ResizeGrip] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.ResizeGripHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
        clrs[clr.ResizeGripActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
        clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
        clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
        clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
        clrs[clr.PlotLines] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.PlotLinesHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.PlotHistogram] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.PlotHistogramHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
        clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
        clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
    end
end

local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

function imgui.OnDrawFrame()
    if window.v then
        imgui.SetNextWindowPos(imgui.ImVec2(350.0,300.0), imgui.Cond.FirstUseEver)
        imgui.Begin('Ghetto Helper by VRush | '..u8(menun), window, imgui.WindowFlags.AlwaysAutoResize)
        imgui.BeginChild('##left', imgui.ImVec2(150, 300), true)
        if imgui.Button(fa.ICON_DESKTOP..u8' Главная', imgui.ImVec2(-1, 25)) then
            menu = 1
            menun = 'Главная'
        end
        if imgui.Button(fa.ICON_BARS..u8' Функции', imgui.ImVec2(-1, 25)) then
            menu = 2
            menun = 'Функции'
        end
        if menu == 3 or menu == 2 then
            if imgui.Button(fa.ICON_ID_CARD..u8' Для 9+ рангов', imgui.ImVec2(-1, 25)) then
                menu = 3
                menun = 'Для 9+ рангов'
            end
        end
        if imgui.Button(fa.ICON_TERMINAL..u8' Команды', imgui.ImVec2(-1, 25)) then
            menu = 4
            menun = 'Команды'
        end
        if imgui.Button(fa.ICON_COGS..u8' Настройки', imgui.ImVec2(-1, 25)) then
            menu = 5
            menun = 'Настройки'
        end
        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginChild('##right', imgui.ImVec2(500, 300), true)
        if menu == 1 then
            imgui.Text(u8'Привет, это Ghetto Helper by VRush')
            imgui.Text(u8'Скрипт создан для упрощения игры в гетто или на каптах')
            imgui.Text(u8'Описание функций вы можете посмотреть наведя курсор\nна серый текст (?) возле переключателя функции')
            imgui.Text(u8'Автор этого скрипта VRush')
            imgui.Link("https://www.blast.hk/members/415848/",u8'Мой бластхак')
            imgui.Link("https://www.blast.hk/threads/138165/",u8'Тема на Blast.hk')
            imgui.TextColoredRGB('Спасибо за пользование {525497}Ghetto Helper{FFFFFF})')
            imgui.Text(u8'Текущая версия: '..thisScript().version..u8' Последняя версия для обновления '..updateversion)
            if updateversion ~= thisScript().version then 
                imgui.Text(u8'Требуется обновление!')
                imgui.SameLine()
                if imgui.Button(u8'Проверить обновление') then 
                    autoupdate("https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
                end
            else 
                imgui.Text(u8'Обновление не требуется')
                imgui.SameLine() 
                if imgui.Button(u8'Проверить обновление') then 
                    autoupdate("https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
                end
            end
        end
        if menu == 2 then
            imgui.Text(u8'Сбив на Z')
            imgui.SameLine()
            imgui.Ques('При нажатии на Z в чат будет отправляться пустое сообщение.')
            imgui.SameLine()
            if imgui.ToggleButton('##Sbiv', checksbiv) then
                cfg.config.SbivBind = checksbiv.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'DrugTimer')
            imgui.SameLine()
            imgui.Ques('При нажатии на Х будет использоватся нарко и запускаться таймер на экране.')
            imgui.SameLine()
            if imgui.ToggleButton('##DrugTimer', checkdtimer) then
                cfg.config.DrugTimer = checkdtimer.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Колокольчик')
            imgui.SameLine()
            imgui.Ques('При нанесении урона, будет проигрыватся звук.')
            imgui.SameLine()
            if imgui.ToggleButton('##bell', checkbell) then
                cfg.config.Bell = checkbell.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Kill State')
            imgui.SameLine()
            imgui.Ques('Надпись +kill при убийстве')
            imgui.SameLine()
            if imgui.ToggleButton('##kill', checkkill) then
                cfg.config.Kill = checkkill.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Capt Stats')
            imgui.SameLine()
            imgui.Ques('Ваша статистика капт в слева под радаром')
            imgui.SameLine()
            if imgui.ToggleButton('##stats', checkstats) then
                cfg.config.Stats = checkstats.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if imgui.Button(u8'Изменить позицию') then 
                changestatspos = true             
                msg('Нажмите ЛКМ чтобы сохранить позицию.') 
                window.v = false
            end
            imgui.Text(u8'Check Online')
            imgui.SameLine()
            imgui.Ques('Кол-во участников банд у вас на экране')
            imgui.SameLine()
            if imgui.ToggleButton('##checkonline', checkonline) then
                cfg.config.CheckOnline = checkonline.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if imgui.Button(u8'Изменить пoзицию') then 
                changecheckonlinepos = true             
                msg('Нажмите ЛКМ чтобы сохранить позицию.') 
                window.v = false
            end
            if imgui.Button(u8'Обновить список.') then
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
            imgui.Text(u8"Сменина цвет фракционного чата")
            imgui.SameLine()
            if imgui.ToggleButton("##check6", checkchangecolorfb) then
                cfg.config.ColorFb = checkchangecolorfb.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            --if imgui.ColorEdit3("##colorfb", fb_pal) then
            --    local clr = join_argb(0, fb_pal.v[3] * 255, fb_pal.v[2] * 255, fb_pal.v[1] * 255)
            --    local r,g,b = fb_pal.v[3] * 255, fb_pal.v[2] * 255, fb_pal.v[1] * 255
            --    cfg.config.colorfb = ("0xFF%06X"):format(clr)
            --    cfg.config.fb_pal1 = r
            --    cfg.config.fb_pal2 = g
            --    cfg.config.fb_pal3 = b
            --    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            --end
        end
        if menu == 3 then
            imgui.PushItemWidth(82.5)
            imgui.Text(u8'Быстрый инвайт')
            imgui.SameLine()
            imgui.Ques('Автоматически будет отправлять инвайт с РП отыгровкой. Активация: ПКМ + 1')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##inv', checkinvite) then
                cfg.config.Invite = checkinvite.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if cfg.config.Invite then
                if imgui.InputInt(u8'Ранг при инвайте', invrank) then
                    cfg.config.InvRank = invrank.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
            end
            if invrank.v <= 0 or invrank.v >= 9 then
                invrank.v = 1
            end
            imgui.PushItemWidth(120)
            imgui.Text(u8'Быстрое увольнение')
            imgui.SameLine()
            imgui.Ques('Быстрое увольнение члена банды. Активация: /fu [ID]')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##uval', checkuninvite) then
                cfg.config.UnInvite = checkuninvite.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if cfg.config.UnInvite then
                if imgui.InputText(u8'Причина увольнения', uvaltext) then
                    cfg.config.UnInviteText = uvaltext.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
            end
            imgui.Text(u8'Быстрый спавн каров')
            imgui.SameLine()
            imgui.Ques('Быстрый спавн каров фракции /scar')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##scar', checkspawncar) then
                cfg.config.SpawnCar = checkspawncar.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Быстрое открытие склада')
            imgui.SameLine()
            imgui.Ques('Быстрое открытие складав фракции /sk')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##sklad', checksklad) then
                cfg.config.Sklad = checksklad.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'Объявления о наборе')
            imgui.SameLine()
            imgui.Ques('Быстрая рассылка в /vr /fam /al о наборе во фракцию при вводе команды /na')
            imgui.SameLine()
            if imgui.ToggleButton(u8'##nabor', checknabor) then
                cfg.config.Nabor = checknabor.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            if cfg.config.Nabor then
            imgui.PushItemWidth(130)
                if imgui.Combo('', ComboNabor, bands) then
                    cfg.config.NaborBang = ComboNabor.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.PushItemWidth(120)
                if imgui.InputText(u8'Дополнительный текст', nabortext) then
                    cfg.config.NaborText = nabortext.v
                    inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                end
                imgui.SameLine()
                imgui.Ques('Например "ЗП 180к" или "Выдаем премии" тут думайте сами.')
            end
        end
        if menu == 4 then
            imgui.Text(u8'/mb') 
            imgui.SameLine()
            imgui.Ques('Быстрое открытие /members')
            imgui.SameLine()
            if imgui.ToggleButton('##mb', cmdmb) then
                cfg.config.CmdMb = cmdmb.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'/de') 
            imgui.SameLine()
            imgui.Ques('Быстрое создание дигла /de [Кол-вл]')
            imgui.SameLine()
            if imgui.ToggleButton('##de', cmdde) then
                cfg.config.CmdDe = cmdde.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.Text(u8'/m4') 
            imgui.SameLine()
            imgui.Ques('Быстрое создание эмки /de [Кол-вл]')
            imgui.SameLine()
            if imgui.ToggleButton('##m4', cmdm4) then
                cfg.config.CmdM4 = cmdm4.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
        end
        if menu == 5 then
            imgui.Text(u8'Смена темы скрипта')
            imgui.SameLine()
            imgui.PushItemWidth(130)
            if imgui.Combo('', ComboStyle, styles) then
                cfg.config.Styles = ComboStyle.v
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
                apply_style(ComboStyle.v)
                i = ComboStyle.v + 1
                msg('Тема была изменена на '..u8:decode(styles[i]))
            end
            imgui.Text(u8'Автообновление')
            if imgui.RadioButton(u8'Включить', radioautoupdate, 1) then
                cfg.config.AutoUpdate = 1
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
            imgui.SameLine()
            if imgui.RadioButton(u8'Выключить', radioautoupdate, 2) then
                cfg.config.AutoUpdate = 2
                inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
            end
        end
        imgui.EndChild()
        if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(-1, 25)) then msg('Скрипт был принудительно перезагружен') thisScript():reload() end
        if imgui.Button(u8'Сбросить настройки', imgui.ImVec2(-1, 25)) then 
            msg('Настройки были сборошены до состояние "По умолчанию"')
            os.remove(getWorkingDirectory()..'/config/Ghetto Helper/Ghetto Helper.ini')
            msg('Скрипт был принудительно перезагружен') 
            window.v = true
            thisScript():reload()
        end
        imgui.End()
    end
    if window_v.v then
        imgui.SetNextWindowPos(imgui.ImVec2(350.0, 250.0), imgui.Cond.FirstUseEver)
        imgui.Begin('Window Title', window_v,imgui.WindowFlags.AlwaysAutoResize)
        imgui.BeginChild('##left', imgui.ImVec2(550, 130), true)
        imgui.TextColoredRGB('Спасибо за пользование {525497}Ghetto Helper')
        imgui.Text(u8'Автор этого скрипта VRush')
        imgui.Link("https://www.blast.hk/members/415848/",u8'Мой бластхак')
        imgui.Link("https://www.blast.hk/threads/138165/",u8'Тема на Blast.hk')
        imgui.TextColoredRGB('{FF0000}В СКРИПТЕ ПРИСУТСТВУЮТ ФУНКЦИИ ЗА КОТОРЫЕ ВЫ МОЖЕТЕ ПОЛУЧИТЬ НАКАЗАНИЕ')
        imgui.TextColoredRGB('{FF0000}ИСПОЛЬЗУЙТЕ НА СВОЙ СТРАХ И РИСК')
        imgui.EndChild()
        if imgui.Button(u8'Закрыть', imgui.ImVec2(-1, 30)) then window_v.v = false window.v = true end
        imgui.TextDisabled(u8'Показывать это окно при запуске')
        imgui.SameLine()
        if imgui.ToggleButton(u8'##ne', nepocaz) then cfg.config.mainwin = nepocaz.v inicfg.save(cfg, 'Ghetto Helper/Ghetto Helper.ini') end
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
                    msg('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                    wait(250)
                    downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                            print(string.format('Загружено %d из %d.', p13, p23))
                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            print('Загрузка обновления завершена.')
                            msg('Обновление завершено!')
                            goupdatestatus = true
                            lua_thread.create(function() wait(500) thisScript():reload() end)
                        end
                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                            if goupdatestatus == nil then
                            msg('Обновление прошло неудачно. Запускаю устаревшую версию.')
                            update = false
                            end
                        end
                        end
                    )
                    end, prefix
                    )
                else
                    update = false
                    msg('Обновление не требуется.')
                end
                end
            else
                msg('Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
                update = false
            end
            end
        end
        )
        while update ~= false do wait(100) end
    end)
end
                                                                                                                                                                                                                                                                                                                                                                                                                           function LoadScript() if thisScript().filename ~= 'Ghetto Helper by VRush.lua' then msg('Название скрипта было изменено, скрипт отключён') msg('Измените название скрипта на "Ghetto Helper by VRush.lua"') thisScript():unload() end end

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
        wait(5000)
        msg('Загружен, автор VRush') 
        if cfg.config.AutoUpdate == 1 then
            autoupdate("https://raw.githubusercontent.com/Venibon/Ghetto-Helper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
        elseif cfg.config.AutoUpdate == 2 then
            msg('Автообновление было выключено, проверьте обновление в Главном меню')
        end
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
        sampRegisterChatCommand('gh', function()
            if cfg.config.mainwin then
                window_v.v = true
            else
                window.v = not window.v
            end
        end)

        sampRegisterChatCommand("fu", function(arg)
            if cfg.config.UnInvite then
                if not arg:match('%d+') then
                    sampAddChatMessage(tag..'Правильный ввод: /fu [ID]', -1)
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
                sampSendDialogResponse(1214, 1, 3, -1)
                return false
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("sk", function(arg)
            if cfg.config.Sklad then
                sampSendChat('/lmenu')
                sampSendDialogResponse(1214, 1, 2, -1)
                return false
            else 
                sampSendChat('/1')
            end
        end)

        sampRegisterChatCommand("na", function(arg)
            if cfg.config.Nabor then
                lua_thread.create(function()
                    g = ComboNabor.v + 1
                    gg = u8:decode(cfg.config.NaborText)
                    msg('Проходит набор в '..bands[g]..'! '..gg..'! Всех ждем на респе!')
                    printStringNow('Nabor', 6000)
                    sampSendChat('/vr Проходит набор в '..bands[g]..'! '..gg..'! Всех ждем на респе!')
                    wait(2000)
                    sampSendChat('/fam Проходит набор в '..bands[g]..'! '..gg..'! Всех ждем на респе!')
                    wait(2000)
                    sampSendChat('/al Проходит набор в '..bands[g]..'! '..gg..'! Всех ждем на респе!')
                    wait(2000)
                    sampSendChat('/vr Проходит набор в '..bands[g]..'! '..gg..'! Всех ждем на респе!')
                end)
            else 
                sampSendChat('/1')
            end
        end)
        sampRegisterChatCommand("de", function(arg)
            if cfg.config.CmdDe then
                lua_thread.create(function()
                    if arg == '' or arg == nil or arg == 0 then
                        msg('Введите кол-во патрон')
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

        sampRegisterChatCommand("m4", function(arg)
            if cfg.config.CmdM4 then
                lua_thread.create(function()
                    if arg == '' or arg == nil or arg == 0 then
                        msg('Введите кол-во патрон')
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
        bool, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        lua_thread.create(statsupdate)
        lua_thread.create(onlineupdate)
    while true do
        wait(0)
        imgui.Process = window.v or window_v.v
        if cfg.config.SbivBind then
            if isKeyJustPressed(VK_Z) and not sampIsCursorActive() then
                sampSendChat(' ')
            end
        end
        if cfg.config.DrugTimer then
            if wasKeyPressed(VK_X) and not sampIsCursorActive() then
                if getCharHealth(PLAYER_PED) < 150 then
                    sampSendChat('/usedrugs 3')
                    Timer.start, Timer.state = os.clock(), true
                end
            end
            if Timer.state then
                local TimeLeft = math.floor(Timer.start + Timer.time - os.clock())
                printStringNow('~r~'..TimeLeft..'s', 1000)               
                if TimeLeft < 1 then
                    printStringNow('~g~use', 1000)
                    Timer.state = false               
                end
            end
        end
        if cfg.config.Invite then
            local result, target = getCharPlayerIsTargeting(playerHandle)
            if result then result, playerid = sampGetPlayerIdByCharHandle(target) end 
            if result and isKeyDown(VK_1) then 
                name = sampGetPlayerNickname(playerid) 
                sampSendChat('/me передал бандану')
                wait(1000)
                sampSendChat('/invite '..playerid)
                wait(3000)
                sampSendChat('/giverank '..playerid..' '..invrank.v, -1)
                msg('Вы приняли игрока с ником: '..name..' | Ранг: '..invrank.v)
            end
        end
        if changestatspos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.config.CPX = CPX
            cfg.config.CPY = CPY
            inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
        end
        if isKeyJustPressed(VK_LBUTTON) and changestatspos or changecheckonlinepos then
            changestatspos = false
            sampToggleCursor(false)
            msg('Позиция сохранена.')
            window.v = true
        end
        if changecheckonlinepos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.config.OPX = CPX
            cfg.config.OPY = CPY
            inicfg.save(cfg,'Ghetto Helper/Ghetto Helper.ini')
        end
        if isKeyJustPressed(VK_LBUTTON) and changecheckonlinepos then
            changecheckonlinepos = false
            sampToggleCursor(false)
            msg('Позиция сохранена.')
            window.v = true
        end
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
            ratio = kills / deaths
            ratio = math.round(ratio,2)
        end
    end
end

function sampev.onSendSpawn()
    kills = 0
    if cfg.config.Stats then
        current = 0 -- Reset Current Damage
        if firstspawn == false then firstspawn = true end
        if firstspawn == true then
            deaths = deaths + 1
            ratio = kills / deaths
            ratio = math.round(ratio,2)
        end
    end
end

function sampev.onPlayerDeathNotification(killer, killed, reason)
    if cfg.config.Kill then
        if killer == myid then
            kills = kills + 1
            killNotify(kills)
        end
    end
end

function sampev.onServerMessage(color, text)
    if cfg.config.ColorFb then
        if text:find("%[F%] (.+) (%w+_%w+)%[(%d+)%]:(.+)") then
            local rank, nick, id, msg = text:match("%[F%] (.+) (%w+_%w+)%[(%d+)%]:(.+)")
            sampAddChatMessage("[F] " .. rank .. " " .. nick .. "[" .. id .. "]:" .. msg, cfg.config.color_fb)
            return false
        end
    end
end

math.round = function(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end
  
function statsupdate()
    while true do wait(0)
        if cfg.config.Stats then
            renderFontDrawText(font,"{ffffff}Total Damage: {ef3226}"..total.."\n{ffffff}Current Damage: {ef3226}"..current.."\n{ffffff}Kills: {ef3226}"..kills.."\n{ffffff}Deaths: {ef3226}"..deaths.."\n{ffffff}Ratio: {ef3226}"..ratio, cfg.config.CPX, cfg.config.CPY,0xffffffff)
        end
    end
end

--local clistgrove = 0x99009327
--local clistballas = 0x99CC00CC
--local clistrifa = 0x996666FF
--local clistvagos = 0x99D1DB1C
--local clistaztec = 0x9900FFE2
--local clistnightwolfs = 0x807F6464

function onlineupdate()
    while true do wait(0)
        if cfg.config.CheckOnline then
            renderFontDrawText(font,"{009327}Grove Str: {ef3226}"..ogrove.."\n{CC00CC}Ballas: {ef3226}"..oballas.."\n{D1DB1C}Los Santos Vagos: {ef3226}"..ovagos.."\n{00FFE2}Varrios Los Aztecaz: {ef3226}"..oaztec.."\n{6666FF}Rifa: {ef3226}"..orifa.."\n{7F6464}Night Wolds: {ef3226}"..onightwolfs, cfg.config.OPX, cfg.config.OPY,0xffffffff)
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

function killNotify(ks)
    if ks == 1 then printStyledString('~r~+ KILL', 2500, 7) end
    if ks == 2 then printStyledString('~r~DOUBLE KILL', 2500, 7) end
    if ks == 3 then printStyledString('~r~TRIPPLE KILL', 2500, 7) end
    if ks == 4 then printStyledString('~r~QUADRUPLE KILL', 2500, 7) end
    if ks == 5 then printStyledString('~r~MULTI KILL', 2500, 7) end
    if ks == 6 then printStyledString('~r~RAMPAGE', 2500, 7) end
    if ks == 7 then printStyledString('~r~KILLING SPREE', 2500, 7) end
    if ks == 8 then printStyledString('~r~IMPRESSIVE', 2500, 7) end
    if ks == 9 then printStyledString('~r~DOMINATING', 2500, 7) end
    if ks == 10 then printStyledString('~r~HUMILIATING', 2500, 7) end
    if ks == 11 then printStyledString('~r~UNSTOPPABLE', 2500, 7) end
    if ks == 12 then printStyledString('~r~COMBO WHORE', 2500, 7) end
    if ks == 13 then printStyledString('~r~MEGA KILL', 2500, 7) end
    if ks == 14 then printStyledString('~r~RIDICULOUS KILL', 2500, 7) end
    if ks == 15 then printStyledString('~r~ULTRA KILL', 2500, 7) end
    if ks == 16 then printStyledString('~r~EAGLE EYE', 2500, 7) end
    if ks == 17 then printStyledString('~r~OWNAGE', 2500, 7) end
    if ks == 18 then printStyledString('~r~LUDICROUS KILL', 2500, 7) end
    if ks == 19 then printStyledString('~r~HEAD HUNTER', 2500, 7) end
    if ks == 20 then printStyledString('~r~WICKED SICK', 2500, 7) end
    if ks == 21 then printStyledString('~r~MONSTER KILL', 2500, 7) end
    if ks == 22 then printStyledString('~r~HATTRICK', 2500, 7) end
    if ks == 23 then printStyledString('~r~HOLY SHIT', 2500, 7) end
    if ks == 24 then printStyledString('~r~GODLIKE', 2500, 7) kills = 0 end
end

function msg(arg)
    sampAddChatMessage('{FFFFFF}[{525497}Ghetto Helper{FFFFFF}]{525497}: {FFFFFF}'..arg, -1)
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