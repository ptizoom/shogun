classifier_accuracy = 0.0001;
init_random = 42;
accuracy = 1e-07;
classifier_labels = [1, -1, -1, 1, 1, -1, 1, -1, -1, 1, 1];
seqlen = 60;
classifier_tube_epsilon = 0.01;
classifier_epsilon = 1e-05;
data_test = {'ACATAGAGCTTCTTTTAGAATCGTTTAACAACTGCGAATGTATGGGTGGTTCGCAGTTCG', 'ATTGTGGACGGCTAGGGGCAGGAGCGTAATGGTTTGCCAGCTGGCAACAGTTGATTAGCT', 'TATGTCTACATTTTACAAACCAAATTTCCTCCAACCGAATACTAACCGTAGGAGCCACCT', 'ACCGGGTTCGTTTCACGCCTCTCCCTAATAGGCGAGCGAGACAATCTTGACTCAGTTAGA', 'ATACATTGTACCACTACAATCCTACCGTTCTAAACGGTGGAAGCTAACAAGAGCACTCTA', 'TAGGTCAATGTACATGTCGGCTTTGCCTAGGGTCCACCCTTACTAAAGATCGACGTTGTT', 'TAAAGCCTTTCGCAACCTAGGCCCGCAAGTCGGTTGGTCCATTAGCATAAGGAGGAAGCT', 'TTCTCCAAGCAGCGCTTCCCTCAACCTACTTCCCTATGGACCAGTGGACAGTGACGCTTG', 'CCACCGGACAATACATGAGGTATTTGGCTGGCGTATGTCCTCTCGCGCACATTCGCGTTC', 'TCTAGGGATAGACGCAACTTACAAGGAAATTAATTCAAGCAGATCAGCTGCGCTCGACTT', 'AATTACCTAATACCCCGAGTTAACCCGAACGAGCTTCACAGTGTCAGCGCATATTTGGTC', 'CGCCCGTATGTGTATATTCATCTAATGTCGGGGGCCTAGAGGAAAGTAGCCTCCAACAGC', 'GACGTATGGGAAGCTCAGCGGTTGGTCACAGGGAGCGGCAATTGACGTAAGCCAGTTGGA', 'GCGCAACAATCGTTGTCCCGGCAGAGGGTTCGGAACCGTAATACGGAAAGGAGTACGCCG', 'TTGGCGCAGGCTACATGCGCTCCTCAGTCACGAGTCCCATCCGCGATTGTACGGCCACAG', 'AAGGTGCTGAGTCCAACGATTGTACGTTCTATTAGACGGTGCTTATATCACGCAGTCACA', 'TTGCTGTGTGCTGGAGGAAGTGAGACAAACACGCCTAGAAGGTGTAAAAGGATTCAAAAG'};
data_type = '';
kernel_name = 'WeightedDegreeString';
classifier_type = 'kernel';
classifier_sv_sum = 55;
classifier_alpha_sum = -1.11022302463e-16;
feature_type = 'Char';
classifier_C = 0.23;
name = 'GPBTSVM';
classifier_num_threads = 1;
data_train = {'TCCCAAACGCATTTTGTACAAAGTGATGCGCCTCCTGAAAGCATGAGGACTCGCAACAAT', 'TTTATATTGTGCCGAGTATTTTGTTACGAGGAGTCAACTAGACTGACACGACCTTATCCT', 'TTGCTCGCGAATAGAAAATCTGCGGTCCTTTCTCCAGACTAAATGCTTCGTGATGCCAAT', 'ACGATACCAAGTAGGTCCCGTACTTTTCGGAGGATGTACGCGTAGGCTTGGCTGGTCTAC', 'CTTGGGTCCATGCATAGTCAGTGTAGGTATGCATACCTGTCGGTTAGAGCCCGCGCATCC', 'GCACTGGGACTACCCTAGATACGGCCCCACCCGTGAATCAGGGCATCGGGCCGTTAATGT', 'AGGGCAGCCTCTAGTAACAGTCCCGAGGGAGAATGAAACAACGGGATTTTTGAGGGGACT', 'GGCCTGTCGAGCCGTATCCACGACTATCGCAAAAGTTGACCAGGCCTTCTTCCGTTACGG', 'ATGTTGCGAGAGAAAAGGGAAAATACAAGGAACAATGGCCGGGAGCTGGAGACAGACTAG', 'CATACGGGCAGGTTTCCTCATTCACTTAATCGTAGACTCTGCACCACCGGGAAGCATTGA', 'TGTTTGAGGGAATGTTGGTGGACGCACAACTGAAGCTGTCGCTGCCAGAGCGTTTAAGCC'};
feature_class = 'string';
classifier_bias = 0.861567242497;
classifier_labeltype = 'twoclass';
kernel_arg0_degree = 3;
classifier_classified = [0.895331981, 0.891184176, 0.887937168, 0.872642394, 0.845729167, 0.866392779, 0.888408989, 0.853545216, 0.879656972, 0.854844491, 0.848659885, 0.907255828, 0.873215503, 0.92061757, 0.894188172, 0.841314339, 0.806128047];
alphabet = 'DNA';
classifier_linadd_enabled = 'True';
data_class = 'dna';