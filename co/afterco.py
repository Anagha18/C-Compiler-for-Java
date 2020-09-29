import re
import sys

############## TO CONVERT GOTO <LINE NUMBER> TO GOTO <L0,L1...> AND INSERTION OF L0,L1... AT LINE NUMBERS ##############

if __name__ == "__main__" :

	if len(sys.argv) == 2 :
		input_file = str(sys.argv[1])
	f = open(input_file, "r")
	list_of_lines = [] 
	#Iterate through input and store in a list
	for line in f :
		line=line.strip()
		list_of_lines.append(line)
	f.close()
	counter=0 #Line numbers
	var_counter=0
	len_of_lines=len(list_of_lines)
	list_of_linej=[] #List of lines to jump to
	d={}
	list_of_goto=[] #List of lines that have "GOTO"
	for line in list_of_lines:	
		split_line=line.split()
		split_len=len(split_line)
		if(split_len==3):#LENGTH 3
			result_var=split_line[0] #LHS
			op=split_line[1] #OPERATOR
			value=split_line[2] #RHS
			if(op=="GOTO"):
				line_to_jump=int(value) #RHS is line number to jump to
				list_of_linej.append(line_to_jump)
				list_of_goto.append(counter) #Line number where GOTO occurs
			counter+=1
		elif(split_len==2): #LENGTH 2
			value=split_line[1] #RHS
			line_to_jump=int(value)
			list_of_linej.append(line_to_jump)
			list_of_goto.append(counter)
			counter+=1
		else:
			counter+=1
	list_of_linej=list(set(list_of_linej)) #Get unique line numbers
	list_of_linej.sort()
	#print(list_of_linej)
	#print(list_of_goto)

	counter=0
	for line in list_of_lines:
		#print("\n")
		#print(counter)
		#print(line)
		if(counter in list_of_linej): #If you come across a line that is being jumped to, insert L<number>
			var_name="L"+str(var_counter)
			var_counter+=1
			print(var_name,":")
			print(line)
			
		elif(counter in list_of_goto): #If GOTO appears in line
			split_line=line.split()
			split_len=len(split_line)
			if(split_len==3): 
				result_var=split_line[0]
				op=split_line[1]
				value=split_line[2]
				if(op=="GOTO"): #Insert appropriate L<number> by refering to list of line jumps
					value=int(value)
					ind=list_of_linej.index(value)
					var_name="L"+str(ind)			
					value=var_name
					print(result_var,"",op,"",value)
				else:
					print(line)
			elif(split_len==2):
				result_var=split_line[0]
				value=split_line[1]
				value=int(value)
				ind=list_of_linej.index(value)
				var_name="L"+str(ind)			
				value=var_name
				print(result_var,value)
		else:
			print(line)
		counter+=1
		#Add SWI 0x11 in the end; end of ARM program
		if(counter>=len_of_lines):
			if(counter in list_of_linej):
				ind=list_of_linej.index(counter)
				var_name="L"+str(ind)	
				print(var_name,":")
			print("SWI 0X11")	
			
