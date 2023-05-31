%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#define YYDEBUG 0

struct Node{
    char key[100];
    char value[100];
    int childrenNb;
    struct Node* children;
};

struct Node* createKeyChildNode(char key[100], struct Node* child);
struct Node* createKeyValueNode(char key[100], char value[100]);
struct Node* createChildrenNode(struct Node* child1, struct Node* child2);
void printNode(struct Node* node, int level);
void printJSON(struct Node* node, int level, int isFirst);
void fPrintJSON(struct Node* node, int level, int isFirst, FILE* fp);
void calc(struct Node* node);
int eval(struct Node* node);
struct Node* sum(struct Node* node);

struct Node variables[100];
int variableCount = 0;

%}



%union {
  char sValue[100];
  struct Node *nPtr;
};

%token <sValue> STRING_VAL DRAW IF VARIABLE SUM PRINT
%type <sValue> start_tag end_tag 
%type <sValue> if_tag_end variable_tag_end variable_tag sum_tag sum_tag_end
%type <sValue> print_tag print_tag_end
%type <nPtr> statement start_tag_with_value param 
%type <nPtr> statements if_tag params single_tag
%type <nPtr> if_statement variable_statement sum_statement
%type <nPtr> print_statement

%start      program

%%

program : statements '.'          { 
                                    //printJSON($1, 0, 0);
                                    FILE *fp;
                                    fp = fopen("translator_output.txt", "w+");
                                    fPrintJSON($1, 0, 0, fp); 
                                    fclose(fp);
                                    exit(0); 
                                }
        | DRAW statements '.'     { 
                                    FILE *fp;
                                    fp = fopen("translator_output.txt", "w+");
                                    fPrintJSON($2, 0, 0, fp); 
                                    fclose(fp);
                                    system("python draw.py");
                                    exit(0); 
                                }            
        ;

statements : statements statement       {$$ = createChildrenNode($1, $2);}
         | statement                { $$ = $1; }
         ;

statement : start_tag STRING_VAL end_tag    { 
                                                if(YYDEBUG == 0 && strcmp($1, $3) != 0){
                                                    printf("Invalid start-end tags: %s - %s\n", $1, $3);
                                                    exit(1);
                                                }
                                                $$ = createKeyValueNode($1, $2);
                                            }
          | start_tag statements end_tag     { 
                                                if(YYDEBUG == 0 && strcmp($1, $3) != 0){
                                                    printf("Invalid start-end tags: %s - %s\n", $1, $3);
                                                    exit(1);
                                                }
                                                $$ = createKeyChildNode($1, $2);
                                            }
          | start_tag_with_value statements end_tag     
                                            { 
                                                if(YYDEBUG == 0 && strcmp($1->key, $3) != 0){
                                                    printf("Invalid start-end tags: %s - %s\n", $1->key, $3);
                                                    exit(1);
                                                }
                                                if($2->key == NULL || $2->key[0] == '\0'){
                                                    for(int i = 0; i <= $2->childrenNb; ++i){
                                                        $1->children[$1->childrenNb + i] = $2->children[i];
                                                    }
                                                    $1->childrenNb += $2->childrenNb;
                                                } else{
                                                    $1->children[$1->childrenNb] = *$2;
                                                    $1->childrenNb++;
                                                }

                                               
                                                $$ = $1;
                                            }
                               
          | start_tag_with_value end_tag    {
                                                if(YYDEBUG == 0 && strcmp($1->key, $2) != 0){
                                                    printf("Invalid start-end tags: %s - %s\n", $1->key, $2);
                                                    exit(1);
                                                }
                                                $$ = $1;
                                            }
          | single_tag                      { $$ = $1; }
          | if_statement                    { $$ = $1; }
          | variable_statement              { $$ = $1; }
          | sum_statement                   { $$ = $1; }
          | print_statement                 { $$ = $1; }
          ;


if_statement : if_tag statements if_tag_end  {
                                                if (eval($1) == 1){
                                                    $$ = $2;
                                                } else {
                                                    $$ = NULL;
                                                }
                                            };

variable_statement : variable_tag statement variable_tag_end {
                                                                variables[variableCount] = *$2;
                                                                variableCount++;
                                                                $$ = NULL;
                                                            };

sum_statement : sum_tag statement sum_tag_end {
                variables[variableCount] = *sum($2);
                variableCount++;
                $$ = NULL;
            };

print_statement : print_tag STRING_VAL print_tag_end {
                $$ = NULL;
                for (int i = 0; i < variableCount; ++i){
                    if(strcmp(variables[i].key, $2) == 0){
                        $$ = &variables[i];
                    }
                }
            };

single_tag : '<' STRING_VAL params '/' '>'    { $$ = createKeyChildNode($2, $3);}

start_tag_with_value : '<' STRING_VAL params '>' { $$ = createKeyChildNode($2, $3);};
start_tag : '<' STRING_VAL '>'          { strcpy($$, $2); };
end_tag : '<' '/' STRING_VAL '>'    { strcpy($$, $3); };

params : params param               { $$ = createChildrenNode($1, $2); }
       | param                      { $$ = $1; }

param : STRING_VAL '=' '\"' STRING_VAL '\"'   { $$ = createKeyValueNode($1, $4); };

if_tag : '<' IF params '>'    {$$ = createKeyChildNode($2, $3);};
if_tag_end : '<' '/' IF '>'  { strcpy($$, $3); };

variable_tag : '<' VARIABLE '>'          { strcpy($$, $2); };
variable_tag_end : '<' '/' VARIABLE '>'  { strcpy($$, $3); };

