###
	jspaige\www\js-src\jspaige\emStructDbg.coffee
    
    display emscripten data as C structs
    customize code to define C stracts
    outputs labelled struct data to console.log
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


########### PARSE DEFINITIONS ############
    
structs = {}
structName = struct = null

chkStruct = ->
	if not structName then return
	 
for defLine in struct_defs.split '\n'
	if (line = _.trim defLine) is '' then continue
	if _.startsWith line, 'struct'
		chkStruct()
		struct = []
		structName = _.trim line[6...]
		continue
	if not structName
		console.log 'emStructDbg error: structure name missing -- ', defLine
		break
	member = _.trim line.split(';')[0]
	words = member.split /\s/
	type = null
	for word in words
		if _.startsWith word, '*'
			isPointer = true
			word = word[1...]
		word = _.trim word
		if word is '' or word in noise_words then continue
		
		if not isPointer and not type
			if not (typeDef = typedefs[word])
				console.log 'emStructDbg error: unknown type label', word, ' -- ', defLine
				break
			parmCount = 0
			def = {}
			for part in typeDef.split ','
				if (part = _.trim part) is '' then continue
				switch parmCount
					when 0
						type = part.toLowerCase()
						if type not in ['i8', 'i16', 'i32', 'i64', 'float', 'double']
							console.log 'emStructDbg error: invalid size', type, ' -- ', typeDef
							break
						def.type = type
					when 1
						displaySpec = part.toLowerCase()
						if displaySpec in ['hex','dec']
							 def.display    = displaySpec
						else def.structName = displaySpec
				parmCount++
			if parmCount < 2
				console.log 'emStructDbg error: less than 2 parms in typedef -- ', typeDef
				break
			if struct[structName]
				console.log 'emStructDbg error: duplicate struct name -- ', structName
				break
			struct[structName] = def
			structName = null
chkStruct()

for structName, struct in structs
	if struct.structName and not structs[struct.structName]
		console.log 'emStructDbg warning: undefined struct -- ', struct
		delete struct.structName
		def.display = 'hex'

window.emStruct = () ->
	
		
	
	