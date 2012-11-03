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
sub EXPECT_EQ {
    &is($_[0], $_[1]) or &diag(caller(), " check this ");
}
sub EXPECT_TRUE {
    &ok(@_) or &diag(caller(), "::check this::", $@, @_);
}

@vtypes = qw/ULongInt Int Real Word Byte Char Bool ShortReal LongInt/;

@vtypes = qw/Char ULongInt Int Real Word Byte Bool ShortReal LongInt/;


=pod

SparseVector

=cut

# *swig_num_feat_entries_get = *modshogunc::BoolSparseVector_num_feat_entries_get;
# *swig_num_feat_entries_set = *modshogunc::BoolSparseVector_num_feat_entries_set;

#modshogun::SGReferencedData
# *ref_count = *modshogunc::SGReferencedData_ref_count;
# *save_serializable = *modshogunc::SGReferencedData_save_serializable;
# *load_serializable = *modshogunc::SGReferencedData_load_serializable;


# *size = *modshogunc::BoolVector_size;
# *zero = *modshogunc::BoolVector_zero;
# *set_const = *modshogunc::BoolVector_set_const;
# *range_fill = *modshogunc::BoolVector_range_fill;
# *random = *modshogunc::BoolVector_random;
# *clone = *modshogunc::BoolVector_clone;
# *clone_vector = *modshogunc::BoolVector_clone_vector;
# *fill_vector = *modshogunc::BoolVector_fill_vector;
# *range_fill_vector = *modshogunc::BoolVector_range_fill_vector;
# *random_vector = *modshogunc::BoolVector_random_vector;
# *randperm = *modshogunc::BoolVector_randperm;
# *get_element = *modshogunc::BoolVector_get_element;
# *set_element = *modshogunc::BoolVector_set_element;
# *resize_vector = *modshogunc::BoolVector_resize_vector;
# *permute_vector = *modshogunc::BoolVector_permute_vector;
# *permute = *modshogunc::BoolVector_permute;
# *resize = *modshogunc::BoolVector_resize;
# *twonorm = *modshogunc::BoolVector_twonorm;
# *onenorm = *modshogunc::BoolVector_onenorm;
# *qsq = *modshogunc::BoolVector_qsq;
# *qnorm = *modshogunc::BoolVector_qnorm;
# *vec1_plus_scalar_times_vec2 = *modshogunc::BoolVector_vec1_plus_scalar_times_vec2;
# *dot = *modshogunc::BoolVector_dot;
# *vector_multiply = *modshogunc::BoolVector_vector_multiply;
# *add = *modshogunc::BoolVector_add;
# *add_scalar = *modshogunc::BoolVector_add_scalar;
# *scale_vector = *modshogunc::BoolVector_scale_vector;
# *sum = *modshogunc::BoolVector_sum;
# *min = *modshogunc::BoolVector_min;
# *max = *modshogunc::BoolVector_max;
# *arg_max = *modshogunc::BoolVector_arg_max;
# *arg_min = *modshogunc::BoolVector_arg_min;
# *sum_abs = *modshogunc::BoolVector_sum_abs;
# *fequal = *modshogunc::BoolVector_fequal;
# *unique = *modshogunc::BoolVector_unique;
# *display_size = *modshogunc::BoolVector_display_size;
# *find = *modshogunc::BoolVector_find;
# *sorted_index = *modshogunc::BoolVector_sorted_index;
# *scale = *modshogunc::BoolVector_scale;
# *mean = *modshogunc::BoolVector_mean;
# *swig_vector_get = *modshogunc::BoolVector_vector_get;
# *swig_vector_set = *modshogunc::BoolVector_vector_set;
# *swig_vlen_get = *modshogunc::BoolVector_vlen_get;
# *swig_vlen_set = *modshogunc::BoolVector_vlen_set;
# *save_serializable = *modshogunc::BoolVector_save_serializable;
# *load_serializable = *modshogunc::BoolVector_load_serializable;

=TODO

