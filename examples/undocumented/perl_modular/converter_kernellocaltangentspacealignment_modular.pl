#!/usr/bin/env python
#!/usr/bin/env perl
from tools.load import LoadMatrix

lm=LoadMatrix()
data = lm.load_numbers('../data/fm_train_real.dat')

parameter_list = [[data,60],[data,70]]

def converter_kernellocaltangentspacealignment_modular (data,k):
	from shogun.Features import RealFeatures
	from shogun.Converter import KernelLocalTangentSpaceAlignment
	
	features = RealFeatures(data)
		
	converter = KernelLocalTangentSpaceAlignment()
	converter.set_target_dim(1)
	converter.set_k(k)
	#converter.apply(features)

	return features


if __name__=='__main__':
	print('KernelLocalTangentSpaceAlignment')
	converter_kernellocaltangentspacealignment_modular(*parameter_list[0])
