/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "trabalho.y" /* yacc.c:339  */


#include <string>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <vector>

using namespace std;

struct Tipo {
  string nome;

  Tipo(){}
  Tipo(string nome){ this->nome = nome; }
};
struct Atributo {
  string v; // Valor
  Tipo t;   // Tipo
  string c; // Código

  Atributo(){}
  Atributo(string v, string t="", string c =""){
    this->v = v;
    this->t.nome = t;
    this->c = c;
  }
};
struct SimboloVariavel{
  string nome;
  Tipo t;
  int escopo;

  SimboloVariavel(){}
  SimboloVariavel(string nome, string tipo, int escopo){this->nome = nome; this->t = tipo; this->escopo = escopo;}
};

#define YYSTYPE   Atributo

#define COLOR_RED     "\x1B[31m"
#define COLOR_RESET   "\x1B[0m"

#define C_INT     "int"
#define C_DOUBLE  "double"
#define C_FLOAT   "float"
#define C_CHAR    "char"
#define C_STRING  "string"
#define C_BOOL    "bool"
#define C_VOID    "void"

void yyerror(const char*);
void erro(string msg);
int yylex();
int yyparse();

vector<string> &split(const string &s, char delim, vector<string> &elems);
vector<string> split(const string &s, char delim);
string toStr(int n);
string gerarIncludeC(string bib);
string declararVariavel(string tipo, string vars, int escopo);
void inserirVariavelTabela(string tipo, string nome, int escopo);
bool buscaVariavelDeclarada(string tipo, string nome, int escopo);

int escopoAtual = 0;

typedef map<string, SimboloVariavel> TSV; // TabelaSimbolosVariavel: Key ==> contat(escopo,nomeVar);
TSV tabelaSimbolosVariavel;


#line 138 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_INICIO = 258,
    TK_INCLUDE = 259,
    TK_BIB_INCLUDE = 260,
    TK_PROTOTIPO = 261,
    TK_ID = 262,
    TK_CTE_INT = 263,
    TK_CTE_DOUBLE = 264,
    TK_CTE_FLOAT = 265,
    TK_CTE_CHAR = 266,
    TK_CTE_STRING = 267,
    TK_CTE_BOOL_TRUE = 268,
    TK_CTE_BOOL_FALSE = 269,
    TK_INT = 270,
    TK_DOUBLE = 271,
    TK_FLOAT = 272,
    TK_STRING = 273,
    TK_CHAR = 274,
    TK_BOOL = 275,
    TK_VOID = 276,
    TK_NULL = 277,
    TK_DECLARAR_VAR = 278,
    TK_AS = 279,
    TK_MAIN = 280,
    TK_COMECA_BLOCO = 281,
    TK_TERMINA_BLOCO = 282,
    TK_TERMINA_MAIN = 283,
    TK_COMECA_FUNCAO = 284,
    TK_TERMINA_FUNCAO = 285,
    TK_ADICAO = 286,
    TK_SUBTRACAO = 287,
    TK_MULTIPLICACAO = 288,
    TK_DIVISAO = 289,
    TK_MODULO = 290,
    TK_COMP_MENOR = 291,
    TK_COMP_MAIOR = 292,
    TK_COMP_MENOR_IGUAL = 293,
    TK_COMP_MAIOR_IGUAL = 294,
    TK_COMP_IGUAL = 295,
    TK_COMP_DIFF = 296,
    TK_OR = 297,
    TK_AND = 298,
    TK_NOT = 299,
    TK_ATRIBUICAO = 300,
    TK_IF = 301,
    TK_ELSE = 302,
    TK_FOR = 303,
    TK_DO = 304,
    TK_WHILE = 305,
    TK_SWITCH = 306,
    TK_CASE = 307,
    TK_DEFAULT = 308,
    TK_BREAK = 309,
    TK_RETURN = 310,
    TK_PRINT = 311,
    TK_SCAN = 312
  };
