module Users
  class LinksController < ApplicationController
    before_action :find_user
    before_action :find_link, only: %i[update destroy]

    def index
      render json: @user.links.order('id ASC')
    end

    def create
      render json: @user.links.create(link_params)
    end

    def update
      render json: @link if @link.update(link_params)
    end

    def destroy
      @link.destroy
    end

    private

    def find_link
      @link = @user.links.find_by(id: params[:id])
    end

    def link_params
      params.permit(:link)
    end

    def find_user
      @user = User.find_by(id: params[:user_id])
    end
  end
end
