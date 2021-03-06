FROM centos:centos6

# Required
# --------
# - cmsRun fails without stdint.h (from glibc-headers)
#   Tested CMSSW_7_4_5_patch1
#
# Other
# -----
# - ETF calls /usr/bin/lsb_release (from redhat-lsb-core)
# - sssd-client for LDAP lookups through the host
# - SAM tests expect cvmfs utilities
# - gcc is required by GLOW jobs (builds matplotlib)
#
# CMSSW dependencies
# ------------------
# Required software is listed under slc6_amd64_platformSeeds at
# http://cmsrep.cern.ch/cgi-bin/cmspkg/driver/cms/slc6_amd64_gcc472

RUN yum -y install http://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install cvmfs \
                   gcc \
                   glibc-headers \
                   lcmaps-plugins-mount-under-scratch \
                   openssh-clients \
                   osg-wn-client \
                   osg-wn-client-glexec \
                   redhat-lsb-core \
                   sssd-client && \
    yum -y install glibc coreutils bash tcsh zsh perl tcl tk readline openssl \
                   ncurses e2fsprogs krb5-libs freetype compat-readline5 \
                   ncurses-libs perl-libs perl-ExtUtils-Embed fontconfig \
                   compat-libstdc++-33 libidn libX11 libXmu libSM libICE \
                   libXcursor libXext libXrandr libXft mesa-libGLU mesa-libGL \
                   e2fsprogs-libs libXi libXinerama libXft libXrender libXpm \
                   libcom_err && \
    yum -y install --enablerepo osg-upcoming-development singularity && \
    yum clean all

# Create condor user and group
RUN groupadd -r condor && \
    useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor

# Add lcmaps.db
COPY lcmaps.db /etc/lcmaps.db

# yum update
RUN yum update -y && \
    yum clean all
