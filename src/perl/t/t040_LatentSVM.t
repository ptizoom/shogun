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

=pod

#include <gmock/gmock.h>
#include <shogun/latent/LatentModel.h>
#include "MockLatentModel.h"
#include <shogun/latent/LatentSVM.h>
#using namespace shogun;
#using ::testing::Return;

=cut

package modshogun::MockLatentModel {
    our @ISA = qw(modshogun::LatentModel);

  #public:
    # sub MOCK_CONST_METHOD0(get_num_vectors, int32_t());
    # sub MOCK_CONST_METHOD0(get_dim, int32_t());
#MOCK_METHOD0(get_psi_feature_vectors, CDotFeatures*());
    # sub MOCK_METHOD2(infer_latent_variable, CData*(const SGVector<float64_t>& w, index_t idx));
    # sub MOCK_METHOD1(argmax_h, void(const SGVector<float64_t>& w));
    # sub MOCK_CONST_METHOD0(get_name, const char*());
};

#using ::testing::AtMost;
#using ::testing::_;

package main;

sub TEST_LatentModel_infer
{
#CLatentModel (CLatentFeatures *feats, CLatentLabels *labels)
    my ($model, $dim, $sample, $a, $data, $w) = @_;
    &TEST_LatentModel_dim(@_);
    #&EXPECT_CALL($model, infer_latent_variable(_,_)).Times(AtMost($samples)).WillRepeatedly(Return($data));
    for($i = 0; $i < $samples; $i++) {
	my $data_infer = $model->infer_latent_variable($w, $i);
	&is($data_infer, $data->get_element($i));
    }    
}
sub TEST_LatentModel_dim
{
#CLatentModel (CLatentFeatures *feats, CLatentLabels *labels)
    my ($model, $dim, $sample, $a, $data, $w) = @_;
#TypeError in method 'LatentModel_get_dim', argument 1 of type 'shogun::CLatentModel const *'
    #&ON_CALL($model, get_dim()).WillByDefault(Return($dim));
    &is($model->get_dim(), $dim);
    #&ON_CALL($model, get_num_vectors()).WillByDefault(Return($samples));
    &is($model->get_num_vectors(), $samples);  
}

sub TEST_LatentModel_argmax_h
{
    my ($model, $dim, $sample, $a, $data, $w) = @_;
    &TEST_LatentModel_infer(@_);
    &ok($model->argmax_h($a));    
    &SG_UNREF($data);
    &SG_UNREF($model);
}

sub TEST_LatentSVM_ctor
{
#	using ::testing::AtLeast;
#	using ::testing::Exactly;
	# MockCLatentModel* model = new MockCLatentModel();
	# int32_t dim = 10, samples = 20;
	# &ON_CALL(*model, get_dim()).WillByDefault(Return(dim));
	# &ON_CALL(*model, get_num_vectors()).WillByDefault(Return(samples));
	# &EXPECT_CALL(*model, get_dim()).Times(Exactly(1));
	# &EXPECT_CALL(*model, get_num_vectors()).Times(Exactly(1));
#	CLatentSVM* 
    my ($model, $dim, $sample, $a, $data, $w) = @_;
    &ok( $lsvm = modshogun::LatentSVM::new());
    &ok( $lsvm = new modshogun::LatentSVM($model, 10));
    &TEST_LatentModel_dim(@_);
    &SG_UNREF($lsvm);
}
sub TEST_LatentSVM_apply
{
	#using ::testing::AtMost;
	#using ::testing::_;
#$model = new MockLatentModel();
#$dim = 10; $samples = 20;
#$a =  modshogun::RealVector->new($dim);
#$data = new modshogun::Data();

    my ($model, $dim, $sample, $a, $data) = @_;

#CLatentFeatures* 
 
   &ok($f = new modshogun::ObjecttFeatures($samples));

#&ON_CALL(*model, get_dim()).WillByDefault(Return(dim));
#&ON_CALL(*model, get_num_vectors()).WillByDefault(Return(samples));
#&EXPECT_CALL(*model, get_num_vectors()).Times(2);
#&EXPECT_CALL(*model, infer_latent_variable(_,_)).Times(samples).WillRepeatedly(Return(data));
#	SGMatrix<float64_t> feats(dim, samples);
#	CDenseFeatures<float64_t>* dense_feats = new CDenseFeatures<float64_t>(feats);
#	EXPECT_CALL(*model, get_psi_feature_vectors()).Times(1).WillOnce(Return(dense_feats));

 
    &ok($lsvm = modshogun::LatentSVM->new($model, 10));
    &TEST_LatentModel_dim(@_);
    &TEST_LatentModel_infer(@_);

    ok($lsvm->apply($f));

    #&EXPECT_CALL(*model, get_psi_feature_vector(_))	.Times(samples)	.WillRepeatedly(Return(a));
    for(my $i = 0; $i < $samples; $i++) {
	my $va = $model->get_psi_feature_vector($i);
	&is($va, $a->get_element($i));
    }
    &SG_UNREF($lsvm);
    &SG_UNREF($dense_feats);
}

