require 'rails/generators/active_record/model/model_generator'
require File.join(File.dirname(__FILE__), '../test_unit/model_generator')
require File.join(File.dirname(__FILE__), '../base')

module RogersScaffold
  module Generators
    class ActiveRecordGenerator < ::ActiveRecord::Generators::ModelGenerator
      include ::RogersScaffold::Base

      source_root superclass.source_root

      hook_for :test_framework, :in => 'rogers_scaffold:model'

      def initialize(args, *options) #:nodoc:
        super
      end

      protected
      def migration_action; 'add'; end
    end
  end
end
