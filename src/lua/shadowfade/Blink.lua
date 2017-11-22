
Blink.OnInitialized = Alien.OnInitialized
function Blink:OnInitialized()
	Ability.OnInitialized(self)
end

local kEtherealForce = 13.5

-- Why this particular value?
-- Without adrenaline, you will be able to do exactly one step,
-- then you will have to wait to regain 10 energy.
-- After that, you will be left with no energy at all.
--
-- If you use adrenaline, however, you will be able to
-- do it **twice** with no pause inbetween.
function Blink:GetSecondaryEnergyCost()
	return 60 -- original for blink initiation is 14
end

local function PerformBlink(self)
	self.etherealEndTime = Shared.GetTime()
	local celerityLevel = GetHasCelerityUpgrade(self) and GetSpurLevel(player:GetTeamNumber()) or 0

	self:SetVelocity(
		self:GetVelocity() + self:GetViewCords().zAxis * (kEtherealForce + celerityLevel * 1.5)
	)
end

function Blink:OnSecondaryAttack(player)
	local hasEnoughEnergy = player:GetEnergy() >= self:GetSecondaryEnergyCost()
	if hasEnoughEnergy and player:GetBlinkAllowed() then
		player:DeductAbilityEnergy(self:GetSecondaryEnergyCost())
		PerformBlink(player)
	end

	Ability.OnSecondaryAttack(self, player)
end
