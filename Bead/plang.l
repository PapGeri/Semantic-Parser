%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
#include "Parserbase.h"

using namespace std;
%}

LETTER 		[a-zA-Z]
DIGIT		[0-9]
WS			[ \t\n]

%%

PROGRAM			return Parser::PROGRAM;
PROGRAM_VEGE	return Parser::PROGRAM_VEGE;
VALTOZOK:		return Parser::VALTOZOK;
UTASITASOK:		return Parser::UTASITASOK;
EGESZ			return Parser::EGESZ;
LOGIKAI			return Parser::LOGIKAI;
IGAZ			return Parser::IGAZ;
HAMIS			return Parser::HAMIS;
VAGY			return Parser::VAGY;
ES				return Parser::ES;
NEM				return Parser::NEM;
SKIP			return Parser::SKIP;
HA				return Parser::HA;
AKKOR			return Parser::AKKOR;
KULONBEN		return Parser::KULONBEN;
HA_VEGE			return Parser::HA_VEGE;
CIKLUS			return Parser::CIKLUS;
AMIG			return Parser::AMIG;
CIKLUS_VEGE		return Parser::CIKLUS_VEGE;
KI:				return Parser::KI;
BE:				return Parser::BE;

"<"				return Parser::KISEBB;
">"				return Parser::NAGYOBB;
"<="			return Parser::KISEBB_EGYENLO;
">="			return Parser::NAGYOBB_EGYENLO;
"+"				return Parser::PLUSZ;
"-"				return Parser::MINUSZ;
"="				return Parser::EGYENLO;
":="			return Parser::ERTEKADAS;
"*"				return Parser::SZORZAS;
"/"				return Parser::OSZTAS;
"%"				return Parser::MOD;
"("				return Parser::NYITO_ZAROJEL;
")"				return Parser::CSUKO_ZAROJEL;


{DIGIT}+		return Parser::SZAM;

((_)?|{LETTER})({LETTER}|{DIGIT}|_)*	return Parser::AZONOSITO;
#.*				//Egy soros komment - nincs teendo
{WS}+				//Feher elvalasztok - nincs teendo

.		{
			std::cerr << "Lexical error in line: " << lineno() << std::endl;
			exit(1);
		}

%%