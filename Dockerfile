FROM ubuntu:latest
MAINTAINER Lakshman Kumar <lakshmankumar@gmail.com>

# Install dev tools
RUN apt-get update && apt-get install -y \
            git \
            python \
            wget \
            vim \
            strace \
            diffstat \
            pkg-config \
            cmake \
            build-essential \
            tcpdump \
            tmux \
            curl \
            cscope \
            ctags \
            nodejs \
            npm \
            software-properties-common

RUN add-apt-repository ppa:webupd8team/java  && \
           apt-get update && \
           echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
           apt-get install -y oracle-java7-installer  \
                              libxext-dev \
                              libxrender-dev \
                              libxtst-dev && \
           rm -rf /var/lib/apt/lists/* && \
           rm -rf /var/cache/oracle-jdk7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable

# Create user and add home-dir and github dir
RUN useradd lnara002 && echo "lnara002:lnara002" | chpasswd && \
                        adduser lnara002 sudo && \
                        mkdir /home/lnara002 && \
                        chown -R lnara002: /home/lnara002 && \
                        mkdir /home/lnara002/github

ENV HOME /home/lnara002

# lets get our vimfiles and setup vim
RUN git clone https://github.com/lakshmankumar12/vimfiles /home/lnara002/github/vimfiles &&  \
       git clone https://github.com/lakshmankumar12/vundle-headless-installer.git /home/lnara002/github/vundle-headless-installer && \
       mkdir -p /home/lnara002/.vim/plugin && \
       ln -s /home/lnara002/github/vimfiles/lakshman.vim /home/lnara002/.vim/plugin/lakshman.vim && \
       mkdir -p /home/lnara002/.vim/bundle/ && \
       ln -s /home/lnara002/github/vimfiles/vimrc /home/lnara002/.vimrc && \
       python /home/lnara002/github/vundle-headless-installer/install.py

WORKDIR /home/lnara002/.vim/bundle/vimproc.vim
RUN make && \
    chown -R lnara002: /home/lnara002

# reach outside world
RUN mkdir /var/shared/ && \
    touch /var/shared/placeholder && \
    chown -R lnara002:lnara002 /var/shared
VOLUME /var/shared

USER lnara002
WORKDIR /home/lnara002
CMD ["bash"]
