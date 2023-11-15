# NAME

CLI::Simple::Constants

# SYNOPSIS

    use CLI::Simple::Constants qw(:booleans)

# DESCRIPTION

This class provides a set of exportable constants commonly used in
writing command line scripts.

# EXPORTABLE TAGS

- booleans

        $TRUE    => 1
        $FALSE   => 0
        $SUCCESS => 0 # shell success
        $FAILURE => 1 # shell failure

- all

    Import all constants.

- chars

        $AMPERSAND          => q{&};
        $COLON              => q{:};
        $COMMA              => q{,};
        $DOUBLE_COLON       => q{::};
        $DASH               => q{-};
        $DOT                => q{.};
        $EMPTY              => q{};
        $EQUALS_SIGN        => q{=};
        $OCTOTHORP          => q{#};
        $PERIOD             => q{.};
        $QUESTION_MARK      => q{?};
        $SLASH              => q{/};
        $SPACE              => q{ };
        $TEMPLATE_DELIMITER => q{@};
        $UNDERSCORE         => q{_};

- log-levels

    Names for Log::Log4perl log level

        %LOG_LEVELS => (
           debug => $DEBUG,
           trace => $TRACE,
           warn  => $WARN,
           error => $ERROR,
           fatal => $FATAL,
           info  => $INFO,
        );

# AUTHOR

Rob Lauer - rlauer6@comcast.net
