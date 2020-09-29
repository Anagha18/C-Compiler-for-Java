
echo "Starting the execution"

echo "Generating symbol table"
cd ast
lex lex.l
yacc -d parser.y -w
gcc -lfl lex.yy.c y.tab.c -w
./a.out < ../input.java > ast.txt
clear
cd ..
echo "Completed constructing abstract syntax tree"

cd icg
lex lex.l
yacc -d parser.y
gcc -lfl lex.yy.c y.tab.c -w
./a.out < ../input.java > icg.txt
cd ..
echo "Completed generating intermediate code"

echo "Moving on to optimize code"
cd co
python try.py ../icg/icg.txt > oc.txt
python3 afterco.py oc.txt > final.txt
echo "Intermediate code has been optimized"
cd ..
echo "Generating Assembly code"
cd assembly
python3 assembly.py ../co/final.txt > result.txt
echo "Assembly code generated"



