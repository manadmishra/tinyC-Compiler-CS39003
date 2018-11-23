%{
    #include "ass6_16CS30019_translator.h"
    void yyerror(const char*);
    extern int yylex(void);
    using namespace std;
%}


%union{
    int intval;   
    char charval; 
    idStr idl;    
    float floatval; 
    string *strval; 
    decStr decl;   
    arglistStr argsl; 
    int instr;  
    expresn expon;   
    list *nextlist; 
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN
%token FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH
%token TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY
%token POINTER INCREMENT DECREMENT LEFT_SHIFT RIGHT_SHIFT LESS_EQUALS GREATER_EQUALS EQUALS NOT_EQUALS
%token AND OR ELLIPSIS MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN
%token LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SINGLE_LINE_COMMENT MULTI_LINE_COMMENT
%token <idl> ID  
%token <intval> INT_CONSTANT
%token <floatval> FLOAT_CONSTANT
%token <strval> ENUMERATION_CONSTANT
%token <charval> CHAR_CONST
%token <strval> STRING_LITERAL
%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression logical_or_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer identifier_opt declaration init_declarator_list init_declarator_list_opt init_declarator
%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement block_item_list_opt
%type <argsl> argument_expression_list argument_expression_list_opt
%type <decl> type_specifier declaration_specifiers specifier_qualifier_list type_name pointer pointer_opt
%type <instr>       M
%type <nextlist>    N
%type <charval>     unary_operator

%start translation_unit

%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY
%nonassoc IF_CONFLICT
%nonassoc ELSE

%%
M:
{
    $$ = next_instr;
};

N:
{
    $$ = makelist(next_instr);
    glob_quad.emit(Q_GOTO, -1);
};

primary_expression:             ID {
                                                
                                                symdata * check_func = glob_st->search(*$1.name);
                                                if(check_func == NULL)
                                                {
                                                    $$.loc  =  curr_st->lookup_2(*$1.name);
                                                    if($$.loc->tp_n != NULL && $$.loc->tp_n->basetp == tp_arr)
                                                    {
                                                        $$.arr = $$.loc;
                                                        $$.loc = curr_st->gentemp(new type_n(tp_int));
                                                        $$.loc->i_val.int_val = 0;
                                                        $$.loc->isInitialized = true;
                                                        glob_quad.emit(Q_ASSIGN,0,$$.loc->name);
                                                        $$.type = $$.arr->tp_n;
                                                        $$.poss_array = $$.arr;
                                                    }
                                                    else
                                                    {
                                                        
                                                        $$.type = $$.loc->tp_n;
                                                        $$.arr = NULL;
                                                        $$.isPointer = false;
                                                    }
                                                }
                                                else
                                                {
                                                    
                                                    $$.loc = check_func;
                                                    $$.type = check_func->tp_n;
                                                    $$.arr = NULL;
                                                    $$.isPointer = false;
                                                }
                                            } |
                                INT_CONSTANT {
                                                    $$.loc  = curr_st->gentemp(new type_n(tp_int));
                                                    $$.type = $$.loc->tp_n;
                                                    $$.loc->i_val.int_val = $1;
                                                    $$.loc->isInitialized = true;
                                                    $$.arr = NULL;
                                                    glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                                } |
                                FLOAT_CONSTANT {
                                                    $$.loc  = curr_st->gentemp(new type_n(tp_double));
                                                    $$.type = $$.loc->tp_n;
                                                    $$.loc->i_val.double_val = $1;
                                                    $$.loc->isInitialized = true;
                                                    $$.arr = NULL;
                                                    glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                                  } |
                                CHAR_CONST {
                                                $$.loc  = curr_st->gentemp(new type_n(tp_char));
                                                $$.type = $$.loc->tp_n;
                                                $$.loc->i_val.char_val = $1;
                                                $$.loc->isInitialized = true;
                                                $$.arr = NULL;
                                                glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                            } |
                                STRING_LITERAL {
                                                    
                                                    strings_label.push_back(*$1);
                                                    $$.loc = NULL;
                                                    $$.isString = true;
                                                    $$.ind_str = strings_label.size()-1;
                                                    $$.arr = NULL;
                                                    $$.isPointer = false;
                                                } |
                                '(' expression ')' {
                                                        $$ = $2;
                                                   };

enumeration_constant:           ID {};

postfix_expression :            primary_expression {
                                                         $$ = $1;
                                                    } |
                                postfix_expression '[' expression ']' {
                                        
                                                                        $$.loc = curr_st->gentemp(new type_n(tp_int));
                                                                        
                                                                        symdata* temporary = curr_st->gentemp(new type_n(tp_int));
                                                                        
                                                                        char temp[10];
                                                                        sprintf(temp,"%d",$1.type->next->getSize());
                                                                        
                                                                        glob_quad.emit(Q_MULT,$3.loc->name,temp,temporary->name);
                                                                        glob_quad.emit(Q_PLUS,$1.loc->name,temporary->name,$$.loc->name);
                                                                        
                                                                        
                                                                        $$.arr = $1.arr;
                                                                        $$.type = $1.type->next;
                                                                        $$.poss_array = NULL;

                                                                     } |
                                postfix_expression '(' argument_expression_list_opt ')' {
                                                                                            if(!$1.isPointer && !$1.isString && ($1.type) && ($1.type->basetp==tp_void))
                                                                                            {
                                                                                                
                                                                                            }
                                                                                            else
                                                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                                            char str[10];
                                                                                            if($3.arguments == NULL)
                                                                                            {
                                                                                                sprintf(str,"0");
                                                                                                if($1.type->basetp!=tp_void)
                                                                                                    glob_quad.emit(Q_CALL,$1.loc->name,str,$$.loc->name);
                                                                                                else
                                                                                                    glob_quad.emit2(Q_CALL,$1.loc->name,str);
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if((*$3.arguments)[0]->isString)
                                                                                                {
                                                                                                    str[0] = '_';
                                                                                                    sprintf(str+1,"%d",(*$3.arguments)[0]->ind_str);
                                                                                                    glob_quad.emit(Q_PARAM,str);
                                                                                                    glob_quad.emit(Q_CALL,$1.loc->name,"1",$$.loc->name);
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    for(int i=0;i<$3.arguments->size();i++)
                                                                                                    {
                                                                                                        if((*$3.arguments)[i]->poss_array != NULL && $1.loc->name != "printi")
                                                                                                            glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->poss_array->name);
                                                                                                        else
                                                                                                            glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->loc->name);
                                                                        
                                                                                                    }
                                                                                                    sprintf(str,"%ld",$3.arguments->size());
                                                                                                    if($1.type->basetp!=tp_void)
                                                                                                        glob_quad.emit(Q_CALL,$1.loc->name,str,$$.loc->name);
                                                                                                    else
                                                                                                        glob_quad.emit2(Q_CALL,$1.loc->name,str);
                                                                                                }
                                                                                            }

                                                                                            $$.arr = NULL;
                                                                                            $$.type = $$.loc->tp_n;
                                                                                         } |
                                postfix_expression '.' ID {}|
                                postfix_expression POINTER ID {
                                                                            /*----*/
                                                                      } |
                                postfix_expression INCREMENT {
                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                if($1.arr != NULL)
                                                                {
                                                                    symdata * temp_elem = curr_st->gentemp(CopyType($1.type));
                                                                    glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                                    glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
                                                                    glob_quad.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
                                                                    glob_quad.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);
                                                                    glob_quad.emit(Q_PLUS,$1.loc->name,"1",$1.loc->name);    
                                                                }
                                                                $$.type = $$.loc->tp_n;                                 
                                                             } |
                                postfix_expression DECREMENT {
                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                if($1.arr != NULL)
                                                                {
                                                                    symdata * temp_elem = curr_st->gentemp(CopyType($1.type));
                                                                    glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                                    glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
                                                                    glob_quad.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
                                                                    glob_quad.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);
                                                                    glob_quad.emit(Q_MINUS,$1.loc->name,"1",$1.loc->name);
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                              } |
                                '(' type_name ')' '{' initializer_list '}' {
                                                                                /*------*/
                                                                           }|
                                '(' type_name ')' '{' initializer_list ',' '}' {
                                                                                    /*------*/
                                                                               };

