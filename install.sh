# Systematically set a number of environment variables
source env.sh

# Create a conda environment called dedalus
ENVS=$(conda env list)
if [[ $ENVS = *'dedalus'* ]]; then
    source activate dedalus
else
    conda env create -f dedalus.yml
    source activate dedalus
fi

# Create a python2 environment just for mercurial
ENVS=$(conda env list)
if [[ $ENVS != *'hg'* ]]; then
    conda env create -f hg.yml
fi

# Create the software directory if it doesn't exist
mkdir -p $SOFTWARE

# Install mpi4py for cray
cd $SOFTWARE
git clone https://github.com/mpi4py/mpi4py.git
cd mpi4py
cat >> mpi.cfg <<EOF
[cray]
mpicc = cc
mpicxx = CC
extra_link_args = -shared
EOF
python setup.py build --mpi=cray
python setup.py install

# Download and install h5py
cd $SOFTWARE
git clone https://github.com/h5py/h5py.git
cd h5py
python setup.py configure --mpi --hdf5=$HDF5_DIR
python setup.py build
python setup.py install

# Download dedalus using the mercurial environment
source deactivate
source activate hg
hg clone https://bitbucket.org/dedalus-project/dedalus $DEDALUS_REPO

# Build the FFTW C-extensions using gcc (not the cray mpicc wrapper).
source deactivate
source activate dedalus_install
cd $DEDALUS_REPO
CC=gcc python setup.py build_ext --inplace
