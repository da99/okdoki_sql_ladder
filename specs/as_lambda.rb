require "i_dig_sql"

describe ".ladder with lambda params" do

  before do
    class A
      class << self
        def class_id; 1; end
        def table_name; "a"; end
        def parent_sql child
          [ ->(curr, prev) {
            I_Dig_Sql.new("SELECT ? AS class_id, id, NULL AS parent_id
                          FROM #{table_name}
                          WHERE id IN ( SELECT parent_id FROM #{prev.cte} )", class_id)
          } ]
        end
      end # === class self ===
    end

    class B
      class << self
        def class_id; 2; end
        def table_name; "b"; end
        def parent_sql child
          A.parent_sql(self).push ->(curr, prev) {
            I_Dig_Sql.new(
              %$
              SELECT ? AS class_id, id, ? AS parent_id
              FROM #{table_name}
              WHERE id IN ( SELECT parent_id FROM #{prev.cte} )
              $, "a_id"
            )
          }
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
        B.parent_sql(self).push ->(curr, prev) {
          [self, 'b_id']
          I_Dig_Sql.new(%$
            SELECT ? AS class_id, id, ? AS parent_id
            FROM #{self.class.table_name}
            WHERE id = ?
          $, "b_id", id)
        }
      end
    end
  end # === before

  it "turns an array of lambdas into an i_dig_sql" do

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
        SELECT ? AS class_id, id, NULL AS parent_id
        FROM a
        WHERE id IN ( SELECT parent_id FROM c_ladder_1 )
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

end # === describe .ladder with lambda params ===
