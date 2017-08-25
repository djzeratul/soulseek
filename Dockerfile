FROM ubuntu:14.04
MAINTAINER Daniel Guerra
RUN dpkg --add-architecture i386
RUN apt-get -yy update \
&& apt-get -y install --no-install-recommends wget libx11-6 libx11-xcb1 libfontconfig1 supervisor xvfb x11vnc software-properties-common openbox xterm\
&& add-apt-repository ppa:wine/wine-builds \
&& apt-get -yy update \
&& apt-get -y install winehq-devel \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN addgroup soulseek
RUN useradd -m -s /bin/bash -g soulseek soulseek
RUN echo "soulseek:soulseek" | /usr/sbin/chpasswd
RUN echo "soulseek    ALL=(ALL) ALL" >> /etc/sudoers
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
WORKDIR /home/soulseek
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD menu.xml /etc/xdg/openbox/menu.xml
ADD soulseek /usr/bin/soulseek
RUN chown soulseek:soulseek /usr/bin/soulseek*
ADD winetricks /home/soulseek/winetricks
RUN chown soulseek:soulseek /home/soulseek
ENV WINEPREFIX /home/soulseek/.wine
ENV WINEARCH win64
ENV DISPLAY :1
ADD start /bin/start
USER soulseek
EXPOSE 5900 6080
CMD ["/bin/start"]
