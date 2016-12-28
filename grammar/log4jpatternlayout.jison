/*
    required grok extra pattern files:
        * https://github.com/logstash-plugins/logstash-patterns-core/blob/master/patterns/java
*/

%lex

%s conversionpattern

%%

<conversionpattern>[c]([{][0-9]+[}])?           %{ this.popState();                             return 'CATEGORY'; %}
<conversionpattern>[C]([{][0-9]+[}])?           %{ this.popState();                             return 'CLASS'; %}
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
    ;
