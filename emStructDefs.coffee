###
    C definitions javascript module for emStructObj project
    
    This file contains definitions for C variables and C structs
    It also serves as an initialization file (.ini)
    It should be customized for your C application
    This particular file is used in a production project and can be considered a sample
    
    For a browser, this module should be included before the emStructObj module
    For node, require this module.
###
  
if not (exports? and module? and module.exports)
	exports = window.emDefinitions = {}

# comment out this line to not define shortcut names for functions
# the shortcuts are ...
#    emso  for emStructObj
#    emo2s for emObjToStruct
exports.useShortcuts = yes

# These words are ignored (void isn't needed since all defs containing * are pointers to void).
exports.noiseWords = ['PG_FAR', 'void']

# Type Definitions 
# size param is one of emscription getValue and setValue types ...
# 		i8, i16, i32, i64, float, or double
# format param is hex, dec, str, strw, ptr, or name of struct and is used to control display

exports.typeDefs =
	# all struct member lines containing * are type 'ptr'
	ptr:				{size: 'i32', format: 'dec'}
	short:				{size: 'i16', format: 'hex'}
	pg_short_t:			{size: 'i16', format: 'hex'}
	pg_error:			{size: 'i16', format: 'dec'}
	long:				{size: 'i32', format: 'hex'}
	pg_handle:			{size: 'i32', format: 'hex'}
	master_list_ptr:	{size: 'i32', format: 'hex'}
	mem_debug_proc:		{size: 'i32', format: 'hex'}
	purge_proc:			{size: 'i32', format: 'hex'}
	free_memory_proc: 	{size: 'i32', format: 'hex'}
	memory_ref:			{size: 'i32', format: 'hex'}
	pg_fail_info_ptr: 	{size: 'i32', format: 'hex'}
	pg_error_handler:	{size: 'i32', format: 'hex'}
	
# Struct Defininitions
# Lines that start with "struct" start a struct definition
# Each member must be on it's own line.  Everything past the semicolon is ignored.
# This is not really parsed, just extracted with regexes

exports.structDefs = """

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
