package EDF::Reader;

use warnings;
use strict;

use Data::Dumper;

=head1 NAME

EDF::Reader - Read 'Easy Data File's

=head1 DESCRIPTION

Read 'Easy Data Files'. A (non technical) human readable textuak data format for small amounts of data storage in plain text files

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

    file.txt :

    ##
    # FILEDEF
    # field1 REQUIRED
    # feild2
    ##

    field1 : foo
    field2 : bar
    -----------
    program.pl :

    use EDF::Reader;

    my $edf = EDF::Reader->new('path/to/file.txt');
    my $data = $edf->data;
    ...

=head1 METHODS

=head2 new

=cut

sub new {
  my ($class, $file) = @_;
  my $self = {};
  bless $self, $class;
  $self->read($file) if $file;
  return $self;
}

=head2 read

=cut

sub read {
  my ($self, $file) = @_;
  $self->{filename} = $file;

  my $text = do { local( @ARGV, $/ ) = $file ; <> };
  $self->{fields} = $self->_get_fields($text);
  $self->{data} = $self->_get_data($text);;  
}

=head2 fields

=cut

sub fields {
  my $self = shift;
  return $self->{fields};
}

=head2 data

=cut

sub data {
  my $self = shift;
  return $self->{data};
}


=head2 _get_fields

=cut

sub _get_fields {
  my ($self, $text) = @_;

  # get the file definition
  my @fields = ( $text =~ m/
                          ^\#\s*FILEDEF\s*\n     # starts with '# FILEDEF'
                           \#\s*((?:.*\s*\n)*)   # contains any number of terms
                           \#{2}?                # end ends with at least 2 '#'s
                         /mxg
               );
  @fields = split ('\n\s*\#\s*', $fields[0]);
  $_ =~ s/^\s*\#?\s*(.*?)\s*$/$1/ foreach @fields; # sanitise

  # set fields listref
  return [ map { my $req = ($_ =~ s/\s*REQUIRED\s*$//);
                 $_ = { name => $_,
                        required => $req || 0
                      }
               } @fields
         ];
}

=head2 _get_data

=cut

sub _get_data {
  my ($self, $text) = @_;

  # split into data blocks
  my @blocks = split(/\n\s*\n/, $text);

  my @data;
  foreach my $block (@blocks){
    my @lines = split ('\n', $block);
    my $currentfield;
    my $dataset = {};
    foreach my $line (@lines){
      my $appendtext;
      foreach my $field (@{$self->{fields}}){
        my $regexpstr = '^\s*(' . $field->{name} . ')\s*:\s*(.*)$';
        if ($line =~ m/$regexpstr/){
          $currentfield = $1; # found a new field
          $appendtext = $2 || ' ' # If no data use a space.
                                  # This will be stripped later;
        }
      }
      next unless $currentfield;
      $appendtext ||= $line;
      $appendtext =~ s/^\s+//g;
      $appendtext =~ s/\s+$//g;
      $dataset->{$currentfield} .= "\n" if $dataset->{$currentfield};
      $dataset->{$currentfield} .= $appendtext;
    }
    my $missing_keys;
    foreach (@{$self->{fields}}){
      if ($_->{required}){
        $missing_keys = 1 unless $dataset->{$_->{name}};
      }
    }
    if (!$missing_keys &&
         scalar keys %$dataset > 0){
      push @data, $dataset;
    }
  }

  $self->{data} = \@data;
}



=head1 AUTHOR

Alex Monney, C<< <alexmonney at hotmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-edf-reader at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=EDF-Reader>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EDF::Reader

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EDF-Reader>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/EDF-Reader>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/EDF-Reader>

=item * Search CPAN

L<http://search.cpan.org/dist/EDF-Reader>

=back


=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Alex Monney, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;
