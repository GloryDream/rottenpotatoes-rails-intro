class Movie < ActiveRecord::Base
  @all_ratings = Array['G','PG','PG-13','R']
  def self.all_ratings
    @all_ratings
  end
end
