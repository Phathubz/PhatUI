--[[
  ██████╗ ██╗  ██╗ █████╗ ████████╗    ██╗   ██╗██╗
  Phat UI v3.0  ·  Light Glass
  • Màu sáng, đọc được rõ ràng
  • Sidebar tab nổi bật, có icon + màu active
  • Section layout hài hòa, cân đối
  • Drag chỉ TopBar, 3 nút điều khiển
  • Notification đủ màu đọc được
--]]

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─── Palette (Light Glass) ────────────────────
local C = {
    -- Window layers — sáng hơn nhiều
    WIN     = Color3.fromRGB(28,  32,  48),   -- nền chính
    TOP     = Color3.fromRGB(22,  26,  40),   -- topbar
    SIDE    = Color3.fromRGB(20,  24,  38),   -- sidebar
    SEC     = Color3.fromRGB(36,  42,  62),   -- section card
    ELEM    = Color3.fromRGB(44,  50,  74),   -- button / row
    ELEMH   = Color3.fromRGB(58,  66,  96),   -- hover

    -- Accents
    CYAN    = Color3.fromRGB( 80, 210, 255),
    CYAN2   = Color3.fromRGB( 40, 150, 200),
    PURPLE  = Color3.fromRGB(160,  90, 255),
    GREEN   = Color3.fromRGB( 60, 220, 140),
    RED     = Color3.fromRGB(255,  80, 100),
    AMBER   = Color3.fromRGB(255, 195,  55),
    WHITE   = Color3.fromRGB(255, 255, 255),

    -- Text — sáng rõ
    T1 = Color3.fromRGB(240, 244, 255),   -- primary  (gần trắng)
    T2 = Color3.fromRGB(185, 200, 235),   -- secondary (xanh nhạt sáng)
    T3 = Color3.fromRGB(120, 140, 185),   -- muted

    -- Structure
    DIV  = Color3.fromRGB( 55,  64,  95),
    BOR  = Color3.fromRGB( 70,  82, 120),
}

-- tab accent colours (sidebar)
local TAB_COLORS = {
    Color3.fromRGB( 80,210,255),   -- cyan
    Color3.fromRGB(160, 90,255),   -- purple
    Color3.fromRGB( 60,220,140),   -- green
    Color3.fromRGB(255,195, 55),   -- amber
    Color3.fromRGB(255, 80,100),   -- red
    Color3.fromRGB(255,130, 60),   -- orange
}

-- ─── Helpers ──────────────────────────────────
local function tw(o,p,t,s,d)
    TweenService:Create(o, TweenInfo.new(t or .18,
        s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p):Play()
end

local function mk(cls, parent, props)
    local obj = Instance.new(cls, parent)
    for k,v in pairs(props or {}) do obj[k]=v end
    return obj
end

local function corner(p,r)
    local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c
end
local function stroke(p,col,th,tr)
    local s=Instance.new("UIStroke",p)
    s.Color=col or C.BOR; s.Thickness=th or 1; s.Transparency=tr or 0; return s
end
local function pad(p,t,r,b,l)
    local u=Instance.new("UIPadding",p)
    u.PaddingTop=UDim.new(0,t or 6); u.PaddingRight=UDim.new(0,r or 8)
    u.PaddingBottom=UDim.new(0,b or 6); u.PaddingLeft=UDim.new(0,l or 8)
end
local function vlist(p,px,ha)
    local l=Instance.new("UIListLayout",p)
    l.FillDirection=Enum.FillDirection.Vertical
    l.Padding=UDim.new(0,px or 4)
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment=ha or Enum.HorizontalAlignment.Left
    return l
end
local function hlist(p,px,va)
    local l=Instance.new("UIListLayout",p)
    l.FillDirection=Enum.FillDirection.Horizontal
    l.Padding=UDim.new(0,px or 6)
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.VerticalAlignment=va or Enum.VerticalAlignment.Center
    return l
end
local function hov(b,n,h)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=h},.1) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=n},.14) end)
end

-- ─── Custom TopBar drag ───────────────────────
local function attachDrag(Main, TopBar)
    Main.Draggable = false
    local drag, ds, sp = false, nil, nil
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; ds=i.Position; sp=Main.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

