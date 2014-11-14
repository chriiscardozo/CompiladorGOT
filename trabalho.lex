DELIM			[ \t\n]
NUMERO			[0-9]
LETRA			[A-Za-z_]

ID			{LETRA}({LETRA}|{NUMERO})*

CTE_INT			{NUMERO}+
CTE_DOUBLE		{NUMERO}+("."{NUMERO}+)?
CTE_CHAR		"\'"."\'"
CTE_STRING		"\"".*"\""
CTE_BOOL_TRUE	"FIRE"
CTE_BOOL_FALSE	"ICE"

COMENTARIO "HODOR".*"\n"

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
WHILE	"while_the_proud_lord_says"
SWITCH	"which_house_do_you_belong_in"

RETURN	"the_lannister_send_their_regards"

SCAN	"maester_read"
PRINT	"maester_write"