#endif
/* Tokens.  */
#define TK_INICIO 258
#define TK_INCLUDE 259
#define TK_BIB_INCLUDE 260
#define TK_PROTOTIPO 261
#define TK_ID 262
#define TK_CTE_INT 263
#define TK_CTE_DOUBLE 264
#define TK_CTE_FLOAT 265
#define TK_CTE_CHAR 266
#define TK_CTE_STRING 267
#define TK_CTE_BOOL_TRUE 268
#define TK_CTE_BOOL_FALSE 269
#define TK_INT 270
#define TK_DOUBLE 271
#define TK_FLOAT 272
#define TK_STRING 273
#define TK_CHAR 274
#define TK_BOOL 275
#define TK_VOID 276
#define TK_NULL 277
#define TK_DECLARAR_VAR 278
#define TK_AS 279
#define TK_MAIN 280
#define TK_COMECA_BLOCO 281
#define TK_TERMINA_BLOCO 282
#define TK_TERMINA_MAIN 283
#define TK_COMECA_FUNCAO 284
#define TK_TERMINA_FUNCAO 285
#define TK_ADICAO 286
#define TK_SUBTRACAO 287
#define TK_MULTIPLICACAO 288
#define TK_DIVISAO 289
#define TK_MODULO 290
#define TK_COMP_MENOR 291
#define TK_COMP_MAIOR 292
#define TK_COMP_MENOR_IGUAL 293
#define TK_COMP_MAIOR_IGUAL 294
#define TK_COMP_IGUAL 295
#define TK_COMP_DIFF 296
#define TK_OR 297
#define TK_AND 298
#define TK_NOT 299
#define TK_ATRIBUICAO 300
#define TK_IF 301
#define TK_ELSE 302
#define TK_FOR 303
#define TK_DO 304
#define TK_WHILE 305
#define TK_SWITCH 306
#define TK_CASE 307
#define TK_DEFAULT 308
#define TK_BREAK 309
#define TK_RETURN 310
#define TK_PRINT 311
#define TK_SCAN 312

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);



/* Copy the second part of user declarations.  */