-- ─── Notification ─────────────────────────────
local _notifHolder

local function notify(title, msg, ntype)
    if not _notifHolder then return end
    local accent = ({
        info=C.CYAN, success=C.GREEN, error=C.RED, warn=C.AMBER
    })[ntype or "info"] or C.CYAN

    local card = mk("Frame", _notifHolder, {
        Size=UDim2.new(1,0,0,68),
        BackgroundColor3=Color3.fromRGB(32,37,56),
        BackgroundTransparency=0,
        BorderSizePixel=0,
    })
    corner(card,10)
    stroke(card, accent, 1.5, 0.1)

    -- colour strip
    local strip = mk("Frame", card, {
        Size=UDim2.new(0,4,1,-16), Position=UDim2.new(0,0,0,8),
        BackgroundColor3=accent, BorderSizePixel=0,
    }); corner(strip,2)

    -- type badge
    local badge = mk("TextLabel", card, {
        Size=UDim2.fromOffset(60,16), Position=UDim2.new(0,12,0,8),
        BackgroundColor3=accent, BackgroundTransparency=0.75,
        Text=string.upper(ntype or "info"),
        TextColor3=accent, TextSize=10, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Center,
        BorderSizePixel=0,
    }); corner(badge,4)

    mk("TextLabel", card, {
        Size=UDim2.new(1,-18,0,20), Position=UDim2.new(0,12,0,26),
        BackgroundTransparency=1, Text=title or "",
        TextColor3=C.T1, TextSize=14, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
    })
    mk("TextLabel", card, {
        Size=UDim2.new(1,-18,0,16), Position=UDim2.new(0,12,0,48),
        BackgroundTransparency=1, Text=msg or "",
        TextColor3=C.T2, TextSize=12, Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left,
    })

    card.Position=UDim2.new(1.15,0,0,0)
    tw(card,{Position=UDim2.new(0,0,0,0)},.3,Enum.EasingStyle.Quint)
    task.delay(4,function()
        tw(card,{Position=UDim2.new(1.15,0,0,0)},.25,Enum.EasingStyle.Quint)
        task.delay(.28,function() card:Destroy() end)
    end)
end

