package Excel::XLSX::Writer::Container::App;

###############################################################################
#
# App - A class for writing the Excel XLSX app.xml file.
#
# Used in conjunction with Excel::XLSX::Writer
#
# Copyright 2000-2010, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.010000;
use strict;
use warnings;
use Exporter;
use Carp;
use XML::Writer;

our @ISA     = qw(Exporter);
our $VERSION = '0.01';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;

    my $self = {
        _writer      => undef,
        _sheet_names => [],
    };

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    return unless $self->{_writer};

    $self->_write_xml_declaration;
    $self->_write_properties();
}


###############################################################################
#
# _set_xml_writer()
#
# Set the XML::Writer for the object.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    my $output = new IO::File( $filename, 'w' );
    my $writer = new XML::Writer( OUTPUT => $output );

    $self->{_writer} => $writer;
}


###############################################################################
#
# _add_part_names()
#
# Add the name of a workbook parts suvh as 'Sheet1'.
#
sub _add_part_names {

    my $self       = shift;
    my $sheet_name = shift;

    push @{ $self->{_sheet_names} }, $sheet_name;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_xml_declaration()
#
# Write the XML declaration.
#
sub _write_xml_declaration {

    my $self       = shift;
    my $writer     = $self->{_writer};
    my $encoding   = 'UTF-8';
    my $standalone = 1;

    $writer->xmlDecl( $encoding, $standalone );
}


###############################################################################
#
# _write_properties()
#
# Write the <Properties> element.
#
sub _write_properties {

    my $self = shift;
    my $xmlns =
'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties';
    my $xmlns_vt =
      'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes';

    my @attributes = (
        'xmlns'    => $xmlns,
        'xmlns:vt' => $xmlns_vt,
    );

    $self->{_writer}->startTag( 'Properties', @attributes );
    $self->_write_application();
    $self->_write_doc_security();
    $self->_write_scale_crop();
    $self->_write_heading_pairs();
    $self->_write_titles_of_parts();
    $self->_write_company();
    $self->_write_links_up_to_date();
    $self->_write_shared_doc();
    $self->_write_hyperlinks_changed();
    $self->_write_app_version();
    $self->{_writer}->endTag( 'Properties' );
}

###############################################################################
#
# _write_application()
#
# Write the <Application> element.
#
sub _write_application {

    my $self = shift;
    my $data = 'Microsoft Excel';

    $self->{_writer}->dataElement( 'Application', $data );
}


###############################################################################
#
# _write_doc_security()
#
# Write the <DocSecurity> element.
#
sub _write_doc_security {

    my $self = shift;
    my $data = 0;

    $self->{_writer}->dataElement( 'DocSecurity', $data );
}


###############################################################################
#
# _write_scale_crop()
#
# Write the <ScaleCrop> element.
#
sub _write_scale_crop {

    my $self = shift;
    my $data = 'false';

    $self->{_writer}->dataElement( 'ScaleCrop', $data );
}


###############################################################################
#
# _write_heading_pairs()
#
# Write the <HeadingPairs> element.
#
sub _write_heading_pairs {

    my $self = shift;

    $self->{_writer}->startTag( 'HeadingPairs' );

    $self->_write_vt_vector( 'variant',
        [ [ 'lpstr', 'Worksheets' ], [ 'i4', 1 ] ] );

    $self->{_writer}->endTag( 'HeadingPairs' );
}


###############################################################################
#
# _write_titles_of_parts()
#
# Write the <TitlesOfParts> element.
#
sub _write_titles_of_parts {

    my $self = shift;

    $self->{_writer}->startTag( 'TitlesOfParts' );

    my @parts_data;

    for my $sheet_name ( @{ $self->{_sheet_names} } ) {
        push @parts_data, [ 'lpstr', $sheet_name ];
    }

    $self->_write_vt_vector( 'lpstr', \@parts_data );

    $self->{_writer}->endTag( 'TitlesOfParts' );
}


###############################################################################
#
# _write_vt_vector()
#
# Write the <vt:vector> element.
#
sub _write_vt_vector {

    my $self      = shift;
    my $base_type = shift;
    my $data      = shift;
    my $size      = @$data;

    my @attributes = (
        'size'     => $size,
        'baseType' => $base_type,
    );

    $self->{_writer}->startTag( 'vt:vector', @attributes );

    for my $aref ( @$data ) {
        $self->{_writer}->startTag( 'vt:variant' ) if $base_type eq 'variant';
        $self->_write_vt_data( @$aref );
        $self->{_writer}->endTag( 'vt:variant' ) if $base_type eq 'variant';
    }

    $self->{_writer}->endTag( 'vt:vector' );
}


##############################################################################
#
# _write_vt_data()
#
# Write the <vt:*> elements such as <vt:lpstr> and <vt:if>.
#
sub _write_vt_data {

    my $self = shift;
    my $type = shift;
    my $data = shift;

    $self->{_writer}->dataElement( "vt:$type", $data );
}


###############################################################################
#
# _write_company()
#
# Write the <Company> element.
#
sub _write_company {

    my $self = shift;
    my $data = 'perl.org';

    $self->{_writer}->dataElement( 'Company', $data );
}


###############################################################################
#
# _write_links_up_to_date()
#
# Write the <LinksUpToDate> element.
#
sub _write_links_up_to_date {

    my $self = shift;
    my $data = 'false';

    $self->{_writer}->dataElement( 'LinksUpToDate', $data );
}


###############################################################################
#
# _write_shared_doc()
#
# Write the <SharedDoc> element.
#
sub _write_shared_doc {

    my $self = shift;
    my $data = 'false';

    $self->{_writer}->dataElement( 'SharedDoc', $data );
}


###############################################################################
#
# _write_hyperlinks_changed()
#
# Write the <HyperlinksChanged> element.
#
sub _write_hyperlinks_changed {

    my $self = shift;
    my $data = 'false';

    $self->{_writer}->dataElement( 'HyperlinksChanged', $data );
}


###############################################################################
#
# _write_app_version()
#
# Write the <AppVersion> element.
#
sub _write_app_version {

    my $self = shift;
    my $data = 12.0001;

    $self->{_writer}->dataElement( 'AppVersion', $data );
}


1;


__END__

=pod

=head1 NAME

App - A class for writing the Excel XLSX app.xml file.

=head1 SYNOPSIS

See the documentation for L<Excel::XLSX::Writer>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::XLSX::Writer>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMX, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::XLSX::Writer>.

=cut
