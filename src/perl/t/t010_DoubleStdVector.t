#!/usr/bin/perl -I /usr/src/shogun/src/interfaces/perl_modular
#tests for ...
# *size = *modshogunc::DoubleStdVector_size;
# *empty = *modshogunc::DoubleStdVector_empty;
# *clear = *modshogunc::DoubleStdVector_clear;
# *push = *modshogunc::DoubleStdVector_push;
# *pop = *modshogunc::DoubleStdVector_pop;
# *get = *modshogunc::DoubleStdVector_get;
# *set = *modshogunc::DoubleStdVector_set;


BEGIN { 
    require tests;
    unless ($@) {
#	plan tests => ,
	# todo => [37..40],
    } else {
#	plan tests => 1;
#	print "ok 1 # Skipped: no sourcefilter support\n";
	exit;
    }
}

use_ok('modshogun');
ok (!$@);

ok($a_s = modshogun::DoubleStdVector->new());
ok($a_s->empty());


my $a = sequence 10;
eval '$a_s = modshogun::DoubleStdVector->new($a)';
ok($@);

ok($a_s = modshogun::DoubleStdVector->new([(0..10)]));
ok(! $a_s->empty());
ok($a_s->size() == 11);


ok($a_s->get(10) == 10);

eval '$v = $a_s->get(11)';
ok($@);

eval '$a_s->push(13)';
ok(!$@);

ok($a_s->get(11) == 13);

ok($a_s->pop() == 13);


END {
    done_testing(13);
}