#line 300 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  5
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   385

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  65
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  38
/* YYNRULES -- Number of rules.  */
#define YYNRULES  97
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  205

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   312

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      58,    59,     2,     2,    61,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    64,    60,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    62,     2,    63,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    96,    96,   106,   109,   110,   113,   116,   117,   120,
     121,   124,   125,   126,   127,   128,   129,   130,   133,   134,
     137,   138,   141,   142,   145,   148,   149,   152,   153,   156,
     157,   160,   163,   164,   167,   170,   171,   174,   175,   176,
     177,   178,   179,   180,   181,   182,   183,   184,   185,   188,
     191,   194,   195,   198,   199,   202,   203,   204,   205,   206,
     207,   208,   209,   210,   211,   212,   213,   214,   215,   216,
     217,   218,   221,   222,   223,   224,   225,   226,   227,   228,
     229,   230,   233,   234,   237,   240,   243,   246,   247,   250,
     253,   254,   255,   258,   261,   264,   267,   270
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TK_INICIO", "TK_INCLUDE",
  "TK_BIB_INCLUDE", "TK_PROTOTIPO", "TK_ID", "TK_CTE_INT", "TK_CTE_DOUBLE",
  "TK_CTE_FLOAT", "TK_CTE_CHAR", "TK_CTE_STRING", "TK_CTE_BOOL_TRUE",
  "TK_CTE_BOOL_FALSE", "TK_INT", "TK_DOUBLE", "TK_FLOAT", "TK_STRING",
  "TK_CHAR", "TK_BOOL", "TK_VOID", "TK_NULL", "TK_DECLARAR_VAR", "TK_AS",
  "TK_MAIN", "TK_COMECA_BLOCO", "TK_TERMINA_BLOCO", "TK_TERMINA_MAIN",
  "TK_COMECA_FUNCAO", "TK_TERMINA_FUNCAO", "TK_ADICAO", "TK_SUBTRACAO",
  "TK_MULTIPLICACAO", "TK_DIVISAO", "TK_MODULO", "TK_COMP_MENOR",
  "TK_COMP_MAIOR", "TK_COMP_MENOR_IGUAL", "TK_COMP_MAIOR_IGUAL",
  "TK_COMP_IGUAL", "TK_COMP_DIFF", "TK_OR", "TK_AND", "TK_NOT",
  "TK_ATRIBUICAO", "TK_IF", "TK_ELSE", "TK_FOR", "TK_DO", "TK_WHILE",
  "TK_SWITCH", "TK_CASE", "TK_DEFAULT", "TK_BREAK", "TK_RETURN",
  "TK_PRINT", "TK_SCAN", "'('", "')'", "';'", "','", "'['", "']'", "':'",
  "$accept", "S", "MAIN", "FUNCOES", "FUNCAO", "INCLUDES", "PROT", "TIPO",
  "LISTA_ARGUMENTOS", "ARGUMENTOS", "VARS_GLOBAIS", "VAR_GLOBAL",
  "LISTA_IDS", "ARRAY", "BLOCO", "CORPO", "VARS_LOCAIS", "VAR_LOCAL",
  "COMANDOS", "COMANDO", "COMANDO_BREAK", "CHAMADA_FUNCAO",
  "LISTA_PARAMETROS", "PARAMETROS", "EXPRESSAO", "TERMINAL", "COMANDO_IF",
  "COMANDO_WHILE", "COMANDO_DO_WHILE", "COMANDO_FOR", "EXPRESSAO_FOR",
  "COMANDO_SWITCH", "LISTA_CASE", "CASE", "DEFAULT", "COMANDO_RETURN",
  "COMANDO_SCAN", "COMANDO_PRINT", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,    40,    41,
      59,    44,    91,    93,    58
};
# endif

