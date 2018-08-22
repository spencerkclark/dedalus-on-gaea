## Installing and running `dedalus` on Gaea

Within this repository there are four files which one can use as a reference
for how one might go about installing `dedalus` on GFDL's Gaea computer.  Gaea
is a Cray machine; therefore we need to be sure to link to its native
implementation of MPI (e.g. we should not try to build and install openmp from
source).  In addition, it also already has MPI-enabled compiled versions for
FFTW and parallel HDF5; we just to need to link to those.  The included files
assume that you are using a zsh shell and have `conda` installed in some form
already.  They should be easily translatable for use with other shells.

#### `env.sh`
Sourcing this file in the command line, e.g.:
```
$ source env.sh
```
primes your environment for installing or running `dedalus`.  If `dedalus` has
been installed, it activates the conda environment containing its Python
dependencies.  In addition, it loads the cray-compatible modules for `mpich`,
`hdf5-parallel`, and `fftw`; this populates key environment variables like
`PATH` and `LD_LIBRARY_PATH` appropriately.  Sourcing the file also sets
important environment variables for installing `dedalus` like `MPI_PATH`, and
`FFTW_PATH`.

#### `install.sh`
Sourcing this file in the command line, e.g.:
```
$ source install.sh
```
will go through the steps of creating the `dedalus` conda environment, and
downloading and installing `mpi4py`, `h5py`, and `dedalus` from source (each
configured appropriately for using the native cray modules on Gaea).  Note that
since mercurial is only compatible with Python 2, we create a separate conda
environment just for that (we only use it to download the `dedalus` source code
repository).  This script installs each of these files into the user's
`unswept` directory in a folder called `software`:
`/lustre/f1/unswept/$USER/software`.

#### `dedalus.yml`
This is just an environment specification file for the Python dependencies of
`dedalus` that we can install through conda.

#### `hg.yml`
This is just an environment specification file for the environment we will use
to use mercurial.

## Installing `dedalus`
Modulo modifying the scripts for your specific shell, installing `dedalus` on
Gaea would look something like the following:
```
$ git clone https://github.com/spencerkclark/dedalus-on-gaea.git
$ cd dedalus-on-gaea
$ source env.sh
$ source install.sh
```

## Running `dedalus` on Gaea
Rather than `mpiexec`, cray machines use the `aprun` command to submit MPI
jobs.  To interactively run one of the `dedalus` example scripts to test things
out, start an interactive job via:
```
$ msub -I
```
Then once the job starts up, activate the `dedalus` environment via:
```
$ source ~/dedalus-on-gaea/env.sh
```
and then navigate to the `dedalus` examples directory:
```
$ cd $SOFTWARE/dedalus/examples/ivp/2d_rayleigh_benard
```
Finally, run `rayleigh_benard.py` using `aprun` and 32 cores:
```
$ aprun -n 32 python rayleigh_benard.py
```
I have not tried it, but I expect that without too much trouble, one should be
able to figure out how to submit batch jobs to run `dedalus` simulations or
multiple cores.

## See also
The instructions here were derived from a number of sources, including the
examples given in the [official `dedalus`
documentation](https://dedalus-project.readthedocs.io/en/latest/installation.html#manual-installation) and
[Nathaniel Tarshish's notes on setting up `dedalus` on the GFDL
PPAN](https://github.com/nathanieltarshish/PPANdedalus/blob/master/GFDL_PPAN_instructions.md).
The instructions [here](http://jaist-hpc.blogspot.com/2015/02/mpi4py.html) for
installing `mpi4py` on a Cray machine were also helpful.
