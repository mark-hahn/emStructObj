###
    C definitions javascript module for enStructObj project
    
    This file contains definitions for C variables and C structs
    It should be customized for your C application
    This particular file is used in a production project and can be considered a sample
    
    This module should be included before the emStructObj module in a browser
    For node, require this module.
###
 
isNode = exports? and module? and module.exports

if isNode
	 _ = require 'underscore'
else exports = window

# all struct member lines containing * are considered a pointer
pointer_size = "i32"

# type definitions 
# first param is emscription getValue and setValue type ...
# 		i8, i16, i32, i64, float, or double
# second param is hex, dec, or name of struct
typedefs =
	short:				'i16, hex'
	pg_short_t:			'i16, hex'
	pg_error:			'i16, dec'
	long:				'i32, hex'
	pg_handle:			'i32, hex'
	master_list_ptr:	'i32, hex'
	mem_debug_proc:		'i32, hex'
	purge_proc:			'i32, hex'
	free_memory_proc: 	'i32, hex'
	memory_ref:			'i32, hex'
	pg_fail_info_ptr: 	'i32, hex'
	pg_error_handler:	'i32, hex'
	
# These words are ignored (void isn't needed since all * are pointers to anything).
noise_words = ['PG_FAR', 'void']

# All struct defininitions must be here.
# Lines that start with "struct" start a struct definition
# Each member must be on it's own line.  Everything past the semicolon is ignored.

struct_defs = """

struct pgm_globals
	short					signature;			/* Used for checking/debugging */
	pg_short_t				debug_flags;		/* Debug mode, if any */
	pg_handle				master_handle;		/* HANDLE for master list (Windows only) */
	pg_handle				spare_tire;			/* Used to free up some memory in tight situations */
	master_list_ptr			master_list;		/* Contains list of all active memory_refs */
	long					next_master;		/* Next available space in master_list */
	long					total_unpurged;		/* Total # of bytes allocated not purged */
	long					max_memory;			/* Maximum memory (set by app) */
	long					purge_threshold;	/* Amount extra to purge */
	void PG_FAR				*machine_var;		/* Machine-specific generic ptr */
	mem_debug_proc			debug_proc;			/* Called when a bug is detected */
	purge_proc				purge;				/* Called to purge/unpurge memory */
	free_memory_proc		free_memory;		/* Called to free up miscellaneous memory */
	long					purge_ref_con;		/* Reference for purge proc */
	memory_ref				purge_info;			/* Machine-based purge information */
	memory_ref				freemem_info;		/* List of pg_ref(s) for cache feature (2.0) */
	long					next_mem_id;		/* Used for unique ID's assigned to refs */
	long					current_id;			/* ID to use for MemoryAlloc's */
	long					active_id;			/* Which ID to suppress, if any, for purging */
	long					last_message;		/* Last message in exception handling */
	pg_fail_info_ptr		top_fail_info;		/* Current exception in linked list */
	void PG_FAR *			last_ref;			/* Last reference - used by external failure processing TRS/OITC */
	pg_error_handler		last_handler;		/* Last app handler before Paige */
	pg_error				last_error;			/* Last reported error */
	memory_ref				debug_check;		/* Used for special-case debugging */
	memory_ref				dispose_check;		/* Used for special-case debugging on DisposeMemory */
	short					debug_access;		/* Used with above field */
	void PG_FAR				*app_globals;		/* Ptr to globals for PAIGE, etc. */
	long					creator;			/* For Mac file I/O */
	long					fileType;			/* For Mac file I/O */

"""  
