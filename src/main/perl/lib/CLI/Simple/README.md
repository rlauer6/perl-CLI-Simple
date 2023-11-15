# NAME

CLI::Simple

# SYNOPIS

    package MyScript;

    use parent qw(CLI::Simple);
    
    caller or __PACKAGE__->main();
    
    sub main {
     CLI::Simple->new(
      option_specs    => [qw( help foo=s )],
      default_options => { foo => 'bar' },
      extra_options   => [qw( logger bar )],
      commands        => { execute => \&execute }
    )->run;
     

# DESCRIPTION

Tired of writing the same 'ol boilerplate code for command line
scripts? Want a standard, simple way to create a Perl script?
`CLI::Simple` makes it easy to create scripts that take options,
commands and arguments.

Command line scripts often take options, sometimes a command and
perhaps arguments to those commands.  For example, consider the script
`myscript` that takes options and implements a few commands (biz, buz) with
arguments.

    myscript [options] command args

Examples:

    myscript --foo bar --log-level debug biz 1

    myscript --bar --log-level info buz message "Hello World"

Using <CLI::Simple> to implement this script looks like this...

    package MyScript;

    use parent qw(CLI::Simple);

    caller or __PACKAGE__main();

    sub foo {..}

    sub default {...}

    sub bar {...}
    
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
          bar => \&bar,
          foo => \&foo,
        },
      )->run;
    }

# METHODS AND SUBROUTINES

## new

Instantiates a new CLI::Simple object.

## run

Execute the script with the given options, commands and arguments. The
`run` method interprets the command pass execution to your command
subroutines. Your subroutines should return a 0 for success and a
non-zero value for failure.  This error code is passed to the shell as
the script return code.

## get\_args

    get_args(var-name, ... );

In scalar context returns a reference to the hash of arguments. In
array context will return a hash of key/value pairs.

## init

If you define your own `init()` function, it will be called by the
constructor.

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

Command line options are set ala `Getopt::Long`. You pass those
options into the constructor like this:

    my $cli = CLI::Simple->new(option_specs => [ qw( help|h foo bar=s log-level=s ]);

In your command subroutines you can access these options using gettters.

    $cli->get_foo;
    $cli->get_bar;
    $cli->get_log_level;

Note that options that use dashes in the name will be automatically
converted to snake case names. Some folks find it easier to use '-'
then '\_' for option names.

# COMMAND ARGUMENTS

If you want to allow your commands to accept positional arguments you
can retrieve them as named hash elements.

    my %args = $self->get_args(qw(arg1 arg2));

    my $args = $self->get_args(qw(arg1 arg2));

# SETTING DEFAULT VALUES FOR OPTIONS

# ADDING ADDITIONAL SETTERS & GETTERS

# ADDING USAGE TO YOUR SCRIPTS

To add a usage or help capability to your scripts, just add some pod
at the bottom of your script with a USAGE section (head1).

    =head1 USAGE

    usage: myscript [options] command args

    Options
    -------
    --help, -h      help
    ....

If the commad used is 'help' or if you have added an optional
`--help` option, users can display the usage section.

    myscript.pm -h
    myscript help

# LOGGING

`CLI::Simple` will enable you to create a Log::Log4perl logger. You can
pass in a configuration or let the classs use Log::Log4perl's easy
mode.

    __PACKAGE__->use_log4perl(level => 'info', config => $config);

The class will add a `--log-level` option for you if you have not added one yourself.

# FAQ

# LICENSE AND COPYRIGHT

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl itself.

# SEE ALSO

[Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong), [CLI::Simple::Utils](https://metacpan.org/pod/CLI%3A%3ASimple%3A%3AUtils)

# AUTHOR

Rob Lauer - <rlauer6@comcast.net>