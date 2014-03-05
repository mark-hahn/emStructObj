// Generated by CoffeeScript 1.6.2
/*
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
*/


(function() {
  var chkStruct, def, defLine, displaySpec, isPointer, line, member, parmCount, part, struct, structName, structs, type, typeDef, word, words, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  structs = {};

  structName = struct = null;

  chkStruct = function() {
    if (!structName) {

    }
  };

  _ref = struct_defs.split('\n');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    defLine = _ref[_i];
    if ((line = _.trim(defLine)) === '') {
      continue;
    }
    if (_.startsWith(line, 'struct')) {
      chkStruct();
      struct = [];
      structName = _.trim(line.slice(6));
      continue;
    }
    if (!structName) {
      console.log('emStructDbg error: structure name missing -- ', defLine);
      break;
    }
    member = _.trim(line.split(';')[0]);
    words = member.split(/\s/);
    type = null;
    for (_j = 0, _len1 = words.length; _j < _len1; _j++) {
      word = words[_j];
      if (_.startsWith(word, '*')) {
        isPointer = true;
        word = word.slice(1);
      }
      word = _.trim(word);
      if (word === '' || __indexOf.call(noise_words, word) >= 0) {
        continue;
      }
      if (!isPointer && !type) {
        if (!(typeDef = typedefs[word])) {
          console.log('emStructDbg error: unknown type label', word, ' -- ', defLine);
          break;
        }
        parmCount = 0;
        def = {};
        _ref1 = typeDef.split(',');
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          part = _ref1[_k];
          if ((part = _.trim(part)) === '') {
            continue;
          }
          switch (parmCount) {
            case 0:
              type = part.toLowerCase();
              if (type !== 'i8' && type !== 'i16' && type !== 'i32' && type !== 'i64' && type !== 'float' && type !== 'double') {
                console.log('emStructDbg error: invalid size', type, ' -- ', typeDef);
                break;
              }
              def.type = type;
              break;
            case 1:
              displaySpec = part.toLowerCase();
              if (displaySpec === 'hex' || displaySpec === 'dec') {
                def.display = displaySpec;
              } else {
                def.structName = displaySpec;
              }
          }
          parmCount++;
        }
        if (parmCount < 2) {
          console.log('emStructDbg error: less than 2 parms in typedef -- ', typeDef);
          break;
        }
        if (struct[structName]) {
          console.log('emStructDbg error: duplicate struct name -- ', structName);
          break;
        }
        struct[structName] = def;
        structName = null;
      }
    }
  }

  chkStruct();

  for (struct = _l = 0, _len3 = structs.length; _l < _len3; struct = ++_l) {
    structName = structs[struct];
    if (struct.structName && !structs[struct.structName]) {
      console.log('emStructDbg warning: undefined struct -- ', struct);
      delete struct.structName;
      def.display = 'hex';
    }
  }

  window.emStruct = function() {};

}).call(this);

/*
//@ sourceMappingURL=emStructObj.map
*/