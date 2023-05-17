# ik-vehcontrol

You can reach me at [Hi-Dev](https://discord.com/invite/pSJPPctrNx)

# Preview 

https://youtu.be/i61r_mrW_8A

Update : https://youtu.be/OC6_ZNCXtIo

# Explanation

With this resource you can show mod information of an owned car.<br>
Mechanics can send the report to a nearby player for money.
Money will go to management funds of the mechanic.

![image](https://github.com/i-kulgu/ik-vehcontrol/assets/29943243/e49e9aa7-385a-4d07-a935-a654709f1f95)

# Installation

Copy the next image to your inventory\html\images folder

![car-report](https://github.com/i-kulgu/ik-vehreport/assets/29943243/cfd91cd9-6016-4802-b213-d63afb5f0d30)

Add the next item in your qb-core\shared\items.lua file:


```lua
	["car-report"] 			 = {["name"] = "car-report", 			["label"] = "Car Report", 	   			["weight"] = 50, 		["type"] = "item", 		["image"] = "car-report.png", 			["unique"] = false,   	["useable"] = true,   	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Vehicle modification report..", },

```

Add the next lines in your inventory\html\js\app.js right after labkey if you want to show the item information in your inventory :

```js
} else if (itemData.name == "car-report") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p><strong>Vehicle: </strong>" + itemData.info.vehname + "</p><p><strong>Plate: </strong>" + itemData.info.plate + "</p>");
```

![image](https://github.com/i-kulgu/ik-vehreport/assets/29943243/abeb46a5-e7d8-4ef0-b89c-42f7bffede72)