#TODO:PTZ121031 overload ->[] with Vector{get,set}_element
#TODO:PTZ121031 overload ->{vlen} with ->vlen()
#TODO:PTZ121031 overload ->{vector} with ->vector()
#TODO:PTZ121031 auto type correction? TypeError in method 'ULongIntVector_set_const', argument 2 of type 'unsigned long' at /usr/src/shogun/perl/t/t020_SGVector.t line 107.
#TODO:PTZ121031  $funv->clone_vector($a->{vector}, $a->{vlen}) creates 3 elements and is not handled by swig


=cut


sub TEST_ctor
{
    my ($class, $T) = @_;
    my $funv = eval('modshogun::'. $T . $class);
    diag('testing instanciators of ' . 'modshogun::'. $T . $class );
    ok($a = $funv->new(10));
    &EXPECT_EQ($a->{vlen}, 10);
    eval($a->zero());
    ok(!$@);
    for ( $i=0; $i < 10; ++$i) {
	$ai = $a->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord $ai;
	}
	&EXPECT_EQ(0, $ai);
    }

    $dv = 3.3;
    if($T =~/Real/) {
	$v = $dv;
    } else {
	$v = int($dv);
    }
    eval($a->set_const($v));
    ok(!$@);
    for ( $i=0; $i < 10; ++$i) {
	$ai = $a->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord $ai;
	}
	&EXPECT_EQ($v, $ai);
    }
    ok($a_clone_v = *{$funv . '::clone_vector'}->($a->{vector}, $a->{vlen}));
    
    for ( $i=0; $i < 10; ++$i) {
#TODO::PTZ121101 use some sort of peek function
#	&EXPECT_EQ($a_clone_v->[$i], $a->get_element($i));
    }
    ok($b = $funv->new($a_clone_v, 10, 1));
    &EXPECT_EQ($b->{vlen}, 10);
    for ( $i=0; $i < 10; ++$i) {
	&EXPECT_EQ($b->get_element($i), $a->get_element($i));
    }
    #/* test copy ctor */
    ok($c = $funv->new($b));
    &EXPECT_EQ($c->{vlen}, $b->{vlen});
    for ( $i=0; $i < $c->{vlen}; ++$i) {
	&EXPECT_EQ($b->get_element($i), $c->get_element($i));
    }
}
sub TEST_add
{# testing adding of modshogun::BoolVector
    my ($class, $T) = @_;
    my $funv= eval 'modshogun::'. $T . $class;
    diag('testing adding of ' . 'modshogun::'. $T . $class );

    ok($a = $funv->new(10));
    ok($b = $funv->new(10));
    $n = 1024.0;
    if($T =~ /Byte|Char/) { $n = 127.0 }
    #if($T =~ /Bool/) { $n = 1.0 }
    
    eval $a->random(0.0, $n);
    ok(!$@);
    eval $b->random(0.0, $n);
    ok(!$@);

    ok($b_clone_v = *{$funv . '::clone_vector'}->($b->{vector}, $b->{vlen}));
    ok($c = $funv->new($b_clone_v, 10, 1));

    eval $c->add($a);
    ok(!$@);
    for($i = 0; $i < $c->{vlen}; ++$i) {
	if($T =~ /Char/) {
	    &EXPECT_EQ(ord($a->get_element($i)) + ord($b->get_element($i)), ord($c->get_element($i)));
	} else {
	    &EXPECT_EQ($a->get_element($i) + $b->get_element($i), $c->get_element($i));
	}
    }

    $c = $a + $a;
    &is(ref($c), 'PDL');
    &EXPECT_EQ($c->nelem, $a->{vlen});
    for ( $i=0; $i < $a->{vlen}; ++$i) {
	if($T =~ /Char/) {
	    &EXPECT_EQ($c->at($i), 2 * ord($a->get_element($i)));
	} else {
	    &EXPECT_EQ($c->at($i), 2*$a->get_element($i));
	}
    }
}
sub TEST_dot
{
    my ($class, $T) = @_;
    my $funv= eval 'modshogun::'. $T . $class;
    diag('testing dot product of ' . 'modshogun::'. $T . $class );

    my $a = $funv->new(10);
    $n = 1024.0;
    if($T =~ /Byte|Char/) { $n = 127.0 }
    $a->random(0.0, $n);
   
    my $dot_val = 0.0;
    for (my $i = 0; $i < $a->{vlen}; ++$i) {
	if($T =~ /Char/) {
	    $dot_val += ord($a->get_element($i)) ** 2;
	} else {
	    $dot_val += $a->get_element($i) * $a->get_element($i);
	}
    }
    my $a_dot;
    &ok($a_dot = *{$funv . '::dot'}->($a->{vector}, $a->{vector}, $a->{vlen}));
    $error = abs($dot_val - $a_dot);
    
    &EXPECT_TRUE($error < 10E-10);
}

