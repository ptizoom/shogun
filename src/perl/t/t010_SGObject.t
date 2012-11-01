#!/usr/bin/perl -I t -I blib/arch -I ../blib/arch -I blib/lib -I ../blib/lib -I /usr/src/shogun/src/interfaces/perl_modular -I/usr/src/shogun/src/shogun
#use strict;



BEGIN { 
    require tests;
    eval 'require modshogun';
    unless ($@) {
#	plan tests => ,
	# todo => [37..40],
    } else {
	#plan tests => 1;
	print join(':', @INC);
	print "\n";
	print "LD_LIBRARY_PATH=".$ENV{LD_LIBRARY_PATH};
	print "\n";
	print "nok 1 # no modshogun support\n";
	exit;
    }
}
#PTZ121030 we have to test all this...
#modshogun::SGObject;
# *ref_count = *modshogunc::SGObject_ref_count;
# *shallow_copy = *modshogunc::SGObject_shallow_copy;
# *deep_copy = *modshogunc::SGObject_deep_copy;
# *get_name = *modshogunc::SGObject_get_name;
# *is_generic = *modshogunc::SGObject_is_generic;
# *unset_generic = *modshogunc::SGObject_unset_generic;
# *print_serializable = *modshogunc::SGObject_print_serializable;
# *save_serializable = *modshogunc::SGObject_save_serializable;
# *load_serializable = *modshogunc::SGObject_load_serializable;
# *load_file_parameters = *modshogunc::SGObject_load_file_parameters;
# *load_all_file_parameters = *modshogunc::SGObject_load_all_file_parameters;
# *map_parameters = *modshogunc::SGObject_map_parameters;
# *set_global_io = *modshogunc::SGObject_set_global_io;
# *get_global_io = *modshogunc::SGObject_get_global_io;
# *set_global_parallel = *modshogunc::SGObject_set_global_parallel;
# *get_global_parallel = *modshogunc::SGObject_get_global_parallel;
# *set_global_version = *modshogunc::SGObject_set_global_version;
# *get_global_version = *modshogunc::SGObject_get_global_version;
# *get_modelsel_names = *modshogunc::SGObject_get_modelsel_names;
# *print_modsel_params = *modshogunc::SGObject_print_modsel_params;
# *get_modsel_param_descr = *modshogunc::SGObject_get_modsel_param_descr;
# *get_modsel_param_index = *modshogunc::SGObject_get_modsel_param_index;
# *build_parameter_dictionary = *modshogunc::SGObject_build_parameter_dictionary;
# *swig_io_get = *modshogunc::SGObject_io_get;
# *swig_io_set = *modshogunc::SGObject_io_set;
# *swig_parallel_get = *modshogunc::SGObject_parallel_get;
# *swig_parallel_set = *modshogunc::SGObject_parallel_set;
# *swig_version_get = *modshogunc::SGObject_version_get;
# *swig_version_set = *modshogunc::SGObject_version_set;
# *swig_m_parameters_get = *modshogunc::SGObject_m_parameters_get;
# *swig_m_parameters_set = *modshogunc::SGObject_m_parameters_set;
# *swig_m_model_selection_parameters_get = *modshogunc::SGObject_m_model_selection_parameters_get;
# *swig_m_model_selection_parameters_set = *modshogunc::SGObject_m_model_selection_parameters_set;
# *swig_m_parameter_map_get = *modshogunc::SGObject_m_parameter_map_get;
# *swig_m_parameter_map_set = *modshogunc::SGObject_m_parameter_map_set;
# *swig_m_hash_get = *modshogunc::SGObject_m_hash_get;
# *swig_m_hash_set = *modshogunc::SGObject_m_hash_set;


my $a = sequence 10;

#ok($s_a = modshogun::SGObject->());
ok($s_a = modshogun::SGObject->get_name());
diag($s_a);

END {
    done_testing(4);
}

__END__
my $b = pdl(1);

eval translate_and_show '$b = $a((5));';
ok(!$@);
ok($b->at == 5);
eval translate_and_show '$b = $a->((5));';
ok (!$@);
ok($b->at == 5);

my $c = PDL->pdl(7,6);
eval translate_and_show '$b = $a(($c(1)->at(0)));';
ok (!$@);
ok($b->getndims == 0 && all $b == 6);

# the latest versions should do the 'at' automatically
eval translate_and_show '$b = $a(($c(1)));';
ok (!$@);
ok($b->getndims == 0 && all $b == 6);

eval translate_and_show '$c = $a(:);';
ok (!$@);
print $@ if $@;
ok ($c->getdim(0) == 10 && all $c == $a);

my $idx = pdl 1,4,5;

eval translate_and_show '$b = $a($idx);';
ok (!$@);
ok(all $b == $idx);

# use 1-el piddles as indices
my $rg = pdl(2,7,2);
my $cmp = pdl(2,4,6);
eval translate_and_show '$b = $a($rg(0):$rg(1):$rg(2));';
ok (!$@);
ok(all $b == $cmp);

# mix ranges and index piddles
my $twod = sequence 5,5;
$idx = pdl 2,3,0;
$cmp = $twod->slice('-1:0')->dice_axis(1,$idx);
eval translate_and_show '$b = $twod(-1:0,$idx);';
ok (!$@);
ok(all $b == $cmp);

#
# modifiers
#

$a = sequence 10;
eval translate_and_show '$b = $a($a<3;?)' ;
ok (!$@);
ok(all $b == pdl(0,1,2));

