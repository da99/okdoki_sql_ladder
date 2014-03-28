
class On_A_Ladder

  class << self
  end # === class self ===

  def initialize sql
    @ladder = []
    @sql    = sql
  end

  def Ladder
    @ladder
  end

  def Bottom r

    @ladder = @ladder.concat(r.parent_sql)
    @ladder << r
    last_index = @ladder.size - 1
    sqls = []
    @ladder.each_with_index { |v, i|
      sqls << if i == 0 # top
        "SELECT ? as class_id, id, NULL as parent_id
        FROM :klass
        WHERE id in (SELECT parent_id FROM :middle_cte)"
      elsif i != last_index # middle
        "SELECT ? AS class_id, id, ? AS parent_id
        FROM :klass
        WHERE id IN ( SELECT parent_id FROM :bottom_cte )"
      else             # bottom
        "SELECT ? AS class_id, id, ? AS parent_id
        FROM :klass
        WHERE id = ?"
      end
    }

    sqls << I_Dig_Sql.new(sqls.map { |s|
    }.join("UNION")).AS(NEW_NAME)

    self
  end

  def position
    @ladder[0]
  end

end # === class On_A_Ladder ===



