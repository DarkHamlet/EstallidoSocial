#############################################
###     An�lsis de sentimiento del        ###
### movimiento social a trav�s de Twitter ###
###             2019-11-20                ###
###               Hamlet                  ###
#############################################

# https://medium.com/mindninja/sentiment-analysis-on-twitter-data-with-r-e93769feb8c4
# Script para conectar a la API de Twitter, buscar info hist�rica del �ltimo mes.
# Periodo de inter�s: Viernes 18-10-2019 al viernes 07-11-2019 (28 d�as, m�ximo que entrega la API)

# erase memory
# rm(list=ls())

# packages
install.packages('rtweet')
install.packages('dplyr')
install.packages('tidytext')
install.packages('ggplot2')

## install remotes package if it's not already
# if (!requireNamespace("remotes", quietly = TRUE)) {
#  install.packages("remotes")
# }

## install dev version of rtweet from github
# remotes::install_github("mkearney/rtweet")

# Load all required libraries
library(rtweet)
library(dplyr)
library(tidytext)
library(ggplot2)

# Create token # Aqu� crear la App
token = create_token(
  app = "app4data", #app4data
  consumer_key = "yT0a2vvDkbmquBoKiWILt2jdx",
  consumer_secret = "baeaFoj0fv3TTGS98PTTKkg29r4Eh5FwlePgtjQLGIzNSDLUQk",
  access_token = "803590273-vXRZOdHPb5cMDuusJ3Z6VPDBqB2nRLIi84l7Yh34",
  access_secret = "yZVU0mwzHsItUulpvEibo8XV4Y0A04pXu9BRmEcaq7AuD")

# AppID: 17024185

## Set workspace and Data
setwd("C:\\Hamlet\\Personal\\Data Science\\Diplomado DataScience UC\\2019 Hamlet\\Proyecto Final\\Datax")

query <- "Climate,meme,challenge,Climatechange,trashtag"
#query <- "chile,estadodeemergencia,meme"


## Define stream period
streamtime <- 30 # 30*60

## Define storage file for streamed content
filename <- "stream.json"

## Start the stream and store in a df
streamdata <- stream_tweets(q = query, timeout = streamtime, file_name = filename)

View(streamdata)


