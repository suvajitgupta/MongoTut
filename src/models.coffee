mongoose	= require 'mongoose'
Schema    = mongoose.Schema

age_validator = (v)->
  return v > 0 and v < 100

personSchema = new Schema
	first_name: String
	last_name:  String
	email:			String
	age:        { type: Number, validate: [ age_validator, 'age must be in range 0-100' ] }
	createdAt:  Date
	updatedAt:  Date
	
state_validator = (v)->
  return v.length is 2

buildingSchema = new Schema
  name:           String
  description:    String
  address:        String
  state:          { type: String, validate: [ state_validator, 'state must be 2 chars' ] }
  squareFootage:  Number

Person    = mongoose.model "person", personSchema
Building  = mongoose.model "building", buildingSchema

module.exports = { Person, Building }