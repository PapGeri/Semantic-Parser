%baseclass-preinclude "semantics.h"
%lsp-needed


%union
{
    std::string *szoveg;
    type* var_type;
}
%token PROGRAM 
%token <szoveg> AZONOSITO
%token VALTOZOK 
%token UTASITASOK 
%token SZAM 
%token PROGRAM_VEGE

%token CIKLUS 
%token AMIG 
%token CIKLUS_VEGE
%token HA 
%token AKKOR 
%token KULONBEN 
%token HA_VEGE
%token SKIP 
%token NYITO_ZAROJEL 
%token CSUKO_ZAROJEL

%token BE 
%token KI 
%token EGESZ 
%token LOGIKAI 
%token IGAZ 
%token HAMIS

%left VAGY
%left ES
%left EGYENLO
%left KISEBB NAGYOBB KISEBB_EGYENLO NAGYOBB_EGYENLO
%left PLUSZ MINUSZ
%left SZORZAS OSZTAS MOD
%left ERTEKADAS

%right NEM

%type <var_type> kifejezes;

%%

start: 
    program {};

program: 
    program_nev deklaraciok program_torzs program_vege {};

program_nev: 
    PROGRAM AZONOSITO {};

deklaraciok: 
    {
        //std::cout << "deklaracio -> epszilon" << std::endl;
    } 
    | 
        VALTOZOK deklaracio deklaraciok {}
    | 
        deklaracio deklaraciok {};

deklaracio: 
    EGESZ AZONOSITO
    {
        if(sztabla.count(*$2) > 0)
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
            << "Korabbi deklaracio sora: " << sztabla[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        sztabla[*$2] = var_data(d_loc__.first_line, natural);
    }
    | LOGIKAI AZONOSITO
    {
        if(sztabla.count(*$2) > 0)
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
            << "Korabbi deklaracio sora: " << sztabla[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        sztabla[*$2] = var_data(d_loc__.first_line, boolean);
    };

program_torzs: 
    UTASITASOK utasitasok {};

utasitasok: 
        utasitas {}
    | 
        utasitas utasitasok {};

utasitas: 
        be {}
    | 
        ki {}
    | 
        skip {}
    | 
        ertekadas {}
    | 
        ciklus {}
    | 
        ha {};

be: 
    BE AZONOSITO {};

ki: 
    KI kifejezes {};

skip: 
    SKIP {};

ertekadas: 
    AZONOSITO ERTEKADAS kifejezes 
    {
     if(sztabla.count(*$1) == 0)
     {
         std::stringstream ss;
         ss << "Nem deklaralt valtozo" << std::endl;
        error(ss.str().c_str());
     }
     if(sztabla[*$1].var_type != *$3 )
     {
         error("Tipushibas ertekadas.\n");
     }
    };

ciklus: 
    CIKLUS AMIG kifejezes utasitasok CIKLUS_VEGE 
    {
        if(*$3 != boolean)
        {
            std::stringstream ss;
            error("Tipushibas ertekadas. \n");
            error(ss.str().c_str());
        }
    };

ha: 
        HA kifejezes AKKOR utasitasok HA_VEGE 
        {
            if(*$2 != boolean)
            {
                std::stringstream ss;
                error("Tipushibas ertekadas. \n");
                error(ss.str().c_str());
            }
        }
    | 
        HA kifejezes AKKOR utasitasok KULONBEN utasitasok HA_VEGE 
        {
            if(*$2 != boolean)
            {
                std::stringstream ss;
                error("Tipushibas ertekadas. \n");
                error(ss.str().c_str());
            }
        };

kifejezes: 
    AZONOSITO 
    {
        if(sztabla.count(*$1) != 0)
        {
            $$ = new type(sztabla[*$1].var_type);
        } else {
            error("Nem deklaralt");
        }
        delete $1;
    } 
    | SZAM 
    {
        $$ = new type(natural);
    } 
    | NEM kifejezes 
    {
        if(*$2 == boolean)
        {  
            $$ = new type(boolean);   
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $2;
    } 
    | kifejezes VAGY kifejezes 
    {
        if((*$1 == boolean) && (*$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes ES kifejezes 
    {
        if((*$1 == boolean) && (*$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes EGYENLO kifejezes 
    {
        if((*$1 == natural && *$3 == natural) || (*$1 == boolean && *$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes KISEBB_EGYENLO kifejezes 
    {
        if((*$1 == natural && *$3 == natural) || (*$1 == boolean && *$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes NAGYOBB_EGYENLO kifejezes 
    {
        if((*$1 == natural && *$3 == natural) || (*$1 == boolean && *$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes KISEBB kifejezes 
    {
        if((*$1 == natural && *$3 == natural) || (*$1 == boolean && *$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes NAGYOBB kifejezes 
    {
        if((*$1 == natural && *$3 == natural) || (*$1 == boolean && *$3 == boolean))
        {
            $$ = new type(boolean);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes PLUSZ kifejezes 
    {
        if(*$1 == natural && *$3 == natural)
        {
            $$ = new type(natural);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes MINUSZ kifejezes 
    {
        if(*$1 == natural && *$3 == natural)
        {
            $$ = new type(natural);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes SZORZAS kifejezes 
    {
        if(*$1 == natural && *$3 == natural)
        {
            $$ = new type(natural);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes OSZTAS kifejezes 
    {
        if(*$1 == natural && *$3 == natural)
        {
            $$ = new type(natural);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    } 
    | kifejezes MOD kifejezes 
    {
        if(*$1 == natural && *$3 == natural)
        {
            $$ = new type(natural);
        } else {
            std::stringstream ss;
            error( "Tipushibas ertekadas.\n" );
            error(ss.str().c_str());
        }
        delete $1;
        delete $3;
    }
    | IGAZ 
    {
       $$ = new type(boolean);
    } 
    | HAMIS 
    {
       $$ = new type(boolean);
    } 
    | NYITO_ZAROJEL kifejezes CSUKO_ZAROJEL 
    {
        $$ = $2;
    }; 

program_vege: 
    PROGRAM_VEGE {};