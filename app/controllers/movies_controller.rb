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
    
    #Expose this variables to the view
    @all_ratings = Movie.ratings  
    
    if(params[:order])
      #track the order state
      session[:order] = params[:order]
      @order_param = params[:order]
      
      case @order_param
        when 'title'

          if(session[:ratings])
            @movies = Movie
                        .where(rating: session[:ratings].keys)
                        .order(:title)
          else
            @movies = Movie.all.order(:title)
          end
          
        when 'release_date'
           if(session[:ratings])
            @movies = Movie
                        .where(rating: session[:ratings].keys)
                        .order(:title)
          else
            @movies = Movie.all.order(:release_date)
          end
        else
          flash[:warning] = 'The order specified it\'s not defined'
      end
    
    elsif(params[:ratings])
      
      #track the params for future usage
      session[:ratings] = params[:ratings]

      #Build the url params with the ratings params 
      ratings_array = []
      params[:ratings].each do |k, v|
        ratings_array.push("ratings=#{k}")
      end
      ratings_query = ratings_array.join('&')
      @ratings_params = "&#{ratings_query}"
      @movies = Movie.where(rating: params[:ratings].keys)
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
