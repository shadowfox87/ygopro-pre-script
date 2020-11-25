--インフェルニティ・ポーン
--Infernity Pawn
--LUA by Kohana Sonogami
function c100273011.initial_effect(c)
	--Optional
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273011,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c100273011.opcon)
	e1:SetTarget(c100273011.optg)
	e1:SetOperation(c100273011.opop)
	c:RegisterEffect(e1)
end
function c100273011.opcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		and Duel.GetDrawCount(tp)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c100273011.ttopfilter(c)
	return c:IsSetCard(0xb)
end
function c100273011.ssetfilter(c)
	return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100273011.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100273011.ttopfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
	local b2=Duel.IsExistingMatchingCard(c100273011.ssetfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(100273011,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100273011,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c100273011.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax then return end
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100273011,3))
		local g=Duel.SelectMatchingCard(tp,c100273011.ttopfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c100273011.ssetfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end