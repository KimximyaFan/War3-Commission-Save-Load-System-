library SaveLoadSave requires SaveLoadGeneric, SaveLoadPreprocess

private function Resource_Data_String_Build takes integer pid returns string
    local string str = "100/"
    
    set str = str + I2S( GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD ) ) + "/"
    set str = str + I2S( GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_LUMBER ) ) + "/"
    
    return str
endfunction

private function Character_Data_String_Build takes integer pid returns string
    local string str = "100/"
    local integer i
    
    // 유닛 타입 저장
    set str = str + I2S( GetUnitTypeId(Get_Player_Unit()) ) + "/"
    
    // 유닛 레벨 저장
    set str = str + I2S( GetHeroLevel(Get_Player_Unit()) ) + "/"
    
    // 유닛 경험치 저장
    set str = str + I2S( GetHeroXP(Get_Player_Unit()) ) + "/"
    
    // 유닛 힘 저장
    set str = str + I2S( GetHeroStr(Get_Player_Unit(), false) ) + "/"
    
    // 유닛 민 저장
    set str = str + I2S( GetHeroAgi(Get_Player_Unit(), false) ) + "/"
    
    // 유닛 지 저장
    set str = str + I2S( GetHeroInt(Get_Player_Unit(), false) ) + "/"
    
    // 유닛 아이템 저장
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 5
        if UnitItemInSlot(Get_Player_Unit(), i) != null then
            set str = str + I2S( GetItemTypeId(UnitItemInSlot(Get_Player_Unit(), i)) ) + "/"
        else
            set str = str + I2S( -1 ) + "/"
        endif
    endloop
    
    // 창고 아이템 저장
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 5
        if UnitItemInSlot(Get_Player_Bag(), i) != null then
            set str = str + I2S( GetItemTypeId(UnitItemInSlot(Get_Player_Bag(), i)) ) + "/"
        else
            set str = str + I2S( -1 ) + "/"
        endif
    endloop
    
    set str = str + I2S( udg_Hero_State[pid+1] ) + "/"
    
    return str
endfunction

function Save_Load_Save takes integer pid returns nothing
    if Get_Save_Count() <= 0 then
        call BJDebugMsg("세이브 횟수 다씀")
        return
    endif
    
    call Set_Save_Count( Get_Save_Count() - 1 )
    
    if Is_Battle_Net() == false then
        return
    endif
    
    // 커스텀 인트 저장
    call JNObjectUserSetInt(Get_User_Id(), "user_drop_int", udg_Player_Drop_INT[pid+1])
    call JNObjectUserSetInt(Get_User_Id(), "user_gold_int", udg_Player_Gold_INT[pid+1])
    call JNObjectUserSave( Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), "0" )
    
    // 캐릭터 정보 저장
    call JNSetSaveCode( Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), Get_Characater_Index(Get_Current_Character_Index()), Character_Data_String_Build(pid) )
    
    // 리소스 정보 저장
    call JNSetSaveCode( Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), Get_Resource_String(), Resource_Data_String_Build(pid) )
    
    call BJDebugMsg("저장됨")
endfunction

endlibrary