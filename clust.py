#!/usr/bin/python
import sys
import os
from optparse import OptionParser
import numpy as np
from sklearn.cluster import MeanShift, estimate_bandwidth

parser = OptionParser()


parser.add_option("-o", "--output", dest="output",
                  help="window size")


(options, args) = parser.parse_args()

with open(sys.argv[0]) as my_file:
    X = my_file.readlines()
X = np.array(zip(X,np.zeros(len(X))), dtype=np.int)
bandwidth = estimate_bandwidth(X, quantile=0.1)
ms = MeanShift(bandwidth=bandwidth, bin_seeding=True)
ms.fit(X)
labels = ms.labels_
cluster_centers = ms.cluster_centers_

labels_unique = np.unique(labels)
n_clusters_ = len(labels_unique)

for k in range(n_clusters_):
    my_members = labels == k
    print "ClusterID={0} Length={2} StartPos= {1}".format(k, X[my_members, 0][0], len(X[my_members, 0])+500)
    #print X[my_members, 0][0]