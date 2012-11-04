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

sub TEST_train
{
    my ($T) = @_;
    diag('SVMOcasTest::testing and training of ' . 'modshogun::'. $T . '' );

    my $num_samples = 50;
    &ok( $dg =	modshogun::DataGenerator->new());
    #TODO::PTZ121004 multielement piddle in conditional expression at /usr/share/perl5/Test/Builder.pm line 773
    eval { $data = modshogun::DataGenerator::generate_gaussians($num_samples, 2, 2) };
    &ok(!$@);
    &is(ref($data), 'PDL');
    diag($data->dump);
    @d = ($num_samples * 2, 2);
    (@dd) = $data->dims;
    &is_deeply(\@dd, \@d);

    &ok( $features = 	modshogun::RealFeatures->new($data));
    &ok( $train_idx =	modshogun::IntVector->new($num_samples));
    &ok( $test_idx =	modshogun::IntVector->new($num_samples));
    &ok( $labels =	modshogun::RealVector->new($num_samples));
#{num_cols}
    my ($i, $j) = (0, 0);
    while($j < $num_samples) {
	#print $i, ',', $j, '::';
	my $e = ($i < $data->getdim(0) / 2) ? 1.0 : -1.0;
	$labels->set_element($e, $j);     
	if($i % 2 == 0) {
	    $train_idx->set_element($i, $j);
	} else {
	    $test_idx->set_element($i, $j);
	    $j++;
	}
	$i++;
    }
    &ok($train_feats = $features->copy_subset($train_idx));
    &ok($test_feats  = $features->copy_subset($test_idx));

    &ok($ground_truth = modshogun::BinaryLabels->new($labels));
    &ok($ocas = new modshogun::SVMOcas(1.0, $train_feats, $ground_truth));
    &ok($ocas->train());
    &ok($pred = $ocas->apply_binary($test_feats));
    &is($pred->get_num_labels, $num_samples);

    &is($pred->get_name, 'BinaryLabels');

    &ok($mpred = eval('modshogun::' . $pred->get_name())->new());
#    $mpred = eval('modshogun::' . $pred->get_name())->obtain_from_generic($pred);

=pod

  DB<98> x $pred->get_label_type
0  _p_ELabelType=HASH(0x3491238)
Can't locate object method "FIRSTKEY" via package "_p_ELabelType" at /usr/share/perl/5.14/dumpvar.pl line 205.

=cut

    for (my $i = 0; $i < $num_samples; ++$i) {
	&EXPECT_EQ($ground_truth->get_int_label($i), ($pred->get_int_label($i)));
    }
    &SG_UNREF($ocas);
    &SG_UNREF($train_feats);
    &SG_UNREF($test_feats);
    &SG_UNREF($pred);
}

@vtypes = qw/SVMOcas/;
foreach $tp (@vtypes) {
    &TEST_train($tp);
}


END {
    done_testing(71);
}



__END__

what to test in Features...(there is also Streamed, BinnedDot, Dot...!)

*get_dim_feature_space = *modshogunc::DotFeatures_get_dim_feature_space;
*dot = *modshogunc::DotFeatures_dot;
*dense_dot_sgvec = *modshogunc::DotFeatures_dense_dot_sgvec;
*get_nnz_features_for_vector = *modshogunc::DotFeatures_get_nnz_features_for_vector;
*get_combined_feature_weight = *modshogunc::DotFeatures_get_combined_feature_weight;
*set_combined_feature_weight = *modshogunc::DotFeatures_set_combined_feature_weight;
*get_computed_dot_feature_matrix = *modshogunc::DotFeatures_get_computed_dot_feature_matrix;
*get_computed_dot_feature_vector = *modshogunc::DotFeatures_get_computed_dot_feature_vector;
*benchmark_add_to_dense_vector = *modshogunc::DotFeatures_benchmark_add_to_dense_vector;
*benchmark_dense_dot_range = *modshogunc::DotFeatures_benchmark_dense_dot_range;
*get_mean = *modshogunc::DotFeatures_get_mean;
*get_cov = *modshogunc::DotFeatures_get_cov;
*compute_cov = *modshogunc::DotFeatures_compute_cov;

