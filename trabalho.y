%{

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
    int ndim; // ndim == 0 ? não é array : é array;
    int t_dim[2];

    Tipo(){}
    Tipo(string nome, int ndim = 0, int t_dim1 = 0, int t_dim2 = 0) : nome(nome), ndim(ndim) {
      t_dim[0] = t_dim1;
      t_dim[1] = t_dim2;
    }
};

struct Atributo {
    string v; // Valor
    Tipo t;   // Tipo
    string c; // Código

    Atributo() {}
    Atributo(string v, string t = "", string c = "") : v(v), t(t), c(c) {}
    Atributo(string v, Tipo t, string c = "") : v(v), t(t), c(c) {}
};

struct SimboloVariavel{
    string nome;
    Tipo t;
    int bloco;

    SimboloVariavel() {}
    SimboloVariavel(string nome, string tipo, int bloco)
        : nome(nome), t(tipo), bloco(bloco) {}
    SimboloVariavel(string nome, Tipo tipo, int bloco)
        : nome(nome), t(tipo), bloco(bloco) {}
};

struct Argumento {
  string nome;
  Tipo tipo;

  Argumento(){}
  Argumento(string nome, Tipo tipo) : nome(nome), tipo(tipo) {}
};

struct SimboloFuncao {
  string nome;
  Tipo retorno;
  bool prototipo; // TRUE => Apenas prototipo ; FALSE => Já com corpo declarado
  vector<Argumento> params;
  string codigo_params;

  SimboloFuncao() {}
  SimboloFuncao(string nome, Tipo retorno, vector<Argumento> params, string codigo_params, bool prototipo = false)
    : nome(nome), retorno(retorno), params(params), codigo_params(codigo_params), prototipo(prototipo) {}
};

#define YYSTYPE     Atributo

#define COLOR_RED   "\x1B[31m"
#define COLOR_RESET "\x1B[0m"
#define TAB         "    "

#define C_INT       "int"
#define C_DOUBLE    "double"
#define C_FLOAT     "float"
#define C_CHAR      "char"
#define C_STRING    "string"
#define C_BOOL      "bool"
#define C_VOID      "void"

#define C_TK_BREAK  "breaker_of_chains"

#define MAX_STR     256

#define MAX_CASES 1000

void yyerror(const char*);
void erro(string msg);
int yylex();
int yyparse();

int id_bloco = 0;
string codigoVarsProcedimento = "";
int id_label = 0;
string tipo_retorno_atual = "";

typedef pair<Atributo, string> SCase;
vector<SCase> listaSCases;

typedef map<string, SimboloFuncao> TSF;
TSF tabelaFuncoes;

typedef map<string, SimboloVariavel> TSV;
vector<TSV> tabelaVariaveis;
TSV tabelaVariaveisArgumentos;

vector<string> split(string s, char delim);
string toStr(int n);
void replaceAll(string &s, const string &search, const string &replace);

string validarAcessoArray(string var, string dims);
vector<string> traduzDimensoesArray(string aux);
string gerarIncludeC(string bib);
string declararVariavel(string tipo_base, string vars, int bloco);
void inserirVariavelTabela(TSV &tabela, Tipo tipo, string nome, int bloco);
bool variavelDeclarada(const TSV &tabela, string nome);
Atributo buscaVariavel(string nome);
void removerBlocoVars();
void adicionarNovaTabelaVariaveis();

void adicionarVariaveisProcedimento(string codigo);
void resetVariaveisProcedimento();

vector<Argumento> converteParaVectorArgumentos(const vector<string> &params_split);
void inicializaResultadoOperador();
Tipo tipoResultadoBinario(const Tipo &a, string op, const Tipo &b);
Tipo tipoResultadoUnario(string op, const Tipo &a);
void resetVarsTemp();
string gerarCodigoVarsTemp();
string gerarVarTemp(const Tipo &t);
void gerarCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3);
void gerarCodigoOperadorUnario(Atributo &SS, const Atributo &S1, const Atributo &S2);
bool funcaoDeclarada(string nome);
string gerarCodigoPrototipo(string tipo, string nome, string listaParams);
void adicionarFuncaoImplementada(string tipo, string nome, string listaParams);

string gerarCodigoReturn(const Atributo &S2);

string gerarCodigoPrint(const Atributo &S);

string verificarTiposChamadaFuncao(string nome, string parametros);

string gerarLabel();
string gerarBreak();
string gerarCodigoIfElse(const Atributo &condicao, const Atributo &cod_if, const Atributo &cod_else);
string gerarCodigoWhile(const Atributo &condicao, const Atributo &cod);
string gerarCodigoDoWhile(const Atributo &condicao, const Atributo &cod);
string gerarCodigoFor(const Atributo &init, const Atributo &condicao, const Atributo &upd, const Atributo &cod);
string gerarCodigoSwitch(const Atributo &expr, const Atributo &cod);

void verificarPrototiposDeclarados();

%}

%token TK_INICIO TK_INCLUDE TK_BIB_INCLUDE TK_PROTOTIPO
%token TK_ID TK_CTE_INT TK_CTE_DOUBLE TK_CTE_FLOAT TK_CTE_CHAR TK_CTE_STRING TK_CTE_BOOL_TRUE TK_CTE_BOOL_FALSE
%token TK_INT TK_DOUBLE TK_FLOAT TK_STRING TK_CHAR TK_BOOL TK_VOID TK_NULL
%token TK_DECLARAR_VAR TK_AS
%token TK_MAIN TK_COMECA_BLOCO TK_TERMINA_BLOCO TK_TERMINA_MAIN TK_COMECA_FUNCAO TK_TERMINA_FUNCAO
%token TK_ADICAO TK_SUBTRACAO TK_MULTIPLICACAO TK_DIVISAO TK_MODULO
%token TK_COMP_MENOR TK_COMP_MAIOR TK_COMP_MENOR_IGUAL TK_COMP_MAIOR_IGUAL TK_COMP_IGUAL TK_COMP_DIFF
%token TK_OR TK_AND TK_NOT
%token TK_ATRIBUICAO
%token TK_IF TK_ELSE TK_FOR TK_DO TK_WHILE TK_SWITCH TK_CASE TK_DEFAULT TK_BREAK
%token TK_RETURN
%token TK_PRINT TK_SCAN

