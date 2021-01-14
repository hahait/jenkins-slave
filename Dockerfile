FROM hahait/centos7.9:20201222

USER root

COPY apache-maven-3.6.3 /data/java/maven-3.6.3

COPY node-v12.10.0-linux-x64 /data/node

COPY jdk1.8.0_111 /data/java/jdk

COPY Python-3.6.4 /usr/local/python3.6

COPY requirements.txt /data/requirements.txt

COPY remoting-4.6.jar /usr/share/jenkins/agent.jar

COPY jenkins-agent /usr/local/bin/jenkins-agent

ARG AGENT_WORKDIR=/home/jenkins/agent

RUN ln -sf /data/node/bin/node /usr/bin/node \
    && ln -sf /data/java/maven-3.6.3/bin/mvn /usr/bin/mvn \
    && ln -sf /data/node/bin/npm /usr/bin/npm \ 
    && npm config set strict-ssl false \
    && npm config set @watsons:registry http://npmreg.watsons.com:4873/ \
    && npm config set registry https://registry.npm.taobao.org \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \ 
    && ln -sf /data/java/jdk/bin/java /usr/bin/java \
    && mkdir /root/.ssh/ \
    && chmod 755 /usr/share/jenkins \
    && chmod 644 /usr/share/jenkins/agent.jar \
    && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar \
    && mkdir -p /home/jenkins/agent \
    && chmod +x /usr/local/bin/jenkins-agent \
    && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave \
    && yum -y install gcc* automake autoconf libtool make kde-l10n-Chinese \
    && yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel \
    && yum -y reinstall glibc-common \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 \
    && echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf \
    && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'sass_binary_site=https://npm.taobao.org/mirrors/node-sass/' >> /root/.npmrc \
    && cd /usr/local/python3.6 && ./configure --prefix=/data/python3.6 && make && make install \
    && ln -s /data/python3.6/bin/python3 /usr/bin/python3 \
    && ln -s /data/python3.6/bin/pip3 /usr/bin/pip3 \
    && pip3 install -r /data/requirements.txt \
    && source /etc/profile


ADD .ssh /root/.ssh/

ADD .pip /root/.pip

ADD settings.xml /root/.m2/

VOLUME /root/.jenkins

VOLUME $AGENT_WORKDIR

RUN chmod 600 /root/.ssh/id_rsa

ENV NODE_HOME /data/node

ENV JAVA_HOME /data/java/jdk

ENV MAVEN_HOME /data/java/maven-3.6.3

ENV LANG zh_CN.UTF-8

ENV LC_ALL zh_CN.UTF-8

WORKDIR $AGENT_WORKDIR

ENTRYPOINT ["jenkins-agent"]
