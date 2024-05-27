function Print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

function PrintRed(msg)
	Print(msg, 1.0, 0.2, 0.2)
end

function PrintWhite(msg)
	Print(msg, 1.0, 1.0, 1.0)
end

function ManaTickRule_OnLoad()
	this:RegisterEvent("UNIT_MANA")

	this:SetWidth(PlayerFrameManaBar:GetWidth())
	this:SetHeight(PlayerFrameManaBar:GetHeight())

	this.startTime = GetTime();
	this.maxValue = this.startTime + 5;

	this.fiveSecondRule = false
	this.isHidden = true
	this.currMana = UnitMana("player")
end

function ManaTickRule_OnEvent()
	if event == "UNIT_MANA" then
		if tonumber(UnitManaMax("player")) == 100 then 
			this:Hide()
			this.isHidden = true
			return
		end
		if this.isHidden then 
			this:Show()
			this.isHidden = false
		end

		local mana = UnitMana("player")
		if this.currMana > mana then
			this.fiveSecondRule = true
			local time = GetTime()
			this.startTime = time
			this.maxValue = this.startTime + (this.fiveSecondRule and 6 or 5);
		else
			this.fiveSecondRule = false
			local time = GetTime()
			this.startTime = time
			this.maxValue = this.startTime + 2;
		end

		this.currMana = mana
	end
end

function ManaTickRule_OnUpdate()
	if (UnitManaMax("player") > UnitMana("player")) then
		local time = GetTime()
		local sparkPosition = ((time - this.startTime) / (this.maxValue - this.startTime)) * this:GetWidth();
		if ( sparkPosition < 0 ) then
			sparkPosition = 0;
		end
		ManaTickRuleFrame_spark:SetPoint("CENTER", ManaTickRuleFrame, "LEFT", sparkPosition, 0);
	else
		this:Hide()
		this.isHidden = true
	end
end