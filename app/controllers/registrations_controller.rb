class RegistrationsController < ApplicationController

  def index
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(params[:registration])
    params[:courses].each do |course_id|
      @registration.courses.build(:course_id => course_id)
    end if params[:courses]
    if @registration.save
      redirect_to registration_path(@registration)
    else
      render :index
    end
  end

end
