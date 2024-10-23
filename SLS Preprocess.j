library SaveLoadPreprocess requires SaveLoadGeneric

function Get_Name_From_Unit_Type takes string unit_type_str returns string
    local integer unit_type = S2I(unit_type_str)
    local string unit_name
    
    if unit_type == 'AAAA' then
        set unit_name = "박철흠"
    elseif unit_type == 'AAAB' then
        set unit_name = "복재성"
    endif
    
    return "테스트 이름"
endfunction

// =====================================================================

private function User_Resource_Data_Sync takes nothing returns nothing
    local string sync_str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_str, "#", 0) )
    local string data_str = JNStringSplit(sync_str, "#", 1)
    
    call Set_Resource_Data_String( pid, data_str )
endfunction

private function User_Character_Data_Sync takes nothing returns nothing
    local string sync_str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_str, "#", 0) )
    local integer index = S2I( JNStringSplit(sync_str, "#", 1) )
    local string data_str = JNStringSplit(sync_str, "#", 2)

    call Set_Character_Data_String( pid, index, data_str )
endfunction

private function User_Custom_Int_Sync takes nothing returns nothing
    local string sync_str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_str, "#", 0) )
    local integer drop_int = S2I( JNStringSplit(sync_str, "#", 1) )
    local integer gold_int = S2I( JNStringSplit(sync_str, "#", 2) )

    set udg_Player_Drop_INT[pid+1] = drop_int
    set udg_Player_Gold_INT[pid+1] = gold_int
endfunction

private function User_Resource_Data_Register takes integer pid returns nothing
    call DzSyncData( "rsrc", I2S(pid) + "#" + JNGetLoadCode(Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), Get_Resource_String()) )
endfunction

private function User_Character_Data_Register takes integer pid, integer index returns nothing
    call DzSyncData( "char", I2S(pid) + "#" + I2S(index) + "#" + JNGetLoadCode(Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), Get_Characater_Index(index)) )
endfunction

private function User_Custom_Int_Register takes integer pid returns nothing
    local boolean is_data_exist = false
    local string drop_int
    local string gold_int
    
    call JNObjectUserInit( Get_Map_Id(), Get_User_Id(), Get_Secret_Key(), "0" )
    
    if Get_Character_Data_Property(pid, 0, CHARACTER_DATA_FLAG) == "100" then
        set is_data_exist = true
    endif
    
    if Get_Character_Data_Property(pid, 1, CHARACTER_DATA_FLAG) == "100" then
        set is_data_exist = true
    endif
    
    if Get_Character_Data_Property(pid, 2, CHARACTER_DATA_FLAG) == "100" then
        set is_data_exist = true
    endif
    
    if is_data_exist == true then
        set drop_int = I2S(JNObjectUserGetInt(Get_User_Id(), "user_drop_int"))
        set gold_int = I2S(JNObjectUserGetInt(Get_User_Id(), "user_gold_int"))

        call DzSyncData( "cusint", I2S(pid) + "#" + drop_int + "#" + gold_int )
    endif
endfunction

// 유저의 아이디 기록
private function User_Id_Register takes integer j returns nothing
    if JNCheckNameHack( GetPlayerName( Player(j) ) ) == false then
        call Set_User_ID( GetPlayerName( Player(j) ) )
    endif
endfunction

// 유저 데이터들을 일단 로드해온후 기록
private function User_Data_Load takes nothing returns nothing
    local integer count = Get_Character_Count()
    local integer pid
    local integer index
    
    // 일단 잘 모르니 1번 플레이어 부터 12번 플레이어까지 돌림
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid >= 12
        
        // 실제 사용자인지 판별하는 if 문
        if GetPlayerController(Player(pid)) == MAP_CONTROL_USER and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING then
            // 각플
            if GetLocalPlayer() == Player(pid) then
                call User_Id_Register(pid)
                
                call User_Resource_Data_Register(pid)
                
                set index = -1
                loop
                set index = index + 1
                exitwhen index >= count
                    call User_Character_Data_Register(pid, index)
                endloop
                
                call User_Custom_Int_Register(pid)
            endif
        endif
    endloop
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    // 캐릭터 정보 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "char", false)
    call TriggerAddAction( trg, function User_Character_Data_Sync )
    
    // 리소스 정보 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "rsrc", false)
    call TriggerAddAction( trg, function User_Resource_Data_Sync )
    
    // 커스텀 정수 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "cusint", false)
    call TriggerAddAction( trg, function User_Custom_Int_Sync )
    
    set trg = null
endfunction

private function Player_Bag_Settting takes nothing returns nothing
    local integer pid
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        call Set_Player_Bag(pid, udg_Player_Bag[pid+1])
    endloop
endfunction

function Save_Load_Preprocess_Init takes nothing returns nothing
    
    if Is_Battle_Net() == false then
        return
    endif
    
    call Player_Bag_Settting()
    call Sync_Trigger_Init()
    call User_Data_Load()
endfunction

endlibrary