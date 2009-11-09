/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 1999-2008 Gunnar Raetsch
 * Copyright (C) 1999-2008 Fraunhofer Institute FIRST and Max-Planck-Society
 */

#include "lib/common.h"
#include "lib/Mathematics.h"
#include "kernel/AUCKernel.h"
#include "features/WordFeatures.h"
#include "lib/io.h"

CAUCKernel::CAUCKernel(int32_t size, CKernel* s)
: CSimpleKernel<uint16_t>(size), subkernel(s)
{
}

CAUCKernel::CAUCKernel(CWordFeatures* l, CWordFeatures* r, CKernel* s)
: CSimpleKernel<uint16_t>(10), subkernel(s)
{
	init(l, r);
}

CAUCKernel::~CAUCKernel()
{
	cleanup();
}

bool CAUCKernel::init(CFeatures* l, CFeatures* r)
{
	CSimpleKernel<uint16_t>::init(l, r);
	init_normalizer();
	return true;
}

bool CAUCKernel::load_init(FILE* src)
{
	return false;
}

bool CAUCKernel::save_init(FILE* dest)
{
	return false;
}

float64_t CAUCKernel::compute(int32_t idx_a, int32_t idx_b)
{
  int32_t alen, blen;
  bool afree, bfree;

  uint16_t* avec=((CWordFeatures*) lhs)->get_feature_vector(idx_a, alen, afree);
  uint16_t* bvec=((CWordFeatures*) rhs)->get_feature_vector(idx_b, blen, bfree);

  ASSERT(alen==2);
  ASSERT(blen==2);

  ASSERT(subkernel && subkernel->has_features());

  float64_t k11,k12,k21,k22;
  int32_t idx_a1=avec[0], idx_a2=avec[1], idx_b1=bvec[0], idx_b2=bvec[1];

  k11 = subkernel->kernel(idx_a1,idx_b1);
  k12 = subkernel->kernel(idx_a1,idx_b2);
  k21 = subkernel->kernel(idx_a2,idx_b1);
  k22 = subkernel->kernel(idx_a2,idx_b2);

  float64_t result = k11+k22-k21-k12;

  ((CWordFeatures*) lhs)->free_feature_vector(avec, idx_a, afree);
  ((CWordFeatures*) rhs)->free_feature_vector(bvec, idx_b, bfree);

  return result;
}