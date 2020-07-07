local function ulx.redeem( caller, targets, silent )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team == TEAM_UNDEAD then
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
redeem:addHelp( "Redeem target(s)." )
