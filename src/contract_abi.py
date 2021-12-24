abi = """
[
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_petId",
				"type": "uint256"
			}
		],
		"name": "adoptAnimal",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "AdoptAnimalEvent",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "generateAnimalKind",
		"outputs": [
			{
				"internalType": "string",
				"name": "kind",
				"type": "string"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "generateAnimalAge",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAdopters",
		"outputs": [
			{
				"internalType": "address[10]",
				"name": "",
				"type": "address[10]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAnimals",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "kind",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "age",
						"type": "uint256"
					}
				],
				"internalType": "struct Adoption.Animal[10]",
				"name": "",
				"type": "tuple[10]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
"""