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
});

function exec(input) {
    return require("../lib/log4jpatternlayout").parse(input);
}