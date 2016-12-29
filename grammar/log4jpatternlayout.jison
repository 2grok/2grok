/*
    required grok extra pattern files:
        * https://github.com/logstash-plugins/logstash-patterns-core/blob/master/patterns/java
*/

%lex

%s conversionpattern dateformat

%%

<conversionpattern>[c]([{][0-9]+[}])?           %{ this.popState();                             return 'CATEGORY'; %}
<conversionpattern>[C]([{][0-9]+[}])?           %{ this.popState();                             return 'CLASS'; %}
<conversionpattern>[d][{]                       %{ this.popState(); this.begin('dateformat');   return 'DATE_EXPLICIT_START'; %}
<conversionpattern>[d]                          %{ this.popState();                             return 'DATE_IMPLICIT'; %}
<conversionpattern>[F]                          %{ this.popState();                             return 'FILE'; %}
<conversionpattern>[l]                          %{ this.popState();                             return 'LOCATION'; %}
<conversionpattern>[L]                          %{ this.popState();                             return 'LINE'; %}
<conversionpattern>[m]                          %{ this.popState();                             return 'MESSAGE'; %}
<conversionpattern>[M]                          %{ this.popState();                             return 'METHOD'; %}
<conversionpattern>[n]                          %{ this.popState();                             return 'NEWLINE'; %}
<conversionpattern>[p]                          %{ this.popState();                             return 'PRIORITY'; %}
<conversionpattern>[r]                          %{ this.popState();                             return 'PERFORMANCE'; %}
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
<<EOF>>                         			                                                    return 'EOF';

/lex

%%

EXPRESSIONS
    : EXPRESSION EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1); return $1; }
    ;

EXPRESSION
    : CONVERSIONPATTERN_START CATEGORY
        { $$ = '%{JAVACLASS:category}'; }
    | CONVERSIONPATTERN_START FORMAT_MODIFIERS CATEGORY
        { $$ = '%{JAVACLASS:category}'; }
    | CONVERSIONPATTERN_START CLASS
        { $$ = '%{JAVACLASS:class}'; }
    | CONVERSIONPATTERN_START FORMAT_MODIFIERS CLASS
        { $$ = '%{JAVACLASS:class}'; }
    | CONVERSIONPATTERN_START DATE_IMPLICIT  
        { $$ = '%{TIMESTAMP_ISO8601:timestamp}'; }
    | CONVERSIONPATTERN_START FORMAT_MODIFIERS DATE_IMPLICIT
        { $$ = '%{TIMESTAMP_ISO8601:timestamp}'; }
    | CONVERSIONPATTERN_START DATE_EXPLICIT_START DATE_EXPLICIT
        { $$ = '(?<timestamp>'+$3+')'; }
    | CONVERSIONPATTERN_START FORMAT_MODIFIERS DATE_EXPLICIT_START DATE_EXPLICIT
        { $$ = '(?<timestamp>'+$4+')'; }
    ;

DATE_EXPLICIT
    : ERA DATE_EXPLICIT
        { $$ = '%{[A-Z_]+'; }
    | YEAR DATE_EXPLICIT
        { $$ = '%{YEAR}'; }
    | WEEK_YEAR DATE_EXPLICIT
        { $$ = '%{[0-9]+}'; }
    | MONTH DATE_EXPLICIT
        { $$ = '%{MONTHNUM2}'; }
    | WEEK_IN_YEAR DATE_EXPLICIT
        { $$ = '%{[0-9]{1,2}}'; }
    | WEEK_IN_MONTH DATE_EXPLICIT
        { $$ = '%{[0-9]}'; }
    | DAY_IN_YEAR DATE_EXPLICIT
        { $$ = '%{[0-9]+}'; }
    | DAY_IN_MONTH DATE_EXPLICIT
        { $$ = '%{[0-9]{1,2}}'; }
    | DAY_OF_WEEK_IN_MONTH DATE_EXPLICIT
        { $$ = '%{[0-9]+}'; }
    | DAY_NAME_IN_WEEK DATE_EXPLICIT
        { $$ = '%{[a-zA-Z]+}'; }
    | DAY_NUMBER_IN_WEEK DATE_EXPLICIT
        { $$ = '%{[1-7]}'; }
    | AM_PM DATE_EXPLICIT
        { $$ = '%{[AP][M]}'; }
    | HOUR_IN_DAY_0_23 DATE_EXPLICIT
        { $$ = '%{HOUR}'; }
    | HOUR_IN_DAY_1_24 DATE_EXPLICIT
        { $$ = '%{HOUR}'; }
    | HOUR_IN_AM_PM_0_11 DATE_EXPLICIT
        { $$ = '%{HOUR}'; }
    | HOUR_IN_AM_PM_1_12 DATE_EXPLICIT
        { $$ = '%{HOUR}'; }
    | MINUTE DATE_EXPLICIT
        { $$ = '%{MINUTE}'; }
    | SECOND DATE_EXPLICIT
        { $$ = '%{SECOND}'; }
    | MILISECOND DATE_EXPLICIT
        { $$ = '%{[0-9]{1,2}}'; }
    | TIMEZONE_GENERAL DATE_EXPLICIT
        { $$ = '%{[a-zA-Z -:0-9]+}'; }
    | TIMEZONE_RFC822 DATE_EXPLICIT
        { $$ = '%{[-:0-9]+}'; }
    | TIMEZONE_ISO_8601 DATE_EXPLICIT
        { $$ = '%{[-:0-9]+}'; }
    | DATE_EXPLICIT_END
    | DATE_ANY_CHAR DATE_EXPLICIT
        { $$ = $1; }
    ;
