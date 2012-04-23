config     = require './config'
mongoose = require 'mongoose'
db       = mongoose.connect config.db_url
models   = require './models'
counter  = 0

mongoose.connection.on "open", -> console.log "Connected to Mongooose..."
mongoose.connection.on "error", (err, res) -> console.log "Mongoose error occured: #{err}"

people = [
  first_name: "Suvajit"
  last_name:  "Gupta"
  email: "suvajit.gupta@eloqua.com"
  age: 44
,
  first_name: "Josh"
  last_name: "Holt"
  email: "josh.holt@eloqua.com"
  age: 30
]

add_person = (person, callback) ->
  p = new models.Person person
  p.save (err) ->
    callback()
    if err
      console.log err
      return err
    else
      return p

update_callback = (docs)->
  (err, numAffected) ->
    print_people docs if ++counter == people.length
  
update_person = (person, callback) ->
  models.Person.update {first_name: person.first_name}, {age: 99, createdAt: new Date, updatedAt: new Date}, null, callback
  
print_person = (doc) ->
  console.log "********************************************************************************"
  console.log "#{key}: #{value}" for own key, value of doc.toObject()
  console.log "********************************************************************************"

print_people = (docs) ->
  print_person doc for doc in docs
  mongoose.disconnect()

destroy_person = (person) ->
  models.Person.remove {first_name: person.first_name}, (err)->
    console.log "#{person.first_name} deleted" if not err
    mongoose.disconnect()
  
done = ->
  mongoose.disconnect() if ++counter == people.length
  
seed_people = (done) -> add_person person, done for person in people

models.Person.find {}, (err, docs) ->
  return console.log err if err
  if docs is null || docs.length is 0
    console.log "Seeding with #{people.length} people..."
    seed_people done
  else
    destroy_person docs[0]
    # update_person person, update_callback(docs) for person in docs
