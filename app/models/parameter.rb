# frozen_string_literal: true

class Parameter
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :id, :string
  attribute :name, :string
  attribute :hint, :string

  validates :id, presence: true
  validates :name, presence: true

  def initialize(attrs)
    attrs = ActiveSupport::HashWithIndifferentAccess.new(attrs)
    filtered_attrs = self.class.attribute_names.map { |name| [name, attrs[name]] }.to_h

    super(filtered_attrs)
  end

  def type
    self.class.type
  end

  def persisted?
    false
  end

  class << self
    def type
      model_name.element
    end

    def for_type(params)
      all.find { |c| c.type == params["type"] }
    end

    def all
      [Parameter::Constant, Parameter::Input, Parameter::Select,
       Parameter::Multiselect, Parameter::Date, Parameter::Range,
       Parameter::QuantityPrice]
    end
  end

  class Array
    class << self
      def load(hsh)
        hsh&.map { |params| Parameter.for_type(params).load(params) }
      end

      def dump(list)
        list&.map { |parameter| parameter.dump }
      end
    end
  end
end