argument_expression_list:       assignment_expression {
                                                        $$.arguments = new vector<expresn*>;
                                                        expresn * tex = new expresn($1);
                                                        $$.arguments->push_back(tex);
                                                     }|
                                argument_expression_list ',' assignment_expression {
                                                                                        expresn * tex = new expresn($3);
                                                                                        $$.arguments->push_back(tex);
                                                                                    };

argument_expression_list_opt:   argument_expression_list {
                                                            $$ = $1;
                                                          }|
                                /*epsilon*/ {
                                                $$.arguments = NULL;
                                            };

unary_expression:               postfix_expression {
                                                        $$ = $1;
                                                   }|
                                INCREMENT unary_expression {
                                                                $$.loc = curr_st->gentemp($2.type);
                                                                if($2.arr != NULL)
                                                                {
                                                                    symdata * temp_elem = curr_st->gentemp(CopyType($2.type));
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
                                                                    glob_quad.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
                                                                    glob_quad.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_PLUS,$2.loc->name,"1",$2.loc->name);
                                                                    glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                            }|
                                DECREMENT unary_expression {
                                                                $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                if($2.arr != NULL)
                                                                {
                                                                    symdata * temp_elem = curr_st->gentemp(CopyType($2.type));
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
                                                                    glob_quad.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
                                                                    glob_quad.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_MINUS,$2.loc->name,"1",$2.loc->name);
                                                                    glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                            }|
                                unary_operator cast_expression
                                                                {
                                                                    type_n * temp_type;
                                                                    switch($1)
                                                                    {
                                                                        case '&':
                                                                            temp_type = new type_n(tp_ptr,1,$2.type);
                                                                            $$.loc = curr_st->gentemp(CopyType(temp_type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            glob_quad.emit(Q_ADDR,$2.loc->name,$$.loc->name);
                                                                            $$.arr = NULL;
                                                                            break;
                                                                        case '*':
                                                                            $$.isPointer = true;
                                                                            $$.type = $2.loc->tp_n->next;
                                                                            $$.loc = $2.loc;
                                                                            $$.arr = NULL;
                                                                            break;
                                                                        case '+':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                            break;
                                                                        case '-':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            glob_quad.emit(Q_UNARY_MINUS,$2.loc->name,$$.loc->name);
                                                                            break;
                                                                        case '~':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            glob_quad.emit(Q_NOT,$2.loc->name,$$.loc->name);
                                                                            break;
                                                                        case '!':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            $$.truelist = $2.falselist;
                                                                            $$.falselist = $2.truelist;
                                                                            break;
                                                                        default:
                                                                            break;
                                                                    }
                                                                }|
                                SIZEOF unary_expression {}|
                                SIZEOF '(' type_name ')' {};

unary_operator  :               '&' {
                                        $$ = '&';
                                    }|
                                '*' {
                                        $$ = '*';
                                    }|
                                '+' {
                                        $$ = '+';
                                    }|
                                '-' {
                                        $$ = '-';
                                    }|
                                '~' {
                                        $$ = '~';
                                    }|
                                '!' {
                                        $$ = '!';
                                    };

cast_expression :               unary_expression {
                                                    if($1.arr != NULL && $1.arr->tp_n != NULL&& $1.poss_array==NULL)
                                                    {
                                                        $$.loc = curr_st->gentemp(new type_n($1.type->basetp));
                                                        glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                        $$.arr = NULL;
                                                        $$.type = $$.loc->tp_n;
                                                    }
                                                    else if($1.isPointer == true)
                                                    {
                                                        $$.loc = curr_st->gentemp(CopyType($1.type));
                                                        $$.isPointer = false;
                                                        glob_quad.emit(Q_RDEREF,$1.loc->name,$$.loc->name);
                                                    }
                                                    else
                                                        $$ = $1;
                                                }|
                                '(' type_name ')' cast_expression{
                                                                    /*--------*/
                                                                 };

multiplicative_expression:      cast_expression {
                                                    $$ = $1;
                                                }|
                                multiplicative_expression '*' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    glob_quad.emit(Q_MULT,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                              }|
                                multiplicative_expression '/' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    glob_quad.emit(Q_DIVIDE,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                              }|
                                multiplicative_expression '%' cast_expression{
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    glob_quad.emit(Q_MODULO,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                             };

additive_expression :           multiplicative_expression {
                                                                $$ = $1;
                                                          }|
                                additive_expression '+' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        glob_quad.emit(Q_PLUS,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                  }|
                                additive_expression '-' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        glob_quad.emit(Q_MINUS,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                  };

shift_expression:               additive_expression {
                                                        $$ = $1;
                                                    }|
                                shift_expression LEFT_SHIFT additive_expression {
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    glob_quad.emit(Q_LEFT_OP,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                }|
                                shift_expression RIGHT_SHIFT additive_expression{
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    glob_quad.emit(Q_RIGHT_OP,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                };

relational_expression:          shift_expression {
                                                        $$ = $1;
                                                 }|
                                relational_expression '<' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                $$.type = new type_n(tp_bool);
                                                                                $$.truelist = makelist(next_instr);
                                                                                $$.falselist = makelist(next_instr+1);
                                                                                glob_quad.emit(Q_IF_LESS,$1.loc->name,$3.loc->name,"-1");
                                                                                glob_quad.emit(Q_GOTO,"-1");
                                                                           }|
                                relational_expression '>' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                $$.type = new type_n(tp_bool);
                                                                                $$.truelist = makelist(next_instr);
                                                                                $$.falselist = makelist(next_instr+1);
                                                                                glob_quad.emit(Q_IF_GREATER,$1.loc->name,$3.loc->name,"-1");
                                                                                glob_quad.emit(Q_GOTO,"-1");
                                                                           }|
                                relational_expression LESS_EQUALS shift_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        $$.falselist = makelist(next_instr+1);
                                                                                        glob_quad.emit(Q_IF_LESS_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                        glob_quad.emit(Q_GOTO,"-1");
                                                                                    }|
                                relational_expression GREATER_EQUALS shift_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            $$.falselist = makelist(next_instr+1);
                                                                                            glob_quad.emit(Q_IF_GREATER_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                      };

equality_expression:            relational_expression {
                                                            $$ = $1;
                                                      }|
                                equality_expression EQUALS relational_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        $$.falselist = makelist(next_instr+1);
                                                                                        glob_quad.emit(Q_IF_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                        glob_quad.emit(Q_GOTO,"-1");
                                                                                 }|
                                equality_expression NOT_EQUALS relational_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            $$.falselist = makelist(next_instr+1);
                                                                                            glob_quad.emit(Q_IF_NOT_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                     };

and_expression :                equality_expression {
                                                        $$ = $1;
                                                    }|
                                and_expression '&' equality_expression {
                                                                            $$.loc = curr_st->gentemp($1.type);
                                                                            $$.type = $$.loc->tp_n;
                                                                            glob_quad.emit(Q_LOG_AND,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                        };

exclusive_or_expression:        and_expression {
                                                    $$ = $1;
                                               }|
                                exclusive_or_expression '^' and_expression {
                                                                                $$.loc = curr_st->gentemp($1.type);
                                                                                $$.type = $$.loc->tp_n;
                                                                                glob_quad.emit(Q_XOR,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                           };

inclusive_or_expression:        exclusive_or_expression {
                                                            $$ = $1;
                                                        }|
                                inclusive_or_expression '|' exclusive_or_expression {
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        glob_quad.emit(Q_LOG_OR,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    };

logical_and_expression:         inclusive_or_expression {
                                                            $$ = $1;
                                                        }|
                                logical_and_expression AND M inclusive_or_expression {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4);
                                                                                        backpatch($1.truelist,$3);
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        $$.falselist = merge($1.falselist,$4.falselist);
                                                                                        $$.truelist = $4.truelist;
                                                                                    };

logical_or_expression:          logical_and_expression {
                                                            $$ = $1;
                                                       }|
                                logical_or_expression OR M logical_and_expression   {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4); 
                                                                                        backpatch($1.falselist,$3);
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        $$.truelist = merge($1.truelist,$4.truelist);
                                                                                        $$.falselist = $4.falselist;
                                                                                    };

conditional_expression:         logical_or_expression {
                                                            $$ = $1;
                                                      }|
                                logical_or_expression N '?' M expression N ':' M conditional_expression {
                                                                                                            $$.loc = curr_st->gentemp($5.type);
                                                                                                            $$.type = $$.loc->tp_n;
                                                                                                            glob_quad.emit(Q_ASSIGN,$9.loc->name,$$.loc->name);
                                                                                                            list* TEMP_LIST = makelist(next_instr);
                                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                                            backpatch($6,next_instr);
                                                                                                            glob_quad.emit(Q_ASSIGN,$5.loc->name,$$.loc->name);
                                                                                                            TEMP_LIST = merge(TEMP_LIST,makelist(next_instr));
                                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                                            backpatch($2,next_instr);
                                                                                                            conv2Bool(&$1);
                                                                                                            backpatch($1.truelist,$4);
                                                                                                            backpatch($1.falselist,$8);
                                                                                                            backpatch(TEMP_LIST,next_instr);
                                                                                                        };

assignment_operator:            '='                                                     |
                                MULTIPLY_ASSIGN                                         |
                                DIVIDE_ASSIGN                                           |
                                MODULO_ASSIGN                                           |
                                ADD_ASSIGN                                              |
                                SUBTRACT_ASSIGN                                         |
                                LEFT_SHIFT_ASSIGN                                       |
                                RIGHT_SHIFT_ASSIGN                                      |
                                AND_ASSIGN                                              |
                                XOR_ASSIGN                                              |
                                OR_ASSIGN                                               ;

assignment_expression:          conditional_expression {
                                                            $$ = $1;
                                                        }|
                                unary_expression assignment_operator assignment_expression {
                                                                                                if($1.isPointer)
                                                                                                {
                                                                                                    glob_quad.emit(Q_LDEREF,$3.loc->name,$1.loc->name);
                                                                                                }
                                                                                                typecheck(&$1,&$3,true);
                                                                                                if($1.arr != NULL)
                                                                                                {
                                                                                                    glob_quad.emit(Q_LINDEX,$1.loc->name,$3.loc->name,$1.arr->name);
                                                                                                }
                                                                                                else if(!$1.isPointer)
                                                                                                    glob_quad.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);
                                                                                                $$.loc = curr_st->gentemp($3.type);
                                                                                                $$.type = $$.loc->tp_n;
                                                                                                glob_quad.emit(Q_ASSIGN,$3.loc->name,$$.loc->name);
                                                                                            };

/*A constant value of this expression exists*/
constant_expression:            conditional_expression {
                                                            $$ = $1;
                                                       };

expression :                    assignment_expression {
                                                            $$ = $1;
                                                      }|
                                expression ',' assignment_expression {
                                                                        $$ = $3;
                                                                     };

/*Declarations*/ 

declaration:                    declaration_specifiers init_declarator_list_opt ';' {
                                                                                        if($2.loc != NULL && $2.type != NULL && $2.type->basetp == tp_func)
                                                                                        {
                                                                                            curr_st = new symtab();
                                                                                        }
                                                                                    };

init_declarator_list_opt:       init_declarator_list {
                                                        if($1.type != NULL && $1.type->basetp == tp_func)
                                                        {
                                                            $$ = $1;
                                                        }
                                                     }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                            };

declaration_specifiers:         storage_class_specifier declaration_specifiers_opt {}|
                                type_specifier declaration_specifiers_opt               |
                                type_qualifier declaration_specifiers_opt {}|
                                function_specifier declaration_specifiers_opt {};

declaration_specifiers_opt:     declaration_specifiers                                  |
                                /*epsilon*/                                             ;

init_declarator_list:           init_declarator {
                                                    $$ = $1;
                                                }|
                                init_declarator_list ',' init_declarator                ;

init_declarator:                declarator {
                                                if($1.type != NULL && $1.type->basetp == tp_func)
                                                {
                                                    $$ = $1;
                                                }
                                            }|
                                declarator '=' initializer {
                                                                if($3.type!=NULL)
                                                                {
                                                                if($3.type->basetp==tp_int)
                                                                {
                                                                    $1.loc->i_val.int_val= $3.loc->i_val.int_val;
                                                                    $1.loc->isInitialized = true;
                                                                    symdata *temp_ver=curr_st->search($1.loc->name);
                                                                    if(temp_ver!=NULL)
                                                                    {
                                                                    temp_ver->i_val.int_val= $3.loc->i_val.int_val;
                                                                    temp_ver->isInitialized = true;
                                                                    }
                                                                }
                                                                else if($3.type->basetp==tp_char)
                                                                {
                                                                    $1.loc->i_val.char_val= $3.loc->i_val.char_val;
                                                                    $1.loc->isInitialized = true;
                                                                    symdata *temp_ver=curr_st->search($1.loc->name);
                                                                    if(temp_ver!=NULL)
                                                                    {temp_ver->i_val.char_val= $3.loc->i_val.char_val;
                                                                        temp_ver->isInitialized = true;
                                                                    }
                                                                }
                                                                }
                                                                glob_quad.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);
                                                            };

storage_class_specifier:        EXTERN {}|
                                STATIC {}|
                                AUTO {}|
                                REGISTER {};

type_specifier:                 VOID {
                                        glob_type = new type_n(tp_void);
                                    }|
                                CHAR {
                                        glob_type = new type_n(tp_char);
                                    }|
                                SHORT {}|
                                INT {
                                        glob_type = new type_n(tp_int);
                                    }|
                                LONG {}|
                                FLOAT {}|
                                DOUBLE {
                                            glob_type = new type_n(tp_double);
                                        }|
                                SIGNED {}|
                                UNSIGNED {}|
                                BOOL {}|
                                COMPLEX {}|
                                IMAGINARY {}|
                                enum_specifier {};

specifier_qualifier_list:       type_specifier specifier_qualifier_list_opt {
                                                                                /*----------*/
                                                                            }|
                                type_qualifier specifier_qualifier_list_opt {}; 

specifier_qualifier_list_opt:   specifier_qualifier_list {}|
                                /*epsilon*/ {};

enum_specifier:                 ENUM identifier_opt '{' enumerator_list '}' {}|
                                ENUM identifier_opt '{' enumerator_list ',' '}' {}|
                                ENUM ID {};

identifier_opt:                 ID {
                                                $$.loc  = curr_st->lookup(*$1.name);
                                                $$.type = new type_n(glob_type->basetp);
                                            }|
                                /*epsilon*/ {};

enumerator_list:                enumerator {}|
                                enumerator_list ',' enumerator {};

enumerator:                     enumeration_constant {}|
                                enumeration_constant '=' constant_expression {};

type_qualifier:                 CONST {}|
                                RESTRICT {}|
                                VOLATILE {};

function_specifier:             INLINE {};

declarator :                    pointer_opt direct_declarator {
                                                                if($1.type == NULL)
                                                                {
                                                                    /*--------------*/
                                                                }
                                                                else
                                                                {
                                                                    if($2.loc->tp_n->basetp != tp_ptr)
                                                                    {
                                                                        type_n * test = $1.type;
                                                                        while(test->next != NULL)
                                                                        {
                                                                            test = test->next;
                                                                        }
                                                                        test->next = $2.loc->tp_n;
                                                                        $2.loc->tp_n = $1.type;
                                                                    }
                                                                }

                                                                if($2.type != NULL && $2.type->basetp == tp_func)
                                                                {
                                                                    $$ = $2;
                                                                }
                                                                else
                                                                {
                                                                    $2.loc->size = $2.loc->tp_n->getSize();
                                                                    $2.loc->offset = curr_st->offset;
                                                                    curr_st->offset += $2.loc->size;
                                                                    $$ = $2;
                                                                    $$.type = $$.loc->tp_n;
                                                                }
                                                            };

pointer_opt:                    pointer {
                                            $$ = $1;
                                        }|
                                /*epsilon*/ {
                                                $$.type = NULL;
                                            };

direct_declarator:              ID {
                                                    $$.loc = curr_st->lookup(*$1.name);
                                                    if($$.loc->var_type == "")
                                                    {
                                                        $$.loc->var_type = "local";
                                                        $$.loc->tp_n = new type_n(glob_type->basetp);
                                                    }
                                                    $$.type = $$.loc->tp_n;
                                            }|
                                '(' declarator ')' {
                                                        $$ = $2;
                                                    }|
                                direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']' {
                                                                                                                //printf("Hello\n");
                                                                                                                if($1.type->basetp == tp_arr)
                                                                                                                {
                                                                                                                    /*if type is already an arr*/
                                                                                                                    type_n * typ1 = $1.type,*typ = $1.type;
                                                                                                                    typ1 = typ1->next;
                                                                                                                    while(typ1->next != NULL)
                                                                                                                    {
                                                                                                                        typ1 = typ1->next;
                                                                                                                        typ = typ->next;
                                                                                                                    }
                                                                                                                    typ->next = new type_n(tp_arr,$4.loc->i_val.int_val,typ1);
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    //add the type of array to list
                                                                                                                    if($4.loc == NULL)
                                                                                                                        $1.type = new type_n(tp_arr,-1,$1.type);
                                                                                                                    else
                                                                                                                        $1.type = new type_n(tp_arr,$4.loc->i_val.int_val,$1.type);
                                                                                                                }
                                                                                                                $$ = $1;
                                                                                                                $$.loc->tp_n = $$.type;
                                                                                                            }|
                                direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list STATIC assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list_opt '*' ']' {}|
                                direct_declarator '(' parameter_type_list ')' {
                                                                                   int params_no=curr_st->no_params;
                                                                                   curr_st->no_params=0;
                                                                                   int dec_params=0;
                                                                                   int over_params=params_no;
                                                                                   for(int i=curr_st->symbol_tab.size()-1;i>=0;i--)
                                                                                   {
                                                                                    }
                                                                                   for(int i=curr_st->symbol_tab.size()-1;i>=0;i--)
                                                                                   {
                                                                                        string detect=curr_st->symbol_tab[i]->name;
                                                                                        if(over_params==0)
                                                                                        {
                                                                                            break;
                                                                                        }
                                                                                        if(detect.size()==4)
                                                                                        {
                                                                                            if(detect[0]=='t')
                                                                                            {
                                                                                                if('0'<=detect[1]&&detect[1]<='9')
                                                                                                {
                                                                                                    if('0'<=detect[2]&&detect[2]<='9')
                                                                                                    {
                                                                                                        if('0'<=detect[3]&&detect[3]<='9')
                                                                                                            dec_params++;
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        else
                                                                                            over_params--;

                                                                                   }
                                                                                   params_no+=dec_params;
                                                                                   int temp_i=curr_st->symbol_tab.size()-params_no;
                                                                                   symdata * new_func = glob_st->search(curr_st->symbol_tab[temp_i-1]->name);
                                                                                    if(new_func == NULL)
                                                                                    {
                                                                                        new_func = glob_st->lookup(curr_st->symbol_tab[temp_i-1]->name);
                                                                                        $$.loc = curr_st->symbol_tab[temp_i-1];
                                                                                        for(int i=0;i<(temp_i-1);i++)
                                                                                        {
                                                                                            curr_st->symbol_tab[i]->ispresent=false;
                                                                                            if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
                                                                                            {
                                                                                                symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);
                                                                                                if(glob_var==NULL)
                                                                                                {
                                                                                                    glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);
                                                                                                    int t_size=curr_st->symbol_tab[i]->tp_n->getSize();
                                                                                                    glob_var->offset=glob_st->offset;
                                                                                                    glob_var->size=t_size;
                                                                                                    glob_st->offset+=t_size;
                                                                                                    glob_var->nest_tab=glob_st;
                                                                                                    glob_var->var_type=curr_st->symbol_tab[i]->var_type;
                                                                                                    glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;
                                                                                                    if(curr_st->symbol_tab[i]->isInitialized)
                                                                                                    {
                                                                                                        glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;
                                                                                                        glob_var->i_val=curr_st->symbol_tab[i]->i_val;
                                                                                                    }

                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if(new_func->var_type == "")
                                                                                        {
                                                                                            new_func->tp_n = CopyType(curr_st->symbol_tab[temp_i-1]->tp_n);
                                                                                            new_func->var_type = "func";
                                                                                            new_func->isInitialized = false;
                                                                                            new_func->nest_tab = curr_st;
                                                                                            curr_st->name = curr_st->symbol_tab[temp_i-1]->name;
                                                                                            curr_st->symbol_tab[temp_i-1]->name = "retVal";
                                                                                            curr_st->symbol_tab[temp_i-1]->var_type = "return";
                                                                                            curr_st->symbol_tab[temp_i-1]->size = curr_st->symbol_tab[temp_i-1]->tp_n->getSize();
                                                                                            curr_st->symbol_tab[temp_i-1]->offset = 0;
                                                                                            curr_st->offset = 16;
                                                                                            int count=0;
                                                                                            for(int i=(curr_st->symbol_tab.size())-params_no;i<curr_st->symbol_tab.size();i++)
                                                                                            {
                                                                                                curr_st->symbol_tab[i]->var_type = "param";
                                                                                                curr_st->symbol_tab[i]->offset = count- curr_st->symbol_tab[i]->size;
                                                                                                count=count-curr_st->symbol_tab[i]->size;
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        curr_st = new_func->nest_tab;
                                                                                    }
                                                                                    curr_st->start_quad = next_instr;
                                                                                    $$.loc = new_func;
                                                                                    $$.type = new type_n(tp_func);
                                                                                }|
                                direct_declarator '(' identifier_list_opt ')' {
                                                                                int temp_i=curr_st->symbol_tab.size();
                                                                                symdata * new_func = glob_st->search(curr_st->symbol_tab[temp_i-1]->name);
                                                                                if(new_func == NULL)
                                                                                {
                                                                                    new_func = glob_st->lookup(curr_st->symbol_tab[temp_i-1]->name);
                                                                                    $$.loc = curr_st->symbol_tab[temp_i-1];
                                                                                    for(int i=0;i<temp_i-1;i++)
                                                                                    {
                                                                                        curr_st->symbol_tab[i]->ispresent=false;
                                                                                        if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
                                                                                        {
                                                                                            symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);
                                                                                            if(glob_var==NULL)
                                                                                            {
                                                                                                glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);
                                                                                                int t_size=curr_st->symbol_tab[i]->tp_n->getSize();
                                                                                                glob_var->offset=glob_st->offset;
                                                                                                glob_var->size=t_size;
                                                                                                glob_st->offset+=t_size;
                                                                                                glob_var->nest_tab=glob_st;
                                                                                                glob_var->var_type=curr_st->symbol_tab[i]->var_type;
                                                                                                glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;
                                                                                                if(curr_st->symbol_tab[i]->isInitialized)
                                                                                                {
                                                                                                    glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;
                                                                                                    glob_var->i_val=curr_st->symbol_tab[i]->i_val;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if(new_func->var_type == "")
                                                                                    {
                                                                                        new_func->tp_n = CopyType(curr_st->symbol_tab[temp_i-1]->tp_n);
                                                                                        new_func->var_type = "func";
                                                                                        new_func->isInitialized = false;
                                                                                        new_func->nest_tab = curr_st;
                                                                                        curr_st->name = curr_st->symbol_tab[temp_i-1]->name;
                                                                                        curr_st->symbol_tab[temp_i-1]->name = "retVal";
                                                                                        curr_st->symbol_tab[temp_i-1]->var_type = "return";
                                                                                        curr_st->symbol_tab[temp_i-1]->size = curr_st->symbol_tab[0]->tp_n->getSize();
                                                                                        curr_st->symbol_tab[temp_i-1]->offset = 0;
                                                                                        curr_st->offset = 16;
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    curr_st = new_func->nest_tab;
                                                                                }
                                                                                curr_st->start_quad = next_instr;
                                                                                $$.loc = new_func;
                                                                                $$.type = new type_n(tp_func);
                                                                            };

type_qualifier_list_opt:        type_qualifier_list {}|
                                /*epsilon*/ {};

assignment_expression_opt:      assignment_expression {
                                                            $$ = $1;
                                                        }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                            };

identifier_list_opt:            identifier_list                                         |
                                /*epsilon*/                                             ;

pointer:                        '*' type_qualifier_list_opt {
                                                                $$.type = new type_n(tp_ptr);
                                                            }|
                                '*' type_qualifier_list_opt pointer {
                                                                        $$.type = new type_n(tp_ptr,1,$3.type);
                                                                    };

type_qualifier_list:            type_qualifier {}|
                                type_qualifier_list type_qualifier {};

parameter_type_list:            parameter_list {
                                                    /*-------*/
                                                }|
                                parameter_list ',' ELLIPSIS {};

parameter_list:                 parameter_declaration {
                                                            /*---------*/
                                                            (curr_st->no_params)++;
                                                        }|
                                parameter_list ',' parameter_declaration {
                                                                            /*------------*/
                                                                            (curr_st->no_params)++;
                                                                        };

parameter_declaration:          declaration_specifiers declarator {
                                                                        /*The parameter is already added to the current Symbol Table*/
                                                                  }|
                                declaration_specifiers {};

identifier_list :               ID                                              |
                                identifier_list ',' ID                          ;

type_name:                      specifier_qualifier_list                                ;

initializer:                    assignment_expression {
                                    $$ = $1;
                                }|
                                '{' initializer_list '}' {}|
                                '{' initializer_list ',' '}' {};

initializer_list:               designation_opt initializer                             |
                                initializer_list ',' designation_opt initializer        ;                                                                                                                           

designation_opt:                designation                                             |
                                /*Epslion*/                                             ;

designation:                    designator_list '='                                     ;

designator_list:                designator                                              |
                                designator_list designator                              ;

designator:                     '[' constant_expression ']'                             |
                                '.' ID {};

/*Statements*/
statement:                      labeled_statement {/*Switch Case*/}|
                                compound_statement {
                                                        $$ = $1;
                                                    }|
                                expression_statement {
                                                        $$ = NULL;
                                                    }|
                                selection_statement {
                                                        $$ = $1;
                                                    }|
                                iteration_statement {
                                                        $$ = $1;
                                                    }|
                                jump_statement {
                                                    $$ = $1;
                                                };

labeled_statement:              ID ':' statement {}|
                                CASE constant_expression ':' statement {}|
                                DEFAULT ':' statement {};

compound_statement:             '{' block_item_list_opt '}' {
                                                                $$ = $2;
                                                            };

block_item_list_opt:            block_item_list {
                                                    $$ = $1;
                                                }|  
                                /*Epslion*/ {
                                                $$ = NULL;
                                            };

block_item_list:                block_item {
                                                $$ = $1;
                                            }|
                                block_item_list M block_item {
                                                                    backpatch($1,$2);
                                                                    $$ = $3;
                                                             };

block_item:                     declaration {
                                                $$ = NULL;
                                            }|
                                statement {
                                                $$ = $1;
                                          };

expression_statement:           expression_opt ';'{
                                                        $$ = $1;
                                                  };

expression_opt:                 expression {
                                                $$ = $1;
                                           }|
                                /*Epslion*/ {
                                                $$.loc = NULL;
                                            };

selection_statement:            IF '(' expression N ')' M statement N ELSE M statement {
                                                                                            /*N1 is used for falselist of expression, M1 is used for truelist of expression, N2 is used to prevent fall through, M2 is used for falselist of expression*/
                                                                                            $7 = merge($7,$8);
                                                                                            $11 = merge($11,makelist(next_instr));
                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                            backpatch($4,next_instr);

                                                                                            conv2Bool(&$3);

                                                                                            backpatch($3.truelist,$6);
                                                                                            backpatch($3.falselist,$10);
                                                                                            $$ = merge($7,$11);
                                                                                        }|
                                IF '(' expression N ')' M statement %prec IF_CONFLICT{
                                                                        $7 = merge($7,makelist(next_instr));
                                                                        glob_quad.emit(Q_GOTO,"-1");
                                                                        backpatch($4,next_instr);
                                                                        conv2Bool(&$3);
                                                                        backpatch($3.truelist,$6);
                                                                        $$ = merge($7,$3.falselist);
                                                                    }|
                                SWITCH '(' expression ')' statement {};

iteration_statement:            WHILE '(' M expression N ')' M statement {
                                                                            glob_quad.emit(Q_GOTO,$3);
                                                                            backpatch($8,$3);           /*S.nextlist to M1.instr*/
                                                                            backpatch($5,next_instr);    /*N1.nextlist to next_instr*/
                                                                            conv2Bool(&$4);
                                                                            backpatch($4.truelist,$7);
                                                                            $$ = $4.falselist;
                                                                        }|
                                DO M statement  WHILE '(' M expression N ')' ';' {  
                                                                                    backpatch($8,next_instr);
                                                                                    backpatch($3,$6);           /*S1.nextlist to M2.instr*/
                                                                                    conv2Bool(&$7);
                                                                                    backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
                                                                                    $$ = $7.falselist;
                                                                                }|
                                FOR '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement {
                                                                                                                       /*M1 is used for coming back to check the epression at every iteration. N1 is used  for generating the goto which will be used for exit conditions. M2 is used for nextlist of statement and N2 is used for jump to check the expression and M3 is used for the truelist of expression*/
                                                                                                                        backpatch($11,$5);          /*N2.nextlist to M1.instr*/
                                                                                                                        backpatch($14,$9);          /*S.nextlist to M2.instr*/
                                                                                                                        glob_quad.emit(Q_GOTO,$9);
                                                                                                                        backpatch($7,next_instr);    /*N1.nextlist to next_instr*/
                                                                                                                        conv2Bool(&$6);
                                                                                                                        backpatch($6.truelist,$13);
                                                                                                                        $$ = $6.falselist;
                                                                                                                    }|
                                FOR '(' declaration expression_opt ';' expression_opt ')' statement {};

jump_statement:                 GOTO ID ';' {}|
                                CONTINUE ';' {}|
                                BREAK ';' {}|
                                RETURN expression_opt ';' {
                                                                if($2.loc == NULL)
                                                                    glob_quad.emit(Q_RETURN);
                                                                else
                                                                {
                                                                    expresn * dummy = new expresn();
                                                                    dummy->loc = curr_st->symbol_tab[0];
                                                                    dummy->type = dummy->loc->tp_n;
                                                                    typecheck(dummy,&$2,true);
                                                                    delete dummy;
                                                                    glob_quad.emit(Q_RETURN,$2.loc->name);
                                                                }
                                                                $$=NULL;
                                                          };

/*External Definitions*/
translation_unit:               external_declaration                                    |
                                translation_unit external_declaration                   ;

external_declaration:           function_definition                                     |
                                declaration      {

                                                                                        for(int i=0;i<curr_st->symbol_tab.size();i++)
                                                                                        {
                                                                                                    if(curr_st->symbol_tab[i]->nest_tab==NULL)
                                                                                                    {
                                                                                                    if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
                                                                                                    {
                                                                                                        symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);
                                                                                                        if(glob_var==NULL)
                                                                                                        {
                                                                                                            glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);
                                                                                                            int t_size=curr_st->symbol_tab[i]->tp_n->getSize();
                                                                                                            glob_var->offset=glob_st->offset;
                                                                                                            glob_var->size=t_size;
                                                                                                            glob_st->offset+=t_size;
                                                                                                            glob_var->nest_tab=glob_st;
                                                                                                            glob_var->var_type=curr_st->symbol_tab[i]->var_type;
                                                                                                            glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;
                                                                                                            if(curr_st->symbol_tab[i]->isInitialized)
                                                                                                            {
                                                                                                                glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;
                                                                                                                glob_var->i_val=curr_st->symbol_tab[i]->i_val;
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                  }
                                                                                        }
                                                                                        
                                                    }                                       ;

function_definition:    declaration_specifiers declarator declaration_list_opt compound_statement {
                                                                                                    symdata * func = glob_st->lookup($2.loc->name);
                                                                                                    func->nest_tab->symbol_tab[0]->tp_n = CopyType(func->tp_n);
                                                                                                    func->nest_tab->symbol_tab[0]->name = "retVal";
                                                                                                    func->nest_tab->symbol_tab[0]->offset = 0;
                                                                                                    if(func->nest_tab->symbol_tab[0]->tp_n->basetp == tp_ptr)
                                                                                                    {
                                                                                                        int diff = size_pointer - func->nest_tab->symbol_tab[0]->size;
                                                                                                        func->nest_tab->symbol_tab[0]->size = size_pointer;
                                                                                                        for(int i=1;i<func->nest_tab->symbol_tab.size();i++)
                                                                                                        {
                                                                                                            func->nest_tab->symbol_tab[i]->offset += diff;
                                                                                                        }
                                                                                                    }
                                                                                                    int offset_size = 0;
                                                                                                    for(int i=0;i<func->nest_tab->symbol_tab.size();i++)
                                                                                                    {
                                                                                                        offset_size += func->nest_tab->symbol_tab[i]->size;
                                                                                                    }
                                                                                                    func->nest_tab->end_quad = next_instr-1;
                                                                                                    curr_st = new symtab();
                                                                                                };

declaration_list_opt:           declaration_list                                        |
                                /*epsilon*/                                             ;

declaration_list:               declaration                                             |
                                declaration_list declaration                            ;

%%
void yyerror(const char*s)
{
    printf("%s",s);
}