#define YYPACT_NINF -170

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-170)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  (!!((Yytable_value) == (-1)))

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      19,    13,    42,    24,    45,  -170,    13,    29,    31,  -170,
    -170,  -170,  -170,  -170,  -170,  -170,  -170,    52,    53,    29,
       3,     7,     5,    59,    41,    29,    77,    31,    29,    78,
      26,    29,    62,    29,  -170,    30,  -170,    82,    33,  -170,
      27,    53,  -170,    53,    65,    91,    34,  -170,    29,     5,
      36,     5,  -170,    73,  -170,   -26,  -170,  -170,  -170,  -170,
    -170,  -170,  -170,  -170,    62,   145,    48,    49,     2,    50,
      51,  -170,   145,    54,    56,   145,  -170,  -170,    91,    55,
    -170,   186,  -170,  -170,  -170,    58,  -170,  -170,    60,    61,
      63,    62,    57,    64,    45,  -170,    29,   145,    66,    83,
    -170,   145,   145,    62,    62,    69,   145,   145,   342,   145,
     115,   216,  -170,  -170,   145,   145,   145,   145,   145,   145,
     145,   145,   145,   145,   145,   145,   145,  -170,  -170,  -170,
    -170,  -170,  -170,     2,    29,  -170,  -170,    67,  -170,   173,
     145,  -170,   229,   342,    68,   100,   101,    74,   258,   271,
     300,    84,  -170,     4,     4,  -170,  -170,  -170,   204,   204,
     204,   204,   -27,   -27,   159,   159,  -170,  -170,  -170,   145,
     342,     2,   145,  -170,  -170,   145,     2,   107,  -170,  -170,
    -170,    89,    90,   313,  -170,   -18,     2,   145,  -170,   145,
      96,   134,   -18,  -170,  -170,   103,   137,    62,  -170,  -170,
       2,    62,  -170,  -170,  -170
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     8,     0,     0,    10,     1,     8,     0,    23,     7,
      11,    12,    13,    14,    15,    16,    17,     0,     0,     5,
       0,     0,    28,     0,     0,     5,     0,    23,    19,     0,
      26,     0,    33,     5,     4,     0,    22,     0,     0,    18,
       0,     0,    24,     0,     0,    36,     0,     2,    19,    28,
       0,    28,    25,     0,     3,    28,    73,    74,    75,    76,
      77,    78,    79,    81,    33,     0,     0,     0,     0,     0,
       0,    49,     0,     0,     0,     0,    47,    31,    36,     0,
      70,     0,    71,    38,    39,     0,    41,    42,     0,     0,
       0,    33,     0,    21,    10,    27,     0,    52,    72,     0,
      68,     0,    88,    33,    33,     0,     0,     0,    95,     0,
       0,     0,    35,    46,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    37,    40,    43,
      44,    45,    32,     0,     0,     9,    34,     0,    51,    54,
       0,    48,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,    80,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,    67,     6,    20,    50,     0,
      69,     0,    88,    29,    30,     0,     0,     0,    97,    96,
      53,    82,     0,     0,    84,    92,     0,    88,    85,     0,
       0,     0,    92,    91,    83,     0,     0,    33,    89,    90,
       0,    33,    94,    86,    93
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -170,  -170,  -170,    -9,  -170,   157,    70,    -5,   117,    32,
     154,  -170,    14,   -30,  -118,   -63,    92,  -170,   104,  -170,
    -170,  -170,  -170,    15,   -45,  -170,  -170,  -170,  -170,  -170,
    -169,  -170,    -7,  -170,  -170,  -170,  -170,  -170
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,    33,    24,    25,     4,     8,    26,    38,    39,
      19,    20,    23,    30,   105,    44,    45,    46,    77,    78,
      79,    80,   137,   138,   143,    82,    83,    84,    85,    86,
     144,    87,   191,   192,   193,    88,    89,    90
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      81,    99,    17,   182,   114,   115,   116,   117,   118,   119,
     120,   121,   122,    -1,    -1,   166,    34,     3,   195,    93,
     100,    95,     1,    37,    47,    98,    42,   108,   103,     6,
     111,   104,    97,    81,   189,   190,    29,   116,   117,   118,
     145,   146,     5,    37,    10,    11,    12,    13,    14,    15,
      16,     7,   139,   181,    18,    52,   142,    53,   184,    21,
      22,   148,   149,    27,   150,    28,    32,    29,   194,   153,
     154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
     164,   165,   203,    31,    35,    43,    40,    41,    48,    49,
      51,   136,    50,    54,    91,   170,    94,    96,    55,    56,
      57,    58,    59,    60,    61,    62,   101,   102,   106,   107,
     141,   140,   109,    63,   110,   113,   133,    64,   128,   147,
     129,   130,   151,   131,   139,   134,   168,   173,   172,    37,
     183,   174,   175,   185,   202,    65,   186,    66,   204,    67,
      68,    69,    70,   179,   196,    71,    72,    73,    74,    75,
     187,    76,    55,    56,    57,    58,    59,    60,    61,    62,
     197,   198,   200,     9,   135,    92,   167,    63,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,    36,   112,   132,   180,   199,     0,     0,     0,    65,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   201,     0,    75,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
       0,     0,     0,     0,   169,   114,   115,   116,   117,   118,
      -1,    -1,    -1,    -1,     0,     0,   127,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,     0,     0,   152,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   171,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,     0,     0,   176,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     177,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125,   126,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,     0,     0,   178,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   188,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126
};

