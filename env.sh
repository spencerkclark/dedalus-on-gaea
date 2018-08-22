# source this file if you want to install or run dedalus

# Unload superfluous conflicting libraries and deactivate any default conda
# environments.  I've commented out the lines from my case (just to serve as an
# example of what I mean here).
# module unload fre/bronx-10
# source deactivate

# If the dedalus environment exists, activate it.  Otherwise
# don't worry about it (say if we are installing for the first time).
ENVS=$(conda env list)
if [[ $ENVS = *'dedalus'* ]]; then
    source activate dedalus
fi

# 'module show <module-name>' shows all the metadata added to the
# environment for a given module.  This is super helpful for
# finding the appropriate paths.

# Load the cray implementation of mpi
module load cray-mpich

# Load fftw
module load cray-fftw

# Load hdf5-parallel
# Note this automatically adds the appropriate HDF5_DIR environment variable
module load cray-hdf5-parallel
export HDF5_VERSION=1.8.16

# The module system adds variables to the CRAY_LD_LIBRARY_PATH
# For non-default libraries, like dedalus, we need to allow access
# to the default libraries through the normal LD_LIBRARY_PATH.
# This can be done by prepending the cray version to the normal
# version.
# See here: https://pubs.cray.com/content/S-2529/17.05/xctm-series-programming-environment-user-guide-1705-s-2529/modify-linking-behavior-to-use-non-default-libraries
export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}

# Set the default mpi compilers to the cray versions
export CC=cc
export CXX=CC
export FTN=ftn

# Set environment variables for dedalus installation
export FFTW_PATH=/opt/cray/pe/fftw/3.3.6.3/broadwell
export MPI_PATH=$CRAY_MPICH_DIR

# Set a root path to user-installed libraries (including dedalus)
export SOFTWARE=/lustre/f1/unswept/$USER/software

# Install dedalus by modifying the PYTHONPATH (append if it already exists)
export DEDALUS_REPO=${SOFTWARE}/dedalus
if [[ -v PYTHONPATH ]]; then
    export PYTHONPATH=${SOFTWARE}/dedalus:${PYTHONPATH}
else
    export PYTHONPATH=${SOFTWARE}/dedalus
fi
