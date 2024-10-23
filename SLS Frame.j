library SaveLoadFrame requires SaveLoadNewCharacter, SaveLoadBuild, SaveLoadSave

globals
    private integer load_box
    private integer array load_buttons
    
    private integer save_box
    private integer save_button
    
    private boolean array is_empty
endglobals

private function Save_Button_Clicked takes nothing returns nothing
    local integer clicked_frame = DzGetTriggerUIEventFrame()
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    call Save_Load_Save(pid)
endfunction

private function New_Chacter_Sync takes nothing returns nothing
    local string sync_str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_str, "/", 0) )
    
    call Save_Load_New_Character(pid)
endfunction

private function Load_Chacter_Sync takes nothing returns nothing
    local string sync_str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_str, "/", 0) )
    local integer current_character_index = S2I( JNStringSplit(sync_str, "/", 1) )
    
    call Save_Load_Build(pid, current_character_index)
endfunction

private function Load_Button_Clicked takes nothing returns nothing
    local integer clicked_frame = DzGetTriggerUIEventFrame()
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local integer button_index = S2I( JNStringSplit(DzFrameGetName(clicked_frame), "/", 1) )
    
    call DzFrameShow(load_box, false)
    
    call Set_Current_Character_Index(button_index)
    call DzFrameShow(save_button, true)
    
    if is_empty[button_index] == true then
        call DzSyncData("new", I2S(pid) + "/" )
    else
        call DzSyncData("load", I2S(pid) + "/" + I2S(Get_Current_Character_Index()) )
    endif
endfunction

private function Save_Frames takes nothing returns nothing
    // 위치 조절 (중앙 기준)
    local real x_position = -0.3
    local real y_position = -0.1
    // 버튼 크기 조절
    local real width = 0.04
    local real height = 0.04
    
    set save_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(save_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, x_position, y_position)
    call DzFrameSetSize(save_button, width, height)
    call DzFrameSetText(save_button, "save")
    call DzFrameSetScriptByCode(save_button, JN_FRAMEEVENT_CONTROL_CLICK, function Save_Button_Clicked, false)
    call DzFrameShow(save_button, false)
endfunction

private function Load_Frames takes nothing returns nothing
    local integer button_count = Get_Character_Count()
    local real button_width = 0.12
    local real button_height = 0.05
    local real button_y_pad = 0.06
    local integer i
    local integer pid
    local string name
    local string level
    local string temp
    
    set load_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(load_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetSize(load_box, 0.20, 0.30)
    call DzFrameShow(load_box, true)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= button_count
        set load_buttons[i] = DzCreateFrameByTagName("GLUETEXTBUTTON", "LoadButton/" + I2S(i), load_box, "ScriptDialogButton", 0)
        call DzFrameSetPoint(load_buttons[i], JN_FRAMEPOINT_TOP, load_box, JN_FRAMEPOINT_TOP, 0.0, -0.07 - button_y_pad * i)
        call DzFrameSetSize(load_buttons[i], button_width, button_height)
        call DzFrameSetScriptByCode(load_buttons[i], JN_FRAMEEVENT_CONTROL_CLICK, function Load_Button_Clicked, false)
        call DzFrameShow(load_buttons[i], true)
        
        set pid = -1
        loop 
        set pid = pid + 1
        exitwhen pid >= 12
            if GetPlayerController(Player(pid)) == MAP_CONTROL_USER and GetPlayerSlotState(Player(pid)) == PLAYER_SLOT_STATE_PLAYING then
                // 각플
                if GetLocalPlayer() == Player(pid) then
                    set temp = Get_Character_Data_Property(pid, i, CHARACTER_DATA_FLAG)

                    if temp == "100" then
                        set name = Get_Name_From_Unit_Type( Get_Character_Data_Property(pid, i, CHARACTER_DATA_UNIT_TYPE) )
                        set level = Get_Character_Data_Property(pid, i, CHARACTER_DATA_LEVEL)
                        call DzFrameSetText(load_buttons[i], name + ", Level : " + level )
                        set is_empty[i] = false
                    else
                        call DzFrameSetText(load_buttons[i], "빈 캐릭터" )
                        set is_empty[i] = true
                    endif
                endif
            endif
        endloop
    endloop
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    // 새 캐릭터 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "new", false)
    call TriggerAddAction( trg, function New_Chacter_Sync )
    
    // 캐릭터 로드 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load", false)
    call TriggerAddAction( trg, function Load_Chacter_Sync )
    
    set trg = null
endfunction

function Save_Load_Frame_Init takes nothing returns nothing
    call Sync_Trigger_Init()
    call Load_Frames()
    call Save_Frames()
endfunction

endlibrary