%right TK_ATRIBUICAO
%left TK_AND TK_OR
%nonassoc TK_COMP_IGUAL TK_COMP_DIFF
%nonassoc TK_COMP_MENOR TK_COMP_MAIOR TK_COMP_MENOR_IGUAL TK_COMP_MAIOR_IGUAL
%left TK_ADICAO TK_SUBTRACAO
%left TK_MULTIPLICACAO TK_DIVISAO TK_MODULO
%right TK_NOT

%%

S : TK_INICIO INCLUDES PROT VARS_GLOBAIS FUNCOES MAIN FUNCOES	
      { 
        verificarPrototiposDeclarados();
        cout << "// *****Welcome to the Game Of Thrones*****\n\n\n"
        << $2.c << "#include <stdio.h>\n"
                   "#include <stdlib.h>\n"
                   "#include <string.h>\n"
        << "\n"
        << $3.c // prototipos
        << $4.c // vars_globais
        << $5.c + $7.c // funcoes
        << $6.c // main
        << endl;
      }
  ;

MAIN : COMECA_MAIN CORPO TK_TERMINA_MAIN
        {
            $$ = Atributo();
            $$.c = "\n"
                   "int main() {\n" +
                   gerarCodigoVarsTemp() +
                   codigoVarsProcedimento + '\n' +
                   $2.c +
                   "\n" +
                   TAB + "return 0;\n"
                   "}\n";
            resetVarsTemp();
            removerBlocoVars();
            resetVariaveisProcedimento();
        }
     ;

COMECA_MAIN : TABELA_VARS TK_MAIN { tipo_retorno_atual = C_INT; }
            ;

FUNCOES : FUNCAO FUNCOES { $$.c = $1.c + $2.c; }
        | { $$ = Atributo(); }
        ;

FUNCAO : CABECALHO_FUNCAO BLOCO
        {
            $$ = Atributo();
            $$.t = $1.t;
            $$.c = $1.c + "{\n" +
                   gerarCodigoVarsTemp() +
                   codigoVarsProcedimento + '\n' +
                   $2.c +
                   "}\n";

            resetVarsTemp();
            resetVariaveisProcedimento();
        }
       ;

CABECALHO_FUNCAO : TIPO TK_ID '(' LISTA_ARGUMENTOS ')' { 
                    adicionarFuncaoImplementada($1.v, $2.v, $4.c);

                    string t = $1.v;
                    if($1.v == C_BOOL)
                      t = C_INT;

                    $$ = Atributo();
                    $$.t = Tipo($1.v);
                    $$.c = "\n" + t + " " + $2.v + "(" + $4.c + ")";

                    tipo_retorno_atual = $1.v;
                 }
                 ;

INCLUDES : TK_INCLUDE TK_BIB_INCLUDE INCLUDES { $$ = Atributo(); $$.c = gerarIncludeC($2.v) + $3.c; }
         | { $$ = Atributo(); }
         ;

PROT : TK_PROTOTIPO TIPO TK_ID '(' LISTA_ARGUMENTOS ')' ';' PROT {
         $$ = Atributo();
         $$.c = gerarCodigoPrototipo($2.v, $3.v, $5.c) + "\n" + $8.c;
         tabelaVariaveisArgumentos.clear();
       }
     | { $$ = Atributo(); tabelaVariaveisArgumentos.clear(); }
     ;

TIPO : TK_INT     { $$ = Atributo(C_INT);     }
     | TK_DOUBLE  { $$ = Atributo(C_DOUBLE);  }
     | TK_FLOAT   { $$ = Atributo(C_FLOAT);   }
     | TK_STRING  { $$ = Atributo(C_STRING);  }
     | TK_CHAR    { $$ = Atributo(C_CHAR);    }
     | TK_BOOL    { $$ = Atributo(C_BOOL);    }
     | TK_VOID    { $$ = Atributo(C_VOID);    }
     ;

LISTA_ARGUMENTOS : ARGUMENTOS { $$ = Atributo(); $$.c = $1.c; }
                 | { $$ = Atributo(); }
                 ;

ARGUMENTOS : TIPO TK_ID ARRAY ',' ARGUMENTOS {
              $$ = Atributo();

              string t = $1.v;
              if($1.v == C_BOOL)
                t = C_INT;

              $$.c = t + " " + $2.v + $3.c + ", " + $5.c;

              if(tabelaVariaveisArgumentos.count($2.v) > 0)
                erro("Argumento com mesmo nome já foi declarado.");
              else
                tabelaVariaveisArgumentos[$2.v] = SimboloVariavel($2.v, $1.v, -1);

             }
           | TIPO TK_ID ARRAY {
              $$ = Atributo();

              string t = $1.v;
              if($1.v == C_BOOL)
                t = C_INT;

              $$.c = t + " " + $2.v + $3.c; 

              if(tabelaVariaveisArgumentos.count($2.v) > 0)
                erro("Argumento com mesmo nome já foi declarado.");
              else
                tabelaVariaveisArgumentos[$2.v] = SimboloVariavel($2.v, $1.v, -1);

             }
           ;

VARS_GLOBAIS : TABELA_VARS VAR_GLOBAL VARS_GLOBAIS { $$ = Atributo();  $$.c = $1.c + $2.c; }
             | { $$ = Atributo(); }
             ;

TABELA_VARS : { adicionarNovaTabelaVariaveis(); }
            ;

VAR_GLOBAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO ';' { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, 0) + ";\n"; }
           ;

