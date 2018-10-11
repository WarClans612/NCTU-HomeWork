import time, DAN, requests, random

ServerIP = '140.113.199.205' #Change to your IoTtalk IP or None for autoSearching
Reg_addr=None #None # if None, Reg_addr = MAC address

DAN.profile['dm_name']='Dummy_Device'
DAN.profile['df_list']=['Dummy_Sensor', 'Dummy_Control','OneParameter','ThreeParameter']
DAN.profile['d_name']= None # None for autoNaming
DAN.device_registration_with_retry(ServerIP, Reg_addr)

switcher = False
while True:
    try:
    #Pull data from a device feature called "Dummy_Control"
        value1=DAN.pull('Dummy_Control')
        if value1 != None:
            if value1[0] == 1:
                switcher = True
            elif value1[0] == 0:
                switcher = False

            if switcher == True:
                print (value1[0])

    #Push data to a device feature called "Dummy_Sensor"
        value2=random.uniform(1.1, 10)
        DAN.push ('Dummy_Sensor', value2)

    except Exception as e:
        print(e)
        DAN.device_registration_with_retry(ServerIP, Reg_addr)

    time.sleep(0.2)
