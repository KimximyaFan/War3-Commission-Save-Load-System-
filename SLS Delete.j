library SaveLoadDelete requires SaveLoadGeneric

private function Save_Data_Delete takes nothing returns nothing
    local integer pid = GetPlayerId( GetTriggerPlayer() )
    
    if GetLocalPlayer() == Player(pid) then
        call JNSetSaveCode( Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), Get_Characater_Index(Get_Current_Character_Index()), "-1" )
    endif
endfunction

function Save_Load_Delete_Init takes nothing returns nothing
    local trigger trg
    local integer i
    
    set trg = CreateTrigger()
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 12
        call TriggerRegisterPlayerChatEvent( trg, Player(i), "-캐릭터 삭제", true )
    endloop
    
    call TriggerAddAction(trg, function Save_Data_Delete)
endfunction

endlibrary