LISTA_IDS : TK_ID ARRAY ',' LISTA_IDS { $$ = Atributo(); $$.c = $1.v + $2.c + "," + $4.c; } // FALTA ARRAY
          | TK_ID ARRAY { $$ = Atributo(); $$.c = $1.v + $2.c; }
          ;

ARRAY : '[' TK_CTE_INT ']' ARRAY { $$ = Atributo(); $$.c = "[" + $2.v + "]" + $4.c; }
      | { $$ = Atributo(); }
      ;

BLOCO : COMECA_BLOCO CORPO TK_TERMINA_BLOCO      { $$.c = $2.c; removerBlocoVars(); }
      | COMECA_BLOCO CORPO TK_TERMINA_FUNCAO   	 { $$.c = $2.c; removerBlocoVars(); }
      ;

COMECA_BLOCO : TABELA_VARS TK_COMECA_BLOCO  { }
             | TABELA_VARS TK_COMECA_FUNCAO { }
             ;

CORPO : VARS_LOCAIS COMANDOS { adicionarVariaveisProcedimento($1.c); $$.c = $2.c; }
      ;

VARS_LOCAIS : VAR_LOCAL VARS_LOCAIS  { $$ = Atributo(); $$.c = $1.c + $2.c; }
            | { $$ = Atributo(); }
            ;

VAR_LOCAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO ';' { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, id_bloco) + ";\n"; }
          ;

COMANDOS : COMANDO COMANDOS { $$.c = $1.c + $2.c; }
         | { $$ = Atributo(); }
         ;

COMANDO : EXPRESSAO ';'
        | COMANDO_IF
        | COMANDO_WHILE
        | COMANDO_DO_WHILE ';'
        | COMANDO_FOR
        | COMANDO_SWITCH
        | COMANDO_RETURN ';'
        | COMANDO_SCAN ';'
        | COMANDO_PRINT ';'
        | COMANDO_BREAK ';'
        | BLOCO
        | ';' { $$ = Atributo(); }
        ;


CHAMADA_FUNCAO : TK_ID '(' LISTA_PARAMETROS ')' { 
                                                  $$ = Atributo();

                                                  // $3.v => tipo var, tipo var, etc.
                                                  string lista = verificarTiposChamadaFuncao($1.v, $3.v);
                                                  $$.t = Tipo(tabelaFuncoes[$1.v].retorno.nome);
                                                  $$.v = gerarVarTemp($$.t);
                                                  $$.c = $3.c + TAB + $$.v + " = " + $1.v + "(" + lista + ");\n";

                                                }
               ;

LISTA_PARAMETROS : PARAMETROS { $$ = Atributo(); $$.c = $1.c; $$.v = $1.v; }
                 | { $$ = Atributo(); }
                 ;

PARAMETROS : EXPRESSAO ',' PARAMETROS {
                                        $$ = Atributo();
                                        string endereco = "";

                                        if($1.t.nome == C_STRING && $1.t.ndim > 0)
                                          endereco = "&";

                                        $$.v = $1.t.nome + " " + $1.v + "," + $3.v;
                                        $$.c = $1.c + $3.c;

                                      }
           | EXPRESSAO {
                          string endereco = "";
                          if($1.t.nome == C_STRING && $1.t.ndim > 0)
                            endereco = "&";

                          $$ = Atributo($1.t.nome + " " + $1.v, $1.t, $1.c);

                       }
           ;

EXPRESSAO : EXPRESSAO TK_ADICAO EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_SUBTRACAO EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_MULTIPLICACAO EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_DIVISAO EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_MODULO EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MENOR EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MAIOR EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MENOR_IGUAL EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MAIOR_IGUAL EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_IGUAL EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_DIFF EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_OR EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_AND EXPRESSAO
            { gerarCodigoOperadorBinario($$, $1, $2, $3); }
          | TK_NOT EXPRESSAO
            { gerarCodigoOperadorUnario($$, $1, $2); }
          | TK_ID ARRAY TK_ATRIBUICAO EXPRESSAO
            { 
              Atributo A = buscaVariavel($1.v);
              string posicaoAcesso = validarAcessoArray($1.v, $2.c); 
              A.v = A.v + posicaoAcesso;
              gerarCodigoOperadorBinario($$, A, $3, $4);
            }
          | CHAMADA_FUNCAO
            { $$ = $1; }
          | '(' EXPRESSAO ')'
            { $$ = $2; }
          | TERMINAL
            { $$ = $1; }
          ;

TERMINAL : TK_ID ARRAY
           { $$ = buscaVariavel($1.v); string posicaoAcesso = validarAcessoArray($1.v, $2.c); 
             $$.v = $$.v + posicaoAcesso;
           }
         | TK_CTE_INT
           { $$ = Atributo($1.v, C_INT); }
         | TK_CTE_DOUBLE
           { $$ = Atributo($1.v, C_DOUBLE); }
         | TK_CTE_FLOAT
           { $$ = Atributo($1.v, C_FLOAT); }
         | TK_CTE_CHAR
           { $$ = Atributo($1.v, C_CHAR); }
         | TK_CTE_STRING
           { $$ = Atributo($1.v, C_STRING); }
         | TK_CTE_BOOL_TRUE
           { $$ = Atributo("1", C_BOOL); }
         | TK_CTE_BOOL_FALSE
           { $$ = Atributo("0", C_BOOL); }
         | TK_NULL
           { $$ = Atributo("0", C_INT); }
         ;

COMANDO_IF : TK_IF '(' EXPRESSAO ')' BLOCO
             { $$.c = gerarCodigoIfElse($3, $5, Atributo()); }
           | TK_IF '(' EXPRESSAO ')' BLOCO TK_ELSE BLOCO
             { $$.c = gerarCodigoIfElse($3, $5, $7); }
           ;

COMANDO_WHILE : TK_WHILE '(' EXPRESSAO ')' BLOCO
                { $$.c = gerarCodigoWhile($3, $5); }
              ;