*free_feature_matrix = *modshogunc::RealFeatures_free_feature_matrix;
*free_features = *modshogunc::RealFeatures_free_features;
*set_feature_vector = *modshogunc::RealFeatures_set_feature_vector;
*get_feature_vector = *modshogunc::RealFeatures_get_feature_vector;
*get_feature_matrix = *modshogunc::RealFeatures_get_feature_matrix;
*steal_feature_matrix = *modshogunc::RealFeatures_steal_feature_matrix;
*set_feature_matrix = *modshogunc::RealFeatures_set_feature_matrix;
*get_transposed = *modshogunc::RealFeatures_get_transposed;
*copy_feature_matrix = *modshogunc::RealFeatures_copy_feature_matrix;
*obtain_from_dot = *modshogunc::RealFeatures_obtain_from_dot;
*apply_preprocessor = *modshogunc::RealFeatures_apply_preprocessor;
*get_num_features = *modshogunc::RealFeatures_get_num_features;
*set_num_features = *modshogunc::RealFeatures_set_num_features;
*set_num_vectors = *modshogunc::RealFeatures_set_num_vectors;
*initialize_cache = *modshogunc::RealFeatures_initialize_cache;
*is_equal = *modshogunc::RealFeatures_is_equal;



DenseLabels  modshogun::Labels


*ensure_valid = *modshogunc::DenseLabels_ensure_valid;


*load = *modshogunc::DenseLabels_load;
*save = *modshogunc::DenseLabels_save;


*set_label = *modshogunc::DenseLabels_set_label;
*set_int_label = *modshogunc::DenseLabels_set_int_label;
*get_label = *modshogunc::DenseLabels_get_label;
*get_int_label = *modshogunc::DenseLabels_get_int_label;
*get_labels = *modshogunc::DenseLabels_get_labels;
*get_labels_copy = *modshogunc::DenseLabels_get_labels_copy;
*set_labels = *modshogunc::DenseLabels_set_labels;
*set_to_one = *modshogunc::DenseLabels_set_to_one;
*zero = *modshogunc::DenseLabels_zero;
*set_to_const = *modshogunc::DenseLabels_set_to_const;
*get_int_labels = *modshogunc::DenseLabels_get_int_labels;
*set_int_labels = *modshogunc::DenseLabels_set_int_labels;
*REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;
*REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;


*obtain_from_generic = *modshogunc::BinaryLabels_obtain_from_generic;
*ensure_valid = *modshogunc::BinaryLabels_ensure_valid;
*scores_to_probabilities = *modshogunc::BinaryLabels_scores_to_probabilities;


*ensure_valid = *modshogunc::DenseLabels_ensure_valid;
*load = *modshogunc::DenseLabels_load;
*save = *modshogunc::DenseLabels_save;
*set_label = *modshogunc::DenseLabels_set_label;
*set_int_label = *modshogunc::DenseLabels_set_int_label;
*get_label = *modshogunc::DenseLabels_get_label;
*get_int_label = *modshogunc::DenseLabels_get_int_label;
*get_labels = *modshogunc::DenseLabels_get_labels;
*get_labels_copy = *modshogunc::DenseLabels_get_labels_copy;
*set_labels = *modshogunc::DenseLabels_set_labels;
*set_to_one = *modshogunc::DenseLabels_set_to_one;
*zero = *modshogunc::DenseLabels_zero;
*set_to_const = *modshogunc::DenseLabels_set_to_const;
*get_int_labels = *modshogunc::DenseLabels_get_int_labels;
*set_int_labels = *modshogunc::DenseLabels_set_int_labels;
*REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;
*REJECTION_LABEL = *modshogunc::DenseLabels_REJECTION_LABEL;
