/*
    required grok extra pattern files:
        * https://github.com/logstash-plugins/logstash-patterns-core/blob/master/patterns/java
*/

%lex

%s conversionpattern dateformat

%%

<conversionpattern>[c]([{][0-9]+[}])?           %{ this.popState();                             return 'CATEGORY'; %}
<conversionpattern>[C]([{][0-9]+[}])?           %{ this.popState();                             return 'CLASS'; %}
<conversionpattern>[d]'{ABSOLUTE}'              %{ this.popState();                             return 'DATE_EXPLICIT_ABSOLUTE'; %}
<conversionpattern>[d]'{DATE}'                  %{ this.popState();                             return 'DATE_EXPLICIT_DATE'; %}
<conversionpattern>[d]'{ISO8601}'               %{ this.popState();                             return 'DATE_EXPLICIT_ISO8601'; %}
<conversionpattern>[d][{]                       %{ this.popState(); this.begin('dateformat');   return 'DATE_EXPLICIT_START'; %}
<conversionpattern>[d]                          %{ this.popState();                             return 'DATE_IMPLICIT'; %}
<conversionpattern>[F]                          %{ this.popState();                             return 'FILE'; %}
<conversionpattern>[l]                          %{ this.popState();                             return 'LOCATION'; %}
<conversionpattern>[L]                          %{ this.popState();                             return 'LINE'; %}
<conversionpattern>[m]                          %{ this.popState();                             return 'MESSAGE'; %}
<conversionpattern>[M]                          %{ this.popState();                             return 'METHOD'; %}
<conversionpattern>[n]                          %{ this.popState();                             return 'NEWLINE'; %}
<conversionpattern>[p]                          %{ this.popState();                             return 'PRIORITY'; %}
<conversionpattern>[r]                          %{ this.popState();                             return 'RELATIVE_TIME'; %}
<conversionpattern>[t]                          %{ this.popState();                             return 'THREAD'; %}
<conversionpattern>[x]                          %{ this.popState();                             return 'NDC'; %}
<conversionpattern>[X]                          %{ this.popState();                             return 'MDC'; %}
<conversionpattern>[-]?[0-9]*([.][0-9]+)?                                                       return 'FORMAT_MODIFIERS';
<dateformat>[}]                                 %{ this.popState();                             return 'DATE_EXPLICIT_END'; %}
<dateformat>[G]+                                                                                return 'ERA';
<dateformat>[y]+                                                                                return 'YEAR';
<dateformat>[Y]+                                                                                return 'WEEK_YEAR';
<dateformat>[M]+                                                                                return 'MONTH';
<dateformat>[w]+                                                                                return 'WEEK_IN_YEAR';
<dateformat>[W]+                                                                                return 'WEEK_IN_MONTH';
<dateformat>[D]+                                                                                return 'DAY_IN_YEAR';
<dateformat>[d]+                                                                                return 'DAY_IN_MONTH';
<dateformat>[F]+                                                                                return 'DAY_OF_WEEK_IN_MONTH';
<dateformat>[E]+                                                                                return 'DAY_NAME_IN_WEEK';
<dateformat>[u]+                                                                                return 'DAY_NUMBER_IN_WEEK';
<dateformat>[a]+                                                                                return 'AM_PM';
<dateformat>[H]+                                                                                return 'HOUR_IN_DAY_0_23';
<dateformat>[k]+                                                                                return 'HOUR_IN_DAY_1_24';
<dateformat>[K]+                                                                                return 'HOUR_IN_AM_PM_0_11';
<dateformat>[h]+                                                                                return 'HOUR_IN_AM_PM_1_12';
<dateformat>[m]+                                                                                return 'MINUTE';
<dateformat>[s]+                                                                                return 'SECOND';
<dateformat>[S]+                                                                                return 'MILISECOND';
<dateformat>[z]+                                                                                return 'TIMEZONE_GENERAL';
<dateformat>[Z]+                                                                                return 'TIMEZONE_RFC822';
<dateformat>[X]+                                                                                return 'TIMEZONE_ISO_8601';
<dateformat>(.)                                                                                 return 'DATE_ANY_CHAR';
'%%'                                                                                            return 'PERCENT';
'%'                                             %{ this.begin('conversionpattern');		        return 'CONVERSIONPATTERN_START'; %}
(.)                                                                                             return 'ANY_CHAR';
<<EOF>>                         			                                                    return 'EOF';

/lex

%%

EXPRESSIONS
    : EXPRESSION
        { typeof console !== 'undefined' ? console.log($1) : print($1); return $1; }
    ;

