class PetApplicationsController < ApplicationController

  def create
    @application = Application.find(params[:id])
    if !params[:_method].nil?
      @application.pets << Pet.search_by_name(params[:_method])
    end
    redirect_to "/applications/#{@application.id}"
  end


end
