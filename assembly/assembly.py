import re
import sys

############## GLOBAL VARIABLES #####################
#d is a dictionary that contains key-value pairs of identifiers/temporaries and their associated registers
#var_counter keeps track of the register numbers
#limit is the max number of registers 
global d
global var_counter 
global limit
d = {}
limit=13
var_counter=0

############## FUNCTION TO KEEP TRACK OF THE NEXT UNUSED REGISTER #####################
def counter():
	global d
	global var_counter
	global limit
	list_of_nums=[]
	flag=0
	#Iterate through 'd' (the used registers) and add them to list_of_nums
	for x in d: 
		key=x
		value=d[x]
		splitz=re.split("R",value)
		list_of_nums.append(int(splitz[1]))

	#Iterate through list_of_nums and find the number not assigned to any register
	for i in range(limit):
		if(i not in list_of_nums):
			flag=1
			break
	#Return number
	if(flag==1):
		return i
	else:
		limit+=1
		var_counter+=1
		return var_counter


############## MAIN FUNCTION #####################
if __name__ == "__main__":

    if len(sys.argv) == 2:
        input_file = str(sys.argv[1])

    list_of_lines = []
    prev_op = ""
    f = open(input_file, "r")


    #Iterate through the file and save the lines in a list
    for line in f:
        line = line.strip()
        list_of_lines.append(line)
    f.close()
    print(".text\nmain:\n")


    #Iterate through every line
    for line in list_of_lines:
        #print(d)
       
        #Split the line and find length of split
        split_line = line.split() 
        split_len = len(split_line) 

	# Assignment expression or GOTO expression (of comparision statements)
        if(split_len == 3): 
            result_var = split_line[0] #LHS
            op = split_line[1] #Operator
            value = split_line[2] #RHS

	    #Look for temporary variables
            type_of_var = re.search("^t[0-9]+", result_var) 

	    #Look for variables
            value_type = re.search("^[a-zA-Z]", value) 

	    #If it's a comparision statement
            if(op == "GOTO"): 
                if(prev_op == "<"): #prev_op keeps track of the comparision made; hence decide type of branch
                    prev_op = ""
                    print("BGT ", value)
                elif(prev_op == ">"):
                    prev_op = ""
                    print("BLT ", value)
                elif(prev_op == ">="):
                    prev_op = ""
                    print("BLTE ", value)
                elif(prev_op == "<="):
                    prev_op = ""
                    print("BGTE ", value)
                elif(prev_op == "=="):
                    prev_op = ""
                    print("BEQ ", value)
                elif(prev_op == "!="):
                    prev_op = ""
                    print("BNE ", value)

            #For assignment statement of program variables --> a=3,a=t0
            elif(type_of_var == None):  
		#Assign a register name for LHS
                var_name = "R"+str(var_counter) 

		#If it's a new variable with no associated register, add it to 'd' and load word
                if(result_var not in d): 
                    d[result_var] = var_name 
                    print("LDR ", var_name, ",=", result_var) 

		#Increment counter
                var_counter = counter() 
		#Assign a register name for RHS
                var_name = "R"+str(var_counter)  

		# RHS is a number, move it into register
                if(value_type == None):  
                    print("MOV ", var_name, ",#", value) 
		
		#RHS is a variable/temporary
                else: 

                    var_name = "R"+str(var_counter)
                    value = d[value] 
                    print("MOV ", var_name, ",", value) 
                    var_counter = counter()

                var_name = "R"+str(var_counter)

		#Find the register name of LHS and store it
                var_name2=d[result_var] 
                print("STR ", var_name, ",[", var_name2, "]") 
                print("\n")
                var_counter = counter()

	    # For assignment statement of temp vars --> t0=3
            else:  
                var_name = "R"+str(var_counter)
		#RHS is a number, move it into a register
                if(value_type == None):  
                    print("MOV ", var_name, ",#", value)
	
		#RHS is a variable, means it's already defined; find the register name and move value
                else: 
                    value = d[value]
                    print("MOV ", var_name, ",", value)

		#Add new register to 'd'
                d[result_var] = var_name 
                print("\n")
                var_counter = counter()

	# Evaluation expressions
        elif(split_len == 5):  
            result_var = split_line[0] #LHS
            operand_1 = split_line[2] #Operand1
            op = split_line[3] #Operator
            operand_2 = split_line[4] #Operand2
	    #Check if it's a variable/temp / number
            var = re.search("^[a-zA-Z]", operand_1)
	    #Check if it's a temporary
            checker = re.search("^t[0-9]+", result_var) 
            # print(var)

	    # Operand1 is a number; Assign a register to it
            if(var == None):  
                reg_name1 = "R"+str(var_counter) 
                var_counter = counter()
                print("MOV ", reg_name1, ", #", operand_1)
	
	    #Operand 1 is a variable, find its register
            else:  
                reg_name1 = d[operand_1]
                #print(reg_name1)

            var = re.search("^[a-zA-Z]", operand_2)
            if(var == None):  
                reg_name2 = "R"+str(var_counter)
                var_counter = counter()
                print("MOV ", reg_name2, ",#", operand_2)
            else:  
                reg_name2 = d[operand_2]

	    #Operator is <,set up prev_op for the next branch statement and print the CMP statement
            if(op == '<'): 
                prev_op = "<" 
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter = counter()
                print("\n")
            elif(op == '<='):
                prev_op = "<="
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter = counter()
                print("\n")
            elif(op == '>='):
                prev_op = ">="
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter += 1
                print("\n")
            elif(op == '>'):
                prev_op = ">"
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter = counter()
                print("\n")
            elif(op == '=='):
                prev_op = "=="
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter = counter()
                print("\n")
            elif(op == '!='):
                prev_op = "!="
                print("CMP ", reg_name1, ", ", reg_name2)
                var_name = "R"+str(var_counter)
                d[result_var] = var_name
                var_counter = counter()
                print("\n")

	    
            elif(op == "+"):
                var_counter+=1
                var_name = "R"+str(var_counter)
		#If LHS is a variable, find the register for it and move the value ->k=k+1, to=k+1
                if(checker==None): 
                        result_var3=d[result_var] 
                        print("MOV ", var_name, ",", result_var3)

		#If LHS is a temp
                else: 
			#If LHS has not been assigned a register; assign a register to it and move
                        if(result_var not in d): 
                                var_name = "R"+str(var_counter)
                                d[result_var] = var_name
                                var_counter = counter()
                                newvar=var_name
                                print("MOV ", var_name, ",#0")
			#Else assign the value to the register
                        else:
                                print("MOV ", var_name, ",", result_var)
                d[result_var] = var_name
                print("\n")
                var_counter = counter()
                print("ADD ", var_name, ",", reg_name1, ',', reg_name2)
                print("\n")
            elif(op == "-"): 
		#If LHS is a variable, find the register for it and if it's a temporary, assign a register to it if not already done
                var_counter+=1
                var_name = "R"+str(var_counter)
                if(checker==None):
                        result_var3=d[result_var]
                        print("MOV ", var_name, ",", result_var3)
                else:
                        if(result_var not in d):
                                var_name = "R"+str(var_counter)
                                d[result_var] = var_name
                                var_counter = counter()
                                newvar=var_name
                                print("MOV ", var_name, ",#0")
                        else:
                                print("MOV ", var_name, ",", result_var)
                d[result_var] = var_name
                print("\n")
                var_counter = counter()
                print("SUB ", var_name, ",", reg_name1, ',', reg_name2)
                print("\n")

            elif(op == "*"):
                var_name = "R"+str(var_counter)
                print("MOV ", var_name, ",", result_var)
                d[result_var] = var_name
                print("\n")
                var_counter = counter()
                print("MUL ", var_name, ",", reg_name1, ',', reg_name2)
                print("\n")
            

	#Statement is "GOTO x" or "L0..."
        elif(split_len == 2): 
            result_var = split_line[0]
            value = split_line[1]
	    #Branch
            if(result_var == "GOTO"): 
                print("B ", value)
            else:
                print(line)
            print("\n")
