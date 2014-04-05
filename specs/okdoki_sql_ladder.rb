require "i_dig_sql"

def common o
  case o
  when I_Dig_Sql
    common(o.to_sql[:sql])
  else
    o.split.join(" ")
  end
end

describe ".ladder" do

  it "turns an array of class/fkeys into an i_dig_sql" do
    class A
      def class_id; 1; end
      class << self
        def table_name; "a"; end
        def parent_sql child
          [[self, nil]]
        end
      end # === class self ===
    end

    class B
      class << self
        def table_name; "b"; end
        def class_id; 2; end
        def parent_sql child
          A.parent_sql(self).push [self, "a_id"]
        end
      end # === class self ===

    end

    class C
      include Okdoki_Sql_Ladder
      class << self
        def table_name; "c"; end
        def class_id; 3; end
      end # === class self ===

      def id; 1000; end

      def parent_sql
        B.parent_sql(self).push [self, 'b_id']
      end
    end

    sql = C.new.ladder
    common(sql).should == common("WITH")
  end

end # === describe okdoki_sql_ladder ===


