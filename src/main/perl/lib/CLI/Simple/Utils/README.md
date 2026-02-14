# NAAME

    CLI::Simple::Utils

# SYNOPSIS

    CLI::Simple::Utils qw(choose);

# DESCRIPTION

Utilities that might be useful when writing command line scripts.

# METHODS AND SUBROUTINES

## choose

An anonymous subroutine disguising as a block level internal
subroutine (of sorts). Use when a ternary or a cascading if/else block
just seems wrong.

    choose {
      return "foo"
        if $bar;

      return "bar"
        if $foo;
    };

## dmp

    dmp this => $this, that => $that;

Shortcut for:

    print {*STDERR} Dumper([this => $this, that => $that]);
    

## slurp\_json

    slurp_json($file)

Returns a Perl object from a presumably JSON encoded file.

## slurp

    slurp(file)

Return the entire contents of a file.

# LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.  See
[https://dev.perl.org/licenses/](https://dev.perl.org/licenses/) for more information.

# AUTHOR

Rob Lauer - <bigfoot@cpan.org>

# SEE ALSO
