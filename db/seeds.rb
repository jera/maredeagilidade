Course.create!(:name => 'FAN4SCRUM', :date => 'de 18 a 20 de Maio das 8:00 as 12:00', :price => 300.00, 
  :instructor => Instructor.create(:name => 'Paulo Vasconcelos', :company => 'Finito', 
    :username => 'finito', :password => 'secret'))
Course.create!(:name => 'Domain Driven Design', :date => 'de 18 a 20 de Maio das 14:00 as 18:00', :price => 300.00, 
  :instructor => Instructor.create(:name => 'Felipe Rodrigues', :company => 'Crafters', 
    :username => 'crafters', :password => 'secret'))
Course.create!(:name => 'Arquitetura e Design de Projetos Java', :date => '23 e 24 de Maio das 8:00 as 18:00', 
  :price => 350.00, :instructor => Instructor.create(:name => 'Paulo Silveira', 
    :company => 'Caelum', :username => 'caelum', :password => 'secret'))
Course.create!(:name => 'Palestras', :date => '21 de Maio das 8:00 as 18:00', 
  :price => 30.00, :instructor => nil)