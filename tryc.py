import re
d={'a': 'R0', 'b': 'R1', 't1': 'R2'}
counter=3
limit=3
list_of_nums=[]
flag=0
for x in d:
	list_of_nums=[]
	key=x
	value=d[x]
	regex_key = re.search("^R[0-9]+", key)
	regex_value = re.search("^R[0-9]+", value)
	if(regex_key!=None):
		splitz=re.split("R",regex_key);
		list_of_nums.append(int(splitz[1]))
	elif(regex_value!=None):
		splitz=re.split("R",regex_value);
		list_of_nums.append(int(splitz[1]))

for i in range(limit):
	if(i not in list_of_nums):
		flag=1
		break
if(flag==1):
	return i
else:
	limit+=1
	counter+=1
	return counter
	


