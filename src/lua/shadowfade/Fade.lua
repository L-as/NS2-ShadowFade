for _, v in ipairs {
	"shadowStepping",
	"timeShadowStepping",
	"shadowStepping",
	"timeShadowStep",
	"shadowStepDirection",
	"shadowStepSpeed",
	"etherealStartTime",
	"etherealEndTime",
	"ethereal",
	"landedAfterBlink",
	--"timeMetabolize",
	"timeOfLastPhase",
	"hasEtherealGate",

} do
	gModClassMap.Fade.networkVars[v] = nil
end

local kBlinkDuration                 = 2
local kGroundFriction                = 9
local kGroundFrictionCelerityScaling = .5
local kAirFriction                   = .17
local kAirFrictionCelerityScaling    = .01

local function GetCelerityLevel(self)
	return GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0
end

function Fade:GetIsBlinking()
	return false
end

function Fade:GetCanJump()
	return self:GetIsOnGround()
end

function Fade:GetGroundFriction()
	return math.min(Shared.GetTime() - self.etherealEndTime, kBlinkDuration) / kBlinkDuration * kGroundFriction - GetCelerityLevel(self) * kGroundFrictionCelerityScaling
end

function Fade:GetAirFriction()
	return math.min(Shared.GetTime() - self.etherealEndTime, kBlinkDuration) / kBlinkDuration * kAirFriction    - GetCelerityLevel(self) * kAirFrictionCelerityScaling
end

local old = Fade.OnInitialized
function Fade:OnInitialized()
	old(self)

	self.isBlinking		   = false
	self.shadowStepping    = false
	self.ethereal		   = false

	self.timeShadowStep    = -1000
	self.etherealStartTime = -1000
	self.etherealEndTime   = -1000
	self.timeOfLastPhase   = -1000

	self.landedAfterBlink  = true
end

function Fade:OnUpdateAnimationInput(modelMixin)
	if self:GetHasMetabolizeAnimationDelay() then
		local weapon = self:GetActiveWeapon()
		if weapon ~= nil and weapon:GetMapName() == Metabolize.kMapName then
			weapon:OnUpdateAnimationInput(modelMixin)
		end
	else
		Alien.OnUpdateAnimationInput(self, modelMixin)
	end
end
