###
	file: emStructObj\emStructObj.coffee
    source code for emStructObj project
    
    convert emscripten C struct data to/from javascript objects
    to be used as debug calls in code or from javascript console
    include it in emscripten as pre-add file
    creates global window.emStruct function
    
    usage:
    	// addr: number, heap byte addr
    	// name: string, name of struct at addr
    	// count: number, record count (defaults to 10)
    	emStruct(addr, name, count)
    
		// example: emStruct(100, 'pgm_globals', 5);
###
    
    
########### LOAD DEPENDENCIES ##########
    
# emdef is created by emStructDefs.js which is customized for each app
# It contains useShortcuts, noiseWords, typeDefs, and structDefs

if exports? and module? and module.exports
	_ = require 'underscore'
	_.mixin require('underscore.string').exports()
	emdef = require 'emStructDefs'
else 
	_ = window._
	_.mixin _.str.exports()
	exports = window
	emdef = emDefinitions
	# underscore and underscore.string must be loaded before this file


########### PARSE STRUCT DEFINITIONS ############
    
structs 	= {}
struct 		= []
structName 	= ''
haveError 	= no

error = (args...) ->
	console.log 'emStructObj error:', args...
	haveError = true

chkStruct = ->
	if structName
		structs[structName] = struct
		struct = []

for defLine in emdef.structDefs.split '\n'
	if (line = _.trim defLine) is '' then continue
	
	if _.startsWith line, 'struct '
		chkStruct()
		structName = _.trim line[7...]
		continue

	if not structName
		error 'struct name missing --', defLine
		break

	words = ( _.trim line.split(';')[0]).split /\s/
	
	memberType = memberName = isPointer = null
	
	wordIdx = 0
	for word in words
		if (ptrMatch = /^\*(.*)$/.exec word)
			isPointer = true
			memberType = 'ptr'
			word = ptrMatch[1]
			
		word = _.trim word
		if word is '' or word in emdef.noiseWords then continue
		
		wordIdx++
		if isPointer then wordIdx++
		
		switch wordIdx 
			when 1
				memberType = word
				typeDef = emdef.typeDefs[memberType]
				if not typeDef then error 'unknown type', memberType, '--', defLine
				
			when 2
				memberName = word
				for member in struct
					if member[1] is memberName
						error 'duplicate member in', structName, '--', defLine
						
				struct.push [memberType, memberName] 
				
			else error 'more than 2 words in member def --', defLine
		
		if haveError then break
	if haveError then break
if haveError then return

chkStruct()

# DEBUG
console.log structs
debugger


########### FUNCTION TO CONVERT STRUCT TO OBJECT ############

exports.emStructObj = exports.emStructToObj = (addr, name, arrayLen = 1) ->


if emdef.useShortcuts then exports.emso = exports.emStructObj


########### FUNCTION TO CONVERT OBJECT TO STRUCT ############

exports.emObjToStruct = (obj, addr, name, arrayLen = 1) ->



if emdef.useShortcuts then exports.emo2s = exports.emObjToStruct
	
		
	
	