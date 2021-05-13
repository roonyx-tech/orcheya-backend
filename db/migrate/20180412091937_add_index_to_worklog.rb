class AddIndexToWorklog < ActiveRecord::Migration[5.1]
  def up
    before = %q{
      create temporary table "twl"
      as (
        select min(id) as "id"
        from "worklogs"
        group by "task_id", "date"
      );

      delete from "worklogs"
      where "worklogs".id not in (
        Select id from "twl"
      );
    }

    after = %q{
      drop table "twl";
    }

    ActiveRecord::Base.connection.execute(before)
    add_index :worklogs, [:task_id, :date], unique: true
    ActiveRecord::Base.connection.execute(after)
  end

  def down
    remove_index :worklogs, [:task_id, :date]
  end
end
