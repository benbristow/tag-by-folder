#!/usr/bin/env ruby
Dir.chdir File.expand_path File.dirname(__FILE__)
require 'rubygems'
require 'bundler'
require 'escort'
require 'taglib'

Escort::App.create do |app|
  app.action do |options, arguments|
    abort "No directory path argument provided" if arguments.empty?
    abort "Too many arguments provided (#{arguments.length}/1)" if arguments.length > 1

    directory = arguments[0]
    abort "Directory does not exist" unless File.directory?(directory)

    track_paths = Dir.glob("#{directory}/**/*.mp3")
    abort "No files in directory" if track_paths.empty?

    changes = 0
    track_paths.each do |track_path|
      directory_name = track_path.split('/')[-2]
      TagLib::MPEG::File.open(track_path) do |track|
        tag = track.id3v2_tag
        if tag.genre != directory_name
          puts "> Replacing genre for #{File.basename(track_path)} to #{directory_name}"
          tag.genre = directory_name
          track.save
          changes += 1
        end
      end
    end

    abort "Finished! #{changes} tag changes made overall."
  end
end
