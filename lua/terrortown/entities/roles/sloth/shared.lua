if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_sloth.vmt")
end

roles.InitCustomTeam(ROLE.name, {
		icon = "vgui/ttt/dynamic/roles/icon_sloth",
		color = Color(37, 150, 190, 255)
})

function ROLE:PreInitialize()
	self.color = Color(37, 150, 190, 255)

	self.abbr = "sloth"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 5
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0

	self.defaultTeam = TEAM_SLOTHS
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.isOmniscientRole = true

	self.conVarData = {
		pct = 0.13,
		maximum = 1,
		minPlayers = 13,
		credits = 1,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 1,
		random = 5,
		togglable = true,
		shopFallback = NONE
	}
end

function ROLE:Initialize()
	if SERVER and JESTER then
		-- add a easy role filtering to receive all jesters
		-- but just do it, when the role was created, then update it with recommended function
		-- theoretically this function is not necessary to call, but maybe there are some modifications
		-- of other addons. So it's better to use this function
		-- because it calls hooks and is doing some networking
		self.networkRoles = {JESTER}
	end
end
if SERVER then
	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		-- remove normal player loadout
		ply:StripWeapon("weapon_zm_improvised")
		ply:StripWeapon("weapon_zm_carry")
		ply:StripWeapon("weapon_ttt_unarmed")

		
		ply:GiveEquipmentWeapon("weapon_ttt_sloth_claws")
	end     ply:GiveEquipmentItem("ttt2-item_blockdmg")

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		-- give back normal player loadout
		ply:GiveEquipmentWeapon("weapon_zm_improvised")
		ply:GiveEquipmentWeapon("weapon_zm_carry")
		ply:GiveEquipmentWeapon("weapon_ttt_unarmed")

		
		ply:StripWeapon("weapon_ttt_sloth_claws")
		ply:RemoveEquipmentItem("ttt2-item_blockdmg")
	end

	hook.Add("TTT2UpdateSubrole", "UpdateSlothRoleSelect", function(ply, oldSubrole, newSubrole)
		if newSubrole == ROLE_SLOTH then
			ply:SetSubRoleModel("models/player/corpse1.mdl")
		elseif oldSubrole == ROLE_SLOTH then
			ply:SetSubRoleModel(nil)
		end
	end)

--placeholder model btw


	hook.Add("PlayerCanPickupWeapon", "SlothModifyPickupWeapon", function(ply, wep)
		if not IsValid(wep) or not IsValid(ply)
		or ply:GetSubRole() ~= ROLE_SLOTH
		or ply:IsSpec() and ply.IsGhost and ply:IsGhost() then
			return
		end

		if WEPS.GetClass(wep) ~= "weapon_ttt_sloth_claws" then
			return false
		end
	end)



	end)
end
