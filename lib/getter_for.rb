module GetterFor
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def getter_for(arguments)
      raise ArgumentError unless arguments.kind_of?(Hash)
      
      arguments.each do |models, methods|
        [models, methods].each do |attributes|
          raise ArgumentError unless [Array, Symbol, String].inject(false) { |bool, klass| bool || attributes.kind_of?(klass) }
          attributes.kind_of?(Array) && attributes.each do |attribute|
            raise ArgumentError unless [Symbol, String].inject(false) { |bool, klass| bool || attribute.kind_of?(klass) }
          end
        end
        
        models  = [models]  unless models.kind_of?(Array)
        methods = [methods] unless methods.kind_of?(Array)
        
        models.each do |model|          
          methods.each do |method|
            define_method "#{model}_#{method}" do
              send(model).send(method) if send(model)
            end
          end
        end
      end
    end
  end
end