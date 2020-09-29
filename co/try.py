import re
import sys


########## Function to remove common subexpressions ################
def remove_sub(noLines) :
	exp = expr(noLines)
	lines = len(noLines)
	newLines = noLines
	for i in range(lines) :
		split_tok = noLines[i].split()
		if len(split_tok) == 5 :
			rhs = split_tok[2] + " " + split_tok[3] + " " + split_tok[4]
			if rhs in exp and exp[rhs] != split_tok[0]: #If RHS in 'exp' and LHS != value of 'exp'
				newLines[i] = split_tok[0] + " " + split_tok[1] + " " + exp[rhs]
	return newLines

########## Function to divide line of code into result and associated expressions ################


def expr(noLines) :
	exp = {} #dictionary to store expressions in RHS with key RHS and value LHS
	var = {} #dictionary to store variables in LHS with key var and value RHS 
	for line in noLines :
		split_tok = line.split()
		if len(split_tok) == 5 : #Tokens of length 5 imply evaluation expressions
			if split_tok[0] in var and var[split_tok[0]] in exp : #If LHS already in 'vars' and RHS in 'exp'
				del exp[var[split_tok[0]]] #Delete that expression as value might be different
			rhs = split_tok[2] + " " + split_tok[3] + " " + split_tok[4] #RHS
			if rhs not in exp : #RHS not in 'exp'
				exp[rhs] = split_tok[0] #Add it to 'exp'
				if is_var(split_tok[2]) : #If Op1 is a var, add it to 'vars' with RHS
					var[split_tok[2]] = rhs
				if is_var(split_tok[4]) : #If Op2 is a var, add it to 'vars' with RHS
					var[split_tok[4]] = rhs
	return exp

########## Function for constant folding ################

def fold(noLines) :

	newLines = []
	for line in noLines :
		newLines.append(evaluate_exp(line))
	return newLines

########## Function to evaluate expressions ################


def evaluate_exp(line) :
	split_tok = line.split()
	#Length = 5 means not an evaluation expression
	if len(split_tok) != 5 :
		return line
	#Ignore if not an assigment expression
	if split_tok[1] != "=" or split_tok[3] not in {"+", "-", "*", "/", "*", "&", "|", "^", "==", ">=", "<=", "!=", ">", "<"}:
		return line
	#If RHS only has values, evalute
	if split_tok[2].isdigit() and split_tok[4].isdigit() :
		result = eval(str(split_tok[2] + split_tok[3] + split_tok[4]))
		return " ".join([split_tok[0], split_tok[1], str(result)])

	return line
	
is_var = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s)) 				

if __name__ == "__main__" :

	file = str(sys.argv[1])
	noLines = []
	f = open(file, "r")
	flag=0
	

	#Iterate through the output of ICG and store the lines in a list
	for line in f :
		#print("in loop")
		#print(type(line))
		if(line=="1234\n"):
			#print("flag  now 1")
			flag=1
		elif(flag):
			if(line=="\n"):
				continue
			noLines.append(line)
		else:
			continue
	f.close()
	#print(noLines)

#Removal of common subexpressions
	part_1 = remove_sub(noLines)
#Constant folding
	part_2 = fold(part_1)
	

	for line in part_2 :
		print(line.strip())
	

