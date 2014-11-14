DELIM			[ \t\n]
NUMERO			[0-9]
LETRA			[A-Za-z_]

ID			{LETRA}({LETRA}|{NUMERO})*

CTE_INT			("-"|"+")?{NUMERO}+
CTE_DOUBLE		("-"|"+")?{NUMERO}+("."{NUMERO}+)?
CTE_FLOAT		("-"|"+")?{NUMERO}+("."{NUMERO}+)?("f")
CTE_CHAR		"\'"."\'"
CTE_STRING		"\""[^"\n]*"\""
CTE_BOOL_TRUE	"FIRE"
CTE_BOOL_FALSE	"ICE"

COMENTARIO "#HODOR".*"\n"

TIPO_INTEIRO	"stark"
TIPO_DOUBLE		"baratheon"
TIPO_FLOAT		"tully"
TIPO_CHAR		"lannister"
TIPO_STRING		"targaryen"
TIPO_BOOL		"martell"
TIPO_VOID		"unsullied"

ATRIBUICAO		"="


PRINCIPAL_FUNCAO	"first_of_his_name()"
COMECO_BLOCO	"{"
FINAL_BLOCO		"}"

IF		"what_do_we_say_to_death"
ELSE	"not_today"
FOR		"for_the_lord_of_winterfell"
DO		"and_so_he_spokes"
WHILE	"while_the_proud_lord_says"
SWITCH	"which_house_do_you_belong_in"

RETURN	"the_lannister_send_their_regards"

SCAN	"maester_read"
PRINT	"maester_write"

OR 		"||"
AND 	"&&"
NOT 	"!"

COMP_MAIOR 			">"
COMP_MENOR 			"<"
COMP_MAIOR_IGUAL 	">="
COMP_MENOR_IGUAL 	"<="
COMP_IGUAL 			"=="
COMP_DIFF			"!="

ADICAO			"+"
SUBTRACAO		"-"
MULTIPLICACAO	"*"
DIVISAO			"/"
MODULO			"%"

PROTOTIPO		"squire"

NULL			"YOU_KNOW_NOTHING"
BREAK			"breaker_of_chains"
DECLARAR_VAR	"its_known"

INICIO			"When you play the game of thrones, you win or you die"
INCLUDE			"dracarys"

%%

{DELIM}				{}
{COMENTARIO}		{}

{CTE_INT}			{}
{CTE_DOUBLE}		{}
{CTE_FLOAT}			{}
{CTE_CHAR}			{}
{CTE_STRING}		{}
{CTE_BOOL_TRUE}		{}
{CTE_BOOL_FALSE}	{}

{TIPO_INTEIRO}		{}
{TIPO_DOUBLE}		{}
{TIPO_FLOAT}		{}
{TIPO_CHAR}			{}
{TIPO_STRING}		{}
{TIPO_BOOL}			{}
{TIPO_VOID}			{}

{ATRIBUICAO}		{}

{PRINCIPAL_FUNCAO}	{}
{COMECO_BLOCO}		{}
{FINAL_BLOCO}		{}

{IF}				{}
{ELSE}				{}
{FOR}				{}
{DO}				{}
{WHILE}				{}
{SWITCH}			{}

{RETURN}			{}

{SCAN}				{}
{PRINT}				{}


{OR}				{}
{AND} 				{}
{NOT} 				{}

{COMP_MAIOR}		{}
{COMP_MENOR} 		{}
{COMP_MAIOR_IGUAL}	{}
{COMP_MENOR_IGUAL} 	{}
{COMP_IGUAL} 		{}
{COMP_DIFF}			{}

{ADICAO}			{}
{SUBTRACAO}			{}
{MULTIPLICACAO}		{}
{DIVISAO}			{}
{MODULO}			{}

{PROTOTIPO}			{}

{NULL} 				{}
{BREAK} 			{}
{DECLARAR_VAR}		{}

{INICIO}			{}
{INCLUDE}			{}

.					{ return *yytext; }