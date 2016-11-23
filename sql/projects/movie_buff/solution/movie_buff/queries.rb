# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer


def it_was_ok
  # We can use ranges (a..b) inside the where method
  # For example, to find all movies made in the 70s I could do the following
  #
  # Movie.where(yr: 1970..1979)
  #
  # Find all movies with scores between 2 and 3

  Movie.where(score: 2..3)
end

def biggest_cast
  # Sometimes we need to use agregate sql functions like
  # COUNT, MAX, and AVG
  # These are often combined with group
  # For example, to find the actor with the most roles we could do
  #
  # Actor
  #   .joins(:movies)
  #   .group("actors.id")
  #   .order("COUNT(movies.id) DESC")
  #   .first
  #
  # Find the movie with the largest cast (i.e most actors)

  Movie
    .joins(:actors)
    .group("movies.id")
    .order("COUNT(actors.id) DESC")
    .first
end

def directed_by_one_of(them)
  # We can use IN to test if an element is in a list
  # To test if a movie was made in one of a list of years called 'years'
  # we could do
  #
  # Movie.where("yr IN (?)", years)
  #
  # them will be a list of names of directors
  # Find all the movies direct by one of them

  Movie
    .joins(:director)
    .where("actors.name IN (?)", them)
end

def bad_taste
  # Find the actor whose with the lowest average score among movies they're cast in
  # Hint: imitate your solution for biggest_cast

  Actor
    .joins(:movies)
    .group(:id)
    .order("AVG(movies.score) ASC")
    .first
end

def it_was_ok
  # We can use ranges (a..b) inside the where method
  # For example, to find all movies made in the 70s I could do the following
  #
  # Movie.where(yr: 1970..1979)
  #
  # Find all movies with scores between 2 and 3

  Movie.where(yr: 1970..1979)
end

def biggest_cast
  # Sometimes we need to use agregate sequel functions like
  # COUNT, MAX, and AVG
  # For example, to find the actor with the most roles we could do
  #
  # Actor
  #   .joins(:movies)
  #   .group("actors.id")
  #   .order("COUNT(movies.id) DESC")
  #   .first
  #
  # Find the movie with the largest cast (i.e most actors)

  Movie
    .joins(:actors)
    .group("movies.id")
    .order("COUNT(actors.id) DESC")
    .first
end

def directed_by_one_of(them)
  # We can use IN to test if an element is in a list
  # To test if a movie was made in one of a list of years called 'years'
  # we could do
  #
  # Movie.where("yr IN (?)", years)
  #
  # them will be a list of names of directors
  # Find all the movies direct by one of them

  Movie
    .joins(:director)
    .where("actors.name IN (?)", them)
end

def bad_taste
  # Find the actor whose with the highest average score among movies they've been in
  # Hint: look at your solution for biggest_cast

  Actor
    .joins(:movies)
    .group(:id)
    .order("AVG(movies.score) ASC")
    .first
end

def movie_names_before_1940
  # Find all the movies made before 1940. Show the id, title, and year.

  Movie.select(:id, :title, :yr).where("yr < 1940")
end

def eighties_b_movies
	# List all the movies from 1980-1989 with scores falling between 3 and 5 (inclusive).
  # Show the id, title, year, and score.

	Movie.select(:id, :title, :yr, :score).where(yr: 1980..1989, score: 3..5)
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.

  Movie
    .select("movies.id, movies.title, actors.name")
    .joins(:actors)
    .where("director_id = actors.id")
    .where("castings.ord = 1")
end

def starring(whazzername)
	# Find the movies with an actor who had a name like `whazzername`.
	# A name is like whazzername if the actor's name contains all of the letters in whazzername,
  # ignoring case, in order.

	# ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but not like "stallone sylvester" or "zylvester ztallone"

	matcher = "%#{whazzername.split(//).join("%")}%"
  Movie.joins(:actors).where("UPPER(actors.name) LIKE UPPER(?)", matcher)

  # Note: The below code also works:
  # Actor.where("name ilike ?", matcher).first.movies

  # As the Postgres docs say,
  # "the keyword ILIKE can be used instead of LIKE to make the match case insensitive according to the active locale.
  # This is not in the SQL standard but is a PostgreSQL extension."
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  Movie.select(:yr, "MAX(score)").group(:yr).having("MAX(score) < 8").pluck(:yr)
end

def golden_age
	# Find the decade with the highest average movie score.
	Movie
    .select("AVG(score), (yr / 10) * 10 AS decade")
    .group("decade")
    .order("avg(score) DESC")
    .first
    .decade
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord).
  Actor
    .joins(:movies)
    .where("movies.title = ?", title)
    .order("castings.ord")
end

def costars(name)
  # List the names of the actors that the named actor has ever appeared with.

  subquery = Movie.select(:id).joins(:actors).where("actors.name = ?", name)
  Movie
    .joins(:actors)
    .where("actors.name != ?", name)
    .where("movies.id IN (?)", subquery)
    .distinct
    .pluck(:name)
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  #Show each actor's id, name and number of supporting roles.

  Actor
    .select(:id, :name, "COUNT(castings.actor_id) as roles")
    .joins(:castings)
    .where("castings.ord != 1")
    .group("actors.id")
    .order("roles DESC")
    .limit(2)
end

def what_was_that_one_with(those_actors)
	# Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.

	Movie
    .select(:title, :id)
    .joins(:actors)
    .where("actors.name in (?)", those_actors)
    .group(:id)
    .having("COUNT(actors.id) >= ?", those_actors.length)
end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie

  Actor
    .select(:name)
    .joins("LEFT OUTER JOIN castings on castings.actor_id = actors.id")
    .where("castings.movie_id IS NULL")
    .count
end

def longest_career
	# Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names

	Actor
    .select(:name, :id, "MAX(movies.yr) - MIN(movies.yr) AS career")
    .joins(:movies)
    .order("career DESC, name")
    .group(:id)
    .limit(3)
end
