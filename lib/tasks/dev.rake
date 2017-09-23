desc "Index Rivers"
task :index do
  River.all.index!
end
