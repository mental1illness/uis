--[[
	i coded this in roblox studio so the code may look bad and i cant swear here too
	made by nam (@mental1illness) i dont take commissions
	
	big guy big guy big big guy big guy
	spongebob
	big guys 
	pants ok
	spongebob big guy
	pants ok

]]

local CloneReference    	= cloneref or function(v) return v; end
local CloneFunction     	= clonefunction or function(v) return v; end
local GetCustomAsset		= getcustomasset or function(v) return v; end
local WriteFile			= writefile or function(v) return v; end
local GetHiddenUI           	= gethui or function()
	local LocalPlayer: Player? = game:GetService("Players").LocalPlayer
	return LocalPlayer.PlayerGui
end

local Enum			= Enum

local Rgb               	= CloneFunction(Color3.fromRGB)
local GetService        	= CloneFunction(game.GetService)
local Insert			        = CloneFunction(table.insert)

local Players           	= CloneReference(GetService(game, "Players"))
local RunService        	= CloneReference(GetService(game, "RunService"))
local InputService      	= CloneReference(GetService(game, "UserInputService"))
local HttpService		= CloneReference(GetService(game, "HttpService"))
local TweenService	= CloneReference(GetService(game, "TweenService"))

local IsStudio		= RunService:IsStudio()

local Library = {
	["Flags"]      	= {  };
	["Element"]    = {  };
	["Objects"]	= {  };
	["Font"]       	= nil;
	["FontBold"]   = nil;
	["Theme"]	 = {
		["Accent"] = Rgb(55, 114, 204); -- 55, 114, 204
		["Gradient"] = ColorSequence.new({
			ColorSequenceKeypoint.new(0,     Rgb(21, 21, 21)),
			ColorSequenceKeypoint.new(0.968, Rgb(30, 30, 30)),
			ColorSequenceKeypoint.new(1,     Rgb(31, 31, 31)),
		}),
		["Outline"] = Rgb(0, 0, 0);
		["Inline"]     = Rgb(37, 37, 37);
		["Text"]     = Rgb(235, 240, 247);
	};
	["TabCounts"] = 0;
	["LastActivatedTab"] = nil;
	["Connections"]	= {  };
}
Library.__index = Library
Library["Element"].__index = Library["Element"]

local Fonts = {  }; do
	function Fonts:New(Name, Weight, Url)
		WriteFile(Name .. ".tff", game:HttpGet(Url))
		local FontData = {
			name = Name,
			faces = { {
				name = "Regular",
				weight = Weight,
				style = "Regular",
				assetId = GetCustomAsset(Name .. ".tff")
			} }
		}
		WriteFile(Name .. ".json", HttpService:JSONEncode(FontData))
		return Font.new(GetCustomAsset(Name .. ".json"))
	end
	if IsStudio then
		Library["Font"] 	= Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		Library["FontBold"] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
	else
		Library["Font"] 	= Fonts:New("Tahoma", 200, "https://github.com/mental1illness/storage/raw/refs/heads/main/fonts/old-tahoma.ttf");
		Library["FontBold"] = Fonts:New("Tahoma_Bold", 200, "https://github.com/mental1illness/storage/raw/refs/heads/main/fonts/old-tahoma-bold.ttf");
	end
end

local Object = {} do
	function Object:New(ClassName: string, Properties: {})
		local IsOK, CreatedObject = pcall(Instance.new, ClassName)
		if not IsOK then
			warn("Failed to create " .. ClassName .. ".")
			return nil
		end
		for Index, Value in Properties do
			local Success, Error = pcall(function()
				CreatedObject[Index] = Value
			end)
			if not Success then
				warn("Failed to set property " .. Index .. " of " .. ClassName .. ": " .. Error)
			end
		end

		Insert(Library["Objects"], CreatedObject)

		return CreatedObject
	end
	function Object:FindFirstChild(Object: Instance, Name: string, Descendants: boolean, IsMultiple: boolean)
		local Objects = {}

		Object  = Object or nil;
		Name	= Name or nil;
		Descendants = Descendants or false;
		IsMultiple = IsMultiple or false;

		if not Object or not Name then
			return nil;
		end

		if Descendants then
			for Index, Value in Object:GetDescendants() do
				if Value and Value.Name and Value.Name == Name then
					if IsMultiple then
						Insert(Objects, Value)
					else
						return Value
					end
				end
			end
		else
			for Index, Value in Object:GetChildren() do
				if Value and Value.Name and Value.Name == Name then
					if IsMultiple then
						Insert(Objects, Value)
					else
						return Value
					end
				end
			end
		end

		return IsMultiple and Objects or nil
	end

	function Object:Tween(Object: Instance, Properties: {}, Duration: number)
		return TweenService:Create(Object, TweenInfo.new(Duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), Properties)
	end

	function Object:GetTransparency(Object: Instance)
		if Object:IsA("Frame") then
			return { "BackgroundTransparency" }
		elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
			return { "TextTransparency" }
		elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
			return { "BackgroundTransparency", "ImageTransparency" }
		elseif Object:IsA("ScrollingFrame") then
			return { "BackgroundTransparency", "ScrollBarImageTransparency" }
		elseif Object:IsA("TextBox") then
			return { "TextTransparency"}
		elseif Object:IsA("UIStroke") then 
			return { "Transparency" }
		end
	end
