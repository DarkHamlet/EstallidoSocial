#############################################
###     Análsis de sentimiento del        ###
### movimiento social a través de Twitter ###
###             2019-11-21                ###
###               Hamlet                  ###
#############################################

# http://www.diegocalvo.es/obtener-datos-de-twitter-con-r-usando-su-api/
# Script para conectar a la API de Twitter, buscar info histórica del último mes.
# Periodo de interés: Viernes 18-10-2019 al viernes 07-11-2019 (28 días, máximo que entrega la API)

# erase memory
rm(list=ls())

# Workaround by edition to httr package
install.packages("devtools");
library("devtools");
devtools::install_version("httr", version="0.6.0", repos="http://cran.us.r-project.org")

# En este caso usaremos package twitteR
# packages
install.packages("ROAuth");
install.packages("base64enc");
install.packages("twitteR");
install.packages("streamR");

install.packages("openssl");
install.packages("httpuv");


library("ROAuth");
library("base64enc");
library("twitteR");
library("streamR")

library("openssl")
library("httpuv")

# Cargar parámetros de configuración
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
options(httr_oauth_cache=T)

# Cargar las credenciales obtenidas del paso anterior
consumer_key <- "yT0a2vvDkbmquBoKiWILt2jdx"
consumer_secret <-"baeaFoj0fv3TTGS98PTTKkg29r4Eh5FwlePgtjQLGIzNSDLUQk"
access_token <-"803590273-vXRZOdHPb5cMDuusJ3Z6VPDBqB2nRLIi84l7Yh34"
access_secret <-"yZVU0mwzHsItUulpvEibo8XV4Y0A04pXu9BRmEcaq7AuD"

# 
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

# Ejecutar la autenticación de TwitteR # funciona!
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# streamR authentication
credentials_file <- "my_oauth.Rdata"
if (file.exists(credentials_file)){
  load(credentials_file)
} else {
  cred <- OAuthFactory$new(consumerKey = consumer_key, consumerSecret =
                             consumer_secret, requestURL = reqURL, accessURL = accessURL, authURL = authURL)
  cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
  save(cred, file = credentials_file)
}

## REST API
# Proporciona acceso a tweets de los últimos 6 a 9 días.
# Cargar la librería específica de TwitterR
library(twitteR);

# Leer el fichero de credenciales creado anteriormente, ¡cuidado con la ruta del fichero!.
source('credenciales.R')

# Función que permite buscar: #hastag, @usuarios, palabras
tweets <- searchTwitter("estado+emergencia"
                        ,n=10, lang="es"
                        ,since="2019-10-18"
                        ,until="2019-11-18"
                        #, geocode='-33.4372, -70.6506, 500km' # geocode = 'latitude,longitude,radius,1mi' # Stgo: -33.4372, -70.6506
                        ,resultType="popular")
## Esto funciona la raja!
View(tweets)
tweet <- tweets[[1]];tweet



?searchTwitter



# Quedarse solo con el primer tweet para datos concretos del mismo
tweet <- tweets[[1]];

# Mostrar la estructura del tweet
str(tweet)

# Obtener el texto del tweet:
tweet$getText()

# Obtener información acerca del usuario:
usuario <- getUser(tweet$getScreenName());

# Mostrar la estructura del usuario
str(usuario)

# Obtener el nombre del usuario
usuario$getName()




## Streaming
# Permite conectar y filtrar los tweets que se están publicando en tiempo real (en el mismo momento.
# Generalmente se deja el proceso funcionando durante un cierto período de tiempo.

# Cargar las librerías específicas
library(twitteR);
library(streamR);

# Leer el fichero de credenciales creado anteriormente
source('credenciales.R')

# Capturar tweets en el fichero "tweets.json" de los tags "love" y "#data" durante 60 segundos
filterStream("tweets.json", track = c("love", "#data"), timeout = 60, oauth = cred);

# Cargar el fichero el objeto para poder manipularlo posteriormente
tweets <- parseTweets("tweets.json", simplify = TRUE);

# Mostrar número de tweets obtenidos de cada tag buscado.
show(paste("Numero de tweets con love:", length(grep("love", tweets$text, ignore.case = TRUE))));
show(paste("Numero de tweets con #data:", length(grep("#data", tweets$text, ignore.case = TRUE))));