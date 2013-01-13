# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'scrolls/rails/version'

Gem::Specification.new do |s|
  s.name     = 'scrolls-rails'
  s.version  = Scrolls::Rails::VERSION
  s.authors  = ['Chris Lloyd']
  s.email    = ['christopher.lloyd@gmail.com']
  s.homepage = 'https://github.com/minefold/scrolls-rails'
  s.summary  = "Tools for using Scrolls logger in Rails"

  s.files = %w(README.md Rakefile Gemfile) + Dir['{lib,spec}/**/*']

  s.require_paths = ['lib']

  s.add_runtime_dependency 'scrolls'
  s.add_runtime_dependency 'rails'
end
