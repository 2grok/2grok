describe("with %c", function() {
    describe("implicit", function() {
        it("returns '%{JAVACLASS:category}'", function() {
            expect(exec('%c')).toBe('%{JAVACLASS:category}');
        });
    });
    describe("having precision specifier", function() {
        it("returns '%{JAVACLASS:category}'", function() {
            expect(exec('%c{2}')).toBe('%{JAVACLASS:category}');
        });
    });
    describe("having format modifiers", function() {
        it("returns '%{JAVACLASS:category}'", function() {
            expect(exec('%-20.30c')).toBe('%{JAVACLASS:category}');
        });
    });
    describe("having format modifiers and precision specifier", function() {
        it("returns '%{JAVACLASS:category}'", function() {
            expect(exec('%-20.30c{1}')).toBe('%{JAVACLASS:category}');
        });
    });
});

describe("with %C", function() {
    describe("implicit", function() {
        it("returns '%{JAVACLASS:class}'", function() {
            expect(exec('%C')).toBe('%{JAVACLASS:class}');
        });
    });
    describe("having precision specifier", function() {
        it("returns '%{JAVACLASS:class}'", function() {
            expect(exec('%C{2}')).toBe('%{JAVACLASS:class}');
        });
    });
    describe("having format modifiers", function() {
        it("returns '%{JAVACLASS:class}'", function() {
            expect(exec('%-20.30C')).toBe('%{JAVACLASS:class}');
        });
    });
    describe("having format modifiers and precision specifier", function() {
        it("returns '%{JAVACLASS:class}'", function() {
            expect(exec('%-20.30C{1}')).toBe('%{JAVACLASS:class}');
        });
    });
});

describe("with %d", function() {
    describe("implicit", function() {
        it("returns '%{TIMESTAMP_ISO8601:timestamp}'", function() {
            expect(exec('%d')).toBe('%{TIMESTAMP_ISO8601:timestamp}');
        });
    });
    describe("having date format specifier 'ABSOLUTE'", function() {
        it("returns '(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'", function() {
            expect(exec('%d{ABSOLUTE}')).toBe('(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})');
        });
    });
    describe("having date format specifier 'DATE'", function() {
        it("returns '(?<timestamp>%{MONTHDAY} %{MONTHNUM2} %{YEAR} %{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'", function() {
            expect(exec('%d{DATE}')).toBe('(?<timestamp>%{MONTHDAY} %{MONTHNUM2} %{YEAR} %{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})');
        });
    });
    describe("having date format specifier 'ISO8601'", function() {
        it("returns '%{TIMESTAMP_ISO8601:timestamp}'", function() {
            expect(exec('%d{ISO8601}')).toBe('%{TIMESTAMP_ISO8601:timestamp}');
        });
    });
    describe("having date format specifier: 'yyyy'", function() {
        it("returns '(?<timestamp>%{YEAR})'", function() {
            expect(exec('%d{yyyy}')).toBe('(?<timestamp>%{YEAR})');
        });
    });
    describe("having date format specifier: 'HH:mm:ss'", function() {
        it("returns '(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND})'", function() {
            expect(exec('%d{HH:mm:ss}')).toBe('(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND})');
        });
    });
    describe("having date format specifier: 'yyyyMMdd - HH:mm:ss'", function() {
        it("returns '(?<timestamp>%{YEAR}%{MONTHNUM2}%{MONTHDAY} - %{HOUR}:%{MINUTE}:%{SECOND})'", function() {
            expect(exec('%d{yyyyMMdd - HH:mm:ss}')).toBe('(?<timestamp>%{YEAR}%{MONTHNUM2}%{MONTHDAY} - %{HOUR}:%{MINUTE}:%{SECOND})');
        });
    });
    describe("having date format specifier: 'HH:mm:ss,SSS'", function() {
        it("returns '(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'", function() {
            expect(exec('%d{HH:mm:ss,SSS}')).toBe('(?<timestamp>%{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})');
        });
    });
    describe("having date format specifier: 'dd MMM yyyy HH:mm:ss,SSS'", function() {
        it("returns ''(?<timestamp>%{MONTHDAY} %{MONTHNUM2} %{YEAR} %{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})'", function() {
            expect(exec('%d{dd MMM yyyy HH:mm:ss,SSS}')).toBe('(?<timestamp>%{MONTHDAY} %{MONTHNUM2} %{YEAR} %{HOUR}:%{MINUTE}:%{SECOND},%{NONNEGINT})');
        });
    });
});

describe("with %F", function() {
    describe("implicit", function() {
        it("returns '%{JAVAFILE:file}'", function() {
            expect(exec('%F')).toBe('%{JAVAFILE:file}');
        });
    });
    describe("having format modifiers", function() {
        it("returns '%{JAVAFILE:file}'", function() {
            expect(exec('%-20.30F')).toBe('%{JAVAFILE:file}');
        });
    });
});

describe("with percent char", function() {
    describe("only", function() {
        it("returns '%'", function() {
            expect(exec('%%')).toBe('%');
        });
    });
    describe("and pattern", function() {
        it("returns percent char and grok pattern", function() {
            expect(exec('%% %C')).toBe('% %{JAVACLASS:class}');
        });
    });
});

describe("with multiple patterns", function() {
    describe("separated by non-whitespace", function() {
        it("returns grok pattern with separator", function() {
            expect(exec('%c-%C')).toBe('%{JAVACLASS:category}-%{JAVACLASS:class}');
        });
    });
    describe("separated by whitespace", function() {
        it("returns grok pattern with separator", function() {
            expect(exec('%c %C')).toBe('%{JAVACLASS:category} %{JAVACLASS:class}');
        });
    });
    describe("separated by multiple chars", function() {
        it("returns grok pattern with all separators", function() {
            expect(exec('%c : %C')).toBe('%{JAVACLASS:category} : %{JAVACLASS:class}');
        });
    });
});

describe("without patterns", function() {
    describe("non-whitespace only", function() {
        it("returns grok pattern with separator", function() {
            expect(exec('foo')).toBe('foo');
        });
    });
    describe("whitespace only", function() {
        it("returns grok pattern with separator", function() {
            expect(exec(' \t')).toBe(' \t');
        });
    });
    describe("multiple chars", function() {
        it("returns grok pattern with all separators", function() {
            expect(exec(' foo\tbar ')).toBe(' foo\tbar ');
        });
    });
});

function exec(input) {
    return require("../lib/log4jpatternlayout").parse(input);
}