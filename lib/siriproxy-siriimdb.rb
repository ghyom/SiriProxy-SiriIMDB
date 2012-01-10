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

  listen_for /wieviele Sterne hat (.*) bekommen/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	#Search for the movie and get the rating as a string
	movieRating = getRating (movieTitle)
	movieRatingString = movieRating.to_s
	say "" + movieTitle + " wurde mit " + movieRatingString + " von 10 Sternen bewertet!"
    request_completed
  end
  
  listen_for /Sollte ich mir (.*) ansehen/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieRating = getRating(movieTitle)
	movieRatingString = movieRating.to_s
	if (movieRating < 6)
		say "Du solltest dir " + movieTitle + " lieber nicht ansehen, er hat nur " + movieRatingString + " von 10 Sternen!"
	elsif (movieRating < 8)
		say "Ich kann dir den Film " + movieTitle + "empfehlen, er hat " + movieRatingString + " von 10 Sternen!"
	elsif (movieRating >= 8)
		say "" + movieTitle + " musst du dir ansehen! Er hat " + movieRatingString + " Sterne bekommen!"
	end
    request_completed
  end

 listen_for /wer hat in (.*) mitgespielt/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", und " + movieActors[2] + " spielten in " + movieTitle + "mit."
    request_completed
  end

 listen_for (/wer spielt in (.*) mit/i)  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", und " + movieActors[2] + " spielten in " + movieTitle + "mit."
    request_completed
  end  
  
  listen_for /who is in (.*)/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", and " + movieActors[2] + " were in " + movieTitle + "."
    request_completed
  end
  
  listen_for /Wer ist der Hauptdarsteller in (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActor = getLeadActor(movieTitle)
	say "Der Hauptdarsteller in " + movieTitle + " ist " + movieActor + "."
	request_completed
  end
  
  listen_for (/Who's the main actor in (.*)/i) do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	say "The main actor in " + movieTitle + " is " + movieActor + "."
	request_completed
  end
  
  listen_for /Who directed (.+)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "The director of " + movieTitle + " is " + movieDirectors[0] + "."
	request_completed
  end
  
  listen_for /von wann ist (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "" + movieTitle + " kommt aus dem Jahr " + movieDate + "."
	request_completed
  end
end