COMANDO_DO_WHILE : TK_DO BLOCO TK_WHILE '(' EXPRESSAO ')'
                   { $$.c = gerarCodigoDoWhile($5, $2); }
                 ;

COMANDO_FOR : TK_FOR '(' EXPRESSAO_FOR ';' EXPRESSAO_FOR ';' EXPRESSAO_FOR ')' BLOCO
              { $$.c = gerarCodigoFor($3, $5, $7, $9); }
            ;

EXPRESSAO_FOR : EXPRESSAO { $$ = $1; }
              | { $$ = Atributo(); }
              ;

COMANDO_SWITCH : TK_SWITCH '(' EXPRESSAO ')' TK_COMECA_BLOCO LISTA_CASE TK_TERMINA_BLOCO
                 { $$.c = gerarCodigoSwitch($3, $6); }
               ;

LISTA_CASE : CASE LISTA_CASE
           | DEFAULT
           |
           ;

CASE : TK_CASE TERMINAL ':' CORPO
       { listaSCases.push_back(make_pair($2, $4.c)); }
     ;

DEFAULT : TK_DEFAULT ':' CORPO
          { listaSCases.push_back(make_pair(Atributo(), $3.c)); }
        ;

COMANDO_BREAK : TK_BREAK { $$.c = gerarBreak(); }
              ;

COMANDO_RETURN : TK_RETURN EXPRESSAO { $$ = Atributo(); $$.c = gerarCodigoReturn($2); }
               | TK_RETURN {
                  $$ = Atributo();

                  if(tipo_retorno_atual == C_VOID)
                    $$.c = TAB "return ;\n";
                  else
                    erro("Tipo de retorno deve ser igual ao retorno da função.");
                }
               ;

COMANDO_SCAN : TK_SCAN '(' TK_ID ')'
             ;

COMANDO_PRINT : TK_PRINT '(' EXPRESSAO ')' { $$.c = gerarCodigoPrint($3); }
              ;

%%

int contadorLinha = 1;

map<string, Tipo> resultadoOperador;
map<string, int> n_var_temp;

