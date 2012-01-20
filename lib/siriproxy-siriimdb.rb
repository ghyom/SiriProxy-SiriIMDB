# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'imdb'

#######
# SiriIMDB is a Siri Proxy plugin that allows Siri to give you recommendations, ratings, and other useful information about anything on IMDB.
# Check the readme file for more detailed usage instructions.
# Created by parm289  - you are free to use, modify, and redistribute as you like, as long as you give the original author credit.
######

class SiriProxy::Plugin::SiriIMDB < SiriProxy::Plugin
  def initialize(config)
  end
  
  def getActors(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	return movie.cast_members
  end
  
  def getLeadActor(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	return movieActor
  end
  
  def getRating(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	movieRating = movie.rating()
	return movieRating
  end
  
  listen_for /(Dois-je regarder|Dois-je voir|Est-ce que je devrais voir|Est-ce que je doit voir|Est-ce qu'il faut voir|Quelle est la note de) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieRating = getRating(movieTitle)
	movieRatingString = movieRating.to_s
	if (movieRating < 6)
		say "" + movieTitle + " a seulement obtenu " + movieRatingString + " sur 10, ce n'est pas génial..."
	elsif (movieRating < 8)
		say "Vous devriez voir " + movieTitle + ", il a obtenu " + movieRatingString + "  sur 10"
	elsif (movieRating >= 8)
		say "" + movieTitle + " est à voir absolument, il a un score de " + movieRatingString + " sur 10 !"
	end
    request_completed
  end
  
  listen_for /(Qui joue|Qui a joué) dans (.*)/i  do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", et " + movieActors[2] + " jouent dans " + movieTitle + "."
    request_completed
  end
  
  listen_for (/(Qui est l'acteur principal|Qui est le héro) dans (.*)/i) do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	say "L'acteur principal de " + movieTitle + " est " + movieActor + "."
	  request_completed
  end
  
  listen_for /(Qui a réalisé|Qui a produit|Qui à fait) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "" + movieDirectors[0] + " a réalisé " + movieTitle + "."
	  request_completed
  end
  
  listen_for /(Quand est sortit|De quand date|De quelle année est) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "" + movieTitle + " date de " + movieDate + "."
	  request_completed
  end
end
