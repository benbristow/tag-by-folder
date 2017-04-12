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

    puts "> Scanning #{directory} for MP3 files and checking genres..."
    track_paths = Dir.glob("#{directory}/**/*.mp3")
    abort "No files in directory" if track_paths.empty?

    changes = 0
    track_paths.each do |track_path|
      open_track(track_path) do |track, tag|
        if track_genre(track) != intended_genre(track_path)
          replace_genre(track, intended_genre(track_path))
        end
      end
    end

    abort "Finished! #{changes} tag changes made overall."
  end

  private

  def open_track(track_path)
    TagLib::MPEG::File.open(track_path) do |track|
      yield track
    end
  end

  def track_genre(track)
    track.tag.genre
  end

  def intended_genre(track_path)
    track_path.split('/')[-2]
  end

  def replace_genre(track, genre)
    track.tag.genre = genre
    track.save
    puts "Set #{track.tag.title}'s genre to #{genre}"
  end
end
