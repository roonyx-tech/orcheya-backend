module Admin
  class UsersController < Admin::BaseController
    before_action :find_user, only: %i[destroy edit update impersonate]
    def index
      roles = policy_scope(Role).order(:name)
      render json: {
        users: all_users.map { |u| Admin::UserIndexSerializer.new(u) },
        deleted_users: deleted_users.map { |u| Admin::UserIndexSerializer.new(u) },
        invited_users: invited_users.map { |u| Admin::UserInvitationIndexSerializer.new(u) },
        meta: { roles: roles }
      }
    end

    def create
      authorize User, :invite?

      @user = User.invite!(
        email: params[:email],
        roles: Role.where(id: params[:role_id]),
        invited_by_id: current_user.id
      )

      if @user.errors.empty?
        head :ok
      else
        render json: @user.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def destroy
      authorize @user
      (@user.invitation_token && @user.really_destroy!) || @user.destroy
      head :ok
    end

    def edit
      authorize @user, :update?
      roles = Role.all
      timings = Timing.all.as_json(methods: %i[from to])

      render json: @user,
             meta: { roles: roles, timings: timings },
             each_serializer: Admin::UserSerializer,
             adapter: :json
    end

    def update
      authorize @user
      if @user.update user_params
        render json: @user,
               serializer: Admin::UserIndexSerializer,
               adapter: :json
      else
        render json: @user.errors, status: :unprocessable_entity, adapter: :json
      end
    end

    def restore
      user = User.only_deleted.find_by(id: params[:id])
      authorize user, :update?
      head :ok if user.restore(recursive: true)
    end

    def count
      render json: UsersCountReport.report(params[:year])
    end

    def count_average
      render json: UsersCountReport.average_report(params[:start_year], params[:end_year])
    end

    def updates_report
      render json: UpdatesReport.report(params[:start_date], params[:end_date])
    end

    def without_updates
      no_updates = UpdatesReport.without_updates(params[:start_date], params[:end_date], params[:user_ids]&.split(','))
      no_updates = Kaminari.paginate_array(no_updates).page(params[:page]).per(params[:limit])
      render json: { no_updates: no_updates, meta: pagination_meta(no_updates) }, adapter: :json
    end

    def impersonate
      authorize current_user, :login_as?
      impersonate_user(@user)
      tokenize(@user)
      render json: @user, status: :ok
    end

    def stop_impersonating
      stop_impersonating_user
      tokenize(current_user)
      render json: current_user, status: :ok
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def all_users
      policy_scope(User).includes(:roles, :timing).order(:name)
                        .where(invitation_token: nil)
    end

    def invited_users
      policy_scope(User).where.not(invitation_token: nil)
    end

    def deleted_users
      policy_scope(User).only_deleted
                        .joins(:roles)
                        .includes(:roles, :timing)
                        .order(:name)
                        .where.not(deleted_at: nil)
    end

    def user_params
      fields = [:timing_id, :surname, :name_cyrillic, :surname_cyrillic, :skype, :sex, :role, :phone,
                :about, :vacation_notifier_disabled, :notify_update, :name, :email, :employment_at, :discord_name,
                :birthday, roles: [:id]]
      fields << %i[working_hours new_vacation_days]
      p = params.require(:user).permit(fields)
      p[:roles] = Role.where(id: p[:roles].pluck('id'))
      p
    end

    def tokenize(user)
      scope = Devise::Mapping.find_scope!(user)
      token = "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, scope, nil).first}"
      response.set_header('authorization', token)
    end
  end
end
