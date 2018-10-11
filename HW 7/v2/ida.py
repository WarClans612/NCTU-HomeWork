import random
import time
from dan import NoData

### The register server host, you can use IP or Domain.
host = '140.113.199.198'

### [OPTIONAL] The register port, default = 9992
# port = 9992

### [OPTIONAL] If not given or None, server will auto-generate.
# device_name = 'Dummy_Test'

### [OPTIONAL] If not given or None, DAN will register using a random UUID.
### Or you can use following code to use MAC address for device_addr.
# from uuid import getnode
# device_addr = "{:012X}".format(getnode())
#device_addr = "aa8e5b58-8a9b-419b-b8d5-72624d61108d"

### [OPTIONAL] If not given or None, this device will be used by anyone.
username = 'WarClans'

### The Device Model in IoTtalk, please check IoTtalk document.
device_model = 'Dummy_Device'

### The input/output device features, please check IoTtalk document.
idf_list = ['Dummy_Sensor']
odf_list = ['Dummy_Control']

### Set the push interval, default = 1 (sec)
### Or you can set to 0, and control in your feature input function.
push_interval = 1  # global interval
interval = {
    'Dummy_Sensor': 1,  # assign feature interval
}

def register_callback():
    print('register successfully')

def Dummy_Sensor():
    value2 = []
    value2.append(time.time())
    value2.append(random.uniform(1.1, 10))
    return value2

def Dummy_Control(value1):  # value1 is a list
    from dai import counter, max_counter, diff_list
    received_time = time.time()
    counter = counter + 1
    #Circular counter
    if counter == max_counter:
        counter = 0
    diff_list[counter] = received_time - value1[0][0]
    sum = 0
    for datas in diff_list:
        sum = sum + datas
    print('Time Delay Average: ', sum/max_counter)