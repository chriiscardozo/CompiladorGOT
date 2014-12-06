%option case-insensitive

DELIM               [ \t]
LINHA               [\n]
NUMERO              [0-9]
LETRA               [A-Za-z_]

ID                  {LETRA}({LETRA}|{NUMERO})*

CTE_INT             {NUMERO}+("n")?
CTE_DOUBLE          {NUMERO}+("."{NUMERO}+)?("n")?
CTE_FLOAT           {NUMERO}+("."{NUMERO}+)?("f")("n")?
CTE_CHAR            "\'"."\'"
CTE_STRING          "\""[^"\n]*"\""
CTE_BOOL_TRUE       "FIRE"
CTE_BOOL_FALSE      "ICE"

COMENTARIO          "#HODOR".*$

TIPO_INTEIRO        "stark"
TIPO_DOUBLE         "baratheon"
TIPO_FLOAT          "tully"
TIPO_CHAR           "lannister"
TIPO_STRING         "targaryen"
TIPO_BOOL           "martell"
TIPO_VOID           "unsullied"

ATRIBUICAO          "="

PRINCIPAL_FUNCAO    "first_of_his_name()"
COMECA_BLOCO        "{"
TERMINA_BLOCO       "}"

TERMINA_MAIN        "and_now_his_watch_is_ended"

COMECA_FUNCAO       "winter_is_coming"
TERMINA_FUNCAO      "all_functions_must_die"|"valar_morghulis"

IF                  "what_do_we_say_to_death"
ELSE                "not_today"
FOR                 "for_the_lord_of_winterfell"
DO                  "and_so_he_spokes"
WHILE               "while_the_proud_lord_says"
SWITCH              "which_house_do_you_belong_in"
CASE                "house"
DEFAULT             "free_folk"

RETURN              "the_lannister_send_their_regards"

SCAN                "maester_read"
PRINT               "maester_write"

INTERVALO           "intervalo"
FILTER              "filter"
FOREACH             "foreach"
FIRSTN              "firstN"
LASTN               "lastN"
SORT                "sort"

OR                  "||"
AND                 "&&"
NOT                 "!"

COMP_MAIOR          ">"
COMP_MENOR          "<"
COMP_MAIOR_IGUAL    ">="
COMP_MENOR_IGUAL    "<="
COMP_IGUAL          "=="
COMP_DIFF           "!="

ADICAO              "+"
SUBTRACAO           "-"
MULTIPLICACAO       "*"
DIVISAO             "/"
MODULO              "%"

PIPE                "=>"

PROTOTIPO           "squire"

NULL                "YOU_KNOW_NOTHING"
BREAK               "breaker_of_chains"
DECLARAR_VAR        "its_known"
AS                  "as"

INICIO              "When you play the game of thrones, you win or you die"
INCLUDE             "#dracarys"
BIB_INCLUDE         (("<")({LETRA})*(".h")?(">")|(\")({LETRA})*(".h")?(\"))

%%

{DELIM}             {}
{LINHA}             { contadorLinha++; }
{COMENTARIO}        {}

{CTE_INT}           { yylval = Atributo(yytext); return TK_CTE_INT; }
{CTE_DOUBLE}        { yylval = Atributo(yytext); return TK_CTE_DOUBLE; }
{CTE_FLOAT}         { yylval = Atributo(yytext); return TK_CTE_FLOAT; }
{CTE_CHAR}          { yylval = Atributo(yytext); return TK_CTE_CHAR; }
{CTE_STRING}        { yylval = Atributo(yytext); return TK_CTE_STRING; }
{CTE_BOOL_TRUE}     { yylval = Atributo(yytext); return TK_CTE_BOOL_TRUE; }
{CTE_BOOL_FALSE}    { yylval = Atributo(yytext); return TK_CTE_BOOL_FALSE; }

{TIPO_INTEIRO}      { yylval = Atributo(yytext); return TK_INT; }
{TIPO_DOUBLE}       { yylval = Atributo(yytext); return TK_DOUBLE; }
{TIPO_FLOAT}        { yylval = Atributo(yytext); return TK_FLOAT; }
{TIPO_CHAR}         { yylval = Atributo(yytext); return TK_CHAR; }
{TIPO_STRING}       { yylval = Atributo(yytext); return TK_STRING; }
{TIPO_BOOL}         { yylval = Atributo(yytext); return TK_BOOL; }
{TIPO_VOID}         { yylval = Atributo(yytext); return TK_VOID; }

{ATRIBUICAO}        { yylval = Atributo(yytext); return TK_ATRIBUICAO; }

{PRINCIPAL_FUNCAO}  { yylval = Atributo(yytext); return TK_MAIN; }
{COMECA_BLOCO}      { yylval = Atributo(yytext); return TK_COMECA_BLOCO; }
{TERMINA_BLOCO}     { yylval = Atributo(yytext); return TK_TERMINA_BLOCO; }
{TERMINA_MAIN}      { yylval = Atributo(yytext); return TK_TERMINA_MAIN; }
{COMECA_FUNCAO}     { yylval = Atributo(yytext); return TK_COMECA_FUNCAO; }
{TERMINA_FUNCAO}    { yylval = Atributo(yytext); return TK_TERMINA_FUNCAO; }

{IF}                { yylval = Atributo(yytext); return TK_IF; }
{ELSE}              { yylval = Atributo(yytext); return TK_ELSE; }
{FOR}               { yylval = Atributo(yytext); return TK_FOR; }
{DO}                { yylval = Atributo(yytext); return TK_DO; }
{WHILE}             { yylval = Atributo(yytext); return TK_WHILE; }
{SWITCH}            { yylval = Atributo(yytext); return TK_SWITCH; }
{CASE}              { yylval = Atributo(yytext); return TK_CASE; }
{DEFAULT}           { yylval = Atributo(yytext); return TK_DEFAULT; }

{RETURN}            { yylval = Atributo(yytext); return TK_RETURN; }

{SCAN}              { yylval = Atributo(yytext); return TK_SCAN; }
{PRINT}             { yylval = Atributo(yytext); return TK_PRINT; }

{INTERVALO}         { yylval = Atributo(yytext); return TK_INTERVALO; }
{FILTER}            { yylval = Atributo(yytext); return TK_FILTER; }
{FOREACH}           { yylval = Atributo(yytext); return TK_FOREACH; }
{FIRSTN}            { yylval = Atributo(yytext); return TK_FIRSTN; }
{LASTN}             { yylval = Atributo(yytext); return TK_LASTN; }
{SORT}              { yylval = Atributo(yytext); return TK_SORT; }

{OR}                { yylval = Atributo(yytext); return TK_OR; }
{AND}               { yylval = Atributo(yytext); return TK_AND; }
{NOT}               { yylval = Atributo(yytext); return TK_NOT; }

{COMP_MAIOR}        { yylval = Atributo(yytext); return TK_COMP_MAIOR; }
{COMP_MENOR}        { yylval = Atributo(yytext); return TK_COMP_MENOR; }
{COMP_MAIOR_IGUAL}  { yylval = Atributo(yytext); return TK_COMP_MAIOR_IGUAL; }
{COMP_MENOR_IGUAL}  { yylval = Atributo(yytext); return TK_COMP_MENOR_IGUAL; }
{COMP_IGUAL}        { yylval = Atributo(yytext); return TK_COMP_IGUAL; }
{COMP_DIFF}         { yylval = Atributo(yytext); return TK_COMP_DIFF; }

{ADICAO}            { yylval = Atributo(yytext); return TK_ADICAO; }
{SUBTRACAO}         { yylval = Atributo(yytext); return TK_SUBTRACAO; }
{MULTIPLICACAO}     { yylval = Atributo(yytext); return TK_MULTIPLICACAO; }
{DIVISAO}           { yylval = Atributo(yytext); return TK_DIVISAO; }
{MODULO}            { yylval = Atributo(yytext); return TK_MODULO; }

{PIPE}              { yylval = Atributo(yytext); return TK_PIPE; }

{PROTOTIPO}         { yylval = Atributo(yytext); return TK_PROTOTIPO; }

{NULL}              { yylval = Atributo(yytext); return TK_NULL; }
{BREAK}             { yylval = Atributo(yytext); return TK_BREAK; }
{DECLARAR_VAR}      { yylval = Atributo(yytext); return TK_DECLARAR_VAR; }
{AS}                { yylval = Atributo(yytext); return TK_AS; }

{INICIO}            { yylval = Atributo(yytext); return TK_INICIO; }

{INCLUDE}           { yylval = Atributo(yytext); return TK_INCLUDE; }
{BIB_INCLUDE}       { yylval = Atributo(yytext); return TK_BIB_INCLUDE; }

{ID}                { yylval = Atributo(yytext); return TK_ID;}

.                   { return *yytext; }

%%