EXPRESSION
    : PERCENT EXPRESSION
        { $$ = '%' + $2; }
    | CONVERSIONPATTERN_START CONVERSION_CHARACTER EXPRESSION
        { $$ = $2 + $3; }
    | CONVERSIONPATTERN_START FORMAT_MODIFIERS CONVERSION_CHARACTER EXPRESSION
        { $$ = $3 + $4; }
    | ANY_CHAR EXPRESSION
        { $$ = $1 + $2; }
    | EOF /* terminating */
    ;

CONVERSION_CHARACTER
    : CATEGORY
        { $$ = '%{JAVACLASS:category}'; }
    | CLASS
        { $$ = '%{JAVACLASS:class}'; }
    | DATE
        { $$ = $1; }
    | FILE
        { $$ = '%{JAVAFILE:file}'; }
    | LOCATION
        { $$ = '%{JAVASTACKTRACEPART:location}'; }
    | LINE
        { $$ = '%{NONNEGINT:line}'; }
    | MESSAGE
        { $$ = '%{GREEDYDATA:message}'; }
    | METHOD
        { $$ = '%{JAVAMETHOD:method}'; }
    | NEWLINE
        { $$ = '(?<newline>(\r|\n)+)'}
    | PRIORITY
        { $$ = '%{LOGLEVEL:loglevel}'; }
    | RELATIVE_TIME
        { $$ = '%{NONNEGINT:relativetime}'; }
    | THREAD
        { $$ = '%{NOTSPACE:thread}'; }
    ;

DATE
    : DATE_IMPLICIT
        { $$ = '%{TIMESTAMP_ISO8601:timestamp}'; }
    | DATE_EXPLICIT_ABSOLUTE
        { $$ = '(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'; }
    | DATE_EXPLICIT_DATE
        { $$ = '(?<timestamp>%{MONTHDAY} %{MONTHNUM2} %{YEAR} %{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'; }
    | DATE_EXPLICIT_ISO8601
        { $$ = '%{TIMESTAMP_ISO8601:timestamp}'; }
    | DATE_EXPLICIT_START DATE_EXPLICIT
        { $$ = '(?<timestamp>' + $2; }
    ;

DATE_EXPLICIT
    : DATE_EXPLICIT_PATTERN DATE_EXPLICIT
        { $$ = $1 + $2; }
    | DATE_EXPLICIT_END /* terminating */
        { $$ = ')'; }
    ;

DATE_EXPLICIT_PATTERN
    : ERA
        { $$ = '%{[A-Z_]+'; }
    | YEAR
        { $$ = '%{YEAR}'; }
    | WEEK_YEAR
        { $$ = '%{NONNEGINT}'; }
    | MONTH
        { $$ = '%{MONTHNUM2}'; }
    | WEEK_IN_YEAR
        { $$ = '%{NONNEGINT}'; }
    | WEEK_IN_MONTH
        { $$ = '%{NONNEGINT}'; }
    | DAY_IN_YEAR
        { $$ = '%{NONNEGINT}'; }
    | DAY_IN_MONTH
        { $$ = '%{MONTHDAY}'; }
    | DAY_OF_WEEK_IN_MONTH
        { $$ = '%{NONNEGINT}'; }
    | DAY_NAME_IN_WEEK
        { $$ = '%{[a-zA-Z]+}'; }
    | DAY_NUMBER_IN_WEEK
        { $$ = '%{[1-7]}'; }
    | AM_PM
        { $$ = '%{[AP][M]}'; }
    | HOUR_IN_DAY_0_23
        { $$ = '%{HOUR}'; }
    | HOUR_IN_DAY_1_24
        { $$ = '%{HOUR}'; }
    | HOUR_IN_AM_PM_0_11
        { $$ = '%{HOUR}'; }
    | HOUR_IN_AM_PM_1_12
        { $$ = '%{HOUR}'; }
    | MINUTE
        { $$ = '%{MINUTE}'; }
    | SECOND
        { $$ = '%{SECOND}'; }
    | MILISECOND
        { $$ = '%{NONNEGINT}'; }
    | TIMEZONE_GENERAL
        { $$ = '%{[a-zA-Z -:0-9]+}'; }
    | TIMEZONE_RFC822
        { $$ = '%{[-:0-9]+}'; }
    | TIMEZONE_ISO_8601
        { $$ = '%{[-:0-9]+}'; }
    | DATE_ANY_CHAR
        { $$ = $1; }
    ;