static const yytype_int16 yycheck[] =
{
      45,    64,     7,   172,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,   133,    25,     4,   187,    49,
      65,    51,     3,    28,    33,    55,    31,    72,    26,     5,
      75,    29,    58,    78,    52,    53,    62,    33,    34,    35,
     103,   104,     0,    48,    15,    16,    17,    18,    19,    20,
      21,     6,    97,   171,    23,    41,   101,    43,   176,     7,
       7,   106,   107,    60,   109,    58,    25,    62,   186,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   200,    24,     7,    23,     8,    61,    58,     7,
      63,    96,    59,    28,    60,   140,    60,    24,     7,     8,
       9,    10,    11,    12,    13,    14,    58,    58,    58,    58,
      27,    45,    58,    22,    58,    60,    59,    26,    60,    50,
      60,    60,     7,    60,   169,    61,    59,    27,    60,   134,
     175,    30,    58,    26,   197,    44,    47,    46,   201,    48,
      49,    50,    51,    59,   189,    54,    55,    56,    57,    58,
      60,    60,     7,     8,     9,    10,    11,    12,    13,    14,
      64,    27,    59,     6,    94,    48,   134,    22,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    27,    78,    91,   169,   192,    -1,    -1,    -1,    44,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    64,    -1,    58,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      -1,    -1,    -1,    -1,    61,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    -1,    -1,    60,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    -1,    -1,    59,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    -1,    -1,    59,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      59,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    -1,    -1,    59,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    59,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    66,     4,    70,     0,     5,     6,    71,    70,
      15,    16,    17,    18,    19,    20,    21,    72,    23,    75,
      76,     7,     7,    77,    68,    69,    72,    60,    58,    62,
      78,    24,    25,    67,    68,     7,    75,    72,    73,    74,
       8,    61,    72,    23,    80,    81,    82,    68,    58,     7,
      59,    63,    77,    77,    28,     7,     8,     9,    10,    11,
      12,    13,    14,    22,    26,    44,    46,    48,    49,    50,
      51,    54,    55,    56,    57,    58,    60,    83,    84,    85,
      86,    89,    90,    91,    92,    93,    94,    96,   100,   101,
     102,    60,    73,    78,    60,    78,    24,    58,    78,    80,
      89,    58,    58,    26,    29,    79,    58,    58,    89,    58,
      58,    89,    83,    60,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    60,    60,    60,
      60,    60,    81,    59,    61,    71,    72,    87,    88,    89,
      45,    27,    89,    89,    95,    80,    80,    50,    89,    89,
      89,     7,    59,    89,    89,    89,    89,    89,    89,    89,
      89,    89,    89,    89,    89,    89,    79,    74,    59,    61,
      89,    59,    60,    27,    30,    58,    59,    59,    59,    59,
      88,    79,    95,    89,    79,    26,    47,    60,    59,    52,
      53,    97,    98,    99,    79,    95,    89,    64,    27,    97,
      59,    64,    80,    79,    80
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    65,    66,    67,    68,    68,    69,    70,    70,    71,
      71,    72,    72,    72,    72,    72,    72,    72,    73,    73,
      74,    74,    75,    75,    76,    77,    77,    78,    78,    79,
      79,    80,    81,    81,    82,    83,    83,    84,    84,    84,
      84,    84,    84,    84,    84,    84,    84,    84,    84,    85,
      86,    87,    87,    88,    88,    89,    89,    89,    89,    89,
      89,    89,    89,    89,    89,    89,    89,    89,    89,    89,
      89,    89,    90,    90,    90,    90,    90,    90,    90,    90,
      90,    90,    91,    91,    92,    93,    94,    95,    95,    96,
      97,    97,    97,    98,    99,   100,   101,   102
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     7,     3,     2,     0,     6,     3,     0,     8,
       0,     1,     1,     1,     1,     1,     1,     1,     1,     0,
       5,     3,     3,     0,     4,     4,     2,     4,     0,     3,
       3,     2,     3,     0,     4,     2,     0,     2,     1,     1,
       2,     1,     1,     2,     2,     2,     2,     1,     3,     1,
       4,     1,     0,     3,     1,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     2,     4,
       1,     1,     2,     1,     1,     1,     1,     1,     1,     1,
       3,     1,     5,     7,     5,     6,     9,     1,     0,     7,
       2,     1,     0,     4,     3,     2,     4,     4
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 97 "trabalho.y" /* yacc.c:1646  */
    { cout << "// *****Welcome to the Game Of Thrones*****\n\n\n"
        << (yyvsp[-5]).c << "#include <stdio.h>\n"
                   "#include <stdlib.h>\n"
                   "#include <string.h>\n"
        << (yyvsp[-3]).c
        << (yyvsp[-1]).c;
      }
#line 1571 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 106 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); (yyval).c = "int main(){\n" + (yyvsp[-1]).c + "  return 0;\n}\n"; }
#line 1577 "y.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 116 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); (yyval).c = gerarIncludeC((yyvsp[-1]).v) + (yyvsp[0]).c;}
#line 1583 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 117 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); }
#line 1589 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 120 "trabalho.y" /* yacc.c:1646  */
    {}
#line 1595 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 121 "trabalho.y" /* yacc.c:1646  */
    {}
#line 1601 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 124 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_INT);     }
#line 1607 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 125 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_DOUBLE);  }
#line 1613 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 126 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_FLOAT);   }
#line 1619 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 127 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_STRING);  }
#line 1625 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 128 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_CHAR);    }
#line 1631 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 129 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_BOOL);    }
#line 1637 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 130 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(C_VOID);    }
#line 1643 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 141 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo();  (yyval).c = (yyvsp[-2]).c + ";\n" + (yyvsp[0]).c; }
#line 1649 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 142 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); }
#line 1655 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 145 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); (yyval).c = declararVariavel((yyvsp[0]).v, (yyvsp[-2]).c, 0); }
#line 1661 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 148 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); (yyval).c = (yyvsp[-3]).v + "," + (yyvsp[0]).c; }
#line 1667 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 149 "trabalho.y" /* yacc.c:1646  */
    { (yyval) = Atributo(); (yyval).c = (yyvsp[-1]).v; }
#line 1673 "y.tab.c" /* yacc.c:1646  */
    break;


#line 1677 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 273 "trabalho.y" /* yacc.c:1906  */


int contadorLinha = 1;

#include "lex.yy.c"

void yyerror( const char* st ){
  puts( st );
  //cout << "Perto de " << yytext;
  printf( "[%sERRO%s] Na linha: %d. Perto de: '%s'\n", COLOR_RED, COLOR_RESET, contadorLinha, yytext );
}

void erro(string msg){
  yyerror(msg.c_str());
  exit(0);
}

string toStr(int n){
  char buf[1024] = "";
  sprintf( buf, "%d", n );
  return buf;
}

string gerarIncludeC(string bib){
  return "#include "+bib+"\n";
}

string declararVariavel(string tipo, string vars, int escopo){
  vector<string> vetorVars = split(vars, ',');
  string codigo = tipo + " " + vars;

  for(int i = 0; i < vetorVars.size(); i++)
    inserirVariavelTabela(tipo, vetorVars.at(i), escopo);

  return codigo;
}

void inserirVariavelTabela(string tipo, string nome, int escopo){
  if(!buscaVariavelDeclarada(tipo, nome, escopo)){
    tabelaSimbolosVariavel[toStr(escopo)+nome] = SimboloVariavel(nome, tipo, escopo);
  }
  else{
    erro("Variavel ja definida: " + nome +"\n");
  }
}

bool buscaVariavelDeclarada(string tipo, string nome, int escopo){
  if(tabelaSimbolosVariavel.find(toStr(escopo) + nome) != tabelaSimbolosVariavel.end())
    return true;
  else
    return false;
}

vector<string> &split(const string &s, char delim, vector<string> &elems){
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

vector<string> split(const string &s, char delim){
    vector<string> elems;
    split(s, delim, elems);
    return elems;
}

int main( int argc, char* argv[] ){
//  inicializaResultadoOperador();
  yyparse();
}
