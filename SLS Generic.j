library SaveLoadGeneric

globals
    integer user_custom_int_0
    integer user_custom_int_1
    integer user_custom_int_2

    private unit player_unit
    private unit player_bag

    private integer save_count = 5
    
    private integer character_count = 3
    
    private string MAP_ID = "JFT"
    private string SECRET_KEY = "74f6b1f2-6c42-4be6-8d71-8ab7979e9153"

    private string user_id
    
    private integer current_character_index = -1
    
    private string array character_data_str[12][3]
    private string array resource_data_str[12]
    
    private string character_index = "character_index"
    private string resource = "resource"
    
    
    constant integer CHARACTER_DATA_FLAG = 0
    constant integer CHARACTER_DATA_UNIT_TYPE = 1
    constant integer CHARACTER_DATA_LEVEL = 2
    constant integer CHARACTER_DATA_EXP = 3
    constant integer CHARACTER_DATA_STR = 4
    constant integer CHARACTER_DATA_AGI = 5
    constant integer CHARACTER_DATA_INT = 6
    constant integer CHARACTER_DATA_USER_ITEM_0 = 7
    constant integer CHARACTER_DATA_USER_ITEM_1 = 8
    constant integer CHARACTER_DATA_USER_ITEM_2 = 9
    constant integer CHARACTER_DATA_USER_ITEM_3 = 10
    constant integer CHARACTER_DATA_USER_ITEM_4 = 11
    constant integer CHARACTER_DATA_USER_ITEM_5 = 12
    constant integer CHARACTER_DATA_BAG_ITEM_0 = 13
    constant integer CHARACTER_DATA_BAG_ITEM_1 = 14
    constant integer CHARACTER_DATA_BAG_ITEM_2 = 15
    constant integer CHARACTER_DATA_BAG_ITEM_3 = 16
    constant integer CHARACTER_DATA_BAG_ITEM_4 = 17
    constant integer CHARACTER_DATA_BAG_ITEM_5 = 18
    constant integer CHARACTER_DATA_HERO_STATE = 19
    
    constant integer CHARACTER_DATA_GOLD = 1
    constant integer CHARACTER_DATA_LUMBER = 2
endglobals

// ===== Battle Net Check =====
function Is_Battle_Net takes nothing returns boolean
    if JNGetConnectionState() == 1112425812 then
        return true
    else
        return false
    endif
endfunction

// ===== SET =====

function Set_Save_Count takes integer value returns nothing
    set save_count = value
endfunction

function Set_Current_Character_Index takes integer index returns nothing
    set current_character_index = index
endfunction

function Set_Player_Bag takes integer pid, unit u returns nothing
    if GetLocalPlayer() == Player(pid) then
        set player_bag = u
    endif
endfunction

function Set_Player_Unit takes integer pid, unit u returns nothing
    if GetLocalPlayer() == Player(pid) then
        set player_unit = u
    endif
endfunction

function Set_Resource_Data_String takes integer pid, string str returns nothing
    set resource_data_str[pid] = str
endfunction

function Set_Character_Data_String takes integer pid, integer index, string str returns nothing
    set character_data_str[pid][index] = str
endfunction

function Set_User_ID takes string str returns nothing
    set user_id = str
endfunction

// ===== GET =====

function Get_Save_Count takes nothing returns integer
    return save_count
endfunction

function Get_Current_Character_Index takes nothing returns integer
    return current_character_index
endfunction

function Get_Player_Bag takes nothing returns unit
    return player_bag
endfunction

function Get_Player_Unit takes nothing returns unit
    return player_unit
endfunction

function Get_Resource_Data_Property takes integer pid, integer property returns string
    return JNStringSplit(resource_data_str[pid], "/", property)
endfunction

function Get_Character_Data_Property takes integer pid, integer index, integer property returns string
    return JNStringSplit(character_data_str[pid][index], "/", property)
endfunction

function Get_Resource_String takes nothing returns string
    return resource
endfunction

function Get_Characater_Index takes integer index returns string
    return character_index + I2S(index)
endfunction

function Get_Character_Data_String takes integer pid, integer index returns string
    return character_data_str[pid][index]
endfunction

function Get_User_Id takes nothing returns string
    return user_id
endfunction

function Get_Secret_Key takes nothing returns string
    return SECRET_KEY
endfunction

function Get_Map_Id takes nothing returns string
    return MAP_ID
endfunction

function Get_Character_Count takes nothing returns integer
    return character_count
endfunction

endlibrary