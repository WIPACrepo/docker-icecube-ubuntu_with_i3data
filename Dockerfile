###############################################################
# Dockerfile to build an ubuntu image with all dependencies
# needed to build icetray and all IceCube test data
###############################################################

FROM icecube/ubuntu:2017.03.24

MAINTAINER Claudio Kopper <ckopper@icecube.wisc.edu>

# switch back to root user
USER root
WORKDIR /root

# set up test data directory
RUN mkdir /opt/i3-data
ENV I3_DATA /opt/i3-data

# install some additional data (clsim and nugen)
RUN mkdir /opt/i3-data/neutrino-generator && \
    wget -nv -t 5 -O /opt/i3-data/safeprimes_base32.gz  http://code.icecube.wisc.edu/tools/clsim/safeprimes_base32.gz && \
    wget -nv -t 5 -O /opt/i3-data/safeprimes_base32.txt http://code.icecube.wisc.edu/tools/clsim/safeprimes_base32.txt && \
    wget -nv -t 5 -O /opt/i3-data/neutrino-generator/nugen-v3-tables.tgz http://code.icecube.wisc.edu/tools/neutrino-generator/nugen-v3-tables.tgz && \
    tar -zx -f /opt/i3-data/neutrino-generator/nugen-v3-tables.tgz -C /opt/i3-data/neutrino-generator && \
    rm /opt/i3-data/neutrino-generator/nugen-v3-tables.tgz && \
    chmod -R u+rwX,go+rX,go-w /opt/i3-data/neutrino-generator

# add GCD files
RUN mkdir /opt/i3-data/GCD && \
    wget -nv -N -t 5 -P /opt/i3-data/GCD/ -r -l 1 -A *.i3* -nd http://prod-exe.icecube.wisc.edu/GCD/ && \
    chmod -R u+rwX,go+rX,go-w /opt/i3-data/GCD

# install photon tables
RUN mkdir /opt/i3-data/photon-tables && \
    mkdir /opt/i3-data/photon-tables/splines && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/ems_mie_z20_a10.abs.fits       http://prod-exe.icecube.wisc.edu/spline-tables/ems_mie_z20_a10.abs.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/ems_mie_z20_a10.prob.fits      http://prod-exe.icecube.wisc.edu/spline-tables/ems_mie_z20_a10.prob.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/ems_spice1_z20_a10.abs.fits    http://prod-exe.icecube.wisc.edu/spline-tables/ems_spice1_z20_a10.abs.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/ems_spice1_z20_a10.prob.fits   http://prod-exe.icecube.wisc.edu/spline-tables/ems_spice1_z20_a10.prob.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/NoHoleIceCascades_250_z20_a10.abs.fits http://prod-exe.icecube.wisc.edu/spline-tables/NoHoleIceCascades_250_z20_a10.abs.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/NoHoleIceCascades_250_z20_a10.prob.fits http://prod-exe.icecube.wisc.edu/spline-tables/NoHoleIceCascades_250_z20_a10.prob.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/InfBareMu_mie_abs_z20a10_V2.fits  http://prod-exe.icecube.wisc.edu/spline-tables/InfBareMu_mie_abs_z20a10_V2.fits && \
    wget -nv -t 5 -O /opt/i3-data/photon-tables/splines/InfBareMu_mie_prob_z20a10_V2.fits http://prod-exe.icecube.wisc.edu/spline-tables/InfBareMu_mie_prob_z20a10_V2.fits

# install I3_TESTDATA
RUN mkdir /opt/i3-data/i3-test-data && \
    rsync -vrlpt --delete code.icecube.wisc.edu::Offline/test-data/releases/V00-00-00/ /opt/i3-data/i3-test-data/ && \
    chmod -R u+rwX,go+rX,go-w /opt/i3-data/i3-test-data
ENV I3_TESTDATA /opt/i3-data/i3-test-data

# switch to icecube user
USER icecube
WORKDIR /home/icecube
