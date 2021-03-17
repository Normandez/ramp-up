#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VAR_NAME "MY_VAR"
#define OPT_OUTPUT "-o"

enum OutputType
{
    OT_STDOUT = 0,
    OT_FILE,
    OT_NOT_SET
};

FILE* file = NULL;

static enum OutputType parse_args(int argc, char** argv)
{
    if ( argc > 1 )
    {   
        bool is_opt = false;
        for ( int i = 1; i < argc; ++i )
        {
            if ( strcmp(argv[i], OPT_OUTPUT) == 0 )
                is_opt = true;
            else if ( is_opt )
            {
                file = fopen(argv[i], "w");
                return OT_FILE;
            }
            else
            {
                fprintf(stderr, "option '%s' is unknown\r\n", argv[i]);
                return OT_NOT_SET;
            }
        }
        fprintf(stderr, "%s\r\n", "no file specified");
        return OT_NOT_SET;
    }

    return OT_STDOUT;
}

static bool get_my_var(const char** buf)
{
    const char* my_var = getenv(VAR_NAME);
    if ( my_var != NULL )
    {
        *buf = my_var;
        return true;
    }
    else
        return false;
}

static bool print_file(const char* buf)
{
    if ( file == NULL )
    {
        fprintf(stderr, "%s\r\n", "output: cannot create file");
        return false;
    }

    int bytes = fprintf(file, "%s\r\n", buf);
    if ( bytes < 0 )
    {
        fprintf(stderr, "%s\r\n", "output: write error");
        fclose(file);
        return false;
    }

    fclose(file);
    return true;
}

static bool print_my_var(const char* buf, enum OutputType ot)
{
    switch ( ot )
    {
    case OT_STDOUT:
        fprintf(stdout, "%s\r\n", buf);
        return true;
    break;
    case OT_FILE:
        return print_file(buf);
    break;
    default:
        return false;
    }
}

int main(int argc, char** argv)
{
    enum OutputType ot = parse_args(argc, argv);
    if ( ot == OT_NOT_SET )
        return 1;

    const char* buf = NULL;
    if ( get_my_var(&buf) )
    {
        if ( !print_my_var(buf, ot) )
            return 1;
    }
    else
    {
        fprintf(stderr, "%s", "$MY_VAR is not set\r\n");
        if ( file != NULL )
            fclose(file);

        return 123;
    }

    return 0;
}

