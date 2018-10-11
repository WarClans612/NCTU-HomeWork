import time, DAN, requests, random

ServerIP = '140.113.199.205' #Change to your IoTtalk IP or None for autoSearching
Reg_addr= '0416106' #None # if None, Reg_addr = MAC address

DAN.profile['dm_name']='0416106'
DAN.profile['df_list']=['0416106', 'OneParameter']
DAN.profile['d_name']= None # None for autoNaming
DAN.device_registration_with_retry(ServerIP, Reg_addr)

face = None
while True:
    try:
    #Pull data from a device feature called "Dummy_Control"
        value1=DAN.pull('0416106')
        if value1 != None:
            if value1[0][2] > 0:
                input_face = 'up'
            else:
                input_face = 'down'
            
            if face == None:
                face = input_face
                print ("Smartphone facing {orientation}".format(orientation=face))
            if face == 'down' and input_face == 'up':
                print ("Smartphone facing up")
                face = 'up'
            elif face == 'up' and input_face == 'down':
                print ("Smartphone facing down")
                face = 'down'

    except Exception as e:
        print(e)
        DAN.device_registration_with_retry(ServerIP, Reg_addr)

    time.sleep(0.2)
