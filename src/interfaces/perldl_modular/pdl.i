/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This code is inspired by the perl data language package typemaps
 *
 * Written (W) 2012 Christian Montanari
 */


%{

/* Functions to extract array attributes.
 */

  static bool is_array(SV* a) {
    return SVavref(a);
  }

  static bool is_piddle(SV* a) {
    //SVt_PDLV was not declared in this scop
    //is this a piddle?    SvGETMAGIC(a);
    //return((SvROK(a) && SvTYPE(SvRV(a)) == SVt_PDLV) ? true : false);
    const char *objname = "PDL";
    SV *parent = 0;
    HV *bless_stash = 0;
  
    //PDL_COMMENT("Check if you can get a package name for this input value.  ")
    //PDL_COMMENT("It can be either a PDL (SVt_PVMG) or a hash which is a     ")
    //PDL_COMMENT("derived PDL subclass (SVt_PVHV)                            ")
    if (SvROK(a) && ((SvTYPE(SvRV(a)) == SVt_PVMG) || (SvTYPE(SvRV(a)) == SVt_PVHV))) {
      parent = a;
      if (sv_isobject(parent))
	objname = HvNAME((bless_stash = SvSTASH(SvRV(a))));
      //PDL_COMMENT("The package to bless output vars into is taken from the first input var")
    }
    return (parent != 0);
  }


  static int array_type(SV* sv) {
  //is there such think
  //  return (int) PyArray_TYPE(a);
  //maybe we talk about MAGIC
  //but perl does not care any types can be put in a array...
    //pdl *p = SvPDLV(a);
    //SV* a = p->sv;
    //return SvTYPE(SvRV(a));
//Basic/Core/pdlapi.c
    pdl* it = SvPDLV(sv);
    return it->datatype;
  }


  static int array_dimensions(SV* sv) {
    pdl* it = SvPDLV(sv);
    if(it->state & PDL_NOMYDIMS) {
      return -1;//NODIMS?
    }
    return it->ndims;
  }

  //
  static size_t array_size(SV* sv, int i) {
    pdl* x = SvPDLV(sv);
    pdl_make_physvaffine( x );
    //size_t *incs = (PDL_VAFFOK(x) ? x->vafftrans->incs : x->dimincs);
    //return it->dimincs;
    return x->nvals;
  }
  
  static bool array_is_contiguous(SV* sv) {
    //PTZ120930 can we call XS_PDL_iscontig(sv); line 342 "Core.xs"
    pdl*	x = SvPDLV(sv);
    int	RETVAL = true;
    pdl_make_physvaffine( x );
    if PDL_VAFFOK(x) {
	int i, inc=1;
	printf("vaff check...\n");
	for (i=0;i<x->ndims;i++) {
	  if (PDL_REPRINC(x,i) != inc) {
	    RETVAL = false;
	    break;
	  }
	  inc *= x->dims[i];
	}
      }
    //  pdl* it = SvPDLV(sv);
    //  return (it->state & (PDL_ALLOCATED | PDL_HDRCPY));
    //PTZ120927 needs to check... in 
    return RETVAL;
  }






  //form PDL/Basic/Core/Core.xs
#define XS_PDL_setflag(reg,flagval,val) (val?(reg |= flagval):(reg &= ~flagval))


#if 0
XS(XS_PDL_set_inplace)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
    if (items != 2)
       croak_xs_usage(cv,  "self, val");
    {
	pdl *	self = SvPDLV(ST(0));
	int	val = (int)SvIV(ST(1));
#line 453 "Core.xs"
    setflag(self->state,PDL_INPLACE,val);
#line 743 "Core.c"
    }
    XSRETURN_EMPTY;
}

XS(XS_PDL_get_dataref)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
    if (items != 1)
       croak_xs_usage(cv,  "self");
    {
	pdl *	self = SvPDLV(ST(0));
	SV *	RETVAL;
	if(self->state & PDL_DONTTOUCHDATA) {
		croak("Trying to get dataref to magical (mmaped?) pdl");
	}
	pdl_make_physical(self); /* XXX IS THIS MEMLEAK WITHOUT MORTAL? */
	RETVAL = (newRV(self->datasv));
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}
#endif