sum_tag : '<' SUM '>'          { strcpy($$, $2); };
sum_tag_end : '<' '/' SUM '>'  { strcpy($$, $3); };

print_tag: '<' PRINT '>'     { strcpy($$, $2); };
print_tag_end : '<' '/' PRINT '>'  { strcpy($$, $3); };     

%%

struct Node* createKeyValueNode(char key[100], char value[100]){
    struct Node* p = malloc(sizeof(struct Node));
    strcpy(p->key,key);
    strcpy(p->value,value);
    return p;
}

struct Node* createKeyChildNode(char key[100], struct Node* child){
    if(child->key == NULL || child->key[0] == '\0'){
        strcpy(child->key,key);
        return child;
    }

    struct Node* p = malloc(sizeof(struct Node));
    strcpy(p->key,key);
    p->children = malloc(100 * sizeof(struct Node));
    p->children[0] = *child;
    p->childrenNb = 1;
    return p;
}

struct Node* createChildrenNode(struct Node* child1, struct Node* child2){
    if(child1 == NULL){
        return child2;
    }
    if(child2 == NULL){
        return child1;
    }
    struct Node* p = malloc(sizeof(struct Node));
    p->children = malloc(100 * sizeof(struct Node));
    p->childrenNb = 0;
    if(child1->key == NULL || child1->key[0] == '\0'){
        // add child1's children to p's children
        // remove intermediate key without name
        for (int i = 0; i <= child1->childrenNb; ++i){
            p->children[i] = child1->children[i];
        }
        p->childrenNb = child1->childrenNb;
    } else {
        p->children[p->childrenNb] = *child1;
        p->childrenNb++;
    }

    if(child2->key == NULL || child2->key[0] == '\0'){
        // add child2's children to p's children
        // remove intermediate key without name
        for (int i = 0; i <= child2->childrenNb; ++i){
            p->children[i + p->childrenNb] = child2->children[i];
        }
        p->childrenNb += child2->childrenNb;
    } else {
        p->children[p->childrenNb] = *child2;
        p->childrenNb++;
    }
    return p;
}

void printNode(struct Node* node, int level){
    for(int i = 0; i < level; ++i)
        printf("\t");
    printf("key: %s\n", node->key);
    for(int i = 0; i < level; ++i)
        printf("\t");
    printf("value: %s\n", node->value);
    for (int i = 0; i < node->childrenNb; ++i){
        printNode(node->children + i, level+1);
    } 
}

void printJSON(struct Node* node, int level, int isFirst){
    // print space
    for(int i = 0; i < level; ++i) printf("  ");
    if (isFirst > 0) {
        printf(",");
    }
    // print key
    if(node->key != NULL && node->key[0] != '\0'){
        printf("\"%s\": ", node->key);
    }    // print { if we have subobjects

    if(!(node->value != NULL && node->value[0] != '\0')) printf("{\n");
    // print value if we have just a value
    if(node->value != NULL && node->value[0] != '\0'){
        printf(" \"%s\"\n", node->value);
        return;
    }
    // print subobjects
    for (int i = 0; i < node->childrenNb; ++i){
        printJSON(node->children + i, level+1, i);
    }
    // print space
    for(int i = 0; i < level; ++i) printf("  ");
    // print }
    printf("}\n");
}

void fPrintJSON(struct Node* node, int level, int isFirst, FILE* fp){
    // print space
    for(int i = 0; i < level; ++i) fprintf(fp, "  ");
    if (isFirst > 0) {
        fprintf(fp, ",");
    }
    // print key
    if(node->key != NULL && node->key[0] != '\0'){
        fprintf(fp, "\"%s\": ", node->key);
    }    // print { if we have subobjects

    if(!(node->value != NULL && node->value[0] != '\0')) fprintf(fp, "{\n");
    // print value if we have just a value
    if(node->value != NULL && node->value[0] != '\0'){
        fprintf(fp, " \"%s\"\n", node->value);
        return;
    }
    // print subobjects
    for (int i = 0; i < node->childrenNb; ++i){
        fPrintJSON(node->children + i, level+1, i, fp);
    }
    // print space
    for(int i = 0; i < level; ++i) fprintf(fp, "  ");
    // print }
    fprintf(fp, "}\n");
}

void calc(struct Node* node){
    struct Node* p = malloc(sizeof(struct Node));
    p->children = malloc(100 * sizeof(struct Node));
    p->childrenNb = 0;
    strcpy(p->value, "10");
    strcpy(p->key, "result");
    node->children[node->childrenNb] = *p;
    node->childrenNb++;
}

int eval(struct Node* node){
    struct Node p;
    for(int i = 0; i < variableCount; ++i){
        if(strcmp(variables[i].key, node->children[0].key) == 0){
            p = variables[i];
            break;
        }
    }

    if(strcmp(node->children[0].value, p.value) == 0){
        return 1;
    }
    return 0;
}

struct Node* sum(struct Node* node){
    struct Node* p = malloc(sizeof(struct Node));
    p->childrenNb = 0;
    strcpy(p->key, node->key);
    int s = 0;
    for(int i = 0; i < variableCount; ++i){
        for(int j = 0; j < node->childrenNb; ++j){
            if(strcmp(variables[i].key, node->children[j].value) == 0){
                s += atoi(variables[i].value);
            }
        }
    }
    sprintf(p->value, "%d", s);
    return p;
}



void yyerror(char *s) 
{ 
  fprintf(stdout, "%s\n", s); 
} 

int main(void) 
{
#if YYDEBUG
  yydebug = 1;
#endif
  yyparse();
  return 0; 
}