KlustaKwik version 1.7
----------------------

KlustaKwik is a program for unsupervised classification of multidimensional
continuous data. It arose from a specific need - automatic sorting of neuronal
action potential waveforms (see KD Harris et al, Journal of Neurophysiology
84:401-414,2000), but works for any type of data.  We needed a program that
would:

1) Fit a mixture of Gaussians with unconstrained covariance matrices
2) Automatically choose the number of mixture components
3) Be robust against noise
4) Reduce the problem of local minima
5) Run fast on large data sets (up to 100000 points, 48 dimensions)

Speed in particular was essential.  KlustaKwik is based on the CEM algorithm of
Celeux and Govaert (which is faster than the standard EM algorithm), and also
uses several tricks to improve execution speed while maintaining good
performance.  On our data, it runs at least 10 times faster than Autoclass.


Cluster splitting and deletion
------------------------------

The main improvement in version 1.6 is the ability to specify Bayesian information content or AIC information content as the penalty for a larger number of clusters or a mixture of these two.  KlustaKwik allows for a variable number of clusters to be fit. The program periodically checks if splitting any cluster would improve the overall score.  It also checks to see if deleting any cluster and reallocating its points would improve overall score.  The splitting and deletion features allow the program to often escape from local minima, reducing sensitivity to the initial number of clusters, and reducing the total number of starts needed for a data set.


Binaries
--------
The current distribution contains pre-compiled binaries for Linux Pentium, Mac OS X, and Windows. These are located in separate subdirectories.


Compilation
-----------

The program is written in C++.  To compile under unix, extract all files to a
single directory and type make.  That should be all you need to do.  If it
doesn't work, change the makefile to replace g++ with the name of your C++
compiler. A Metrowerks Codewarrior project is included for compilation on 
the Mac or Windows.

To check it compiled properly type "KlustaKwik test 1 -MinClusters 2" to run
the program on the supplied test file. The outputs, test.clu.1 and test.model.1,
should match the supplied test_res.clu.1 and test_res.model.1 files (excepting
line endings, which may vary by platform).


Usage
-----

The program takes a "feature file" as input, and produces two output files, the
"cluster file", and a log file.  The file formats and conventions may seem
slightly strange.  This is for historical reasons.  If you want to change the
code, go ahead, this is open source software.

The feature file should have a name like FILE.fet.n, where FILE is any string,
and n is a number.  The program is invoked by running "KlustaKwik FILE n", and
will create a cluster file FILE.clu.n and a log file FILE.klg.n.  The number n
doesn't serve any purpose other than to let you have several files with the
same file base.

The first line of the feature file should be the number of input dimensions. 
The following lines are the data, with each line being one data instance,
consisting of a list of numbers separated by spaces.  An example file test.fet.1 is provided. Please note that the features can be the sample values of a putative waveform event.

The first line of the cluster file will be the number of classes that the
program chose.  The following lines will be the classes asigned to the data
points.  Class 1 is a "noise cluster" modelled by a uniform distribution, which
should contain outliers, if there are any.


Parameters
----------

It is possible to pass the program parameters by running "KlustaKwik FILE n
params" etc.  All parameters have default values. Here are the parameters you can use:

-ChangedThresh f (default 0.05)
All log-likelihoods are recalculated if the fraction of instances changing class exeeds f (see DistThresh)

-Debug n         (default 0)
Miscellaneous debugging information (not recommended)

-DistDump        (default 0)
Outputs a ridiculous amount of debugging information (definately not recommended).

-DistThresh d    (default 6.907755 = ln(1000) )
Time-saving paramter.  If a point has log likelihood more than d worse for a
given class than for the best class, the log likelihood for that class is not
recalculated.  This saves an awful lot of time.

-fSaveModel n    (default 1)
If n is non-zero, save final model to .model file.

-FullStepEvery n (default 10)
All log-likelihoods are recalculated every n steps (see DistThresh)

-help
Prints a short message and then the default parameter values.

-Log n           (default 1)
Produces .klg log file if non-zero. (to switch off use -Log 0)

-MaxClusters n   (default 10)
The random initial assignment will have no more than n clusters. 

-MaxIter n       (default 500)
Don't try more than n iterations from any starting point.

-MaxPossibleClusters n   (default 100)
Cluster splitting can produce no more than n clusters.

-MinClusters n   (default 2)
The random intial assignment will have no less than n clusters.  The final
number may be different, since clusters can be split or deleted during the
course of the algorithm.

-PenaltyMix d    (default 0.0)
Amount of BIC to use a penalty for more clusters. Default of 0 sets to use all AIC. Use 1.0 to use all BIC (this generally produces fewer clusters).

-nStarts n       (default 1)
The algorithm will be started n times for each inital cluster count between
MinClusters and MaxClusters.

-RandomSeed n    (default 1)
Specifies a seed for the random number generator

-Screen n        (default 1)
Produces parameters and progress information on the console. Set to 0 to suppress output in batches.

-SplitEvery n    (default 50)
Test to see if any clusters should be split every n steps. 0 means don't split.

-StartCluFile STRING   (default "")
Treats the specified cluster file as a "gold standard".  If it can't find a
better cluster assignment, it will output this.

-UseFeatures STRING   (default 11111111111100001)
Specifies a subset of the input features to use.  STRING should consist of 1s
and 0s with a 1 indicating to use the feature and a 0 to leave it out, or the string 'ALL' indicating that every column in the feature file should be used.  NB The default value for this parameter is 11111111111100001 (because this is what we use in the lab).

-Verbose n   (default 1)
Provide more diagnostic output if non-zero.


Contact Information
-------------------

This program is copyright Ken Harris (harris@axon.rutgers.edu), 2000-2003. It
is distributed under the GNU General Public License (www.gnu.org) at http:klustakwik.sourceforge.net. If you make any changes or improvements, please let me know.
