module UserModule
  def search_skills
    skills = []
    params.dig(:tags).each do |tag|
      skills.concat(Skill.where(
        'title ilike :tag or variants ~* :variants',
        tag: tag, variants: "(^#{tag}|[\s,]#{tag})(,|$)"
      ).pluck(:id))
    end
    skills
  end

  def week_stats(date)
    week_begin = date.at_beginning_of_week
    week_end = date.at_end_of_week
    minutes = @user.worklogs.where(date: week_begin..week_end).sum(:length) / 60
    {
      begin: week_begin,
      end: week_end,
      minutes: minutes
    }
  end

  def month_stats(date)
    month_begin = date.at_beginning_of_month
    month_end = date.at_end_of_month
    minutes = @user.worklogs.where(date: month_begin..month_end).sum(:length) / 60
    {
      name: month_begin.strftime('%B'),
      minutes: minutes
    }
  end

  def generate_timegraph
    updates.merge(worklogs).keys.map do |day|
      {
        date: day,
        time: worklogs[day] || 0,
        update: params[:update] == 'true' ? updates[day] || false : false
      }
    end
  end

  def updates
    @updates ||= @user.updates
                      .map { |x| { x.date.to_date => true } }
                      .reduce({}, :merge)
  end

  def worklogs
    logs = @user.worklogs.where(date: params[:start_date]..params[:end_date], source: source)
    logs = logs.joins(:project).where(projects: { paid: params[:paid] }) if params[:paid].present?

    @worklogs ||= logs.group(:date)
                      .sum(:length)
                      .map { |date, time| { date => time / 60 } }
                      .reduce({}, :merge)
  end
end