sub TEST_norm
{
    my ($class, $T) = @_;
    my $funv= eval 'modshogun::'. $T . $class;
    diag('testing norm of ' . 'modshogun::'. $T . $class );
    
    my $a = $funv->new(10);
    $n = 1024.0;
    $n0 = -50.;
    if($T =~ /Byte|Char/) { $n = 127.0; }
    if($T =~ /U|Byte|Bool|Word/) { $n0 = 0.0; }
    #if($T =~ /Bool/) { $n = 1; }

    #Unsigned
    $a->random($n0, $n);
    
    #/* check l-2 norm */	
    $a_dot = *{$funv . '::dot'}->($a->{vector}, $a->{vector}, $a->{vlen});
    $l2_norm = modshogun::Math::sqrt($a_dot);

    unless($T =~ /Char|Bool/) {
	$error = abs($l2_norm - *{$funv . '::twonorm'}->($a->{vector}, $a->{vlen}));
	&EXPECT_TRUE($error < 10E-12);
    }
    $l1_norm = 0.0;
    for (my $i = 0; $i < $a->{vlen}; ++$i) {
	if($T =~ /Char/) {
	    $l1_norm += ord($a->get_element($i));
	    
	} else {
	    $l1_norm += abs($a->get_element($i));
	}
    }
    &EXPECT_EQ($l1_norm, *{$funv . '::onenorm'}->($a->{vector}, $a->{vlen}));

    my $b = $funv->new(10);

    $b->set_const(1.0);
    &EXPECT_EQ(10.0, *{$funv .   '::qsq'}->($b->{vector}, $b->{vlen}, 0.5));
    &EXPECT_EQ(100,  *{$funv . '::qnorm'}->($b->{vector}, $b->{vlen}, 0.5));
}


