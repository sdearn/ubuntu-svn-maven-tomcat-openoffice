FROM ubuntu:14.04

MAINTAINER sdearn<540797670@qq.com>

RUN sudo rm -f /etc/localtime \
    && sudo ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN sudo apt-get update \
    && sudo apt-get install -y openjdk-7-jdk \
    && sudo apt-get install -y openjdk-7-jre \
    && sudo apt-get install -y wget \
    && sudo apt-get install -y zip \
    && sudo apt-get install -y vim
 
RUN echo "export JAVA_HOME=/usr/lib/jvm/Java-7-openjdk-amd64">>/etc/profile
RUN echo "export JRE_HOME=$JAVA_HOME/jre">>/etc/profile
RUN echo "export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH">>/etc/profile
RUN echo "export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH">>/etc/profile

RUN sudo apt-get install -y subversion

ADD file/ file/

ADD file/docker-entrypoint.sh work/docker-entrypoint.sh
ADD file/settings.xml work/settings.xml
ADD file/java.security work/java.security

WORKDIR /work

RUN mkdir -p /root/.m2/ && mv settings.xml /root/.m2/
    
RUN mv java.security /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre/lib/security/

RUN ["chmod", "+x", "/work/docker-entrypoint.sh"]

RUN wget http://brandpano-test.oss-cn-shenzhen.aliyuncs.com/docker-github/apache-tomcat-7.0.82.zip \
     && unzip apache-tomcat*.zip && rm -f apache-tomcat*.zip && mv apache-tomcat* tomcat

RUN wget http://brandpano-test.oss-cn-shenzhen.aliyuncs.com/docker-github/apache-maven-3.3.9-bin.zip \
    && unzip apache-maven*.zip && rm -f apache-maven*.zip && mv apache-maven* maven

RUN echo "export M2_HOME=/work/maven">>/etc/profile
RUN echo "export PATH=$M2_HOME/bin:$PATH">>/etc/profile

RUN wget http://brandpano-test.oss-cn-shenzhen.aliyuncs.com/docker-github/Apache_OpenOffice_4.1.5_Linux_x86-64_install-deb_zh-CN.tar.gz \
    && tar -zxvf Apache_OpenOffice_4.1.5_Linux_x86-64_install-deb_zh-CN.tar.gz && rm -f Apache_OpenOffice_4.1.5_Linux_x86-64_install-deb_zh-CN.tar.gz
    
RUN cd /work/zh-CN/DEBS && sudo dpkg -i *.deb

RUN cd /work/zh-CN/DEBS/desktop-integration && sudo dpkg -i openoffice4.1-debian-menus_4.1.5-9789_all.deb

WORKDIR /work

EXPOSE 8080
EXPOSE 8100

ENTRYPOINT ["/work/docker-entrypoint.sh"]
