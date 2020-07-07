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

				gamemode.Call( "SpawnBossZombie", target )

				target:SetPos( pos )
				target:SetAngles( ang )
			else
				gamemode.Call( "SpawnBossZombie", target )
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
