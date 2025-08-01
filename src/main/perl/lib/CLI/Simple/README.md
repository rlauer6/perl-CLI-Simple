# NAME

CLI::Simple - a framework for creating option driven Perl scripts

# SYNOPSIS

    package MyScript;

    use strict;
    use warnings;

    use parent qw(CLI::Simple);
    
    caller or __PACKAGE__->main();
    
    sub execute {
      my ($self) = @_;

      # retrieve a CLI option   
      my $file = $self->get_file;
      ...
    }
    
    sub list { 
      my ($self) = @_

      # retrieve a command argument
      my ($file) = $self->get_args();
      ...
    }

    sub main {
     CLI::Simple->new(
      option_specs    => [ qw( help format=s ) ],
      default_options => { format => 'json' }, # set some defaults
      extra_options   => [ qw( content ) ], # non-option, setter/getter
      commands        => { execute => \&execute, list => \&list,  }
    )->run;

    1;

# DESCRIPTION

Tired of writing the same 'ol boilerplate code for command line
scripts? Want a standard, simple way to create a Perl script?
`CLI::Simple` makes it easy to create scripts that take _options_,
_commands_ and _arguments_.

This documentation refers to version 1.0.0.

## Features

- accept command line arguments ala [GetOptions::Long](https://metacpan.org/pod/GetOptions%3A%3ALong)
- supports commands and command arguments
- automatically add a logger
- easily add usage notes
- automatically create setter/getters for your script

Command line scripts often take _options_, sometimes a _command_ and
perhaps _arguments_ to those commands.  For example, consider the
script `myscript` that takes options and implements a few commands
(_send-message_, _receive-message_) that also take arguments.

    myscript [options] command args

or

    myscript command [options] args

Examples:

    myscript --foo bar --log-level debug send-message "Hello World" now

    myscript --bar --log-level info receive-message

Using `CLI::Simple` to implement this script looks like this...

    package MyScript;

    use parent qw(CLI::Simple);

    caller or __PACKAGE__->main();

    sub send_message {...}

    sub default {...}

    sub receive_message {...}
    
    sub main {
      return __PACKAGE__->new(
        option_specs => [
          qw(
            foo=s
            bar
            log-level
          )
        ],
        commands => {
          send    => \&send_message,
          receive => \&receive_message,
        },
      )->run;
    }

    1;

# METHODS AND SUBROUTINES

## new

    new( args )

Instantiates a new `CLI::Simple` instance, parses options, optionally
initializes logging, and makes options available via dynamically
generated accessors.

_Note: The `new()` constructor uses [Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong)'s `GetOptions`,
which directly modifies `@ARGV` by removing any recognized
options. The remaining elements of `@ARGV` are treated as the command
name and its arguments._

`args` is a hash or hash reference containing the following keys:

- commands (required)

    A hash mapping command names to either a subroutine reference or an
    array reference.

    If an array reference is used, the first element must be a subroutine
    reference and the second should be a valid log level. (See ["Per
    Command Log Levels"](#per-command-log-levels).)

    Example:

        {
          send           => \&send_message,
          receive        => \&receive_message,
          list_messages  => [ \&list_messages, 'error' ],
        }

    If your script does not use command names, set a `default` key to the
    subroutine or method to run.

        { default => \&main }

- default\_options (optional)

    A hash reference of default values for your options.

- extra\_options

    An arrayref of names for additional accessors you'd like to create,
    even if they're not part of the option spec.

    Example:

        extra_options => [ qw(foo bar baz) ]

- option\_specs (required)

    An array reference of option specifications, as accepted by [Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong).

## command

Returns the command presented on the command line.

## commands

Returns the hash you passed in the constructor as `commands`.

## run

Execute the script with the given options, commands and arguments. The
`run` method interprets the command line and passes control to your
command subroutines. Your subroutines should return a 0 for success
and a non-zero value for failure.  This error code is passed to the
shell as the script return code.

## get\_args

Return the arguments that follow the command.

    get_args(var-name, ... )
    get_args()

With arguments, in scalar context returns a reference to the hash of
arguments by assigning each positional argument to a key value.  In
array context returns a list of key/value pairs.

With no arguments returns the array of command arguments.

Example:

    sub send_message {
      my ($self) = @_;

      my %args = $self->get_args(qw(message email));
      
      _send_message($arg{message}, $args{email});

     ...

## init

If you define your own `init()` method, it will be called by the
constructor. Use this method to perform any actions you require before
you execute the `run()` method.

# USING PACKAGE VARIABLES

You can pass the necessary parameter required to implement your
command line scripts in the constructor or some people prefer to see
them clearly defined in the code. Accordingly, you can use package
variables with the same name as the constructor arguments (in upper
case).

    our $OPTION_SPECS = [
      qw(
        help|h
        log-level=s|L
        debug|d
      )
    ];
    
    our $COMMANDS = {
      foo => \&foo,
      bar => \&bar,
    };

# COMMAND LINE OPTIONS

Command-line options are defined using [Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong)-style
specifications. You pass these into the constructor via the
`option_specs` parameter:

    my $cli = CLI::Simple->new(
      option_specs => [ qw( help|h foo-bar=s log-level=s ) ]
    );

In your command subroutines, you can access these values using
automatically generated getter methods:

    $cli->get_foo();
    $cli->get_log_level();

Option names that contain dashes (`-`) are automatically converted to
snake\_case for the accessor methods. For example:

    option_specs => [ 'foo-bar=s' ]

...results in:

    $cli->get_foo_bar();

# COMMAND ARGUMENTS

If your commands accept positional arguments, you can retrieve them
using the `get_args` method.

You may optionally provide a list of argument names, in which case the
arguments will be returned as a hash (or hashref in scalar context)
with named values.

Example:

    sub send_message {
      my ($self) = @_;

      my %args = $self->get_args(qw(phone_number message));

      send_sms_message($args{phone_number}, $args{message});
    }

If you call `get_args()` without any argument names, it simply
returns all remaining arguments as a list:

    my ($phone_number, $message) = $self->get_args;

_Note: When called with names, `get_args` returns a hash in list
context and a hash reference in scalar context._

# SETTING DEFAULT VALUES FOR OPTIONS

To assign default values to your options, pass a hash reference as the
`default_options` argument to the constructor. These values will be
used unless explicitly overridden by the user on the command line.

Example:

    my $cli = CLI::Simple->new(
      default_options => { foo => 'bar' },
      option_specs    => [ qw(foo=s bar=s) ],
      commands        => {
        foo => \&foo,
        bar => \&bar,
      },
    );

Defaulted options are accessible through their corresponding getter
methods, just like options set via the command line.

# ADDING USAGE TO YOUR SCRIPTS

To provide built-in usage/help output, include a `=head1 USAGE`
section in your script's POD:

    =head1 USAGE

      usage: myscript [options] command args

      Options
      -------
      --help, -h      Display help
      ...

If the user supplies the command `help`, or the `--help` option,
`CLI::Simple` will display this section automatically:

    perl myscript.pm --help
    perl myscript.pm help

## Custom help() Method

If you need full control over the help output, you can define a custom
`help` method and assign it as a command:

    commands => {
      help => \&help,
      ...
    }

This is useful if your module follows the modulino pattern and you
want to present usage information that differs from the embedded
POD. Without a custom handler, `CLI::Simple` defaults to displaying the
`USAGE` POD section.

# ADDING ADDITIONAL SETTERS

All command-line options are automatically available through getter
methods named `get_*`.

If you need to create additional accessors (getters and setters) for
values that are not derived from the command line, use the
`extra_options` parameter.

This is useful for passing runtime configuration or computed values
throughout your application.

Example:

    my $cli = CLI::Simple->new(
      default_options => { foo => 'bar' },
      option_specs    => [ qw(foo=s bar=s) ],
      extra_options   => [ qw(biz buz baz) ],
      commands        => {
        foo => \&foo,
        bar => \&bar,
      },
    );

This will generate `get_biz`, `set_biz`, `get_buz`, etc., for
internal use.

# LOGGING

`CLI::Simple` integrates with [Log::Log4perl](https://metacpan.org/pod/Log%3A%3ALog4perl) to provide structured
logging for your scripts.

To enable logging, call the class method `use_log4perl()` in your
module or script:

    __PACKAGE__->use_log4perl(
      level  => 'info',
      config => $log4perl_config_string
    );

If you do not explicitly include a `log-level` option in your
`option_specs`, CLI::Simple will automatically add one for you.

Once enabled, you can access the logger instance via:

    my $logger = $self->get_logger;

This logger supports the standard Log4perl methods like `info`,
`debug`, `warn`, etc.

## Per Command Log Levels

Some commands may require more verbose logging than others. For
example, certain commands might perform complex actions that benefit
from detailed logs, while others are designed solely to produce clean,
structured output.

To assign a custom log level to a command, use an array reference as
the value for that command in the commands hash passed to the
constructor.

The array reference must contain exactly two elements:

- A code reference to the command subroutine
- A log level string: one of 'trace', 'debug', 'info', 'warn',
'error', or 'fatal'

Example:

    CLI::Simple->new(
      option_specs    => [qw( help format=s )],
      default_options => { format => 'json' },  # set some defaults
      extra_options   => [qw( content )],       # non-option, setter/getter
      commands        => {
        execute => \&execute,
        list    => [ \&list, 'error' ],
      }
    )->run;

# FAQ

- How do I execute startup code before my command runs?

    Implement an `init()` method in your class. The `new()` constructor
    will invoke this method before returning and before `run()` is
    executed.

    Your `init()` method will have access to all options and
    arguments. Logging will also be initialized, so you can use
    `get_logger()` to emit messages.

- Do I need to implement commands?

    No. If your script doesn't support multiple commands, you can specify
    a `default` key instead:

        commands => { default => \&main }

- Must I subclass `CLI::Simple`?

    No. You can use it procedurally or functionally.

- How do I turn my class into a script?

    Use the modulino pattern: create a class that checks whether it is
    being invoked directly:

        package MyScript;

        caller or __PACKAGE__->main();

        sub main {
          ...
        }

    This lets the file be used as both a module and an executable script.

- How do the helper scripts work?

    This distribution includes two scripts to help with modulino-style
    scripts:

    - modulino

        A generic launcher that runs a Perl module as a script.

    - create-modulino.pl

        Creates a symbolic link or wrapper script to make your modulino-based
        module runnable from the command line.

        Example:

            sudo create-modulino.pl Foo::Bar foo-bar

        This creates an executable called `foo-bar` that loads and invokes
        `Foo::Bar` as a modulino script.

# LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.  See
[https://dev.perl.org/licenses/](https://dev.perl.org/licenses/) for more information.

# SEE ALSO

[Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong), [CLI::Simple::Utils](https://metacpan.org/pod/CLI%3A%3ASimple%3A%3AUtils), [Pod::Usage](https://metacpan.org/pod/Pod%3A%3AUsage)

# AUTHOR

Rob Lauer - <bigfoot@cpan.org>
