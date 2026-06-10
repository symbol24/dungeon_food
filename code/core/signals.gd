extends Node


# MANAGERS
signal all_managers_ready

# LOOT MANAGER
signal spawn_loot(loot:Array, spawn_pos:Vector2)

# LEVEL SYSTEM
signal chunk_ready(chunk:Chunk)
signal chunk_spawning_complete
signal in_new_chunk
signal load_chunk(target:StringName, spawn:StringName)

# SPAWNING
signal spawn_player()