my ($model, $dim, $sample, $a, $data);

$samples = 20;
$dim = 10;
$dim = $HOG_SIZE = 1488;

sub TEST_LatentModel_new {
    &ok($model = bless({}, modshogun::LatentModel));
    &ok($model = bless({}, modshogun::LatentModel));


    &ok($a = modshogun::RealVector->new($dim));
    &ok($data = new modshogun::Data());
    return ($model, $dim, $sample, $a, $data);
}
sub SG_REF {
    &ok(ref($_[0]) =~ /modshogun::/);
}
sub SG_SDONE {
    &ok(!$@);
}
sub SG_SPRINT {
    diag(@_);
}

sub read_dataset
#(char* fname, CLatentFeatures*& feats, CLatentLabels*& labels)
{
#	FILE* 
    $fd = IO::File->open($fname, "r");
#	char line[MAX_LINE_LENGTH];
#	char *pchar, *last_pchar;
#	int num_examples,label,height,width;
#	char* 
    $path = dirname($fname);
    #if ($fd == NULL) {
#	&SG_SERROR("Cannot open input file %s!\n", $fname);
#    }
    #fgets($line, $MAX_LINE_LENGTH, $fd);
    #$num_examples = atoi($line);
    $num_examples = 20;

    &ok( $labels = new modshogun::LatentLabels($num_examples));
    &SG_REF($labels);

    #CBinaryLabels* 
    &ok($ys = new modshogun::BinaryLabels($num_examples));

    &ok($feats = new modshogun::LatentFeatures($num_examples));
    &SG_REF($feats);

    eval modshogun::Math::init_random();
    &ok(!$@);

    #for (int i = 0; (!feof(fd)) && (i < num_examples); ++i)
    for (my $i = 0; $i < $num_examples; ++$i)
    {
#		fgets(line, MAX_LINE_LENGTH, fd);

#		pchar = line;
#		while ((*pchar)!=' ') pchar++;
#		*pchar = '\0';
#		pchar++;

#		/* label: {-1, 1} */
#		last_pchar = pchar;
#		while ((*pchar)!=' ') pchar++;
#		*pchar = '\0';
#		label = (atoi(last_pchar) % 2 == 0) ? 1 : -1;
#		pchar++;
	$label = (ran(2) % 2 == 0) ? 1 : -1;

	&ok($ys->set_label($i, $label) == true);
	#&SG_SERROR("Couldn't set label for element %d\n", i);
#		last_pchar = pchar;
#		while ((*pchar)!=' ') pchar++;
#		*pchar = '\0';
#		width = atoi(last_pchar);
#		pchar++;
	$width = ran($HOG_SIZE);
#		last_pchar = pchar;
#		while ((*pchar)!='\n') pchar++;
#		*pchar = '\0';
#		height = atoi(last_pchar);
	$height = ran($HOG_SIZE);

		#/* create latent label */
	$x = modshogun::Math::random(0, $width  - 1);
	$y = modshogun::Math::random(0, $height - 1);

#		CBoundingBox* 
	$bb = new modshogun::CBoundingBox($x,$y);
	$labels->add_latent_label($bb);

	#&SG_SPROGRESS($i, 0, $num_examples);
	#CHOGFeatures* 
	$hog = new modshogun::CHOGFeatures($width, $height);
#		$hog->hog = &SG_CALLOC(float64_t**, $hog->width);

	for (my $j = 0; $j < $width; ++$j)
	{
	    #$hog->hog[$j] = &SG_CALLOC(float64_t*, $hog->height);
	    for (my $k = 0; $k < $height; ++$k)
	    {
		#char filename[MAX_LINE_LENGTH];
		#hog->hog[j][k] = SG_CALLOC(float64_t, HOG_SIZE);
		
		#sprintf($filename,"%s/%s.%03d.%03d.txt",$path,$line,$j,$k);
		#FILE* $f = IO::File->open(filename, "r");
		#if (f == NULL)
		#    &SG_SERROR("Could not open file: %s\n", filename);
		for (my $l = 0; $l < $HOG_SIZE; ++$l) {
		    #fscanf(f,"%lf",$hog->hog[$j][$k][$l]);
		    # well...stuff a double in this dim 3 array!
		}
		#close($f);
	    }
	}
	$feats->add_sample($hog);
    }
    close($fd);

    $labels->set_labels($ys);
    &SG_SDONE();
}


