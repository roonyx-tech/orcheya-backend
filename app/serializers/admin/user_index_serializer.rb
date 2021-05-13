module Admin
  class UserIndexSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :surname,
               :email,
               :phone,
               :birthday,
               :invitation_token,
               :discord_connected,
               :slack_connected,
               :timedoctor_connected,
               :notify_update,
               :discord_notify_update,
               :roles,
               :deleted_at,
               :employment_at,
               :deleted_at,
               :working_hours,
               :vacations_days_available,
               :vacation_notifier_disabled

    belongs_to :timing, serializer: TimingIndexSerializer

    def discord_connected
      object.discord_connected?
    end

    def slack_connected
      object.slack_connected?
    end

    def timedoctor_connected
      object.timedoctor_connected?
    end

    def vacations_days_available
      object.available_vacations_days
    end
  end
end
