conf     = require './config'
mongoose = require 'mongoose'
db       = mongoose.connect conf.db_url
models   = require './models'

mongoose.connection.on "open",  -> console.log "Connected to Mongo..."
mongoose.connection.on "error", (err, res) -> console.log "An Error occured #{err}"

people = [{
  first_name: "Suvajit"
  last_name:  "Gupta"
  email: "suvajit.gupta@eloqua.com"
},{
  first_name: "Josh"
  last_name: "Holt"
  email: "josh.holt@eloqua.com"
}]

add_person = (person) ->
  p = new models.Person person
  p.save (err) ->
    console.log err if err

print_person = (doc) ->
  console.log "********************************************************************************"
  console.log "#{doc.first_name} #{doc.last_name}"
  console.log "#{doc.email}"
  console.log "********************************************************************************"

print_people = (err, docs) ->
  print_person doc for doc in docs
  mongoose.disconnect()

seed_people = -> add_person person for person in people

models.Person.find {}, (err, docs) ->
  return console.log err if err
  if docs is null || docs.length is 0
    console.log "Seeding with 2 people..."
    seed_people()
  else
    print_people err, docs
