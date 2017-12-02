
Blink.OnInitialized = Alien.OnInitialized
function Blink:OnInitialized()
	Ability.OnInitialized(self)
end

local kEtherealForce    = 13.5
local kEtherealCooldown = 0.08

function Blink:GetSecondaryEnergyCost()
	return 20 -- original for blink is `14 + 32 * seconds`
end

local function PerformBlink(self, player)
	self.etherealEndTime = Shared.GetTime()
	local celerityLevel = GetHasCelerityUpgrade(self) and GetSpurLevel(player:GetTeamNumber()) or 0

	local dir = self:GetViewCoords().zAxis

	self:TriggerEffects("shadow_step", {effecthostcoords = Coords.GetLookIn(self:GetOrigin(), dir)})
	self:SetVelocity(
		self:GetVelocity() + dir * (kEtherealForce + celerityLevel * 1.5)
	)
end

function Blink:OnSecondaryAttack(player)
	local hasEnoughEnergy = player:GetEnergy() >= self:GetSecondaryEnergyCost()
	if (
		player:GetEnergy() >= self:GetSecondaryEnergyCost() and
		player:GetBlinkAllowed() and
		Shared.GetTime() - player.etherealEndTime >= kEtherealCooldown
	) then
		player:DeductAbilityEnergy(self:GetSecondaryEnergyCost())
		PerformBlink(player, player)
	end

	Ability.OnSecondaryAttack(self, player)
end
