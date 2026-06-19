extends Node

@onready var http_request = $HTTPRequest 
var crypto_list = []
var selected_crypto = null
var balance : float = 0.0
# Zoznam kryptomien
var offline_crypto_list = [
	{"name": "Bitcoin", "price": 60000.0},
	{"name": "Ethereum", "price": 3000.0},
	{"name": "Solana", "price": 150.0},
	{"name": "Dogecoin", "price": 0.15},
	{"name": "Cardano", "price": 0.40},
	{"name": "Ripple", "price": 0.50},
	{"name": "Polkadot", "price": 7.0},
	{"name": "Litecoin", "price": 80.0},
	{"name": "Chainlink", "price": 15.0},
	{"name": "Avalanche", "price": 35.0}
]

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	var error = http_request.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1")
	
	if error != OK:
		crypto_list = offline_crypto_list
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json=JSON.parse_string(body.get_string_from_utf8())
		if json:
			update_prices(json)
	else:
		print("API Error, using offline data")
		crypto_list = offline_crypto_list
		
func update_prices(data):
	crypto_list = []
	for coin in data:	
		var coin_info = {
			"name" : coin["name"],
			"price" : coin["current_price"],
			"difficulty" : 1.0 + (coin["current_price"] / 10000.0),
			"block_reward" : coin["current_price"] * 0.05
		}
		crypto_list.append(coin_info)
	print("Mám načítaných ", crypto_list.size(), " mien.")
	print("Data from Excchange loaded!!!GOOD")

func _process(delta: float) -> void:
	if selected_crypto != null:
		var mining_speed = 0.0001 / selected_crypto["difficulty"]
		balance += (selected_crypto["price"] * mining_speed) * delta
	if randf() <0.005 * delta:
		var bonus = selected_crypto["block_reward"]
		balance += bonus
		print("Blok najdeny! Bonus: $",bonus)
