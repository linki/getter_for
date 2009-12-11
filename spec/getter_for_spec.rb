require File.join(File.dirname(__FILE__), "/spec_helper")

describe GetterFor do
  describe "getter" do
    class Model
      include GetterFor
    end
    
    it "should respond to :getter_for" do
      Model.should respond_to(:getter_for)
    end
    
    it "should require a parameter" do
      lambda {
        Model.send :getter_for
      }.should raise_error(ArgumentError)
    end

    it "should require a hash" do
      lambda {
        Model.send :getter_for, []
      }.should raise_error(ArgumentError)
    end
    
    it "should have either a symbol or string or an array of symbols or strings as key" do
      lambda {
        Model.send :getter_for, { :attr => :attr }
      }.should_not raise_error(ArgumentError)      

      lambda {
        Model.send :getter_for, { 'attr' => :attr }
      }.should_not raise_error(ArgumentError)      

      lambda {
        Model.send :getter_for, { [:user, 'category'] => :attr }
      }.should_not raise_error(ArgumentError)      
    end
    
    it "should raise an error if key is not a symbol, string or array of symbols or strings" do
      lambda {
        Model.send :getter_for, { 1 => :attr }
      }.should raise_error(ArgumentError)

      lambda {
        Model.send :getter_for, { [:attr, 2] => :attr }
      }.should raise_error(ArgumentError)
    end
    
    it "should have either a symbol or string or an array of symbols or strings as value" do
      lambda {
        Model.send :getter_for, { :attr => 'attr' }
      }.should_not raise_error(ArgumentError)      

      lambda {
        Model.send :getter_for, { :attr => :attr }
      }.should_not raise_error(ArgumentError)      


      lambda {
        Model.send :getter_for, { :attr => [:name, 'synomym'] }
      }.should_not raise_error(ArgumentError)      
    end
    
    it "should raise an error if value is not a symbol, string or array of symbols or strings" do
      lambda {
        Model.send :getter_for, { :attr => 1 }
      }.should raise_error(ArgumentError)

      lambda {
        Model.send :getter_for, { :attr => [:attr, 2] }
      }.should raise_error(ArgumentError)      
    end
    
    class Ticket
      include GetterFor
      getter_for :user => :name
    end

    it "should respond to :user_name" do
      ticket = Ticket.new      
      ticket.should respond_to(:user_name)
    end
    
    it "should return the user's name" do
      ticket, user = [Ticket, Object].map(&:new)
      user.expects(:name).returns('Han Solo')
      ticket.expects(:user).twice.returns(user)
      ticket.user_name.should == 'Han Solo'      
    end
    
    it "should return nil if user is nil" do
      ticket = Ticket.new
      ticket.expects(:user).returns(nil)
      ticket.user_name.should == nil
    end
    
    it "should raise an error if user does not respond to :name" do
      ticket, user = [Ticket, Object].map(&:new)
      ticket.expects(:user).twice.returns(user)
      lambda {
        ticket.user_name
      }.should raise_error(NoMethodError)
    end

    class Product
      include GetterFor
      getter_for 'manufactory' => 'name'
    end

    it "should accept strings" do
      product, manufactory = [Product, Object].map(&:new)
      manufactory.expects(:name).returns('Death Star')
      product.expects(:manufactory).twice.returns(manufactory)
      product.manufactory_name.should == 'Death Star'      
    end

    class Issue
      include GetterFor
      getter_for :user => :name, :assignee => :email
    end
    
    it "should take multiple arguments" do
      issue = Issue.new
      issue.should respond_to(:user_name)
      issue.should respond_to(:assignee_email)      
    end

    class Package
      include GetterFor
      getter_for :carrier => [:name, :email]
      getter_for [:category, :sender] => :name
      getter_for [:location, :destination] => [:name, :description]
    end

    it "should accept collection of keys and values" do
      package = Package.new
      [:carrier_name, :carrier_email, :category_name, :sender_name,
       :location_name, :location_description, :destination_name, :destination_description].each do |attribute|
         package.should respond_to(attribute)
      end
    end
    
    class Fancy
      include GetterFor
      getter_for :user => :name, :user_name => :downcase
    end
    
    it "should work fancy" do
      fancy, name = [Fancy, Object].map(&:new)
      name.expects(:downcase).returns('han solo')
      fancy.expects(:user_name).twice.returns(name)
      fancy.user_name_downcase.should == 'han solo'      
    end
    
    class User
      include GetterFor
      getter_for :department => :name
    end

    class Comment
      include GetterFor
      getter_for :user => :department_name
    end
    
    it "should work nested" do
      comment, user, department = [Comment, User, Object].map(&:new)
      department.expects(:name).returns('Development')
      user.expects(:department).twice.returns(department)
      comment.expects(:user).twice.returns(user)
      comment.user_department_name.should == 'Development'      
    end    
    
  end
end
