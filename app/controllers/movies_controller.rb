# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings
    @hilite = {}
    @movies = {}
    @ratings = {}
    sort_by = params[:sort_by] || session[:sort_by];

    @hilite[sort_by] = sort_by ? 'hilite' : ''

    if params["ratings"] # user just clicked to filter
      session[:ratings] = params["ratings"]
      session[:all_empty_boxes] = nil
    end
    
    if params[:sort_by]  # user just clicked to sort
      # clicking twice reverts the sort effect
      if flash[:sort_by] == params[:sort_by]
        @movies = Movie.all
        session[:sort_by] = nil
        sort_by = nil
        redirect_to movies_path
      else
        flash[:sort_by] = params[:sort_by]
        session[:sort_by] = params[:sort_by]
      end
    end

    if params[:commit] && !params["ratings"]    # user unselected all checkboxes and filtered
      @movies = {}
      @ratings = {}
      session.clear()
      session[:all_empty_boxes] = true
    elsif !session[:all_empty_boxes]             # there's at least one checkbox selected
      @ratings = params["ratings"] || session[:ratings];

      if sort_by && !@ratings  # only sort
        @movies = Movie.all.order(session[:sort_by]);
      elsif @ratings && !sort_by # only filter
        @movies = Movie.where(rating: @ratings.keys)
      elsif !@ratings && !sort_by
        @movies = Movie.all;
      else
        @movies = Movie.all.order(session[:sort_by]).where(rating: @ratings.keys)
      end
    end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end