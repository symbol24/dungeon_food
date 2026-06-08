extends Node


# MANAGERS
signal all_managers_ready

# LOOT MANAGER
signal spawn_loot(loot:Array, spawn_pos:Vector2)

# LEVEL SYSTEM
signal level_chunk_ready(chunk:LevelChunk)

# PLAYER SPAWNING
signal spawn_player(pos:Vector2)

# ENEMY SPAWNING
signal spawn_enemies(to_spawn:Dictionary)
