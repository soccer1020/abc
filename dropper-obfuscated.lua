local url = "ws://107.175.254.57:8765"
local ws
local Players = game:GetService('Players')
local Terrain = Workspace:FindFirstChild('Terrain')
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService('Workspace')
local replicatedStorage = game:GetService("ReplicatedStorage")
local mainEvent = replicatedStorage:WaitForChild("MainEvent")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local IGNORED = workspace:WaitForChild("Ignored")	
local StarterGui = game:GetService("StarterGui")
local PLAYER_GUI = localPlayer:WaitForChild("PlayerGui")

local cash_drop = false

StarterGui:ClearAllChildren()
PLAYER_GUI:ClearAllChildren()


if table.find(getgenv().alts, localPlayer.UserId) then
		local client_id = "Server-"..ps_owner1
		settings().Rendering.QualityLevel = 1

		local localPlayer = game.Players.LocalPlayer

		local function teleport(position)
			task.spawn(function()
				while task.wait() do
					pcall(function()
						localPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = position
						localPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0)
					end)
				end
			end)
		end




		local function setuptp()
			local distance = 20
			local alts = getgenv().alts
		
			-- Teleport center if it's the owner
			if game.Players.LocalPlayer.UserId == ps_owner1 then
				local centerPosition = CFrame.new(-263.75531005859375, -12.117109298706055, -378.037841796875)
				teleport(centerPosition)
			end
		
			-- Create list excluding the owner
			local list = {}
			for _, altId in ipairs(alts) do
				if ps_owner1 ~= altId then
					table.insert(list, altId)
				end
			end
		
			-- Check if there are any alts to teleport to
			if #list > 0 then
				local indexInList = table.find(list, game.Players.LocalPlayer.UserId)
		
				-- If the player is found in the list, proceed with teleportation
				if indexInList then
					local angle = 360 / #list
					local teleportsetup = (CFrame.new(-263.75531005859375, -12.117109298706055, -378.037841796875) 
											* CFrame.Angles(0, math.rad(angle) * indexInList, 0) 
											* CFrame.new(0, 0, distance))
					teleport(teleportsetup)
				end
			end
		end
		
		setuptp()
		task.wait(10)
		

		local names = {"Ignored", "Players", "Camera", "Terrain",game.Players.LocalPlayer.Name}
		for _, instance in workspace:GetChildren() do
				if not table.find(names, instance.Name) then
					instance:Destroy()
				end
		end
		
		local names = {"Drop", game.Players.LocalPlayer.Name}
		for _, instance in workspace.Ignored:GetChildren() do
				if not table.find(names, instance.Name) then
					instance:Destroy()
				end
		end
		
		
		local playerfolder = game.Players.LocalPlayer.Backpack
		playerfolder.ChildAdded:Connect(function(child)
				if child.Name ~= game.Players.LocalPlayer.Character.Name then
					child:Destroy()
				end
		end)
		



		local Lighting = game:GetService("Lighting")
		
		-- Remove any existing Sky object
		local sky = Lighting:FindFirstChildOfClass("Sky")
		if sky then
			sky:Destroy()  -- Remove the sky object
		end
		
		-- Remove the Atmosphere if it exists
		local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
		if atmosphere then
			atmosphere:Destroy()  -- Remove the atmosphere to eliminate clouds
		end
		
		-- Optionally, you can also disable the default environment by clearing the lighting settings:
		
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)  -- Set ambient lighting to white (or black for a darker look)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)  -- Set outdoor lighting
		Lighting.Brightness = 0  -- Set lighting brightness to 0
		Lighting.ExposureCompensation = -100  -- Make the scene as dark as possible
		
		-- Optionally set the `Sky` to a fully transparent Sky (if you want no visual sky at all)
		local emptySky = Instance.new("Sky")
		emptySky.SkyboxBk = "rbxassetid://1"  -- Transparent texture
		emptySky.SkyboxDn = "rbxassetid://1"  -- Transparent texture
		emptySky.SkyboxFt = "rbxassetid://1"  -- Transparent texture
		emptySky.SkyboxLf = "rbxassetid://1"  -- Transparent texture
		emptySky.SkyboxRt = "rbxassetid://1"  -- Transparent texture
		emptySky.SkyboxUp = "rbxassetid://1"  -- Transparent texture
		emptySky.Parent = Lighting


		local hideCash = true
			
		if hideCash == true then
			for _, v in pairs(IGNORED.Drop:GetChildren()) do
				if v:IsA("Part") then
					if v:FindFirstChild("Decal") then
						v.Decal:Destroy()
						v.Decal:Destroy() 
					end

					if v:FindFirstChild("BillboardGui") then
						v.BillboardGui.Enabled = false
					end
					v.Transparency = 1
				end
			end
		else
			for _, v in pairs(IGNORED.Drop:GetChildren()) do
				if v:IsA("Part") then
					if v:FindFirstChild("BillboardGui") then
						v.BillboardGui.Enabled = true
					end
					v.Transparency = 0
				end
			end
		end

		IGNORED.Drop.ChildAdded:Connect(function(child)
			if child:IsA("Part") then
				if hideCash then
					task.wait(0.5)
					for _, decal in pairs(child:GetChildren()) do
						if decal:IsA("Decal") then
							decal:Destroy()
						end
					end
		
					if child:FindFirstChild("BillboardGui") then
						child.BillboardGui.Enabled = false
					end
					child.Transparency = 1
				end
			end
		end)

		local screen_gui = Instance.new("ScreenGui")
		screen_gui.IgnoreGuiInset = true
		screen_gui.ResetOnSpawn = true
		screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screen_gui.Parent = game:GetService("CoreGui")
		
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BorderColor3 = Color3.new(0, 0, 0)
		frame.BorderSizePixel = 0
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.Visible = true
		frame.Parent = screen_gui
		
		local text_label = Instance.new("TextLabel")
		text_label.Font = Enum.Font.SourceSans
		text_label.TextColor3 = Color3.new(1, 1, 1)
		text_label.TextScaled = true
		text_label.TextSize = 14
		text_label.TextWrapped = true
		text_label.AnchorPoint = Vector2.new(0.5, 0.5)
		text_label.BackgroundColor3 = Color3.new(1, 1, 1)
		text_label.BackgroundTransparency = 1
		text_label.BorderColor3 = Color3.new(0, 0, 0)
		text_label.BorderSizePixel = 0
		text_label.Position = UDim2.new(0.499545425, 0, 0.49460867, 0)
		text_label.Size = UDim2.new(0.280877739, 0, 0.194782615, 0)
		text_label.Visible = true
		text_label.Parent = frame
		
		local function formatnumber(n)
			n = tostring(n)
			return n:reverse():gsub("...","%0,",math.floor((#n-1)/3)):reverse()
		end
		
		text_label.Text = "Loading..."
		task.spawn(function()
			while task.wait() do
				pcall(function()
					text_label.Text = "$"..formatnumber(game.Players.LocalPlayer:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
				end)
			end
		end)
		
		local frame_2 = Instance.new("Frame")
		frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame_2.BackgroundColor3 = Color3.new(1, 1, 1)
		frame_2.BorderColor3 = Color3.new(0, 0, 0)
		frame_2.BorderSizePixel = 0
		frame_2.Position = UDim2.new(0.499858946, 0, 0.597217381, 0)
		frame_2.Size = UDim2.new(0.355485886, 0, 0.0104347831, 0)
		frame_2.Visible = true
		frame_2.Parent = frame
		
		local uigradient = Instance.new("UIGradient")
		uigradient.Parent = frame_2

		
		local allowedusers = {}
		local userList = {}
		
		local function printUserList()
			for userId, value in pairs(userList) do
				print(userId .. ": " .. value)
			end
		end
		
		local function isProtectedPlayer(userId)
			for _, id in ipairs(getgenv().alts) do
				if userId == id then
					return true
				end
			end
			for _, id in ipairs(getgenv().dont_kick) do
				if userId == id then
					return true
				end
			end
			return false
		end

		local function ismod(userId)
			for _, id in ipairs(getgenv().dont_kick) do
				if userId == id then
					return true
				end
			end
			return false
		end
		
		local function vipKick(player)
		
			if not isProtectedPlayer(player.UserId) then
				game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Kick", player)
			end
			
		end
		
		local function shout(message)
			game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("Shout", message)
		end
		
		
		local function addUser(userId, value)
			userList[userId] = value  
		end
		
		local function addUseralloweduser(userId, channelId, ws_sender, discord_user_id)
			-- Insert the user details, including ws_sender, into the allowedusers table
			table.insert(allowedusers, { 
				userId = userId, 
				channelId = channelId, 
				ws_sender = ws_sender,
				discord_user_id = discord_user_id
			})
		end
		
		
		local function getChannelIdByUserId(userId)
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return user.channelId  -- Return the associated channelId
				end
			end
			-- If userId is not found
			return nil  -- Return nil if the userId is not found
		end
		
		local function getallowedusersUserId(userId)
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return user.ws_sender
				end
			end
			-- If userId is not found
			return nil  -- Return nil if the userId is not found
		end		

		local function get_userid_discord(userId)
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return user.discord_user_id
				end
			end
			-- If userId is not found
			return nil  -- Return nil if the userId is not found
		end		



		local function userExists(userId)
			-- Iterate over the allowedusers table
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return true
				end
			end
			-- Return false if no match is found
			return false
		end
		
		
		local function deleteUser(userId)
			userList[userId] = nil
		end
		
		
		local function removeUser(userId)
			for index, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					-- Remove the user from the list
					table.remove(allowedusers, index)
					return  -- Exit the function after removing the user
				end
			end
		end
		

		if localPlayer.UserId == ps_owner1 then

			





			local currencyPostFixes = {
				["k"] = 1000,
				["m"] = 1000000,
				["b"] = 1000000000,
			}
			local function Track(user, amount, D_user_id, D_guild)
				local success, errorMessage = pcall(function()
					
					for postFix, value in pairs(currencyPostFixes) do
						if string.find(amount, postFix) then
							local rawNumberString = string.gsub(amount, postFix, "")
							local amountNumber = tonumber(rawNumberString)
							amount = amountNumber * value
							break
						end
					end
				
					if userList[user] then
						local value = userList[user]
						amount = amount + value
						deleteUser(user)
					end
				
				
					repeat task.wait() until game:GetService("Players"):FindFirstChild(user)
					local target = game:GetService("Players"):FindFirstChild(user)
					
				
					local oldcurrency = tonumber(target:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
					local need = oldcurrency + amount
					local Channel_ID = getChannelIdByUserId(user)
					local ws_sender = getallowedusersUserId(user)
					local User_ID = target.UserId
					local username = target.Name
					local discord_id = get_userid_discord(user)
					local discord_guild = D_guild or "False"

					local starter_data = {
						target_bot_id = "bot-"..ps_owner1,
						action = "ADD-USER",
						channel_id = Channel_ID,
						user_id = User_ID,
						old_currency = oldcurrency,
						need = need,
						discord_id = discord_id,
						discord_guild = discord_guild,
						username = username
					}
					
					local json_data = HttpService:JSONEncode(starter_data)
					ws:Send(json_data)



					local starter_data = {
						target_bot_id = "bot2-"..ps_owner1,
						action = "ADD-USER",
						channel_id = Channel_ID,
						user_id = User_ID,
						old_currency = oldcurrency,
						need = need,
						discord_id = discord_id,
						discord_guild = discord_guild,
						username = username
					}
					
					local json_data = HttpService:JSONEncode(starter_data)
					ws:Send(json_data)



					local starter_data = {
						target_bot_id = "host-"..ps_owner1,
						action = "ADD-USER",
						channel_id = Channel_ID,
						user_id = User_ID,
						old_currency = oldcurrency,
						need = need,
						discord_id = discord_id,
						discord_guild = discord_guild,
						username = username
					}
					
					local json_data = HttpService:JSONEncode(starter_data)
					ws:Send(json_data)
					
					local new, last_cash_value, CASH_SPENT, last_change_value = 0, 0, 0, 0
					local last_sent_time = 0
					repeat
						task.wait(1)  -- Wait for 1 second to avoid tight looping
						
						local target = game:GetService("Players"):FindFirstChild(user)
						
						if target then
							new = tonumber(target:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
							
							if last_cash_value == 0 then
								last_cash_value = new
							else
								if last_cash_value > new then
									local spent = last_cash_value - new
									CASH_SPENT = CASH_SPENT + spent
								end
								last_cash_value = new
							end
							
							-- Check if 20 seconds have passed since the last send
							if tick() - last_sent_time >= 20 then
								local updated_data = {
									target_bot_id = "bot-"..ps_owner1,
									action = "UPDATE-BALANCE",
									user_id = User_ID,
									new_balance = new,
									total_spent = CASH_SPENT,
									channel_id = Channel_ID,
									discord_id = discord_id
								}
								
								-- Encode to JSON
								local json_data = HttpService:JSONEncode(updated_data)
								
								-- Send the JSON data
								ws:Send(json_data)
								


								local updated_data = {
									target_bot_id = "bot2-"..ps_owner1,
									action = "UPDATE-BALANCE",
									user_id = User_ID,
									new_balance = new,
									total_spent = CASH_SPENT,
									channel_id = Channel_ID,
									discord_id = discord_id
								}
								
								-- Encode to JSON
								local json_data = HttpService:JSONEncode(updated_data)
								
								-- Send the JSON data
								ws:Send(json_data)
								

								local updated_data = {
									target_bot_id = "host-"..ps_owner1,
									action = "UPDATE-BALANCE",
									user_id = User_ID,
									new_balance = new,
									total_spent = CASH_SPENT,
									channel_id = Channel_ID,
									discord_id = discord_id
								}
								
								-- Encode to JSON
								local json_data = HttpService:JSONEncode(updated_data)
								
								-- Send the JSON data
								ws:Send(json_data)
								
								-- Update the last sent time
								last_sent_time = tick()
							end
							
							-- Update `last_change_value` if the balance has changed
							if new ~= last_change_value then
								last_change_value = new
							end
						end
					until new + CASH_SPENT >= need or target == nil
				
					if new + CASH_SPENT >= need then
						removeUser(user)
						local updated_data = {
							target_bot_id = "bot-"..ps_owner1,
							action = "UPDATE-BALANCE",
							user_id = User_ID,
							new_balance = new,
							total_spent = CASH_SPENT,
							channel_id = Channel_ID,
							discord_id = discord_id
						}
						local json_data = HttpService:JSONEncode(updated_data)
						ws:Send(json_data)
						local updated_data = {
							target_bot_id = "bot2-"..ps_owner1,
							action = "UPDATE-BALANCE",
							user_id = User_ID,
							new_balance = new,
							total_spent = CASH_SPENT,
							channel_id = Channel_ID,
							discord_id = discord_id
						}
						local json_data = HttpService:JSONEncode(updated_data)
						ws:Send(json_data)
						local updated_data = {
							target_bot_id = "host-"..ps_owner1,
							action = "UPDATE-BALANCE",
							user_id = User_ID,
							new_balance = new,
							total_spent = CASH_SPENT,
							channel_id = Channel_ID,
							discord_id = discord_id
						}
						local json_data = HttpService:JSONEncode(updated_data)
						ws:Send(json_data)


						local updated_data = {
							target_bot_id = "bot-"..ps_owner1,
							action = "BLOCK",
							user_id = User_ID
						}
						local finished_M = HttpService:JSONEncode(updated_data)
						ws:Send(finished_M)

						
						local updated_data = {
							target_bot_id = "bot2-"..ps_owner1,
							action = "BLOCK",
							user_id = User_ID
						}
						local finished_M = HttpService:JSONEncode(updated_data)
						ws:Send(finished_M)

						
						local updated_data = {
							target_bot_id = "host-"..ps_owner1,
							action = "BLOCK",
							user_id = User_ID
						}
						local finished_M = HttpService:JSONEncode(updated_data)
						ws:Send(finished_M)
						shout("Please leave the game " .. user .. " or you will be kicked.")
						wait(10)
						vipKick(target)
						return true
					else
						local remaining = need - new
						addUser(user, remaining)
						return false
					end
				end)
				
				if not success then
					print("Error in Track function: " .. errorMessage)
				end
			end
			



			local function formatCurrency(value)
				if value >= 1e9 then
					return string.format("%.1fB", value / 1e9)
				elseif value >= 1e6 then
					return string.format("%.1fM", value / 1e6)
				elseif value >= 1e3 then
					return string.format("%.1fK", value / 1e3)
				else
					return tostring(value)
				end
			end
			
			
			local function sendserveralts(channel_id,ws_sender)
				local output = ""
				for _, player in pairs(game.Players:GetPlayers()) do
					if table.find(getgenv().alts, player.UserId) then
						local currency = player:WaitForChild("DataFolder"):WaitForChild("Currency")
						local formattedCurrency = formatCurrency(currency.Value)
						output = output .. player.Name .. ":" .. player.UserId .. ":" .. formattedCurrency .. ","
					end
				end
				if #output > 0 then
					output = output:sub(1, -2)
				end


				local updated_data = {
					target_bot_id = ws_sender,
					action = "LEADERBOARD",
					channel_id = channel_id,
					message = output
				}
				local finished_M = HttpService:JSONEncode(updated_data)
				ws:Send(finished_M)

			end
			
			local function sendservercash(channel_id,ws_sender)
				local totalCurrency = 0  -- Initialize total currency to 0
				for _, player in pairs(game.Players:GetPlayers()) do
					if table.find(getgenv().alts, player.UserId) then
						local currency = player:WaitForChild("DataFolder"):WaitForChild("Currency")
						totalCurrency = totalCurrency + currency.Value 
					end
				end
			
				local formattedCurrency = formatCurrency(totalCurrency)
			

				local updated_data = {
					target_bot_id = ws_sender,
					action = "STOCK",
					channel_id = channel_id,
					message = formattedCurrency
				}
				local finished_M = HttpService:JSONEncode(updated_data)
				ws:Send(finished_M)

			
				ws:Send(dataaa)
			end





		
			local function onPlayerAdded(player)
				if localPlayer.UserId == ps_owner1 then
					player.CharacterAdded:Wait()
					repeat
						task.wait()
					until player.Character and player.Character:FindFirstChild("FULLY_LOADED_CHAR") ~= nil        
					
					if not cash_drop then
						
						if userList[player.Name] then
							task.wait(1)
							game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
							task.wait(1)
							Track(player.Name, "1k")
						elseif userExists(player.Name) then
							game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
						else
							if not isProtectedPlayer(player.UserId) then
								shout("Please leave the game " .. player.Name .. " or you will be kicked.")
								wait(10)
								
								-- Use a localized variable for target2 here
								local target2 = game:GetService("Players"):FindFirstChild(player.Name)
								
								-- Only proceed if target2 is found
								if target2 then
									local updated_data = {
										target_bot_id = "host-"..ps_owner1,
										action = "BLOCK",
										user_id = player.UserId
									}
									local finished_M = HttpService:JSONEncode(updated_data)
									ws:Send(finished_M)

									local updated_data = {
										target_bot_id = "bot-"..ps_owner1,
										action = "BLOCK",
										user_id = player.UserId
									}
									local finished_M = HttpService:JSONEncode(updated_data)
									ws:Send(finished_M)

									local updated_data = {
										target_bot_id = "bot2-"..ps_owner1,
										action = "BLOCK",
										user_id = player.UserId
									}
									local finished_M = HttpService:JSONEncode(updated_data)
									ws:Send(finished_M)

									wait(10)
									vipKick(target2)  -- Kick the player if target2 is found

								end
							else
								if ismod(player.UserId) then
									game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
								end
							end
						end

					else
						game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
					end
				end
			end
			
			
			Players.PlayerAdded:Connect(onPlayerAdded)

			
			local function kick_command(username)
				local target2 = game:GetService("Players"):FindFirstChild(username)
				if target2 then
					vipKick(target2)
				end
			end

			local amount_to_Say = getgenv().pre_drop

			task.spawn(function()
				while task.wait() do
					pcall(function()
						game.Players:Chat(amount_to_Say)

						-- Wait for a random time between 10 and 60 seconds
						local randomDelay = math.random(100, 600) / 10  -- gives 10.0 to 60.0 seconds
						task.wait(randomDelay)
					end)
				end
			end)

			local og_cash = getgenv().pre_drop
			
			function setupWebSocketEvents()
				ws.OnMessage:Connect(function(message)
					local data = HttpService:JSONDecode(message)
					local Action = data.action
			
					if Action == "drop" then
						local amount_bought = data.amount_bought
						local RBLX_username = data.RBLX_username
						local channel_ID = data.channel_ID
						local author_id = data.author_id
						local guild_id = data.guild_id
						local ws_sender = data.ws_sender
			
						local co = coroutine.create(function()
							addUseralloweduser(RBLX_username, channel_ID, ws_sender, author_id)
							Track(RBLX_username, amount_bought, author_id, guild_id)
						end)
						coroutine.resume(co)
			
					elseif Action == "leaderboard" then
						local channel_ID = data.channel_ID
						local ws_sender = data.ws_sender
			
						local co = coroutine.create(function()
							sendserveralts(channel_ID, ws_sender)
						end)
						coroutine.resume(co)
			
					elseif Action == "stock" then
						local channel_ID = data.channel_ID
						local ws_sender = data.ws_sender
			
						local co = coroutine.create(function()
							sendservercash(channel_ID, ws_sender)
						end)
						coroutine.resume(co)
			
					elseif Action == "cashdrop" then
						local mode = data.mode
						local cash_to_drop = data.cash_to_drop


						local co = coroutine.create(function()
							if mode == "on" then
								cash_drop = true
								amount_to_Say = cash_to_drop
							elseif mode == "off" then
								cash_drop = false
								amount_to_Say = og_cash

                                for _, player in pairs(Players:GetPlayers()) do
                                    if player.UserId == ps_owner1 then
                                        continue
                                    end
                                    if not isProtectedPlayer(player.UserId) then

                                        
                                        -- Use a localized variable for target2 here
                                        local target2 = game:GetService("Players"):FindFirstChild(player.Name)
                                        
                                        -- Only proceed if target2 is found
                                        if target2 then
                                            local updated_data = {
                                                target_bot_id = "host-"..ps_owner1,
                                                action = "BLOCK",
                                                user_id = player.UserId
                                            }
                                            local finished_M = HttpService:JSONEncode(updated_data)
                                            ws:Send(finished_M)

                                            local updated_data = {
                                                target_bot_id = "bot-"..ps_owner1,
                                                action = "BLOCK",
                                                user_id = player.UserId
                                            }
                                            local finished_M = HttpService:JSONEncode(updated_data)
                                            ws:Send(finished_M)

                                            local updated_data = {
                                                target_bot_id = "bot2-"..ps_owner1,
                                                action = "BLOCK",
                                                user_id = player.UserId
                                            }
                                            local finished_M = HttpService:JSONEncode(updated_data)
                                            ws:Send(finished_M)

                                            wait(10)
                                            vipKick(target2)  -- Kick the player if target2 is found
                                        end
								    end
							    end
                            end
						end)
						coroutine.resume(co)
					end
				end)
			
				ws.OnClose:Connect(function()
					print("WebSocket closed. Starting reconnect loop...")
					connect() -- Retry connection indefinitely
				end)
			end
			
			function connect()
				while true do
					local success = pcall(function()
						ws = WebSocket.connect(url)
			
						if ws then
							local sent, err = pcall(function()
								ws:Send(client_id)
							end)
			
							if sent then
								setupWebSocketEvents()
							else
								warn("Failed to send client ID:", err)
								error("WebSocket send failed")
							end
						else
							error("WebSocket.connect returned nil")
						end
					end)
			
					if success and ws then
						break -- Exit loop if successfully connected and ready
					else
						print("WebSocket connection failed. Retrying in 10 seconds...")
						wait(10)
					end
				end
			end
			
			-- Start connection
			connect()

		end


		
		
		
		
		local function cashToInt(stringValue)
			local noDollarSign = string.sub(stringValue, 2, #stringValue)
			local noComma = string.gsub(noDollarSign, ",", "")
			local toInt = tonumber(noComma)
			
			return toInt
		end
		
		local function countFloorCash()
			local totalFloorCashAmount = 0
		
			for _,v in pairs(workspace.Ignored.Drop:GetChildren()) do
				if v:IsA("Part") then
					local amount = cashToInt(v.BillboardGui.TextLabel.Text)
					--TotalFloorCash
					totalFloorCashAmount += amount
				end
			end
		
			return totalFloorCashAmount
		end
		
		
		local function isOwnerInGame()
			for _, player in pairs(Players:GetPlayers()) do
				if player.UserId == ps_owner1 then
					return true
				end
			end
			return false
		end

		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
		local messageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
		


        local function setupChatListener(player)
            if player.UserId == getgenv().ps_owner1 then
                player.Chatted:Connect(function(message)
                    
                    local splitString = message:split(" ")
            
                    local index_0_message = splitString[1]
                    if player.UserId == getgenv().ps_owner1 then
                        local new_drop = tonumber(index_0_message)
                        if new_drop then
                            pre_drop = new_drop
                        end
                    end
                end)
            end
        end
    
        for _, player in pairs(game.Players:GetPlayers()) do
            setupChatListener(player)
        end
			

        local function non(player)
			setupChatListener(player)
		end
			
			
		Players.PlayerAdded:Connect(non)
		
		local function dropCashIfNeeded()
			while true do
				task.wait(15.5)
				if countFloorCash() < pre_drop then
					if isOwnerInGame() then
						mainEvent:FireServer("DropMoney", 15000)
					else
						local ReplicatedStorage = game:GetService("ReplicatedStorage")
						local chatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
						local CHAT_EVENT = chatEvents:WaitForChild("SayMessageRequest")
						CHAT_EVENT:FireServer("Waiting for ps owner to be in server.", "All")
					end
				end
			end
		end
		local co1 = coroutine.create(function()
			dropCashIfNeeded()
		end)
		coroutine.resume(co1)
		

		settings().Rendering.QualityLevel = 1
		UserSettings().GameSettings.MasterVolume = 0
		setfpscap(fps_cap)
		RunService:Set3dRenderingEnabled(false)    
		
		
		
		local GC = getconnections or get_signal_cons
			if GC then
				for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
					if v["Disable"] then
						v["Disable"](v)
					elseif v["Disconnect"] then
						v["Disconnect"](v)
					end
				end
			end
		
		
		function ismacro() 
			return game:GetService("Lighting"):GetAttribute("MacroAllow") or false 
		end 
		
        local isroleplay = function()
        local roleplay = game:GetService("Players"):GetAttribute("Roleplay")
            return roleplay or false 
        end 
		
		
		if localPlayer.UserId == ps_owner1 then
			if isroleplay() == false then
				game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("RoleplayModeChange")
			end
		end
end
