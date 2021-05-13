class AddPlatformToProject < ActiveRecord::Migration[5.1]


  def up
    add_column :projects, :platform, :integer


    Project.all.each do |project|
      project.platform = Project.platforms[:timedoctor]

      project.save
    end
  end

  def down
    remove_column :projects, :platform, :integer
  end
end