&TEST_LatentSVM_ctor(&TEST_LatentModel_new());

&TEST_LatentSVM_apply(&TEST_LatentModel_new());

&TEST_LatentModel_argmax_h(&TEST_LatentModel_new());


#main classifier_latent_svm

	&modshogun::init_shogun_with_defaults();
	$sg_io->set_loglevel($MSG_DEBUG);

	#/* check whether the train/test args are given */
	if (argc < 3)
	{
		&SG_SERROR("not enough arguements given\n");
	}
	#CLatentFeatures* train_feats = NULL;
	#CLatentLabels* train_labels = NULL;
	#/* read train data set */
	&read_dataset(argv[1], $train_feats, $train_labels);

	#/* train the classifier */
	#float64_t 
	$C = 10.0;

	#CObjectDetector* 
    &ok($od = new modshogun::ObjectDetector($train_feats, $train_labels));
	CLatentSVM llm($od, $C);

	&ok($llm->train());

	#//  CLatentFeatures* test_feats = NULL;
	#//  CLatentLabels* test_labels = NULL;
	#//  read_dataset(argv[2], test_feats, test_labels);

	&SG_SPRINT("Testing with the test set\n");
	$llm->apply(train_feats);


	&modshogun::exit_shogun();


END {
    done_testing(71);
}



__END__
*get_num_vectors = *modshogunc::LatentModel_get_num_vectors;
*get_dim = *modshogunc::LatentModel_get_dim;
*set_labels = *modshogunc::LatentModel_set_labels;
*get_labels = *modshogunc::LatentModel_get_labels;
*set_features = *modshogunc::LatentModel_set_features;
*get_features = *modshogunc::LatentModel_get_features;
*get_psi_feature_vectors = *modshogunc::LatentModel_get_psi_feature_vectors;
*infer_latent_variable = *modshogunc::LatentModel_infer_latent_variable;
*argmax_h = *modshogunc::LatentModel_argmax_h;
*cache_psi_features = *modshogunc::LatentModel_cache_psi_features;
*get_cached_psi_features = *modshogunc::LatentModel_get_cached_psi_features;
*get_caching = *modshogunc::LatentModel_get_caching;
*set_caching = *modshogunc::LatentModel_set_caching;
