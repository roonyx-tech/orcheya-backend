module Admin
  class SectionsController < ApplicationController
    before_action :set_section, only: %i[update destroy]

    def index
      @sections = policy_scope(Section, policy_scope_class: FaqPolicy::Scope)
      render json: @sections,
             include: '*.*',
             each_serializer: SectionSerializer
    end

    def create
      section = Section.new(section_params)
      authorize section, policy_class: FaqPolicy
      if section.save
        render json: section,
               include: '*.*',
               serializer: SectionSerializer
      else
        render json: section.errors, status: :unprocessable_entity
      end
    end

    def update
      authorize @section, policy_class: FaqPolicy

      if @section.update(section_params)
        render json: @section,
               include: '*.*',
               serializer: SectionSerializer
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @section, policy_class: FaqPolicy
      @section.destroy
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params
        .require(:section)
        .permit(
          %w[title image].push(
            questions_attributes: %w[id title _destroy].push(
              answer_attributes: %w[section_id content]
            )
          )
        )
    end
  end
end
