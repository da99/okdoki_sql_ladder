
describe ".ladder_sql with Array params" do

  before do

    class A

      class << self
        def class_id; 1; end
        def table_name; "a"; end
        def parent_sql child
          [[self, nil]]
        end
      end # === class self ===

    end

    class B

      class << self
        def class_id; 2; end
        def table_name; "b"; end
        def parent_sql child
          A.parent_sql(self).push [self, "a_id"]
        end
      end # === class self ===

    end

    class C

      class << self
        def class_id; 3; end
        def table_name; "c"; end
      end # === class self ===

      def id; 3; end

      def parent_sql
        B.parent_sql(self).push [self, 'b_id']
      end

    end
  end # === before

  it "turns an array of class/fkeys into an i_dig_sql" do

    sql = Okdoki_Sql_Ladder(C.new)

    common(sql).should == common(%~
      WITH c_ladder_2 AS (
        SELECT ? AS class_id, id, ? AS parent_id
        FROM c
        WHERE id = ?
      )
      ,
      c_ladder_1 AS (
        SELECT ? AS class_id, id, ? AS parent_id
        FROM b
        WHERE id IN ( SELECT parent_id FROM c_ladder_2 )
      )
      ,
      c_ladder_0 AS (
        SELECT ? as class_id, id, NULL as parent_id
        FROM a
        WHERE id in ( SELECT parent_id FROM c_ladder_1 )
      )
      ,
      c_ladder_sql AS (
        SELECT * FROM c_ladder_2
          UNION
        SELECT * FROM c_ladder_1
          UNION
        SELECT * FROM c_ladder_0
      )
    ~)
  end

  it "passes all args to final i_dig_sql return value" do
    sql = Okdoki_Sql_Ladder(C.new)
    args(sql).should == [
      C.class_id, "b_id", C.new.id,
      B.class_id, "a_id",
      A.class_id
    ]
  end

end # === describe .ladder with Array params ===


