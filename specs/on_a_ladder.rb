
class A
end

class B
end

class B1
end

class B2
end

class B3
end

class C
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

