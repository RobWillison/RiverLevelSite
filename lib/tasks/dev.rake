desc "Index Rivers"
task index: [:environment] do
  River.all.index!
end
