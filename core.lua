local clubs = {}
local group

local function AnnounceGrouping()
	local pSize = GetNumGroupMembers();
	
	if pSize > 1 then
	return
	end	
	
	local queueStats = {GetLFGQueueStats(LE_LFG_CATEGORY_LFD)};
	local queuetime = GetTime() - queueStats[17];
	
	if queuetime > 0 then
	return
	end

	local queueList = GetLFGQueuedList(LE_LFG_CATEGORY_LFD);
	local count = 0;
	local overflowCount = 0;

	local queuestring = ""

	for k, v in pairs(queueList) do
		count = count + 1;
		
		if count < 6 then
			local instanceName = select(1, GetLFGDungeonInfo(k))
			local curString = queuestring .. " " .. instanceName
			queuestring = curString
			
			if count < 5 and count > 1 then
				queuestring = queuestring .. ","
			end
		else
			overflowCount = overflowCount + 1
		end
	end
	
	if overflowCount > 0 then
		queuestring = queuestring .. " and " .. overflowCount .. " more"
	end
	
	C_Club.SendMessage(group, 1, "==queueing for " .. queuestring .. "==");
end

local function BroadcastAchievement(self, event, ...)
	local achievementID = ...;
	local achievementLink = GetAchievementLink(achievementID);

	C_Club.SendMessage(group, 1, UnitName("player") .. " has earned the achievement " .. achievementLink .. ".");
end

local function GetClubIDByName(clubname)
	local clubs = C_Club.GetSubscribedClubs();
	for k, v in ipairs(clubs) do
		if v.name == clubname then
			return v.clubId;
		end
	end
end

SLASH_RELOAD1 = "/rl";
SlashCmdList.RELOAD = ReloadUI;

SLASH_NOTIFYGG1 = "/gcom";
SlashCmdList.NOTIFYGG = function(com)
	local list = {GetLFGQueuedList(LE_LFG_CATEGORY_LFD)};
	print(com)
	
	group = GetClubIDByName(com)	
end

local events = CreateFrame("Frame");
events:RegisterEvent("LFG_QUEUE_STATUS_UPDATE");
events:SetScript("OnEvent", AnnounceGrouping);

local frame = CreateFrame("Frame");
frame:RegisterEvent("ACHIEVEMENT_EARNED");
frame:SetScript("OnEvent", BroadcastAchievement);






