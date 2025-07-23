-- Luiz Hub V2 - UNIVERSAL SCRIPT PARA XENO / iOS OTIMIZADO
-- Criado por @LuizAgostino com ESP Azul Claro leve, Fly, AirJump, e WalkSpeed ajustável

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Luiz Hub V2"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0, 191, 255)
title.BackgroundTransparency = 1

-- Botão Fechar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

-- Template de botão
local function criarBotao(texto, posY)
    local botao = Instance.new("TextButton", frame)
    botao.Size = UDim2.new(0.9, 0, 0.12, 0)
    botao.Position = UDim2.new(0.05, 0, posY, 0)
    botao.Text = texto
    botao.Font = Enum.Font.Gotham
    botao.TextScaled = true
    botao.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    return botao
end

-- Variáveis
local speed = 16
local flying = false
local espOn = false

-- WalkSpeed Ajustável
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0.05, 0, 0.33, 0)
speedLabel.Size = UDim2.new(0.6, 0, 0.1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed: " .. speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true

local minusBtn = Instance.new("TextButton", frame)
minusBtn.Position = UDim2.new(0.68, 0, 0.33, 0)
minusBtn.Size = UDim2.new(0.12, 0, 0.1, 0)
minusBtn.Text = "−"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local plusBtn = Instance.new("TextButton", frame)
plusBtn.Position = UDim2.new(0.81, 0, 0.33, 0)
plusBtn.Size = UDim2.new(0.12, 0, 0.1, 0)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function updateSpeed()
    pcall(function()
        player.Character.Humanoid.WalkSpeed = speed
    end)
    speedLabel.Text = "WalkSpeed: " .. speed
end

plusBtn.MouseButton1Click:Connect(function()
    speed += 2
    if speed > 100 then speed = 100 end
    updateSpeed()
end)

minusBtn.MouseButton1Click:Connect(function()
    speed -= 2
    if speed < 4 then speed = 4 end
    updateSpeed()
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = speed
end)

-- Fly
local function startFly()
    local char = player.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity", hrp)
    local bg = Instance.new("BodyGyro", hrp)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame

    while flying and bv and bg do
        task.wait()
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
        bg.CFrame = workspace.CurrentCamera.CFrame
    end

    bv:Destroy()
    bg:Destroy()
end

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            coroutine.wrap(startFly)()
        end
    end
end)

local flyBtn = criarBotao("Fly: Tecla F", 0.47)

-- AirJump
local jumping = false
local airJumpEnabled = true

UIS.JumpRequest:Connect(function()
    if airJumpEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ESP
local espBtn = criarBotao("ESP: OFF", 0.61)

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if espOn then
                if not head:FindFirstChild("ESP_TAG") then
                    local gui = Instance.new("BillboardGui", head)
                    gui.Name = "ESP_TAG"
                    gui.Size = UDim2.new(0, 100, 0, 30)
                    gui.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", gui)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = plr.Name
                    label.TextColor3 = Color3.fromRGB(173, 216, 230)
                    label.Font = Enum.Font.GothamBold
                    label.TextScaled = true
                end
            else
                if head:FindFirstChild("ESP_TAG") then
                    head.ESP_TAG:Destroy()
                end
            end
        end
    end
end)

-- Atualizar distância no ESP
game:GetService("RunService").RenderStepped:Connect(function()
    if espOn then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tag = plr.Character.Head:FindFirstChild("ESP_TAG")
                if tag and tag:FindFirstChildOfClass("TextLabel") then
                    local dist = math.floor((player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
                    tag.TextLabel.Text = plr.Name .. " [" .. dist .. "m]"
                end
            end
        end
    end
end)

