{spawn} = require 'child_process'
util = require 'util'

bin_path = './node_modules/.bin'
stream_data_handler = (data) -> util.print data.toString()

compile_app = (callback) ->
    options = [
        '-b'
        '-c'
        '-o'
        '.'
        'coffeescripts/app.coffee'
    ]
    coffee = spawn "#{bin_path}/coffee", options
    coffee.stdout.on 'data', stream_data_handler
    coffee.stderr.on 'data', stream_data_handler
    coffee.on 'exit', (status) -> callback?() if status is 0

build_app = (callback) ->
    compile_app -> callback?()

task 'app', 'make app', ->
    build_app -> 'All done.'
