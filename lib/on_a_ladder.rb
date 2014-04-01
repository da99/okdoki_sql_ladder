
module On_A_Ladder

  def ladder o
    s = self
    tag = "#{o.class.to_s.downcase} ladder tag"
    curr = o.parent_sql
    sqls = [curr]
    while (curr = curr.parent_sql) do
      sqls.push curr
    end

    last_index = sqls.length - 1

    sqls.each_with_index { |v, i|

      cte_table_name      = "#{o.class.to_s.downcase}_ladder_#{i-last_index}"
      prev_cte_table_name = "#{o.class.to_s.downcase}_ladder_#{i-last_index-1}"
      prev                = sqls[i-1]

      new_sql = case v
                when I_Dig_Sql
                  v.update_table_or_sql(cte_table_name)
                when Array
                  klass = v.first
                  fkey = v[1] || 'parent_id'

                  if i == last_index # TOP
                    I_Dig_Sql.new("SELECT ? as class_id, id, NULL as parent_id
                      FROM #{klass.table_name}
                      WHERE id in (SELECT parent_id FROM #{prev_cte_table_name})", klass.class_id)

                  elsif i != last_index && i != 0 # MIDDLE
                    I_Dig_Sql.new("SELECT ? AS class_id, id, ? AS parent_id
                      FROM #{klass.table_name}
                      WHERE id IN ( SELECT parent_id FROM #{prev_cte_table_name} )", klass.class_id, fkey)

                  else i == 0 # BOTTOM
                    I_Dig_Sql.new("SELECT ? AS class_id, id, ? AS parent_id
                      FROM #{klass.table_name}
                      WHERE id = ?", klass.class_id, fkey, o.id)
                  end
                when String
                  I_Dig_Sql.new(v)
                end

      raise "Unknown type: #{v.inspect}" unless new_sql

      new_sql.tag_as(tag)
      new_sql
    }

    self.WITH(
      I_Dig_Sql.new(sqls.find_tagged(tag).map { |s| 
        "SELECT * FROM #{s.AS}"
      }
      .join("UNION"))
      .AS("#{o.class.to_s.downcase}_ladder_sql")
    )

    self
  end

end # === module On_A_Ladder ===







