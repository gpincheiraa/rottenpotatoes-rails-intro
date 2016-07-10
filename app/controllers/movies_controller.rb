class MoviesController < ApplicationController

  include MoviesHelper

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Expose this variables to the view
    @all_ratings = Movie.ratings
    @movies = Movie.all
    
    @order = params[:order] || flash[:order]
    @ratings = params[:ratings] || flash[:ratings]
    
    if(@order)
      flash[:order] = @order
      @movies = @movies.order(@order)
    end
    
    if(@ratings)
      flash[:ratings] = @ratings
      @movies = @movies.where(rating: @ratings.keys)
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
