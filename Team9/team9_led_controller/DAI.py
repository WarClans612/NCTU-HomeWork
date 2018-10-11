import time, DAN, requests, random

#Initialize value
supported_modes = ['0', '1', '2', '3', '4', '5']
modes = 5
led_number = 5
max_state = 100
state = 0

def mode_0(state, value1):
    '''Modes for temperature'''
    if value1 is not None and value1[1] is not None:
        for i in range(5):
            DAN.push('Team9_led' + str(i+1), *(int(value1[1][i]) for j in range(3)))

def mode_1(state, value1):
    '''Static color for LED'''
    comb = {
        'Team9_led1': (1, 0, 0),
        'Team9_led2': (0, 1, 0),
        'Team9_led3': (0, 0, 1),
        'Team9_led4': (1, 0, 1),
        'Team9_led5': (1, 1, 0)
    }
    for key, value in comb.items():
        DAN.push(key, *value)
    
def mode_2(state, value1):
    '''Shifting color'''
    needed_state = 5
    comb = {
        'Team9_led1': (1, 0, 0),
        'Team9_led2': (1, 1, 0),
        'Team9_led3': (0, 1, 1),
        'Team9_led4': (1, 0, 1),
        'Team9_led5': (0, 1, 0)
    }
    shifter = int(state//(max_state/needed_state))
    for num in range(led_number):
        wanted = 'Team9_led' + str((num + shifter) % led_number + 1)
        DAN.push(wanted, *comb['Team9_led' + str(num+1)])
        
def mode_3(state, value1):
    import random
    '''Random mode'''
    for num in range(led_number):
        DAN.push('Team9_led' + str(num+1), *tuple(random.choice([0, 1]) for i in range(3)))

def mode_4(state, value1):
    '''All rainbow'''
    needed_state = 6
    comb = {
        '1': (1, 0, 0), 
        '2': (1, 1, 0), 
        '3': (0, 1, 0), 
        '4': (0, 1, 1), 
        '5': (0, 0, 1), 
        '6': (1, 0, 1), 
    }
    shifter = int(state//(max_state/needed_state))
    for num in range(led_number):
        DAN.push('Team9_led' + str(num+1), *(comb[str(shifter+1)]))
        
def mode_5(state, value1):
    '''Moving rainbow'''
    needed_state = 6
    comb = {
        '1': (1, 0, 0), 
        '2': (1, 1, 0), 
        '3': (0, 1, 0), 
        '4': (0, 1, 1), 
        '5': (0, 0, 1), 
        '6': (1, 0, 1), 
    }
    shifter = int(state//(max_state/needed_state))
    leds_on = int(state//5)%led_number
    for num in range(led_number):
        if num == leds_on:
            DAN.push('Team9_led' + str(num+1), *(comb[str(shifter+1)]))
        else:
            DAN.push('Team9_led' + str(num+1), 0, 0, 0)

def state_control(state):
    state = state + 1
    return state % max_state
    
ServerIP = '140.113.199.200' #Change to your IoTtalk IP or None for autoSearching
Reg_addr=None #None # if None, Reg_addr = MAC address

DAN.profile['dm_name']='Team9_led_controller'
DAN.profile['df_list']=['Team9_led1', 'Team9_led2', 'Team9_led3', 'Team9_led4', 'Team9_led5', 'Team9_led_control','ThreeParameter','ThreeParameter','ThreeParameter','ThreeParameter','ThreeParameter','OneParameter']
DAN.profile['d_name']= None # None for autoNaming
DAN.device_registration_with_retry(ServerIP, Reg_addr)

while True:
    try:
    #Pull data from a device feature called "Dummy_Control"
        value1=DAN.pull('Team9_led_control')
        if value1 is not None:
            value1 = value1[0]
        if value1 is not None:
            #Check input modes correctness
            if value1[0] in supported_modes:
                modes = value1[0]
            else:
                print('Invalid input. Resume work')
                continue
            print ('Input modes: ', value1[0])
            
        #Call function that correspond to the correct modes
        globals()['mode_' + str(modes)](state, value1)

        time.sleep(0.1)
        state = state_control(state)
    #Push data to a device feature called "Dummy_Sensor"

    except Exception as e:
        print(e)
        DAN.device_registration_with_retry(ServerIP, Reg_addr)