use Env;
use Data::Dumper;
use Data::Hexdumper qw(hexdump);
use Devel::Peek;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use IO::String;
use IO::File;
use File::Temp	qw/tempfile tempdir mktemp/;
use File::Path	qw(remove_tree make_path);
use File::Spec::Functions;
use File::Basename;
use Tie::IxHash;
use Storable;
use ExtUtils::Command::MM;

$ENV{PERL_DEBUG_MSTATS} = 1;

BEGIN {
#use Find::Lib;
    sub update_test_libs {
#search for 
	my @shoguna = qw(modshogun.pm  modshogun.so);
	my @libs_path = ('src/interfaces/perl_modular', 'src/shogun');
	my $pthsep = $DynaLoader::pthsep || ':';

#make basedir
	my $shogun_basedir = File::Spec->rel2abs('.');
	$shogun_basedir =~ s#\Wsrc\Wperl\W.*##g;

	my @ld_library_path = split(/$pthsep/, $ENV{LD_LIBRARY_PATH});    
	my $found = 0;
	foreach my $p (@ld_library_path) {
	    if(-f  File::Spec->catfile($p, $shoguna[0])) {
		$found = 1;
		last;
	    }
	}
	my @libs_dir = map(File::Spec->catfile($shogun_basedir, $_), @libs_path);
	unless($found) {
	    $ENV{LD_LIBRARY_PATH} = join($pthsep, @libs_dir);
#TODO:PTZ121030 this does not work actually, need to add more 
	}
	$found = 0;
	foreach my $p (@INC) {
	    if(-f File::Spec->catfile($p, $shoguna[0])) {
		$found = 1;
		last;
	    }
	}
	unless($found) {#unshift(@INC, $d);
	    unshift(@INC, @libs_dir);
	    #use lib (@libs_dir);#PTZ121030 does not work
	}

    }

    #check lib is present in perldb tracing mode
    if($0 =~ qr#/usr/.*src/#) {
	my $i = 2;
	my $d = File::Basename->dirname($0);
	my $p = catdir($d, '..');
	while($i-- > 0) {
	    $d = catdir($p, 'lib');
	    if(-d $d) {
		unshift(@INC, $d);
		#use lib $d;
		last;
	    }
	    $p = catdir($p, '..');
	}
    }
    &update_test_libs;
    $ENV{PERL_DL_DEBUG} = 1;
    &test_harness(0, 'blib/lib', 'blib/arch');
}

sub ok {
	_base_dumper('ok', @_);
}
sub is($$;$) {
	_base_dumper('is', @_);
}
sub like($$;$) {
	_base_dumper('like', @_);
}
sub is_deeply {
	_base_dumper('is_deeply', @_);
}

sub use_ok {
	my $u = shift;
	$u = $u . '.pm';
	$u =~ s/::/\//g;
	require $u ,(@_);
}
sub cmp_ok {
	_base('cmp_ok', @_);
}
sub diag {
	_base('diag', @_);
}
sub done_testing {
	_base('done_testing', @_);
}
sub skip {
	_base('skip', @_);
}
sub _base {
	my $s = 'Test::More::' . shift;
	if($0 =~ qr/\.t$/) {
		&{$s}(@_);
	} else {
		print caller(), @_;
	}
}
sub _base_dumper {
	my $s = 'Test::More::' . shift;
	if($0 =~ qr/\.t$/) {
		&{$s}(@_);
	} else {
		print caller(), Dumper(@_);
	}
}

if($0 =~ qr/\.t$/) {
    require Test::More;
    foreach
	$s
	(qw/ok is diag done_testing use_ok skip like cmp_ok is_deeply/)
    {
	undef *{$s};
	*{$s} = \&{'Test::More::' . $s};
    }
}
#bundle of values used in nearly every tests
@search_path_d  = ('.', 'doc', '../doc', 't', '../t');
$d_t = (-d 't' ? 't/' : '');
$test_jump = "\n" x 3;
$cache_d = $d_t . 'tmp';
$db_n = $d_t . 'test_results.db';
$dsn = 'dbi:SQLite:dbname=' . $db_n;
$f_store = $d_t . 't_convert_parse_features_stats.pdb';
@f_tests = ();
@f_directories = ();

sub find_test_file {
  my $s = shift || '.g';
  if(-f $s) {
    return $s;
  }
  if(-f '../' . $s) {
    return '../' . $s;
  }
  if(-f '../../' . $s) {
    return '../../' . $s;
  }
  if(-f 't/' . $s) {
    return 't/' . $s;
  }
  if(-f '../t/' . $s) {
    return '../t/' . $s;
  }
  if(-f 'contrib/' . $s) {
    return 'contrib/' . $s;
  }
  if(-f '../contrib/' . $s) {
    return '../contrib/' . $s;
  }
  diag("FIXME: test file $s not found");
  return $s;
}

use PDL::LiteF;
eval 'require PDL::NiceSlice';
$| = 1; #select stdout
sub PDL::NiceSlice::findslice;
sub translate_and_show {
  my ($txt) = @_;
  my $etxt = PDL::NiceSlice::findslice $txt;
  print "$txt -> \n\t$etxt\n";
  return $etxt;
}





1;
__END__
