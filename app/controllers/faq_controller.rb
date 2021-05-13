class FaqController < ApplicationController
  def index
    render json: Section.all
  end

  def show
    @section = Section.find(params[:id])
    render json: @section, serializer: SectionSerializer,
           include: '*.*'
  end
end