/* this is horrible - the routines from bad should perhaps be here instead ? */
double pdl_get_badvalue( int datatype ) {
    double retval;
    switch ( datatype ) {
	case PDL_B: retval = PDL->bvals.Byte; break;
	case PDL_S: retval = PDL->bvals.Short; break;
	case PDL_US: retval = PDL->bvals.Ushort; break;
	case PDL_L: retval = PDL->bvals.Long; break;
	case PDL_LL: retval = PDL->bvals.LongLong; break;
	case PDL_F: retval = PDL->bvals.Float; break;
	case PDL_D: retval = PDL->bvals.Double; break;

      default:
	croak("Unknown type sent to pdl_get_badvalue\n");
    }
    return retval;
} /* pdl_get_badvalue() */


double pdl_get_pdl_badvalue( pdl *it ) {
    double retval;
    int datatype;


    datatype = it->datatype;
    retval = pdl_get_badvalue( datatype );
    return retval;
} /* pdl_get_pdl_badvalue() */


//line 23 pdlcore.c
 static SV* getref_pdl(pdl* it) {
   SV* newref;
   if(!it->sv) {
     SV *ref;
     HV *stash = gv_stashpv("PDL",TRUE);
     SV *psv = newSViv(PTR2IV(it));
     it->sv = psv;
     newref =  newRV_noinc((SV*) it->sv);
     (void) sv_bless(newref,stash);
   } else {
     newref = newRV_inc((SV*)it->sv);
     SvAMAGIC_on(newref);
   }
   return newref;
 }

void pdl_make_scratch_hash(pdl *ret,double data, int datatype) {
    STRLEN n_a;
    HV *hash;
    SV *dat; PDL_Long fake[1];

    /* Compress to smallest available type. This may have strange
       results sometimes :( */
    ret->datatype = datatype;
    ret->data = pdl_malloc(pdl_howbig(ret->datatype)); /* Wasteful */
    //PTZ121004, yo, maybe need data PDL_B?
    dat = newSVpv((char *)ret->data, pdl_howbig(ret->datatype));

    ret->data = SvPV(dat, n_a);
    ret->datasv = dat;

    /* This is an important point: it makes this whole piddle mortal
     * so destruction will happen at the right time.
     * If there are dangling references, pdlapi.c knows not to actually
     * destroy the C struct. */
    sv_2mortal(getref_pdl(ret));
    
    pdl_setdims(ret, fake, 0); /* However, there are 0 dims in scalar */
    ret->nvals = 1;
    
    /* NULLs should be ok because no dimensions. */
    pdl_set(ret->data, ret->datatype, NULL, NULL, NULL, 0, 0, data);
}

#if 0

//include in a pdl_swig.i
SV* pdl_core_listref_c(pdl* x)
{
   PDL_Long * inds;
   PDL_Long * incs;
   int offs;
   void *data;
   int ind;
   int lind;
   int stop = 0;
   AV *av;

   SV *sv;
   double pdl_val, pdl_badval;
   int badflag = (x->state & PDL_BADVAL) > 0;

   if ( badflag ) {
      pdl_badval = pdl_get_pdl_badvalue( x );
   }
   pdl_make_physvaffine( x );
   inds = (PDL_Long*) pdl_malloc( sizeof( PDL_Long ) * x->ndims); /* GCC -> on stack :( */
   data = PDL_REPRP(x);
   incs = (PDL_VAFFOK(x) ? x->vafftrans->incs : x->dimincs);
   offs = PDL_REPROFFS(x);
   av = newAV();
   av_extend(av,x->nvals);
   lind=0;
   for(ind=0; ind < x->ndims; ind++) inds[ind] = 0;
   while(!stop) {
      pdl_val = pdl_at(data, x->datatype, inds, x->dims, incs, offs, x->ndims );
      if ( badflag && pdl_val == pdl_badval ) {
	 sv = newSVpvn( "BAD", 3 );
      } else {
	//not sure... 
	 sv = newSVnv( pdl_val );
      }
      av_store(av, lind, sv);

      lind++;
      stop = 1;
      for(ind = 0; ind < x->ndims; ind++) {
	 if(++(inds[ind]) >= x->dims[ind]) {
       	    inds[ind] = 0;
         } else {
       	    stop = 0; break;
         }
      }
   }
   return  newRV_noinc((SV *)av);
}
#endif


