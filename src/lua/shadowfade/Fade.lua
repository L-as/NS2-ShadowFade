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

local kBlinkDuration = 2

function Fade:GetIsBlinking()
	return false
end

function Fade:GetCanJump()
	return self:GetIsOnGround()
end

function Fade:GetGroundFriction()
	return math.min(Shared.GetTime() - self.etherealEndTime, kBlinkDuration) / kBlinkDuration * 9
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