-- ═════════════════════════════════════════════
--  CreateWindow
-- ═════════════════════════════════════════════
function Phat:CreateWindow(cfg)
    cfg=cfg or {}
    local W=cfg.Width or 640; local H=cfg.Height or 500
    local SW=cfg.SidebarWidth or 170

    local Window={_tabs={}, Notify=notify}

    local sg=mk("ScreenGui", PlayerGui, {
        Name="PhatUI", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })

    -- Notif holder
    _notifHolder=mk("Frame", sg, {
        Size=UDim2.fromOffset(288,350),
        Position=UDim2.new(1,-302,1,-366),
        BackgroundTransparency=1, ClipsDescendants=true,
    })
    local nl=vlist(_notifHolder,8)
    nl.VerticalAlignment=Enum.VerticalAlignment.Bottom

    -- ── Main ───────────────────────────────────
    local Main=mk("Frame", sg, {
        Name="Main", Size=UDim2.fromOffset(W,H),
        Position=UDim2.fromScale(.5,.5), AnchorPoint=Vector2.new(.5,.5),
        BackgroundColor3=C.WIN, BackgroundTransparency=.04,
        ClipsDescendants=true,
    })
    corner(Main,14)
    stroke(Main, C.BOR, 1.5, 0)

    -- ── TopBar ─────────────────────────────────
    local TopBar=mk("Frame", Main, {
        Size=UDim2.new(1,0,0,50), BackgroundColor3=C.TOP,
        BackgroundTransparency=0, BorderSizePixel=0, ZIndex=5,
    })

    -- gradient accent line bottom
    local aLine=mk("Frame", TopBar, {
        Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=C.CYAN, BorderSizePixel=0, ZIndex=6,
    })
    mk("UIGradient", aLine).Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.CYAN),
        ColorSequenceKeypoint.new(0.5, C.PURPLE),
        ColorSequenceKeypoint.new(1, C.CYAN),
    }

    -- logo dot
    local dot=mk("Frame", TopBar, {
        Size=UDim2.fromOffset(10,10), Position=UDim2.new(0,16,0.5,-5),
        BackgroundColor3=C.CYAN, BorderSizePixel=0, ZIndex=6,
    }); corner(dot,5)

    mk("TextLabel", TopBar, {
        Text=cfg.Title or "PHAT UI",
        Size=UDim2.new(0,280,1,0), Position=UDim2.new(0,34,0,0),
        BackgroundTransparency=1, TextColor3=C.T1,
        TextSize=15, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
    })
    if cfg.Subtitle then
        mk("TextLabel", TopBar, {
            Text=cfg.Subtitle,
            Size=UDim2.new(0,200,0,14), Position=UDim2.new(0,34,1,-18),
            BackgroundTransparency=1, TextColor3=C.CYAN2,
            TextSize=10, Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
        })
    end

    attachDrag(Main, TopBar)

    -- window buttons
    local function wBtn(xOff, sym, nc, hc, tc)
        local b=mk("TextButton", TopBar, {
            Size=UDim2.fromOffset(30,30), Position=UDim2.new(1,xOff,0.5,-15),
            Text=sym, TextSize=14, Font=Enum.Font.GothamBold,
            BackgroundColor3=nc, TextColor3=tc or C.T3,
            BorderSizePixel=0, ZIndex=10,
        }); corner(b,8); hov(b,nc,hc)
        b.MouseEnter:Connect(function() tw(b,{TextColor3=C.WHITE},.1) end)
        b.MouseLeave:Connect(function() tw(b,{TextColor3=tc or C.T3},.12) end)
        return b
    end
    local BClose=wBtn(-14,"✕", Color3.fromRGB(60,25,30), C.RED,    C.RED)
    local BMax  =wBtn(-50,"□", C.ELEM,                   C.ELEMH,  C.T3)
    local BMin  =wBtn(-86,"─", C.ELEM,                   C.ELEMH,  C.T3)

    -- ── Sidebar ────────────────────────────────
    local Sidebar=mk("Frame", Main, {
        Name="Sidebar",
        Size=UDim2.new(0,SW,1,-50), Position=UDim2.new(0,0,0,50),
        BackgroundColor3=C.SIDE, BackgroundTransparency=0,
        BorderSizePixel=0,
    })

    -- divider line sidebar→content
    mk("Frame", Sidebar, {
        Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=C.DIV, BorderSizePixel=0,
    })

    -- sidebar header label
    mk("TextLabel", Sidebar, {
        Text="MENU", Size=UDim2.new(1,-20,0,18), Position=UDim2.new(0,16,0,12),
        BackgroundTransparency=1, TextColor3=C.T3,
        TextSize=10, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
    })

    local tabListFrame=mk("Frame", Sidebar, {
        Size=UDim2.new(1,0,1,-40), Position=UDim2.new(0,0,0,38),
        BackgroundTransparency=1,
    })
    vlist(tabListFrame, 4, Enum.HorizontalAlignment.Center)
    pad(tabListFrame, 4, 0, 8, 0)

    -- ── Content scrolling ──────────────────────
    local Content=mk("ScrollingFrame", Main, {
        Name="Content",
        Size=UDim2.new(1,-SW,1,-50), Position=UDim2.new(0,SW,0,50),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=C.CYAN2,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
    })
    vlist(Content,10)
    pad(Content,12,12,12,12)

    -- ── AddTab ─────────────────────────────────
    local tabIdx=0

    function Window:AddTab(tabcfg)
        tabcfg=tabcfg or {}
        tabIdx=tabIdx+1
        local mi=tabIdx
        local Tab={}
        local accentCol=TAB_COLORS[((mi-1)%#TAB_COLORS)+1]

        -- Sidebar button
        local TBtn=mk("TextButton", tabListFrame, {
            Name="Tab"..mi, Size=UDim2.new(1,-12,0,42),
            BackgroundColor3=C.ELEM, BackgroundTransparency=0.2,
            Text="", BorderSizePixel=0, LayoutOrder=mi,
        }); corner(TBtn,10)

        -- coloured left bar (hidden when inactive)
        local lBar=mk("Frame", TBtn, {
            Size=UDim2.new(0,4,0.6,0), Position=UDim2.new(0,0,0.2,0),
            BackgroundColor3=accentCol, BorderSizePixel=0, Visible=false,
        }); corner(lBar,2)

        -- icon circle
        local icoBG=mk("Frame", TBtn, {
            Size=UDim2.fromOffset(28,28),
            Position=UDim2.new(0,12,0.5,-14),
            BackgroundColor3=accentCol, BackgroundTransparency=0.75,
            BorderSizePixel=0,
        }); corner(icoBG,8)

        mk("TextLabel", icoBG, {
            Text=tabcfg.Icon or "●",
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            TextColor3=accentCol, TextSize=14,
            Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Center,
        })

        -- label
        local tLbl=mk("TextLabel", TBtn, {
            Text=tabcfg.Title or ("Tab "..mi),
            Size=UDim2.new(1,-52,1,0), Position=UDim2.new(0,48,0,0),
            BackgroundTransparency=1,
            TextColor3=C.T2, TextSize=13,
            Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left,
        })

        -- notification dot (optional badge)
        local nDot=mk("Frame", TBtn, {
            Size=UDim2.fromOffset(6,6),
            Position=UDim2.new(1,-16,0.5,-3),
            BackgroundColor3=accentCol, BorderSizePixel=0, Visible=false,
        }); corner(nDot,3)

        -- Page
        local Page=mk("Frame", Content, {
            Name="Page"..mi, Size=UDim2.new(1,0,0,0),
            AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1, Visible=false, LayoutOrder=mi,
        })
        vlist(Page,10)

        local function activate()
            for _,t in ipairs(Window._tabs) do
                t._page.Visible=false
                tw(t._btn,{BackgroundColor3=C.ELEM,BackgroundTransparency=0.2},.14)
                t._lbar.Visible=false
                tw(t._lbl,{TextColor3=C.T2},.14)
            end
            Page.Visible=true
            tw(TBtn,{BackgroundColor3=accentCol,BackgroundTransparency=0.85},.16)
            lBar.Visible=true
            tw(tLbl,{TextColor3=accentCol},.14)
        end

        Tab._page=Page; Tab._btn=TBtn; Tab._lbar=lBar; Tab._lbl=tLbl
        TBtn.MouseButton1Click:Connect(activate)
        hov(TBtn, C.ELEM, C.ELEMH)
        if tabIdx==1 then task.defer(activate) end
        table.insert(Window._tabs, Tab)

        -- ── AddSection ─────────────────────────
        local secIdx=0
        function Tab:AddSection(title)
            secIdx=secIdx+1
            local Sec={}

            -- section card
            local SF=mk("Frame", Page, {
                Name="Sec"..secIdx, Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=C.SEC, BackgroundTransparency=0,
                BorderSizePixel=0, LayoutOrder=secIdx,
            }); corner(SF,12)
            stroke(SF, C.BOR, 1, 0.35)

            -- coloured top border strip
            local topStrip=mk("Frame", SF, {
                Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,0,0),
                BackgroundColor3=accentCol, BorderSizePixel=0,
            })
            mk("UIGradient", topStrip).Color=ColorSequence.new{
                ColorSequenceKeypoint.new(0, accentCol),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(
                    math.clamp(accentCol.R*255+60,0,255),
                    math.clamp(accentCol.G*255+60,0,255),
                    math.clamp(accentCol.B*255+60,0,255)
                )),
            }

            -- section header row
            local hRow=mk("Frame", SF, {
                Size=UDim2.new(1,0,0,36),
                BackgroundTransparency=1,
            })

            -- small color dot
            local sdot=mk("Frame", hRow, {
                Size=UDim2.fromOffset(8,8), Position=UDim2.new(0,14,0.5,-4),
                BackgroundColor3=accentCol, BorderSizePixel=0,
            }); corner(sdot,4)

            mk("TextLabel", hRow, {
                Text=title or "Section",
                Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,28,0,0),
                BackgroundTransparency=1,
                TextColor3=C.T1,             -- section title: gần trắng
                TextSize=13, Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left,
            })

            -- divider
            mk("Frame", SF, {
                Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,0,36),
                BackgroundColor3=C.DIV, BorderSizePixel=0,
            })

            -- inner content frame
            local inner=mk("Frame", SF, {
                Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
            })
            pad(inner, 44, 12, 12, 12)
            vlist(inner, 6)

            local ei=0

            -- ── AddButton ──────────────────────
            function Sec:AddButton(bc)
                bc=bc or {}; ei=ei+1

                local row=mk("Frame", inner, {
                    Size=UDim2.new(1,0,0,38),
                    BackgroundTransparency=1, LayoutOrder=ei,
                })

                local Btn=mk("TextButton", row, {
                    Size=UDim2.new(1,0,1,0),
                    BackgroundColor3=C.ELEM, BackgroundTransparency=0,
                    Text="", BorderSizePixel=0,
                }); corner(Btn,8)
                stroke(Btn, C.BOR, 1, 0.4)

                -- icon strip left
                local btnStrip=mk("Frame", Btn, {
                    Size=UDim2.new(0,3,0.5,0), Position=UDim2.new(0,0,0.25,0),
                    BackgroundColor3=accentCol, BorderSizePixel=0,
                }); corner(btnStrip,2)

                mk("TextLabel", Btn, {
                    Text=bc.Title or "Button",
                    Size=UDim2.new(1,-42,1,0), Position=UDim2.new(0,14,0,0),
                    BackgroundTransparency=1, TextColor3=C.T1,
                    TextSize=13, Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Left,
                })

                local arr=mk("TextLabel", Btn, {
                    Text="›", Size=UDim2.new(0,22,1,0),
                    Position=UDim2.new(1,-24,0,0),
                    BackgroundTransparency=1, TextColor3=C.T3,
                    TextSize=18, Font=Enum.Font.GothamBold,
                })

                hov(Btn, C.ELEM, C.ELEMH)
                Btn.MouseEnter:Connect(function() tw(arr,{TextColor3=accentCol},.1) end)
                Btn.MouseLeave:Connect(function() tw(arr,{TextColor3=C.T3},.12) end)
                Btn.MouseButton1Click:Connect(function()
                    tw(Btn,{BackgroundColor3=accentCol,BackgroundTransparency=0.8},.07)
                    task.delay(.09,function() tw(Btn,{BackgroundColor3=C.ELEM,BackgroundTransparency=0},.2) end)
                    if bc.Callback then pcall(bc.Callback) end
                end)
            end

            -- ── AddToggle ──────────────────────
            function Sec:AddToggle(tc)
                tc=tc or {}; ei=ei+1
                local state=tc.Default or false

                local Row=mk("Frame", inner, {
                    Size=UDim2.new(1,0,0,38),
                    BackgroundColor3=C.ELEM, BackgroundTransparency=0,
                    BorderSizePixel=0, LayoutOrder=ei,
                }); corner(Row,8)
                stroke(Row, C.BOR, 1, 0.4)

                mk("TextLabel", Row, {
                    Text=tc.Title or "Toggle",
                    Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,14,0,0),
                    BackgroundTransparency=1, TextColor3=C.T1,
                    TextSize=13, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left,
                })

                -- state label
                local sLbl=mk("TextLabel", Row, {
                    Text=state and "ON" or "OFF",
                    Size=UDim2.fromOffset(30,38),
                    Position=UDim2.new(1,-88,0,0),
                    BackgroundTransparency=1,
                    TextColor3=state and accentCol or C.T3,
                    TextSize=11, Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Center,
                })

                -- track
                local track=mk("Frame", Row, {
                    Size=UDim2.fromOffset(46,24),
                    Position=UDim2.new(1,-56,0.5,-12),
                    BackgroundColor3=state and accentCol or C.DIV,
                    BorderSizePixel=0,
                }); corner(track,12)
                local tStr=stroke(track, state and accentCol or C.BOR, 1, 0)

                -- knob
                local knob=mk("Frame", track, {
                    Size=UDim2.fromOffset(18,18),
                    Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
                    BackgroundColor3=state and C.WHITE or C.T3,
                    BorderSizePixel=0,
                }); corner(knob,9)

                local function set(v)
                    state=v
                    if v then
                        tw(track,{BackgroundColor3=accentCol},.18)
                        tw(knob,{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=C.WHITE},.2)
                        tStr.Color=accentCol
                        sLbl.Text="ON"; tw(sLbl,{TextColor3=accentCol},.12)
                    else
                        tw(track,{BackgroundColor3=C.DIV},.18)
                        tw(knob,{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=C.T3},.2)
                        tStr.Color=C.BOR
                        sLbl.Text="OFF"; tw(sLbl,{TextColor3=C.T3},.12)
                    end
                    if tc.Callback then pcall(tc.Callback,state) end
                end

                Row.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then set(not state) end
                end)
                hov(Row, C.ELEM, C.ELEMH)
                return {Set=set, Get=function() return state end}
            end

            -- ── AddSlider ──────────────────────
            function Sec:AddSlider(sc)
                sc=sc or {}; ei=ei+1
                local mn,mx=sc.Min or 0, sc.Max or 100
                local val=sc.Default or mn

                local SF2=mk("Frame", inner, {
                    Size=UDim2.new(1,0,0,54),
                    BackgroundColor3=C.ELEM, BackgroundTransparency=0,
                    BorderSizePixel=0, LayoutOrder=ei,
                }); corner(SF2,8)
                stroke(SF2, C.BOR, 1, 0.4)

                -- top row: label + value
                mk("TextLabel", SF2, {
                    Text=sc.Title or "Slider",
                    Size=UDim2.new(1,-60,0,20), Position=UDim2.new(0,14,0,8),
                    BackgroundTransparency=1, TextColor3=C.T1,
                    TextSize=13, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left,
                })
                local vLbl=mk("TextLabel", SF2, {
                    Text=tostring(math.round(val)),
                    Size=UDim2.new(0,50,0,20), Position=UDim2.new(1,-60,0,8),
                    BackgroundTransparency=1, TextColor3=accentCol,
                    TextSize=14, Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Right,
                })

                -- track bg
                local tBG=mk("Frame", SF2, {
                    Size=UDim2.new(1,-28,0,6),
                    Position=UDim2.new(0,14,1,-16),
                    BackgroundColor3=C.DIV, BorderSizePixel=0,
                }); corner(tBG,3)

                local fillPct=(val-mn)/(mx-mn)
                local fillF=mk("Frame", tBG, {
                    Size=UDim2.new(fillPct,0,1,0),
                    BackgroundColor3=accentCol, BorderSizePixel=0,
                }); corner(fillF,3)

                local handleF=mk("Frame", tBG, {
                    Size=UDim2.fromOffset(14,14),
                    Position=UDim2.new(fillPct,-7,0.5,-7),
                    BackgroundColor3=C.WHITE, BorderSizePixel=0,
                }); corner(handleF,7)
                stroke(handleF, accentCol, 2, 0)

                local dragging=false
                local function upd(x)
                    local p=math.clamp((x-tBG.AbsolutePosition.X)/tBG.AbsoluteSize.X,0,1)
                    val=math.round(mn+(mx-mn)*p)
                    fillF.Size=UDim2.new(p,0,1,0)
                    handleF.Position=UDim2.new(p,-7,0.5,-7)
                    vLbl.Text=tostring(val)
                    if sc.Callback then pcall(sc.Callback,val) end
                end
                tBG.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; upd(i.Position.X) end
                end)
                UIS.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
                end)
                return {
                    Get=function() return val end,
                    Set=function(v)
                        v=math.clamp(v,mn,mx); val=v
                        local p=(v-mn)/(mx-mn)
                        tw(fillF,{Size=UDim2.new(p,0,1,0)},.12)
                        tw(handleF,{Position=UDim2.new(p,-7,0.5,-7)},.12)
                        vLbl.Text=tostring(math.round(v))
                    end,
                }
            end

            -- ── AddInput ───────────────────────
            function Sec:AddInput(ic)
                ic=ic or {}; ei=ei+1

                local wrap=mk("Frame", inner, {
                    Size=UDim2.new(1,0,0,58),
                    BackgroundTransparency=1, LayoutOrder=ei,
                })
                mk("TextLabel", wrap, {
                    Text=ic.Title or "Input",
                    Size=UDim2.new(1,0,0,18),
                    BackgroundTransparency=1, TextColor3=C.T2,
                    TextSize=11, Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Left,
                })
                local bg=mk("Frame", wrap, {
                    Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,0,20),
                    BackgroundColor3=C.ELEM, BackgroundTransparency=0,
                    BorderSizePixel=0,
                }); corner(bg,8)
                local iStr=stroke(bg, C.BOR, 1, 0.3)

                local tb=mk("TextBox", bg, {
                    Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1,
                    Text=ic.Default or "",
                    PlaceholderText=ic.Placeholder or "Type here...",
                    TextColor3=C.T1, PlaceholderColor3=C.T3,
                    TextSize=13, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    ClearTextOnFocus=ic.ClearOnFocus~=false,
                })
                tb.Focused:Connect(function() iStr.Color=accentCol end)
                tb.FocusLost:Connect(function(enter)
                    iStr.Color=C.BOR
                    if ic.Callback then pcall(ic.Callback,tb.Text,enter) end
                end)
                return {Get=function() return tb.Text end}
            end

            -- ── AddDropdown ────────────────────
            function Sec:AddDropdown(dc)
                dc=dc or {}; ei=ei+1
                local sel,open=dc.Default,false

                local DDW=mk("Frame", inner, {
                    Size=UDim2.new(1,0,0,38),
                    BackgroundTransparency=1,
                    LayoutOrder=ei, ClipsDescendants=false, ZIndex=20,
                })

                local DBt=mk("TextButton", DDW, {
                    Size=UDim2.new(1,0,1,0),
                    BackgroundColor3=C.ELEM, BackgroundTransparency=0,
                    Text="", BorderSizePixel=0, ZIndex=20,
                }); corner(DBt,8)
                stroke(DBt, C.BOR, 1, 0.4)

                mk("TextLabel", DBt, {
                    Text="▴ ",Size=UDim2.fromOffset(16,38),
                    Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1, TextColor3=accentCol,
                    TextSize=11, Font=Enum.Font.GothamBold, ZIndex=21,
                })

                local dLbl=mk("TextLabel", DBt, {
                    Text=sel or dc.Title or "Select...",
                    Size=UDim2.new(1,-60,1,0), Position=UDim2.new(0,28,0,0),
                    BackgroundTransparency=1,
                    TextColor3=sel and C.T1 or C.T3,
                    TextSize=13, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=21,
                })
                local dArr=mk("TextLabel", DBt, {
                    Text="⌄", Size=UDim2.new(0,24,1,0),
                    Position=UDim2.new(1,-26,0,0),
                    BackgroundTransparency=1, TextColor3=C.T3,
                    TextSize=14, Font=Enum.Font.GothamBold, ZIndex=21,
                })

                local panel=mk("Frame", DDW, {
                    Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,4),
                    BackgroundColor3=C.SEC, BackgroundTransparency=0,
                    BorderSizePixel=0, ClipsDescendants=true, ZIndex=60,
                }); corner(panel,8)
                stroke(panel, accentCol, 1.5, 0.3)

                vlist(panel,2); pad(panel,4,4,4,4)

                local items=dc.Items or {}
                for _,item in ipairs(items) do
                    local opt=mk("TextButton", panel, {
                        Size=UDim2.new(1,0,0,30),
                        Text=item, BackgroundColor3=C.ELEM,
                        TextColor3=C.T1, TextSize=13,
                        Font=Enum.Font.Gotham, BorderSizePixel=0, ZIndex=61,
                    }); corner(opt,6)
                    hov(opt, C.ELEM, C.ELEMH)
                    opt.MouseButton1Click:Connect(function()
                        sel=item; dLbl.Text=item; dLbl.TextColor3=C.T1
                        open=false
                        tw(panel,{Size=UDim2.new(1,0,0,0)},.15)
                        tw(dArr,{Rotation=0},.15)
                        if dc.Callback then pcall(dc.Callback,sel) end
                    end)
                end
                local pH=#items*34+8
                DBt.MouseButton1Click:Connect(function()
                    open=not open
                    tw(panel,{Size=open and UDim2.new(1,0,0,pH) or UDim2.new(1,0,0,0)},.18,Enum.EasingStyle.Quart)
                    tw(dArr,{Rotation=open and 180 or 0},.18)
                end)
                return {
                    Get=function() return sel end,
                    Set=function(v) sel=v; dLbl.Text=v; dLbl.TextColor3=C.T1 end,
                }
            end

            return Sec
        end -- AddSection
        return Tab
    end -- AddTab

    -- ── Window controls ────────────────────────
    local minimized=false; local maximized=false
    local sSize=UDim2.fromOffset(W,H); local sPos=Main.Position

    BMin.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            Content.Visible=false; Sidebar.Visible=false
            tw(Main,{Size=UDim2.fromOffset(W,50)},.22,Enum.EasingStyle.Quart)
        else
            tw(Main,{Size=maximized and UDim2.fromScale(1,1) or sSize},.22,Enum.EasingStyle.Quart)
            task.delay(.12,function() Content.Visible=true; Sidebar.Visible=true end)
        end
    end)

    BMax.MouseButton1Click:Connect(function()
        if minimized then return end
        maximized=not maximized
        if maximized then
            sSize=Main.Size; sPos=Main.Position
            tw(Main,{Size=UDim2.fromScale(1,1),Position=UDim2.fromScale(.5,.5)},.22,Enum.EasingStyle.Quart)
            BMax.Text="❐"
        else
            tw(Main,{Size=sSize,Position=sPos},.22,Enum.EasingStyle.Quart)
            BMax.Text="□"
        end
    end)

    BClose.MouseButton1Click:Connect(function()
        tw(Main,{Size=UDim2.fromOffset(W,0),BackgroundTransparency=1},.2,Enum.EasingStyle.Quart)
        task.delay(.22,function() sg:Destroy() end)
    end)

    -- Entry animation
    Main.BackgroundTransparency=1
    Main.Size=UDim2.fromOffset(W*.85,H*.85)
    tw(Main,{Size=UDim2.fromOffset(W,H),BackgroundTransparency=.04},.3,Enum.EasingStyle.Quint)

    return Window
