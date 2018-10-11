import time, DAN, requests, random

ServerIP = '140.113.199.202' #Change to your IoTtalk IP or None for autoSearching
Reg_addr=None #None # if None, Reg_addr = MAC address

DAN.profile['dm_name']='Dummy_Device'
DAN.profile['df_list']=['Dummy_Sensor', 'Dummy_Control','OneParameter','OneParameter']
DAN.profile['d_name']= None # None for autoNaming
DAN.device_registration_with_retry(ServerIP, Reg_addr)

max_counter = 10
#Initializing difference time list
diff_list = []
for i in range(max_counter):
    diff_list.append(0)
counter = 0

while True:
    try:
    #Pull data from a device feature called "Dummy_Control"
        value1=DAN.pull('Dummy_Control')
        if value1 != None:
            received_time = time.time()
            counter = counter + 1
            #Circular counter
            if counter == max_counter:
                counter = 0
            diff_list[counter] = received_time - value1[0][0]
            sum = 0
            for datas in diff_list:
                sum = sum + datas
            print('Time Delay Average: ', diff_list)
        
        time.sleep(0.1)
    #Push data to a device feature called "Dummy_Sensor"
        value2 = []
        value2.append(time.time())
        value2.append(random.uniform(1.1, 10))
        DAN.push ('Dummy_Sensor', value2)

    except Exception as e:
        print(e)
        DAN.device_registration_with_retry(ServerIP, Reg_addr)