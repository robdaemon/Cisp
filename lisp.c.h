/* Generated by           cobc 2.0.0 */
/* Generated from         lisp.cbl */
/* Generated at           Apr 27 2017 17:51:26 */
/* GnuCOBOL build date    Nov 13 2016 01:30:50 */
/* GnuCOBOL package date  Nov 06 2016 22:36:19 UTC */
/* Compile command        cobc.exe -o bin\lisp.dll -std=default -Wall -g -LC:\Users\laury\Documents\Computer School\Recurse Center\Cisp\subroutines\bin -L\subroutines\bin -L..\subroutines\bin lisp.cbl */


/* Module path */
static const char		*cob_module_path = NULL;

/* Number of call parameters */
static int		cob_call_params = 0;

/* Attributes */

static const cob_field_attr a_1 =	{0x21,   0,   0, 0x0000, NULL};
static const cob_field_attr a_2 =	{0x10,   4,   0, 0x0000, NULL};
static const cob_field_attr a_3 =	{0x01,   0,   0, 0x0000, NULL};
static const cob_field_attr a_4 =	{0x10,  20,   0, 0x0000, NULL};

static const cob_field_attr cob_all_attr = {0x22, 0, 0, 0, NULL};


/* Constants */
static const cob_field c_1	= {1, (cob_u8_ptr)"(", &a_1};
static const cob_field c_2	= {1, (cob_u8_ptr)")", &a_1};
static const cob_field c_3	= {4, (cob_u8_ptr)"INIT", &a_1};
static const cob_field c_4	= {8, (cob_u8_ptr)"IS-EMPTY", &a_1};
static const cob_field c_5	= {11, (cob_u8_ptr)"STACK-EMPTY", &a_1};
static const cob_field c_6	= {16, (cob_u8_ptr)"WS-CURR-COMMAND:", &a_1};
static const cob_field c_7	= {18, (cob_u8_ptr)" WS-CURRENT-VALUE:", &a_1};
static const cob_field c_8	= {17, (cob_u8_ptr)" WS-COMMAND-NAME:", &a_1};
static const cob_field c_9	= {19, (cob_u8_ptr)" WS-COMMAND-RESULT:", &a_1};
static const cob_field c_10	= {1, (cob_u8_ptr)" ", &a_1};
static const cob_field c_11	= {14, (cob_u8_ptr)"POP-CALL-STACK", &a_1};
static const cob_field c_12	= {5, (cob_u8_ptr)"CLOSE", &a_1};
static const cob_field c_13	= {4, (cob_u8_ptr)"LISP", &a_1};
static const cob_field c_14	= {8, (cob_u8_ptr)"Command:", &a_1};
static const cob_field c_15	= {5, (cob_u8_ptr)"print", &a_1};
static const cob_field c_16	= {1, (cob_u8_ptr)"+", &a_1};
static const cob_field c_17	= {11, (cob_u8_ptr)"THROW-ERROR", &a_1};
static const cob_field c_18	= {18, (cob_u8_ptr)"LISP FORMAT ERROR:", &a_1};
static const cob_field c_19	= {26, (cob_u8_ptr)" COULD NOT BE INTERPRETED.", &a_1};
static const cob_field c_20	= {5, (cob_u8_ptr)"LISP:", &a_1};
static const cob_field c_21	= {7, (cob_u8_ptr)"Result:", &a_1};

static cob_field cob_all_space	= {1, (cob_u8_ptr)" ", &cob_all_attr};


/* Strings */
static const char st_1[]	= "lisp.cbl";
static const char st_2[]	= "MAIN-PROCEDURE";
static const char st_3[]	= "PERFORM";
static const char st_4[]	= "EVALUATE";
static const char st_5[]	= "SET";
static const char st_6[]	= "MOVE";
static const char st_7[]	= "IF";
static const char st_8[]	= "GOBACK";
static const char st_9[]	= "INIT-CALL-STACK-PROCEDURE";
static const char st_10[]	= "CALL";
static const char st_11[]	= "INIT-RECURSION-OBJECT-PROCEDURE";
static const char st_12[]	= "RETURN-PROCEDURE";
static const char st_13[]	= "PRINT-CALL-STACK";
static const char st_14[]	= "DEBUG-LISP";
static const char st_15[]	= "DISPLAY";
static const char st_16[]	= "POP-CALL-STACK";
static const char st_17[]	= "CLOSE-CALL-STACK-PROCEDURE";
static const char st_18[]	= "LOG-CURRENT-COMMAND-PROCEDURE";
static const char st_19[]	= "STRING";
static const char st_20[]	= "EVALUATE-CURRENT-COMMAND";
static const char st_21[]	= "EVALUATE-CURRENT-VALUES";
static const char st_22[]	= "APPLY-VALUE-TO-EXPRESSION";
static const char st_23[]	= "LISP-PRINT-PROCEDURE";
static const char st_24[]	= "LISP-ADD-PROCEDURE";
static const char st_25[]	= "ADD";
static const char st_26[]	= "LOG-COMMAND-EVALUTATION";

static int COB_NOINLINE
cob_get_numdisp (const void *data, const size_t size)
{
	const unsigned char	*p;
	size_t			n;
	int    			 retval;
	p = (const unsigned char *)data;
	retval = 0;
	for (n = 0; n < size; ++n, ++p) {
		retval *= 10;
		retval += (*p & 0x0F);
	}
	return retval;
}

