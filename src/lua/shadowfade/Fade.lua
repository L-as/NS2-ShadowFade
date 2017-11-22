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