void inicializaResultadoOperador() {
    // = 
    resultadoOperador["int=int"] = Tipo("int");
    resultadoOperador["double=double"] = Tipo("double");
    resultadoOperador["float=float"] = Tipo("float");
    resultadoOperador["double=int"] = Tipo("double");
    resultadoOperador["float=int"] = Tipo("float");
    resultadoOperador["double=float"] = Tipo("double");
    resultadoOperador["string=string"] = Tipo("string");
    resultadoOperador["string=char"] = Tipo("string");
    resultadoOperador["char=char"] = Tipo("char");
    resultadoOperador["char=int"] = Tipo("char");
    resultadoOperador["int=char"] = Tipo("int");
    resultadoOperador["bool=bool"] = Tipo("bool");

    // +
    resultadoOperador["int+int"] = Tipo("int");
    resultadoOperador["double+double"] = Tipo("double");
    resultadoOperador["float+float"] = Tipo("float");
    resultadoOperador["double+int"] = Tipo("double");
    resultadoOperador["int+double"] = Tipo("double");
    resultadoOperador["float+int"] = Tipo("float");
    resultadoOperador["int+float"] = Tipo("float");
    resultadoOperador["double+float"] = Tipo("double");
    resultadoOperador["float+double"] = Tipo("double");
    resultadoOperador["string+string"] = Tipo("string");
    resultadoOperador["string+char"] = Tipo("string");
    resultadoOperador["char+string"] = Tipo("string");
    resultadoOperador["char+char"] = Tipo("char");
    resultadoOperador["char+int"] = Tipo("int");
    resultadoOperador["int+char"] = Tipo("int");


    // -
    resultadoOperador["int-int"] = Tipo("int");
    resultadoOperador["double-double"] = Tipo("double");
    resultadoOperador["float-float"] = Tipo("float");
    resultadoOperador["double-int"] = Tipo("double");
    resultadoOperador["int-double"] = Tipo("double");
    resultadoOperador["float-int"] = Tipo("float");
    resultadoOperador["int-float"] = Tipo("float");
    resultadoOperador["double-float"] = Tipo("double");
    resultadoOperador["float-double"] = Tipo("double");
    resultadoOperador["char-int"] = Tipo("int");
    resultadoOperador["int-char"] = Tipo("int");

    // *
    resultadoOperador["int*int"] = Tipo("int");
    resultadoOperador["double*double"] = Tipo("double");
    resultadoOperador["float*float"] = Tipo("float");
    resultadoOperador["double*int"] = Tipo("double");
    resultadoOperador["int*double"] = Tipo("double");
    resultadoOperador["float*int"] = Tipo("float");
    resultadoOperador["int*float"] = Tipo("float");
    resultadoOperador["double*float"] = Tipo("double");
    resultadoOperador["float*double"] = Tipo("double");

    // /
    resultadoOperador["int/int"] = Tipo("int");
    resultadoOperador["double/double"] = Tipo("double");
    resultadoOperador["float/float"] = Tipo("float");
    resultadoOperador["double/int"] = Tipo("double");
    resultadoOperador["int/double"] = Tipo("double");
    resultadoOperador["float/int"] = Tipo("float");
    resultadoOperador["int/float"] = Tipo("float");
    resultadoOperador["double/float"] = Tipo("double");
    resultadoOperador["float/double"] = Tipo("double");

    // <
    resultadoOperador["int<int"] = Tipo("bool");
    resultadoOperador["double<double"] = Tipo("bool");
    resultadoOperador["float<float"] = Tipo("bool");
    resultadoOperador["double<int"] = Tipo("bool");
    resultadoOperador["int<double"] = Tipo("bool");
    resultadoOperador["float<int"] = Tipo("bool");
    resultadoOperador["int<float"] = Tipo("bool");
    resultadoOperador["double<float"] = Tipo("bool");
    resultadoOperador["float<double"] = Tipo("bool");
    resultadoOperador["string<string"] = Tipo("bool");
    resultadoOperador["char<char"] = Tipo("bool");
    resultadoOperador["char<int"] = Tipo("bool");
    resultadoOperador["int<char"] = Tipo("bool");

    // >
    resultadoOperador["int>int"] = Tipo("bool");
    resultadoOperador["double>double"] = Tipo("bool");
    resultadoOperador["float>float"] = Tipo("bool");
    resultadoOperador["double>int"] = Tipo("bool");
    resultadoOperador["int>double"] = Tipo("bool");
    resultadoOperador["float>int"] = Tipo("bool");
    resultadoOperador["int>float"] = Tipo("bool");
    resultadoOperador["double>float"] = Tipo("bool");
    resultadoOperador["float>double"] = Tipo("bool");
    resultadoOperador["string>string"] = Tipo("bool");
    resultadoOperador["char>char"] = Tipo("bool");
    resultadoOperador["char>int"] = Tipo("bool");
    resultadoOperador["int>char"] = Tipo("bool");

    // <=
    resultadoOperador["int<=int"] = Tipo("bool");
    resultadoOperador["double<=double"] = Tipo("bool");
    resultadoOperador["float<=float"] = Tipo("bool");
    resultadoOperador["double<=int"] = Tipo("bool");
    resultadoOperador["int<=double"] = Tipo("bool");
    resultadoOperador["float<=int"] = Tipo("bool");
    resultadoOperador["int<=float"] = Tipo("bool");
    resultadoOperador["double<=float"] = Tipo("bool");
    resultadoOperador["float<=double"] = Tipo("bool");
    resultadoOperador["string<=string"] = Tipo("bool");
    resultadoOperador["char<=char"] = Tipo("bool");
    resultadoOperador["char<=int"] = Tipo("bool");
    resultadoOperador["int<=char"] = Tipo("bool");

    // >=
    resultadoOperador["int>=int"] = Tipo("bool");
    resultadoOperador["double>=double"] = Tipo("bool");
    resultadoOperador["float>=float"] = Tipo("bool");
    resultadoOperador["double>=int"] = Tipo("bool");
    resultadoOperador["int>=double"] = Tipo("bool");
    resultadoOperador["float>=int"] = Tipo("bool");
    resultadoOperador["int>=float"] = Tipo("bool");
    resultadoOperador["double>=float"] = Tipo("bool");
    resultadoOperador["float>=double"] = Tipo("bool");
    resultadoOperador["string>=string"] = Tipo("bool");
    resultadoOperador["char>=char"] = Tipo("bool");
    resultadoOperador["char>=int"] = Tipo("bool");
    resultadoOperador["int>=char"] = Tipo("bool");

    // ==
    resultadoOperador["int==int"] = Tipo("bool");
    resultadoOperador["double==double"] = Tipo("bool");
    resultadoOperador["float==float"] = Tipo("bool");
    resultadoOperador["double==int"] = Tipo("bool");
    resultadoOperador["int==double"] = Tipo("bool");
    resultadoOperador["float==int"] = Tipo("bool");
    resultadoOperador["int==float"] = Tipo("bool");
    resultadoOperador["double==float"] = Tipo("bool");
    resultadoOperador["float==double"] = Tipo("bool");
    resultadoOperador["string==string"] = Tipo("bool");
    resultadoOperador["char==char"] = Tipo("bool");
    resultadoOperador["char==int"] = Tipo("bool");
    resultadoOperador["int==char"] = Tipo("bool");
    resultadoOperador["bool==bool"] = Tipo("bool");

    // !=
    resultadoOperador["int!=int"] = Tipo("bool");
    resultadoOperador["double!=double"] = Tipo("bool");
    resultadoOperador["float!=float"] = Tipo("bool");
    resultadoOperador["double!=int"] = Tipo("bool");
    resultadoOperador["int!=double"] = Tipo("bool");
    resultadoOperador["float!=int"] = Tipo("bool");
    resultadoOperador["int!=float"] = Tipo("bool");
    resultadoOperador["double!=float"] = Tipo("bool");
    resultadoOperador["float!=double"] = Tipo("bool");
    resultadoOperador["string!=string"] = Tipo("bool");
    resultadoOperador["char!=char"] = Tipo("bool");
    resultadoOperador["char!=int"] = Tipo("bool");
    resultadoOperador["int!=char"] = Tipo("bool");
    resultadoOperador["bool!=bool"] = Tipo("bool");

    // ||
    resultadoOperador["bool||bool"] = Tipo("bool");

    // &&
    resultadoOperador["bool&&bool"] = Tipo("bool");

    // !
    resultadoOperador["!bool"] = Tipo("bool");

    // %
    resultadoOperador["int%int"] = Tipo("int");
}

#include "lex.yy.c"

void yyerror( const char* st ){
    puts(st);
    printf("[%sERRO%s] Na linha: %d. Perto de: '%s'\n", COLOR_RED, COLOR_RESET, contadorLinha, yytext);
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
    return "#include " + bib + "\n";
}

