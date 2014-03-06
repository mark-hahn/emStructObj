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

########### FUNCTION TO CONVERT STRUCT TO OBJECT ############
    
addrInc = (size) -> switch size
	when 'i8' 				then 1
	when 'i16' 				then 2
	when 'i32', 'float' 	then 4
	when 'i64', 'double' 	then 8
	
toHex = (val) -> if val < 10 then val else '0x' + val.toString 16
			
exports.emStructObj = emStructObj = exports.emStructToObj = (addr, name, arrayLen) ->
	if typeof addr isnt 'number' or addr < 0 or addr isnt Math.floor addr
		error 'address must be a positive integer', addr
		return
	
	if (type = emdef.typeDefs[name]) and not (typeInc = addrInc type.size)
		error 'invalid size', type.size, 'in type', name
		return
		
	if not type
		if not (struct = structs[name])
			error 'struct', name, 'is not defined'
			return
			
		for member in struct
			[memberType, memberName] = member
			if not (memberTypeDef = emdef.typeDefs[memberType]) or 
			   not addrInc memberTypeDef.size
				error 'invalid size', memberTypeDef.size, 'in member', memberName
				return

	results = []
	for idx in [0...(arrayLen ? 1)]
		if type
			val = getValue addr, type.size
			results.push (if type.format is 'hex' then toHex val else val)
			addr += typeInc
			continue
		
		obj = {}
		for member in struct
			[memberType, memberName] = member
			
			if structs[memberName]
				val = getValue addr, typeDefs.ptr.size
				obj[memberName] = emStructObj val, memberName
				addr += addrInc typeDefs.ptr.size
				continue
				
			memberTypeDef = emdef.typeDefs[memberType]
			val = getValue addr, memberTypeDef.size
			if memberTypeDef.format is 'hex' then val = toHex val
			obj[memberName] = val
			
			addr += addrInc memberTypeDef.size
		
		results.push obj
		
	if arrayLen then results else results[0]


if emdef.useShortcuts then exports.emso = exports.ems2o = exports.emStructObj


########### FUNCTION TO CONVERT OBJECT TO STRUCT ############

exports.emObjToStruct = (obj, addr, name, arrayLen = 1) ->



if emdef.useShortcuts then exports.emo2s = exports.emObjToStruct
	
		
# DEBUG
console.log emdef.typeDefs, structs
#debugger


