# NAME

CLI::Simple::Constants - Exportable constants for CLI::Simple-based applications

# SYNOPSIS

    use CLI::Simple::Constants qw(:booleans :chars :log-levels);

    return $SUCCESS if $flag;
    print $PADDING, "=>", $SPACE, $EQUALS_SIGN, "\n" if $DEBUG;

# DESCRIPTION

This module provides a collection of constants commonly needed when building
command-line tools, especially those using `CLI::Simple`.

It includes:

- Boolean values for use in control flow or shell-style success/failure
- Character constants for formatting and CLI-friendly output
- Predefined log level names for use with Log::Log4perl
- Export tags for grouping constants by intent

# EXPORT TAGS

- :booleans

    Semantic truthy and shell-style constants:

        $TRUE    => 1
        $FALSE   => 0
        $SUCCESS => 0   # shell success
        $FAILURE => 1   # shell failure

- :chars

    Export commonly used single-character string constants:

        $AMPERSAND          => '&'
        $COLON              => ':'
        $COMMA              => ','
        $DOUBLE_COLON       => '::'
        $DASH               => '-'
        $DOT                => '.'
        $EMPTY              => ''
        $EQUALS_SIGN        => '='
        $OCTOTHORP          => '#'
        $PERIOD             => '.'
        $QUESTION_MARK      => '?'
        $SLASH              => '/'
        $SPACE              => ' '
        $TEMPLATE_DELIMITER => '@'
        $UNDERSCORE         => '_'

    Note: `$DOT` and `$PERIOD` are synonyms provided for semantic clarity.

- :strings

    String constants used for formatting:

        $PADDING => '    '   # 4 spaces, commonly used for indentation

- :log-levels

    Provides a hash mapping symbolic log level names to [Log::Log4perl](https://metacpan.org/pod/Log%3A%3ALog4perl) constants:

        %LOG_LEVELS => (
          debug => $DEBUG,
          trace => $TRACE,
          info  => $INFO,
          warn  => $WARN,
          error => $ERROR,
          fatal => $FATAL,
        )

- :all

    Exports all constants from the above tags.

# SEE ALSO

[Log::Log4perl](https://metacpan.org/pod/Log%3A%3ALog4perl), [CLI::Simple](https://metacpan.org/pod/CLI%3A%3ASimple)

# AUTHOR

Rob Lauer

# LICENSE

Same terms as Perl itself.
