# NAME

CLI::Simple - a framework for creating option driven Perl scripts

# SYNOPIS

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

This documentation describes version 0.0.8.

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

    caller or __PACKAGE__main();

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

`args` is a hash or hash reference containing the following keys:

- commands (required)

    A hash reference containing the command names and a code reference to
    the subroutines that implement the command.

    Example:

        { 
          send    => \&send_message,
          receive => \&receive_message,
        }

    If your script does not accept a command, set a `default` key to the
    subroutine or method that will implement your script.

        { default => \&main }

- default\_options (optional)

    A hash reference that contains the default values for your options.  

- extra\_options

    If you want to create additional setters or getters, set
    `extra_options` to an array of names.

    Example:

        extra_options => [ qw(foo bar baz) ]

- option\_specs (required)

    An array reference of option specifications.  These are the same as
    those passed to `Getopt::Long`.

Instantiates a new `CLI::Simple` object.

## run

Execute the script with the given options, commands and arguments. The
`run` method interprets the command line and pass control to your command
subroutines. Your subroutines should return a 0 for success and a
non-zero value for failure.  This error code is passed to the shell as
the script return code.

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
converted to snake case names. (Some folks find it easier to use '-'
rather than '\_' for option names.)

# COMMAND ARGUMENTS

If you want to allow your commands to accept positional arguments you
can retrieve them as named hash elements.  This can make your code much
easier to read and understand.

    sub send_message {
      my ($self) = @_;

      my %args = $self->get_args(qw(phone_number message));

      send_sms_mesage($args{phone_number}, $args{message});
      ...
    }

If you pass an empty list then all of the command arguments will be
returned.

    my ($phone_number, $message) = $self->get_args;

# SETTING DEFAULT VALUES FOR OPTIONS

To set default values for your option, pass a hash reference as the
`default_options` argument to the constructor.

    my $cli = CLI::Simple->new(
      default_option => { foo => 'bar' },
      option_specs   => [ qw(foo=s bar=s) ],
      commands       => { foo => \&foo, bar => \&bar },
    );

# ADDING ADDITIONAL SETTERS & GETTERS

As noted all command line options are available using getters of the
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

To add usage or help capability to your scripts, just add some pod
at the bottom of your script in a USAGE section (head1).

    =head1 USAGE

     usage: myscript [options] command args
     
     Options
     -------
     --help, -h      help
     ....

If the command specified is 'help' or if you have added an optional
`--help` option, users can then access the usage section from the command line.

    perl myscript.pm -h perl myscript.pm help

# LOGGING

`CLI::Simple` will enable you to automatically add logging to your
script using a [Log::Log4perl](https://metacpan.org/pod/Log%3A%3ALog4perl) logger. You can pass in a `Log4perl`
configuration string or let the class instantiate `Log::Log4perl` in
easy mode.

Do this at the top of your class:

    __PACKAGE__->use_log4perl(level => 'info', config => $config);

The class will add a `--log-level` option for you if you have not
added one yourself. Additionally, you can use the `get_logger` method
to retrieve the logger.

# FAQ

- How do I execute some startup code before my command runs?

    The `new` constructor will execute an `init()` method prior to
    returning. Implement your own ["init"](#init) function which will have of the
    commands and arguments available to it at that time.

- Do I need to implement commands?

    No, but if you don't you must provide the name of the subroutine that
    will implement your script logic as the `default` command.

        use CLI::Simple;

        sub do_it {
          my ($cli) = @_;

          # do something useful...
        }

        my $cli = CLI::Simple->new(
          default_option => { foo => 'bar' },
          option_specs   => [ qw(foo=s bar=s) ],
          extra_options  => [ qw(biz buz baz) ],
          commands       => { default => \&do_it },
        );

        $cli->run;

- Do I have to subclass `CLI::Simple`?

    No, see above example,

- How do I turn my class into a script?

    I like to implement scripts as a Perl class and use the so-called
    "modulino" pattern popularized by Brian d foy. Essentially you create
    a class that looks something like this:

        package Foo;

        caller or  __PACKAGE__->main();

        sub main {
          ....
        }

        1;

    Using this pattern you can write Perl modules that can also be used as
    a script or test harness for your class.

        package MyScript;

        use strict;
        use warnings;

        caller or  __PACKAGE__->main();

        sub do_it {
          my ($cli) = @_;

          # do something useful...
        }

        sub main {

          my $cli = CLI::Simple->new(
            default_option => { foo => 'bar' },
            option_specs   => [ qw(foo=s bar=s) ],
            extra_options  => [ qw(biz buz baz) ],
            commands       => { default => \&do_it },
          );

         exit $cli->run;
        }

        1;

    To make it easy to use such a module, I've created a `bash` script that
    calls the module with the arguments passed on the command line.

    The script (`modulino`) is included in this distribution.

    You can also use the included `create-modulino.pl` script to create a
    symbolic link to your class that will be executed as if it is a Perl
    script if you've implemented the modulino pattern described above.

        sudo create-modulino.pl Foo::Bar foo-bar

    If you do not provide an alias name as the second argument the script
    will create a copy of the `modulino` script as a normalized name of
    your module but will not create a symbolic link.

    The script essentially executes the recipe below.

    - 1. Copy the `modulino` script using a name that converts the
    first letter of the class to lower case and any CamelCased words
    inside the class name to lower case with all words snake cased.
    Example: `Module::ScanDeps::FindRequires` becomes:
    `module_scanDeps_findRequires`.

            sudo cp /usr/local/bin/modulino /usr/local/bin/module_scanDeps_findRequire
            

    - 2. Make sure the new script is executable.

            chmod 0755 module_scanDeps_findRequire

    - 3. Create a symlink with a name of your chosing to the new script.

            sudo ln -s /usr/local/bin/module_scanDeps_findRequire /usr/local/bin/find-requires 

# LICENSE AND COPYRIGHT

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl itself.

# SEE ALSO

[Getopt::Long](https://metacpan.org/pod/Getopt%3A%3ALong), [CLI::Simple::Utils](https://metacpan.org/pod/CLI%3A%3ASimple%3A%3AUtils)

# AUTHOR

Rob Lauer - <bigfoot@cpan.org>
