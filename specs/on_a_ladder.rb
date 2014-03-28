
class A
  class << self
    def parent
    end
  end
end

class B
  class << self
    def parent
      A
    end
    def parent_id
      :top_id
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
    self.class.parent_sql( 
                          I_Dig_Sql.new.WITH(
                            I_Dig_Sql.new
                            .SELECT("? AS class_id, ? AS parent_id", self.class_id, parent_id)
                            .FROM(self.class.table_name)
                            .WHERE(:id, id)
                            .AS("#{self.class.to_s.downcas}_cte")
                          )
                         )
  end
end

def keys k
  k.map { |v| v[:class] }
end

def parents ladder
  ladder.map { |k| k[:parent] }
end

describe ".Top" do

  it "saves class" do
    o = On_A_Ladder.new
    .Top(A)
    .Top(B)

    keys(o.Ladder).should == [A, B]
  end

  it "sets :parent to nil" do
    o = On_A_Ladder.new
    .Top(A)
    .Top(B)

    parents(o.Ladder).should == [nil, nil]
  end

end # === describe on_a_ladder ===

describe ".Down" do

  it "saves class" do
    o = On_A_Ladder.new
    .Top(A)
    .Down(B)
    .Down(C)

    keys(o.Ladder).should == [A, B, C]
  end

  it "sets :parent to previous entry" do
    o = On_A_Ladder.new
    .Top(A)
    .Down(B)
    .Down(C)

    parents(o.Ladder).should == [nil, A, B]
  end

end # === describe .Down ===

