require '05_relation'

describe 'Relation' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
      finalize!
    end
  end
  
  it "#where now returns a 'Relation' object" do
    cats = Cat.where(name: 'Breakfast')
    
    expect(cats).to be_instance_of(Relation)
  end
  
  it "Relation returns query when inspected" do
    cats = Cat.where(name: 'Breakfast')
    cat = cats.inspect.first
    
    expect(cat.name).to eq('Breakfast')
  end
  
  it "#where is chainable" do
    cat = Cat.where(owner_id: 3).where(nane: "Markov")
    markov_query = cat.where(name: "Markov")
    markov = markov_query.inspect.first
    
    expect(cat.length).to eq(2)
    expect(markov.name).to eq('Markov')
  end
  
end

