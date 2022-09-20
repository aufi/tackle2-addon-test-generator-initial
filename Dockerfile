FROM registry.access.redhat.com/ubi8/go-toolset:1.16.12 as builder
ENV GOPATH=$APP_ROOT
COPY --chown=1001:0 . .
RUN make cmd

FROM registry.access.redhat.com/ubi8/ubi-minimal
USER root
RUN echo -e "[centos8]" \
 "\nname = centos8" \
 "\nbaseurl = http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/" \
 "\nenabled = 1" \
 "\ngpgcheck = 0" > /etc/yum.repos.d/centos.repo
RUN echo -e "[WandiscoSVN]" \
 "\nname=Wandisco SVN Repo" \
 "\nbaseurl=http://opensource.wandisco.com/centos/6/svn-1.9/RPMS/$basearch/" \
 "\nenabled=1" \
 "\ngpgcheck=0" > /etc/yum.repos.d/wandisco.repo
RUN microdnf -y install \
  java-11-openjdk-headless \
  openssh-clients \
  unzip \
  wget \
  git \
  subversion \
  maven \
  python39 \
  python39-toml \
  python39-wheel \
 && microdnf -y clean all
ARG TESTGEN=https://github.com/konveyor/tackle-test-generator-cli/releases/download/v2.4.0/tackle-test-generator-cli-v2.4.0-all-deps.zip
RUN wget -qO /opt/tackle-test-generator-cli.zip $TESTGEN \
 && unzip /opt/tackle-test-generator-cli.zip -d /opt \
 && rm /opt/tackle-test-generator-cli.zip
#RUN cd /opt/tackle-test-generator-cli &&  python3 setup.py --help && python3 setup.py install && tkltest-unit
RUN cd /opt/tackle-test-generator-cli && python3 -m venv venv && source venv/bin/activate && pip install --editable . && tkltest-unit
RUN cd /opt/tackle-test-generator-cli && python3 -m venv venv && source venv/bin/activate && tkltest-unit --help
#ENV HOME=/working \
#    JAVA_HOME="/usr/lib/jvm/jre-11" \
#    JAVA_VENDOR="openjdk" \
#    JAVA_VERSION="11"
WORKDIR /working
COPY --from=builder /opt/app-root/src/bin/addon /usr/local/bin/addon
ENTRYPOINT ["/usr/local/bin/addon"]
