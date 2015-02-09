require 'rails/generators/test_unit/helper/helper_generator'
require File.join(File.dirname(__FILE__), '../base')

module RogersScaffold
  module Generators
    module Helper
      class TestUnitGenerator < ::TestUnit::Generators::HelperGenerator
        include ::RogersScaffold::Base

        source_root superclass.source_root
      end
    end
  end
end
