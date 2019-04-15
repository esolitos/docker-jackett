# Jackett/Jackett Docker image
[![Build Status](https://travis-ci.org/esolitos/docker-jackett.svg?branch=master)](https://travis-ci.org/esolitos/docker-jackett)
[![Image Size](https://images.microbadger.com/badges/image/esolitos/jackett.svg)](http://microbadger.com/images/esolitos/jackett)
[![Docker Stars](https://img.shields.io/docker/stars/esolitos/jackett.svg?style=flat-square)](https://hub.docker.com/r/esolitos/jackett/)
[![Docker Pulls](https://img.shields.io/docker/pulls/esolitos/jackett.svg?style=flat-square)](https://hub.docker.com/r/esolitos/jackett/)

Docker image for [`Jackett/Jackett`](https://github.com/Jackett/Jackett)


[Jackett](https://github.com/Jackett/Jackett) works as a proxy server: it translates queries from apps (Sonarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.
