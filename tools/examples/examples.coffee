_ = require 'underscore'
fs = require 'fs'
path = require 'path'
{exec} = require 'child_process'

root = path.resolve(__dirname, '../../')

css = fs.readFileSync path.resolve(__dirname, 'res/solarized-dark.css')
template = _.template(fs.readFileSync(path.resolve __dirname, 'res/template.html.jst').toString())
samplesPath = path.resolve(root, './samples')
samples = fs.readdirSync samplesPath
highlight = null  # lazily required

process = (file) ->
  {highlight} = require path.resolve(root, 'build/highlight')

  language = path.extname(file)[1..]
  content = fs.readFileSync path.resolve(samplesPath, file)
  code = highlight(language, content.toString()).value
  html = template {code, css, language}
  htmlPath = path.resolve(root, 'examples', "#{language}.html")
  fs.writeFileSync htmlPath, html

  console.log "#{file} sample processed"


exec "python #{path.resolve __dirname, '../build.py'} -t node", (err, stdout, stderr) ->
  if err?
    console.log stderr
    process.exit 1
  else
    console.log stdout
    fs.mkdir path.resolve(__dirname, '../../examples')
    process sample for sample in samples
