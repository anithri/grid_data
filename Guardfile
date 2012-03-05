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
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  callback(:run_all_end) {|*args| puts "*" * 30 + "\n" + "WOOT #{args.inspect}"}
  callback(:run_on_change_end) {|*args| puts "*" * 30 + "\n" + "WOOT #{args.inspect}"}
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
      out = ""
      total = 0
      {changed: [:yellow, '~'], added: [:green, '+'], deleted: [:red, '-'], untracked: [:blue, '?']}.each do |type, options|
        count = @repo.status.send(type).count
        next unless count > 0
        total += count
        out << [::Term::ANSIColor.send(options[0]), options[1], count, Term::ANSIColor.reset, " "].join("")
      end
      status_color = case
                       when total == 0
                         ::Term::ANSIColor.green
                       when total < 6
                         ::Term::ANSIColor.yellow
                       else
                         ::Term::ANSIColor.red
                     end
      out = out.empty? ? "Clean!" : out
      status_color + "Git Status: " + ::Term::ANSIColor.reset + out
    end
  end
end

guard 'grit' do
  watch(%r(\.*))
end

