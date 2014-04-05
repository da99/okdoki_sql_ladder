
class A
  class << self
    def parent_sql sql
      [I_Dig_Sql.new(%~
       SELECT  ? AS class_id, id, NULL AS parent_id
       FROM a
       WHERE id IN ( SELECT parent_id FROM with_b )
       ~, 1).AS('with_b')]
    end
  end
end

class B
  class << self
    def parent_sql sql
      A.parent_sql.push I_Dig_Sql.new(%~
        SELECT ? AS class_id, id, ? AS parent_id
        FROM b
        WHERE id IN ( SELECT parent_id FROM with_c )
      ~, 2, 'a_id').AS("with_c")
    end
  end
end

class B1
  class << self
    def parent
      B
    end
    def parent_id
      :id
    end
  end
end

class B2
  class << self
    def parent
      B1
    end
    def parent_id
      :id
    end
  end
end

class B3
  class << self
    def parent
      B2
    end
    def parent_id
      :id
    end
  end
end

class C
  class << self
    def parent
      B
    end
    def parent_id
      :mid_id
    end
  end

  def parent_sql
    B.parent_sql.push I_Dig_Sql.new(
      %~
        SELECT ? AS class_id, ? AS id, ? AS parent_id
      ~, 3, parent_id, id
    ).AS('with_c')
  end
end

def keys k
  k.map { |v| v[:class] }
end

def parents ladder
  ladder.map { |k| k[:parent] }
end



