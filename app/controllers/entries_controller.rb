class EntriesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @entry  = current_user.entries.build(params[:entry])
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @entry.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @entry = current_user.entries.find_by_id(params[:id])
      redirect_to root_path if @entry.nil?
    end

<<END_ALT
    def authorized_user
      @entry = current_user.entries.find(params[:id])
    rescue
      redirect_to root_path
    end
END_ALT

end

