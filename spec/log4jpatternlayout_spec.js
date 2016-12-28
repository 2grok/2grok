describe("with %c", function() {
    describe("implicit", function() {
        it("returns classname", function() {
            expect(exec('%c')).toBe('%{JAVACLASS:category}');
        });
    });

    describe("having precision specifier", function() {
        it("returns classname", function() {
            expect(exec('%c{2}')).toBe('%{JAVACLASS:category}');
        });
    });

    describe("having format modifiers", function() {
        it("returns classname", function() {
            expect(exec('%-20.30c')).toBe('%{JAVACLASS:category}');
        });
    });
    describe("having format modifiers and precision specifier", function() {
        it("returns classname", function() {
            expect(exec('%-20.30c{1}')).toBe('%{JAVACLASS:category}');
        });
    });
});

describe("with %C", function() {
    describe("implicit", function() {
        it("returns classname", function() {
            expect(exec('%C')).toBe('%{JAVACLASS:class}');
        });
    });

    describe("having precision specifier", function() {
        it("returns classname", function() {
            expect(exec('%C{2}')).toBe('%{JAVACLASS:class}');
        });
    });

    describe("having format modifiers", function() {
        it("returns classname", function() {
            expect(exec('%-20.30C')).toBe('%{JAVACLASS:class}');
        });
    });
    describe("having format modifiers and precision specifier", function() {
        it("returns classname", function() {
            expect(exec('%-20.30C{1}')).toBe('%{JAVACLASS:class}');
        });
    });
});

function exec(input) {
    return require("../lib/log4jpatternlayout").parse(input);
}