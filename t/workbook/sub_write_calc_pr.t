###############################################################################
#
# Tests for Excel::Writer::XLSX::Workbook methods.
#
# reverse ('(c)'), September 2010, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions '_new_workbook';
use strict;
use warnings;

use Test::More tests => 4;


###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $workbook;


###############################################################################
#
# Test the _write_calc_pr() method.
#
$caption  = " \tWorkbook: _write_calc_pr()";
$expected = '<calcPr calcId="124519" calcOnSave="0"/>';

$workbook = _new_workbook(\$got);

$workbook->_write_calc_pr();

is( $got, $expected, $caption );

###############################################################################
#
# Test the _write_calc_pr() method w/ non-default calcId.
#
$caption  = " \tWorkbook: _write_calc_pr() non-default calcId";
$expected = '<calcPr calcId="125725" calcOnSave="0"/>';

$workbook = _new_workbook(\$got);

$workbook->set_calc_mode('auto', 125725);
$workbook->_write_calc_pr();

is( $got, $expected, $caption );

###############################################################################
#
# Test the _write_calc_pr() method w/ manual calculation
#
$caption  = " \tWorkbook: _write_calc_pr() manual calcId";
$expected = '<calcPr calcId="124519" calcOnSave="0" calcMode="manual"/>';

$workbook = _new_workbook(\$got);

$workbook->set_calc_mode('manual');
$workbook->_write_calc_pr();

is( $got, $expected, $caption );

###############################################################################
#
# Test the _write_calc_pr() method w/ autoNoTable calculation
#
$caption  = " \tWorkbook: _write_calc_pr() autoNoTable";
$expected = '<calcPr calcId="124519" calcOnSave="0" calcMode="autoNoTable"/>';

$workbook = _new_workbook(\$got);

$workbook->set_calc_mode('autoNoTable');
$workbook->_write_calc_pr();

is( $got, $expected, $caption );

__END__


