function ulx.redeem( caller, targets, silent )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			target:Redeem( silent )
			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A redeemed #T", affected )
end

local redeem = ulx.command( "ZS ULX Commands", "ulx redeem", ulx.redeem, "!redeem" )
redeem:addParam{ type = ULib.cmds.PlayersArg }
redeem:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "silent" }
redeem:defaultAccess( ULib.ACCESS_ADMIN )
redeem:help( "Redeem target(s)" )


function ulx.forceboss( caller, targets, silent, inPlace )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			if inPlace then
				local pos = target:GetPos()
				local ang = target:GetAngles()

				gamemode.Call( "SpawnBossZombie", target, silent )

				target:SetPos( pos )
				target:SetAngles( ang )
			else
				gamemode.Call( "SpawnBossZombie", target, silent )
			end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be boss", affected )
end

local forceboss = ulx.command( "ZS ULX Commands", "ulx forceboss", ulx.forceboss, "!forceboss" )
forceboss:addParam{ type = ULib.cmds.PlayersArg }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "silent" }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place" }
forceboss:defaultAccess( ULib.ACCESS_ADMIN )
forceboss:help( "Respawn target(s) as boss" )


local ZombieClasses

function ulx.forceclass( caller, targets, className, inPlace )
	local class = ZombieClasses[ className ]
	if not class then
		ULib.tsayError( caller, "No such class \"" .. className .. "\"!" )
		return
	end

	local classIndex = class.Index

	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			if inPlace then
				local pos = target:GetPos()
				local ang = target:GetAngles()

				-- copied from GM:SpawnBossZombie
				target:KillSilent()
				target:SetZombieClass( classIndex )
				target:DoHulls( classIndex, TEAM_UNDEAD )
				target:UnSpectateAndSpawn()

				target:SetPos( pos )
				target:SetAngles( ang )
			else
				target:KillSilent()
				target:SetZombieClass( classIndex )
				target:DoHulls( classIndex, TEAM_UNDEAD )
				target:UnSpectateAndSpawn()
			end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be #s", affected, className )
end

-- these commands depend on data that doesn't exist until the gamemode is fully loaded
hook.Add( "Initialize", "zs_ulx_cmds",
	function()
		local GAMEMODE = gmod.GetGamemode()

		ZombieClasses = GAMEMODE.ZombieClasses

		local forceclassCompletes = {}
		for k in pairs( ZombieClasses ) do
			if isstring( k ) then
				table.insert( forceclassCompletes, k )
			end
		end

		local forceclass = ulx.command( "ZS ULX Commands", "ulx forceclass", ulx.forceclass, "!forceclass" )
		forceclass:addParam{ type = ULib.cmds.PlayersArg }
		forceclass:addParam{ type = ULib.cmds.StringArg, hint = "class", completes = forceclassCompletes, ULib.restrictToCompletes }
		forceclass:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place" }
		forceclass:defaultAccess( ULib.ACCESS_ADMIN )
		forceclass:help( "Respawn target(s) as the specified class" )
	end
)