end

function Library:Connect(Signal: RBXScriptSignal, Callback: (...any) -> ())
	local Connection = Signal:Connect(Callback)
	Insert(Library["Connections"], Connection)
	return Connection
end

function Library:Disconnect()
	for Index, Connection in Library["Connections"] do
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
	table.clear(Library["Connections"])
end

do -- Library
	function Library:Window( Properties: { } )
		Properties = Properties or {  }
		local Config = {
			["Name"] = Properties["Name"] or "fragmented",
			["Domain"] = Properties["Domain"] or ".lol",
		}
		local Holder = Object:New("ScreenGui", {
			["Name"]            = Config["Name"],
			["IgnoreGuiInset"]  = true,
			["ResetOnSpawn"]    = false,
			["Enabled"]         = true,
			["Parent"]          = GetHiddenUI(),
			["ZIndexBehavior"]  = Enum.ZIndexBehavior.Global,
		})

		local OtherElements = Object:New("ScreenGui", {
			["IgnoreGuiInset"]  = true,
			["ResetOnSpawn"]    = false,
			["Enabled"]         = true,
			["Parent"]          = GetHiddenUI(),
			["ZIndexBehavior"]  = Enum.ZIndexBehavior.Global,
		})

		local Main = Object:New("Frame", {
			["AnchorPoint"]      = Vector2.new(0.5, 0.5),
			["Parent"]           = Holder,
			["Name"]             = "Main",
			["Position"]         = UDim2.new(0.5, 0, 0.5, 0),
			["BorderColor3"]     = Library["Theme"]["Outline"],
			["Size"]             = UDim2.new(0, 598, 0, 638),
			["BorderSizePixel"]  = 0,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		})

		local TitleHolder = Object:New("Frame", {
			["Parent"]               = Main,
			["Name"]                 = "TitleHolder",
			["Position"]             = UDim2.new(0, 10, 0, 8),
			["BackgroundTransparency"] = 1,
			["BorderSizePixel"]      = 0,
			["AutomaticSize"]        = Enum.AutomaticSize.XY,
			["Size"]                 = UDim2.new(0, 0, 0, 0),
			["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIListLayout", {
			["Parent"]        = TitleHolder,
			["FillDirection"] = Enum.FillDirection.Horizontal,
			["SortOrder"]     = Enum.SortOrder.LayoutOrder,
			["Padding"]       = UDim.new(0, 1),
		})

		local Title = Object:New("TextLabel", {
			["FontFace"]             = Library["FontBold"],
			["Parent"]               = TitleHolder,
			["TextColor3"]           = Library["Theme"]["Accent"],
			["BorderColor3"]         = Library["Theme"]["Outline"],
			["Text"]                 = Config["Name"],
			["Name"]                 = "Title",
			["BackgroundTransparency"] = 1,
			["TextXAlignment"]       = Enum.TextXAlignment.Left,
			["BorderSizePixel"]      = 0,
			["AutomaticSize"]        = Enum.AutomaticSize.XY,
			["Size"]                 = UDim2.new(0, 0, 0, 0),
			["TextSize"]             = 12,
			["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["Parent"]       = Title,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		local Domain = Object:New("TextLabel", {
			["FontFace"]             = Library["Font"],
			["Parent"]               = TitleHolder,
			["TextColor3"]           = Color3.fromRGB(255, 255, 255),
			["BorderColor3"]         = Library["Theme"]["Outline"],
			["Text"]                 = Config["Domain"],
			["Name"]                 = "Domain",
			["BackgroundTransparency"] = 1,
			["BorderSizePixel"]      = 0,
			["AutomaticSize"]        = Enum.AutomaticSize.XY,
			["Size"]                 = UDim2.new(0, 0, 0, 0),
			["TextSize"]             = 12,
			["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["Parent"]       = Domain,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})


		local Outline = Object:New("UIStroke", {
			["Parent"]       = Title,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		local Elements = Object:New("Frame", {
			["AnchorPoint"]      = Vector2.new(0.5, 0.5),
			["Parent"]           = Main,
			["Name"]             = "Elements",
			["Position"]         = UDim2.new(0.5, 0, 0.5141, 0),
			["BorderColor3"]     = Library["Theme"]["Outline"],
			["Size"]             = UDim2.new(0.9682, 0, 0.942, 0),
			["BorderSizePixel"]  = 0,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["Parent"]       = Elements,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		local Inline = Object:New("UIStroke", {
			["LineJoinMode"]        = Enum.LineJoinMode.Miter,
			["Name"]                = "Inline",
			["Color"]               = Library["Theme"]["Inline"],
			["Parent"]              = Elements,
			["BorderStrokePosition"] = Enum.BorderStrokePosition.Inner,
		})

		local Greeting = Object:New("Frame", {
			["AnchorPoint"]      = Vector2.new(0.5, 1),
			["Parent"]           = Elements,
			["Name"]             = "Greeting",
			["Position"]         = UDim2.new(0.5, 0, 0.9817, 0),
			["BorderColor3"]     = Library["Theme"]["Outline"],
			["Size"]             = UDim2.new(0.9637, 0, 0.0433, 0),
			["BorderSizePixel"]  = 0,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["LineJoinMode"]         = Enum.LineJoinMode.Miter,
			["Name"]                 = "Inline",
			["Color"]                = Library["Theme"]["Inline"],
			["Parent"]               = Greeting,
			["BorderStrokePosition"] = Enum.BorderStrokePosition.Inner,
		})

		local GreetText = Object:New("TextLabel", {
			["TextWrapped"]          = true,
			["Parent"]               = Greeting,
			["TextColor3"]           = Color3.fromRGB(255, 255, 255),
			["BorderColor3"]         = Library["Theme"]["Outline"],
			["Text"]                 = "welcome back,",
			["Name"]                 = "GreetText",
			["Size"]                 = UDim2.new(0.1254, 0, 0.4615, 0),
			["AnchorPoint"]          = Vector2.new(0, 0.5),
			["BorderSizePixel"]      = 0,
			["BackgroundTransparency"] = 1,
			["Position"]             = UDim2.new(0.0161, 0, 0.4615, 0),
			["FontFace"]             = Library["Font"],
			["AutomaticSize"]        = Enum.AutomaticSize.XY,
			["TextSize"]             = 12,
			["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["Parent"]       = GreetText,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		local User = Object:New("TextLabel", {
			["TextWrapped"]          = true,
			["Parent"]               = Greeting,
			["TextColor3"]           = Library["Theme"]["Accent"],
			["BorderColor3"]         = Library["Theme"]["Outline"],
			["Text"]                 = "nam",
			["Name"]                 = "User",
			["Size"]                 = UDim2.new(0.0448, 0, 0.4615, 0),
			["AnchorPoint"]          = Vector2.new(0, 0.5),
			["BorderSizePixel"]      = 0,
			["BackgroundTransparency"] = 1,
			["Position"]             = UDim2.new(0.1523, 0, 0.4615, 0),
			["FontFace"]             = Library["FontBold"],
			["AutomaticSize"]        = Enum.AutomaticSize.XY,
			["TextSize"]             = 12,
			["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
		})

		Object:New("UIStroke", {
			["Parent"]       = User,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		local Game = Object:New("TextLabel", {
			["TextWrapped"] = false,
			["TextColor3"] = Library["Theme"]["Accent"],
			["BorderColor3"] = Library["Theme"]["Outline"],
			["Text"] = "Counter Blox",
			["Parent"] = Greeting,
			["Name"] = "Game",
			["AnchorPoint"] = Vector2.new(1, 0.5),
			["BackgroundTransparency"] = 1,
			["Position"] = UDim2.new(1, -2, 0.4615, 0),
			["BorderSizePixel"] = 0,
			["AutomaticSize"] = Enum.AutomaticSize.XY,
			["FontFace"] = Library["FontBold"],
			["TextSize"] = 12,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
			["TextXAlignment"] = Enum.TextXAlignment.Center,
			["ClipsDescendants"] = false,
		})

		Object:New("UIPadding", {
			["Parent"] = Game,
			["PaddingLeft"] = UDim.new(0, 15),
			["PaddingRight"] = UDim.new(0, 15),
		})

		Object:New("UIStroke", {
			["Parent"] = Game,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"] = "Outline",
		})

		local Bracket1 = Object:New("TextLabel", {
			["TextWrapped"] = false,
			["Parent"] = Game,
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["BorderColor3"] = Library["Theme"]["Outline"],
			["Text"] = "]",
			["Name"] = "Bracket1",
			["AnchorPoint"] = Vector2.new(0, 0.5),
			["BorderSizePixel"] = 0,
			["BackgroundTransparency"] = 1,
			["Position"] = UDim2.new(1, 4, 0.5, 0),
			["FontFace"] = Library["Font"],
			["AutomaticSize"] = Enum.AutomaticSize.XY,
			["TextSize"] = 12,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
			["ZIndex"] = 2,
		})

		Object:New("UIStroke", {
			["Parent"] = Bracket1,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"] = "Outline",
		})

		local Bracket2 = Object:New("TextLabel", {
			["TextWrapped"] = false,
			["Parent"] = Game,
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["BorderColor3"] = Library["Theme"]["Outline"],
			["Text"] = "[",
			["Name"] = "Bracket2",
			["AnchorPoint"] = Vector2.new(1, 0.5),
			["BorderSizePixel"] = 0,
			["BackgroundTransparency"] = 1,
			["Position"] = UDim2.new(0, -4, 0.5, 0),
			["FontFace"] = Library["Font"],
			["AutomaticSize"] = Enum.AutomaticSize.XY,
			["TextSize"] = 12,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
			["ZIndex"] = 2,
		})

		Object:New("UIStroke", {
			["Parent"] = Bracket2,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"] = "Outline",
		})

		local Gradient = Object:New("UIGradient", {
			["Rotation"] = -90,
			["Parent"]   = Greeting,
			["Name"]     = "Gradient",
			["Color"]    = Library["Theme"]["Gradient"],
		})

		Object:New("UIStroke", {
			["Parent"]       = Greeting,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})

		Object:New("UIGradient", {
			["Rotation"] = 90,
			["Parent"]   = Elements,
			["Name"]     = "Gradient",
			["Color"]    = Library["Theme"]["Gradient"]
		})

		local Tabs = Object:New("Frame", {
			["Name"]             = "Tabs",
			["Parent"]           = Elements,
			["BorderColor3"]     = Library["Theme"]["Outline"],
			["Size"]             = UDim2.new(1, 0, 0.0366, 0),
			["BorderSizePixel"]  = 0,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		})

		do
			Object:New("UIStroke", {
				["LineJoinMode"]         = Enum.LineJoinMode.Miter,
				["Name"]                 = "Inline",
				["Color"]                = Library["Theme"]["Inline"],
				["Parent"]               = Tabs,
				["BorderStrokePosition"] = Enum.BorderStrokePosition.Inner,
			})

			Object:New("UIGradient", {
				["Rotation"] = 90,
				["Parent"]   = Tabs,
				["Name"]     = "Gradient",
				["Color"]    = ColorSequence.new{
					ColorSequenceKeypoint.new(0,     Color3.fromRGB(21, 21, 21)),
					ColorSequenceKeypoint.new(0.968, Color3.fromRGB(30, 30, 30)),
					ColorSequenceKeypoint.new(1,     Color3.fromRGB(31, 31, 31)),
				},
			})

			local UIListLayout = Object:New("UIListLayout", {
				["Parent"]        = Tabs,
				["Padding"]       = UDim.new(0, 5),
				["SortOrder"]     = Enum.SortOrder.LayoutOrder,
				["FillDirection"] = Enum.FillDirection.Horizontal,
			})

			Object:New("UIStroke", {
				["Parent"]       = Tabs,
				["LineJoinMode"] = Enum.LineJoinMode.Miter,
				["Name"]         = "Outline",
			})

			Object:New("UIPadding", {
				["Parent"] = Tabs,
				["PaddingTop"] = UDim.new(0, -1),
				["PaddingLeft"] = UDim.new(0, 5),
			})
		end

		Object:New("UIGradient", {
			["Rotation"] = 90,
			["Parent"]   = Main,
			["Name"]     = "Gradient",
			["Color"]    = ColorSequence.new{
				ColorSequenceKeypoint.new(0,     Color3.fromRGB(21, 21, 21)),
				ColorSequenceKeypoint.new(0.968, Color3.fromRGB(30, 30, 30)),
				ColorSequenceKeypoint.new(1,     Color3.fromRGB(31, 31, 31)),
			},
		})

		Object:New("UIStroke", {
			["Parent"]       = Main,
			["LineJoinMode"] = Enum.LineJoinMode.Miter,
			["Name"]         = "Outline",
		})
		Object:New("UIStroke", {
			["LineJoinMode"]        = Enum.LineJoinMode.Miter,
			["Name"]                = "Inline",
			["Color"]               = Library["Theme"]["Inline"],
			["Parent"]              = Main,
			["BorderStrokePosition"] = Enum.BorderStrokePosition.Inner,
		})

		Object:New("UIStroke", {
			["LineJoinMode"]         = Enum.LineJoinMode.Miter,
			["Name"]                 = "Inline",
			["Color"]                = Library["Theme"]["Inline"],
			["Parent"]               = Tabs,
			["BorderStrokePosition"] = Enum.BorderStrokePosition.Inner,
		})


		local Sections = Object:New("Frame", {
			["BorderColor3"] = Library["Theme"]["Outline"],
			["AnchorPoint"] = Vector2.new(0.5, 1),
			["Parent"] = Elements,
			["BackgroundTransparency"] = 1,
			["Position"] = UDim2.new(0.4991, 0, 0.9251, 0),
			["Name"] = "Sections",
			["Size"] = UDim2.new(0.9637, 0, 0.8752, 0),
			["BorderSizePixel"] = 0,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
		})

		do -- Sections
			Object:New("UIListLayout", {
				["VerticalAlignment"] = Enum.VerticalAlignment.Bottom,
				["Wraps"] = true,
				["HorizontalAlignment"] = Enum.HorizontalAlignment.Right,
				["HorizontalFlex"] = Enum.UIFlexAlignment.Fill,
				["Parent"] = Sections,
				["Padding"] = UDim.new(0, 10),
				["SortOrder"] = Enum.SortOrder.LayoutOrder,
				["VerticalFlex"] = Enum.UIFlexAlignment.Fill,
			})

			local Left = Object:New("Frame", {
				["BorderColor3"] = Library["Theme"]["Outline"],
				["AnchorPoint"] = Vector2.new(0.5, 1),
				["Parent"] = Sections,
				["BackgroundTransparency"] = 1,
				["Position"] = UDim2.new(0.5, 0, 1, -11),
				["Name"] = "Left",
				["Size"] = UDim2.new(1, 0, 1, 0),
				["BorderSizePixel"] = 0,
				["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
			})

			Object:New("UIListLayout", {
				["SortOrder"] = Enum.SortOrder.LayoutOrder,
				["HorizontalFlex"] = Enum.UIFlexAlignment.Fill,
				["Parent"] = Left,
				["Padding"] = UDim.new(0, 10),
				["VerticalFlex"] = Enum.UIFlexAlignment.Fill,
			})


			local Right = Object:New("Frame", {
				["BorderColor3"] = Library["Theme"]["Outline"],
				["AnchorPoint"] = Vector2.new(0.5, 1),
				["Parent"] = Sections,
				["BackgroundTransparency"] = 1,
				["Position"] = UDim2.new(0.5, 0, 1, -11),
				["Name"] = "Right",
				["Size"] = UDim2.new(1, 0, 1, 0),
				["BorderSizePixel"] = 0,
				["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
			})

			Object:New("UIListLayout", {
				["SortOrder"] = Enum.SortOrder.LayoutOrder,
				["HorizontalFlex"] = Enum.UIFlexAlignment.Fill,
				["Parent"] = Right,
				["Padding"] = UDim.new(0, 10),
				["VerticalFlex"] = Enum.UIFlexAlignment.Fill,
			})
		end

		Config.SetWindowName = function(self, Name)
			Title.Text = Name
		end
		Config.SetWindowDomain = function(self, Domain)
			Domain.Text = Domain
		end
		local CurTweens = {}
		Config.SetVisiblity = function(Bool: boolean)

			for Index, Value in CurTweens do
				Value:Cancel()
			end
			CurTweens = {}

			if Bool == false then
				Holder.Enabled = true
			end

			local Pending = 0

			for Index, Value in Library["Objects"] do
				if not Value then continue end

				local Transparency = Object:GetTransparency(Value)
				if Transparency == nil then continue end

				for _, Property in Transparency do
					if Bool == true then
						if not Value:GetAttribute("OldTransparency_" .. Property) then
							Value:SetAttribute("OldTransparency_" .. Property, Value[Property])
						end

						local Tween = Object:Tween(Value, { [Property] = 1 }, 0.5)
						Pending += 1

						Tween:Play()
						Insert(CurTweens, Tween)

						Tween.Completed:Once(function()
							Pending -= 1
							if Pending <= 0 then
								Holder.Enabled = false
							end
						end)
					else
						local OldValue = Value:GetAttribute("OldTransparency_" .. Property)
						if OldValue then
							local Tween = Object:Tween(Value, { [Property] = OldValue }, 0.5)
							Tween:Play()
							Insert(CurTweens, Tween)
						end
					end
				end
			end
		end

		local IsOn = false

		Library:Connect(InputService.InputBegan, function(Input: InputAction)
			if Input.KeyCode == Enum.KeyCode.Insert or Input.KeyCode == Enum.KeyCode.Delete then
				IsOn = not IsOn
				Config.SetVisiblity(IsOn)
			end 
		end)

		Config["TabHolder"] = Tabs;
		Config["SectionHolder"] = Sections;
		Config["Type"] = "Window";

		return setmetatable(Config, Library["Element"])
	end

	do --- Elements Table
		Library["Element"].CreateTab = function(self, Properties: {  })
			Properties = Properties or {}
			local Tab = {
				["Name"] = Properties["Name"] or Properties["Text"] or "Tab",
				["IsActivated"] = false
			}

			Library["TabCounts"] += 1
			local TabButton = nil;

			local Holder = self["TabHolder"] do
				local NewTab = Object:New("TextButton", {
					["Parent"]               = self["TabHolder"],
					["FontFace"]             = Library["Font"],
					["TextColor3"]           = Library["Theme"]["Text"],
					["BorderColor3"]         = Library["Theme"]["Outline"],
					["Text"]                 = Tab["Name"],
					["Name"]                 = Library["TabCounts"],
					["BackgroundTransparency"] = 1,
					["Size"]                 = UDim2.new(0, 0, 0.7727, 0),
					["BorderSizePixel"]      = 0,
					["AutomaticSize"]        = Enum.AutomaticSize.XY,
					["TextSize"]             = 12,
					["BackgroundColor3"]     = Color3.fromRGB(255, 255, 255),
				})

				TabButton = NewTab

				Object:New("UIPadding", {
					["Parent"]     = NewTab,
					["PaddingTop"] = UDim.new(0, 5),
				})

				Object:New("UIStroke", {
					["Parent"]       = NewTab,
					["LineJoinMode"] = Enum.LineJoinMode.Miter,
					["Name"]         = "Outline",
				})
			end


			do
				local CurrentTween = nil
				Tab.Activate = function()
					if Library["LastActivatedTab"] ~= nil and Library["LastActivatedTab"] ~= Tab then
						Library["LastActivatedTab"].Deactivate()
					end
					if CurrentTween ~= nil then 
						CurrentTween:Cancel() 
					end
					Tab["IsActivated"] = true
					TabButton["FontFace"] = Library["FontBold"]
					CurrentTween = Object:Tween(TabButton, { TextColor3 = Library["Theme"]["Accent"] }, 0.5)
					CurrentTween:Play()
					Library["LastActivatedTab"] = Tab
				end
				Tab.Deactivate = function()
					if CurrentTween ~= nil then 
						CurrentTween:Cancel() 
					end
					Tab["IsActivated"] = false
					TabButton["FontFace"] = Library["Font"]
					CurrentTween = Object:Tween(TabButton, { TextColor3 = Library["Theme"]["Text"] }, 0.5)
					CurrentTween:Play()
				end
			end

			TabButton.MouseButton1Click:Connect(function()
				Tab.Activate()
			end)

			if Library["TabCounts"] == 1 then
				Tab.Activate() 
			else
				Tab.Deactivate()
			end

			Tab["TabButton"] = TabButton;
			Tab["Type"] = "Tab";

			return setmetatable(Tab, Library["Element"])
		end
	end
end

local Window = Library:Window({ ["Name"] = "fragmented", ["Domain"] = ".lol" })
local Tab = Window:CreateTab({ ["Name"] = "israel" })
local Tab = Window:CreateTab({ ["Name"] = "im red" })
