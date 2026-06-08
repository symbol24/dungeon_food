extends Node


# MANAGERS
signal all_managers_ready

# LOOT MANAGER
signal spawn_loot(loot:Array, spawn_pos:Vector2)

# LEVEL SYSTEM
signal chunk_ready(chunk:Chunk)

# SPAWNING
signal spawn_player(pos:Vector2)
signal spawn_enemies(to_spawn:Dictionary)
signal spawn_npcs(to_sapwn:Dictionary)
