class SanitizeUpdates < ActiveRecord::Migration[5.1]
  def up
    Update.where('made LIKE \'%<%\' OR planning LIKE \'%<%\' OR issues LIKE \'%<%\'').find_each do |update|
      update.update id: update.id
    end
  end

  def down; end
end
