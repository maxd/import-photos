#!/usr/bin/env ruby -I. -Iapp

require 'rubygems'
require 'bundler/setup'
require 'sequel'

config = YAML.load_file(File.expand_path('../config/database.yml', __FILE__))
DATABASE = Sequel.connect(config)

require 'application'
Application.new.run