end

return Phat

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  USAGE EXAMPLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local UI = loadstring(game:HttpGet("URL_HERE"))()

local win = UI:CreateWindow({
    Title    = "PHAT UI",
    Subtitle = "v3.0  ·  Light Glass",
    Width    = 640,
    Height   = 500,
})

-- Mỗi tab tự lấy màu accent riêng (cyan, purple, green, amber...)
local t1 = win:AddTab({ Title = "Combat",   Icon = "⚔" })
local t2 = win:AddTab({ Title = "Player",   Icon = "👤" })
local t3 = win:AddTab({ Title = "Visual",   Icon = "👁" })
local t4 = win:AddTab({ Title = "Settings", Icon = "⚙" })

local s1 = t1:AddSection("General")

s1:AddButton({
    Title    = "Kill Aura",
    Callback = function()
        win:Notify("Kill Aura", "Đã kích hoạt", "success")
    end,
})

local tog = s1:AddToggle({
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v)
        win:Notify("Infinite Jump", v and "Bật" or "Tắt",
                   v and "success" or "warn")
    end,
})

local sl = s1:AddSlider({
    Title    = "Walk Speed",
    Min = 16, Max = 150, Default = 16,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character
        if h then h.Humanoid.WalkSpeed = v end
    end,
})

s1:AddDropdown({
    Title    = "Target Team",
    Items    = { "Red", "Blue", "Green", "All" },
    Callback = function(v) print("Team:", v) end,
})

local s2 = t1:AddSection("Keybinds")
s2:AddInput({
    Title       = "Kill Aura Key",
    Placeholder = "e.g. F1",
    Callback    = function(v) print("Key set:", v) end,
})

-- Notifications
win:Notify("Loaded",   "PhatUI v3.0 sẵn sàng", "info")
win:Notify("Tip",      "Kéo cửa sổ bằng TopBar", "warn")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]