# flat modifier
$a = sequence 3,3;
eval translate_and_show '$b = $a(0:-2;_);';
ok (!$@);
ok(all $b == sequence 8);

# where modifier cannot be mixed with other modifiers
$a = sequence 10;
eval { translate_and_show '$b = $a($a<3;?_)' };
ok ($@ =~ 'more than 1');

# more than one identifier
$a = sequence 3,3;
eval translate_and_show '$b = $a(0;-|)';
print "Error was: $@\n" if $@;
ok (!$@);
eval {$b++};
print "\$b = $b\n";
ok($b->dim(0) == 3 && all $b == 3*sequence(3)+1);
ok($a->at(0,0) == 0);

# do we ignore whitspace correctly?
eval translate_and_show '$c = $a(0; - | )';
print "Error was: $@\n" if $@;
ok (!$@);
ok (all $c == $b-1);

# empty modifier block
$a = sequence 10;
eval translate_and_show '$b = $a(0;   )';
ok (!$@);
ok ($b == $a->at(0));

# modifiers repeated
eval 'translate_and_show "\$b = \$a(0;-||)"';
print "Error was: $@\n" if $@;
ok ($@ =~ 'twice or more');

# foreach/for blocking

$a = '';
eval translate_and_show "foreach \n" . ' $b(1,2,3,4) {$a .= $b;}';
ok(!$@ and $a eq '1234');

$a = '';
eval translate_and_show 'for    $b(1,2,3,4) {$a .= $b;}';
ok(!$@ and $a eq '1234');

$a = '';
eval translate_and_show 'for  my  $b(1,2,3,4) {$a .= $b;}';
ok(!$@ and $a eq '1234');

$a = '';
eval translate_and_show 'for  our $b(1,2,3,4) {$a .= $b;}';
ok(!$@ and $a eq '1234');

$a = ''; # foreach and whitespace
eval translate_and_show 'foreach  my $b (1,2,3,4) {$a .= $b;}';
ok(!$@ and $a eq '1234');

$a = ''; my $t = ones 10; # foreach and imbedded expression
eval translate_and_show 'foreach my $type ( $t(0)->list ) { $a .= $type }';
ok(!$@ and $a eq '1');

# block method access translation

$a = pdl(5,3,2);
my $method = 'dim';
eval translate_and_show '$c = $a->$method(0)';
print "c: $c\n";
ok(!$@ && $c == $a->dim(0));

#
# todo ones
#

# whitespace tolerance

$a= sequence 10;
eval translate_and_show '$c = $a (0)';
ok(!$@ && $c == $a->at(0));

# comment tolerance

eval translate_and_show << 'EOT';

$c = $a-> # comment
	 (0);
EOT

ok(!$@ && $c == $a->at(0));

eval translate_and_show << 'EOT';

$c = $a-> # comment
          # comment line 2
	 (0);
EOT

ok(!$@ && $c == $a->at(0));

$a = ''; # foreach and whitespace + comments
eval translate_and_show << 'EOT';

foreach  my $b # a random comment thrown in

(1,2,3,4) {$a .= $b;}

EOT

ok(!$@ and $a eq '1234');

# test for correct header propagation
$a = ones(10,10);
my $h = {NAXIS=>2,
	 NAXIS1=>100,
	 NAXIS=>100,
	 COMMENT=>"Sample FITS-style header"};
$a->sethdr($h);
$a->hdrcpy(1);
eval translate_and_show '$b = $a(1:2,pdl(0,2));';

# Old hdrcpy test (for copy-by-reference); this is obsolete
# with quasi-deep copying.  --CED 11-Apr-2003
#   ok (!$@ and $b->gethdr() == $h);
ok(!$@ and join("",%{$b->gethdr}) eq join("",%{$h}));

$a = ones(10);
my $i = which $a < 0;
my $ai;
eval translate_and_show '$ai = $a($i);';
ok(isempty $ai );


__END__

# modshogun::BinaryLabels;
# *obtain_from_generic = *modshogunc::BinaryLabels_obtain_from_generic;
# *ensure_valid = *modshogunc::BinaryLabels_ensure_valid;
# *scores_to_probabilities = *modshogunc::BinaryLabels_scores_to_probabilities;
# ############# Class : modshogun::DenseLabels ##############
# #@ISA = qw( modshogun::Labels modshogun );
# *ensure_valid = *modshogunc::DenseLabels_ensure_valid;
# *load = *modshogunc::DenseLabels_load;
# *save = *modshogunc::DenseLabels_save;
# *set_label = *modshogunc::DenseLabels_set_label;
# *set_int_label = *modshogunc::DenseLabels_set_int_label;
# *get_label = *modshogunc::DenseLabels_get_label;
# *get_int_label = *modshogunc::DenseLabels_get_int_label;
# *get_labels = *modshogunc::DenseLabels_get_labels;
# *get_labels_copy = *modshogunc::DenseLabels_get_labels_copy;
# *set_labels = *modshogunc::DenseLabels_set_labels;
# *set_to_one = *modshogunc::DenseLabels_set_to_one;
# *zero = *modshogunc::DenseLabels_zero;
# *set_to_const = *modshogunc::DenseLabels_set_to_const;
# *get_int_labels = *modshogunc::DenseLabels_get_int_labels;
# *set_int_labels = *modshogunc::DenseLabels_set_int_labels;
# *REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;
# *REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;
