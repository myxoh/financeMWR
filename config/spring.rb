%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/services
  app/lib
).each { |path| Spring.watch(path) }
