#!/usr/bin/env python
#!/usr/bin/env perl
from tools.load import LoadMatrix
from numpy import where

lm=LoadMatrix()
traindat = lm.load_numbers('../data/fm_train_real.dat')
testdat = lm.load_numbers('../data/fm_test_real.dat')

parameter_list=[[traindat,testdat, 2.0],[traindat,testdat, 3.0]]

def kernel_log_modular (fm_train_real=traindat,fm_test_real=testdat, degree=2.0):
	from shogun.Features import RealFeatures
	from shogun.Kernel import LogKernel
	from shogun.Distance import EuclideanDistance

	feats_train=RealFeatures(fm_train_real)
	feats_test=RealFeatures(fm_test_real)
	
	distance=EuclideanDistance(feats_train, feats_train)

	kernel=LogKernel(feats_train, feats_train, degree, distance)
	km_train=kernel.get_kernel_matrix()

	kernel.init(feats_train, feats_test)
	km_test=kernel.get_kernel_matrix()
	return km_train,km_test,kernel


if __name__=='__main__':
	print('Log')
	kernel_log_modular(*parameter_list[0])
