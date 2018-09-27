class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = 0
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      redirect = 1
      @ratings = session[:ratings]
    else
      @ratings = nil
    end

    if !@ratings
      @ratings = Hash.new
      Movie.all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end

    if params[:sort]
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      redirect = 1
      @sort = session[:sort]
    else
      @sort = nil
    end

    if redirect==1
      redirect_to movies_path(:sort=>@sort, :ratings=>@ratings)
    end

    if @sort and @ratings
      @movies = Movie.where(:rating => @ratings.keys).order(@sort)
    elsif @sort
      @movies = Movie.order(@sort)
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    else
      @movies = Movie.all
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
