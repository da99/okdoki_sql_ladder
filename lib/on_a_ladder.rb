
class About_Arr

  class << self

    def Back arr
      size = arr.size
      arr.reverse.each_with_index { |v, i|
        real_index = (size - 1) - i
        next_meta  =
        prev_meta  =
        meta.val = v
        meta.index = real_index
        meta.i     = i
        meta.next  = next_meta
        meta.prev  = prev_meta

        meta.fin
        yield meta.val, meta.index, meta
      }
    end

    def Forward arr
      size = arr.size
      arr.each_with_index { |v, i|
        meta = About_Arr.Meta.new
        real_index   = i
        next_meta    =
        prev_meta    =
        meta.val    = v
        meta.index  = real_index
        meta.i      = i
        meta.next   = next_meta
        meta.prev   = prev_meta

        meta.fin
        yield meta.val, meta.index, meta
      }
    end

  end # === class self ===

  class Meta

    def initialize
      @is_fin = false
    end

    [
      :real_index,
      :last_index,
      :next_meta, :prev_meta,
      :val, :index, :i, :next, :prev
    ].each { |v|
      eval %~
        def #{v}
          @#{v}
        end

        def #{v}= o
          raise "No more values can be set after .fin is called" if @is_fin
          @#{v} = o
          return o
        end
      ~
    }

    def fin
      @is_fin = true
      self
    end

    def top?
      real_index == 0
    end

    def middle?
      real_index != 0 && real_index != last_index
    end

    def bottom?
      real_index == last_index
    end

  end # === class Meta ===

end # === class About_Arr ===

module On_A_Ladder

  def ladder o
    s = self
    tag = "#{o.class.to_s.downcase} ladder tag"
    curr = o.parent_sql
    sqls = [curr]
    while (curr = curr.parent_sql) do
      sqls.unshift curr
    end

    # ---------------------------------------------------
    About_Seq.Back(sqls) { |v, i, meta|
      cte_table_name      = "#{o.class.to_s.downcase}_ladder_#{i}"

      new_sql = case v
                when I_Dig_Sql
                  v.update_table_or_sql(cte_table_name)
                when Array
                  klass = v.first
                  fkey = v[1] || 'parent_id'

                  if meta.first? # TOP
                    I_Dig_Sql.new("SELECT ? as class_id, id, NULL as parent_id
                      FROM #{klass.table_name}
                      WHERE id in (SELECT parent_id FROM #{meta.prev[:cte_table_name]})", klass.class_id)

                  elsif meta.middle? # MIDDLE
                    I_Dig_Sql.new("SELECT ? AS class_id, id, ? AS parent_id
                      FROM #{klass.table_name}
                      WHERE id IN ( SELECT parent_id FROM #{meta.prev[:cte_table_name]} )", klass.class_id, fkey)

                  else meta.bottom? # BOTTOM
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
    # ---------------------------------------------------

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