sub TEST_misc
{
    my ($class, $T) = @_;
    my $funv= eval 'modshogun::'. $T . $class;
    diag('testing miscelenia of ' . 'modshogun::'. $T . $class );
    
    my $a = $funv->new(10);
    $n = 1024.0;
    $n0 = -1024.;
    if($T =~ /Byte|Char/) { $n = 127.0; }
    if($T =~ /U|Byte|Bool|Word/) { $n0 = 0.0; }

    #/* test, min, max, sum */
    $min = 1025;
    $max = -1025;
    $sum = 0.0;
    $sum_abs = 0.0;
    for (my $i = 0; $i < $a->{vlen}; ++$i) {
	my $ai=$a->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord($ai);
	}
	$sum += $ai;
	$sum_abs += abs($ai);
	if ($ai > $max) {
	    $max = $ai;
	}
	if ($ai < $min) {
	    $min = $ai;
	}
    }
    &EXPECT_EQ($min, *{$funv . '::min'}->($a->{vector}, $a->{vlen}));
    &EXPECT_EQ($max, *{$funv . '::max'}->($a->{vector}, $a->{vlen}));
    &EXPECT_EQ($sum, *{$funv . '::sum'}->($a->{vector}, $a->{vlen}));
    &EXPECT_EQ($sum_abs, *{$funv . '::sum_abs'}->($a->{vector}, $a->{vlen}));

    #/* test ::vector_multiply(...) */
    my $c = $funv->new(10);
    *{$funv . '::vector_multiply'}->($c->{vector}, $a->{vector}, $a->{vector}, $a->{vlen});
    for($i = 0; $i < $c->{vlen}; ++$i) {
	my $ai=$a->get_element($i);
	my $ci=$c->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord($ai);
	    $ci = ord($ci);	    
	}
	&EXPECT_EQ($ci, $ai ** 2);
    }

    #/* test ::add(...) */
    my ($alpha, $beta) = (1.5, 1.3);
     if($T =~/Real/) {
	 ($alpha, $beta) = (1.5, 1.3);
     } else {
	 ($alpha, $beta) = (15, 13);
	 
     }
    *{$funv . '::add'}->($c->{vector}, $alpha, $a->{vector}, $beta, $a->{vector}, $a->{vlen});
    for($i = 0; $i < $c->{vlen}; ++$i) {
	my $ai=$a->get_element($i);
	my $ci=$c->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord($ai);
	    $ci = ord($ci);	    
	}
	&EXPECT_EQ($ci, $alpha * $ai + $beta * $ai);
    }

    #/* tests ::add_scalar */
    if($T =~ /U|Byte|Bool|Word/) { $n0 = 2.; }
    else {$n0 = -1.;}
    *{$funv . '::scale_vector'}->($n0, $a->{vector}, $a->{vlen});
    $a_clone_v = *{$funv . '::clone_vector'}->($a->{vector}, $a->{vlen});

    $b = $funv->new($a_clone_v, $a->{vlen}, 0);
    *{$funv . '::add_scalar'}->($alpha + $beta, $b->{vector}, $b->{vlen});
    for($i = 0; $i < $c->{vlen}; ++$i) {
	my $ai=$a->get_element($i);
	my $bi=$b->get_element($i);
	if($T =~ /Char/) {
	    $ai = ord($ai);
	    $bi = ord($bi);	    
	}
	&EXPECT_EQ($bi, $ai + $alpha + $beta);
    }
    $b_clone_v = *{$funv . '::clone_vector'}->($b->{vector}, $b->{vlen});
    $d = $funv->new($b_clone_v, $b->{vlen}, 0);

    #makes sens only with float32/64_t I guess..SWIGTYPE_p_double SWIGTYPE_p_float
    return unless($T =~ /Real/);
    *{$funv . '::vec1_plus_scalar_times_vec2'}->($d->{vector}, $beta, $d->{vector}, $d->{vlen});
    for($i = 0; $i < $d->{vlen}; ++$i) {
	my $di=$d->get_element($i);
	my $bi=$b->get_element($i);
	if($T =~ /Char/) {
	    $di = ord($di);
	    $bi = ord($bi);	    
	}
	&EXPECT_EQ($di, $bi + $beta * $bi);
    }
}


foreach $tp (@vtypes) {
    &TEST_ctor('Vector', $tp);
    &TEST_add ('Vector', $tp);
    &TEST_dot ('Vector', $tp);
    &TEST_norm('Vector', $tp);
    &TEST_misc('Vector', $tp);
}

END {
    done_testing(1080);
}

__END__
# testing norm of modshogun::BoolVector
[1;31m[ERROR][0m Sorry, not yet implemented .
 at /usr/src/shogun/src/perl/t/t020_SGVector.t line 225
	main::TEST_norm('Vector', 'Bool') called at /usr/src/shogun/src/perl/t/t020_SGVector.t line 323

# testing norm of modshogun::CharVector
#   Failed test at /usr/src/shogun/src/perl/t/t020_SGVector.t line 24.
not ok 714

#   Failed test at /usr/src/shogun/src/perl/t/t020_SGVector.t line 24.
*** glibc detected *** /usr/bin/perl: corrupted double-linked list: 0x00000000040b7ca0 ***

# testing instanciators of modshogun::BoolVector
ok 715
*** glibc detected *** /usr/bin/perl: corrupted double-linked list: 0x0000000003d0bc30 ***


stack?
 _wrap_ULongIntVector_vec1_plus_scalar_times_vec2
...?!

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

<sonne|work>:
 create some matrix
 from that x=RealFeatures(matrix)
 and then x.get_feature_matrix() (or what it is called)
 and compare if results match
 if that works do k=GaussianKernel(x,x)
 k.get_kernel_matrix()