string declararVariavel(string tipo_base, string vars, int bloco) {
    vector<string> vetorVars = split(vars, ',');

    string codigo = bloco ? TAB : "";
    if (tipo_base == C_STRING)
        codigo += string(C_CHAR) + " ";
    else if(tipo_base == C_BOOL)
        codigo += string(C_INT) + " ";
    else
        codigo += tipo_base + " ";

    TSV &tabela = tabelaVariaveis.back(); // Tabela do topo da pilha

    for (int i = 0; i < vetorVars.size(); i++) {
        if (i > 0) codigo += ", ";

        string nomeVar = vetorVars[i] + "_" + toStr(bloco);
        Tipo tipo_verificado = tipo_base;
        string nome_verificado = vetorVars[i];

        if (vetorVars[i].find("[") != string::npos) {          
            vector<string> dims = traduzDimensoesArray(vetorVars[i]);

            if (dims.size() > 3)
                erro("Array com dimensoes invalidas. (Max = 2 dimensoes)");

            // posições geradas pelo split => [ 0 => var_nome, 1 =>  dim1, 2 =>  dim2]
            if (dims.size() > 2){
                tipo_verificado.ndim = 2;
                tipo_verificado.t_dim[0] = atoi(dims[1].c_str());
                tipo_verificado.t_dim[1] = atoi(dims[2].c_str());
            }
            else {
                tipo_verificado.ndim = 1;
                tipo_verificado.t_dim[0] = atoi(dims[1].c_str());
            }
            nome_verificado = dims[0];
        }

        inserirVariavelTabela(tabela, tipo_verificado, nome_verificado, bloco);

        int qtd_elementos = 0;

        if (tipo_verificado.ndim == 1)
            qtd_elementos = tipo_verificado.t_dim[0];
        else if (tipo_verificado.ndim == 2)
            qtd_elementos = tipo_verificado.t_dim[0] * tipo_verificado.t_dim[1];

        if (tipo_base == C_STRING) {
            if (qtd_elementos > 0)
                qtd_elementos = qtd_elementos * MAX_STR;
            else
                qtd_elementos = MAX_STR;
        }

        if (qtd_elementos > 0)
            codigo = codigo + nome_verificado + "_" + toStr(bloco) + "[" + toStr(qtd_elementos) + "]";
        else
            codigo = codigo + nome_verificado + "_" + toStr(bloco);;
    }

    return codigo;
}

vector<string> traduzDimensoesArray(string aux) {
    replaceAll(aux, "[", ",");
    replaceAll(aux, "]", "");
    vector<string> dims = split(aux, ',');
    return dims;
}

string validarAcessoArray(string var, string dims) {
    string codigo = "";
    vector<string> dimsAcesso = traduzDimensoesArray(dims);
    int posicao;
    Atributo variavel = buscaVariavel(var);

    if (dimsAcesso.size() > 0) {
        if (dimsAcesso.size()-1 != variavel.t.ndim) {
            erro("Acesso de indice invalido: A variavel " + var + " possui " + toStr(variavel.t.ndim) +
                " dimensoes. Você usou " + toStr(dimsAcesso.size()) + " dimensoes. Use a quantidade correta.");
        }

        for(int i = 1; i < dimsAcesso.size(); i++){
            if(atoi(dimsAcesso[i].c_str()) >= variavel.t.t_dim[i-1]
                || atoi(dimsAcesso[i].c_str()) < 0)
                erro("Indice fora dos limites. Tentou acessar posição " +  dimsAcesso[i] + " no total de " + toStr(variavel.t.t_dim[i-1]) +
                    "(de 0 a " + toStr(variavel.t.t_dim[i-1]-1) + ") na dimensao " + toStr(i-1));
        }

        if (variavel.t.ndim == 1) 
            posicao = atoi(dimsAcesso[1].c_str());
        else
            posicao = variavel.t.t_dim[1]*atoi(dimsAcesso[1].c_str()) + atoi(dimsAcesso[2].c_str());

        if(variavel.t.nome == C_STRING){
          codigo = "[" + toStr(posicao*256) + "]";
        }
        else{
          codigo = "[" + toStr(posicao) + "]";
        }

    }
    else {
        if (variavel.t.ndim > 0)
            erro("Falta especificar indice do array: " + var);
    }

    return codigo;
}

void inserirVariavelTabela(TSV &tabela, Tipo tipo, string nome, int bloco){
    string nome_bloco = nome + "_" + toStr(bloco);
    if (!variavelDeclarada(tabela, nome)) 
        tabela[nome] = SimboloVariavel(nome_bloco, tipo, bloco);
    else
        erro("Variavel ja definida: " + nome + "\n");
}

bool variavelDeclarada(const TSV &tabela, string nome){
    return tabela.find(nome) != tabela.end();
}

Atributo buscaVariavel(string nome) {
    for (int i = tabelaVariaveis.size()-1; i >= 0; i--) {
        if (variavelDeclarada(tabelaVariaveis[i], nome)) {
            const SimboloVariavel &var = tabelaVariaveis[i][nome];
            return Atributo(var.nome, var.t);
        }
    }
    erro("Variavel nao declarada: " + nome);
    return Atributo();
}

void removerBlocoVars() {
    if (tabelaVariaveis.empty())
        return;
    tabelaVariaveis.pop_back();
}

void adicionarNovaTabelaVariaveis(){
    TSV tabela;
    id_bloco++;

    for (auto &arg : tabelaVariaveisArgumentos) {
        arg.second.bloco = id_bloco;
        tabela[arg.first] = arg.second;
    }

    tabelaVariaveisArgumentos.clear();
    tabelaVariaveis.push_back(tabela);
}

vector<string> split(string s, char delim){
    vector<string> elems;
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim))
        elems.push_back(item);
    return elems;
}

string trim(string const& str)
{
    size_t first = str.find_first_not_of(' ');
    size_t last  = str.find_last_not_of(' ');
    return str.substr(first, last-first+1);
}

void replaceAll(string &s, const string &search, const string &replace) {
    for (size_t pos = 0; ; pos += replace.length()) {
        // Locate the substring to replace
        pos = s.find(search, pos);
        if (pos == string::npos) break;
        s.replace(pos, search.length(), replace);
    }
}

Tipo tipoResultadoBinario(const Tipo &a, string op, const Tipo &b) {
    if (resultadoOperador.find(a.nome + op + b.nome) == resultadoOperador.end())
        erro("Operacao nao permitida: " + a.nome + op + b.nome);
    return resultadoOperador[a.nome + op + b.nome];
}

