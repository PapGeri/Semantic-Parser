%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
    std::string *szoveg;
    type* var_type;
}

%token NATURAL;
%token BOOLEAN;
%token TRUE;
%token FALSE;
%token NUMBER;
%token ASSIGN;
%token <szoveg> IDENT;
%type <var_type> expr;

%%

start:
    declarations assignments
;

declarations:
    // ures
|
    declaration declarations
;

declaration:
    NATURAL IDENT
    {
        if( sztabla.count(*$2) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
            << "Korabbi deklaracio sora: " << sztabla[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        sztabla[*$2] = var_data( d_loc__.first_line, natural );
        
    }
|
    BOOLEAN IDENT
    {
        if( sztabla.count(*$2) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
            << "Korabbi deklaracio sora: " << sztabla[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        
        sztabla[*$2] = var_data( d_loc__.first_line, boolean );
    }
;

assignments:
    // ures
|
    assignment assignments
;

assignment:
    IDENT ASSIGN expr
    {
        if(sztabla.count(*$1) == 0)
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo" << std::endl;
            error ( ss.str().c_str());
        }
        if( sztabla[*$1].var_type != *$3 )
        {
            error( "Tipushibas ertekadas.\n" );
        }
    }
;

expr:
    IDENT
    {
        if(sztabla.count(*$1) == 0)
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo" << std::endl;
            error ( ss.str().c_str());
        }
        $$ = new type(sztabla[*$1].var_type);
    }
|
    NUMBER
    {
        $$ = new type(natural);
    }
|
    TRUE
    {
        $$ = new type(boolean);
    }
|
    FALSE
    {
        $$ = new type(boolean);
    }
;
