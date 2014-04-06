
require "about_pos"

module Okdoki_Sql_Ladder

  Curr = Struct.new(:cte)
  Prev = Struct.new(:cte)

  def ladder_sql
    o = self
    tag = "#{o.class.to_s.downcase} ladder tag"

    # === Get parents array:
    sqls = o.parent_sql
    i_dig_sql = I_Dig_Sql.new

    # === Turn parent array into sql array:
    About_Pos.Back(sqls) { |v, i, meta|
      cte_table_name = meta[:cte_table_name] = "#{o.class.to_s.downcase}_ladder_#{i}" 

      with_sql = case v

                 when Proc
                   v
                   .call(Curr.new(cte_table_name), Prev.new(meta.prev? ? meta.prev[:cte_table_name] : nil))
                   .AS(cte_table_name)

                 when Array
                   klass = if meta.bottom?
                             v.first.class
                           else
                             v.first
                           end
                   fkey = v[1] || 'parent_id'

                   if meta.top? # TOP
                     I_Dig_Sql.new("SELECT ? as class_id, id, NULL as parent_id
                      FROM #{klass.table_name}
                      WHERE id in ( SELECT parent_id FROM #{meta.prev[:cte_table_name]} )", klass.class_id)
                     .AS(cte_table_name)

                   elsif meta.middle? # MIDDLE
                     I_Dig_Sql.new("SELECT ? AS class_id, id, ? AS parent_id
                      FROM #{klass.table_name}
                      WHERE id IN ( SELECT parent_id FROM #{meta.prev[:cte_table_name]} )", klass.class_id, fkey)
                     .AS(cte_table_name)

                   else meta.bottom? # BOTTOM
                     I_Dig_Sql.new("SELECT ? AS class_id, id, ? AS parent_id
                      FROM #{klass.table_name}
                      WHERE id = ?", klass.class_id, fkey, o.id)
                     .AS(cte_table_name)
                   end
                 else
                   raise "Unknown type for sql: #{v.inspect}"
                 end

      i_dig_sql.WITH(with_sql).tag_as(tag)
    }
    # ---------------------------------------------------

    i_dig_sql.WITH(
      I_Dig_Sql.new(
        i_dig_sql
        .find_tagged(tag)
        .map { |s| "SELECT * FROM #{s.AS}" }
        .join("\nUNION\n")
      )
      .AS("#{o.class.to_s.downcase}_ladder_sql")
    )

    i_dig_sql
  end

end # === module Okdoki_Sql_Ladder ===







