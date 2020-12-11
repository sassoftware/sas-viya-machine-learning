FROM node:12.4.0-alpine
LABEL maintainer="oleg.golovidov@sas.com"
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080

#
# You can override these(but in container leave APPHOST as shown below)
#

ENV APPHOST=0.0.0.0
ENV APPPORT=8080
ENV APPNAME=autotune
ENV APPLOC=./public
ENV APPENTRY=index.html
ENV APPENV=./env/appenv.js
CMD ["npm", "run", "indocker"]
