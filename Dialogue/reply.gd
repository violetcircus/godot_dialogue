extends Button

var id
signal reply_pressed(id)

func _on_pressed():
	print(str(id))
	emit_signal("reply_pressed", id)