//I made it up
SV* pdl_core_listref_pv_string(pdl * x)
{
   PDL_Long * inds;
   PDL_Long * incs;
   size_t offs;
   void *data;
   SV** xx;

   int ind; int lind; int i;
   int stop = 0;
   AV *av;
   SV *sv;
   double pdl_badval;
   int badflag = (x->state & PDL_BADVAL) > 0;
   if ( badflag ) {
      pdl_badval = pdl_get_pdl_badvalue( x );
   }
   pdl_make_physvaffine( x );
   inds = (PDL_Long *) pdl_malloc(sizeof(PDL_Long) * x->ndims); /* GCC -> on stack :( */
   data = PDL_REPRP(x);
   xx = (SV**) data;

   incs = (PDL_VAFFOK(x) ? x->vafftrans->incs : x->dimincs);
   offs = PDL_REPROFFS(x);
   av = newAV();
   av_extend(av, x->nvals);
   lind = 0;
   for(ind = 0; ind < x->ndims; ind++) inds[ind] = 0;
   while(!stop) {
     //SV* pdl_val = cast<SV*>(pdl_at(data, x->datatype, inds, x->dims, incs, offs, x->ndims));
     //cast refused get index and mem
     i = pdl_get_offset(inds, x->dims, incs, offs, x->ndims);
     sv = newSVrv(xx[i], NULL);
     av_store(av, lind, sv);
     lind++;
     stop = 1;
     for(ind = 0; ind < x->ndims; ind++) {
       if(++(inds[ind]) >= x->dims[ind]) {
	 inds[ind] = 0;
       } else {
	 stop = 0;
	 break;
       }
     }
   }
   return  newRV_noinc((SV *)av);
}

#if 0
//in Char.pm
sub string {		
  my $self   = shift;
  my $level  = shift || 0;

  my $sep = $PDL::use_commas ? "," : " ";

  if ($self->dims == 1) {
    my $str = ${$self->get_dataref}; # get copy of string
    $str =~ s/\00+$//g; # get rid of any null padding
    return "\'". $str. "\'". $sep;
  } else {
    my @dims = reverse $self->dims;
    my $ret = '';
    $ret .= (" " x $level) . '[' . ((@dims == 2) ? ' ' : "\n");
    for (my $i=0;$i<$dims[0];$i++) {
      my $slicestr = ":," x (scalar(@dims)-1) . "($i)";
      my $substr = $self->slice($slicestr);
      $ret .= $substr->string($level+1);
    }
    $ret .= (" " x $level) . ']' . $sep . "\n";
    return $ret;
  }
				
}
#endif

 %}

#if 0
 //typemaps from PDL itself in pdl.i
TYPEMAP
pdl*	T_PDL
pdl *	T_PDL
Logical	T_IV
float	T_NV
INPUT
T_PDL
	$var = PDL->SvPDLV($arg)
OUTPUT
T_PDL
	PDL->SetSV_PDL($arg,$var);
/* Two dimensional output arrays */
%define TYPEMAP_OUT_SGMATRIX_(type,typecode)
%typemap(out) shogun::SGMatrix<type>
{
    if (!matrix_to_pdl($result, $1, typecode))
        SWIG_fail;
}
%enddef
#endif


%define TYPEMAP_PDL
%typemap(out) pdl*
{
    PDL->SetSV_PDL($result, $1);
}

%typemap(in) pdl*
{
    $result = PDL->SvPDLV($1)
}
%enddef


