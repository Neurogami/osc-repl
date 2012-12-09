require 'rake/testtask'


begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'osc-repl'
  authors  'James Britt / Neurogami'
  email    'james@neurogami.com'
  url      'http://code.neurogami.com'
  depends_on ['osc-ruby']
}




Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end