Tipo tipoResultadoUnario(string op, const Tipo &a) {
    if (resultadoOperador.find(op + a.nome) == resultadoOperador.end())
        erro("Operacao nao permitida: " + op + a.nome);
    return resultadoOperador[op + a.nome];
}

void resetVarsTemp() {
    n_var_temp.clear();
}

string gerarCodigoVarsTemp() {
    string cod;
    for (const auto &tipo : n_var_temp) {
        for (int i = 0; i < tipo.second; i++) {
            string tp = tipo.first;
            if (tp == C_STRING) {
                tp = C_CHAR;
                cod += TAB + tp + " temp_" + tipo.first + "_" + toStr(i) + "[" + toStr(MAX_STR) + "];\n";
            }
            else {
                if (tp == C_BOOL)
                    tp = C_INT;
                cod += TAB + tp + " temp_" + tipo.first + "_" + toStr(i) + ";\n";
            }
        }
    }
    return cod;
}

string gerarVarTemp(const Tipo &t) {
    return "temp_" + t.nome + "_" + toStr(n_var_temp[t.nome]++);
}

void adicionarVariaveisProcedimento(string codigo) {
    codigoVarsProcedimento = codigoVarsProcedimento + codigo;
}
void resetVariaveisProcedimento() {
    codigoVarsProcedimento = "";
}

void gerarCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3) {
    SS.t = tipoResultadoBinario(S1.t, S2.v, S3.t);
    SS.c = S1.c + S3.c;

    if (S2.v == "=") {
        SS.v = S1.v;
        string endereco = "";

        if (S1.t.ndim > 0) endereco = "&";

        if (SS.t.nome == C_STRING) {
            if (S1.t.nome == C_STRING && S3.t.nome == C_STRING)
                SS.c += TAB "sprintf(" + endereco + S1.v + ", \"%s\", " + S3.v + ");\n";
            else
                SS.c += TAB "sprintf(" + endereco + S1.v + ", \"%c\", " + S3.v + ");\n";
        }
        else {
            SS.c += TAB + S1.v + " = " + S3.v + ";\n";
        }
    }
    else {
        SS.v = gerarVarTemp(SS.t);

        if (SS.t.nome == C_STRING) { // se o resultado e' C_STRING, entao a operacao e' de concatenacao
            string endereco1 = "", endereco2 = "";

            // Tratando caso de vetor de strings
            if (S1.t.ndim > 0 && S1.t.nome == C_STRING)
                endereco1 = "&";
            if (S3.t.ndim > 0 && S3.t.nome == C_STRING)
                endereco2 = "&";

            if (S1.t.nome == C_STRING && S3.t.nome == C_STRING)
                SS.c += TAB "sprintf(" + SS.v + ", \"%s%s\", " + endereco1 + S1.v + ", " + endereco2 +  S3.v + ");\n";
            else if (S1.t.nome == C_STRING && S3.t.nome == C_CHAR)
                SS.c += TAB "sprintf(" + SS.v + ", \"%s%c\", " +  endereco1 + S1.v + ", " + S3.v + ");\n";
            else
                SS.c += TAB "sprintf(" + SS.v + ", \"%c%s\", " + S1.v + ", " +  endereco2 + S3.v + ");\n";
        }
        else if (SS.t.nome == C_BOOL && S1.t.nome == C_STRING) { // comparacao de strings
            SS.c += TAB + SS.v + " = strcmp(" + S1.v + ", " + S3.v + ") " + S2.v + " 0;\n";
        }
        else {
            SS.c += TAB + SS.v + " = " + S1.v + " " + S2.v + " " + S3.v + ";\n";
        }
    }
}

void gerarCodigoOperadorUnario(Atributo &SS, const Atributo &S1, const Atributo &S2) {
    SS.t = tipoResultadoUnario(S1.v, S2.t);

    SS.v = gerarVarTemp(SS.t);
    SS.c = S2.c +
           TAB + SS.v + " = " + S1.v + S2.v + ";\n";
}

string gerarCodigoPrint(const Atributo &S){
  string codigo = string(TAB) + "printf";
  string endereco = "";
  
  if(S.t.ndim > 0)
    endereco = "&";

  if(S.t.nome == C_INT)
    codigo += "(\"%d\", " + S.v + ");\n";
  else if(S.t.nome == C_CHAR)
    codigo += "(\"%c\", " + S.v + ");\n";
  else if(S.t.nome == C_FLOAT)
    codigo += "(\"%f\", " + S.v + ");\n";
  else if(S.t.nome == C_DOUBLE)
    codigo += "(\"%lf\", " + S.v + ");\n";
  else if(S.t.nome == C_STRING)
    codigo += "(\"%s\", " + endereco + S.v + ");\n";
  else if(S.t.nome == C_BOOL)
    codigo += "(\"%d\", " + S.v + ");\n";

  return codigo;
}

string gerarLabel() {
    return string("LABEL_") + toStr(id_label++);
}

string gerarCodigoIfElse(const Atributo &condicao, const Atributo &cod_if, const Atributo &cod_else) {
    if (condicao.t.nome != C_BOOL)
        erro("Expressão não booleana."); // TODO fazer uma mensagem melhor
    string codigo;
    string label_if  = gerarLabel();
    string label_end = gerarLabel();
    codigo = condicao.c +
             TAB "if (" + condicao.v + ") goto " + label_if + ";\n" +
             cod_else.c +
             TAB "goto " + label_end + ";\n" +
             label_if + ":\n" +
             cod_if.c +
             label_end + ":\n";
    return codigo;
}

string gerarCodigoWhile(const Atributo &condicao, const Atributo &cod) {
    if (condicao.t.nome != C_BOOL)
        erro("Expressão não booleana."); // TODO fazer uma mensagem melhor
    string codigo;
    string label_if  = gerarLabel();
    string label_cod = gerarLabel();
    string label_end = gerarLabel();
    codigo = label_if + ":\n" +
             condicao.c +
             TAB "if (" + condicao.v + ") goto " + label_cod + ";\n" +
             TAB "goto " + label_end + ";\n" +
             label_cod + ":\n" +
             cod.c +
             TAB "goto " + label_if + ";\n" +
             label_end + ":\n";
    return codigo;
}

