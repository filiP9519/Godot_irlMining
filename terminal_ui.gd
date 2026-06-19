extends CanvasLayer
@onready var container = $TerminalWindow/ColorRect/Panel/CoinVBoxContainer
@onready var balance_label = $TerminalWindow/BalanceLabel
@onready var click_sound = $TerminalWindow/ClickSound
var current_selection = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if GameManager.crypto_list.size() > 0:
		print("Terminál vidí: ", GameManager.crypto_list[0]["name"])
	else:
		print("Terminál nevidí žiadne dáta!")
	for child in container.get_children():
		queue_free()
	for coin in GameManager.crypto_list:
		#make row
		var row = HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 20)
		var name_label = Label.new()
		name_label.text = coin["name"]
		name_label.custom_minimum_size.x = 100 #so text doesnt overlay
		
		var price_label = Label.new()
		price_label.text = "$" + str(coin["price"])
		
		var btn = Button.new()
		btn.text = "Vybrať"
		# Toto prepojí tlačidlo s funkciou a pošle jej dáta o mene
		btn.pressed.connect(_on_crypto_selected.bind(coin))

		
		row.add_child(name_label)
		row.add_child(price_label)
		row.add_child(btn)
		container.add_child(row)
		
		#UI Adjustments
		name_label.custom_minimum_size.x = 150
		price_label.custom_minimum_size.x = 100
		price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		btn.add_theme_color_override("font_hover_color", Color.GREEN)
func _on_button_exit_pressed() -> void:
	click_sound.play()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#zrusenie terminalu
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_selection != null:
		balance_label.text = "Aktualny zostatok: $" + str(snapped(GameManager.balance,0.01)) 
	

func refresh():
	GameManager.http_request.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1")


func _on_crypto_selected(coin_data) -> void:
	click_sound.play()
	current_selection = coin_data
	print("Vybral si menu ", coin_data["name"])
	#GameManager.selected_crypto = coin_data
	
func _on_start_mining_pressed() -> void:
	click_sound.play()
	if current_selection != null:
		GameManager.selected_crypto = current_selection
		print("Ťaženie spustené pre: ", GameManager.selected_crypto["name"])
	else:
		print("Najprv si vyber menu zo zoznamu!")


func _on_stop_mining_pressed() -> void:
	click_sound.play()
	if current_selection != null:
		print("Tazenie bolo zastavene pre: ",GameManager.selected_crypto["name"])
		GameManager.selected_crypto = null
		
	else:
		print("Aktuálne nič neťažíš.")
