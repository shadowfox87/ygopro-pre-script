--聖なる煌炎
--Holy Knight Blast
--LUA by Kohana Sonogami
function c100270049.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270049,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100270049+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100270049.condition)
	e1:SetCost(c100270049.cost)
	e1:SetTarget(c100270049.target)
	e1:SetOperation(c100270049.activate)
	c:RegisterEffect(e1)
end
function c100270049.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainDisablable(ev)
end
function c100270049.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(7) and c:IsRace(RACE_DRAGON) 
		and c:IsAbleToHandAsCost()
end
function c100270049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100270049.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c100270049.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c100270049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100270049.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() and Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