string gerarCodigoDoWhile(const Atributo &condicao, const Atributo &cod) {
    if (condicao.t.nome != C_BOOL)
        erro("Expressão não booleana."); // TODO fazer uma mensagem melhor
    string codigo;
    string label_cod = gerarLabel();
    codigo = label_cod + ":\n" +
             cod.c +
             condicao.c +
             TAB "if (" + condicao.v + ") goto " + label_cod + ";\n";
    return codigo;
}

string gerarCodigoFor(const Atributo &init, const Atributo &condicao, const Atributo &upd, const Atributo &cod) {
    if (condicao.t.nome != C_BOOL)
        erro("Expressão não booleana."); // TODO fazer uma mensagem melhor
    string codigo;
    string label_if  = gerarLabel();
    string label_cod = gerarLabel();
    string label_end = gerarLabel();
    codigo = init.c +
             label_if + ":\n" +
             condicao.c +
             TAB "if (" + condicao.v + ") goto " + label_cod + ";\n" +
             TAB "goto " + label_end + ";\n" +
             label_cod + ":\n" +
             cod.c +
             upd.c +
             TAB "goto " + label_if + ";\n" +
             label_end + ":\n";
    return codigo;
}

string gerarCodigoSwitch(const Atributo &expr, const Atributo &cod) {
    string condicoes;
    string blocos;

    for (const auto &c : listaSCases) {
        string label = gerarLabel();
        if (c.first.v != "") {
            Atributo a;
            gerarCodigoOperadorBinario(a, expr, Atributo("=="), c.first);
            condicoes += a.c +
                         TAB "if (" + a.v + ") goto " + label + ";\n";
            blocos += label + ":\n" +
                      c.second;
        }
        else {
            condicoes += TAB "goto " + label + ";\n";
            blocos += label + ":\n" +
                      c.second;
        }
    }

    string label_end = gerarLabel();
    condicoes += TAB "goto " + label_end + ";\n";
    blocos += label_end + ":\n";

    replaceAll(blocos, C_TK_BREAK, "goto " + label_end);

    listaSCases.clear();
    return condicoes + blocos;
}

string gerarBreak() {
    return TAB "breaker_of_chains;\n";
}

bool funcaoDeclarada(string nome){
    return tabelaFuncoes.find(nome) != tabelaFuncoes.end();
}

string gerarCodigoPrototipo(string tipo, string nome, string listaParams){
  string codigo = "";
  vector<string> params_split = split(listaParams, ',');
  vector<Argumento> params;

  if(funcaoDeclarada(nome))
    erro("A função " + nome + " já foi declarada.");
  
  string tipo_verificado = tipo;
  if(tipo == C_BOOL)
    tipo_verificado = C_INT;

  codigo = tipo_verificado + " " + nome + "(" + listaParams + ");";

  params = converteParaVectorArgumentos(params_split);

  SimboloFuncao prot = SimboloFuncao(nome, Tipo(tipo), params, listaParams, true);
  tabelaFuncoes[nome] = prot;
  return codigo;
}

void verificarPrototiposDeclarados(){
  for(const auto& kv : tabelaFuncoes)
    if(kv.second.prototipo)
      erro("A função " + kv.second.nome + "(" + kv.second.codigo_params + ") tem protótipo declarado mas não foi implementada.");
}

void adicionarFuncaoImplementada(string tipo, string nome, string listaParams){
  if(funcaoDeclarada(nome)){
    SimboloFuncao &f = tabelaFuncoes[nome];

    if(f.prototipo){
      if(f.codigo_params != listaParams)
        erro("A função " + f.nome + " não corresponde à lista de argumentos do protótipo declarado.");

      f.prototipo = false;
    }
    else
      erro("A função " + f.nome + " já foi declarada.");
  }
  else{
    vector<string> params_split = split(listaParams, ',');

    SimboloFuncao f = SimboloFuncao(nome, Tipo(tipo), converteParaVectorArgumentos(params_split) ,listaParams);
    tabelaFuncoes[nome] = f;
  }
}

vector<Argumento> converteParaVectorArgumentos(const vector<string> &params_split){
  vector<Argumento> params;

  for(int i = 0; i < params_split.size(); i++){
    vector<string> definicao_t_var = split(trim(params_split[i]), ' ');
    Argumento p = Argumento(definicao_t_var[1], Tipo(definicao_t_var[0]));
    params.push_back(p);
  }

  return params;
}

string gerarCodigoReturn(const Atributo &S2){
    if (S2.t.nome != tipo_retorno_atual)
        erro("Tipo de retorno deve ser igual ao retorno da função.");
    return S2.c + TAB + "return " + S2.v + ";\n";
}

string verificarTiposChamadaFuncao(string nome, string parametros){
  string codigo = "";
  vector<string> vetor_params = split(parametros, ',');

  if(!funcaoDeclarada(nome))
    erro("Função " + nome +" não foi declarada.");

  SimboloFuncao f = tabelaFuncoes[nome];

  if(f.params.size() != vetor_params.size())
    erro("Quantidade de argumentos para função " + nome + " está incorreta.");

  for(int i = 0; i < vetor_params.size(); i++){
    vector<string> descricaoParam = split(vetor_params[i], ' '); // 0 => tipo e 1 => nome

    if(descricaoParam[0] != f.params[i].tipo.nome)
      erro("Parâmetro " + toStr(i+1) + " inválido para função " + nome);

    if(i != 0) codigo = codigo + ", ";
    codigo = codigo + descricaoParam[1];
  }

  return codigo;
}

int main (int argc, char *argv[]){
    inicializaResultadoOperador();
    yyparse();
}
