# Establece la imagen de base a utilizar
FROM debian:buster-slim

# Establece el autor (maintainer) del archivo
MAINTAINER Eduardo Moreno

# Variables de entorno
ENV DEBIAN_FRONTEND noninteractive

# Directorio de trabajo
RUN mkdir /root/git
WORKDIR /root/git

#Fijamos la zona horaria a nivel contendor.
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Actualización imágen de sistema
RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confold" upgrade

# Instalación de paquetes necesarios para compilar Buildroot
RUN apt-get install -y git build-essential wget cpio python python3 unzip bc mercurial subversion gcc-multilib vim ccache squashfs-tools zip gettext mtools dosfstools libncurses5-dev cmake g++-multilib automake

# Instalación de paquetes interesantes para compilar aplicaciones para el entorno de la RG350
RUN apt-get install -y rsync

# Agregamos variable de entorno para que Buildroot se pueda compilar con el usuario root que utilizamos en el contenedor
ENV FORCE_UNSAFE_CONFIGURE=1

# Agregamos al PATH la ruta del toolchain para cuando lo hayamos generado en /root/git/RG350_buildroot/output/host
ENV PATH="/root/git/buildroot-rg350-old-kernel/output/host/usr/bin:$PATH"

# Configuración de locales
#RUN locale-gen es_ES.UTF-8
#RUN update-locale LANG="es_ES.UTF-8" LANGUAGE="es_ES"
#RUN dpkg-reconfigure locales

# Limpieza del gestor de paquetes
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
