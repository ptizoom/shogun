init_random = 42;
accuracy = 1e-15;
data_type = '';
km_train = [0.59049, 2.38877906e-16, 3.15875538e-18, 6.797079e-17, 4.94257909e-10, 9.10318752e-20, 3.65919385e-21, 6.91778892e-17, 7.0135141e-16, 2.78759096e-20, 3.37385869e-13;2.38877906e-16, 0.59049, 7.73230196e-17, 9.11168912e-18, 3.57689329e-15, 3.90824111e-19, 4.63237297e-16, 1.00316146e-19, 2.32790643e-21, 8.66110334e-21, 7.85429253e-16;3.15875538e-18, 7.73230196e-17, 0.59049, 1.15763037e-15, 2.62228785e-19, 1.76607404e-16, 6.75298879e-19, 7.06406269e-15, 1.07280578e-14, 3.31652541e-17, 6.34308639e-21;6.797079e-17, 9.11168912e-18, 1.15763037e-15, 0.59049, 1.57584591e-17, 1.42189055e-13, 1.12188027e-18, 9.65885502e-23, 3.32029433e-15, 1.48370941e-18, 5.18938864e-18;4.94257909e-10, 3.57689329e-15, 2.62228785e-19, 1.57584591e-17, 0.59049, 6.47276841e-17, 1.77687291e-13, 5.7477377e-19, 6.78080064e-18, 8.27567453e-17, 2.08377554e-12;9.10318752e-20, 3.90824111e-19, 1.76607404e-16, 1.42189055e-13, 6.47276841e-17, 0.59049, 4.65640989e-19, 9.64840014e-20, 7.1728171e-18, 6.22053271e-14, 3.61016881e-21;3.65919385e-21, 4.63237297e-16, 6.75298879e-19, 1.12188027e-18, 1.77687291e-13, 4.65640989e-19, 0.59049, 1.77635149e-14, 3.03570576e-14, 3.98469902e-19, 5.04000716e-14;6.91778892e-17, 1.00316146e-19, 7.06406269e-15, 9.65885502e-23, 5.7477377e-19, 9.64840014e-20, 1.77635149e-14, 0.59049, 4.62646702e-16, 1.51646825e-14, 1.63287819e-15;7.0135141e-16, 2.32790643e-21, 1.07280578e-14, 3.32029433e-15, 6.78080064e-18, 7.1728171e-18, 3.03570576e-14, 4.62646702e-16, 0.59049, 2.54549575e-15, 9.1482219e-14;2.78759096e-20, 8.66110334e-21, 3.31652541e-17, 1.48370941e-18, 8.27567453e-17, 6.22053271e-14, 3.98469902e-19, 1.51646825e-14, 2.54549575e-15, 0.59049, 1.93029526e-19;3.37385869e-13, 7.85429253e-16, 6.34308639e-21, 5.18938864e-18, 2.08377554e-12, 3.61016881e-21, 5.04000716e-14, 1.63287819e-15, 9.1482219e-14, 1.93029526e-19, 0.59049];
kernel_arg0_length = 5;
seqlen = 60;
data_test = {'CTATCAAAAGATGCCGCATCAGGCTGGCTCGCGAATCCGGAATGCTGAACTAATAGAGCA', 'GGGGGGGGGGAACTTGCATTATCCGGTACCCGCCCGGGACAACAGTATAGGTACACTTGG', 'TCATCAAGGCGTTGTTCCCACCAACGTGCCAATCTGAGCCGTTTAAACCGGTTATCCTAT', 'GTTGAACATCTGACCCGAGCTTAAGTCCACCCGCACTCTGCAGGGTGATGCGGACCCAAA', 'CTACCTAAATGACAATCGCGCCGAGTATACGGATTATGTATATGCATGCCTCATCCATAG', 'TATCGCGCATATACTATCCGCCGCATTCGGGCTAGTGTCCTCGATGCCGAGGATCCCGTA', 'CATCGCTGTAGTGATCACGTCCGCTTCATAAAATGTACTTGATCGGGGGACGCCACTCGG', 'ATCTAACCTAGATTCAGAAGTTGGTGCTAAGACCGTACAGGCAGGACCTTGTGTACGGAC', 'CCCGTGTTCCATAGCTCTCCGTGTTTCCATTGCATATCCTACTGTTAACCCTAGAACTAG', 'GAGTGAGGAAAACCCTGTGACTAACCCACGCGGGAGACGACAACTCCGGTTTTAGTGTAC', 'TCGAGTCAATGAATTACTGTCGGTCACTCCGAACGGTTCGAAACACGCGCAAAAGTCCTA', 'AGGGGACATTCACACGTCAAAATATGGCGCCCTCCCAAAGCTGAGGGGGAGCGATCGTTG', 'ATGGTAAGTCGCGTAGTCCATCCCCGTCGGCATGGATGTTTTATATCGATACTGACAGTG', 'ACTAGCTTCGGCCGATAACACCGTTATCCCCTCGATTCGGGGGAGCCTACAACTCGAGTC', 'TTGCGTACCCTCCGAAGCCAGTTAGTCTTACAATTAGGCGTAAACCCGTCCTTACTACCA', 'ACTTTAATGCACCATATTCGGACGGGCCCCGTGGGGGATACAATCTCCCGTCCTACCACA', 'TGTGGGTACGTTGAATCATAGGACAGCATCCAATCCTGCTGAGTCGTGAAGCTCCGGCAG'};
feature_type = 'Char';
name = 'SimpleLocalityImprovedString';
data_train = {'TTGCCCCAGCGCCATGAGTTGAGTGTCATGACTAACTTGGCATACGAGGGACGTATGTAC', 'ACTAGAGAACTAAATGGGAGACGGAATGAATTTCCAGAAAGCGTGCTCATAGCGGAGTCC', 'CTGTAAAAGTCTATATATACCCGTGGAGCTCGACCCCATATAAGGCGCGGCTGCTTGATA', 'ACGTGTAAGTGAAACATGGAAGTGTTAAGCCCCTACGGGTTGACGTTGGAAAACCGGGCC', 'TATCGAACGCGCCTTGAATATCTCCGTTGTGTTCGGGTCACACTGTATGAGTAGTAGCCG', 'ATACGCCTTTGTTCCACTGGAACTCTAGGTAAATAAGGTTGTGCTGCGCAGTGATACCAC', 'GTTTCGTCTCCGGGCGTTAAGCACTTCCGAGACCGGCACGAAGTCCTTCTGTCTTCTCAC', 'TGGGACGTACAACGAATTCGCTGTAGGCCGGAGAAGCCCGCTCGCGGCCCAAGTCCAATG', 'ACTACGGCTAGAGTCGTAGTGAACAGAACCGGAAACAGATCCTGGTCTCTCCGAACGTGT', 'GAAGCACGCTGGTCGTGTCGATTTGAATCCGCGCGTACCTCCGCTTGGAGGCATCGACTC', 'GACTGTTTTATAAACGCACCTCACCGCCCCTATGATTGCGCATTATGACCTTAGTTAGTC'};
feature_class = 'string';
km_test = [1.96053147e-13, 7.00537459e-16, 2.50383602e-19, 2.38677012e-12, 2.10264198e-16, 1.64803985e-14, 6.94761445e-12, 1.01649933e-19, 1.03034933e-14, 3.77171854e-17, 1.30205118e-16, 2.00684581e-14, 8.40390617e-19, 2.27861108e-16, 1.37752507e-14, 1.82573317e-13, 5.27193513e-17;1.01744199e-22, 2.94969163e-17, 4.16719409e-18, 2.6558786e-17, 6.66245066e-17, 6.22802389e-15, 1.95841083e-22, 1.79588675e-14, 5.53662922e-22, 1.61479704e-18, 1.65541277e-16, 4.56144574e-14, 3.83330824e-19, 5.63572689e-15, 3.75026899e-22, 8.29524261e-18, 4.67319732e-17;5.67344492e-18, 5.45699737e-13, 1.62065978e-15, 1.86153776e-14, 9.62059666e-13, 1.78825959e-20, 1.08080468e-16, 6.62855475e-18, 1.2765282e-15, 2.87941005e-17, 2.67015663e-13, 1.60391726e-14, 6.04887268e-21, 9.81878596e-13, 3.75073083e-18, 1.90482654e-14, 6.12803963e-17;2.58898502e-18, 2.78254559e-15, 5.4959806e-22, 4.21025999e-14, 4.24147059e-13, 1.51474307e-18, 1.05978786e-15, 2.6987595e-19, 1.29186287e-23, 5.22828733e-18, 9.60237496e-13, 7.22848698e-12, 1.14674478e-15, 7.22812189e-16, 2.59229813e-16, 5.3524326e-20, 5.80566896e-14;8.64260336e-19, 1.83503581e-10, 8.59931434e-14, 1.5448728e-18, 1.51390277e-23, 4.00080867e-12, 1.15013787e-19, 4.93815502e-17, 2.69076275e-18, 2.5697193e-18, 6.12359341e-12, 6.80563035e-17, 3.7010908e-09, 1.91696582e-15, 2.3899281e-15, 8.84252426e-11, 2.03322983e-16;3.46853394e-18, 8.6175443e-23, 4.06005614e-15, 1.70902913e-20, 1.72410959e-14, 2.65676894e-14, 1.40415674e-12, 5.892624e-16, 3.00380255e-18, 2.49565758e-16, 1.06504592e-14, 8.40424973e-14, 4.4950201e-14, 9.76126251e-21, 1.00052743e-11, 6.3011101e-16, 9.73969854e-14;1.48483686e-15, 5.89944093e-18, 1.41200154e-16, 2.41658322e-16, 9.07670597e-20, 1.00475206e-13, 8.58433249e-12, 1.42386888e-09, 5.98709033e-14, 1.43792886e-19, 4.59488772e-10, 3.282916e-14, 1.12186864e-14, 3.05724832e-18, 5.46267659e-15, 2.04536709e-15, 1.02392099e-12;5.91297977e-10, 1.84686763e-19, 3.86592522e-19, 1.70929253e-15, 3.70342164e-14, 1.58329929e-11, 1.05782939e-25, 8.65623725e-17, 2.53406397e-14, 2.85856461e-13, 4.75522135e-14, 5.03294157e-16, 2.09211544e-17, 1.44287228e-13, 1.75000778e-14, 1.95209834e-11, 5.40877074e-22;1.54913287e-15, 3.43865012e-12, 4.10166099e-18, 1.50290336e-16, 1.21003614e-13, 4.62242709e-22, 1.37110764e-17, 1.89648429e-11, 1.97984812e-14, 7.44533737e-17, 2.24680802e-16, 9.61043745e-15, 1.43584271e-14, 7.73388002e-21, 2.59269074e-25, 9.55922475e-16, 1.13300147e-10;1.07979181e-12, 3.46588767e-16, 5.42825992e-17, 2.0712568e-14, 1.2159048e-13, 1.99871695e-14, 7.52312059e-14, 2.25109202e-11, 1.55477833e-13, 6.19920401e-15, 1.7441619e-10, 1.55138037e-16, 2.26303117e-19, 1.7446644e-16, 8.1684197e-16, 1.77337193e-13, 6.38146773e-16;2.52930111e-11, 1.06464576e-16, 4.41835733e-11, 2.53799644e-12, 3.15514031e-16, 5.70716254e-20, 2.05228501e-18, 4.96578879e-18, 2.28207088e-12, 1.43759129e-16, 1.9700795e-13, 5.46860478e-16, 1.48688157e-10, 1.13991392e-11, 4.95705122e-17, 4.24384799e-12, 5.72752189e-13];
kernel_arg1_inner_degree = 7;
alphabet = 'DNA';
kernel_arg2_outer_degree = 5;
data_class = 'dna';