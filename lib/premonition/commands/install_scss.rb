# frozen_string_literal: true

require 'net/http'

module Jekyll
  module Premonition
    class InstallScssCommand < Jekyll::Command
      class << self
        def init_with_program(prog)
          prog.command(:"premonition-install") do |c|
            c.syntax 'premonition-install [options]'
            c.description 'Install Premonition SASS stylesheet into your Jekyll site.'
            c.option 'dest', '-d DEST', 'Where premonition.scss should be stored. (defaults to _sass/)'
            c.option 'main', '-m DEST', 'The path to your main SASS file (defaults to assets/main.scss)'
            c.action do |args, opts|
              Jekyll::Premonition::InstallScssCommand.process(args, opts)
            end
          end
        end

        def process(_args, opts)
          begin
            puts '== Installing Premonition Stylesheet and resources =="'
            puts '-- premonition.scss --'
            dest = opts['dest'].nil? || opts['dest'].empty? ? './_sass/' : File.join(opts['dest'], '')
            main = opts['main'].nil? || opts['main'].empty? ? './assets/main.scss' : opts['main']
            raise StandardError, "#{dest} folder does not exist" unless Dir.exist?(dest)
            raise StandardError, "#{main} does not exist" unless File.exist?(main)

            uri = URI('https://raw.githubusercontent.com/lazee/premonition/master/stylesheet/premonition.scss')
            pf = "#{dest}premonition.scss"

            if File.exist?(pf)
              print "You already have #{pf} installed. Continue? [Y/n]"
              override = gets.chomp
              raise StandardError, "Aborted. No harm done." if override == 'n'
            end

            File.write(pf, Net::HTTP.get(uri))
            puts "Saved stylesheet in #{pf}"

            if File.readlines(main).grep(/\@import \"premonition\"/).any?
              puts "#{main} already imports the Premonition stylesheet."
            else
              puts 'You must add Premonition to your main SASS file.'
              print "Add '@import \"premonition\";' to end of #{main} now? [Y/n] "
              add = gets.chomp
              if add == 'n'
                puts 'Ok. But then you will need to add it manually for the styling of Premonition to work.'
              else
                f = File.open(main, 'a')
                f.write("\n@import \"premonition\";\n")
                f.close
                puts "Added Premonition stylesheet to #{main}."
              end
            end

          rescue StandardError => msg
            puts "ERROR: #{msg}"
          end
        end
      end
    end
  end
end
