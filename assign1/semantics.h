#include <iostream>
#include <string>
#include <map>
#include <sstream>

enum type {natural, boolean};

struct var_data 
{
    int decl_row;
    type var_type;
    var_data(int d, type t) : decl_row(d), var_type(t) {}
    var_data(){}
};





