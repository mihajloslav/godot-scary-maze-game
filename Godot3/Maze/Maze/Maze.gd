#---------------------------------------------------------------------------------------------------
extends Control
#---------------------------------------------------------------------------------------------------
enum VISIBLE {PLAY, MENU, LEVEL1, LEVEL2, LEVEL3, PICTURE} 
#---------------------------------------
onready var play : Control = $Play
onready var menu : Control = $Menu
onready var level1: Control = $Level1
onready var level2 : Control = $Level2
onready var level3 : Control = $Level3
onready var picture : Control = $Picture
#---------------------------------------
onready var level1_collision : Node2D = $Level1/Collision
onready var level2_collision : Node2D = $Level2/Collision
onready var level3_collision : Node2D = $Level3/Collision
#---------------------------------------
onready var picture_label_control : Control = $Picture/PictureLabelControl
onready var picture_label_control_position : Vector2 = picture_label_control.rect_position
onready var picture_label_end : Control = $Picture/PictureLabelEnd
#---------------------------------------
onready var picture_sprite : Sprite = $Picture/Sprite
onready var picture_sprite_scale : Vector2 = picture_sprite.scale
onready var picture_sprite_position : Vector2 = picture_sprite.position
#---------------------------------------
onready var timer : Timer = $Timer
onready var buttons : Control = $Picture/Buttons
#---------------------------------------
onready var dot : KinematicBody2D = $Dot
onready var dot_scale : Vector2 = $Dot.scale
#---------------------------------------
var level : int = 0
var label_start : bool = false
#---------------------------------------------------------------------------------------------------
func _ready() -> void:
	_change_visible(level)
	_on_Maze_resized()
#---------------------------------------------------------------------------------------------------
func _input(_event : InputEvent) -> void:
	dot.position = get_viewport().get_mouse_position()
#---------------------------------------------------------------------------------------------------
func _physics_process(_delta : float) -> void:
	if level == 5:
		if label_start:
			picture_label_control.visible = true
			picture_label_control.rect_position = lerp(picture_label_control.rect_position, Vector2(picture_label_control.rect_position.x,picture_label_end.rect_position.y), 0.05)
		if picture_label_control.rect_position.y >= picture_label_end.rect_position.y - 2:
			label_start = false
			picture_label_control.rect_position = Vector2(picture_label_control.rect_position.x,picture_label_end.rect_position.y +2)
			buttons.visible = true
#---------------------------------------------------------------------------------------------------
func _on_LevelArea_body_entered(_body : Node, current_level : int) -> void:
	if level == current_level: _change_visible(1)
#---------------------------------------------------------------------------------------------------
func _on_RedArea_body_entered(_body : Node, current_level : int) -> void:
	if level == current_level:
		level = current_level + 1
		if level == 5: timer.start()
		_change_visible(level)
#---------------------------------------------------------------------------------------------------
func _on_Timer_timeout() -> void: label_start = true
#---------------------------------------------------------------------------------------------------
func _change_visible(current_level : int) -> void:
	level = current_level
	print(Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) if level == 0 or level == 1 or level == 5 else Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN))
	if level != 5:
		buttons.visible = false
		picture_label_control.visible = false
		picture_label_control.rect_position = picture_label_control_position
		label_start = false
	play.visible = level == VISIBLE.PLAY
	menu.visible = level == VISIBLE.MENU
	level1.visible = level == VISIBLE.LEVEL1
	level2.visible = level == VISIBLE.LEVEL2
	level3.visible = level == VISIBLE.LEVEL3
	picture.visible = level == VISIBLE.PICTURE
#---------------------------------------------------------------------------------------------------
func _open_website(site_number : int) -> void:
	match site_number:
		0: print(OS.shell_open("https://github.com/mikikupus/godot-scary-maze-game"))
		1: print(OS.shell_open("https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fgithub.com%2Fmikikupus%2Fgodot-scary-maze-game&amp;src=sdkpreparse"))
		2: print(OS.shell_open("https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fpublish.twitter.com%2F&ref_src=twsrc%5Etfw%7Ctwcamp%5Ebuttonembed%7Ctwterm%5Eshare%7Ctwgr%5E&text=&url=https%3A%2F%2Fgithub.com%2Fmikikupus%2Fgodot-scary-maze-game"))
		3: print("mailto:onlymihajlo@gmail.com")
#---------------------------------------------------------------------------------------------------
func _on_Maze_resized() -> void:
	if level1_collision != null: level1_collision.scale = OS.get_window_size() / Vector2(1280,720)
	if level2_collision != null: level2_collision.scale = OS.get_window_size() / Vector2(1280,720)
	if level3_collision != null: level3_collision.scale = OS.get_window_size() / Vector2(1280,720)
	if dot != null: dot.scale = dot_scale * (OS.get_window_size() / Vector2(1280,720))
	if picture_sprite != null: 
		picture_sprite.scale = picture_sprite_scale * (OS.get_window_size() / Vector2(1280,720))
		picture_sprite.position = picture_sprite_position * (OS.get_window_size() / Vector2(1280,720))
#---------------------------------------------------------------------------------------------------
