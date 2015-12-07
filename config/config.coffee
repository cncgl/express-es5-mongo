path     = require 'path'
rootPath = path.normalize __dirname + '/..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'express-es5'
    port: 3000
    db: 'mongodb://localhost/express-es5-development'

  test:
    root: rootPath
    app:
      name: 'express-es5'
    port: 3000
    db: 'mongodb://localhost/express-es5-test'

  production:
    root: rootPath
    app:
      name: 'express-es5'
    port: 3000
    db: 'mongodb://localhost/express-es5-production'

module.exports = config[env]
