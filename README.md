# XML to JSON translator project
Lex / Yacc + Python Project which translate XML to JSON, draws objects on screen using Turtle package, and contains a basic script-like behavior, which can create variables, make sums, can use if-statements, and print variables.
## Requirements (Linux):
* Lex / Yacc  
* Python 3 + Turtle Package  
## Additional requirements (Windows Subsystem for Linux):  
* install Xming: https://sourceforge.net/projects/xming/
* run XLaunch with default config (Next=>Next=>Next=>Finish)
* run this command in bash terminal ```export DISPLAY:=0```

## How to run:
```make all``` (handles lex, yacc, and creates exe.)  
```./TRANSLATOR < *INPUT_FILE*```  

JSON Output can be seen in ```translator_output.txt```    

Available input files:
* ```translator_input_draw```  
* ```translator_input_script```  
* ```translator_input_test```    

## Accepted structures:
* Object with value:   
``` <objectName> value </objectName> ```
* Object with subobjects:   
``` 
    <objectName>  
        <subobjectName1>...</suobjectName1>  
        <subobjectName2>...</suobjectName2>  
    </objectName>
    
    <objectName subobjectName1="value" subobjectName2="value" ...> </objectName>
```
## Basic script functions:  
* Variable declaration:
```
    <variable>
        <variableName>
            value
        </variableName>
    </variable>
```  
* If statement:  
```
    <if variableName="variableValue">
        <otherTag1> ... </otherTag1>
        <otherTag2> ... </otherTag2>
    </if>
```  
if ```variableName``` has the value equal with ```variableValue``` then the ```otherTags``` will be executed  
* Print function:
```
    <variable> <a> 10 </a> </variable>
    <print> a </print>
```
* Sum function:  
```
    <variable> <a> 10 </a> </variable>
    <variable> <b> 11 </b> </variable>    
    <variable> <c> 12 </c> </variable>    
    <sum>
        <d>
            <it>a</it>
            <it>b</it>
            <it>c</it>
        </d>
    </sum>
```  
creates a new variable d, and stores the sum of the variables a, b, c 
## Draw functonallity:
