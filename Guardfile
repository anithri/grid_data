notification :libnotify, :timeout => 3, :transient => true, :append => false, hint: "int:transient:1"

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', :cli => "--color --format Fuubar --drb", :version => 2, :notification => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end


module ::Guard
  class Grit < Guard

    def initialize(*args)
      require 'grit'
      require 'term/ansicolor'

      super
      @repo = ::Grit::Repo.new(Dir.pwd)
    end

    def start
      UI.info status_line
    end

    def run_on_change(paths)
      UI.info status_line
    end

    def status_line
      total = @repo.status.files.count
      status_color = case
                       when total == 0
                         ::Term::ANSIColor.green
                       when total < 6
                         ::Term::ANSIColor.yellow
                       else
                         ::Term::ANSIColor.red
                     end
      out = status_color + "Git Status: "
      {changed: [:yellow, '~'], added: [:green, '+'], deleted: [:red, '-'], untracked: [:blue, '?']}.each do |type, options|
        count = @repo.status.send(type).count
        next unless count > 0
        out << [::Term::ANSIColor.send(options[0]), options[1], count, " "].join("")
      end
      out
    end
  end
end

guard 'grit'

