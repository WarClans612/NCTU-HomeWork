# # coding: utf-8

# # json to csv
# * "**\$WORKDIR**" is our working direction
# * This script should run in "**\$WORKDIR/logfile/json/**"
# * Transfer "**\$WORKDIR/logfile/json/*.json**" to "**\$WORKDIR/logfile/table/*.csv**"

# In[17]:


import json
import pandas as pd
from pandas.io.json import json_normalize
f = open('2018-12-08-0309.json','r')
r = json.loads(f.read())


# In[18]:


# Insert first table to tables(DataFrame)
tables = json_normalize(r['feeds'])
#tables.to_csv('../table/2018-12-08-0309.csv', sep=',')
#tables


# In[19]:


# list all processed table 
processedList = get_ipython().getoutput('(ls ../table/*.csv)')
for i, c in enumerate(processedList):
    processedList[i] = c.split('/')[-1].split('.')[0]
#print('processed json:\n')
#print(processedList.nlstr)
#print('-'*20)


# In[20]:


# list all json files in current directory
jsonList = get_ipython().getoutput('(ls *.json)')
print('all json:\n')
print(jsonList.nlstr)
print('-'*20)


# In[21]:


# list not processed json files
print('not processed yet:\n')
for filename in jsonList[1:]:
    if (filename[:-5]) not in processedList:
        print(filename)
print('-'*20)


# In[22]:


# Transfer json to csv 
for filename in jsonList[1:]: 
    #print(filename[:-5])
    if (filename[:-5]) in processedList:
        pass
    else:
        # Open json file
        file = open(filename, 'r')
        r = json.loads(file.read())
        processedName = '../table/' + filename[:-5] + '.csv'
        
        # put json into pd.DataFrame
        table = json_normalize(r['feeds'])
        
        # write DataFrame to csv
        table.to_csv(processedName, sep=',')
        
        tables = pd.concat([tables, table])


# In[23]:


# Check result

# Refresh processedList
processedList = get_ipython().getoutput('(ls ../table/*.csv)')
for i, c in enumerate(processedList):
    processedList[i] = c.split('/')[-1].split('.')[0]

# list not processed json files
print('(After) not processed yet:\n')
for filename in jsonList[1:]:
    if (filename[:-5]) not in processedList:
        print(filename)
print('-'*20)


