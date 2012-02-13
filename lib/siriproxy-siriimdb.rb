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
  
  listen_for /(Dois-je regarder|Dois-je voir|Que penses-tu de|Est-ce que tu me conseilles|Est-ce que tu me conseil) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieRating = getRating(movieTitle)
	movieRatingString = movieRating.to_s
	if (movieRating < 6)
		say "Le film " + movieTitle + " a seulement obtenu " + movieRatingString + " sur 10, ce n'est pas génial..."
	elsif (movieRating < 8)
		say "Vous devriez vraiment voir le film " + movieTitle + ", il a obtenu " + movieRatingString + "  sur 10"
	elsif (movieRating >= 8)
		say "Le film " + movieTitle + " est à voir absolument, il a un score de " + movieRatingString + " sur 10 !"
	end
    request_completed
  end
  
  listen_for /(Qui joue|Qui a joué) dans (.*)/i  do |question,movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", et " + movieActors[2] + " ont joués dans " + movieTitle + "."
    request_completed
  end
  
  listen_for (/(Qui est l\'acteur principal|Qui est le héro) dans (.*)/i) do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	say "L'acteur principal du film " + movieTitle + " est " + movieActor + "."
	  request_completed
  end
  
  listen_for /(Qui a réalisé|Qui a produit|Qui à fait) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "" + movieDirectors[0] + " a réalisé le film " + movieTitle + "."
	  request_completed
  end
  
  listen_for /(Quand est sorti|Quand a été produit|Quand a été réalisé) (.*)/i do |question, movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "Le film " + movieTitle + " date de " + movieDate + "."
	  request_completed
  end
end
