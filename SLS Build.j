library SaveLoadBuild requires SaveLoadGeneric, SaveLoadPreprocess

globals
    private real unit_start_x = -23758
    private real unit_start_y = 28700
endglobals

function Save_Load_Build takes integer pid, integer current_character_index returns nothing
    local integer unit_type = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_UNIT_TYPE ) )
    local integer unit_exp = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_EXP ) )
    local integer unit_str = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_STR ) )
    local integer unit_agi = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_AGI ) )
    local integer unit_int = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_INT ) )
    local unit u
    local integer item_type
    local integer i
    
    // 리소스 로드
    call AdjustPlayerStateBJ( S2I( Get_Resource_Data_Property( pid, CHARACTER_DATA_GOLD ) ), Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    call AdjustPlayerStateBJ( S2I( Get_Resource_Data_Property( pid, CHARACTER_DATA_LUMBER ) ), Player(pid), PLAYER_STATE_RESOURCE_LUMBER )
    
    // 영웅 유닛 로드
    set u = CreateUnit(Player(pid), unit_type, unit_start_x, unit_start_y, 270)
    call AddHeroXP(u, unit_exp, true)
    call SetHeroStr(u, unit_str, true)
    call SetHeroAgi(u, unit_agi, true)
    call SetHeroInt(u, unit_int, true)
    
    // 영웅 아이템 로드
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 6
        set item_type = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_USER_ITEM_0 + i ) )
        
        if item_type != -1 then
            call UnitAddItemToSlotById(u, item_type, i )
        endif
    endloop
    
    // 창고 아이템 로드
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 6
        set item_type = S2I( Get_Character_Data_Property( pid, current_character_index, CHARACTER_DATA_BAG_ITEM_0 + i ) )
        
        if item_type != -1 then
            call UnitAddItemToSlotById(Get_Player_Bag(), item_type, i )
        endif
    endloop
    
    call Set_Player_Unit(pid, u)
    
    set udg_Player_Hero[pid+1] = u
    set udg_Hero_State[pid+1] = S2I( Get_Character_Data_Property(pid, current_character_index, CHARACTER_DATA_HERO_STATE ) )
endfunction

endlibrary