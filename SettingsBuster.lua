local _, sb = ...;

local TRACKING = {
	["other"] = {
		"Banker",
		"Flight Master",
		"Innkeeper",
		"Mailbox",
		"Profession Trainers",
		"Trivial Quests",
		"Track Quest POIs",
		"Focus Target",
		"Stable Master",
		"Transmogrifier",
	},
	["spell"] = {
		"Find Herbs",
		"Find Minerals",
		"Find Treasure",
	},
};

local function in_array(needle, haystack)
	for key, value in pairs(haystack) do
		if (value == needle) then
			return true;
		end
	end
	return false;
end

sb.frame = CreateFrame("Frame", "SettingsBuster_Frame", UIParent);
sb.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
sb.frame:SetScript("OnEvent", function(self, event, ...)
	return sb[event] and sb[event](sb, ...)
end);

function sb:PLAYER_ENTERING_WORLD(self, ...)
	--SetCVar("TargetPriorityAllowAnyOnScreen", 0);
	--SetCVar("TargetNearestUseOld", 1);
	--SetCVar("TargetPriorityIncludeBehind", 0);
	SetCVar("cameraDistanceMaxZoomFactor", 2.6);
	SetCVar("autoLootDefault", 1);
	SetCVar("lootUnderMouse", 0);
	SetCVar("nameplateMaxDistance", 40);
	SetCVar("nameplateResourceOnTarget", 0);
	SetCVar("nameplateShowAll", 1);
	SetCVar("nameplateShowEnemyMinions", 1);
	SetCVar("nameplateShowEnemyMinus", 1);
	SetCVar("nameplateShowEnemyGuardians", 1);
	SetCVar("nameplateShowEnemyPets", 1);
	SetCVar("nameplateShowEnemyTotems", 1);
	SetCVar("nameplateShowFriendlyMinions", 1);
	SetCVar("nameplateShowFriendlyGuardians", 1);
	SetCVar("nameplateShowFriendlyPets", 1);
	SetCVar("nameplateShowFriends", 0);
	SetCVar("nameplateShowSelf", 0);
	SetCVar("Outline", 0);
	SetCVar("UnitNameFriendlySpecialNPCName", 0);
	SetCVar("UnitNameHostleNPC", 0);
	SetCVar("UnitNameInteractiveNPC", 0);
	SetCVar("UnitNameNPC", 1);
	SetCVar("miniWorldMap", 0);

	for i=1, C_Minimap.GetNumTrackingTypes() do
		local name, _, _, category = C_Minimap.GetTrackingInfo(i);
		if (TRACKING[category] ~= nil and next(TRACKING[category]) and in_array(name, TRACKING[category])) then
			--DEFAULT_CHAT_FRAME:AddMessage(i .. " - Yay! - " .. name .. " (" .. category .. ")");
			C_Minimap.SetTracking(i, true);
		else
			--DEFAULT_CHAT_FRAME:AddMessage("  " .. i .. " - Boo! - " .. name .. " (" .. category .. ")");
			C_Minimap.SetTracking(i, false);
		end
	end

	sb.frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
end

local origMainMenuMicroButton_AreAlertsEnabled = MainMenuMicroButton_AreAlertsEnabled;
function MainMenuMicroButton_AreAlertsEnabled()
	return false;
end

local origHasPvpTalentAlertToShow = TalentMicroButtonMixin.HasPvpTalentAlertToShow;
function TalentMicroButtonMixin:HasPvpTalentAlertToShow(...)
	DEFAULT_CHAT_FRAME:AddMessage("Here!");
	return nil, LOWEST_TALENT_FRAME_PRIORITY;
end

local hook_frame = CreateFrame("Frame");
hook_frame:SetScript("OnEvent", function(self, event, addon)
	if (addon == "Blizzard_TalentUI") then
		hooksecurefunc("PlayerTalentFrame_Refresh", function(self)
			PlayerTalentFrame_SetExpanded(false);
		end);
		self:UnregisterEvent("ADDON_LOADED");
	end
end);
hook_frame:RegisterEvent("ADDON_LOADED");