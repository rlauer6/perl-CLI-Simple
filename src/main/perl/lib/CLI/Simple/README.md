# NAME

CLI::Simple

# SYNOPIS

    package MyScript;

    use strict;
    use warnings;

    use parent qw(CLI::Simple);
    
    caller or __PACKAGE__->main();
    
    sub execute { ... }
    
    sub list { ... }

    sub main {
     CLI::Simple->new(
      option_specs    => [ qw( help foo=s ) ],
      default_options => { foo => 'bar' },
      extra_options   => [ qw( logger bar ) ],
      commands        => { execute => \&execute, list => \&list,  }
    )->run;

    1;
     

# DESCRIPTION

Tired of writing the same 'ol boilerplate code for command line
scripts? Want a standard, simple way to create a Perl script?
`CLI::Simple` makes it easy to create scripts that take _options_,
_commands_ and _arguments_.

## Features

- accept command line arguments ala [GetOptions::Long](https://metacpan.org/pod/GetOptions%3A%3ALong)
- supports commands and command arguments
- automatically add a logger
- easily add usage notes
- create setter/getters for your script

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

    caller or __PACKAGE__main();

    sub send_message {..}

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

# METHODS AND SUBROUTINES

## new

    new( args )

`args` is a hash or hash reference containing the following keys:

- commands (required)

    A hash reference containing the command names and a code reference to
    the subroutines that implement the command.

    Example:

        { 
          send    => \&send_message,
          receive => \&receive_message,
        }

    If your script does accept command, set a `default` key to the
    subroutine or method that will implement your script.

        { default => \&main }

- default\_options (optional)

    A hash reference that contains the default values for your options.  

- extra\_options

    If you want to create additional setters or getters, set
    `extra_options` to an array variable names.

    Example:

        extra_options => [ qw(foo bar baz) ]

- option\_specs (required)

    An array reference of option specfications.  These are the same as
    those passed to `Getopt::Long`.

Instantiates a new `CLI::Simple` object.

## run

Execute the script with the given options, commands and arguments. The
`run` method interprets the command line and pass control to your command
subroutines. Your subroutines should return a 0 for success and a
non-zero value for failure.  This error code is passed to the shell as
the script return code.

## get\_args

    get_args(var-name, ... );

In scalar context returns a reference to the hash of arguments. In
array context will return a hash of key/value pairs.

Example:

    sub send_message {
      my ($self) = @_;

      my (%args) = $self->get_args(qw(message email));
      
      _send_message($arg{message}, $args{email});

     ...

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

In your command subroutines you can then access these options using gettters.

    $cli->get_foo;
    $cli->get_bar;
    $cli->get_log_level;

Note that options that use dashes in the name will be automatically
converted to snake case names. Some folks find it easier to use '-'
rather than '\_' for option names.

# COMMAND ARGUMENTS

If you want to allow your commands to accept positional arguments you
can retrieve them as named hash elements.  This can make your code much
easier to read and understand.

    sub send_mesage {
      my ($self) = @_;

      my %args = $self->get_args(qw(phone_number message));

      send_sms_mesage($args{phone_number}, $args{message});
      ...
    }

If pass an empty list then all of the command arguments will be returned.

    my ($phone_number, $message) = $self->get_args;

# SETTING DEFAULT VALUES FOR OPTIONS

To set default values for your option, pass a hash reference as the
`default_options` argument to the constructur.

    my $cli = CLI::Simple->new(
      default_option => { foo => 'bar' },
      option_specs   => [ qw(foo=s bar=s) ],
      commands       => { foo => \&foo, bar => \&bar },
    );

# ADDING ADDITIONAL SETTERS & GETTERS

As note all command line options are available using getters of the
same name preceded by `get_`.

If you want to create additional setter and getters, pass an array of
variable names as the `extra_options` argument to the constructor.

    my $cli = CLI::Simple->new(
      default_option => { foo => 'bar' },
      option_specs   => [ qw(foo=s bar=s) ],
      extra_options  => [ qw(biz buz baz) ],
      commands       => { foo => \&foo, bar => \&bar },
    );

# ADDING USAGE TO YOUR SCRIPTS

To add a usage or help capability to your scripts, just add some pod
at the bottom of your script with a USAGE section (head1).

    =head1 USAGE

     usage: myscript [options] command args
     
     Options
     -------
     --help, -h      help
     ....

If the command specified is 'help' or if you have added an optional
`--help` option, users can access the usage section from the command line.

    perl myscript.pm -h
    perl myscript.pm help

# LOGGING

`CLI::Simple` will enable you to automatically add logging to your
scrip using a [Log::Log4perl](https://metacpan.org/pod/Log%3A%3ALog4perl) logger. You can pass in a `Log4perl` configuration
string or let the class instantiat `Log::Log4perl` in easy mode.

Do this at the top of your class:

    __PACKAGE__->use_log4perl(level => 'info', config => $config);

The class will add a `--log-level` option for you if you have not
added one yourself. Additionally, you can use the `get_logger` method
to retrieve the logger.

# FAQ

- Do I need to implement commands?

    No, but if you don't you must provide the name of the subroutine that
    will implement your script as the `default` command.

        use CLI::Simple;

        sub main {
          my ($cli) = @_;

          # do something useful...
        }

        my $cli = CLI::Simple->new(
          default_option => { foo => 'bar' },
          option_specs   => [ qw(foo=s bar=s) ],
          extra_options  => [ qw(biz buz baz) ],
          commands       => { default => \&main },
        );

        $cli->run;

- Do I have to subclass `CLI::Simple`?

    No, see above example,

- How can I use the "modulino pattern"?

    I like to implement scripts as a Perl class and use the so-called
    "modulino" pattern popularized by Brian d foy. Essentially you create
    a class that looks something like this:

        package Foo;

        caller or  __PACKAGE__->main();

        sub main {
          ....
        }

    Using this pattern you can write Perl modules that can also be used as
    a script or test harness.

    To make it easy to use such a module, I've created a `bash` script that
    calls the module with the arguments passed on the command line.

    The script (`modulino`) is include in this distribution.

    Use it to create a symlink to itself that will load your Perl module
    and run your modulino. Running `modulino` will echo a command you can
    run to create the symlink.

        >modulino Foo::Bar
        ln -s /usr/local/bin/modulino foo_bar

# LICENSE AND COPYRIGHT

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl itself.

# SEE ALSO

[Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong), [CLI::Simple::Utils](https://metacpan.org/pod/CLI%3A%3ASimple%3A%3AUtils)

# AUTHOR

Rob Lauer - <rlauer6@comcast.net>
